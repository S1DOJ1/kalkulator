pipeline {

    agent any

    triggers { pollSCM('* * * * *') }

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
		sh 'trivy image --severity HIGH test:latest'
                sh 'docker run --rm -d -p 8000:8000 test'

            }
        }

        
        stage('test') {

            steps {

                echo 'testing'
                sh 'sleep 5'
                sh 'curl -d "num1=8&num2=12" -X POST http://localhost:8000/add'
          	sh 'docker stop $(docker ps -q --filter ancestor=test)' 
                
            }
        }
        stage('bandit') {
		
	        steps {
		
		        sh 'sleep 10'
		        sh 'docker run --rm test:latest bandit -r . -lll'
	
	        }
	    }

	stage('semgrep') {
	    steps {
	    	sh 'docker run --rm test:latest semgrep --config auto '
	    }	
	}
        
    }

    post {
        success {
            echo 'Docker image built and pushed successfully!!'
        }
        failure {
            echo 'Something went wrong with the build.'
        }
    }
}
