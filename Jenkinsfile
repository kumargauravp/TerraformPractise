pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue:false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID=credentials("AWS_ACCESS_KEY_ID")
        AWS_SECRET_ACCESS_KEY=credentials("AWS_SECRET_ACCESS_KEY")
    }

    agent any
    stages {
        stage('checkout')
        {
            steps {
                scripts{
                    dir("Terraform")
                    {
                        git "https://github.com/kumargauravp/terraform-jenkins-eks.git"
                    }
                }
            }
        }
        stage('plan')
        {
            steps{
                sh "pwd; cd Terraform/; terraform init"
                sh "pwd; cd Terraform/; terraform plan -out tfplan"
                sh "pwd; cd Terraform/; terraform show -no-color tfplan >tfplan.txt"
            }
        }
        stage('Approval'){
            when {
                not{
                    equals expected: true, actual:params.autoApprove
                }
            }
            steps{
                script{
                    def plan =readFile 'Terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?"
                    parameters: [test(name: 'Plan', description: 'Please review the plan', defaultValue:plan)]
                }
            }
        }
        stage('Apply')
        {
            steps{
                sh 'pwd; cd Terraform/; terraform apply -input=false tfplan'
            }
        }
    }
}