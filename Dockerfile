# Utiliser une image de base avec Java (openjdk)
FROM openjdk:21 as build

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier pom.xml (ou build.gradle si tu utilises Gradle)
COPY pom.xml .

# Copier le Maven Wrapper (mvnw et mvnw.cmd) et donner les bonnes permissions
COPY mvnw .
COPY .mvn .mvn

RUN chmod +x mvnw  # Assurez-vous que mvnw est exécutable

# Télécharger les dépendances Maven
RUN ./mvnw dependency:go-offline

# Copier le code source de l'application
COPY src /app/src

# Compiler le projet (ceci génère le fichier .jar)
RUN ./mvnw clean package -DskipTests

# Utiliser l'image de base Java pour l'exécution
FROM openjdk:21

# Définir le répertoire de travail pour l'exécution
WORKDIR /app

# Copier le fichier .jar compilé depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Exposer le port utilisé par Spring Boot (par défaut 8080)
EXPOSE 9090

# Créez un utilisateur non-root
RUN useradd -m appuser

# Utilisez cet utilisateur pour exécuter l'application
USER appuser

# Lancer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
