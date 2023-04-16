<h1 align="center">
<br>
  Create a CICD Pipeline to deploy a front-end Java Web Application
  <br>
</h1>

<details><summary><b>What is CICD pipeline?</b></summary>

**CICD** is an automated process that includes both **Continuous Integration (CI)** and **Continuous Deployment/Delivery (CD)**. **CI** is the continuous integration and testing of source code, while **CD** is the continuous deployment of source code to production environments.

**Pipeline** is an automated process for building, testing, packaging, and deploying applications. It includes a series of interconnected stages to minimize time and cost, while ensuring consistency and reliability in the application deployment. **Pipeline** can be implemented using various tools such as Jenkins, GitLab CI/CD, CircleCI, or Travis CI.

**Pipeline** can be used in the **CI** or **CD** process to automate the building, testing, and deployment of applications. Therefore, **Pipeline** and **CICD** are closely related and are often used together in software development projects.


In this lab, **Pipeline** and **CICD** use ``Jenkins``, ``Ansible``, ``Nexus`` and a ``Docker host``.

- **Pipeline process steps:**
    - The pipeline is built using [Jenkinsfile](./Jenkinsfile) and [source code](./src/main/webapp/) that describes the process of building, testing, packaging, and deploying the application. This pipeline uses the following tools and servers:
    - ``Jenkins``: used to run the pipeline and perform steps in the CI/CD process.
    - ``Nexus``: used to store artifacts, including JAR files, WAR files, and Docker images.
    - ``Ansible``: used to deploy configuration files and scripts during the application deployment process.
    - ``Docker host``: used to run Docker containers.
- **CI process steps:**
    - The CI process in this pipeline includes the following steps:
    - Checkout source code from the Git repository.
    - Build the project using Apache Maven to create a WAR file.
    - Perform unit and integration testing steps using JUnit and Selenium.
    - Store the WAR file in the Nexus server.
- **CD process steps:**
    - Retrieve the WAR file from the Nexus server.
    - Package the application into a Docker image.
    - Push the Docker image to a Docker Registry.
    - Deploy the application to the Docker host server using Ansible.

When there is a change in the project's source code, the Jenkins server will automatically trigger the pipeline and perform the CI/CD process to ensure that the application is built, tested, and deployed automatically, reliably, and consistently.
</details>

## Pre-required
- IAM user of AWS (Do not use root).
- Setup [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Install [Terraform CLI](https://developer.hashicorp.com/terraform/downloads).
- Run `aws configure` in terminal then enter Access key, Secret Key, default region name and output format to configure the user's login information and authentication with AWS (region name and output format are skippable).
- Create a keypair in AWS console then save and give it full control or chmod 400 in your PC to remote ec2 later.
- Use or refer this repo to make your own Github repo for this lab:
    - [main.tf](./main.tf) is used to deploy the infrastructure on AWS by terraform.
    - [InstallAnsible.sh](./InstallAnsible.sh), [InstallDocker.sh](./InstallDocker.sh), [InstallJenkins.sh](./InstallJenkins.sh) and [InstallNexus.sh](./InstallNexus.sh) are scripts to install services into EC2.
    - [Jenkinsfile](./Jenkinsfile) includes the whole pipeline stages that are run by Jenkins server.
    - [pom.xml](./pom.xml) is configuration file to define the information of project and project dependencies or artifact information after building.
    - [download-deploy.yaml](./download-deploy.yaml) is Ansible playbook that includes the tasks will be run to build container in Docker host by Ansible server.
    - [hosts](./hosts) will define the controled-server IP for Ansible.
    - [src](./src/) is Java Web source code.

## Getting Started

### Provision infrastructure in AWS with Terraform
Open Terminal and run.

`terraform init`
>This command is only for the first time use Terraform.

`terraform apply --auto-approve`
>This command is to provision all resources and infrastructure in `main.tf`

