This folder contains necessary configurations (using yaml manifests) for deploying a nginx ingress controller on a Kubernetes cluster. 
The ingress controller is essential for managing access to services within the cluster, allowing to route traffic based on defined rules.

Prerequisites:
- A Kubernetes cluster is already set up and running.
- kubectl is installed and configured to interact with the cluster.
- An app/service is already deployed in the cluster that you want to expose via the ingress controller. (this guide provides an alternative image below)
- Firewall rules are configured to allow traffic on the necessary ports (80 and 443) - this is in case the service exposed by the ingress controller is exposed to the internet.

Folder Structure:
- 'deployment.yaml': Contains the deployment configuration for the nginx ingress controller. (points to an image supported by the Kubernetes community)
- 'service.yaml': Defines the service that exposes the ingress controller, allowing it to receive external traffic. Note that this service is of type LoadBalancer, which will provision an external load balancer in cloud environments.
- 'ingressclass.yaml': Defines the ingress class for the nginx ingress controller. Note that the ingress class should match the one used in the ingress.yaml
- 'ingress.yaml': Contains the ingress resource configuration. This is the "rule" that the ingress controller will evaluate. Use your app's port here
- 'rbac.yaml': Defines a service account which is later associated to necessary roles (these are namespace based) and cluster roles (namespace independent) to allow the ingress controller to function properly.
- 'namespace.yaml': Creates a namespace for the ingress controller to run in.

Steps to Deploy:
1. Make sure to point to the desired Kubernete cluster
2. if no app is deployed, you can use the following command to deploy a sample app:
    ```bash
    kubectl create deployment demo --image=httpd --port=80
    kubectl expose deployment demo
    ```
   This creates a simple httpd deployment and expose it internally within the cluster.
3. If you already have an app deployed, make sure to use that app's service name in the `ingress.yaml` file under the `backend` section. Replace `demo` with your app's service name.
4. Apply in following order:
    ```bash
    kubectl apply -f namespace.yaml
    kubectl apply -f rbac.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    kubectl apply -f ingressclass.yaml
    kubectl apply -f ingress.yaml
    ```
Verify the deployment:
1. Check the ingress resource to ensure it is created and has the correct rules
2. Verify the ingress controller is running and the service is created:
    ```bash
    kubectl get pods -n <your namespace>
    kubectl get svc -n <your namespace>
    ```
3. Obtain the external IP of the ingress controller service and try to access the app by using it.
