# Dragon OS archiso profile

Perfil `archiso` para gerar uma ISO **Dragon OS** x86_64, baseada em X11 e
configurada para computadores de baixo consumo, incluindo APUs AMD A4 antigas.
O desktop é XFCE + LightDM + Picom com backend `xrender`, sem Wayland, blur ou
sombras pesadas. A seleção inicial oferece os perfis **Noob** (mouse e GUI) e
**Pro** (Rofi, atalhos Super e Terminator).

## Construção

Em um host Arch Linux, instale `archiso`, configure no `pacman.conf` do host o
repositório que fornece `pamac-gtk` (normalmente o repositório assinado do
projeto Dragon OS) e execute:

```bash
./build.sh
```

A ISO bootável é criada em `out/`. O script falha antes do build se
`pamac-gtk` não estiver disponível, evitando uma imagem que não cumpra o
perfil. Grave a ISO em um pendrive, por exemplo:

```bash
sudo dd if=out/dragonos-*.iso of=/dev/sdX bs=4M conv=fsync status=progress
```

> **Atenção:** substitua `/dev/sdX` pelo dispositivo inteiro do pendrive; esse
> comando apaga seus dados.

A sessão live inicia com o usuário `dragon`; abra **Install Dragon OS** para
executar o Calamares. Para uma instalação definitiva, forneça também um
repositório Dragon OS contendo `pamac-gtk`, pois o sistema instalado mantém a
mesma lista de pacotes da imagem live.
