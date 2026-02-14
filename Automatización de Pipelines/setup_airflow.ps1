# Script de instalación rápida de Apache Airflow con Docker
# Ejecutar en PowerShell: .\setup_airflow.ps1

Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  INSTALACIÓN DE APACHE AIRFLOW EN WINDOWS CON DOCKER" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Verificar si Docker está instalado
Write-Host "🔍 Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker no está instalado" -ForegroundColor Red
    Write-Host "Por favor, instala Docker Desktop desde:" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop" -ForegroundColor Cyan
    exit 1
}

# Verificar si Docker está corriendo
Write-Host "🔍 Verificando que Docker esté corriendo..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✅ Docker está corriendo" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker no está corriendo" -ForegroundColor Red
    Write-Host "Por favor, inicia Docker Desktop y vuelve a ejecutar este script" -ForegroundColor Yellow
    exit 1
}

# Crear carpeta del proyecto
Write-Host ""
Write-Host "📁 Creando estructura de carpetas..." -ForegroundColor Yellow
$projectPath = "airflow-docker"

if (Test-Path $projectPath) {
    Write-Host "⚠️  La carpeta $projectPath ya existe" -ForegroundColor Yellow
    $response = Read-Host "¿Deseas continuar? (s/n)"
    if ($response -ne "s") {
        Write-Host "Instalación cancelada" -ForegroundColor Red
        exit 0
    }
} else {
    New-Item -ItemType Directory -Path $projectPath | Out-Null
    Write-Host "✅ Carpeta $projectPath creada" -ForegroundColor Green
}

Set-Location $projectPath

# Crear subcarpetas
$folders = @("dags", "logs", "plugins", "config")
foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "✅ Carpeta $folder creada" -ForegroundColor Green
    }
}

# Descargar docker-compose.yaml
Write-Host ""
Write-Host "📥 Descargando configuración de Airflow..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yaml") {
    Write-Host "⚠️  docker-compose.yaml ya existe, omitiendo descarga" -ForegroundColor Yellow
} else {
    try {
        Invoke-WebRequest -Uri "https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml" -OutFile "docker-compose.yaml"
        Write-Host "✅ docker-compose.yaml descargado" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error al descargar docker-compose.yaml" -ForegroundColor Red
        Write-Host "Por favor, descárgalo manualmente desde:" -ForegroundColor Yellow
        Write-Host "https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml" -ForegroundColor Cyan
        exit 1
    }
}

# Crear archivo .env
Write-Host ""
Write-Host "⚙️  Configurando variables de entorno..." -ForegroundColor Yellow
"AIRFLOW_UID=50000" | Out-File -FilePath ".env" -Encoding ASCII
Write-Host "✅ Archivo .env creado" -ForegroundColor Green

# Inicializar Airflow
Write-Host ""
Write-Host "🚀 Inicializando Airflow (esto puede tardar varios minutos)..." -ForegroundColor Yellow
Write-Host "Por favor, espera..." -ForegroundColor Cyan
try {
    docker-compose up airflow-init
    Write-Host "✅ Airflow inicializado correctamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al inicializar Airflow" -ForegroundColor Red
    Write-Host "Revisa los logs arriba para más detalles" -ForegroundColor Yellow
    exit 1
}

# Iniciar servicios
Write-Host ""
Write-Host "🚀 Iniciando servicios de Airflow..." -ForegroundColor Yellow
try {
    docker-compose up -d
    Write-Host "✅ Servicios iniciados correctamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al iniciar servicios" -ForegroundColor Red
    exit 1
}

# Esperar a que los servicios estén listos
Write-Host ""
Write-Host "⏳ Esperando a que los servicios estén listos (30 segundos)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verificar estado de los servicios
Write-Host ""
Write-Host "📊 Estado de los servicios:" -ForegroundColor Yellow
docker-compose ps

# Mostrar instrucciones finales
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ INSTALACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Accede a la interfaz web de Airflow:" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:8080" -ForegroundColor Cyan
Write-Host "   Usuario: airflow" -ForegroundColor Cyan
Write-Host "   Contraseña: airflow" -ForegroundColor Cyan
Write-Host ""
Write-Host "📁 Coloca tus DAGs en la carpeta:" -ForegroundColor Yellow
Write-Host "   $PWD\dags" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔧 Comandos útiles:" -ForegroundColor Yellow
Write-Host "   Ver logs:        docker-compose logs -f" -ForegroundColor Cyan
Write-Host "   Detener:         docker-compose down" -ForegroundColor Cyan
Write-Host "   Reiniciar:       docker-compose restart" -ForegroundColor Cyan
Write-Host "   Ver servicios:   docker-compose ps" -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
