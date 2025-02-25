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
