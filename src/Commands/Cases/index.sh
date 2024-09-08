#!/bin/bash

# Carrega as configurações e funções necessárias
source ./src/Functions/Config/index.sh
source ./src/Functions/Kill/index.sh

# Função principal para executar comandos com base nos parâmetros fornecidos
commander() {
    local env="$1"

    # Verifica se a variável env é uma string JSON válida
    if jq -e . >/dev/null 2>&1 <<< "$env"; then
        # Obtém parâmetros necessários do JSON
        local chatid=$(jq -r '.chatId' <<< "$env")
        local isowner=$(jq -r '.isOwner' <<< "$env")
        local iscmd=$(jq -r '.isCmd' <<< "$env")
        local reply=$(jq -r '.reply' <<< "$env")
        local arg=$(jq -r '.arg' <<< "$env")
        local command=$(jq -r '.command' <<< "$env")

        # Se não for comando, define a mensagem como comando, para sistema de No-Prefix
        if [[ "$iscmd" == false ]]; then
            command=$(jq -r '.body // ""' <<< "$env")
        fi

        # Define a ação com base no comando
        case "$command" in
            # Testes de comando sem prefixo
            *"bashtest123+@"* | *"bash test 123 +@"* | *"BASH TEST 123 +@"*)
                # Envia a mensagem e retorna os dados dela
                sendmessage "$chatid" '{"text": "✔️ OK!"}' "$reply" false
                return 0
                ;;

            # Se for comando de eval
            'evalsh')
                if [[ "$isowner" == true && "$iscmd" == true ]]; then
                    # Usa eval para executar o código (atenção com segurança)
                    eval "$arg"
                fi
                ;;

            # Se for comando de eval
            'runcode')
                if [[ "$isowner" == true && "$iscmd" == true ]]; then
                    # Usa eval para executar o código e captura a saída
                    result=$(eval "$arg" 2>&1)  # Captura tanto a saída padrão quanto a saída de erro

                    # Envia o resultado como texto usando sendmessage
                    sendmessage "$chatid" "$(jq -n --arg text "$result" '{text: $text}')" "$reply" false
                fi
                ;;

            # Se for comando e tiver permissão de uso raw
            *)
                if [[ "$iscmd" == true && "$CASES_ENABLED" == true ]]; then
                    # Envia a mensagem como raw e retorna os dados dela
                    response=$(sendraw "$chatid" '{"text": "Esse comando não existe ainda!"}' "$reply" false)
                    echo "$response"
                    return 0
                fi
                ;;
        esac
    else
        echo "Erro: env deve ser um JSON válido." >&2
        return 1
    fi
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    commander "$@"
}