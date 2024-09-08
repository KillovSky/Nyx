#!/bin/bash

# Dicionário de cores ANSI
declare -A COLORS=(
    [reset]="\033[0m"
    [bold]="\033[1m"
    [dim]="\033[2m"
    [italic]="\033[3m"
    [underline]="\033[4m"
    [inverse]="\033[7m"
    [hidden]="\033[8m"
    [strikethrough]="\033[9m"
    [black]="\033[30m"
    [red]="\033[31m"
    [green]="\033[32m"
    [yellow]="\033[33m"
    [blue]="\033[34m"
    [magenta]="\033[35m"
    [cyan]="\033[36m"
    [white]="\033[37m"
    [gray]="\033[90m"
    [grey]="\033[90m"
    [brightRed]="\033[91m"
    [brightGreen]="\033[92m"
    [brightYellow]="\033[93m"
    [brightBlue]="\033[94m"
    [brightMagenta]="\033[95m"
    [brightCyan]="\033[96m"
    [brightWhite]="\033[97m"
    [bgBlack]="\033[40m"
    [bgRed]="\033[41m"
    [bgGreen]="\033[42m"
    [bgYellow]="\033[43m"
    [bgBlue]="\033[44m"
    [bgMagenta]="\033[45m"
    [bgCyan]="\033[46m"
    [bgWhite]="\033[47m"
    [bgGray]="\033[100m"
    [bgGrey]="\033[100m"
    [bgBrightRed]="\033[101m"
    [bgBrightGreen]="\033[102m"
    [bgBrightYellow]="\033[103m"
    [bgBrightBlue]="\033[104m"
    [bgBrightMagenta]="\033[105m"
    [bgBrightCyan]="\033[106m"
    [bgBrightWhite]="\033[107m"
    [blackBG]="\033[40m"
    [redBG]="\033[41m"
    [greenBG]="\033[42m"
    [yellowBG]="\033[43m"
    [blueBG]="\033[44m"
    [magentaBG]="\033[45m"
    [cyanBG]="\033[46m"
    [whiteBG]="\033[47m"
)

# Função para retornar mensagem colorida como string
colorprint() {
    local text="$1"
    local color="${2:-green}"

    # Mensagem padrão
    local default_message="${COLORS[red]}[$(basename "$(pwd)")]${COLORS[reset]} → ${COLORS[yellow]}A operação não pode ser concluída porque nenhum texto foi enviado.${COLORS[reset]}"

    # Adquire a cor ou usa uma padrão
    local color_code="${COLORS[$color]:-${COLORS[green]}}"

    # Se não for uma string, retorna mensagem padrão
    if [ -z "$text" ]; then
        echo -e "$default_message"
    else
        echo -e "${color_code}${text}${COLORS[reset]}"
    fi
}

# Função main
main() {
    # Executa a função local com os argumentos recebidos
    colorprint "$@"
}