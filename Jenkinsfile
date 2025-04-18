pipeline {
    agent any

    environment {
        IMAGE_NAME = 'library-management-backend'
        CONTAINER_NAME = 'library-backend'
        PORT = '8080'
        PROJECT_PATH = 'Library Management/Library Management.csproj'
        DLL_NAME = 'Library Management.dll'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/DevExpert250802/Library-Management-Backend-.git'
            }
        }

        stage('Restore Dependencies') {
            steps {
                bat "dotnet restore \"%PROJECT_PATH%\""
            }
        }

        stage('Build') {
            steps {
                bat "dotnet build \"%PROJECT_PATH%\" --configuration Release"
            }
        }

        stage('Publish') {
            steps {
                bat "dotnet publish \"%PROJECT_PATH%\" -c Release -o out"
            }
        }

        stage('Docker Build') {
            steps {
                bat "docker build -t %IMAGE_NAME%:latest ."
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                bat """
                    docker stop %CONTAINER_NAME% || echo Container not running
                    docker rm %CONTAINER_NAME% || echo Container not found
                """
            }
        }

        stage('Run Docker Container') {
            steps {
                bat "docker run -d -p %PORT%:80 --name %CONTAINER_NAME% %IMAGE_NAME%:latest"
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Build or Deployment Failed!'
        }
    }
}
