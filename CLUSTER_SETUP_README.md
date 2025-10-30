# Minikube 2-Node Cluster Setup for Mac

## Why This Script?

I attempted to create a minikube cluster in the remote Linux environment, but encountered several limitations:

1. **Network Restrictions**: The Kubernetes container registry (registry.k8s.io) returned 403 Forbidden errors
2. **Kernel Limitations**: Missing IPv6 tables support and kernel modules
3. **Docker Environment Issues**: The containerized environment doesn't support all features needed for a full Kubernetes cluster

Therefore, I've created a setup script that you can run directly on your Mac.

## Prerequisites

Before running the script, ensure you have:

1. **macOS** with Homebrew installed
2. **Docker Desktop** installed and running
3. At least 4GB RAM available for the cluster
4. At least 20GB disk space

## Installation Instructions

### Option 1: Automated Setup (Recommended)

Run the provided script:

```bash
./setup-minikube-cluster.sh
```

This script will:
- Check for required dependencies (kubectl, minikube)
- Install missing tools via Homebrew
- Create a 2-node minikube cluster
- Verify the cluster is running properly

### Option 2: Manual Setup

If you prefer to run commands manually:

```bash
# Install kubectl and minikube (if not already installed)
brew install kubectl minikube

# Start minikube with 2 nodes
minikube start --nodes 2 --driver=docker --cpus=2 --memory=4096

# Verify the cluster
kubectl get nodes
minikube status
```

## Cluster Configuration

The cluster is configured with:
- **Number of Nodes**: 2 (1 control-plane + 1 worker)
- **Driver**: Docker
- **CPUs**: 2 per node
- **Memory**: 4096MB (4GB)
- **Disk**: 20GB
- **Kubernetes Version**: Latest stable

## Verifying Your Cluster

After setup, verify your cluster:

```bash
# Check nodes
kubectl get nodes

# Check system pods
kubectl get pods -A

# Get cluster info
kubectl cluster-info

# Check minikube status
minikube status
```

You should see 2 nodes in "Ready" status:
- `minikube` (control-plane)
- `minikube-m02` (worker)

## Useful Commands

### Cluster Management
```bash
# Stop the cluster
minikube stop

# Start the cluster again
minikube start

# Delete the cluster
minikube delete

# Open Kubernetes dashboard
minikube dashboard
```

### Add More Nodes
```bash
# Add a third node
minikube node add

# List all nodes
minikube node list
```

### kubectl Basics
```bash
# List all pods
kubectl get pods -A

# List services
kubectl get services -A

# List deployments
kubectl get deployments -A

# Get detailed info about a node
kubectl describe node minikube
```

## Troubleshooting

### Docker Not Running
If you get an error about Docker not running:
1. Open Docker Desktop
2. Wait for it to fully start
3. Run the script again

### Insufficient Resources
If minikube fails to start due to resource constraints:
```bash
# Start with reduced resources
minikube start --nodes 2 --driver=docker --cpus=2 --memory=2048
```

### Port Conflicts
If ports are already in use:
```bash
# Delete existing cluster and try again
minikube delete
minikube start --nodes 2 --driver=docker
```

### Checking Logs
If something goes wrong:
```bash
# View minikube logs
minikube logs

# View detailed logs
minikube logs --file=minikube-logs.txt
```

## Next Steps

Now that your cluster is running, you can:

1. **Deploy an application**:
```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
minikube service hello-minikube
```

2. **Learn kubectl**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

3. **Explore Kubernetes concepts**: https://kubernetes.io/docs/concepts/

## Cleaning Up

When you're done:

```bash
# Stop the cluster (preserves data)
minikube stop

# Delete the cluster completely
minikube delete
```

## Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
