# CajoOS

Um pequeno sistema operacional desktop x86 em Assembly, baseado no [XD OS](https://github.com/eklavya-raj/xdos), do CodingWalaXD. O projeto de referência demonstra um desktop funcional em uma imagem de aproximadamente 19 KB.

Esta primeira versão mantém a base técnica do XD OS e troca a identidade visível para **CajoOS**. Inclui desktop gráfico, janelas, terminal, editor de texto, pintura, arquivos, calculadora, navegador, o jogo **Cajo Snake** e um wallpaper próprio com “CajoOS” centralizado. Os jogos da base foram removidos. O código e a licença MIT originais estão incluídos; consulte `LICENSE.md`.

## Compilar no Windows

1. Instale Python 3 e NASM. O NASM precisa estar no `PATH` ou em `%LOCALAPPDATA%\bin\NASM\nasm.exe`.
2. Abra o PowerShell nesta pasta e execute:

```powershell
python tools/build.py
```

A imagem será criada em `out/os.img`.

## Executar

Instale o QEMU e execute:

```powershell
qemu-system-i386 -drive format=raw,file=out/os.img -m 64 -vga std -rtc base=localtime -nic user,model=rtl8139
```

A placa `rtl8139` é necessária para a rede. O navegador HTTPS da base original não valida certificados.

## VirtualBox

O build gera `out/os.img`, uma imagem bruta de 26 KB. Para criar um disco virtual VDI com o tamanho mínimo aceito pelo VirtualBox, execute:

```powershell
.\tools\make_vdi.ps1
```

No VirtualBox, crie uma VM de 32 bits com 64 MB de RAM, mantenha EFI desativado e selecione `out/CajoOS.vdi` como disco existente.

## ISO de boot

Para criar um ISO El Torito para CD/DVD ou para montar na unidade óptica de uma VM:

```powershell
python -m pip install pycdlib
python .\build.py
python .\tools\make_iso.py
```

O arquivo será `out/CajoOS.iso`. No VirtualBox, anexe-o à unidade óptica e deixe EFI desativado. Para pendrive, grave `out/os.img` como imagem bruta; o ISO não é híbrido para USB.

## Cajo Snake

Abra o ícone **Cajo Snake** na área de trabalho. Use as setas ou `W`, `A`, `S`, `D` para mover. Ao perder, pressione uma tecla para começar de novo.

## Estrutura

- `boot/boot.asm`: boot, carregador e sistema de arquivos da imagem
- `kernel/kernel.asm`: desktop, janelas, teclado e mouse
- `kernel/apps/`: aplicativos
- `kernel/net/`: driver de rede e protocolos
- `games/snake.asm`: código do jogo Cajo Snake
- `tools/build.py`: montagem da imagem

## Gerenciador de arquivos

No app **Files**, clique com o botão direito em uma área vazia para criar um arquivo ou uma pasta. Digite o nome e pressione Enter. Clique em uma pasta para abri-la; use **Back** para voltar. Clique com o botão direito em um item para renomeá-lo (pastas) ou abrir, renomear e excluir (arquivos).

O sistema de arquivos é intencionalmente pequeno: comporta até 11 itens no total e cada arquivo armazena até 1 KB.

## Créditos

Baseado no [XD OS](https://github.com/eklavya-raj/xdos), Copyright (c) 2026 CodingWalaXD, sob licença MIT. CajoOS é uma adaptação inicial dessa base.
