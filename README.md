# logging-architecture-for-k8s

## Technology Stack

- Container
  - Docker
- Orchestration
  - Kubernetes (minikube)
- Demo Application
  - Golang
- Log Collection
  - Vector
- Log Storage and Query
  - Loki
- System Monitoring
  - Prometheus
- Dashboard
  - Grafana
- Object Storage
  - MinIO

## Directory Structure

```
/
├── README.md
├── app/                # Demo application source code
├── vector/             # vector settings
├── loki/               # Loki settings
├── prometheus/         # Prometheus settings
├── grafana/            # Grafana settings
├── minio/              # MinIO settings
├── k8s/                # Kubernetes manifests (deployment, DaemonSet, etc. for each component)
└── scripts/            # Verification and setup scripts
```

## Architecture Diagram

```mermaid
graph TD
  subgraph MonitoringNode
    Grafana
    Prometheus
    Loki
    MonVector["Vector (DaemonSet)"]
  end

  subgraph AppNode
    App
    AppVector["Vector (DaemonSet)"]
  end

  subgraph StorageNode
    MinIO
    StorVector["Vector (DaemonSet)"]
  end

  %% Log flow
  App -->|stdout/stderr| AppVector -->|push logs| Loki
  Grafana -->|stdout/stderr| MonVector -->|push logs| Loki
  Prometheus -->|stdout/stderr| MonVector
  Loki -->|stdout/stderr| MonVector
  MinIO -->|stdout/stderr| StorVector -->|push logs| Loki

  %% Metrics flow
  Prometheus -->|pull metrics| AppVector
  Prometheus -->|pull metrics| MonVector
  Prometheus -->|pull metrics| StorVector

  %% Query
  Grafana -->|query logs| Loki
  Grafana -->|query metrics| Prometheus

  %% Store
  Loki -->|store logs| MinIO
  Prometheus -->|store metrics| MinIO
```
