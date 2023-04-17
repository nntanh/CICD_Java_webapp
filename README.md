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
    - The pipeline is built using [Jenkinsfile](./Jenkinsfile) and [source code](./src/main/webapp/). The [Jenkinsfile](./Jenkinsfile) describes the process of building, testing, packaging, and deploying the application. This pipeline uses the following tools and servers:
    - ``Jenkins`` is used to run the pipeline and perform steps in the CI/CD process.
    - ``Nexus`` is used to store artifacts, including JAR files, WAR files, and Docker images.
    - ``Ansible`` is used to deploy configuration files and scripts during the application deployment process.
    - ``Docker host`` is used to run Docker containers.
- **CI process steps:**  
    - Checkout source code from the Git repository.
    - Build the project using Apache Maven to create a WAR file.
    - Perform unit and integration testing steps using JUnit and Selenium.
    - Store the WAR file in the `Nexus` server.
- **CD process steps:**
    - Retrieve the WAR file from the `Nexus` server.
    - Package the application into a `Docker` image.
    - Push the `Docker` image to a `Docker` Registry.
    - Deploy the application to the `Docker` host server using `Ansible`.

When there is a change in the project's source code, the Jenkins server will automatically trigger the pipeline and perform the CI/CD process to ensure that the application is built, tested, and deployed automatically, reliably, and consistently.
</details>

## Pre-required
- IAM user of AWS (Do not use root).
- Setup [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Install [Terraform CLI](https://developer.hashicorp.com/terraform/downloads).
- Run `aws configure` in terminal then enter Access key, Secret Key, default region name and output format to configure the user's login information and authentication with AWS (region name and output format are skippable).
- Create a keypair in AWS console then save and give it full control or chmod 400 in your PC to remote EC2 later.
- Use or refer this repo to make your own Github repo for this lab:
    - [main.tf](./main.tf) is used to deploy the infrastructure on AWS by terraform.
    - [InstallAnsible.sh](./InstallAnsible.sh), [InstallDocker.sh](./InstallDocker.sh), [InstallJenkins.sh](./InstallJenkins.sh) and [InstallNexus.sh](./InstallNexus.sh) are userdata scripts to install services into EC2.
    - [Jenkinsfile](./Jenkinsfile) includes the whole pipeline stages that are run by Jenkins server.
    - [pom.xml](./pom.xml) is configuration file to define the information of project and project dependencies or artifact information after building.
    - [download-deploy.yaml](./download-deploy.yaml) is Ansible playbook that includes the tasks will be run to build container in Docker host by Ansible server.
    - [hosts](./hosts) will define the controled-server IP for Ansible.
    - [src](./src/) is Java Web source code.

## Getting Started

### Provision infrastructure in AWS with Terraform
Open Terminal and run.

    terraform init
>This command is only for the first time use Terraform.

    terraform apply --auto-approve
>This command is to provision all resources and infrastructure in `main.tf`

There will be 4 instances with their own services are provisioned.
<h1 align="center">
<img src="/images/EC2.png" width=100% height=100%>
</h1>

### Setup Jenkins pipeline
Go to Jenkins console by `[the Jenkins public IP]:8080`
<h1 align="center">
<img src="/images/JenkinsConsole.png" width=100% height=100%>
</h1>

SSH to Jenkins server and take the Administrator Password as the highlight link using below command:
    
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Choose Install Suggested Plugins for default plugins.

<h1 align="center">
<img src="/images/JenkinsPlugins.png" width=100% height=100%>
</h1>

Create Admin User.

<h1 align="center">
<img src="/images/AdminUser.png" width=100% height=100%>
</h1>

Click Not now to skip because this lab does not use static IP and domain for Jenkins.

<h1 align="center">
<img src="/images/JenkinsURL.png" width=100% height=100%>
</h1>

Click New Item in Dashboard

<h1 align="center">
<img src="/images/JenkinsDashboard.png" width=100% height=100%>
</h1>

Fill the name of pipeline then choose and click OK

<h1 align="center">
<img src="/images/JenkinPipeline.png" width=100% height=100%>
</h1>

Follow the below highlight to configure and click Apply then Save.
<h1 align="center">
<img src="/images/PipelineConfigure.png" width=100% height=100%>
</h1>

Repository URL is taken from the Github repo

<h1 align="center">
<img src="/images/GithubRepo.png" width=50% height=50%>
</h1>

A fresh pipeline is created.

<h1 align="center">
<img src="/images/FreshPipeline.png" width=100% height=100%>
</h1>

#### Setup Maven
<details><summary><b>What is Maven?</b></summary>

**Maven** is a build automation tool primarily used for Java projects:
- It follows a Project Object Model (pom.xml) file to download the specified dependencies.
- Build the application by using the maven-compiler plugin to compile the Java source code.
- Package the application into a packaging file (artifact), such as a JAR or WAR file, using the maven-jar or maven-war plugin.

</details>

Install Maven Integration plugin.
<h1 align="center">
<img src="/images/MavenPlugin.png" width=100% height=100%>
</h1>

Configure Maven then click Apply and Save.
<h1 align="center">
<img src="/images/ConfigMaven.png" width=100% height=100%>
</h1>

In [Jenkinsfile](./Jenkinsfile), Maven is chosen.
<h1 align="center">
<img src="/images/MavenChosen.png" width=100% height=100%>
</h1>

Maven has a stage to build the Java artifact.
<h1 align="center">
<img src="/images/MavenBuild.png" width=100% height=100%>
</h1>

