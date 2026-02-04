# Implementación de patrón CQRS:
# Implementación CQRS para plataforma de streaming

import json


class PostgreSQL:
    def user_exists(self, user_id):
        return True

    def plan_available(self, plan_id):
        return True

    def create_subscription(self, data):
        # Return data with simulated ID and
        # timestamp
        return {**data, "id": "sub_123", "created_at": "2024-01-01T00:00:00Z"}


class Cassandra:
    def get_user_recommendations(self, user_id):
        return [{"id": 1, "title": "Recommended Movie"}]

    def update_user_profile(self, user_id, data):
        pass


class Redis:
    def get(self, key):
        return None

    def setex(self, key, seconds, value):
        pass

    def delete(self, key):
        pass


class Elasticsearch:
    pass


class StreamingCQRS:
    def __init__(self):
        self.command_db = PostgreSQL()  # Writes normalizados
        self.query_db = Cassandra()  # Reads optimizados
        self.cache = Redis()
        self.search = Elasticsearch()

    # Servicios auxiliares simulados
    def process_payment(self, payment_info):
        return {"success": True, "id": "pay_999"}

    def publish_event(self, event_name, data):
        print(f"Event published: {event_name}")
        if event_name == "SubscriptionCreated":
            self.handle_subscription_created(data)

    # Command side: Validación estricta, consistencia
    def create_subscription(self, user_id, plan_id, payment_info):
        """Crear suscripción - lado comando"""
        # Validar usuario existe
        if not self.command_db.user_exists(user_id):
            raise ValueError("Usuario no existe")

        # Validar plan disponible
        if not self.command_db.plan_available(plan_id):
            raise ValueError("Plan no disponible")

        # Procesar pago (simulado)
        payment_result = self.process_payment(payment_info)

        if payment_result["success"]:
            # Crear suscripción en BD transaccional
            subscription = self.command_db.create_subscription(
                {
                    "user_id": user_id,
                    "plan_id": plan_id,
                    "payment_id": payment_result["id"],
                }
            )

            # Publicar evento para actualizar read models
            self.publish_event("SubscriptionCreated", subscription)

            return subscription
        else:
            raise ValueError("Pago fallido")

    # Query side: Optimizado para lecturas rápidas
    def get_user_recommendations(self, user_id):
        """Obtener recomendaciones - lado query"""
        # Primero intentar caché
        cache_key = f"recommendations:{user_id}"
        cached = self.cache.get(cache_key)

        if cached:
            return json.loads(cached)

        # Si no está en caché, calcular desde query model
        recommendations = self.query_db.get_user_recommendations(user_id)

        # Almacenar en caché para futuras consultas. 1 hora
        self.cache.setex(cache_key, 3600, json.dumps(recommendations))
        return recommendations

    # Event handling: Mantener consistencia eventual
    def handle_subscription_created(self, event):
        """Actualizar read models cuando se crea suscripción"""
        # Actualizar perfil de usuario en query model
        self.query_db.update_user_profile(
            event["user_id"],
            {
                "subscription_active": True,
                "plan_id": event["plan_id"],
                "subscription_date": event["created_at"],
            },
        )

        # Invalidar caché relacionado
        self.cache.delete(f"user_profile:{event['user_id']}")
        self.cache.delete(f"recommendations:{event['user_id']}")


# Uso del sistema
cqrs = StreamingCQRS()

# Crear suscripción (command)

subscription = cqrs.create_subscription(user_id=123, plan_id=1, payment_info={})

# Obtener recomendaciones (query)
recommendations = cqrs.get_user_recommendations(user_id=123)

print(subscription)
print(recommendations)
