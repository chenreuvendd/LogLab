#!/bin/bash
set -e

echo "=== Setting up a Minikube cluster with 2 nodes on your Mac ==="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install it first:"
    echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Installing Docker Desktop..."
    echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    echo "After installation, start Docker Desktop and re-run this script."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

echo "✓ Docker is installed and running"

# Install kubectl if not present
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    brew install kubectl
fi
echo "✓ kubectl is installed"

# Install minikube if not present
if ! command -v minikube &> /dev/null; then
    echo "Installing minikube..."
    brew install minikube
fi
echo "✓ minikube is installed"

# Delete existing cluster if any
echo ""
echo "Cleaning up any existing minikube clusters..."
minikube delete 2>/dev/null || true

# Create a new minikube cluster with 2 nodes
echo ""
echo "Creating minikube cluster with 2 nodes..."
echo "This may take a few minutes..."
minikube start \
    --nodes 2 \
    --driver=docker \
    --cpus=2 \
    --memory=4096 \
    --disk-size=20g \
    --kubernetes-version=stable

# Wait for the cluster to be ready
echo ""
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=ready node --all --timeout=300s

# Display cluster information
echo ""
echo "=== Cluster Information ==="
kubectl cluster-info
echo ""
echo "=== Nodes ==="
kubectl get nodes -o wide
echo ""
echo "=== Cluster Status ==="
minikube status
echo ""
echo "✓ Minikube cluster with 2 nodes is ready!"
echo ""
echo "You can now interact with your cluster using kubectl commands."
echo ""
echo "Useful commands:"
echo "  - kubectl get nodes        # List all nodes"
echo "  - kubectl get pods -A      # List all pods in all namespaces"
echo "  - minikube dashboard       # Open Kubernetes dashboard"
echo "  - minikube stop            # Stop the cluster"
echo "  - minikube delete          # Delete the cluster"
echo ""
