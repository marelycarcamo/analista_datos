# Instalación de Apache Airflow en Windows

## ⚠️ PROBLEMA IDENTIFICADO

El código original del notebook **NO funciona en Windows** porque:

- Apache Airflow está diseñado para sistemas POSIX (Linux/macOS)
- Error común: `AttributeError: module 'os' has no attribute 'register_at_fork'`
- Windows no tiene la función `os.register_at_fork()` que Airflow necesita

## ✅ REQUISITOS DEL CURSO

- ✓ Python 3.7+
- ✓ Apache Airflow instalado
- ✓ Conocimiento básico de grafos y workflows

## 🐳 SOLUCIÓN: Usar Docker (RECOMENDADO)

Docker permite ejecutar Airflow en un contenedor Linux dentro de Windows, cumpliendo todos los requisitos.

### Paso 1: Instalar Docker Desktop

1. Descargar desde: https://www.docker.com/products/docker-desktop
2. Instalar y reiniciar el sistema si es necesario
3. Abrir Docker Desktop y esperar a que inicie

### Paso 2: Crear estructura del proyecto

Abrir **PowerShell** o **CMD** y ejecutar:

```powershell
# Crear carpeta del proyecto
mkdir airflow-docker
cd airflow-docker

# Descargar archivo de configuración oficial
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'

# Crear carpetas necesarias
mkdir dags
mkdir logs
mkdir plugins
mkdir config

# Configurar variable de entorno
echo AIRFLOW_UID=50000 > .env
```

### Paso 3: Inicializar Airflow

```powershell
# Inicializar la base de datos
docker-compose up airflow-init

# Esperar a que termine (verás "airflow-init exited with code 0")
```

### Paso 4: Iniciar Airflow

```powershell
# Iniciar todos los servicios en segundo plano
docker-compose up -d

# Ver que todo esté corriendo
docker-compose ps
```

### Paso 5: Acceder a la interfaz web

1. Abrir navegador
2. Ir a: http://localhost:8080
3. Iniciar sesión:
   - **Usuario:** `airflow`
   - **Contraseña:** `airflow`

## 📁 ESTRUCTURA DE CARPETAS

```
airflow-docker/
├── dags/                    ← Aquí van tus DAGs (.py)
├── logs/                    ← Logs de ejecución
├── plugins/                 ← Plugins personalizados
├── config/                  ← Configuraciones adicionales
├── docker-compose.yaml      ← Configuración de Docker
└── .env                     ← Variables de entorno
```

## 📝 CREAR TU PRIMER DAG

1. Crear archivo: `dags/mi_primer_dag.py`
2. Copiar el código del notebook (sección 2)
3. Guardar el archivo
4. Esperar ~30 segundos (Airflow escanea automáticamente)
5. Refrescar la interfaz web

## 🔧 COMANDOS ÚTILES

### Ver servicios corriendo

```powershell
docker-compose ps
```

### Ver logs en tiempo real

```powershell
docker-compose logs -f
```

### Detener Airflow

```powershell
docker-compose down
```

### Reiniciar Airflow

```powershell
docker-compose restart
```

### Ejecutar comandos de Airflow

```powershell
# Listar DAGs
docker-compose exec airflow-worker airflow dags list

# Listar tareas de un DAG
docker-compose exec airflow-worker airflow tasks list saludo_diario

# Ejecutar un DAG manualmente
docker-compose exec airflow-worker airflow dags trigger saludo_diario

# Ver estado de ejecuciones
docker-compose exec airflow-worker airflow dags list-runs -d saludo_diario
```

### Acceder al contenedor

```powershell
# Abrir shell dentro del contenedor
docker-compose exec airflow-worker bash

# Dentro del contenedor puedes usar comandos de Airflow directamente:
airflow dags list
airflow tasks list saludo_diario
exit  # Para salir
```

## 🐛 TROUBLESHOOTING

### Puerto 8080 ya está en uso

```powershell
# Editar docker-compose.yaml y cambiar el puerto:
# En la sección webserver, cambiar:
# ports:
#   - "8081:8080"  # Usar 8081 en lugar de 8080
```

### DAG no aparece en la interfaz

1. Verificar que el archivo esté en `dags/`
2. Verificar errores de sintaxis en el archivo
3. Ver logs: `docker-compose logs airflow-scheduler`
4. Esperar 30 segundos (tiempo de escaneo)

### Servicios no inician

```powershell
# Ver logs detallados
docker-compose logs

# Reiniciar todo
docker-compose down
docker-compose up -d
```

### Limpiar todo y empezar de nuevo

```powershell
# ADVERTENCIA: Esto borra todos los datos
docker-compose down --volumes --remove-orphans
docker-compose up airflow-init
docker-compose up -d
```

## 🎯 VERIFICAR QUE TODO FUNCIONA

1. ✅ Docker Desktop está corriendo
2. ✅ `docker-compose ps` muestra todos los servicios "healthy"
3. ✅ http://localhost:8080 carga la interfaz web
4. ✅ Puedes iniciar sesión con airflow/airflow
5. ✅ Ves la lista de DAGs (puede estar vacía al inicio)

## 📚 ALTERNATIVA: WSL2 (Más avanzado)

Si prefieres no usar Docker, puedes instalar WSL2:

1. Instalar WSL2:

   ```powershell
   wsl --install
   ```

2. Reiniciar el sistema

3. Abrir Ubuntu (WSL) y ejecutar:

   ```bash
   # Actualizar sistema
   sudo apt update && sudo apt upgrade -y

   # Instalar Python y dependencias
   sudo apt install python3 python3-pip python3-venv -y

   # Crear entorno virtual
   python3 -m venv ~/airflow_env
   source ~/airflow_env/bin/activate

   # Instalar Airflow
   pip install apache-airflow

   # Inicializar
   airflow db init

   # Crear usuario
   airflow users create \
       --username admin \
       --firstname Admin \
       --lastname User \
       --role Admin \
       --email admin@example.com \
       --password admin

   # Iniciar servicios (en terminales separadas)
   airflow scheduler  # Terminal 1
   airflow webserver  # Terminal 2
   ```

## 📖 RECURSOS ADICIONALES

- Documentación oficial: https://airflow.apache.org/docs/
- Docker Compose: https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/
- Tutoriales: https://airflow.apache.org/docs/apache-airflow/stable/tutorial/

## ✨ RESUMEN

Para cumplir con los requisitos del curso en Windows:

1. **Instala Docker Desktop** (5 minutos)
2. **Sigue los pasos 2-4** de este documento (10 minutos)
3. **Accede a http://localhost:8080** (listo!)

Esto te da:

- ✅ Python 3.8+ (dentro del contenedor)
- ✅ Apache Airflow completamente funcional
- ✅ Interfaz web para crear y monitorear workflows
- ✅ Entorno idéntico al de producción
