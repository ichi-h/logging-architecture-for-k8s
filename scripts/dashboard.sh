echo Token: `kubectl -n admin create token admin`
echo URL: https://localhost:8443
kubectl -n admin port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
