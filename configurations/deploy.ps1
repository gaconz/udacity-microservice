## Microservice 
### Create image for each service
docker-compose -f docker-compose-build.yaml build --parallel
### Start application
docker-compose up

# Apply environment variables and secrets
kubectl apply -f aws-secret.yaml
kubectl apply -f env-secret.yaml
kubectl apply -f env-configmap.yaml

# Apply deployments
kubectl apply -f backend-feed-deployment.yaml
kubectl apply -f backend-user-deployment.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f reverseproxy-deployment.yaml

# Apply services
kubectl apply -f backend-feed-service.yaml
kubectl apply -f backend-user-service.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f reverseproxy-service.yaml

Write-Output "All configurations have been applied."

## Check the deployment names and their pod status
kubectl get deployments
## Create a Service object that exposes the frontend deployment
## The command below will ceates an external load balancer and assigns a fixed, external IP to the Service.
kubectl expose deployment frontend --type=LoadBalancer --name=publicfrontend
kubectl expose deployment reverseproxy --type=LoadBalancer --name=publicreverseproxy
## Repeat the process for the *reverseproxy* deployment. 
## Check name, ClusterIP, and External IP of all deployments
kubectl get services 
kubectl get pods # It should show the STATUS as Runnin


## Run these commands from the /udagram-frontend directory
docker build . -t letienlocvn/udagram-frontend:v6
docker push letienlocvn/udagram-frontend:v6
kubectl set image deployment frontend frontend=letienlocvn/udagram-frontend:v6

## Log for each pods
kubectl logs backend-feed-8dd6f44b7-2z4dk

## Create cluster
eksctl create cluster --name myCluster --region=us-east-1 --nodes-min=2 --nodes-max=3
eksctl create cluster --name myCluster --region us-east-1 --nodegroup-name myNodes --node-type m5.large --nodes 1 --nodes-min 1 --nodes-max 2
## Delete node groups
eksctl delete nodegroup --cluster=myCluster --name=my-nodes --region=us-east-1
eksctl delete cluster --name=myCluster --region=us-east-1

## Delete service
kubectl delete service publicfrontend
kubectl delete service reverseproxy
