# Reverse proxy configuration for engineering.glasswallsolutions.com

## Requirements

- **Ubuntu LTS** (Tested on Ubuntu 18.04 LTS)*

- **Docker**

- **Docker compose**

- **Git**

> *WSL (Windows Subsystem Linux) is not supported

## Installation

- Execute the following to install the dependencies mentioned above
  
  ```bash
    sudo apt install -y curl git
    curl https://get.docker.com | bash -
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo usermod -aG docker $(whoami)
  ```
  
  You need to logout and re-login after this step

- Prepare the repositories
  
  ```bash
    git clone --recursive https://github.com/k8-proxy/k8-reverse-proxy
    git clone https://github.com/k8-proxy/gp-engineering-website
    wget https://github.com/filetrust/Glasswall-Rebuild-SDK-Evaluation/raw/master/Linux/Library/libglasswall.classic.so -O k8-reverse-proxy/stable-src/c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so
    cp -rf gp-engineering-website/* k8-reverse-proxy/stable-src/
    cd k8-reverse-proxy/stable-src/
  ```

- Generate new SSL credentials
  
  ```bash
    ./gencert.sh
    mv full.pem nginx/
  ```

- Start the deployment    
  
  ```bash
    docker-compose up -d --build
  ```
  
  You will need to use this command after every change to any of the configuration files **gwproxy.env**, **subfilter.sh**, **docker-compose.yaml**, if any.
  
  ## Client configuration

- Add hosts records to your client system hosts file ( i.e **Windows**: C:\Windows\System32\drivers\etc\hosts , **Linux, macOS and  Unix-like:** /etc/hosts ) as follows
  
  ```
  127.0.0.1 engineering.glasswallsolutions.com.glasswall-icap.com gw-demo-sample-files-eu1.s3-eu-west-1.amazonaws.com.glasswall-icap.com
  ```
  
  In case the machine running the project is not your local computer, replace **127.0.0.1** with the project host IP,
  
  make sure that tcp ports **80** and **443** are reachable and not blocked by firewall.
  
  ## Access the proxied site
  
  You can access the proxied site by browsing [engineering.glasswallsolutions.com.glasswall-icap.com](https://engineering.glasswallsolutions.com.glasswall-icap.com) after adding `k8-reverse-proxy/stable-src/server.crt` to your browser/system ssl trust store.
