#! /bin/bash
echo "#################### VSTS Agent Installation ####################"
echo "#################### Update lib unwind & curl3 ####################"
sudo apt-get install -y libunwind8 libcurl3
echo "#################### add ppa repo ####################"
sudo apt-add-repository ppa:git-core/ppa
echo "#################### Update package list ####################"
sudo apt-get -y -q update
echo "#################### install git package ####################"
sudo apt-get install git
echo "#################### install libcurl4 package ####################"
apt-get install libcurl4-openssl-dev
echo "#################### Get vsts's agent sources ####################"
wget https://github.com/Microsoft/vsts-agent/releases/download/v2.123.0/vsts-agent-ubuntu.16.04-x64-2.123.0.tar.gz -O vsts-agent-ubuntu.16.04-x64-2.123.0.tar.gz
echo "#################### Create agent folder ####################"
mkdir agent && cd agent
echo "#################### Extract vsts's agent sources ####################"
tar -xvf ../vsts-agent-ubuntu.16.04-x64-2.123.0.tar.gz

echo "#################### Azure CLI 2.0 Installation ####################"
echo "#################### Add Microsoft Repo ####################"
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
     sudo tee /etc/apt/sources.list.d/azure-cli.list
echo "#################### Add Microsoft's key ####################"
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
echo "#################### Install apt transport https package ####################"
sudo apt-get install apt-transport-https
echo "#################### Update && Install Azure Cli 2.0 package ####################"
sudo apt-get update && sudo apt-get install azure-cli jq