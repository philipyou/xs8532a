;;;**********************************************************
Sub_Get_Adc:
		bcf		SYS_FLAG1,F_SADC
		clrf    adc_int_times
		clrf    AdcBuf0l
		clrf    AdcBuf0h
		clrf    AdcBuf0el
		call	sub_clr_sort
		bsf		inte,adie
		bsf		inte,gie
adc_int_Loop:
		halt
    	nop
		nop
		btfss	Calu_Flag,ad_cal
		goto	adc_int_loop
		bcf		Calu_Flag,ad_cal
		
		call	sub_sort_cal	       		
		JE_FD   adc_int_times,4     ;;;我已将平均次数由4次改成8次，看看重量刷新率是否OK
		goto    adc_int_Loop
;;;--------------------------------------------------------				
		bcf		inte,adie	
		
		movfw   ad_sort_h2_l    		
		addwf   AdcBuf0l,1
		movfw   ad_sort_h2_h    	    	
		addwfc  AdcBuf0h,1
		movlw   00h		
		addwfc  AdcBuf0el,1
		
		movfw   ad_sort_h3_l    		
		addwf   AdcBuf0l,1
		movfw   ad_sort_h3_h    	    	
		addwfc  AdcBuf0h,1
		movlw   00h		
		addwfc  AdcBuf0el,1
		
		call    Sub_rrf3b_sl_c   	;;; rrf3b_sl_c is /2 with carry,3 byte,from low_byte.平均(除于2)
		movff   AdcBuf0h,AdBuf0h
		movff   AdcBuf0l,AdBuf0l		
		return

sub_clr_sort:
		clrf	ad_sort_h1_l
		clrf	ad_sort_h1_h
		clrf	ad_sort_h2_l
		clrf	ad_sort_h2_h
		clrf	ad_sort_h3_l
		clrf	ad_sort_h3_h
		clrf	ad_sort_h4_l
		clrf	ad_sort_h4_h
		
		clrf	ad_sort_h5_l
		clrf	ad_sort_h5_h
		clrf	ad_sort_h6_l
		clrf	ad_sort_h6_h
		clrf	ad_sort_h7_l
		clrf	ad_sort_h7_h
		clrf	ad_sort_h8_l
		clrf	ad_sort_h8_h
		return
		
;h1>h2>h3>h4
sub_sort_cal:
		movfw	Radcl
		movwf	ad_sort_h0_l
		movfw	Radceh
		movwf	ad_sort_h0_h
sub_sort_cal_h1:		
		movfw	ad_sort_h1_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h1_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h2
		
		mov_7to8
		mov_6to7
		mov_5to6
		mov_4to5
		mov_3to4
		mov_2to3
		mov_1to2
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h1_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h1_h
		
		goto	sub_sort_cal_exit
sub_sort_cal_h2:
		movfw	ad_sort_h2_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h2_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h3
		
		mov_7to8
		mov_6to7
		mov_5to6
		mov_4to5
		mov_3to4
		mov_2to3
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h2_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h2_h		

		goto	sub_sort_cal_exit
sub_sort_cal_h3:
		movfw	ad_sort_h3_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h3_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h4
		
		mov_7to8
		mov_6to7
		mov_5to6
		mov_4to5
		mov_3to4
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h3_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h3_h
				
		goto	sub_sort_cal_exit
sub_sort_cal_h4:	
		movfw	ad_sort_h4_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h4_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h5
		
		mov_7to8
		mov_6to7
		mov_5to6
		mov_4to5
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h4_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h4_h
		
		goto	sub_sort_cal_exit
sub_sort_cal_h5:	
		movfw	ad_sort_h5_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h5_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h6
		
		mov_7to8
		mov_6to7
		mov_5to6
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h5_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h5_h
		
		goto	sub_sort_cal_exit
sub_sort_cal_h6:	
		movfw	ad_sort_h6_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h6_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h7
		
		mov_7to8
		mov_6to7
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h6_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h6_h
		
		goto	sub_sort_cal_exit		

sub_sort_cal_h7:	
		movfw	ad_sort_h7_l
		subwf	ad_sort_h0_l,w
		movfw	ad_sort_h7_h
		subwfc	ad_sort_h0_h,w
		btfss	status,c
		goto	sub_sort_cal_h8
		
		mov_7to8
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h7_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h7_h
		
		goto	sub_sort_cal_exit
sub_sort_cal_h8:	
		
		movfw	ad_sort_h0_l
		movwf	ad_sort_h8_l
		movfw	ad_sort_h0_h
		movwf	ad_sort_h8_h
		
		goto	sub_sort_cal_exit		
sub_sort_cal_exit:
		return
;;;*******************************************
;;;*******************************************
Sub_Get_hAdc:
		bsf		SYS_FLAG1,F_SADC
	    movlf	00000001b,ADCON		;(0,0,0,0,0,adm[2:0]) ADC输出速率为ADCF/8000  	
		clrf    adc_int_times		
		clrf    AdcBuf0l
		clrf    AdcBuf0h
		clrf    AdcBuf0el
		bsf		inte,adie
		bsf		inte,gie	    	    	    
adc_int_Loop1:
	    halt
	    nop
		nop
		movlw    04h		
		subwf    adc_int_times,0
		jc			
		goto    adc_int_Loop1		
 	    bcf     status,c   	            
		movfw   Radcl    		
		addwf   AdcBuf0l,1
		movfw   Radceh    	    	
		addwfc  AdcBuf0h,1
		movlw   00h		
		addwfc  AdcBuf0el,1
	       		
		JE_FD   adc_int_times,05     ;;;我已将平均次数由4次改成2次，看看重量刷新率是否OK
		goto    adc_int_Loop1	
;;;--------------------------------------------------------				
		bcf		inte,adie
		clrf	NETF
		clrf	NETE			
	    call    Sub_rrf3b_sl_c   	;;; rrf3b_sl_c is /2 with carry,3 byte,from low_byte.平均(除于2)	    				
		movff   AdcBuf0h,AdBuf0h
		movff   AdcBuf0l,AdBuf0l
		return
;;;==========================================
Sub_rrf3b_sl_c:
        rrf3b_sl_c  AdcBuf0l 
        RETURN                              	     	     	     	                                  
;;;*************************************************

;用来做延时
;;;**********************************************************
Sub_Get_Adc_Delay:
		bcf		SYS_FLAG1,F_SADC
		clrf    adc_int_times
		bsf		inte,adie
		bsf		inte,gie
adc_int_Delay_Loop:
		halt
    	nop
		nop
		btfss	Calu_Flag,ad_cal
		goto	adc_int_Delay_loop
		bcf		Calu_Flag,ad_cal			   	            
	       		
		JE_FD   adc_int_times,4     ;;;我已将平均次数由4次改成8次，看看重量刷新率是否OK
		goto    adc_int_Delay_Loop
;;;--------------------------------------------------------				
		bcf		inte,adie		
		return
;;;*******************************************
     
        
;;;************************************************************		