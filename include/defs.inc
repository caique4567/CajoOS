WIDTH   equ 1024
HEIGHT  equ 768
BACK    equ 0x1000000	;back buffer
WALL    equ 0x1400000               ;wallpaper
HILLT   equ 0x2000000
NOTE    equ 0x2100000
TBUF    equ 0x2110000
FONT    equ 0x80000                     ; bios font
FSMAX   equ 11
IMGSEC  equ 52 ; 26624 bytes
FSLBA   equ IMGSEC-1-2*FSMAX  ;dir sector
FSMEM   equ 0x7C00+FSLBA*512 ; bios already loaded it
BARY    equ 728
NWIN    equ 8
; x y w h vis title max
WSIZE   equ 28
WX      equ 0
WY      equ 4
WW      equ 8
WH      equ 12
WVIS    equ 16
WTITLE  equ 20
WMAX    equ 24
WSAVE   equ 0x2704C00
MENUW   equ 240
MENUH   equ 56+(NWIN+1)*36
MENUY   equ BARY-MENUH
CTXW    equ 176
A_TERM  equ 1
A_NOTE  equ 2
A_FILES equ 3
A_SNAKE equ 5
A_PAINT equ 6
A_BROWSE equ 7
CANVAS  equ 0x1800000
CANW    equ 420
CANH    equ 280
KERNEL  equ 0x100010	; unpacked kernel
CMTAB   equ 0x3000000
CMH     equ 0x5100
CMK     equ 0x5180
CMPART  equ 0x5200
CMPROB  equ 0x5204
PROBS   equ 0x2000000
; filled in by the boot sector
lfb     equ 0x5000
pitch   equ 0x5004
packed  equ 0x5008
