# ---------- Stage 1: Build WAR using Maven ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy project files
COPY . .

# Build the WAR file
RUN mvn clean package


# ---------- Stage 2: Run on Tomcat ----------
FROM tomcat:9-jdk17

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=build /app/target/ExaminationSystem.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080