pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/Sahilsinghss/Reactjs.git'
        GIT_CREDS = 'jenkins-oc'
        GIT_BRANCH = 'main'
        SPRING_PROFILE = 'React-dev'
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
                sh 'npm install react-scripts --save'
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

    stage('deploy on openshift') {
      steps{
        echo "deploying on openshift"
        script {
          withEnv("PATH OC =${tool 'oc'}") {
            openshift.withCluster('devopsdaemon-dev') {
              openshift.withProject('devopsdaemon-dev') {
                 def app = openshift.newApp('registry.access.redhat.com/jboss-fuse-6/fis-java-openshift')
        def dcpatch = [
               "metadata":[
                   "name":"fis-java-openshift",
                   "namespace":"devopsdaemon-dev"
            ],
               "apiVersion":"apps.openshift.io/v1",
               "kind":"DeploymentConfig",
               "spec":[
                   "template":[
                       "metadata":[:],
                       "spec":[
                           "containers":[
                                 ["image":"registry.access.redhat.com/jboss-fuse-6/fis-java-openshift",
                                  "name":"fis-java-openshift",
                                  "resources":[:],
                                  "ports":[
                                       ["name":"jolokia",
                                        "containerPort":8778,
                                        "protocol":"TCP"
                                        ]
                                       ]
                                  ]
                           ],
                           "securityContext":[:],
                       ]
                   ]
                   ]
               ]

        openshift.apply(dcpatch)
              }
            }
          }
        }
      }
    }
    
    }
}
