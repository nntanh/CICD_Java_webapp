#!/bin/bash

sudo yum update -y

sudo amazon-linux-extras install epel -y

sudo amazon-linux-extras install ansible2 -y

sudo useradd aaa

sudo echo "123567" | passwd --sdtin aaa

