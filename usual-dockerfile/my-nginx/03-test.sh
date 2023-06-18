name=tc01
echo "---------------------------------------------------------------------------------------------------------"
docker rm -f $name 
echo "---------------------------------------------------------------------------------------------------------"
echo "#docker run --name $name -idt -p 8900:80 pastack-registry.paic.com.cn/library/nginx:1.24.01-deb11" 
docker run --name $name -idt -p 8900:80 pastack-registry.paic.com.cn/library/nginx:1.24.01-deb11 

echo "#docker ps | grep $name"
docker ps | grep $name
echo "---------------------------------------------------------------------------------------------------------"

echo "#docker exec -it $name ip r "
docker exec -it $name ip r 
echo "---------------------------------------------------------------------------------------------------------"
