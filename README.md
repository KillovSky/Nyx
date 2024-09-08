<p align="center">
    <h1 align="center">Projeto Nyx</h1>
    <a href="https://github.com/KillovSky/Nyx/blob/main/LICENSE"><img alt="GitHub License" src="https://img.shields.io/github/license/KillovSky/Nyx?color=blue&label=License&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx"><img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/KillovSky/Nyx?label=Size%20%28With%20.git%20folder%29&style=flat-square"></a>
    <a href="https://api.github.com/repos/KillovSky/Nyx/languages"><img alt="GitHub Languages" src="https://img.shields.io/github/languages/count/KillovSky/Nyx?label=Code%20Languages&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/blob/main/.github/CHANGELOG.md"><img alt="GitHub Version" src="https://img.shields.io/github/package-json/v/KillovSky/Nyx?label=Latest%20Version&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/blob/main/.github/CHANGELOG.md"><img alt="Project Codename" src="https://img.shields.io/github/package-json/build_name/KillovSky/Nyx?label=Latest%20Codename"></a>
    <a href="https://github.com/KillovSky/Nyx/blob/main/.github/CHANGELOG.md"><img alt="Last Update" src="https://img.shields.io/github/package-json/build_date/KillovSky/Nyx?label=Latest%20Update"></a>
    <a href="https://github.com/KillovSky/Nyx/commits/main"><img alt="GitHub Commits" src="https://img.shields.io/github/commit-activity/y/KillovSky/Nyx?label=Commits&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/stargazers/"><img title="GitHub Stars" src="https://img.shields.io/github/stars/KillovSky/Nyx?label=Stars&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/network/members"><img title="GitHub Forks" src="https://img.shields.io/github/forks/KillovSky/Nyx?label=Forks&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/watchers"><img title="GitHub Watchers" src="https://img.shields.io/github/watchers/KillovSky/Nyx?label=Watchers&style=flat-square"></a>
    <a href="http://isitmaintained.com/project/KillovSky/Nyx"><img alt="Issue Resolution" src="http://isitmaintained.com/badge/resolution/KillovSky/Nyx.svg"></a>
    <a href="http://isitmaintained.com/project/KillovSky/Nyx"><img alt="Open Issues" src="http://isitmaintained.com/badge/open/KillovSky/Nyx.svg"></a>
    <a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FKillovSky%2FNyx&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Views&edge_flat=false"/></a>
    <a href="https://github.com/KillovSky/Nyx/pulls"><img alt="Pull Requests" src="https://img.shields.io/github/issues-pr/KillovSky/Nyx?label=Pull%20Requests&style=flat-square"></a>
    <a href="https://github.com/KillovSky/Nyx/graphs/contributors"><img alt="Contributors" src="https://img.shields.io/github/contributors/KillovSky/Nyx?label=Contribuidores&style=flat-square"></a>
</p>

# O que é?

O Projeto Nyx é um plugin opcional desenvolvido em Shell Scripting para o [Projeto Íris](https://github.com/KillovSky/Iris). Este plugin possibilita a implementação de todas as funcionalidades Bash, incluindo o uso de programas CLI, como os de hacking, APT ou similares (desde que a saida respeite o limite de caracteres de +- ~65K). Com isso, a Nyx elimina a necessidade de modificar o código principal da Íris ou de aprender Node.js (JavaScript) para realizar alterações.

## Requisitos

Para garantir o correto funcionamento do Projeto Nyx, o Projeto Íris deve estar ativo. A versão atual do Projeto Nyx é beta e foi desenvolvida rapidamente para fins de aprendizado, podendo conter erros menores.

1. **Bash**:
   - É recomendada a versão mais recente do Bash.
2. **Projeto Íris**:
   - Deve estar instalada e em execução.
3. **Dependências do Projeto Íris**:
   - Instale todas as dependências necessárias do Projeto Íris para assegurar o correto funcionamento da Nyx.
4. **Websocat**:
    - **VITAL** para o funcionamento do sistema: [GitHub ~ vi/websocat](https://github.com/vi/websocat)
5. **JQ**:
    - **VITAL** para o funcionamento do sistema: [Website ~ jqlang.github.io/jq](https://jqlang.github.io/jq/)

Instale o 4 e 5 na path do sistema, assim Nyx conseguirá as usar para iniciar sem problemas.
    - Se não souber como inserir na path, procure por tutoriais ou use o tutorial do [Projeto Íris](https://github.com/KillovSky/Iris/wiki/%F0%9F%96%A5%EF%B8%8F-Instalar-no-Windows#%EF%B8%8F-path) para ter uma **IDEIA BASE NO WINDOWS**.

## Execução

Após a instalação das dependências, você pode executar o Projeto Nyx de duas maneiras:

1. **Usando Bash**:
   - Para executar o Projeto Nyx diretamente, utilize o seguinte comando:
     ```bash
     bash run.sh
     ```

    - Alternativamente:
     ```bash
     chmod +x run.sh
     ./run.sh
     ```

2. **Usando NPM**:
   - Se preferir, você também pode iniciar a Nyx via NPM com o seguinte comando:
     ```bash
     npm start
     ```
   - Isso executará o script bash diretamente através do NPM.

## Modificação

Para modificar o Projeto Nyx, a maneira mais simples é através do sistema de cases que você encontrará na pasta `src/Commands/Cases`. Você encontrará exemplos de comandos que podem ser usados como base para criar novas funcionalidades.

Todos os parâmetros do Projeto Íris estão acessíveis via `$(jq -r '.NomeDaVariavel' <<< "$env")`, permitindo que você utilize as funcionalidades do Projeto Íris em seu código bash, mas esteja atento a sintaxe dele, que pode ser um pouco dificil para iniciantes.

## Detalhes Adicionais

**Informações da Versão**:
- **Codinome**: SNAIL
- **Versão**: v1.0.0
- **Tipo**: BETA
- **Erros**: Nenhum bug grave detectado
- **Data de Lançamento**: 08/09/2024
- **Observações**: Esta versão pode apresentar problemas menores não graves devido à ausência de alguns parâmetros opcionais ainda não integrados no Projeto Íris. Atualizações futuras do Projeto Íris resolverão essas questões, garantindo a integração completa e o funcionamento adequado dos parâmetros. Não será necessário reinstalar a Nyx para aplicar essas atualizações, pois os parâmetros já estarão incorporados nas futuras versões da Íris, e nenhuma intervenção adicional será necessária no Projeto Nyx, a menos que haja novas atualizações da mesma.

## Desenvolvimento Futuro

Mais novidades poderão chegar em breve! Fique atento às atualizações e acompanhe as redes sociais para mais informações!

Obrigado pelo seu interesse e apoio! Vamos continuar evoluindo juntos a um open-source melhor! ❤️
