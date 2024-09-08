#!/bin/bash

# Inclui o arquivo com a função Indexer
source ./src/Indexer/index.sh

# Função para verificar atualizações
checkupdates() {
    local timeout=10
    local update_message

    # Carrega a versão local
    local local_pack
    if [[ -f "package.json" ]]; then
        local_pack=$(jq -r '{version, build_date, build_name}' package.json)
    elif [[ -f "../../../package.json" ]]; then
        local_pack=$(jq -r '{version, build_date, build_name}' "../../../package.json")
    else
        echo "Arquivo package.json não encontrado." >&2
        return 1
    fi

    # Define a mensagem inicial
    update_message=$(systemload colors '[VERSION] ' 'cyan')

    # Obtém a versão remota do package.json
    local remote_pack
    local remote_url="https://raw.githubusercontent.com/KillovSky/Nyx/main/package.json"
    remote_pack=$(curl --max-time "$timeout" -s "$remote_url")

    # Verifica se a requisição foi bem-sucedida
    if [[ $? -ne 0 ]]; then
        echo "Erro ao verificar a versão remota" >&2
        update_message+=$(systemload colors 'GITHUB FILE NOT ABLE FOR VERIFICATION...' 'red')
        echo "$update_message"
        return 1
    fi

    # Converte a resposta para JSON e compara
    local remote_version
    remote_version=$(echo "$remote_pack" | jq -r '.version')
    local remote_build_date
    remote_build_date=$(echo "$remote_pack" | jq -r '.build_date')
    local remote_build_name
    remote_build_name=$(echo "$remote_pack" | jq -r '.build_name')
    local remote_homepage
    remote_homepage=$(echo "$remote_pack" | jq -r '.homepage')
    if [[ "$local_pack" == "$(jq -r '{version, build_date, build_name}' <<< "$remote_pack")" ]]; then
        update_message+=$(systemload colors 'Valeu por me manter atualizada!' 'green')
    else
        update_message+=$(systemload colors 'ATUALIZAÇÃO DISPONÍVEL ' 'red')
        update_message+="→ [$(systemload colors "$remote_version" 'magenta') ~ "
        update_message+="$(systemload colors "${remote_build_name^^}" 'blue') ~ "
        update_message+="$(systemload colors "${remote_build_date^^}" 'yellow')] | "
        update_message+=$(systemload colors "$remote_homepage" 'green')
    fi

    # Printa a mensagem
    echo "$update_message"
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    checkupdates "$@"
}