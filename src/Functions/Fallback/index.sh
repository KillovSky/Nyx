#!/bin/bash

# Módulo de fallback onde caem as requisições que não tem função projetada.

fallback() {
    local func_local="$1"

    # Verifica se o nome da função foi fornecido
    if [[ -z "$func_local" ]]; then
        echo "Erro: Nenhuma função fornecida." >&2
        return 1
    fi

    # Exibe a mensagem que a função não existe
    # echo "A função 'main' não existe no código $func_local ou há algum código incorreto..."
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    fallback "$@"
}