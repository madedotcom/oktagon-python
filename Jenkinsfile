import hudson.AbortException

def prepareRepo() {
    deleteDir()

    checkout scm

    gitUpdateSubmodule()

    currentBuild.displayName = sh(script: "make -s get-version BRANCH_NAME=${env.BRANCH_NAME}", returnStdout: true)
    currentBuild.description = sh(script: "make -s get-desc BRANCH_NAME=${env.BRANCH_NAME}", returnStdout: true)
}

def prTitle() {
    return  env.BRANCH_NAME == 'main' ? '' : env.CHANGE_TITLE.toLowerCase()
}


def isMain() {
    return prTitle() == 'main'
}

pipeline {
    agent {
        label 'aws-ecr'
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        skipDefaultCheckout true
    }

    stages {
        stage('Checkout') {
            steps {
                prepareRepo()
            }
        }

        stage('Build') {
            steps {
                sh "make install-deps"
            }
        }
        stage('Code checks') {
            parallel {
                stage('Black') {
                    steps {
                        sh "make black-check"
                    }
                }

                stage('Isort') {
                    steps {
                        sh "make isort-check"
                    }
                }


            }
        }

        stage("Tests") {
            
            steps {
                sh "make test-coverage"
            }

        }
        
        stage('Publish') {
            when {
                expression { env.BRANCH_NAME == 'master'}
            }

            steps {
                script {
                    sh "make publish"
                }
            }
        }
    }

    post {
        always {
            sh 'make coverage-report'
        }

        failure {
            echo "Job has failed during ${env.FAILURE_STAGE}!"
        }
    }
}
