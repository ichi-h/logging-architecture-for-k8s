echo Token: `kubectl -n kubernetes-dashboard create token admin`
echo URL: https://localhost:8443
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
