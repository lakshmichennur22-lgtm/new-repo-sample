pipeline {

    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        // Stage 1: Pull code from Git
        stage('Checkout') {
            steps {
                echo '========== Pulling Code from Git =========='
                checkout scm
            }
        }

        // Stage 2: Initialize Terraform
        stage('Terraform Init') {
            steps {
                echo '========== Initializing Terraform =========='
                dir('terraform-aws-infra') {
                    sh 'terraform init'
                }
            }
        }

        // Stage 3: Validate Terraform code
        stage('Terraform Validate') {
            steps {
                echo '========== Validating Terraform Code =========='
                dir('terraform-aws-infra') {
                    sh 'terraform validate'
                }
            }
        }

        // Stage 4: Auto fix formatting instead of just checking
        stage('Terraform Format') {
            steps {
                echo '========== Fixing Terraform Formatting =========='
                dir('terraform-aws-infra') {
                    sh 'terraform fmt -recursive'
                }
            }
        }

        // Stage 5: Plan - shows what will be created
        stage('Terraform Plan') {
            steps {
                echo '========== Planning Terraform Changes =========='
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Lakshmi',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    dir('terraform-aws-infra') {
                        sh 'terraform plan -var-file="terraform.tfvars" -out=tfplan'
                    }
                }
            }
        }

        // Stage 6: Manual approval before applying
        stage('Approval') {
            steps {
                echo '========== Waiting for Manual Approval =========='
                timeout(time: 5, unit: 'MINUTES') {
                    input message: '''Review the plan:
                    - 1 VPC (10.0.0.0/16)
                    - 2 Public Subnets
                    - 2 Private Subnets
                    - 1 EC2 Instance (t3.micro)
                    Do you want to Apply?''',
                    ok: 'Yes, Apply!'
                }
            }
        }

        // Stage 7: Apply - creates all AWS resources
        stage('Terraform Apply') {
            steps {
                echo '========== Applying Terraform Changes =========='
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Lakshmi',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    dir('terraform-aws-infra') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        // Stage 8: Show created resource outputs
        stage('Show Outputs') {
            steps {
                echo '========== Terraform Outputs =========='
                dir('terraform-aws-infra') {
                    sh 'terraform output'
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
            - Public Subnets  : 2 (us-east-1a, us-east-1b)
            - Private Subnets : 2 (us-east-1a, us-east-1b)
            - EC2 Instance    : my-ec2-instance (t3.micro)
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
            cleanWs()
        }

    }

}