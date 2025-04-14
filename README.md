# localiza_danfe_por_id_de_upload

Bash script para automação de busca de arquivos DANFE em PDF enviadas no processo de Checkin Documental do TOSP para uma determinada DI.
Busca pelo conteúdo de um arquivo texto indicado como parâmetro para este script na pasta, bem como um determinado ANO indicado como outro parâmentro junto aos backups do armazenamento do TOSP na Azure.
Confere se existem estes arquivos, linha a linha, confere se são realmente PDF, e se consta ao menos uma string identificando o conteúdo dos numerosos arquivos indicados como sendo DANFE, e cria uma cópia em destaque de evidências para facilitar a transferência dos arquivos via SFTP ou WinSCP.

O arquivo texto de parâmetros (ex: busca.txt) deve preferencialmente ser populado com nomes que suspeitamos poderem ser de determinadas DI a partir de uma Query no banco de dados, e pode ser editado diretamente pelo WinSCP, assim como indicado o ano que mais provavelmente teria sido enviado para análise (ex: 2025) na hora da execução do script.

Para baixar o projeto e preparar o ambiente para uso:

```
$ sudo su - sc-tos-app
$ cd ~
$ git clone https://github.com/FabioLeitao/bash_localiza_danfe_por_id_de_upload.git
```

Dependendo da quantidade de IDs a serem procurados, pode haver larga demora, assim recomendo não correr o risco de ter o script interrompido por perda da sessão, buscando rodar dentro de uma sessão do tmux, a ser iniciada antes da execução do mesmo:

```
$ tmux new-session -A -s localiza_danfe
```

O script exige ser executado pelo usuário sc-tos-app ou falhará devido a permissão de acesso as pastas de backups dos PDFs enviados, mas pode ser executado como no exemplo abaixo:

```
$ bash ~\localiza_danfe_por_id_de_upload\localiza_danfe_por_id_de_upload.sh 2025 ~\localiza_danfe_por_id_de_upload\busca.txt
```

Depois de acompanhar o início da execução do script, para sair do tmux sem perder a sessão em execução, digite a sequência de teclas:

```
Ctrl+B D
```

Ainda é possível confirmar se a sessão segue mesmo em execução listando o que o tmux estaria gerenciando, o que deveria listar ao menos a localiza_danfe:

```
$ tmux ls
```

O script está configurado para automaticamente criar informações de DEBUG para poderem acompanhar quando executado, ou por poder demorar bastante dependendo da quantidade de IDs de arquivos buscados na pasta de backup pareceia travado.

Todos os logs são ainda gravados em disco para análise posterior (ou mesmo remota), e podem ser lidos a qualquer momento pelo comando:

```
$ lnav ~/log/busca_danfe_por_id_de_upload.log
```

Para retornar a sessão em execução no tmux (talvez seja preciso corrigir algo ou interromper, ou apenas acompanhar ao vivo):

```
tmux attach -t localiza_danfe
```

