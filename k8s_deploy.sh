#!/bin/bash
# k8s_deploy.sh
# Automate the build and deployment of the Node.js app to k3s in Multipass
# Run this script from your project root on your HOST machine

set -e

# 1. (Optional) Install Multipass and create the k3s VM if not already done
# multipass launch --name k3s --mem 4G --disk 40G
# multipass exec k3s -- bash -c "curl -sfL https://get.k3s.io | sh -"
# multipass exec k3s -- sudo apt-get update && sudo apt-get install -y docker.io

# 2. Build the Docker image inside the VM
multipass transfer . k3s:~/kubernates
multipass exec k3s -- bash -c "cd kubernates && sudo docker build -t node-web-app:latest ."

# 3. Save and import the image into k3s/containerd
multipass exec k3s -- bash -c "cd kubernates && sudo docker save node-web-app:latest -o node-web-app.tar && sudo k3s ctr images import node-web-app.tar"

# 4. Deploy to Kubernetes (apply manifests)
multipass exec k3s -- bash -c "cd kubernates && sudo kubectl apply -f deployment.yaml && sudo kubectl apply -f service.yaml"

# 5. Delete the pod to ensure it uses the imported image
multipass exec k3s -- bash -c "sudo kubectl delete pod -l app=node-web-app || true"

# 6. Wait for the pod to be running
multipass exec k3s -- bash -c "sudo kubectl wait --for=condition=Ready pod -l app=node-web-app --timeout=120s"

# 7. Get the VM's IP address and print access instructions
VM_IP=$(multipass exec k3s -- hostname -I | awk '{print $1}')
echo "\nDeployment complete!"
echo "If your network allows, access your app at: http://$VM_IP:30080"
echo "If not, use port-forwarding:"
echo "multipass exec k3s -- sudo kubectl port-forward service/node-web-app-service 3000:3000"
echo "Then open http://localhost:3000 on your host." 