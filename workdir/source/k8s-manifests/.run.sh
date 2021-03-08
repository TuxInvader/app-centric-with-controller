#!/bin/bash

  cd ~/source/kubernetes-ingress/
  cd deployments/
  kubectl apply -f common/crds/k8s.nginx.org_virtualservers.yaml
  kubectl apply -f common/crds/k8s.nginx.org_virtualserverroutes.yaml
  kubectl apply -f common/crds/k8s.nginx.org_policies.yaml
  kubectl apply -f common/crds/k8s.nginx.org_transportservers.yaml
  kubectl apply -f common/crds/k8s.nginx.org_globalconfigurations.yaml
  kubectl apply -f common/crds/appprotect.f5.com_aplogconfs.yaml
  kubectl apply -f common/crds/appprotect.f5.com_appolicies.yaml
  kubectl apply -f common/crds/appprotect.f5.com_apusersigs.yaml
  kubectl apply -f common/ns-and-sa.yaml
  kubectl apply -f rbac/rbac.yaml
  kubectl apply -f rbac/ap-rbac.yaml
  kubectl apply -f common/default-server-secret.yaml
  kubectl apply -f common/nginx-config.yaml
  kubectl apply -f common/global-configuration.yaml
  kubectl apply -f common/ingress-class.yaml
  cd ../../k8s-manifests/
  ls
  cat docker-secret.yaml
  dockerconfig=$(cat /home/ubuntu/.docker/config.json | base64 -w 0)
  sed -i -re "s/YOUR_SECRET/$dockerconfig/" docker-secret.yaml
  kubectl -n nginx-ingress apply -f docker-secret.yaml
  kubectl apply -f nginx-ingress/10-deploy-kic.yaml
  kubectl apply -f nginx-ingress/11-deploy-kic-service.yaml
