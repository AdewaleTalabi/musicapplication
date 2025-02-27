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

**I used the following commands to install the Sonarqube application:**




I found the simplest way for me to install Sonarqube was from a Docker image with the help of this [tutorial](https://www.youtube.com/watch?v=WsnH69zQ1ak&t=976s)
