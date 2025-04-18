pipeline {
    agent any

    environment {
        IMAGE_NAME = 'library-management-backend'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/DevExpert250802/Library-Management-Backend-.git'
            }
        }

        stage('Restore Dependencies') {
            steps {
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release'
            }
        }

        stage('Publish') {
            steps {
                sh 'dotnet publish -c Release -o out'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Docker Run') {
            steps {
                sh 'docker run -d -p 8080:80 --name library-backend ${IMAGE_NAME}:latest'
            }
        }
    }
}
