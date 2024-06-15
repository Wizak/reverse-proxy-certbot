# Reverse Proxy with Nginx and Certbot

This repository contains the necessary files to set up an Nginx reverse proxy with automatic SSL certificate generation and renewal using Certbot. The setup is designed to run on Docker with Docker Compose.

## Prerequisites

- Docker
- Docker Compose
- A domain name pointed to your server

## Structure

```plaintext
reverse-proxy-certbot/
├── certbot-data/
│   ├── www/              # Webroot for Certbot
│   └── conf/             # Configuration files for Certbot and Nginx
├── nginx/
│   ├── Dockerfile        # Dockerfile for building the Nginx image
│   └── nginx.conf.template # Nginx configuration template
├── .env                  # Environment variables file
├── .gitignore            # Files and directories to be ignored by git
├── docker-compose.yml    # Docker Compose configuration
└── run.sh                # Shell script to start the setup
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory and add the following environment variables:

```plaintext
NGINX_SERVER_HOST_DOMAIN=wizak.mooo.com
NGINX_REVERSE_HOST=http://172.16.238.1:81
```

Replace `wizak.mooo.com` with your actual domain and `http://172.16.238.1:81` with your email address.

### Nginx Configuration

The Nginx configuration template (`nginx/nginx.conf.template`) will be used to generate the final configuration file. You can customize this template to suit your needs.

### Docker Compose

The `docker-compose.yml` file defines two services:

- **nginx**: The reverse proxy server.
- **certbot**: The Certbot client to manage SSL certificates.

### Networks

The services are connected through a shared external network called `shared_network`. Ensure this network exists before running the setup:

```sh
docker network create shared_network
```

## Usage

### Build and Start the Containers

Run the `run.sh` script to build the Docker images and start the containers:

```sh
chmod +x run.sh
./run.sh
```

### Create Certificates

Certbot is configured to automatically create the certificates. You can create the certificates manually by running:

```sh
./run.sh init_certs
```

### Renewing Certificates

Certbot is configured to automatically renew the certificates. You can also manually renew them by running:

```sh
./run.sh renew_certs
```

### Accessing the Services

- Your Nginx reverse proxy will be available at `http://yourdomain.com` and `https://yourdomain.com`.
- The SSL certificates will be stored in `certbot-data/conf/`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Docker](https://www.docker.com/)
- [Nginx](https://nginx.org/)
- [Certbot](https://certbot.eff.org/)