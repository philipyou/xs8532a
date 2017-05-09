Test_Mode:
      call    sub_pau_e2_data
      
      MOVLW		 255						;;;���������ʱ��ǿ�û�����
	  call		 F_Delay_Ms
	  MOVLW		 255						;;;���������ʱ��ǿ�û�����
	  call		 F_Delay_Ms
      
sub_dsp_Test:
      call    Sub_Dsp_Lcd_Null   ;��ʾ----
      call  	sub_show_temp
;      movlf   Lcdch1,LCDQ 
       bsf     lcdq,0
       bsf     lcdq,1
      movlf   Lcdch2,LCDB
      Movlf   Lcdch3,LCDS
      Movlf   Lcdch4,LCDG        
      call    SUB_DSP_REAL
	  movlw   d3s						;ָ����ʱһ��
	  call    sub_delay_12m823  
	  movlw   d3s						;ָ����ʱһ��
	  call    sub_delay_12m823 
;---------------------------------------
;      movlw   10110111B	        	
;	  movwf   LCDENR		        						
	  call	  Sub_Dsp_Lcd_All0		;ȫ��
	  
	  movlf   09h,filter_xs	   
	  movlf   10h,sz_temp	      ;׷��
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
      
    ;---���㿪������---------------------
T_PO_6:	    
      call    sub_calu_openweight
      
       movlw   d3s						;ָ����ʱһ��
	  call    sub_delay_12m823 
      goto    mp_weight_over       ;����˯��
      	
	  call    Sub_Get_Adc 

	  movlw   d1s						;ָ����ʱһ��
	  call    sub_delay_12m823
	
	  call	  sub_initialize_time	
	  call	  sub_weight_initialize	;����ǰRAM��ʼ�� 	
	  
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
	  goto    mp_weight_over        ;����˯��
Test_Funciton_lp1:
      movfw   weight_0_times
      addlw   0ffh-04eh                 	
      jnc
      goto    mp_weight_over       ;����˯��
		
		;---���ȶ��ػ�ʱ��   15s 
	  movlw	  01h
	  subwf	  weight_1_times,1			
	  movlw	  00h
	  subwfc  weight_2_times,1
	  jc
	  goto    mp_weight_over        ;����˯��
;	  goto	mw_go0_e
      
      
	  call    Sub_Get_Adc				;��ȡADֵ
      call    Sub_Get_Pure_WC			;������Ա仯��	
	  call    Sub_Adc_Filter    		;�˲� I:AdBuf0l   O: AdBuf0l	
	  call	  sub_weight_cal				;;;����궨			
	  call    sub_calu_wkg   			;�������� I:AdBuf0l O:bl,bh,ebl as kg.
	  call	  sub_samll_weight        ;С������׷�㴦��
	  call	  sub_dsp_lock			;��������
	  call	  sub_if_weight_o         ;yes/no dsp 0.0kg
	  call    SUB_WC_MEM_APP          ;���� yes/no 0.3kg
	  call    Sub_Test_Battery
	  btfsc   Ad_Flag,AdC_Err    			;�͵���
	  goto    MR_BAT_ERR
	  
	  call    Sub_Real_Wlbkg    			  ;ת����ǰ��λ		
  	  clrf    F_eal
	  clrf    F_eah		
	  btfss   Unit_Flag,Unit_lb			  ;lb       
      bcf	  F_bl,0			  			  ;lbֻ��ʾ2 4 6 8   
      call    sub_Hex2BCD        
      btfss   weight_flag,0   
        goto    mw_go4_30
        clrf    F_bl                         ;��ֵ����ʾ
        clrf    F_bh
mw_go4_30:                  				
		call	sub_adjust_wd
		call	sub_Dsp
		call    sub_ifdsp_dotu   	
;	    goto    Test_Funciton_lp
		
		
	  call    sub_if_locked_o				   ;�Ƿ��ȶ�
	  movff   r_wh,lr_wh
	  movff   r_wl,lr_wl
	  btfsc	  Ad_Flag,lock_dsp
	  goto	  Test_Funciton_lp    
	  jne_fd  same_w_times,07h			    ;�ȶ������ﵽ����������
	  goto    Test_Funciton1
	  goto	  Test_Funciton_lp
Test_Funciton1:	
	  movff   	r_wh,w_memh
	  movff   	r_wl,w_mem		
	  call    	sub_nflash_ntk		      ;�����������������ж��Ƿ��ڹ涨�������³ƣ�
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
      goto    mp_weight_over        ;����˯�� 
/*	  bcf		SYS_FLAG2,wt_cal
	  CALL		F_E2P_Start					;����ʾ	
  	  MOVLW		11100001b
	  CALL		F_E2P_Send			
	  CALL		F_E2P_Stop
		
	  bsf		P_LED,B_LED0				;�ر���				
	  bcf     	ad_flag,weight0
	  call    	Sub_Dsp_Lcd_Null
	  bcf		Ad_Flag,lock_dsp			;������ʾ
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
	  bsf		P_LED,B_LED0	    ;�ر��� 
	  bcf       Unit_Flag,keyflag 

		     
      sleep
      nop
      nop*/
	
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	   