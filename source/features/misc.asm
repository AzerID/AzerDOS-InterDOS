; ==================================================================
; MikeOS -- The Mike Operating System kernel
; Copyright (C) 2006 - 2019 MikeOS Developers -- see doc/LICENSE.TXT
;
; MISCELLANEOUS ROUTINES
; ==================================================================

; ------------------------------------------------------------------
; os_get_api_version -- Return current version of MikeOS API
; IN: Nothing; OUT: AL = API version number

os_get_api_version:
	mov al, MIKEOS_API_VER
	ret


; ------------------------------------------------------------------
; os_pause -- Delay execution for specified 110ms chunks
; IN: AX = 100 millisecond chunks to wait (max delay is 32767,
;     which multiplied by 55ms = 1802 seconds = 30 minutes)

os_pause:
	pusha
	cmp ax, 0
	je .time_up			; If delay = 0 then bail out

	mov cx, 0
	mov [.counter_var], cx		; Zero the counter variable

	mov bx, ax
	mov ax, 0
	mov al, 2			; 2 * 55ms = 110mS
	mul bx				; Multiply by number of 110ms chunks required 
	mov [.orig_req_delay], ax	; Save it

	mov ah, 0
	int 1Ah				; Get tick count	

	mov [.prev_tick_count], dx	; Save it for later comparison

.checkloop:
	mov ah,0
	int 1Ah				; Get tick count again

	cmp [.prev_tick_count], dx	; Compare with previous tick count

	jne .up_date			; If it's changed check it
	jmp .checkloop			; Otherwise wait some more

.time_up:
	popa
	ret

.up_date:
	mov ax, [.counter_var]		; Inc counter_var
	inc ax
	mov [.counter_var], ax

	cmp ax, [.orig_req_delay]	; Is counter_var = required delay?
	jge .time_up			; Yes, so bail out

	mov [.prev_tick_count], dx	; No, so update .prev_tick_count 

	jmp .checkloop			; And go wait some more


	.orig_req_delay		dw	0
	.counter_var		dw	0
	.prev_tick_count	dw	0


; ------------------------------------------------------------------
; os_fatal_error -- Display error message and halt execution
; IN: AX = error message string location

os_fatal_error:
	call os_hide_cursor
	call os_clear_screen
	
	mov si, .error_msg		; Inform of fatal error
	call os_print_string
	
	mov si, ax				; Show the stop code
	call os_print_string
	
	call os_speaker_off
	
	mov ax, 60
	call os_pause
	
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov word si, [param_list]
	mov di, 0

	db 0x0ea
	dw 0x0000
	dw 0xffff
	
	.error_msg		db '>>> FATAL OPERATING SYSTEM ERROR <<<', 13, 10
	.error_msg1		db 13, 10
	.error_msg2		db 'The Operating System was failed to run. Please send', 13, 10
	.error_msg3		db 'the stopcode to the developer. Your computer will', 13, 10
	.error_msg4		db 'be restart on 1 minute', 13, 10
	.error_msg5		db 13, 10
	.error_msg6		db 'Stopcode : ', 0
	
; ------------------------------------------------------------------
; os_death_screen -- Show the death screen (For Backward Compability)
; IN: AX = Stop code string

os_death_screen:
	call os_fatal_error


; ==================================================================

