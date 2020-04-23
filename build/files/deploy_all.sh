#!/bin/bash

inst_roles() {
  echo "Installing Role: $1"
  ansible-galaxy install $1
}

playbook() {
  cd /home/ubuntu/ansible
  echo -e "\n\n******\n  New Task Running: $1 \n******\n\n"
  echo "Setting up nodes routing/DNS......"
  ansible-playbook $1
  if [ $? != 0 ]
  then
    echo -e "\n\n******\n  Task FAILED: $1 \n******\n\n"
    cd -
    exit 1
  fi
  echo -e "\n\n******\n  Task Complete: $1 \n******\n\n"
}

inst_roles nginxinc.nginx
inst_roles geerlingguy.jenkins


echo "Setting up Node Routing and DNS"
playbook node_setup_playbook.yaml

echo "Setting up local NGINX gateway"
playbook playbooks/nginx_workshop_gw/install.yaml 
playbook playbooks/nginx_workshop_gw/setup.yaml

echo "Setting up backend NGINX servers"
playbook playbooks/nginx_workshop_gw/install_backends.yaml

echo "Setting up the Ci/Cd pipe-line (git and jenkins)....."
playbook playbooks/cicd/deploy.yaml

echo "Setting up the UNIT instances (ie installing docker on them)"
playbook playbooks/unit/deploy.yaml

echo "Setting up the NGINX Controller....."
playbook playbooks/controller/deploy.yaml 
playbook playbooks/controller/license.yaml

echo "Setting up and registering NGINX instances with controller...."
playbook playbooks/controller/deploy_nginx.yaml

echo -e "\n\n******\n  All Done!  \n******\n\n"

