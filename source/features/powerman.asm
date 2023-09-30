; ==================================================
; InterDOS -- The Inter Disk Operating System
; POWER MANAGEMENT
; ==================================================

; --------------------------------------------------
; os_shutdown -- Shutdown the computer
; IN/OUT: Nothing

os_shutdown:
	call os_hide_cursor
	call os_clear_screen
	
	mov si, shutdown_msg	; Tell user if computer
	call os_print_string	; will be shutdown
	
	mov ax, 5
	call os_pause

	mov ax, 0			; Clear all registers
	mov bx, 0			; for preparing to
	mov cx, 0			; shutdown
	mov dx, 0
	mov word si, [param_list]
	mov di, 0

	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 0x15
	
; --------------------------------------------------
; os_restart -- Restart the computer
; IN/OUT: Nothing

os_restart:
	call os_hide_cursor
	call os_clear_screen
	
	mov si, restart_msg		; Tell user if computer
	call os_print_string	; will be restart
	
	mov ax, 5
	call os_pause
	
	mov ax, 0			; Clear all registers
	mov bx, 0			; for preparing to
	mov cx, 0			; restart
	mov dx, 0
	mov word si, [param_list]
	mov di, 0

	db 0x0ea
	dw 0x0000
	dw 0xffff
	
; ------------------------------------------------
; Data for above code...

shutdown_msg		db 'Shutting down...', 0
restart_msg			db 'Restarting...', 0

; =============================================