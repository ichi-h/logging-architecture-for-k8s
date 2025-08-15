{
  description = "logging-architecture-for-k8s";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (final: prev: rec {
            kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
              plugins = with prev.kubernetes-helmPlugins; [
                helm-diff
              ];
            };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            minikube
            kubectl
            kubernetes-helm-wrapped
            helmfile-wrapped
          ];
          shellHook = ''
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

            if ! kubectl get nodes | grep -q "monitoring"; then
              echo "Creating monitoring node..."
              minikube node add --name=monitoring
              kubectl label nodes monitoring app=monitoring
            else
              echo "monitoring node already exists."
            fi
          '';
        };
      }
    );
}
