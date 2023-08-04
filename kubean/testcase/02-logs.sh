
pod_name=$(kubectl  get po -n kubean-system -o name  |grep cluster | awk -F"/" '{print $2}')

kubectl logs  $pod_name -n kubean-system --tail 100  
