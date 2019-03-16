### Basic configuration. Logs, Service connection
1. Create Kuard namespace
```
kubectl apply -f namespace.yaml
kubectl get ns
```
2. Create Kuard Deployment
```
kubectl apply -f deployment.yaml
kubectl get deploy --namespace=kuard
```
3. Create Kuard Service
```
kubectl apply -f service.yaml
kubectl get svc  --namespace=kuard
```
Service is not accessible from outside. Available only from inside k8s cluster - `kuard.kuard`(`kuard.kuard.svc.cluster.local`)
```
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kuard     ClusterIP   10.27.249.117   <none>        80/TCP    15s
```
4. Describe Kuard Deployment
```
kubectl get deploy --namespace=kuard
kubectl get deploy kuard --namespace=kuard -o yaml
kubectl describe deploy kuard --namespace=kuard
```
5. Read pod logs
    ```
    kubectl get pods --namespace=kuard
    kubectl logs -f POD_NAME --namespace=kuard
    ```
6. Deploy dummy app to check kuard service.
    ```
    kubectl apply -f deployment-dummy.yaml
    kubectl get pods --namespace=kuard
    kubectl exec -it POD_NAME /bin/sh --namespace=kuard
    apk add --no-cache curl
    curl http://kuard
    ```
7. Try it from another namespace. Comment `namespace: kuard`. Redeploy dummy app in default namespace.
    ```
    kubectl apply -f deployment-dummy.yaml
    kubectl get pods
    kubectl exec -it POD_NAME /bin/sh --namespace=kuard
    apk add --no-cache curl
    curl http://kuard.kuard
    ```
8. Delete dummy deployments
    ```
    kubectl delete deploy dummy && kubectl delete deploy dummy --namespace=kuard
    ```
