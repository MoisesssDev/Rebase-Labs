
## Rebase Labs

Uma app web para listagem de exames médicos.

**Tech Stack**
- Docker
- Ruby
- Javascript
- HTML
- CSS


### Premissa
A premissa principal deste laboratório é que a app não seja feita em Rails, devendo seguir o padrão Sinatra que há neste projeto, ou então se preferir, podendo utilizar outro web framework que não seja Rails, por ex. grape, padrino, rack, etc ou até mesmo um HTTP/TCP server "na mão".


### Pré-requisitos

Certifique-se de ter o Docker instalado na sua máquina.

### Configuração

1. Clone este repositório:
```bash
    git clone git@github.com:MoisesssDev/Rebase-Labs.git
```
2. Navegue até o diretório do projeto:
```bash
    cd Rebase-Labs
```
3. Adicione a permissão de execução ao arquivo `bin/dev` e `bin/test` 
```bash
    chmod +x bin/dev
    chmod +x bin/test
```
4. Para iniciar o servidor, execute o script que roda a imagem no Docker:
```bash
    bin/dev
```
### Testes
Para rodar os testes execute o seguinte comando:
```bash
    bin/test
```

### Links utéis
- [Design do projeto no Figma](https://www.figma.com/file/VmKxKdRMtOzGqNpMa8VWkK/Rebase-Labs?type=design&node-id=0%3A1&mode=design&t=dQCGoxXQvAQTvJ8F-1)
- [Diagrama do banco de dados](https://dbdiagram.io/d/Rebase-Labs-65f3b06cb1f3d4062cfb8aaf)
