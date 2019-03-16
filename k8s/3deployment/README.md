### Extend Deployment
1. Scale our pods to 10 replicas.
    ```
    kubectl apply -f deployment.yaml && watch kubectl get pods --namespace=kuard
    ```
2. Lets add Deployment strategy `RollingUpdate` to our deployment.
  - Add following to the `spec` section.
    ```
    spec:
      replicas: 10
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxSurge: 2
          maxUnavailable: 1
    ```
 - Update image
    ```
    image: gcr.io/kuar-demo/kuard-amd64:green
    ```
 - Apply changes
    ```
    kubectl apply -f deployment.yaml && watch kubectl get pods --namespace=kuard
    ```
3. Add probes to our application. 
    ```yaml
        spec:
          containers:
          - name: kuard
            image: gcr.io/kuar-demo/kuard-amd64:green
            ports:
            - containerPort: 8080
            readinessProbe:
              httpGet:
                path: /ready
                port: 8080
              initialDelaySeconds: 1
              periodSeconds: 1
              failureThreshold: 1
              successThreshold: 1
            livenessProbe:
              httpGet:
                path: /healthy
                port: 8080
              initialDelaySeconds: 1
              timeoutSeconds: 1
              periodSeconds: 1
              failureThreshold: 1
    ```
 - Deploy and watch the pods behaviour
    ```
    kubectl apply -f deployment.yaml && watch kubectl get pods --namespace=kuard
    ```
4. Rollback to the previous version and fix the probes.
    ```
    kubectl rollout undo deployment.v1.apps/kuard --namespace=kuard
    ```
 - Let's adjust probes and deploy. Play with probes in Kuard app
    ```yaml
          # Pod must be ready, before Kubernetes start sending traffic to it
            readinessProbe:
              httpGet:
                path: /ready
                port: 8080
              # Check is done every 2 seconds starting as soon as the pod comes up
              periodSeconds: 2
              # Start checking once pod is up
              initialDelaySeconds: 2
              # If three successive checks fail, then the pod will be considered not ready.
              failureThreshold: 3
              # If only one check succeeds, then the pod will again be considered ready.
              successThreshold: 1
            livenessProbe:
              httpGet:
                path: /healthy
                port: 8080
              # Start probe 5 seconds after all the containers in the Pod are created
              initialDelaySeconds: 5
              # The response must be max in 1 second and status HTTP code must be between 200 and 400
              timeoutSeconds: 1
              # Repeat every 10 seconds
              periodSeconds: 10
              # If more than 3 probes failed - the container will fail + restart
              failureThreshold: 3
    ```
5. Resource limits are very important in k8s, you have more control over application and know it's behaviour. 
```
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: kuard
        image: gcr.io/kuar-demo/kuard-amd64:blue
        resources:
          requests:
            memory: "128Mi"
            cpu: "200m"
          limits:
            memory: "256Mi"
            cpu: "300m"
```
6. Deploy HPA
```
kubectl apply -f hpa.yaml
```