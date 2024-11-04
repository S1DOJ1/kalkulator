pipeline {

    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('checkout') {

            steps {

                echo 'checking'
                checkout([$class: 'GitSCM', branches: [[name: '*/try1']], userRemoteConfigs: [[url: 'https://github.com/S1DOJ1/kalkulator']]])

            }
        }

        stage('build') {

            steps {

                echo 'building'
                sh 'docker build -t test:latest .'
                sh 'docker run --rm -d -p 8000:8000 test'

            }
        }

        
        stage('test') {

            steps {

                echo 'testing'
                sh 'sleep 60'
                sh 'curl -d "num1=5&num2=10" -X POST http://localhost:8000/add'
                sh 'docker stop $(docker ps -q --filter ancestor=test)' 
                
            }
        }


    }
    post {
        success {
            echo 'success'
        }
        failure {
            echo 'failure'
        }
    }
}
