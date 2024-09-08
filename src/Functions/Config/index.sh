#!/bin/bash

# Constantes
CONFIG_FILE="src/Settings/config.json"

# Função para carregar configurações de um arquivo JSON
load_config() {
    # Verifica se o arquivo de configuração existe
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Erro: Arquivo de configuração não encontrado: $CONFIG_FILE" >&2
        exit 1
    fi

    # Carrega as configurações usando jq
    WS_URL=$(jq -r '.WebSocket.value' "$CONFIG_FILE")
    USERNAME=$(jq -r '.Auth.username' "$CONFIG_FILE")
    PASSWORD=$(jq -r '.Auth.password' "$CONFIG_FILE")
    POST_URL=$(jq -r '.PostRequest.value' "$CONFIG_FILE")
    CASES_ENABLED=$(jq -r '.Cases.value' "$CONFIG_FILE")
    UPDATE_INTERVAL=$(jq -r '.UpdateInterval.value' "$CONFIG_FILE")

    # Verifica se todas as configurações foram carregadas corretamente
    if [[ -z "$WS_URL" || -z "$USERNAME" || -z "$PASSWORD" || -z "$UPDATE_INTERVAL" ]]; then
        echo "Erro: Falha ao carregar as configurações. Verifique o arquivo de configuração." >&2
        exit 1
    fi

    # Exporta as variáveis para que possam ser usadas globalmente
    export WS_URL
    export USERNAME
    export PASSWORD
    export POST_URL
    export CASES_ENABLED
    export UPDATE_INTERVAL
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    load_config "$@"
}

# Chama a função para carregar as configurações
load_config
