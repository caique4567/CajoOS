bits 16
org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov ax, 0xA000
    mov es, ax

restart:
    mov word [length], 3
    mov word [snake], 285
    mov word [snake+2], 284
    mov word [snake+4], 283
    mov byte [direction], 1
    mov byte [last_key], 0xFF
    mov byte [step_wait], 12
    call place_food
    call draw_game

game_loop:
    call read_key
    dec byte [step_wait]
    jnz .yield
    mov byte [step_wait], 12
    call advance_snake
    jc game_over
    call draw_game
.yield:
    ; Let the kernel run between game updates instead of busy-polling.
    hlt
    jmp game_loop

read_key:
    mov dx, 0x60
    in al, dx
    cmp al, [last_key]
    je .done
    mov [last_key], al
    test al, 0x80
    jnz .done
    cmp al, 0x48
    je .up
    cmp al, 0x11
    je .up
    cmp al, 0x4D
    je .right
    cmp al, 0x20
    je .right
    cmp al, 0x50
    je .down
    cmp al, 0x1F
    je .down
    cmp al, 0x4B
    je .left
    cmp al, 0x1E
    je .left
    ret
.up:
    cmp byte [direction], 2
    je .done
    mov byte [direction], 0
    ret
.right:
    cmp byte [direction], 3
    je .done
    mov byte [direction], 1
    ret
.down:
    cmp byte [direction], 0
    je .done
    mov byte [direction], 2
    ret
.left:
    cmp byte [direction], 1
    je .done
    mov byte [direction], 3
.done:
    ret

advance_snake:
    mov ax, [snake]
    xor dx, dx
    mov bx, 30
    div bx
    cmp byte [direction], 0
    je .up
    cmp byte [direction], 1
    je .right
    cmp byte [direction], 2
    je .down
.left:
    test dx, dx
    jz .dead
    mov ax, [snake]
    dec ax
    jmp .candidate
.up:
    test ax, ax
    jz .dead
    mov ax, [snake]
    sub ax, 30
    jmp .candidate
.right:
    cmp dx, 29
    jae .dead
    mov ax, [snake]
    inc ax
    jmp .candidate
.down:
    cmp ax, 17
    jae .dead
    mov ax, [snake]
    add ax, 30
.candidate:
    mov [next_head], ax
    mov bx, ax
    mov si, snake
    mov cx, [length]
.collision:
    lodsw
    cmp ax, bx
    je .dead
    loop .collision
    mov ax, [next_head]
    cmp ax, [food]
    jne .shift
    cmp word [length], 128
    jae .shift
    inc word [length]
    call place_food
.shift:
    mov cx, [length]
    dec cx
    jz .head
    mov si, cx
    shl si, 1
.tail:
    mov ax, [snake+si-2]
    mov [snake+si], ax
    sub si, 2
    loop .tail
.head:
    mov ax, [next_head]
    mov [snake], ax
    clc
    ret
.dead:
    stc
    ret

place_food:
.retry:
    mov ax, [seed]
    mov bx, 25173
    mul bx
    add ax, 13849
    mov [seed], ax
    xor dx, dx
    mov bx, 540
    div bx
    mov [food], dx
    mov si, snake
    mov cx, [length]
    mov bx, dx
.check:
    lodsw
    cmp ax, bx
    je .retry
    loop .check
    ret

draw_game:
    xor di, di
    mov cx, 64000
    mov al, 1
    rep stosb
    mov dx, 0x0000
    mov si, title
    call print_text
    mov dx, 0x0100
    mov si, controls
    call print_text
    mov si, snake
    mov cx, [length]
.body:
    lodsw
    mov bl, 10
    call draw_cell
    loop .body
    mov ax, [food]
    mov bl, 12
    call draw_cell
    ret

draw_cell:
    mov [draw_color], bl
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    xor dx, dx
    mov bx, 30
    div bx
    mov si, dx
    shl si, 3
    add si, 40
    mov dx, ax
    shl ax, 8
    shl dx, 6
    add ax, dx
    add ax, 10240
    add ax, si
    mov di, ax
    mov dx, 8
.row:
    push dx
    mov al, [draw_color]
    mov cx, 8
    rep stosb
    add di, 312
    pop dx
    dec dx
    jnz .row
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

print_text:
    mov ah, 2
    xor bh, bh
    int 0x10
    mov bx, 0x000F
.next:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .next
.done:
    ret

game_over:
    mov dx, 0x0B00
    mov si, over_text
    call print_text
    mov dx, 0x0C00
    mov si, restart_text
    call print_text
    mov dx, 0x60
    in al, dx
    mov [last_key], al
.wait:
    in al, dx
    cmp al, [last_key]
    jne .new_key
    hlt
    jmp .wait
.new_key:
    mov [last_key], al
    test al, 0x80
    jnz .wait
    jmp restart

title        db 'CAJO SNAKE', 0
controls     db 'SETAS / WASD PARA MOVER', 0
over_text    db 'FIM DE JOGO', 0
restart_text db 'PRESSIONE UMA TECLA', 0
direction    db 0
last_key     db 0
step_wait    db 0
draw_color   db 0
length       dw 0
food         dw 0
next_head    dw 0
seed         dw 0x7215
snake        times 128 dw 0
