<h1 align="center">
<br>
  Create a CICD Pipeline to deploy a front-end Java Web Application
  <br>
</h1>

<details><summary><b>What is CICD pipeline?</b></summary>

**CICD** is an automated process that includes both **Continuous Integration (CI)** and **Continuous Deployment/Delivery (CD)**. **CI** is the continuous integration and testing of source code, while **CD** is the continuous deployment of source code to production environments.

**Pipeline** is an automated process for building, testing, packaging, and deploying applications. It includes a series of interconnected stages to minimize time and cost, while ensuring consistency and reliability in the application deployment. **Pipeline** can be implemented using various tools such as Jenkins, GitLab CI/CD, CircleCI, or Travis CI.

**Pipeline** can be used in the **CI** or **CD** process to automate the building, testing, and deployment of applications. Therefore, **Pipeline** and **CICD** are closely related and are often used together in software development projects.


In this lab, **Pipeline** and **CICD** use ``Jenkins``, ``Ansible``, ``Nexus (Sonatype)`` and a ``Docker host``.

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
    - [pom.xml](./pom.xml) is configuration file to define the information and dependencies of project or artifact information after building.
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

### Setup Maven
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

[Jenkinsfile](./Jenkinsfile) choose Maven for this Java project.
<h1 align="center">
<img src="/images/MavenChosen.png" width=30% height=30%>
</h1>

Maven has a stage to build the Java artifact.
<h1 align="center">
<img src="/images/MavenBuild.png" width=50% height=50%>
</h1>

### Setup Pipeline Utility Steps plugin
<details><summary><b>What is Pipeline Utility Steps?</b></summary>

**Pipeline Utility Steps** plugin provides steps to access information from jobs, builds, and other objects in Jenkins and use them. These steps make deploying pipelines easier and more efficient.

In this lab, **Pipeline Utility Steps** plugin uses the readMavenPom step to read the contents of the `pom.xml` file. This information can then be used to set variables or configurations within the pipeline.

</details>

Install in Plugin Manager
<h1 align="center">
<img src="/images/PipelineUS.png" width=100% height=100%>
</h1>

[Jenkinsfile](./Jenkinsfile) can use the variables from [pom.xml](./pom.xml) and print them out thank to Pipeline Utility Steps.
<h1 align="center">
<img src="/images/POMVariables.png" width=50% height=50%>
</h1>

<h1 align="center">
<img src="/images/PrintOutVariables.png" width=50% height=50%>
</h1>

### Setup Sonatype Nexus server and connection with Jenkins
<details><summary><b>What is Sonatype Nexus server?</b></summary>

**Sonatype Nexus** is an open-source repository manager software used to manage and store software components (such as libraries, plugins, and other dependencies) of a software project. It allows developers, project managers, and DevOps experts to efficiently and safely manage these software components.

**Nexus** supports multiple types of repositories, including Maven repositories, npm repositories, Docker repositories, and many other types of repositories. It enables developers to easily search and download software components from repositories and also provides tools to manage versions and access control. Additionally, Nexus can be integrated with other software development tools such as Apache Maven, Jenkins, and IntelliJ IDEA.

In this lab, **Nexus** will store the artifact war file after building from Jenkins.

</details>

**On Nexus server**

Open browser with ``[Nexus public IP]:8081`` in URL then click *Sign In* in right conner.
<h1 align="center">
<img src="/images/NexusSignIn.png" width=100% height=100%>
</h1>

Use ``sudo cat /opt/sonatype-work/nexus3/admin.password`` and take admin password then create new password is **admin** also -> choose *Enable anonymous access* -> go to *Finish*
<h1 align="center">
<img src="/images/NexusAnonymous.png" width=100% height=100%>
</h1>

Go to Setting icon -> *Repositories* tab -> click *Create Repository*.
<h1 align="center">
<img src="/images/NexusCreateRepo.png" width=100% height=100%>
</h1>

Choose *maven(hosted)*
<h1 align="center">
<img src="/images/MavenHostedRepo.png" width=100% height=100%>
</h1>

Fill the name with **MyLab-RELEASE** and choose type *Release*.
<h1 align="center">
<img src="/images/NexusReleaseRepo.png" width=100% height=100%>
</h1>

Do the same steps for snapshot repo with **MyLab-SNAPSHOT** and *Snapshot* type.
<h1 align="center">
<img src="/images/MavenRepos.png" width=100% height=100%>
</h1>

**On Jenkins server**
Add new credential to access Nexus repo (server). That creadential is Nexus **admin** user. 

Click *Add Credentials*.
<h1 align="center">
<img src="/images/AddCredential.png" width=100% height=100%>
</h1>

user & password: **admin**
ID: **nexus**

<h1 align="center">
<img src="/images/JenkinCreadential.png" width=100% height=100%>
</h1>

Click *Create*.
<h1 align="center">
<img src="/images/NexusCredential.png" width=100% height=100%>
</h1>

Install `Nexus Artifact Uploader`.
<h1 align="center">
<img src="/images/NexusArtifactUploader.png" width=100% height=100%>
</h1>

It is done for **Nexus**!!

### Setup Ansible connection.
**On Jenkins**
Install ``Publish Over SSH`` plugin.
<h1 align="center">
<img src="/images/SSHPlugin.png" width=100% height=100%>
</h1>

Add user and define the SSH server.
<h1 align="center">
<img src="/images/AnsibleUser.png" width=100% height=100%>
</h1>

Click *Test Configuration* (Success) -> *Apply* and *Save*
<h1 align="center">
<img src="/images/SSHTest.png" width=100% height=100%>
</h1>

**On Ansible**
Connect to Ansible CLI with **ansibleadmin** user by ssh.
    
    ssh ansibleadmin@[Ansible Public IP]

Create ssh keypair by command ``ssh-keygen`` then enter to *accept save private key default directory (/home/ansibleadmin/.ssh/id_rsa)* and *skip the passphrase*.

Private and public key will be placed in `/home/ansibleadmin/.ssh`.

Copy public key to Docker host by command to create ssh connection from Ansbile server without password login later.

    ssh-copy-id ansibleadmin@[Docker host Private IP]

### Create terraform file
Refer the notes in [main.tf](./main.tf).

### Create Jenkinsfile
**Manual code**

<h1 align="center">
<img src="/images/PipelineMaven.png" width=50% height=50%>
</h1>

Use maven to build Java artifact

<h1 align="center">
<img src="/images/PipelinePOMvar.png" width=100% height=100%>
</h1>

Create varriables and get their value from ``pom.xml``

<h1 align="center">
<img src="/images/StageBuild.png" width=100% height=100%>
</h1>

Command to install package (artifact) by **maven**

<h1 align="center">
<img src="/images/NexusRepoDirection.png" width=100% height=100%>
</h1>

The code will check whether the variable Version ends with `SNAPSHOT` or not. If true, the variable NexusRepo will be set to the value `MyLab-SNAPSHOT`, otherwise it will be set to the value "MyLab-RELEASE".
In this case, If the Version variable ends with `SNAPSHOT`, it will upload to `MyLab-SNAPSHOT` repository. Conversely, if it is not "SNAPSHOT", it will move to ``MyLab-RELEASE`` repository.

**Snippet Generator**

Follow the below highlights

<h1 align="center">
<img src="/images/NexusGenerate1.png" width=100% height=100%>
</h1>

<h1 align="center">
<img src="/images/NexusGenerate2.png" width=100% height=100%>
</h1>

Nexus URL: *Nexus Public IP*
Credentials: *User admin of Nexus are created in credential Jenkins*
GroupId, Version, Repository: *Variables from `pom.xml`*

Artifacts -> Click *Add*
<h1 align="center">
<img src="/images/NexusGenerate3.png" width=100% height=100%>
</h1>

Click *Generate Pipeline Script*
<h1 align="center">
<img src="/images/NexusGenerate4.png" width=100% height=100%>
</h1>

Then we can convert them like this.
<h1 align="center">
<img src="/images/NexusGenerate5.png" width=100% height=100%>
</h1>


### Create Ansible files
Refer the names and notes in [download-deploy.yaml](./download-deploy.yaml)

### Run Pipeline and Result
Go into *"Javaweb" pipeline* -> Click *Build Now* to begin to run the pipeline.
<h1 align="center">
<img src="/images/Build1.png" width=100% height=100%>
</h1>

When you get the error alert -> Click the number of building time in conner -> *Console Output* to view the error.
<h1 align="center">
<img src="/images/error.png" width=100% height=100%>
</h1>

>In this lab, I define wrong some server IPs and maven version. 

Success result in third run.
<h1 align="center">
<img src="/images/Result.png" width=100% height=100%>
</h1>