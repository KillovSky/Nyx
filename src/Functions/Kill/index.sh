#!/bin/bash

# Carrega as configurações
source ./src/Functions/Config/index.sh

# Função para enviar uma requisição POST
postmessage() {
    local url="$1"
    local data="$2"
    local timeout="${3:-10}"

    # Envia a requisição POST usando curl
    response=$(curl --insecure --silent --write-out "HTTPSTATUS:%{http_code}" \
        --request POST \
        --url "$url" \
        --header "Content-Type: application/json" \
        --data "$data" \
        --max-time "$timeout")
    
    # Divide a resposta e o código de status
    http_response=$(echo "$response" | sed -e 's/HTTPSTATUS\:.*//g')
    http_code=$(echo "$response" | sed -e 's/.*HTTPSTATUS://')

    # Verifica se o código de status é 2xx
    if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
        echo "$http_response"
    else
        echo "Erro: Código de status HTTP $http_code" >&2
        echo "$http_response" >&2
        return 1
    fi
}

# Função para enviar uma mensagem personalizada via requisição POST
sendraw() {
    local json_data="$1"

    # Obtém a URL do servidor
    local url="$POST_URL"

    # Envia a requisição POST e obtém a resposta
    postmessage "$url" "$json_data"
}

# Função para enviar uma mensagem via requisição POST
sendmessage() {
    local chatid="$1"
    local msg="$2"
    local quoted="$3"
    local code="$4"

    # Verifica se os parâmetros necessários estão presentes
    if [[ -z "$chatid" || -z "$msg" ]]; then
        echo "Erro: 'chatid' e 'msg' são obrigatórios" >&2
        return 1
    fi

    # Converte `msg` e `quoted` para JSON aninhado apenas se necessário
    # `msg` e `quoted` são esperados como JSON válidos diretamente
    # Portanto, não deve ser necessário envolver `msg` e `quoted` novamente em um objeto
    msg_json=$(echo "$msg" | jq -c .)  # Converte msg para JSON, se necessário
    quoted_json=$(echo "$quoted" | jq -c .)  # Converte quoted para JSON, se necessário

    # Cria o JSON a ser enviado
    json_data=$(jq -n \
        --arg username "$USERNAME" \
        --arg password "$PASSWORD" \
        --argjson message "$msg_json" \
        --argjson quoted "$quoted_json" \
        --arg code "$code" \
        --arg chatId "$chatid" \
        '{username: $username, password: $password, message: $message, quoted: $quoted, code: $code, chatId: $chatId}')
    
    # Envia a mensagem personalizada
    sendraw "$json_data"
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    sendmessage "$@"
}