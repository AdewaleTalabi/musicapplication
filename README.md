# CI/CD Pipeline Project

**Project Overview:** Produces a CI/CD Pipeline to facilitate the automated deployment, building, storing of the code base for a simple music application built using React. The pipeline aims to makes seamless updates from the codebase stored on github all way to application being ran via a docker image.

Full video expalnation of the project can be found - [here](https://youtu.be/7RNAai6ZWN4)

**Tech stack used in this project:**

* AWS EC2
* AWS Security Groups
* AWS S3 Buckets
* AWS Elastic IPs
* Jenkins
* Github
* Github Actions
* Sonarqube
* React NodeJs
* Docker

# 1. EC2 Instances

For this project, I used three Ubuntu virtual machines, each one to host the applications I would be using within my CI/CD pipeline. 

All the EC2 instances use Ubuntu 20.04 Image



![](/Assets/Images/Imagem3.jpg)

# 2. Jenkins Server

This process was straightforward with the wide range of tutorials available to demonstrate how do set Jenkins up on an Ubuntu machine.

**I used the following commands to install and my Jenkins application:**

```
sudo apt update
sudo apt install openjdk-11-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
```
**Booting**

Upon initial installation I was encountering issues when closing the VM and opening new sessions, therefore, to ensure that Jenkins was part of the programs that automatically booted with the virtual machine I added the following lines to a file named Jenkins.service.

**Jenkins.service**

```
[Service]
Type=notify
NotifyAccess=main
ExecStart=/usr/bin/jenkins
Restart=on-failure
SuccessExitStatus=143
```

After setting up the Jenkins.service file, I then used the following commands to enable that Jenkins was a part of my server's boot process.

```
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable Jenkins
```

After this process, my Jenkins server was successfully set up and running on port 8080 of my virtual machine.

**Result**

![](/Assets/Images/Imagem5.jpg)

![](/Assets/Images/Imagem6.jpg)

# 3. Sonarqube Server

I found the simplest way for me to install Sonarqube was from a Docker image with the help of this [tutorial](https://www.youtube.com/watch?v=WsnH69zQ1ak&t=976s) 

**I used the following commands to install the Sonarqube application:**

```
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s) -$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo nano docker-compose.yaml
docker-compose.yaml file 
sudo apt update
sudo apt  install docker.io
sudo docker pull sonarqube
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube
sudo vim /etc/systemd/system/sonarqube.service
sudo docker run --restart=always 63880fd07120

```
**Sonarqube.service File**

```
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/opt/sonarqube
ExecStart=/usr/bin/docker start -a sonarqube
ExecStop=/usr/bin/docker stop -t 10 sonarqube
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```
After running all these commands, I now have a Sonarqube application running on the Ubuntu virtual machine through a docker image.

**Result**

![](/Assets/Images/Imagem7.jpg)

![](/Assets/Images/Imagem8.jpg)

![](/Assets/Images/Imagem9.jpg)

# 4. Nexus Server

**I used the following commands to install the Nexus application:**

```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker pull sonatype/nexus3
sudo docker run -d -p 8081:8081 --name nexus sonatype/nexus3
```

**Result**

![](/Assets/Images/Imagem10.jpg)

![](/Assets/Images/Imagem11.jpg)

# 4. Building The Pipeline

Now with all the applications installed on their respective VMs, I could now start to build the pipeline within Jenkins.

# Stage 1 - Checkout

**Purpose:** Taking the musicapplication repository from my Github account using the account credentials and copying on to the Jenkins VM.

```
stage('Checkout') {
        steps {
            // Checkout code from GitHub repository
            git credentialsId: 'AT', url: 'https://github.com/AdewaleTalabi/musicapplication.git'
        }
    }
```
**Result**

![](/Assets/Images/Imagem12.jpg)

Successful pulling of musicapplication repository from GitHub account to the Jenkins server

# Stage 2 - Install

**Purpose:** Install npm on the Jenkins machine

```
 stage('Install'){
        steps{
            sh "npm install"
            }
    }
```

This command installs the latest version of NPM on the Jenkins' server

# Stage 3 - Build

**Purpose:** To produce all the necessary files required for running the music application on the server

```
stage('Build') {
        steps {     
            sh 'npm run build'
        }
    }
```

**Result**

![](/Assets/Images/Imagem13.jpg)

Successful creation of the build folder within the Jenkins server

# Stage 4 - SonarQube analysis

**Purpose:** Connect the Jenkins server to the Sonarqube server and run an analysis on the musicapplication project checking for code errors and inefficiencies.

```
stage('SonarQube analysis') {
        environment {
            scannerHome = tool 'SonarScanner' // Must match the name of the SonarScanner installation in the Jenkins configuration
        }
        steps {
            withSonarQubeEnv('Sonarqube') {
                sh "${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=musicapplication \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.exclusions=**/*.test.js \
                    -Dsonar.language=js"
            }
        }
    }
```

**Result**

![](/Assets/Images/Imagem14.jpg)

Sonarqube is now running tests on the musicapplication code that has been pulled from my Github repository

# Stage 5 - Zip Folder
