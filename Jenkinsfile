@Library("shared_lib") _
pipeline {
    agent any

    options {
        timestamps()
    }

	environment {
		App_Name = 'Test-App CI/CD Pipeline'
	}
	
    stages {
        stage('shared') {
            steps {
                script {
                    hello()
                }
            }
        }
        stage('Clone') {
            steps {
                script {
                    clone("https://github.com/surajsinghit21/django-notes-app.git","main")
                }
            }
        }
		stage('Trivy-check') {
			steps {
				sh "trivy fs ."
			}
		}
        stage('Build') {
            steps {
				echo "${App_Name}"
                echo 'This is building code.'
                echo 'user ----'
                sh "whoami"
                sh "docker build -t notes-app:latest ."
            }
        }
        stage('Test') {
            steps {
                echo 'This is Testing code.'
            }
        }
        stage('push image to docker hub') {
            steps {
                echo 'This is pushing image.'
                withCredentials([usernamePassword('credentialsId': "dockerHubCred",usernameVariable: "USERNAME",passwordVariable: "PASSWORD")])
                {
                    sh "docker login -u ${env.USERNAME} -p ${env.PASSWORD}"
                    sh "docker image tag notes-app:latest suraj1321/notes-app:latest"
                    sh "docker push suraj1321/notes-app:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is Deploying code.'
                sh "docker run -d -p 8000:8000 notes-app:latest"
            }
        }
    }

	post {
		always {
        emailext(
            subject: "Jenkins Build: ${JOB_NAME} #${BUILD_NUMBER} - ${currentBuild.currentResult}",
            mimeType: 'text/html',
            body: """
                <h2>Build Status: ${currentBuild.currentResult}</h2>

                <table border="1" cellpadding="5">
                    <tr><td><b>Job</b></td><td>${JOB_NAME}</td></tr>
                    <tr><td><b>Build</b></td><td>#${BUILD_NUMBER}</td></tr>
                    <tr><td><b>Status</b></td><td>${currentBuild.currentResult}</td></tr>
                    <tr><td><b>URL</b></td><td><a href="${BUILD_URL}">Open Build</a></td></tr>
                </table>
            """,
            to: 'singhsuraj1321@gmail.com'
        )
    }
	}
}
