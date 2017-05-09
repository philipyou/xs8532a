Test_Mode:
      call    sub_pau_e2_data
      
      MOVLW		 255						;;;锁定后的延时增强用户体验
	  call		 F_Delay_Ms
	  MOVLW		 255						;;;锁定后的延时增强用户体验
	  call		 F_Delay_Ms
      
sub_dsp_Test:
      call    Sub_Dsp_Lcd_Null   ;显示----
      call  	sub_show_temp
;      movlf   Lcdch1,LCDQ 
       bsf     lcdq,0
       bsf     lcdq,1
      movlf   Lcdch2,LCDB
      Movlf   Lcdch3,LCDS
      Movlf   Lcdch4,LCDG        
      call    SUB_DSP_REAL
	  movlw   d3s						;指令延时一秒
	  call    sub_delay_12m823  
	  movlw   d3s						;指令延时一秒
	  call    sub_delay_12m823 
;---------------------------------------
;      movlw   10110111B	        	
;	  movwf   LCDENR		        						
	  call	  Sub_Dsp_Lcd_All0		;全显
	  
	  movlf   09h,filter_xs	   
	  movlf   10h,sz_temp	      ;追零
T_mw_sz_loop:
	  decfsz  sz_temp,1
  	  goto	  T_mw_sz_loop1 
	  goto    T_mw_sz_ok 
T_mw_sz_loop1:	
	  call    Sub_Get_Adc	   		
	  call    Sub_Adc_Filter
	  je_fd   Adf_Times,0eH
	  goto    T_mw_sz_loop  
T_mw_sz_ok:       	
	  movff   AdBuf0h,Ad0_Zeroh
	  movff   AdBuf0l,Ad0_Zerol
	   
	  movff   AdBuf0h,cAd0_Zeroh
	  movff   AdBuf0l,cAd0_Zerol
      
    ;---计算开机重量---------------------
T_PO_6:	    
      call    sub_calu_openweight
      
       movlw   d3s						;指令延时一秒
	  call    sub_delay_12m823 
      goto    mp_weight_over       ;进入睡眠
      	
	  call    Sub_Get_Adc 

	  movlw   d1s						;指令延时一秒
	  call    sub_delay_12m823
	
	  call	  sub_initialize_time	
	  call	  sub_weight_initialize	;称重前RAM初始化 	
	  
Test_Funciton:	  
;      btfsc   PT2,1
;	  goto    Test_Funciton
;	  movlw   200
;	  call    sub_delay_1ms 		;;;20MS
;	  btfsc   PT2,1
;	  goto    Test_Funciton
Test_Funciton0:	 
      btfss   PT1,0
	  goto    Test_Funciton0
	  movlw   200
	  call    sub_delay_1ms 		;;;20MS
	  btfss   PT1,0
	  goto    Test_Funciton0	
	  call	  sub_show_temp
Test_Funciton_lp:	
      btfss   PT1,1
	  goto    Test_Funciton_lp1
	  movlw   200
	  call    sub_delay_1ms 		;;;20MS
	  btfsc   PT1,1
	  goto    mp_weight_over        ;进入睡眠
Test_Funciton_lp1:
      movfw   weight_0_times
      addlw   0ffh-04eh                 	
      jnc
      goto    mp_weight_over       ;进入睡眠
		
		;---不稳定关机时间   15s 
	  movlw	  01h
	  subwf	  weight_1_times,1			
	  movlw	  00h
	  subwfc  weight_2_times,1
	  jc
	  goto    mp_weight_over        ;进入睡眠
;	  goto	mw_go0_e
      
      
	  call    Sub_Get_Adc				;获取AD值
      call    Sub_Get_Pure_WC			;计算相对变化量	
	  call    Sub_Adc_Filter    		;滤波 I:AdBuf0l   O: AdBuf0l	
	  call	  sub_weight_cal				;;;进入标定			
	  call    sub_calu_wkg   			;计算重量 I:AdBuf0l O:bl,bh,ebl as kg.
	  call	  sub_samll_weight        ;小重量和追零处理
	  call	  sub_dsp_lock			;锁定处理
	  call	  sub_if_weight_o         ;yes/no dsp 0.0kg
	  call    SUB_WC_MEM_APP          ;记忆 yes/no 0.3kg
	  call    Sub_Test_Battery
	  btfsc   Ad_Flag,AdC_Err    			;低电检测
	  goto    MR_BAT_ERR
	  
	  call    Sub_Real_Wlbkg    			  ;转换当前单位		
  	  clrf    F_eal
	  clrf    F_eah		
	  btfss   Unit_Flag,Unit_lb			  ;lb       
      bcf	  F_bl,0			  			  ;lb只显示2 4 6 8   
      call    sub_Hex2BCD        
      btfss   weight_flag,0   
        goto    mw_go4_30
        clrf    F_bl                         ;负值不显示
        clrf    F_bh
mw_go4_30:                  				
		call	sub_adjust_wd
		call	sub_Dsp
		call    sub_ifdsp_dotu   	
;	    goto    Test_Funciton_lp
		
		
	  call    sub_if_locked_o				   ;是否稳定
	  movff   r_wh,lr_wh
	  movff   r_wl,lr_wl
	  btfsc	  Ad_Flag,lock_dsp
	  goto	  Test_Funciton_lp    
	  jne_fd  same_w_times,07h			    ;稳定次数达到，锁定重量
	  goto    Test_Funciton1
	  goto	  Test_Funciton_lp
Test_Funciton1:	
	  movff   	r_wh,w_memh
	  movff   	r_wl,w_mem		
	  call    	sub_nflash_ntk		      ;下面是重量锁定后判断是否在规定次数内下称，
	  clrf      cnt1
	  movlw     0ffh
	  movwf     cnt2 
Test_Funciton2:	      
      movlw     1
	  call      sub_delay_1ms 		;;;1MS
	  DECFSZ    CNT1,1
	  goto      Test_Funciton3
	  DECFSZ    CNT2,1
	  goto      Test_Funciton3
	  goto      Test_Funciton4
Test_Funciton3:	  
 	  btfss     PT1,1
	  goto      Test_Funciton2
	  movlw     200
	  call      sub_delay_1ms 		;;;20MS
	  btfss     PT1,1
	  goto      Test_Funciton2
Test_Funciton4:	 
      goto    mp_weight_over        ;进入睡眠 
/*	  bcf		SYS_FLAG2,wt_cal
	  CALL		F_E2P_Start					;关显示	
  	  MOVLW		11100001b
	  CALL		F_E2P_Send			
	  CALL		F_E2P_Stop
		
	  bsf		P_LED,B_LED0				;关背光				
	  bcf     	ad_flag,weight0
	  call    	Sub_Dsp_Lcd_Null
	  bcf		Ad_Flag,lock_dsp			;解锁显示
	  bcf		Ad_Flag,lock_open		
	  
	  clrwdt
	  clrf      wdtcon
	  clrf      neta
	  clrf      netc	  
	  clrf      NETF				   
	  clrf      NETE  
	  clrf      pt1pu
	  movlw     ffh
	  movwf     pt1en
	  clrf      pt1
	  movlw     02h
	  movwf     pt2pu
	  movlw     0fdh
	  movwf     pt2en
	  clrf      pt2
	  clrf      intf	  
	  clrf      inte
	  bsf		P_LED,B_LED0	    ;关背光 
	  bcf       Unit_Flag,keyflag 

		     
      sleep
      nop
      nop*/
	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	   