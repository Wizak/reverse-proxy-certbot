#! /bin/bash

export PROJECT_NAME='reverse-proxy-certbot'

function show_commands() {
    echo "Available commands: '$1'"
    printf '\r\n'
    printf '    '
    printf '%s\n    ' "${commands[@]}"
    printf '\r\n'
}

function docker_compose() {
    docker-compose \
        --project-name $PROJECT_NAME \
        -f "docker-compose.yml" \
        --env-file .env \
        $@
}

function logs() {
    docker_compose logs --follow $@
}


function init_build() {
    docker_compose build $@
}

function init_start() {
    docker_compose up --build -d $@
}

function stop() {
    docker_compose down $@
}

function rebuild() {
    init_build backend
    init_build $@
}

function restart() {
    docker_compose down --volumes --remove-orphans
    docker image prune --force
    docker_compose up -d
}

function init_certs() {
    source .env
    docker_compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --cert-name certs -d $NGINX_SERVER_HOST_DOMAIN -v $@
}

function init_certs_test() {
    init_certs --dry-run
}

function renew_certs() {
    docker_compose run --rm certbot renew
    restart
}

commands=(
    logs docker_compose 
    init_build init_start stop rebuild restart
    init_certs init_certs_test renew_certs
)

if [[ $# -gt 0 ]] && [[ "${commands[@]}" =~ "$1" ]]; then
    $@;
else
    show_commands $MODE "$commands"
fi
