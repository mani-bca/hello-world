# Use a base image with JDK and Maven installed
FROM maven:3.8.4-openjdk-11-slim AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the Maven project files
COPY pom.xml .

# Download dependencies specified in pom.xml
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application
RUN mvn package

# Use a lightweight Java runtime image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled application JAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.jar ./app.jar

# Command to run the application
CMD ["java", "-jar", "app.jar"]