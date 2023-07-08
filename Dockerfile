FROM openjdk:8

# Define working directory.
ENV WORKING_DIR /opt/hdfcergo
# Install curl for use with Kubernetes readiness probe.
RUN mkdir -p "$WORKING_DIR" \
    && apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR $WORKING_DIR

# Copy the .jar file into the Docker image
COPY ./target/*.jar $WORKING_DIR/jb-hello-world-maven-0.2.0-shaded.jar

CMD ["java", "-jar", "jb-hello-world-maven-0.2.0-shaded.jar"]
