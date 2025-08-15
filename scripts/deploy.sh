docker build -t demoapp ./app/
kind load docker-image demoapp:latest

kubectl apply -f ./k8s/

helmfile apply
