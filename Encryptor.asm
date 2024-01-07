data segment para public 'data'
	message0 db 'Please provide a text to encrypt or decrypt:$'
	message00 db 'Please provide a key for encryption:$'
	message1 db 'If you want to encrypt your message, please press 1, if you want to decrypt it, please press 2!$'
	message2 db '-->encryption done$'
	message3 db '-->decryption done$'
	message4 db 'Cannot decrypt further!$'
	message5 db 'Cannot encrypt further!$'
	buff db ?
	filecontent db 200 dup ('$')
	buff1 db ?
	filekey db 200 dup ('$')
	delevel db ?
data ends

stk segment stack
	db 254 dup ('?')
stk ends

code segment para public 'code'
assume cs:code, ds:data, ss:stk
main:
    
	mov ax, data
	mov ds, ax
	mov delevel, 0
	
	; Prompt for entering the message
	mov ah, 9
	mov dx, offset message0
	int 21h
	call nl
	; Input the message
	mov buff, 200
	mov ah, 0ah
	lea dx, buff
	int 21h
	call nl
	
	; Prompt for entering the key
	mov ah, 9
	mov dx, offset message00
	int 21h
	call nl
	; Input the key
	mov buff1, 200
	mov ah, 0ah
	lea dx, buff1
	int 21h
	call nl
	
	; Prompt indicating encryption (1) or decryption (2)
	mov ax, data
	mov ds, ax
	mov ah, 9
	mov dx, offset message1
	int 21h

	; Wait for pressing 1 or 2, no action for other inputs
input:
	mov ax, 0
	mov ah, 8
	int 21h
	cmp al, 49
	je en
	cmp al, 50
	je de
	jmp input
	
en:
	; Check if encryption is allowed, cannot encrypt more than 3 times
    mov al, [delevel]
	cmp al, 3
	jne cont
	; Message that encryption is not allowed
    call nl
	mov ah, 9
	mov dx, offset message5
    int 21h
	jmp input
cont:
    ; Display the message indicating encryption
	call nl
	mov ax, data 
	mov ds, ax
	mov ah, 9
	mov dx, offset message2
	int 21h
	; Encryption starts from level 1
	jmp enL1
de:
	; Check if decryption is allowed, cannot decrypt in the initial state
    mov al, [delevel]
	cmp al, 0
	jne con
	; Message that decryption is not allowed
    call nl
	mov ah, 9
	mov dx, offset message4
    int 21h
	jmp input
con:
    ; Display the message indicating decryption
	call nl
	mov ax, data 
	mov ds, ax
	mov ah, 9
	mov dx, offset message3
	int 21h
	jmp deL3
output:
	; Display the current state of the text
	call nl
	mov ah, 9
	mov dx, offset [filecontent+1]
	mov dx, offset [filecontent+1]
	int 21h
	jmp input

;-------------------LEVEL 1--------------------------
; Common segments
keyEndCheck:
	mov al, [si]
    cmp al, '$'
	jne keyNE
	lea si, [filekey+1]
	ret
keyNE:
    ret
;-----------------encryption------------------------
enL1:
	; Encryption level one: the key is adjusted based on the length of the text
	; if too short, it repeats from the beginning, both characters of the text and key are added
    lea si, [filekey+1]
	lea di, [filecontent+1]
enL1Loop:
    ; Checks
	call keyEndCheck
	; If the word has ended, go to level 2
	mov al, [di]
	cmp al, '$'
	je enL2
    ; Reset the registers
	mov ax, 0
	mov dx, 0
	; Add the current key element to the current text element
	mov al, [si]
	add byte ptr [di], al
	; Increment and loop again
	inc si
	inc di
	jmp enL1Loop
;------------------decryption-----------------------
deL1:
	; Initial indexing state
    lea si, [filekey+1]
	lea di, [filecontent+1]
deL1Loop:
    ; Checks
	call keyEndCheck
	mov al, [di]
	cmp al, '$'
	je deL1END
	; Reset the registers
	mov ax, 0
	mov dx, 0
	; Subtract the key element from the text element
	mov al, [si]
	sub byte ptr [di], al
	inc si
	inc di
	jmp deL1Loop
deL1END:
    sub delevel, 1
	jmp output
;--------------------------------------------------

;-------------------LEVEL 2--------------------------
;------------------encryption-----------------------
enL2:
	; Save the size of the key in dx
    call keySize
	mov cx, si
	; Initial indexing state
	lea di, [filecontent+1]
enL2Loop:
    ; Check if the text has ended
	mov ax, 0
	mov al, [di]
	cmp al, '$'
	je enL2End
	; Reset the register and check if the current key element is even or odd
	add byte ptr [di], cl
	inc si
	inc di
	jmp enL2Loop
enL2End:
    jmp enL3
;--------------------------------------------------
deL2:
	; Save the size of the key in dx
	call keySize
	mov cx, si
	; Initial decryption state
	lea si, [filekey+1]
	lea di, [filecontent+1]
deL2Loop:
    ; Check if the text has ended
	mov al, [di]
	cmp al, '$'
	je deL2END
	sub byte ptr [di], cl
	inc si
	inc di
	jmp deL2Loop
deL2END:
    jmp deL1
;-------------------------------------------

;-----------------LEVEL 3--------------------
;--------------encryption-------------------
enL3:
; Initial indexing state
	lea si, [filekey+1]
	lea di, [filecontent+1]
	mov ax, 0
	mov dx, 0
	mov bx, 3
enL3Loop:
; Checks
	call keyEndCheck
	mov ax, 0
	mov al, [di]
	cmp al, '$'
	je enL3END
; Find the remainder of the key element divided by 3
	mov cx, 3
	mov ax, 0
	mov al, [si]
	div cx
	cmp ah, 1
	je case1en
	cmp ah, 2
