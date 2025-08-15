docker build -t demoapp ./app/
minikube image load demoapp:latest

kubectl apply -f ./k8s/
