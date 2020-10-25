# Reverse proxy configuration for engineering.glasswallsolutions.com

## Requirements

- **Ubuntu LTS** (Tested on Ubuntu 18.04 LTS)*

- **Docker**

- **Docker compose**

- **Git**

> *WSL (Windows Subsystem Linux) is not supported

## Preparing environment

- Execute the following to install the dependencies mentioned above
  
  ```bash
    sudo apt install -y curl git
    curl https://get.docker.com | bash -
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    usermod -aG docker $(whoami)
  ```

- Prepare the repositories
  
  ```bash
    git clone --recursive https://github.com/k8-proxy/k8-reverse-proxy
    git clone https://github.com/k8-proxy/gp-engineering-website
    wget https://github.com/filetrust/Glasswall-Rebuild-SDK-Evaluation/raw/master/Linux/Library/libglasswall.classic.so -O k8-reverse-proxy/stable-src/c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so
    cp -rf gp-engineering-website/<path to this source code directory>/* k8-reverse-proxy/stable-src/
    cd k8-reverse-proxy/stable-src/
  ```

- Generate new SSL credentials
  
  ```bash
    ./gencert.sh
    docker-compose up -d
  ```

- Add hosts records to your system hosts file as follows
  
  ```
  127.0.0.1 engineering.glasswallsolutions.com.glasswall-icap.com gw-demo-sample-files-eu1.s3-eu-west-1.amazonaws.com.glasswall-icap.com
  ```
  
  In case the machine running the project is not your local computer, replace **127.0.0.1** with the project host IP,
  
  make sure that tcp ports 80 and 443 are reachable and not blocked by firewall.


