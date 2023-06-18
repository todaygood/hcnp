#!/bin/bash

echo "prepare 3 files..."
cp input/*  cert/  

echo "------------------------------------------------------------------------------------------------------------"
echo "ls cert/"
ls cert/
echo "------------------------------------------------------------------------------------------------------------"

echo "run 3 commands..."

cd cert
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=registry-op registry-csr.json | cfssljson -bare pastack-registry
cfssl-certinfo -cert pastack-registry.pem

cd ..
echo "------------------------------------------------------------------------------------------------------------"
echo "ls cert/"
ls cert/
echo "------------------------------------------------------------------------------------------------------------"

echo "done."
