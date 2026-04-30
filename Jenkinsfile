pipeline {
    agent any

    stages {

        // Stage 1: Checkout code from Git
        stage('Checkout') {
            steps {
                echo '========== Pulling Code from Git =========='
                checkout scm
            }
        }

        // Stage 2: Deploy Terraform infrastructure
        stage('Terraform infra deployment') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'hari',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh '''
                        cd terraform-aws-infra

                        echo "========== Initializing Terraform =========="
                        terraform init -reconfigure

                        echo "========== Validating Terraform Code =========="
                        terraform validate

                        echo "========== Fixing Formatting =========="
                        terraform fmt -recursive

                        echo "========== Planning Terraform Changes =========="
                        terraform plan -out=tfplan -var-file=terraform.tfvars

                        echo "========== Applying Terraform Changes =========="
                        terraform apply -auto-approve tfplan

                        echo "========== Terraform Outputs =========="
                        terraform output
                    '''
                }
            }
        }

    }

    post {

        success {
            echo '''
            ========== SUCCESS ==========
            Resources Created:
            - VPC             : my-vpc
            - Public Subnets  : 2
            - Private Subnets : 2
            - EC2 Instance    : my-ec2-instance
            ==============================
            '''
        }

        failure {
            echo '''
            ========== FAILED ==========
            Check logs above for errors
            ==============================
            '''
        }

        always {
            echo '========== Pipeline Finished =========='
            
        }

    }

}