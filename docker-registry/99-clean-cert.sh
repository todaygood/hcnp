#!/bin/bash

echo "------------------------------------------------------------------------------------------------------------"
echo "before:"
echo "ls cert/"
ls cert/

cd ./cert
rm -f  *.csr  ca-key.pem  ca.pem
rm -f pastack*


cd ..
echo "------------------------------------------------------------------------------------------------------------"
echo "now:"
echo "ls cert/"
ls cert/
echo "------------------------------------------------------------------------------------------------------------"

