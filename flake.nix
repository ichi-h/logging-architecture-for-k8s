{
  description = "logging-architecture-for-k8s";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            minikube
            kubectl
            kubernetes-helm
          ];
          shellHook = ''
            if ! minikube status | grep -q "Running"; then
              echo "Starting minikube..."
              minikube start
            else
              echo "Minikube is already running."
            fi

            if ! minikube addons list | grep -q "dashboard.*enabled"; then
              echo "Enabling Kubernetes Dashboard..."
              minikube addons enable dashboard
            else
              echo "Kubernetes Dashboard is already enabled."
            fi

            if ! minikube addons list | grep -q "metrics-server.*enabled"; then
              echo "Enabling Metrics Server..."
              minikube addons enable metrics-server
            else
              echo "Metrics Server is already enabled."
            fi
          '';
        };
      }
    );
}
