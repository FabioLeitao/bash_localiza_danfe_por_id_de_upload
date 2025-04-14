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

## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://github.com/FabioLeitao/bash_localiza_danfe_por_id_de_upload.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](http://gitlab.ictsirio.com/fabio.leitao/localiza_danfe_por_id_de_upload/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
