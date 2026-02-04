# Requisitos para plataforma de streaming
requisitos_streaming = {
    "datos_transaccionales": {
        "suscripciones": "ACID crítico, joins complejos",
        "pagos": "Consistencia fuerte requerida",
        "usuarios": "Datos maestros normalizados",
    },
    "datos_analiticos": {
        "eventos_reproduccion": "Volumen masivo, time-series",
        "recomendaciones": "Relaciones complejas entre usuarios/contenido",
        "analytics_contenido": "Métricas agregadas variables",
    },
    "requisitos_performance": {
        "latencia_vista": "< 100ms para recomendaciones",
        "throughput_eventos": "1M eventos/segundo",
        "almacenamiento": "100PB datos históricos",
    },
}

print("REQUISITOS PLATAFORMA DE STREAMING")
print("=" * 35)

for categoria, detalles in requisitos_streaming.items():
    print(f"\n{categoria.upper().replace('_', ' ')}:")
    if isinstance(detalles, dict):
        for subcat, desc in detalles.items():
            print(f"  {subcat.title()}: {desc}")
    else:
        print(f"  {detalles}")
# Selección de tecnologías por caso de uso:

# Arquitectura híbrida seleccionada
arquitectura_hibrida = {
    "postgresql": {
        "rol": "Base de datos transaccional principal",
        "casos_uso": ["Suscripciones", "Pagos", "Perfiles de usuario"],
        "justificacion": "ACID para finanzas, joins complejos para billing",
        "escalabilidad": "Vertical (hasta ~10TB)",
        "limitaciones": "Escalabilidad horizontal limitada",
    },
    "cassandra": {
        "rol": "Base de datos de eventos y analytics",
        "casos_uso": [
            "Eventos de reproducción",
            "Métricas de usuario",
            "Logs",
        ],
        "justificacion": (
            "Escalabilidad horizontal masiva, " "writes de alto throughput"
        ),
        "escalabilidad": "Horizontal ilimitada",
        "limitaciones": "Queries complejas limitadas",
    },
    "neo4j": {
        "rol": "Motor de recomendaciones y relaciones",
        "casos_uso": [
            "Sistema de recomendaciones",
            "Análisis de afinidad",
            "Detección de fraude",
        ],
        "justificacion": ("Queries de relaciones complejas, algoritmos de grafos"),
        "escalabilidad": "Hasta ~100B nodos/relaciones",
        "limitaciones": "No optimizado para agregaciones masivas",
    },
    "redis": {
        "rol": "Caché y sesiones de alto performance",
        "casos_uso": [
            "Sesiones de usuario",
            "Caché de recomendaciones",
            "Leaderboards",
        ],
        "justificacion": "Latencia < 1ms, estructuras de datos ricas",
        "escalabilidad": "Cluster horizontal",
        "limitaciones": "Datos volátiles (reinicio borra datos)",
    },
    "elasticsearch": {
        "rol": "Búsqueda y analytics de contenido",
        "casos_uso": [
            "Búsqueda de contenido",
            "Analytics de catálogo",
            "Logs estructurados",
        ],
        "justificacion": "Búsqueda full-text, agregaciones complejas, APIs REST",
        "escalabilidad": "Horizontal con sharding",
        "limitaciones": "No transaccional, eventual consistency",
    },
}

print("ARQUITECTURA HÍBRIDA SELECCIONADA")
print("=" * 40)

for tecnologia, detalles in arquitectura_hibrida.items():
    print(f"\n{tecnologia.upper()}:")
    print(f" Rol: {detalles['rol']}")
    print(f" Casos de uso: {', '.join(detalles['casos_uso'])}")
    print(f" Escalabilidad: {detalles['escalabilidad']}")
