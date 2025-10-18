# Docker Commands Cheat Sheet

A clean, organized, and corrected version of `Docker_command.txt`. Commands are grouped by topic with brief notes and PowerShell-friendly examples.

## Images

- Pull latest image
  - `docker pull IMAGE`
- Pull specific version (tag)
  - `docker pull IMAGE:TAG`
- List images
  - `docker images`
- Remove an image
  - `docker rmi IMAGE|IMAGE_ID`

## Containers: Create, Run, Manage

- Create and start a new container
  - `docker run IMAGE`
- Interactive terminal
  - `docker run -it IMAGE`
    - `-i` keep STDIN open, `-t` allocate a pseudo-TTY
- Run in detached (background) mode
  - `docker run -d IMAGE`
- Name the container
  - `docker run --name CONTAINER_NAME IMAGE`
- Set environment variables
  - `docker run -e KEY=VALUE IMAGE`
- Port mapping (host:container)
  - `docker run -p HOST_PORT:CONTAINER_PORT IMAGE`
  - Example: `docker run -p 8080:3306 IMAGE`  
    Binds host port 8080 to container port 3306
- List containers
  - Running only: `docker ps`
  - All (including stopped): `docker ps -a`
- Start/Stop existing container
  - `docker start CONTAINER_NAME|ID`
  - `docker stop CONTAINER_NAME|ID`
- Remove a container
  - `docker rm CONTAINER_NAME|ID`
- View logs
  - `docker logs CONTAINER_NAME|ID`
  - Follow logs: `docker logs -f CONTAINER_NAME|ID`
- Exec into a running container
  - Bash: `docker exec -it CONTAINER_NAME|ID /bin/bash`
  - sh: `docker exec -it CONTAINER_NAME|ID /bin/sh`

## Networking

- List networks
  - `docker network ls`
- Create a network
  - `docker network create NETWORK_NAME`
- Run a container on a specific network
  - `docker run --network NETWORK_NAME IMAGE`

### Example: MongoDB + Mongo Express

- Create a user-defined bridge network (optional but recommended):
  - `docker network create mongo-network`
- Run MongoDB (root user/pass: admin/qwerty):
  - `docker run -d -p 27017:27017 --name mongo --network mongo-network -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=qwerty mongo`
- Run Mongo Express (connects to the MongoDB above):
  - `docker run -d -p 8081:8081 --name mongo-express --network mongo-network -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty -e ME_CONFIG_MONGODB_URL="mongodb://admin:qwerty@mongo:27017" mongo-express`

Notes:

- On Windows PowerShell, prefer double quotes for env values and URLs.

## Docker Compose

- Containers in a Compose project share a default network.
- Use a compose file (e.g., `compose.yaml` or `filename.yaml`).

Common commands:

- Up (create and start)
  - `docker compose -f filename.yaml up -d`
- Down (stop and remove)
  - `docker compose -f filename.yaml down`
- View compose services/containers
  - `docker compose -f filename.yaml ps`
- View compose logs
  - `docker compose -f filename.yaml logs -f`

## Dockerfile Essentials

Key instructions (in typical order):

- `FROM` — base image
- `ENV` — environment variables
- `WORKDIR` — working directory
- `RUN` — run build-time commands (install deps, etc.)
- `COPY` — copy files from host into image
- `CMD` — default container command (runtime)
- `EXPOSE` — documentation of container port(s) (does not publish by itself)

Build an image from a Dockerfile in the current directory:

- `docker build -t NAME:TAG .`

## Push/Pull with Registries

- Login to a registry (e.g., Docker Hub)
  - `docker login`
- Tag and push an image
  - `docker push NAME:TAG`

## Volumes and Storage

Volumes persist data beyond the lifecycle of a container.

- List volumes
  - `docker volume ls`
- Create a named volume
  - `docker volume create VOLUME_NAME`
  - Default location (Windows): `C:\\ProgramData\\docker\\volumes`
- Remove a volume
  - `docker volume rm VOLUME_NAME`
- Remove all unused volumes
  - `docker volume prune`

Mount types with `docker run -v ...`:

- Named volume
  - `docker run -v VOLUME_NAME:/container/path IMAGE`
- Anonymous volume
  - `docker run -v /container/path IMAGE`
- Bind mount (host directory -> container path)
  - Windows example (quote paths with spaces):
    - `docker run -v "C:\\host\\dir":/container/path IMAGE`

## Handy Tips

- `EXPOSE` documents ports; use `-p HOST:CONTAINER` to publish.
- Use `docker logs -f` to tail logs in real time.
- Prefer user-defined bridge networks for multi-container apps.
