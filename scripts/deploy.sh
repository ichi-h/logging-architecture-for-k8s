docker build -t demoapp ./app/
minikube image load demoapp:latest

helmfile apply

kubectl apply -f ./k8s/
