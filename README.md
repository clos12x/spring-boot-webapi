# 🚀 Proyecto Final CI/CD  
## Implementación de Pipeline CI/CD con GitHub Actions y Despliegue Blue-Green para Aplicación Spring Boot

---

## 👥 Integrantes

- José Luis Tagua Roca
- Ignacio Siacara Alexander Junior
- Marvin Chavez Claros 

---

# 📌 Descripción del Proyecto

Este proyecto implementa un flujo completo de Integración Continua y Entrega Continua (CI/CD) para una aplicación desarrollada con Spring Boot.

La solución utiliza GitHub Actions para automatizar la compilación, ejecución de pruebas, análisis de cobertura, generación del artefacto JAR y publicación de versiones mediante GitHub Release.

Además, se implementa una estrategia de despliegue **Blue-Green Deployment**, permitiendo realizar cambios de versión mediante validación previa, cambio controlado de tráfico y recuperación mediante rollback.

---

# 🏗️ Arquitectura del Sistema

```
                    GitHub Repository
                           |
                           |
                  GitHub Actions CI/CD
                           |
        --------------------------------------
        |                 |                  |
      Build            Tests              JaCoCo
        |
        |
     JAR Artifact
        |
        |
   GitHub Release
        |
        |
 Ubuntu Application Server
        |
        |
  ---------------------------
  |                         |
 BLUE                     GREEN
8081                      8082
  |                         |
  ---------------------------
             |
             |
           Nginx
       Load Balancer
             |
             |
        Usuario Final
```

---

# 🛠️ Tecnologías Utilizadas

| Tecnología | Uso |
|---|---|
| Java | Lenguaje de desarrollo |
| Spring Boot | Framework de aplicación |
| Maven | Construcción y gestión del proyecto |
| GitHub | Control de versiones |
| GitHub Actions | Automatización CI/CD |
| JUnit | Pruebas automatizadas |
| JaCoCo | Análisis de cobertura |
| Bash | Scripts de despliegue |
| Ubuntu Linux | Servidor de aplicación |
| Nginx | Balanceador de tráfico |

---

# 🔄 Pipeline CI/CD

El flujo automatizado implementado contiene las siguientes etapas:

1. Descarga del código desde GitHub.
2. Configuración del entorno Java.
3. Compilación mediante Maven.
4. Ejecución de pruebas automatizadas.
5. Generación del reporte JaCoCo.
6. Creación del archivo JAR.
7. Publicación mediante GitHub Release.
8. Preparación del despliegue en servidor Linux.

---

# 🌿 Control de Versiones

El proyecto utiliza Git para administrar cambios mediante ramas.

Flujo utilizado:

```
feature/release
        |
        |
     Pull Request
        |
        |
       main
```

La integración de cambios se realiza mediante Pull Request antes de incorporar nuevas funcionalidades a la rama principal.

---

# 📦 Artefacto Generado

El proceso CI/CD genera el siguiente artefacto:

```
webapi-0.0.1-SNAPSHOT.jar
```

Este archivo corresponde a la aplicación empaquetada utilizada para el despliegue.

---

# 🏷️ Versionamiento

Las versiones del proyecto son administradas mediante GitHub Release.

Versión publicada:

```
v1.0.0
```

La versión contiene el artefacto generado durante el pipeline CI/CD.

---

# 🔵🟢 Estrategia Blue-Green Deployment

La aplicación cuenta con dos ambientes independientes:

## 🔵 BLUE

Ambiente estable de la aplicación.

```
Puerto: 8081
```

## 🟢 GREEN

Ambiente destinado para la nueva versión.

```
Puerto: 8082
```

Flujo de actualización:

```
BLUE activo

      ↓

Despliegue GREEN

      ↓

Health Check

      ↓

Validación

      ↓

Switch Traffic mediante Nginx

      ↓

GREEN activo
```

---

# ❤️ Health Check

La validación del estado de las instancias se realiza mediante:

```
/api/instance
```

Este endpoint permite identificar qué instancia responde y verificar que el servicio se encuentra disponible.

Ejemplo:

```json
{
 "instance": "GREEN",
 "port": "8082"
}
```

---

# 🌐 Balanceador Nginx

Nginx funciona como punto de entrada del sistema y administra la distribución del tráfico hacia las instancias Spring Boot.

Configuración:

```
BLUE  → 192.168.1.171:8081

GREEN → 192.168.1.171:8082
```

---

# 🔄 Switch Traffic

El cambio de tráfico se realiza mediante Nginx permitiendo cambiar entre versiones desplegadas.

Proceso:

```
BLUE activo

      ↓

Validación GREEN

      ↓

Cambio de tráfico

      ↓

GREEN recibe solicitudes
```

---

# 🔙 Rollback

Ante una falla en la nueva versión GREEN, se realiza la recuperación hacia la versión estable BLUE.

Proceso:

```
GREEN falla

      ↓

Rollback

      ↓

BLUE vuelve a recibir tráfico

      ↓

Servicio restaurado
```

---

# 📁 Estructura del Proyecto

```
spring-boot-webapi

├── src/
├── pom.xml
├── .github/
│    └── workflows/
├── nginx/
├── scripts/
├── README.md
└── CHANGELOG.md
```

---

# ✅ Validaciones Realizadas

Se verificó:

✔ Funcionamiento de las instancias BLUE y GREEN.  
✔ Ejecución del pipeline CI/CD.  
✔ Generación del artefacto JAR.  
✔ Disponibilidad mediante endpoint `/api/instance`.  
✔ Funcionamiento del balanceador Nginx.  
✔ Cambio de tráfico entre versiones.  
✔ Procedimiento de rollback.

---

# 📄 Documentación del Proyecto

Este README contiene la descripción técnica del proyecto, arquitectura implementada, herramientas utilizadas, proceso CI/CD y estrategia de despliegue Blue-Green.
