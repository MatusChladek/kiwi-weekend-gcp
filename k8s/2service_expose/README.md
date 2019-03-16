### Expose Service
1. Change Kuard service type - `type: LoadBalancer`. Deploy service. LoadBalancer will be created automatically. Check GCP console.
    ```
    kubectl apply -f service.yaml
    watch kubectl get svc --namespace=kuard
    ```
2. If you have another HTTP/HTTPS service and you need to expose it, you will spin up another Load Balancer. It's not resurce efficient. Let's check it. Deploy and expose dummy app. Check GCP console LBs.
    ```
    kubectl apply -f deployment_dummy.yaml
    kubectl apply -f service_dummy.yaml
    watch kubectl get svc --namespace=kuard
    ```
3. Let's move dummy and Kuard services to `type: NodePort`.
    ```
    kubectl apply -f service.yaml
    kubectl apply -f service_dummy.yaml
    kubectl get svc --namespace=kuard
    ```
4. Lets create ingress. We will use default GKE ingress controller - `gce-ingress-controller`. Solution from the box :) It will automatically create a L7 Load Balancer, and all the rules will be aplied to that balancer.
    ```
    kubectl apply -f ingress_gce.yaml
    kubectl get ingress --namespace=kuard
    ```
5. Copy the LB IP address and open in the browser. You should see Kuard app.
6. Let's associate STATIC_IP (that we creted via terraform) with our LoadBalancer. It will take some time.
 - Add this annotation to ingress. Apply changes.
    ```
    kind: Ingress
    metadata:
      annotations:
        kubernetes.io/ingress.global-static-ip-name: "cloudweekend"
      name: kuard-ingress
    ```
7. Lets access our app via DNS name. nip.io - free DNS. 
 - Change ingress spec as below. And apply changes
    ```
    spec:
      rules:
      - host: kuard.STATIC_IP.nip.io
        http:
          paths:
          - path: /*
            backend:
              serviceName: kuard
              servicePort: 80
    ```
 - Connect to kuard app `kuard.STATIC_IP.nip.io` from browser.


