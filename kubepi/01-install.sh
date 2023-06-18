#!/bin/bash


kubectl apply -f kubepi-pvc.yaml

kubectl apply -f ingress.yaml

echo "-----------------------------------------------------------------------------------------------------"
echo "#kubectl describe ing kubepi-ingress -n kube-system" 
kubectl describe ing kubepi-ingress -n kube-system 
echo "-----------------------------------------------------------------------------------------------------"
