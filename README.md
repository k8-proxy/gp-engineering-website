# Reverse proxy configuration for engineering.glasswallsolutions.com

## Requirements

- **Ubuntu LTS** (Tested on Ubuntu 18.04 LTS)*

- **Docker**

- **Docker compose**

- **Git**

> *WSL (Windows Subsystem Linux) is not supported

## Preparation

We needed to check the website requests to check domains of interest, (domains that should be proxied), which typically are:

- Website main domain and www subdomain (if applicable)

- Domains used in redirects between website pages (example: authentication redirections)

- Domains that hosts files that should be rebuilt against Glasswall rebuild engine

### Finding domains of interest

- Open a browser that included dev tools (i.e : **Mozilla Firefox**)

- Open dev tools and switch to **Network** tab (CTRL+SHIFT+E in **Firefox**)

- Visit target website main page, surf the website and try to download files while watching requested domains 

- Save domains in question to be used in configuration

### Configuration

Use [this configuration file](https://github.com/k8-proxy/k8-reverse-proxy/blob/master/stable-src/gwproxy.env) as example

- `ROOT_DOMAIN`: Domain used by the proxy (example: www.gov.uk.glasswall-icap.com is proxying www.gov.uk) 

- `ALLOWED_DOMAINS` : Comma separated domains accepted by the proxy, typically this should be domains of interest with the `ROOT_DOMAIN` value appended

- `SQUID_IP` IP address of squid proxy, used by nginx, should be only changed on advanced usage of the docker image (example: Kubernetes)

- `SUBFILTER_ENV`: Space separated text substitution rules in response body, foramtted as **match,replace** , used for url rewriting as in **.gov.uk,.gov.uk.glasswall-icap.com**

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
    wget https://github.com/filetrust/sdk-rebuild-eval/raw/master/libs/rebuild/linux/libglasswall.classic.so -O k8-reverse-proxy/stable-src/c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so
    cp -rf gp-engineering-website/* k8-reverse-proxy/stable-src/
    cd k8-reverse-proxy/stable-src/
  ```

- Tweak `openssl.cnf` to include domains of interest in **alt_names** section

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
