#!/bin/bash

# Faz um 'source' dos arquivos de requisito e da configuração
source ./src/Indexer/index.sh
source ./src/Commands/Cases/index.sh
source ./src/Functions/Config/index.sh

# Constantes
WEBSOCAT_ERRORS_LOG="websocat_errors.log"
RECONNECT_INTERVAL=10

# Função para checar se um comando está instalado
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        systemload colors "Erro: O comando '$cmd' não está instalado. Por favor, instale e tente novamente." "red"
        exit 1
    fi
}

# Verifica os comandos necessários
check_command jq
check_command websocat

# Função para processar mensagens recebidas pelo WebSocket
process_message() {
    local message="$1"
    local printer_message
    printer_message=$(jq -r '.printerMessage // empty' <<< "$message")

    if [[ -n "$printer_message" ]]; then
        systemload colors "$printer_message" "green"
        systemload "$message"
    else
        local is_cmd
        is_cmd=$(jq -r '.isCmd // false' <<< "$message")

        if [[ "$is_cmd" == true ]]; then
            local command
            command=$(jq -r '.command // empty' <<< "$message")
            systemload colors "[MODO LEGADO ~ COMANDO] $command" "yellow"
            systemload "$message"
        else
            local body
            body=$(jq -r '.body // empty' <<< "$message")
            if [[ -z "$body" || "$body" == "null" ]]; then
                local startlog
                startlog=$(jq -r '.startlog // empty' <<< "$message")
                if [[ -z "$startlog" || "$startlog" == "null" ]]; then
                    systemload colors "[STARTLOG OR INVALID] Ignorando..." "yellow"
                    # systemload colors "[RESPOSTA DESCONHECIDA]" "yellow"
                    # systemload colors "$message" "yellow"
                    # Ative se quiser ver os JSONs, porém esteja avisado, se o JSON for gigante pode travar
                else
                    echo "$(systemload colors '[START] ' 'green')$(systemload colors '→ Tudo pronto para começar!' 'yellow')"
                fi
            else
                systemload colors "[MODO LEGADO ~ MENSAGEM] $body" "cyan"
            fi
        fi
    fi
}

# Função para gerenciar a conexão WebSocket
process_websocket() {
    local url="$1"
    local headers="Authorization: Basic $(echo -n "$USERNAME:$PASSWORD" | base64)"

    while true; do
        # Usa rlwrap e websocat para conectar e processar mensagens
        websocat "$url" --header "$headers" --insecure 2>> "$WEBSOCAT_ERRORS_LOG" | while IFS= read -r message; do
            [[ -n "$message" ]] && process_message "$message"
        done

        systemload colors "Conexão WebSocket perdida. Tentando reconectar em $RECONNECT_INTERVAL segundos..." "red"
        sleep "$RECONNECT_INTERVAL"
    done
}

# Função para verificar atualizações em intervalos regulares
update_checker() {
    while true; do
        systemload update
        sleep "$UPDATE_INTERVAL"
    done
}

# Função principal para inicializar o script
initialize() {
    load_config
    update_checker &
    echo "$(systemload colors 'OK!' 'green')"
    process_websocket "$WS_URL"
    wait
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    initialize "$@"
}

# Captura SIGINT (Ctrl+C) e chama a função exit
trap exit SIGINT

# Chamar a função initialize para iniciar o script
initialize
