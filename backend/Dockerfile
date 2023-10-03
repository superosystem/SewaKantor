# Use the official Alpine-based Golang image as the base image
FROM golang:alpine

# Set the working directory inside the container to /app
WORKDIR /app

# Copy all files from the current directory to /app in the container
COPY . .

# Download the Go modules
RUN go mod download

# Build the Go application and name the binary as 'dist'
RUN go build -o engine src/*.go

# Expose port 3000 for the application to listen on
EXPOSE 8080

# Set the default command to run the application when the container starts
ENTRYPOINT [ "./engine" ]
