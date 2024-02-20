pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/Sahilsinghss/springboot.git'
        GIT_CREDS = '92ec0319-697f-49d3-b22d-a99a7f8439e8'
        GIT_BRANCH = 'main'
        SPRING_PROFILE = 'dev'
        dockerimagename = credentials('DockerRepo')
        dockercreds = 'dockerhublogin'
        dockerurl = 'https://registry.hub.docker.com'
    }

    stages {
        stage('Git Clone') {
            steps {
                script {
                    // Clean workspace before cloning (optional)
                    deleteDir()
                    
                    // Git clone
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: GIT_URL,credentialsId: GIT_CREDS]]])
                    echo "Cloned code is in directory: ${pwd()}"
                }
            }
        }
    stage('Build') {
        steps {
            script {
                // Build the Spring Boot project
                sh 'npm run build'
            }
        }
    }


    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( dockerurl, registryCredential ) {
            dockerImage.push("$SPRING_PROFILE")
          }
        }
      }
    }
    
    }
}
