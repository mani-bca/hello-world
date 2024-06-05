pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Git branch to checkout')
        string(name: 'REPO_URL', defaultValue: 'https://github.com/example/my-application.git', description: 'Git repository URL')
        string(name: 'DOCKER_IMAGE', defaultValue: '', description: 'Docker Image')
        string(name: 'TAG', defaultValue: 'latest', description: 'Docker tag')
    }
    environment {
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
        PATH = "/usr/local/bin:$PATH"
        SONAR_TOKEN = credentials('sonar-token-id')
        ORGANIZATION = "sonarqube-organization"
        PROJECT_NAME = "sonarqube-projectname"
    }
    tools {
            maven 'Maven'
            gradle 'Gradle'
    }

    stages {
         stage('SCM Checkout') {
            steps {
                git branch: 'params.BRANCH', url: 'params.REPO_URL'
            }
        }
        stage('Sonarcloud Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarCloud') {
                        sh "${scannerHome}/bin/sonar-scanner  -Dsonar.projectKey=$PROJECT_NAME  -Dsonar.organization=$ORGANIZATION  -Dsonar.host.url=https://sonarcloud.io  -Dsonar.login=${env.SONAR_TOKEN}"
                     }
                }
             }
        }
        stage('Build Artifact Maven') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t params.DOCKER_IMAGE:params.TAG .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push params.DOCKER_IMAGE:params.TAG'
                }
             }
        }
     }
  }
