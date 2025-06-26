# Node Web App (Kubernetes Assignment)

This is a simple Node.js web application using Express, designed to demonstrate deployment with Docker Compose and Kubernetes.

## Project Structure
- `index.js` - Main application file (Express server)
- `package.json` - Node.js dependencies and scripts
- `Dockerfile` - Docker image build instructions
- `docker-compose.yml` - Docker Compose configuration
- `deployment.yaml` - Kubernetes Deployment manifest (to be created)
- `service.yaml` - Kubernetes Service manifest (to be created)

## Running Locally (Node.js)
```bash
npm install
npm start
```
Visit [http://localhost:3000](http://localhost:3000)

## Running with Docker Compose
```bash
docker-compose up
```
Visit [http://localhost:3000](http://localhost:3000)

## Deploying to Kubernetes
1. Build the Docker image for your local Kubernetes cluster (e.g., Minikube):
   ```bash
   eval $(minikube docker-env)
   docker build -t node-web-app:latest .
   ```
2. Apply the manifests:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```
3. Access the app:
   ```bash
   minikube service node-web-app-service
   ```

## License
MIT
