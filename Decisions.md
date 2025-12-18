# Architectural Decisions

### 1. Variables and Default Values
- **`project_name`**: Used to prefix all Docker resources (containers, networks, volumes). This prevents naming conflicts if multiple instances of the infrastructure are deployed on the same host.
- **`host_port` (8080)**: Chosen to allow running the project without `sudo` privileges (binding to port 80 usually requires root) and to avoid conflicts with existing web servers on the host machine.
- **`app_env`**: Exposed to demonstrate configuration injection. It allows switching application behavior (e.g., debug modes) without rebuilding container images.

### 2. Nginx and PHP-FPM Connection (TCP vs Socket)
- **Decision**: TCP connection (`fastcgi_pass php-fpm:9000`).
- **Reasoning**: While Unix sockets are slightly faster, they require sharing a filesystem socket file between containers via a volume, which can introduce permission issues. TCP is the standard for container-to-container communication, offering better scalability (containers can be on different nodes in the future) and simpler network isolation configuration via Docker networks.

### 3. Ansible Idempotency
- **Implementation**: I utilized the Ansible `template` module for generating configurations.
- **Mechanism**: The `template` module calculates the checksum of the destination file. If the rendered template (based on current variables) matches the existing file on the disk, Ansible skips the action. This ensures that re-running the playbook produces `changed=0` if no variables have been modified.

### 4. Health Check Strategy (`/healthz`)
- **Mechanism**: The `/healthz` endpoint in Nginx is configured to proxy the request to PHP-FPM, which executes a specific PHP script returning JSON.
- **Goal**: This serves as an **end-to-end (E2E) check**. It confirms that:
    1. The Nginx container is running and accepting connections.
    2. The PHP-FPM container is running.
    3. The network link between Nginx and PHP-FPM is functioning correctly.
    4. The application code is readable and executable.

### 5. Future Improvements
- **Security**: Implement running containers as non-root users and enable HTTPS using Let's Encrypt or self-signed certificates.
- **Monitoring**: Add a Prometheus exporter sidecar to scrape metrics from Nginx and PHP-FPM.
- **Scalability**: Migrate from the Terraform Docker provider to a Kubernetes manifest (or Helm chart) or Docker Compose for easier local development experience without Terraform state management overhead.
