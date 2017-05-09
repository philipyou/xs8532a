;;;****************************************************
;;;================================================
sub_pt1_set:
		movlw   01010000b
		movwf	PT1EN   	;
		movlw   10101111b
		movwf	PT1PU   	;00h 上拉
		clrf	PT1 
		bsf     ptint,0		
		return
	
;;;================================================
sub_pt2_set:
		movlw   10011000b	;0,0,0,0,aeneb1,0,0,0 置1 P1.4为数字口
		movwf	aienb   
		bcf		spicfg,spien	
		movlw   11111111b
		movwf	PT2EN   	
		movlw   00000000b
		movwf	PT2PU   	
		movlw	00000000b
		movwf	PT2	
		clrf	pt2con
		
		;bsf		aienb,aienb3
		;bsf		aienb,aienb2
		;bsf		aienb,aienb1	
		
	    return	



;;;================================================
sub_mp_option:
		call    Sub_Dsp_Lcd_Null
		call    sub_clear_allint
		call    sub_pt1_set
		call    sub_pt2_set
		clrf    wdtcon			
		
		;clrf	NETA				;(sinl[1:0],sens[1:0],0,chpcks[2:0])  ADC输入端连接AIN0和AIN1 
		movlw	00000000b
		movwf	NETA
		
		bcf		NETC,ADEN           ;关ADEN 
		
		movlw	00100011b
		movwf	NETF		;(0,0,ENVDDA,0,0,0,0,ENVB)  ENVDDA,ENVB高电平使能	
		
		movlw	d10ms
		call	sub_delay_1ms		
		
		movlw	10001010b   ;使能AD
		movwf	NETC		;(chopm[1:0],0,0,adg[1:0],aden,0)   PGA=64		
;.....................................
; Control ADC
;.....................................
		movlw	00000111b
		movwf	ADCON		;(0,0,0,0,0,adm[2:0]) 这里ADCF为250K,ADC输出速率为ADCF/8000约31HZ左右
		movlw   11000010b
		movwf	NETE      ;(LDOS[1:0],0,0,SILB[1:0],ENLB,0)
        movlw	00000001b
        movwf	METCH		;1186 温补   
        
        movlw	01100000b
        movwf	tempc
                  		
		return   		


;;;==================================================
;;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Sub_Cali_adz_T:
		bcf			SYS_FLAG2,bf_cal
		bcf		SYS_FLAG1,OpenTime			;;;首次开机时间长
		bcf			SYS_FLAG1,ScanKey
		;mc_check_otp_scounter   20h,00h,7
		;movfw   	o_rtimes
		;sublw   	19
		;btfss   	status,c
		;goto    	save_err2
		;call    	sub_cleareax                ;;;清除eax
		;movwf   	F_al
		;call    	sub_Dsp_BCD                 ;;转换成BCD码显示		
		call		sub_cal_delay 		 	    
	    movlf   	09h,filter_xs
		bsf			Calu_Flag,cal_time
		clrf		Adf_Times	   
;;;----------------------------------------------	    
sub_cal_zero:	
	    call    Sub_Get_Adc
	    call    Sub_Adc_Filter
			    	    
        clrf    F_eal		
	    movff   Adbuf0h,F_ah
	    movff   Adbuf0l,F_al
		
		movlw	01h
		subwf	Times_l,1					  	;;;不稳定关机时间   60s 01c8h
		movlw	00h
		subwfc	Times_h,1
		jc
;		nop
;		nop
		goto	mp_weight_over		;;;60s关机
				

        bcf     status,c
        rlf     F_al,1        
        rlf     F_ah,1
        bcf     status,c
        rlf     F_al,1         
        rlf     F_ah,1      
		call	sub_Dsp_BCD

		
				
sub_zero_cal:
;		goto    sub_cal_zero
		
	    je_fd   Adf_Times,08H		;;;
	    goto    sub_cal_zero 
;	    btfsc	hard_key,UINT
;	    goto  	sub_zero_cal_1
;	    clrf	Adf_Times
;	    goto	sub_cal_zero
        bcf		SYS_FLAG2,wt_cal	       
sub_zero_cal_1: 
;;;---------------------------------------
	    movff   AdBuf0l,cAd0_Zerol
	    movff   AdBuf0h,cAd0_Zeroh

			        		        	    
	    call	sub_dsp_cal50
		call	sub_cal_delay 	    
;;;--------------------------------------------------
cali_s1:			
	    call    Sub_Get_Adc
	    call    Sub_Adc_Filter 	    
;;;---------------------------------------
	    movfw   cAd0_Zerol
	    subwf   AdBuf0l,0
	    movwf   Cali_KBL
	
	    movfw   cAd0_Zeroh
	    subwfc  AdBuf0h,0
	    movwf   Cali_KBEL

	    			
	    btfsc   STATUS,C           			;;;yes/no 
	    goto    cali_sf1	    
	    clrf    cali_kbl					;不够减
	    clrf    cali_kbel	    
;;;-------------------------------------------------
cali_sf1:

		movlw	01h
		subwf	Times_l,1					  	;;;不稳定关机时间   60s 01c8h
		movlw	00h
		subwfc	Times_h,1
		jc
		goto	mp_weight_over		;;;60s关机
        	    	            
	    je_fd   Adf_Times,08H		;;;
	    goto    cali_s1
	    
	    
	    ;------------------------------------------标定50KG这段时间要实时更新零点方便标定操作
	    movlf   	AdBuf0l,fsr0
		movff2   	cad0_zerol,A_BesL
		call    	Sub_Sub_Abs_BES
		btfsc		Calu_Flag,R_Is_MBE
		goto		cali_sf1_1				;AD值比之前的零点AD值小，要直接更新零点
		movfw   	open_weightl            ;AD值比之前的零点AD值大，要 小于+3KG追零范围才追零
		subwf   	R_Sub,0
		movfw   	open_weighth
		subwfc  	R_Subh,0
		btfsc   	status,c
		goto    	cali_sf1_2			
cali_sf1_1:        
		movff   	AdBuf0l,cad0_zerol                        
		movff   	AdBuf0h,cAd0_Zeroh
cali_sf1_2:	    	    
	    ;-------------------------------------------
	    
	     	    
	    movlw   03h
	    subwf   Cali_KBEL,0
	    btfss   STATUS,C
	    goto    cali_s1
;;;---------------------------------------
		 	
	    call	sub_dsp_cal100
		call	sub_cal_delay 	    	    	
;;;---------------------------------------------------------
cali_s2:
	    call    Sub_Get_Adc
	    call    Sub_Adc_Filter	    
;;;---------------------------------------
	    movfw   cAd0_Zerol
	    subwf   AdBuf0l,1
	    movfw   cAd0_Zeroh
	    subwfc  AdBuf0h,1
        btfss   status,c
        goto    cali_zero2
        
	    movfw   Cali_KBL
	    subwf   AdBuf0l,1
	    movfw   Cali_KBEL
	    subwfc  AdBuf0h,1

	    movff   AdBuf0h,Cali_KBEh
	    movff   AdBuf0l,Cali_KBH
	
	    btfsc   STATUS,C           ;;;yes/no 
	    goto    cali_sf2
cali_zero2:	    
	    clrf    cali_kbh
	    clrf    cali_kbeh
;;;-------------------------------------------------
cali_sf2:

		movlw	01h
		subwf	Times_l,1					  	;;;不稳定关机时间   60s 01c8h
		movlw	00h
		subwfc	Times_h,1
		jc
		goto	mp_weight_over		;;;60s关机 
	    	    	            
	    je_fd   Adf_Times,08H		;;; 
	    goto    cali_s2	    	
       
;	    movlw   03h	
;	    subwf   Cali_KBEH,0
;	    btfss   STATUS,C
;	    goto    cali_s2	
        movlf   	Cali_KBH,fsr0
		movff2   	Cali_KBL,A_BesL
		call    	Sub_Sub_Abs_BES
		movlw   	e8h            ;大小于+10KG范围才有效
		subwf   	R_Sub,0
		movlw   	03h
		subwfc   	R_Subh,0
		btfsc   	status,c
		goto    	cali_s2	
;;;---------------------------------------
              	
	    call	sub_dsp_cal150
		call	sub_cal_delay  	    		
;;;--------------------------------------------------
cali_s3:		
	    call    Sub_Get_Adc
	    call    Sub_Adc_Filter	    
;;;---------------------------------------
	    movfw   cAd0_Zerol
	    subwf   AdBuf0l,1
	    movfw   cAd0_Zeroh
	    subwfc  AdBuf0h,1
        btfss   status,c
        goto    cali_zero3

	    movfw   Cali_KBL
	    subwf   AdBuf0l,1
	    movfw   Cali_KBEL
	    subwfc  AdBuf0h,1
        btfss   status,c
        goto    cali_zero3	    
        
	    movfw   Cali_KBH
	    subwf   AdBuf0l,1
	    movfw   Cali_KBEH
	    subwfc  AdBuf0h,1
	        
	    movff   AdBuf0h,Cali_EKBEH
	    movff   AdBuf0l,Cali_EKBH
;;;-----------------------------------------
	    btfsc   STATUS,C           ;;;yes/no 
	    goto    cali_sf3
cali_zero3:	    
	    clrf    cali_ekbh
	    clrf    cali_ekbeh
;;;-------------------------------------------------
cali_sf3:

		movlw	01h
		subwf	Times_l,1					  	;;;不稳定关机时间   60s 01c8h
		movlw	00h
		subwfc	Times_h,1
		jc
		goto	mp_weight_over		;;;60s关机
	    	    	            
	    je_fd   Adf_Times,08H 
	    goto    cali_s3
	    
;	    movlw   03h	
;	    subwf   Cali_EKBEH,0
;	    btfss   STATUS,C
;	    goto    cali_s3
	   
	   movlf   	Cali_EKBH,fsr0
		movff2   	Cali_KBH,A_BesL
		call    	Sub_Sub_Abs_BES
		movlw   	e8H            ;大小于+10KG范围才有效
		subwf   	R_Sub,0
		movlw   	03H
		subwfc   	R_Subh,0
		btfsc   	status,c
		goto    	cali_s3
		
	    clrwdt
	    clrf	wdtcon
	    
		call		sub_CaluOtp_XOR
		movff		F_al,Cali_XORL
		clrf		adctimes
		bcf			Calu_Flag,cal_time				               	    	     
;;;---------------------------------------
save_eeprom:
	    movff   cAd0_Zerol,Ad0_Zerol
	    movff   cAd0_Zeroh,Ad0_Zeroh
        bcf      sys_flag2,program
        call     Sub_Dsp_Lcd_Null
		mc_write_ram_to_otp_scounter  20h,00h,c0h,7       
save_ok:     
		btfsc   	Sys_Flag2,program
		goto    	save_err1
save_e2ok:		      
		call    	sub_dsp_pass
		goto    	save_ok1
save_err1:
		call    	sub_over_err
		goto    	save_ok1
save_err2:
		call    	sub_end_err
save_ok1:
        call    sub_calu_openweight
 	 	movlw   5
		call    sub_delay_s	    	    	    
		bcf     ad_flag,weight0
	    movlf   19h,filter_xs		       
		call	sub_clear_allint
		bsf		Ad_Flag,cal_model		;;;标定完测试
		bcf		Ad_Flag,lock_open
		bcf		Ad_Flag,lock_dsp
	    goto	sub_weight0_ok
;;;==========================================
sub_cal_delay:
	    movlw   	1
	    call    	sub_delay_s
		clrf		adctimes
   	    movlf		0c8h,Times_l
   	    movlf		01h,Times_h	 
		return		       