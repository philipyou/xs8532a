;;;*******************************************
Sub_Get_T_Adc:
		bcf		SYS_FLAG1,F_SADC
		clrf    adc_int_times
		clrf    AdcBuf0l
		clrf    AdcBuf0h
		clrf    AdcBuf0el
		bsf		inte,adie
		bsf		inte,gie
adc_int_T_Loop:
		halt
    	nop
		nop
		btfss	Calu_Flag,ad_cal
		goto	adc_int_T_loop
		bcf		Calu_Flag,ad_cal			   	            
		movfw   Radcel    		
		addwf   AdcBuf0l,1
		movfw   Radcl    	    	
		addwfc  AdcBuf0h,1
		movfw   Radceh		
		addwfc  AdcBuf0el,1
		movlw	00h
		addwfc  AdcBuf0eh,1		
	       		
		JE_FD   adc_int_times,4     ;平均次数4次
		goto    adc_int_T_Loop
;;;----------------------------------------------			
		bcf		inte,adie		
		rrf4b_sl_c  AdcBuf0l 	; rrf3b_sl_c is /2 with carry
		rrf4b_sl_c  AdcBuf0l 	; rrf3b_sl_c is /2 with carry
		movff   AdcBuf0el,AdBuf0el		
		movff   AdcBuf0h,AdBuf0h
		movff   AdcBuf0l,AdBuf0l		
		return


Sub_temperature_SET:		
		movfw	NETA
		movwf	NETA_BAK
		movfw	NETC
		movwf	NETC_BAK
		movfw	NETE
		movwf	NETE_BAK	
		movfw	NETF
		movwf	NETF_BAK
		movfw	ADCON
		movwf	ADCON_BAK
		movfw	TEMPC
		movwf	TEMPC_BAK
		
		movlw	10010000b
		movwf	NETA
		movlw	10000010b
		movwf	NETC
		movlw	11000000b
		movwf	NETE
		movlw	00100010b
		movwf	NETF
		movlw	00000111b
		movwf	ADCON
		clrf	TEMPC
		
		bsf		UserFlag,F_TEMP
		
;		movlw	e8h
;		movwf	Cali_temp_l
;		movlw	03h
;		movwf	Cali_temp_h
		
		movlw   1fh
		movwf   EADRH
		movlw   fdh
		movwf   EADRL		
		movp	
		movwf	Cali_T_adh

		movlw   1fh
		movwf   EADRH
		movlw   feh
		movwf   EADRL	
		movp
		movwf   Cali_T_adl	
		movfw	EDAT
		movwf   Cali_T_adm
		
		movlw   1fh
		movwf   EADRH
		movlw   ffh
		movwf   EADRL		
		movp
		movwf   Cali_temp_l	
		movfw	EDAT
		movwf   Cali_temp_h
		
		movlw   ffh
		xorwf   Cali_temp_h,0
		btfss   status,z
		goto    Sub_temperature_SET_e
		
	    movlw   ffh
		xorwf   Cali_temp_l,0
		btfss   status,z
		goto    Sub_temperature_SET_e
		
		movlw   0bh
		movwf   Cali_temp_h	
		movlw   11h
		movwf   Cali_temp_l			
		movlw	3ah
		movwf	Cali_T_adh
		movlw	d9h
		movwf	Cali_T_adm
		movlw	33h
		movwf	Cali_T_adl				
Sub_temperature_SET_e:
	    return
Sub_temperature_BACK:		
		movfw	NETA_BAK
		movwf	NETA
		movfw	NETC_BAK
		movwf	NETC
		movfw	NETE_BAK
		movwf	NETE	
		movfw	NETF_BAK
		movwf	NETF
		movfw	ADCON_BAK
		movwf	ADCON
		movfw	TEMPC_BAK
		movwf	TEMPC
		
		
		bcf		UserFlag,F_TEMP		
		return	
	

;;;=========================================================
;;; INPUT IS AdBuf0l, OUT R_Temperature.
sub_calu_temp:
		clrf	r_mul5
		movff	Cali_temp_h,r_mul4
		movff	Cali_temp_l,r_mul3
		
		movlw	b3h				;+27315
		addwf	r_mul3,f
		movlw	6ah
		addwfc	r_mul4,f
		movlw	00h
		addwfc	r_mul5,f
		
		
		
		movff   AdBuf0el,r_mul2
		movff   AdBuf0h,r_mul1
		movff   AdBuf0l,r_mul0
		
		call	F_Mul24U				
		
		movff	Cali_T_adh,r_divisor2
		movff	Cali_T_adm,r_divisor1
		movff	Cali_T_adl,r_divisor0
		
		call	F_Div24U
		clrf	F_ebh
        movff   r_div2,F_ebl
        movff   r_div1,F_bh
        movff   r_div0,F_bl
				
		movlw	b3h
		movwf	A_BesL
		movlw	6Ah
		movwf	A_BesH      ;;;27315 －55 = 27260 ＝6A7Ch 四舍五入
		movlw	F_bl		;;;27315 = 6ab3
		movwf	fsr0
		bcf		bsr,irp0
		call	Sub_Sub_Abs_BES
;;;---------------------------------------------------------------	
			
		clrf    F_ebh
		clrf	F_ebl
		movff   R_Subh,F_bh
		movff   R_Sub,F_bl		

		; ebx = ebh / ecx
    	clrf    F_ech
        clrf    F_ecl
        clrf	F_ch
        movlf   064h,F_cl

		call    sub_4div4	;;;温度变成整数
		
;;;---------------------------------------------------------------		
		movfw	F_bl
		movwf	F_al
		movfw	F_bh
		movwf	F_ah
		clrf	F_eal
		clrf	F_eah
		call	sub_Hex2BCD   ;;;温度变成BCD码
;;;-----------------------------------		
		movfw   F_bl
		movwf	TEMP_DA
		return
		
sub_show_temp:
		movfw	TEMP_DA
		andlw   11110000b
		movwf   lcd_temp
		clrC     
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
		rrf     lcd_temp,1
	
		JE_FD   lcd_temp,00h
		goto    Dsp_Temph
		clrf    temp_h
		goto	Dsp_Templ
Dsp_Temph:
		movfw   lcd_temp
		call    Sub_Dsp_Lcd_Num
		movwf   temp_h
Dsp_Templ:	
		movfw   TEMP_DA
		andlw   00001111b
		call    Sub_Dsp_Lcd_Num
		movwf   temp_l		
		return



	
	


