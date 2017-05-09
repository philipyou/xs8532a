IFDEF	COMP_LED


Sub_LED_init:
		movlw	240
		movwf	TM1IN
		bsf		INTE,TM1IE
		movlw	10110000b
		movwf	TM1CON
		
		bsf		inte,gie
				
		
		movlw	00111001b
		movwf	LEDCON1
		movlw	00000000b
		movwf	LEDCON2
		;movlw	00010101b
	;	movlw	00000000b
		movlw	00010111b
		movwf	CHPCON
		
		
		movlf 26H,7DH
		movlf ffH,PT2EN		

	
		return
;;;*****************************************
/*Sub_Dsp_Counter:
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
;		movfw   lcd_temp
;		call    Sub_Dsp_Lcd_Num
        clrf    lcd_temp
        bsf     lcd_temp,0
        bsf     lcd_temp,1
		movff   lcd_temp,LCDQ
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
        movfw   F_BL
		andlw   00001111b
		movwf   lcd_temp
		movlw   5
        subwf   lcd_temp,0
        btfsc   status,c
        goto    sub_adjust_wd1
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh		
		
		MOVFF   F_BH,AdBufferm
		MOVFF   F_BL,AdBufferL
		return
sub_adjust_wd1:		        
        call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		MOVFF   F_BH,AdBufferm
		movfw   F_BL
		addlw   1
		movwf   AdBufferL
		return*/
Sub_Dsp_Counter:
DSP_COUNTER:
/*		movfw   AdBufferm
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1*/
		movff   lcdq,lcd_temp
	
		JE_FD   lcd_temp,00h
		goto    dsp_q
		clrf    LCDQ
	
;		movfw   AdBufferm
;		andlw   00001111b
;		movwf   lcd_temp
	    movff   lcdb,lcd_temp
		JE_FD   lcd_temp,00h
		goto    dsp_B
		clrf    LCDB
		goto    Dsp_S
;;;-----------------------------------
Dsp_Q:
;		movfw   lcd_temp
;		call    Sub_Dsp_Lcd_Num
        bsf     lcdq,0
        bsf     lcdq,1
;		movwf   LCDQ
Dsp_B:	
;		movfw   AdBufferm
;		andlw   00001111b
        movfw   lcdb
		call    Sub_Dsp_Lcd_Num
		movwf   LCDB
Dsp_S:
/*		movfw   AdBufferl
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movfw   lcd_temp*/
		movff   lcds,lcd_temp
		call    Sub_Dsp_Lcd_Num
		movwf   LCDS
Dsp_G:	
		movfw   LCDG
;		andlw   00001111b
		call    Sub_Dsp_Lcd_Num
		movwf   LCDG
		RETURN
	

;;;*******************************************
sub_adjust_wd:
 ;       movlw   99h
 ;       movwf   F_BL
 ;       movlw   90h
 ;       movwf   F_Bh
         
        movfw   F_BL
		andlw   00001111b
		movwf   lcd_temp
		movlw   5
        subwf   lcd_temp,0
        btfsc   status,c
        goto    sub_adjust_wd1
       
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh		
		
;		MOVFF   F_BH,AdBufferm
;		MOVFF   F_BL,AdBufferL
sub_adjust_wd10:
        movfw   F_BL
		andlw   00001111b
		movwf   LCDG
		movfw   F_BL
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movff   lcd_temp,LCDs
		
		movfw   F_Bh
		andlw   00001111b
		movwf   LCDB
		movfw   F_Bh
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movff   lcd_temp,LCDQ
		return
sub_adjust_wd1:		        
        call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
		call	sub_rrf4b_ebh
;		MOVFF   F_BH,AdBufferm
		movfw   F_BL
		andlw   00001111b
		movwf   LCDG
		movfw   F_BL
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movff   lcd_temp,LCDs
		
		movfw   F_Bh
		andlw   00001111b
		movwf   LCDB
		movfw   F_Bh
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		movff   lcd_temp,LCDQ
		
		movfw   LCDG
		addlw   1
		movwf   LCDG
		movlw   10
		subwf   LCDG,0
		btfss   status,c
		return
		clrf    LCDG
		movfw   LCDs
		addlw   1
		movwf   LCDs
		movlw   10
		subwf   LCDs,0
		btfss   status,c
		return
		clrf    LCDs
		movfw   LCDb
		addlw   1
		movwf   LCDb
		movlw   10
		subwf   LCDb,0
		btfss   status,c
		return
		clrf    LCDb
		movfw   LCDq
		addlw   1
		movwf   LCDq
		movlw   10
		subwf   LCDb,0
		btfss   status,c
		return
		clrf    lcdq
		clrf    lcdb
		clrf    lcds
		clrf    lcdg
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
		bsf     R_LED_SIGN,0     ;;;kg
              		
		return
;;;-----------------------------------------
sub_dsp_cal50:
        call    sub_dsp_cal
        movlf	Lcdch5,LCDB                
		call    SUB_DSP_REAL
		bsf		R_LED_SIGN,1	;;; .  	
		return
;;;;--------------------------------------
sub_dsp_cal100:
        call    sub_dsp_cal
        movlf   Lcdch1,LCDQ 
        movlf	Lcdch0,LCDB               
		call    SUB_DSP_REAL
		bsf		R_LED_SIGN,1	;;; .  	
		return		
;;;;--------------------------------------
sub_dsp_cal150:
        call    sub_dsp_cal
        movlf   Lcdch1,LCDQ 
        movlf	Lcdch5,LCDB                
		call    SUB_DSP_REAL
		bsf		R_LED_SIGN,1	;;; .  	
		return
		
;;;;=========================================
sub_dsp_pass:
        call    Sub_Dsp_Lcd_Null
;		Movlf   LcdchP,LCDQ
;		movlf   LcdchA,LCDB
        Movlf   LcdchF,LCDS
        bsf		R_LED_SIGN,3
;        movwf	LCDG        
		call    SUB_DSP_REAL
		return
;;;=========================================	
sub_dsp_clr:
        call    Sub_Dsp_Lcd_Null
		movlf   Lcdchc,LCDB
        Movlf   Lcdchl,LCDS
        Movlf   Lcdchr,LCDG  
        bsf		R_LED_SIGN,3      
		call    SUB_DSP_REAL
		
		return 
;********************************************
sub_end_err:
        call    Sub_Dsp_Lcd_Null
		movlf   LcdchE,LCDB
        Movlf   Lcdchn,LCDS
        Movlf   Lcdchd,LCDG    
        bsf		R_LED_SIGN,3    
		call    SUB_DSP_REAL
		return     
;;;******************************************
Sub_Lowbat_Dsp:
		call    Sub_Dsp_Lcd_Null
		MOVLF   LcdchL,LCDB
		movlf   Lcdcho,lcdS
  	    bsf		R_LED_SIGN,3  
    	call    sub_dsp_real	
		return
;;;------------------------------------------
sub_over_err:
		call    Sub_Dsp_Lcd_Null
		movlf   Lcdche,LCDB		
		movlf   Lcdchr,LCDS
		movlf   Lcdchr,LCDG
		bsf		R_LED_SIGN,3
    	call    sub_dsp_real  	
        return
;-------------------------------------
sub_dsp_c:
        call    Sub_Dsp_Lcd_Null
        movlf   LcdchC,LCDS
        bsf		R_LED_SIGN,3
    	call    sub_dsp_real  	
        return
;;;-------------------------------------------
sub_Dsp_BCD:
		call    	sub_Hex2BCD
sub_Dsp_Data:	
        bcf         full_flag,0	
		movff   	F_bl,AdBufferl
		movff   	F_bh,AdBufferm
sub_Dsp:	
        movlw   	02h          		   ; 自动开机，设0.2KG起秤
	    subwf   	F_bl,0
	    movlw   	00h
	    subwfc  	F_bh,0
	    btfsc       status,c
	    goto        sub_Dsp1
	    clrf        lcdq
	    clrf        lcdb
	    clrf        lcds
	    clrf        lcdg
sub_Dsp1:	            
               	    
		call    	Sub_Dsp_Counter
		call    	sub_dsp_real
		bsf         led7,1 
		return
;;;-------------------------------------------        
sub_ifdsp_dotu:
		clrf	R_LED_SIGN       
        btfsc	Unit_Flag,Unit_lb
        goto	set_lb
        bsf     R_LED_SIGN,0     ;;;kg
        bsf		R_LED_SIGN,1	 ;;; . 
        return          
set_lb:
        bsf     R_LED_SIGN,0     ;;;lb
;        bsf		R_LED_SIGN,4	 ;;; . 
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
        bsf      full_flag,0
		movlw    0ffh	
;		goto     Dsp_Lcd_Xxx
;        movwf	R_LED_SIGN
;        movwf   LCDQ
        movwf   LCDB
        movwf   LCDS
        movwf   LCDG
;        movwf   temp_h
;        movwf   temp_l
        call    sub_dsp_real
        return
;--------------------------------------
Sub_Dsp_Lcd_All0:
        bsf      full_flag,0
		movlw    0ffh	
;		goto     Dsp_Lcd_Xxx
        movwf	R_LED_SIGN
        movwf   LCDQ
        movwf   LCDB
        movwf   LCDS
        movwf   LCDG
        movwf   temp_h
        movwf   temp_l
        call    sub_dsp_real
        return
;;;----------------------------------------
Sub_Dsp_Lcd_Null:
        bcf      full_flag,0
		movlw    000h
		goto     Dsp_Lcd_Xxx
Dsp_Lcd_Xxx:
		movwf	R_LED_SIGN
        movwf   LCDQ
        movwf   LCDB
        movwf   LCDS
        movwf   LCDG
;        movwf   temp_h
;        movwf   temp_l
        call    sub_dsp_real	
	    return
;;;------------------------------------------
;;;============================================
SUB_DSP_REAL:
        ;---连续赋值
		movfw	LCDQ
		movwf	R_LED_D1
		movfw	LCDB
		movwf	R_LED_D2
		movfw	LCDS
		movwf	R_LED_D3
		movfw	LCDG
		movwf	R_LED_D4
		movfw   temp_h
		movwf   R_LED_D5
		movfw   temp_l
		movwf   R_LED_D6
		movfw	R_LED_SIGN
		movwf	R_LED_D7
		
		call	LED_YINSHE_CLR
		call	LED_YINSHE_TIAOZHENG
		call	LED_YINSHE_FUZHI
                             
		RETURN


LED_YINSHE_CLR:
		clrf	R_LED_TEMP1
		clrf	R_LED_TEMP2
		clrf	R_LED_TEMP3
		clrf	R_LED_TEMP4
		clrf	R_LED_TEMP5
		clrf	R_LED_TEMP6
		clrf	R_LED_TEMP7		
		RETURN
		
LED_YINSHE_FUZHI:
		movfw	R_LED_TEMP1
		movwf	LED1
		movfw	R_LED_TEMP2
		movwf	LED2
		movfw	R_LED_TEMP3
		movwf	LED3
		movfw	R_LED_TEMP4
		movwf	LED4
		movfw	R_LED_TEMP5
		movwf	LED5
		movfw	R_LED_TEMP6
		movwf	LED6
		movfw	R_LED_TEMP7
		movwf	LED7
		RETURN


;通用版本	
LED_YINSHE_TIAOZHENG:
		;---LED1映射转换
		btfsc	R_LED_D1,0
		bsf		LED1_1U
		btfsc	R_LED_D1,1
		bsf		LED1_1D
		btfsc	R_LED_D1,2
		bsf		LED1_UU
		btfsc	R_LED_D1,3
		bsf		LED1_DD
		btfsc	R_LED_D1,4
		bsf		LED1_MM
		btfsc	R_LED_D1,5
		bsf		LED1_CM
		btfsc	R_LED_D1,6
		bsf		LED1_G	
		;---LED2映射转换
		btfsc	R_LED_D2,0
		bsf		LED2_A
		btfsc	R_LED_D2,1
		bsf		LED2_B
		btfsc	R_LED_D2,2
		bsf		LED2_C
		btfsc	R_LED_D2,3
		bsf		LED2_D
		btfsc	R_LED_D2,4
		bsf		LED2_E
		btfsc	R_LED_D2,5
		bsf		LED2_F
		btfsc	R_LED_D2,6
		bsf		LED2_G	
		;---LED3映射转换
		btfsc	R_LED_D3,0
		bsf		LED3_A
		btfsc	R_LED_D3,1
		bsf		LED3_B
		btfsc	R_LED_D3,2
		bsf		LED3_C
		btfsc	R_LED_D3,3
		bsf		LED3_D
		btfsc	R_LED_D3,4
		bsf		LED3_E
		btfsc	R_LED_D3,5
		bsf		LED3_F
		btfsc	R_LED_D3,6
		bsf		LED3_G		
		;---LED4映射转换
		btfsc	R_LED_D4,0
		bsf		LED4_A
		btfsc	R_LED_D4,1
		bsf		LED4_B
		btfsc	R_LED_D4,2
		bsf		LED4_C
		btfsc	R_LED_D4,3
		bsf		LED4_D
		btfsc	R_LED_D4,4
		bsf		LED4_E
		btfsc	R_LED_D4,5
		bsf		LED4_F
		btfsc	R_LED_D4,6
		bsf		LED4_G		
		;---LED5映射转换
		btfsc	R_LED_D5,0
		bsf		LED5_A
		btfsc	R_LED_D5,1
		bsf		LED5_B
		btfsc	R_LED_D5,2
		bsf		LED5_C
		btfsc	R_LED_D5,3
		bsf		LED5_D
		btfsc	R_LED_D5,4
		bsf		LED5_E
		btfsc	R_LED_D5,5
		bsf		LED5_F
		btfsc	R_LED_D5,6
		bsf		LED5_G
		;---LED6映射转换
		btfsc	R_LED_D6,0
		bsf		LED6_A
		btfsc	R_LED_D6,1
		bsf		LED6_B
		btfsc	R_LED_D6,2
		bsf		LED6_C
		btfsc	R_LED_D6,3
		bsf		LED6_D
		btfsc	R_LED_D6,4
		bsf		LED6_E
		btfsc	R_LED_D6,5
		bsf		LED6_F
		btfsc	R_LED_D6,6
		bsf		LED6_G
		
		;---LED7映射转换
		btfsc	R_LED_D7,0
		bsf		LED7_KG       ;KG
		btfsc	R_LED_D7,1
		bsf		LED7_DOT      ;小数点
		btfsc	R_LED_D7,2
		bsf		LED7_BMI      ;BMI
		btfsc	R_LED_D7,3
		bsf		LED7_C        ;.C
		btfsc	R_LED_D7,4
		bsf		LED7_S	      ;偏瘦
		btfsc	R_LED_D7,5
		bsf		LED7_N    	  ;正常
		btfsc	R_LED_D7,6
		bsf		LED7_F    	  ;偏胖
		btfsc	R_LED_D7,7
		bsf		LED7_FAT      ;肥胖
		return
		
		
	
LED_YINSHE_TIAOZHENG5:
	clrf	R_LED_TEMP1
	clrf	R_LED_TEMP2
	clrf	R_LED_TEMP3
	clrf	R_LED_TEMP4
	clrf	R_LED_TEMP5
	clrf	R_LED_TEMP6
	clrf	R_LED_TEMP7
	
	
	;---LED1映射转换
	btfsc	R_LED_D1,0      ;单字1上
	bsf		R_LED_TEMP3,0
	btfsc	R_LED_D1,1      ;单字1下
	bsf		R_LED_TEMP1,4
	btfsc	R_LED_D1,2
	bsf		R_LED_TEMP6,7
	btfsc	R_LED_D1,3
	bsf		R_LED_TEMP1,3
	btfsc	R_LED_D1,4
	bsf		R_LED_TEMP6,6
	btfsc	R_LED_D1,5
	bsf		R_LED_TEMP6,0

	;---LED2映射转换
	btfsc	R_LED_D2,0
	bsf		R_LED_TEMP2,0
	btfsc	R_LED_D2,1
	bsf		R_LED_TEMP1,0
	btfsc	R_LED_D2,2
	bsf		R_LED_TEMP2,1
	btfsc	R_LED_D2,3
	bsf		R_LED_TEMP1,6
	btfsc	R_LED_D2,4
	bsf		R_LED_TEMP2,2
	btfsc	R_LED_D2,5
	bsf		R_LED_TEMP4,6
	btfsc	R_LED_D2,6
	bsf		R_LED_TEMP2,3
	
	
	;---LED3映射转换
	btfsc	R_LED_D3,0
	bsf		R_LED_TEMP2,5
	btfsc	R_LED_D3,1
	bsf		R_LED_TEMP2,7
	btfsc	R_LED_D3,2
	bsf		R_LED_TEMP5,0
	btfsc	R_LED_D3,3
	bsf		R_LED_TEMP1,1
	btfsc	R_LED_D3,4
	bsf		R_LED_TEMP3,7
	btfsc	R_LED_D3,5
	bsf		R_LED_TEMP3,1
	btfsc	R_LED_D3,6
	bsf		R_LED_TEMP7,7
	
	
	
	;---LED4映射转换
	btfsc	R_LED_D4,0
	bsf		R_LED_TEMP2,6
	btfsc	R_LED_D4,1
	bsf		R_LED_TEMP1,5
	btfsc	R_LED_D4,2
	bsf		R_LED_TEMP5,1
	btfsc	R_LED_D4,3
	bsf		R_LED_TEMP5,5
	btfsc	R_LED_D4,4
	bsf		R_LED_TEMP5,7
	btfsc	R_LED_D4,5
	bsf		R_LED_TEMP4,1
	btfsc	R_LED_D4,6
	bsf		R_LED_TEMP4,0
	
	;---LED5映射转换
	btfsc	R_LED_D5,0
	bsf		R_LED_TEMP2,4
	btfsc	R_LED_D5,1
	bsf		R_LED_TEMP5,6
	btfsc	R_LED_D5,2
	bsf		R_LED_TEMP4,7
	btfsc	R_LED_D5,3
	bsf		R_LED_TEMP5,2
	btfsc	R_LED_D5,4
	bsf		R_LED_TEMP5,4
	btfsc	R_LED_D5,5
	bsf		R_LED_TEMP5,3
	btfsc	R_LED_D5,6
	bsf		R_LED_TEMP1,2	
	


	;---LED6映射转换
	btfsc	R_LED_D6,0
	bsf		R_LED_TEMP3,6
	btfsc	R_LED_D6,1
	bsf		R_LED_TEMP3,5
	btfsc	R_LED_D6,2
	bsf		R_LED_TEMP4,5
	btfsc	R_LED_D6,3
	bsf		R_LED_TEMP1,7
	btfsc	R_LED_D6,4
	bsf		R_LED_TEMP4,2
	btfsc	R_LED_D6,5
	bsf		R_LED_TEMP4,4
	btfsc	R_LED_D6,6
	bsf		R_LED_TEMP4,3
	
	;---LED7映射转换
	btfsc	R_LED_D7,0       ;KG
	bsf		R_LED_TEMP3,2
	btfsc	R_LED_D7,1       ;小数点
	bsf		R_LED_TEMP3,3
	btfsc	R_LED_D7,2
	bsf		R_LED_TEMP3,4    ;BMI
	btfsc	R_LED_D7,3
	bsf		R_LED_TEMP6,1    ;.C
	btfsc	R_LED_D7,4
	bsf		R_LED_TEMP6,2    ;偏瘦
	btfsc	R_LED_D7,5
	bsf		R_LED_TEMP6,3    ;正常
	btfsc	R_LED_D7,6
	bsf		R_LED_TEMP6,4    ;偏胖
    btfsc	R_LED_D7,7
	bsf		R_LED_TEMP6,5    ;肥胖
    
	movfw	R_LED_TEMP1
	movwf	LED1
	movfw	R_LED_TEMP2
	movwf	LED2
	movfw	R_LED_TEMP3
	movwf	LED3
	movfw	R_LED_TEMP4
	movwf	LED4
	movfw	R_LED_TEMP5
	movwf	LED5
	movfw	R_LED_TEMP6
	movwf	LED6
	movfw	R_LED_TEMP7
	movwf	LED7
	
	return		
	
	
			
ENDIF



