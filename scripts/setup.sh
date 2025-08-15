# minikube

if ! minikube status | grep -q "Running"; then
  echo "Starting minikube..."
  minikube start
else
  echo "minikube is already running."
fi

if ! minikube addons list | grep -q "dashboard.*enabled"; then
  echo "Enabling dashboard..."
  minikube addons enable dashboard
else
  echo "dashboard is already enabled."
fi

if ! minikube addons list | grep -q "metrics-server.*enabled"; then
  echo "Enabling metrics-server..."
  minikube addons enable metrics-server
else
  echo "metrics-server is already enabled."
fi

# helm

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "Creating monitoring namespace..."
kubectl create namespace monitoring

echo "Installing Grafana Loki..."
helm install loki -n monitoring grafana/loki \
  --set minio.enabled=true \
  --set write.replicas=1 \
  --set read.replicas=1 \
  --set backend.replicas=1 \
  --set loki.auth_enabled=false \
  --set loki.commonConfig.replication_factor=1 \
  --set loki.useTestSchema=true

echo "Installing Grafana..."
helm install grafana -n monitoring grafana/grafana --set service.type=LoadBalancer
