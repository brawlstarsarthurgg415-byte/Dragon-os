# Dragon OS archiso profile

Perfil `archiso` para gerar uma ISO **Dragon OS** x86_64, baseada em X11 e
configurada para computadores de baixo consumo, incluindo APUs AMD A4 antigas.
O desktop é XFCE + LightDM + Picom com backend `xrender`, sem Wayland, blur ou
sombras pesadas. A seleção inicial oferece os perfis **Noob** (mouse e GUI) e
**Pro** (Rofi, atalhos Super e Terminator).

## Construção

Em um host Arch Linux, instale `archiso` e execute:

```bash
./build.sh
```

A ISO bootável é criada em `out/`. O perfil inclui Syslinux para BIOS legado e systemd-boot para UEFI x86_64; portanto, mantenha os diretórios `efiboot/` e seus arquivos de configuração no projeto. A loja gráfica padrão é o GNOME Software com PackageKit, ambos disponíveis nos repositórios oficiais do Arch; não é necessário configurar AUR ou Pamac para gerar a ISO. Grave a ISO em um pendrive, por exemplo:

### Limpeza após um build interrompido

Não apague o diretório `work/` manualmente enquanto ele contiver montagens de
build do ArchISO: isso pode produzir muitas mensagens referentes a arquivos em
`work/x86_64/airootfs/proc/` que não podem ser removidos. Execute novamente
`sudo ./build.sh`; o script desmonta as montagens aninhadas antes de remover o
diretório de trabalho. Para apagar somente uma ISO antiga, use:

```bash
rm -i out/dragonos-*.iso
```

`mkinitcpio-archiso` é parte obrigatória da imagem live. Ele fornece os hooks
do initramfs que encontram e montam `airootfs.sfs`; sem esse pacote, a máquina
pode chegar ao `Switch Root` e falhar, entrando no modo de emergência durante
o boot.

O perfil deixa de fora `lib32-mesa`, porque o repositório `multilib` não é
configurado na imagem e o suporte a OpenGL de 32 bits não é necessário para a
sessão live. Calamares também não está nos repositórios oficiais usados no
build; por isso o atalho **Install Dragon OS** abre o `archinstall` em um
terminal, a menos que um repositório próprio forneça Calamares.

```bash
sudo dd if=out/dragonos-*.iso of=/dev/sdX bs=4M conv=fsync status=progress
```

> **Atenção:** substitua `/dev/sdX` pelo dispositivo inteiro do pendrive; esse
> comando apaga seus dados.

A sessão live inicia com o usuário `dragon`; abra **Install Dragon OS** para
executar o Calamares. A entrada **Dragon Store** abre a loja gráfica para
instalar e remover aplicativos dos repositórios oficiais do Arch.
