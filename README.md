# Node Web App on Kubernetes (k3s/Multipass)

This project is a simple Node.js web application using Express, designed to demonstrate how to deploy a containerized app to a local Kubernetes cluster (k3s) running in a Multipass VM. You will learn how to go from a Docker Compose setup to Kubernetes manifests, build and import images, and expose your app for browser access.

---

## Project Structure
- `index.js` - Main application file (Express server)
- `package.json` - Node.js dependencies and scripts
- `Dockerfile` - Docker image build instructions
- `docker-compose.yml` - Docker Compose configuration (for reference)
- `deployment.yaml` - Kubernetes Deployment manifest
- `service.yaml` - Kubernetes Service manifest

---

## Prerequisites
- [Multipass](https://multipass.run/) installed
- [k3s](https://k3s.io/) running in a Multipass VM (named `k3s`)
- Docker installed in the VM
- `kubectl` aliased to run inside the VM (as in this guide)

---

## Running Locally (Node.js)
```bash
npm install
npm start
```
Visit [http://localhost:3000](http://localhost:3000)

---

## Building and Deploying to Kubernetes (k3s/Multipass)

### 1. **Build the Docker Image in the VM**
Copy your project files into the VM:
```bash
multipass transfer /path/to/your/project k3s:
```
Open a shell in the VM:
```bash
multipass shell k3s
cd kubernates
```
Build the Docker image:
```bash
sudo docker build -t node-web-app:latest .
```

### 2. **Import the Image into k3s (containerd)**
```bash
sudo docker save node-web-app:latest -o node-web-app.tar
sudo k3s ctr images import node-web-app.tar
```

### 3. **Deploy to Kubernetes**
```bash
sudo kubectl apply -f deployment.yaml
sudo kubectl apply -f service.yaml
```

### 4. **Restart the Pod (if needed)**
If you see `ErrImageNeverPull`, delete the pod to force Kubernetes to use the imported image:
```bash
sudo kubectl delete pod -l app=node-web-app
```

### 5. **Check Status**
```bash
sudo kubectl get pods
sudo kubectl get services
```
Wait until the pod is `Running` and the service is available.

### 6. **Access the App in Your Browser**
Get the VM's IP address:
```bash
hostname -I
```
Visit in your browser (from your host machine):
```
http://<VM_IP>:30080
```
If direct access doesn't work, use port forwarding:
```bash
sudo kubectl port-forward service/node-web-app-service 3000:3000
```
Then visit:
```
http://localhost:3000
```

---

## Troubleshooting
- If you see `ErrImageNeverPull`, make sure you have imported the image into k3s/containerd and deleted the old pod.
- If you cannot access the app via NodePort, use port forwarding as shown above.
- If `kubectl` says files do not exist, ensure you are running commands in the correct environment (inside the VM if using Multipass/k3s).

---

## License
MIT