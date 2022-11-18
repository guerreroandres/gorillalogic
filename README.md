# gorillalogic devops test
# Andres Guerrero
# guerreroandres@gmail.com
https://github.com/guerreroandres/gorillalogic

1. Docker image was created and tested locally
2. AWS was used to create the resources in the cloud
3. An EKS cluster was created using terraform
4. A Helm Chart was created to deploy the app into k8s
5. A GitHub Actions workflow was created to continuously deploy the app.

The timeoff application gathered from https://github.com/timeoff-management/timeoff-management-application
such application is running on a container that was successfully tested locally, after this I decided
to deploy the application in kubernetes using Helm Chart, so I created a new Helm Chart for this.
I used the EKS service from AWS to deploy the application, not only the cluster but also the rest of resources
needed by EKS were created using terraform such as VPC, ECR, S3 bucket etc.

The cluster was created using two t2.micro ec2 instances as worker nodes, since this is a tiny instance it only
provides four IP addresses, the kubernetes deployment strategy used to overcome this situation is Recreate, this
way I can have two pods each of them on a different node.

Load Balancer URL:
http://a0ae723fb090e434a98233849b3fc392-765716846.us-east-2.elb.amazonaws.com:3000/

Once the cluster was created using terraform, I tested the timeoff helm chart to create two replicas of the app.

Following Infrastructure was built using terraform, following the next folder structure:
- backend (For terraform remote state):
    - S3 bucket
    - DynamoDB lock table
- eks (For the EKS cluster itself)
    - EKS
    - VPC
    - ECR
    If the infrastructure is going to build on another AWS account please change the "aws-account" terraform variable on both folders.

After all, since the code is hosted on GitHub I decided to create a GitHub Actions Workflow to deploy the app
automatically at every push or PR to the main branch, this workflow contains two jobs:
- Build: Here the docker image is built and pushed to the ECR repo.
- Deploy: The uploaded image is deployed into the kubernetes cluster using helm.

The GitHub Actions workflow file performs all the actions using the following github secrets:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION
- KUBECONFIG

Note: All the AWS services will be down to avoid expensive charges, but you can copy and paste all this repo
and it should work on another AWS account, or in the other hand just let me know when the application will be
tested and I can spin up again all the resources, and provide a new LB url.
