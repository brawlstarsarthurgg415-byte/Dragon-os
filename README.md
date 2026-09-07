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

```bash
sudo dd if=out/dragonos-*.iso of=/dev/sdX bs=4M conv=fsync status=progress
```

> **Atenção:** substitua `/dev/sdX` pelo dispositivo inteiro do pendrive; esse
> comando apaga seus dados.

A sessão live inicia com o usuário `dragon`; abra **Install Dragon OS** para
executar o Calamares. A entrada **Dragon Store** abre a loja gráfica para
instalar e remover aplicativos dos repositórios oficiais do Arch.
