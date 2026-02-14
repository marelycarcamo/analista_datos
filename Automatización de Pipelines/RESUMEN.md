# RESUMEN: Instalación de Apache Airflow en Windows

## 🎯 PROBLEMA IDENTIFICADO

El código original del notebook **NO funciona en Windows** porque:

- Error: `AttributeError: module 'os' has no attribute 'register_at_fork'`
- Apache Airflow requiere funciones POSIX que no existen en Windows

## ✅ REQUISITOS DEL CURSO (CUMPLIDOS)

- ✓ Python 3.7+ (Docker usa Python 3.8+)
- ✓ Apache Airflow instalado (vía Docker)
- ✓ Conocimiento básico de grafos y workflows

## 🚀 SOLUCIÓN RÁPIDA (3 OPCIONES)

### OPCIÓN 1: Script Automático (MÁS FÁCIL) ⭐

1. Instalar Docker Desktop: https://www.docker.com/products/docker-desktop
2. Abrir PowerShell como Administrador
3. Navegar a la carpeta del proyecto:
   ```powershell
   cd "C:\Users\marely\OneDrive\Documentos\TalentOps\actividades\analisis_datos_env\analista_datos\Automatización de Pipelines"
   ```
4. Ejecutar el script:
   ```powershell
   .\setup_airflow.ps1
   ```
5. Acceder a: http://localhost:8080 (usuario: airflow, contraseña: airflow)

### OPCIÓN 2: Instalación Manual con Docker

Ver archivo: `INSTRUCCIONES_INSTALACION.md`

### OPCIÓN 3: WSL2 (Más avanzado)

Ver sección WSL2 en: `INSTRUCCIONES_INSTALACION.md`

## 📁 ARCHIVOS CREADOS

1. **INSTRUCCIONES_INSTALACION.md** - Guía completa paso a paso
2. **setup_airflow.ps1** - Script de instalación automática
3. **mi_primer_dag.py** - Código del DAG listo para usar
4. **RESUMEN.md** - Este archivo

## 📝 PRÓXIMOS PASOS

1. **Instalar Docker Desktop** (si no lo tienes)
2. **Ejecutar setup_airflow.ps1** (opción más fácil)
3. **Copiar mi_primer_dag.py** a la carpeta `airflow-docker/dags/`
4. **Acceder a http://localhost:8080** y ver tu DAG

## 🎓 PARA EL CURSO

Con esta instalación cumples todos los requisitos:

✅ **Python 3.7+**: Docker incluye Python 3.8+
✅ **Apache Airflow instalado**: Completamente funcional
✅ **Interfaz web**: Para crear y monitorear workflows
✅ **Entorno profesional**: Idéntico al usado en producción

## 🔧 COMANDOS BÁSICOS

Una vez instalado, usa estos comandos en PowerShell:

```powershell
# Ver servicios corriendo
docker-compose ps

# Ver logs
docker-compose logs -f

# Detener Airflow
docker-compose down

# Iniciar Airflow
docker-compose up -d

# Listar DAGs
docker-compose exec airflow-worker airflow dags list

# Ejecutar un DAG
docker-compose exec airflow-worker airflow dags trigger saludo_diario
```

## 📞 AYUDA

Si tienes problemas:

1. Revisa `INSTRUCCIONES_INSTALACION.md` (sección Troubleshooting)
2. Verifica que Docker Desktop esté corriendo
3. Ejecuta: `docker-compose logs` para ver errores

## 🎉 LISTO PARA EMPEZAR

Una vez que veas la interfaz web en http://localhost:8080, estás listo para:

- Crear DAGs
- Ejecutar workflows
- Monitorear tareas
- Aprender Apache Airflow

¡Éxito con el curso! 🚀
