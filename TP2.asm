.model small

.data
	ancien_ip dw ?
	ancien_cs dw ?
	message_0 db "DEROUTEMENT DE L'INTERRUPTION OVERFLOW$" 
	message_1 db "LE PROCESSEUR SIGNALE UN ETAT D'OVERFLOW,Appuyer sur une touche pour continuer$"
	message_2 db "OPERATION EFFECTUEE SANS ERREUR D'OVERFLOW$"
	message_3 db "Appuyer sur une touche pour effectuer l'operation d'addition$"
	message_4 db "OPERATION DE RESTORATION DU VECTEUR 4 EST TERMINEE$"
	message_5 db "Appuyer sur une touche pour quitter:$"
	msg1 db "ARCHI 2$"
	msg2 db "TP2$"
	x dw ?
	y dw ?
	
.stack 100h

.code
AppTouch proc near
		mov ah,1
		int 21h
		RET
AppTouch ENDP

store_int_of proc near
		mov ah,35h
		mov al,4
		int 21h
		mov ancien_cs,ES
		mov ancien_ip,BX
		RET
store_int_of ENDP

deroutement proc near
		push ds
		mov ah,9
		mov dx,offset message_0
		int 21h
		call newline
		call newline
		call newline
		mov ah,25h
		mov al,4
		push cs
		pop ds
		mov dx,offset myINT
		int 21h
		pop ds
		RET

myINT:  mov ah,9
		mov dx,offset message_1
		int 21h
		call newline
		call newline
		call newline
		call AppTouch
		IRET
deroutement ENDP

si_of_0 proc near
		JO OF1
		mov ah,9
		mov dx,offset message_2
		int 21h
		call newline
		call newline
		call newline
  OF1:	RET
si_of_0 ENDP

somme proc near
		mov ah,9
		mov dx,offset message_3
		int 21h
		call newline
		call newline
		call newline
		call newline
		call AppTouch
		mov ax,x
		add ax,y
		RET
somme ENDP

restore_of proc near
		push ds
		mov ds,ancien_cs
		mov dx,ancien_ip
		mov al,4
		mov ah,25h
		int 21h
		pop ds
		mov ah,9
		mov dx,offset message_4
		int 21h
		call newline
		call newline
		call newline
		RET
restore_of ENDP

newline proc near
		mov dl,10
		mov ah,2
		int 21h
		mov dl,13
		mov ah,2
		int 21h
		RET
newline ENDP

start:  mov ax,@data
		mov ds,ax
		
		mov ah,2
		mov bh,0
		mov dl,70
		mov dh,1
		int 10h
		mov ah,9
		mov dx,offset msg1
		int 21h
		call newline
		call newline
		call newline
		
		mov ah,2
		mov bh,0
		mov dl,35
		mov dh,5
		int 10h
		mov ah,9
		mov dx,offset msg2
		int 21h
		call newline
		call newline
		call newline
		
		;mov x,76cdh
		;mov y,49bch
		
		mov x,0ffffh
		mov y,1
		
		call somme
		
		JNO noOver
		call store_int_of
		call deroutement
		into
		call restore_of
		jmp Exit
		
noOver:	call si_of_0
		
Exit:   mov ah,2
		mov bh,0
		mov dl,30
		mov dh,21
		int 10h
		mov ah,9
		mov dx,offset message_5
		int 21h
		call AppTouch
		call newline
		
		mov ax,4ch
		int 21h
end start