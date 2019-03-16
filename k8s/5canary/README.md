### Canary

1. Deploy `hello-app v1` and service for the app. 
    ```
    kubectl apply -f hello-app/deployment_v1.yaml
    kubectl apply -f hello-app/service_app.yaml
    ```
2. Expose application in already existing ingress
    ```
    - host: hello.35.201.76.150.nip.io
        http:
        paths:
        - backend:
            serviceName: hello-app
            servicePort: 80
    ```
    - Apply changes and explore ingress.
3. Deploy `hello-app v2` as canary. 
    ```
    kubectl apply -f hello-app/deployment_canary.yaml
    ```
4. Check traffic. 
5. Scale up v2. Apply changes. 
6. Delete v1.