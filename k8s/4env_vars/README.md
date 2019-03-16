### Env Variables

1. Deploy ConfigMap
    ```
    kubectl apply -f configmap.yaml 
    kubectl describe cm kuard --namespace=kuard
    ```
2. Set Secret
    ```
    echo -n 'mySuperS3cr3tP@ssword' | base64
    bXlTdXBlclMzY3IzdFBAc3N3b3Jk
    ```
  - Add key to the secret yaml
    ```
    kubectl apply -f secret.yaml 
    kubectl describe secret kuard-secret --namespace=kuard
    ```
3. Apply deployment and investigate Env vars