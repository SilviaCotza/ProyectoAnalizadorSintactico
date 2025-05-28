# Multi-stage build para una imagen final ligera

# --- ETAPA 1: BUILD (Compilación del Proyecto) ---
# Usamos una imagen JDK completa para compilar la aplicación
FROM eclipse-temurin:22-jdk-jammy AS builder

# ************************************************
# *** AÑADIR ESTAS LÍNEAS PARA INSTALAR MAVEN ***
# ************************************************
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*
# ************************************************

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el pom.xml (ya que no usaremos .mvn)
COPY pom.xml .

# Descarga las dependencias de Maven (sin construir el JAR aún)
RUN mvn dependency:go-offline

# Copia el código fuente del proyecto
COPY src src

# Compila y empaqueta la aplicación Spring Boot en un JAR ejecutable
RUN mvn clean package -DskipTests

# --- ETAPA 2: RUNTIME (Ejecución de la Aplicación) ---
# Usamos una imagen JRE más ligera para la ejecución final
FROM eclipse-temurin:22-jre-jammy

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el JAR ejecutable desde la etapa de construcción anterior
# La ruta del JAR en la etapa 'builder' es típicamente target/<artifactId>-<version>.jar
# Reemplaza 'ProyectoAnalizadorSintactico-1.0-SNAPSHOT.jar' con el nombre real de tu JAR
COPY --from=builder /app/target/ProyectoAnalizadorSintactico-1.0-SNAPSHOT.jar app.jar

# Expone el puerto por defecto de Spring Boot (Render lo remapeará)
EXPOSE 8080

# Comando para ejecutar la aplicación Spring Boot
ENTRYPOINT java -jar app.jar --server.port=$PORT

# Si tu app no se adapta automáticamente al puerto de la variable de entorno PORT, usa:
# ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=$PORT"]