# Create a CICD pipeline to deploy a front-end Java Web Application

<details><summary><b>What is CICD pipeline?</b></summary>

**CICD** is an automated process that includes both **Continuous Integration (CI)** and **Continuous Deployment/Delivery (CD)**. **CI** is the continuous integration and testing of source code, while **CD** is the continuous deployment of source code to production environments.

**Pipeline** is an automated process for building, testing, packaging, and deploying applications. It includes a series of interconnected stages to minimize time and cost, while ensuring consistency and reliability in the application deployment. **Pipeline** can be implemented using various tools such as Jenkins, GitLab CI/CD, CircleCI, or Travis CI.

**Pipeline** can be used in the **CI** or **CD** process to automate the building, testing, and deployment of applications. Therefore, **Pipeline** and **CICD** are closely related and are often used together in software development projects.


In this tutorial, **Pipeline** and **CICD** use ``Jenkins``, ``Ansible``, ``Nexus`` and a ``Docker host``.

- **Pipeline process steps:**
    - The pipeline is built using [Jenkinsfile](./Jenkinsfile) and [source code](./src/) that describes the process of building, testing, packaging, and deploying the application. This pipeline uses the following tools and servers:
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

