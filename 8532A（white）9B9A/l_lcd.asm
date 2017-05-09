IFDEF	COMP_LCD

;;;*****************************************
Sub_Dsp_Counter:
DSP_COUNTER:
		movfw   AdBufferm
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
	
		JE_FD   lcd_temp,00h
		goto    dsp_q
		clrf    LCDQ
	
		movfw   AdBufferm
		andlw   00001111b
		movwf   lcd_temp
	
		JE_FD   lcd_temp,00h
		goto    dsp_B
		clrf    LCDB
		goto    Dsp_S
;;;-----------------------------------
Dsp_Q:
		movfw   lcd_temp
		call    Sub_Dsp_Lcd_Num
		movwf   LCDQ
Dsp_B:	
		movfw   AdBufferm
		andlw   00001111b
		call    Sub_Dsp_Lcd_Num
		movwf   LCDB
Dsp_S:
		movfw   AdBufferl
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movfw   lcd_temp
		call    Sub_Dsp_Lcd_Num
		movwf   LCDS
Dsp_G:	
		movfw   AdBufferl
		andlw   00001111b
		call    Sub_Dsp_Lcd_Num
		movwf   LCDG
		RETURN
	


;;;*******************************************
sub_adjust_wd:
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh		
		
		MOVFF   F_BH,AdBufferm
		MOVFF   F_BL,AdBufferL
		return
;;;-------------------------------------------
sub_rrf4b_ebh:
		CLRC
		rrf4b	F_EBH
		return
;;;*******************************************
sub_dsp_cal:
        call    Sub_Dsp_Lcd_Null
        movlf	Lcdch0,LCDS
        movlf   Lcdch0,LCDG
		;bsf     lcd9,0     ;;;kg
              		
		return
;;;-----------------------------------------
sub_dsp_cal50:
        call    sub_dsp_cal
        movlf	Lcdch5,LCDB                
		call    SUB_DSP_REAL
		;bsf		lcd6,3		;;; .  	
		return
;;;;--------------------------------------
sub_dsp_cal100:
        call    sub_dsp_cal
        movlf   Lcdch1,LCDQ 
        movlf	Lcdch0,LCDB               
		call    SUB_DSP_REAL
		;bsf		lcd6,3		;;; .  	
		return		
;;;;--------------------------------------
sub_dsp_cal150:
        call    sub_dsp_cal
        movlf   Lcdch1,LCDQ 
        movlf	Lcdch5,LCDB                
		call    SUB_DSP_REAL
		;bsf		lcd6,3		;;; .  	
		return
		
;;;;=========================================
sub_dsp_pass:
        call    Sub_Dsp_Lcd_Null
		Movlf   LcdchP,LCDQ
		movlf   LcdchA,LCDB
        Movlf   Lcdch5,LCDS
        movwf	LCDG        
		call    SUB_DSP_REAL
		return
;;;=========================================	
sub_end_err:
        call    Sub_Dsp_Lcd_Null
		movlf   LcdchE,LCDB
        Movlf   Lcdchn,LCDS
        Movlf   Lcdchd,LCDG        
		call    SUB_DSP_REAL
		return     
;;;******************************************
Sub_Lowbat_Dsp:
		call    Sub_Dsp_Lcd_Null
		MOVLF   LcdchL,LCDB
		movlf   Lcdcho,lcdS
    	call    sub_dsp_real	
		return
;;;------------------------------------------
sub_over_err:
		call    Sub_Dsp_Lcd_Null
		movlf   Lcdcho,LCDB		
		movlf   LcdchL,LCDS
    	call    sub_dsp_real  	
        return
;;;-------------------------------------------
sub_Dsp_BCD:
		call    	sub_Hex2BCD
sub_Dsp_Data:		
		movff   	F_bl,AdBufferl
		movff   	F_bh,AdBufferm
sub_Dsp:	                	    
		;call    	Sub_Dsp_Lcd_Null
		call    	Sub_Dsp_Counter
		call    	sub_dsp_real
		return
;;;-------------------------------------------        
sub_ifdsp_dotu:
		;clrf	lcd9        
        btfsc	Unit_Flag,Unit_lb
        goto	set_lb
        ;bsf     lcd9,0     ;;;kg
        ;bsf		lcd6,3		;;; . 
        return          
set_lb:
        ;bsf     lcd9,1     ;;;lb
        ;bsf		lcd6,3		;;; . 
        return
	              
;;;-------------------------------------------
Sub_Dsp_Lcd_Num:
		addpcw	       
		retlw	Lcdch0	;0	(work=0)
		retlw	Lcdch1	;1	(work=1)
		retlw	Lcdch2	;2	(work=2)
		retlw	Lcdch3	;3	(work=3)
		retlw	Lcdch4	;4	(work=4)
		retlw	Lcdch5	;5	(work=5)
		retlw	Lcdch6	;6	(work=6)
		retlw	Lcdch7	;7	(work=7)
		retlw	Lcdch8	;8	(work=8)
		retlw	Lcdch9	;9	(work=9)
		retlw	LcdchA	;A	(work=a)
		retlw	Lcdchb	;b	(work=b)
		retlw	LcdchC	;C	(work=c)
		retlw	Lcdchd	;d	(work=d)
		retlw	LcdchE	;E	(work=e)
		retlw	LcdchF	;F	(work=f)
;;;--------------------------------------------
Sub_Dsp_Lcd_All:
		movlw    0ffh	
		goto     Dsp_Lcd_Xxx
;;;----------------------------------------
Sub_Dsp_Lcd_Null:
		movlw    000h
		goto     Dsp_Lcd_Xxx
Dsp_Lcd_Xxx:
		;movwf	lcd9
        movwf   LCDQ
        movwf   LCDB
        movwf   LCDS
        movwf   LCDG
        call    sub_dsp_real	
	    return
;;;------------------------------------------
;;;============================================
SUB_DSP_REAL:
        Movff   LCDG,nlcd_7add
        movfw	LCDG
        rrf4    work
        Movff   work,nlcd_8add
        
        Movff   LCDS,nlcd_5add
        movfw	LCDS
        rrf4    work
        Movff   work,nlcd_6add
        
        Movff   LCDB,nlcd_3add
        movfw	LCDB
        rrf4    work
        Movff   work,nlcd_4add
        
        Movff   LCDQ,nlcd_1add
        movfw	LCDQ
        rrf4    work
        Movff   work,nlcd_2add
                             
		RETURN
		

ENDIF		
