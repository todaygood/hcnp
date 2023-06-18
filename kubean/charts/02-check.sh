#!/bin/bash

echo "-----------------------------------------------------------------------------------------------------"
echo "#helm status kubean -n kubean-system"
helm status kubean -n kubean-system
echo "-----------------------------------------------------------------------------------------------------"
echo "#helm get all kubean -n kubean-system > yaml.txt"
helm get all kubean -n kubean-system > yaml.txt
echo "-----------------------------------------------------------------------------------------------------"
