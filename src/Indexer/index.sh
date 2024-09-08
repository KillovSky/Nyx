#!/bin/bash

# Diretório base do script
BASE_DIR=$(dirname "$(realpath "$0")")

# Caminhos para symlinks e diretórios
SYMLINKS_PATH="$BASE_DIR/src/Settings/symlinks.json"
FUNCTIONS_DIR="$BASE_DIR/src/Functions"
COMMANDS_DIR="$BASE_DIR/src/Commands"

# Valores padrão para comandos e funções
DEFAULT_COMMAND='Cases'
DEFAULT_FUNCTION='Fallback'
DEFAULT_CALLER='main'

# Faz o 'source' dos arquivos necessários
source "$FUNCTIONS_DIR/Colors/index.sh"
source "$COMMANDS_DIR/Cases/index.sh"
source "$FUNCTIONS_DIR/Config/index.sh"

# Função para carregar symlinks a partir do JSON
load_symlinks() {
    if [[ -f "$SYMLINKS_PATH" ]]; then
        # Usa 'jq' para ler o conteúdo do arquivo JSON de symlinks
        jq -c '.' "$SYMLINKS_PATH"
    else
        # Se o arquivo não existir, retorna um JSON vazio
        echo "{}"
    fi
}

# Função para determinar e carregar o comando ou função apropriado
systemload() {
    local data="$1"
    local command_name=""
    local command_folder=""
    local symlinks_data=""
    local command_path=""

    # Determina o nome do comando a partir dos dados JSON ou string
    if [[ -n "$data" ]]; then
        if [[ "$data" == *"{"* ]]; then
            # Extrai o nome do comando do JSON e converte para minúsculas
            command_name=$(jq -r '.command // empty' <<< "$data" | tr '[:upper:]' '[:lower:]')
            # Se não encontrar o nome do comando, verifica se é um comando
            [[ -z "$command_name" ]] && command_name=$(jq -r '.isCmd // false' <<< "$data")
            # Se ainda estiver vazio, usa o comando padrão
            [[ -z "$command_name" ]] && command_name="$DEFAULT_COMMAND"
        else
            # Converte a string para minúsculas
            command_name=$(tr '[:upper:]' '[:lower:]' <<< "$data")
        fi
    fi

    # Se o nome do comando estiver vazio, usa a função padrão
    [[ -z "$command_name" ]] && command_name="$DEFAULT_FUNCTION"

    # Verifica os diretórios para encontrar o comando ou função
    if [[ -d "$COMMANDS_DIR/$command_name" ]]; then
        command_folder="$COMMANDS_DIR/$command_name"
    elif [[ -d "$FUNCTIONS_DIR/$command_name" ]]; then
        command_folder="$FUNCTIONS_DIR/$command_name"
    else
        # Carrega os dados de symlinks e procura o diretório apropriado
        symlinks_data=$(load_symlinks)

        # Busca o diretório correspondente ao comando e remove possíveis quebras de linha
        command_folder=$(jq -r --arg cmd "$command_name" '
            to_entries[] |
            select(.value.alias[]? | contains($cmd)) |
            .value.place
        ' <<< "$symlinks_data" | tr -d '\r')

        # Verifica se o diretório foi encontrado e resolve o caminho absoluto
        if [[ -n "$command_folder" ]]; then
            command_folder="$(realpath "$BASE_DIR/$command_folder" 2>/dev/null)"
        fi
    fi

    # Se o diretório do comando estiver vazio, usa o comando ou função padrão
    if [[ -z "$command_folder" ]]; then
        if [[ "$data" == *'"isCmd": true'* ]]; then
            command_folder="$COMMANDS_DIR/$DEFAULT_COMMAND"
        else
            command_folder="$FUNCTIONS_DIR/$DEFAULT_FUNCTION"
        fi
    fi

    # Define o caminho do script do comando
    command_path="$command_folder/index.sh"

    if [[ -f "$command_path" ]]; then
        # Faz o 'source' do script do comando
        source "$command_path"
        # Verifica se a função padrão está declarada e a chama
        if declare -f "$DEFAULT_CALLER" &>/dev/null; then
            if [[ "$command_folder" == *"$COMMANDS_DIR"* ]]; then
                "$DEFAULT_CALLER" "$@"
            elif [[ "$command_folder" == *"Fallback"* ]]; then
                "$DEFAULT_CALLER" "$command_name"
                commander "$@"
            else
                "$DEFAULT_CALLER" "${@:2}"
            fi
        else
            # Exibe uma mensagem de erro se a função não for encontrada
            echo "Function '$DEFAULT_CALLER' not found in $command_path" >&2
        fi
    else
        # Exibe uma mensagem de erro se o arquivo do módulo não for encontrado
        echo "Module file not found at $command_path" >&2
        exit 1
    fi
}
