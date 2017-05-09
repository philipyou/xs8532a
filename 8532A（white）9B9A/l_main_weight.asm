;=====================================================
;  				��ѭ�������
;=====================================================
;	�����ĳ�������£�
;   0��mw_go0			�ػ�ʱ�䴦������
;	1��mw_go1			����궨��������
;	2��mw_go2			���󿪻���������
;	3��mw_go3			�͵糬�ش�������
;	4��mw_go4			��λת������ʾ��������
;	5��mw_go5			���ȴ�������
;	6��mw_lc_over		�������������
;	7��mp_weight_over	�ػ������
;=====================================================
		
;go0-------------�ػ�ʱ�䴦������-------------------
;
;-----------------------------------------------------		
mw_go0_s:
		;---��ʾ0.0 kg�Ĺػ�ʱ��   20s
		movfw   weight_0_times
        addlw   0ffh-0a0h                 	
        jnc
		goto    mp_weight_over
		
		;---���ȶ��ػ�ʱ��   15s 
		movlw	01h
		subwf	weight_1_times,1			
		movlw	00h
		subwfc	weight_2_times,1
		jc
		goto	mp_weight_over
		goto	mw_go0_e
;-----------------------------------------------------


;go1-------------����궨��������-------------------
;
;-----------------------------------------------------
mw_go1_s:
;		call	sub_scan_cal				;PIN���궨���			
;		call	sub_change_keyunit			;������ѡ��λ
							
;		btfsc   SYS_FLAG2,bf_cal			;����궨
;		goto    Sub_Cali_adz_T
;;		btfsc   SYS_FLAG2,wt_cal			;;;����궨
;		goto    Sub_Cali_adz_T
		goto	mw_go1_e
;-----------------------------------------------------


;go2-------------���󿪻���������-------------------
;
;-----------------------------------------------------
mw_go2_s:
         btfss	Unit_Flag,keyflag
		goto    mw_go2_0
		bcf     Unit_Flag,keyflag
		goto    mw_go2_1
mw_go2_0:
		je_fd   weight_0_times,01h
		goto    mw_go2_1
		btfss   sys_flag2,bf_AutoOpen
		goto    mw_go2_1
		goto    main_kmg             		;���󿪻�    
		
mw_go2_1:
		bcf		P_LED,B_LED0				;������
				        
        bcf     sys_flag2,bf_AutoOpen
		goto	mw_go2_e
;-----------------------------------------------------


;go3-------------�͵糬�ش�������-------------------
;
;-----------------------------------------------------
mw_go3_s:
		call    Sub_Test_Battery
		btfsc   Ad_Flag,AdC_Err    			;�͵���
		goto    MR_BAT_ERR      	
		
				  	
		call    sub_kgerr_range
		BTFSS   Ad_Flag,AdC_Err
		goto    mw_go3_1
		incf    err_times,1
		movlw   02h                			;���γ�ERR����Ϊ��ERR
		subwf   err_times,0
		btfss   status,c
		goto    mw_go3_0				
		call    sub_over_err
		movlw   3ah
;		btfsc   err_times,7         		;�Ƿ���ʾERR�Ĵ�  2�룬���ǹػ�
        subwf   err_times,0
        btfsc   status,c
		goto    mp_weight_over	
		
	    btfsc   Cali_flag,1    ;�궨״̬�²���ⳬ��
		goto	mw_go4_e
 		goto    mw_start
mw_go3_0:
        btfsc   Cali_flag,1    ;�궨״̬�²���ⳬ��
		goto	mw_go3_e
        movff   DmaxL,F_bl
        movwf	r_wl
        movff   DmaxH,F_bh
        movwf	r_wh
        goto    mw_go3_e			
mw_go3_1:
        clrf    err_times
		goto    mw_go3_e
;-----------------------------------------------------


;go4-------------��λת������ʾ��������--------------
;
;------------------------------------------------------
mw_go4_s:
        btfss   disp_flash_flag,7
        goto    mw_go4_4
        btfsc   disp_flash_flag,0
        goto    mw_go4_0               ;��ʾ��ǰ����
        btfsc   disp_flash_flag,1
        goto    mw_go4_1
        btfsc   disp_flash_flag,2
        goto    mw_go4_2
mw_go4_1:                               ;��ֵ�Ա���ʾ
;        clrf	temp_h
;		clrf	temp_l
		clrf	R_LED_SIGN
		clrf	F_eah
		clrf	F_eal
		movfw   chazhi_data_h
		movwf   F_ah
		movfw	chazhi_data_l
		movwf   F_al            
		call    sub_Hex2BCD
		call	sub_adjust_wd
		bsf     R_LED_SIGN,0     ;;;kg
        bsf		R_LED_SIGN,1     ;С����
        
		call	sub_Dsp1
		
		btfsc   cmp_flag,up
        goto    mw_go4_10
        bsf     Led7,7          ;��
        goto    mw_go4_e
mw_go4_10:    
        bsf     Led2,3          ;��
		goto    mw_go4_e
mw_go4_2:                         ;BMIֵ��ʾ
;        clrf	temp_h
;		clrf	temp_l
		clrf	R_LED_SIGN
		clrf	F_eah
		clrf	F_eal	
		bsf     R_LED_SIGN,1    ;С����
        bsf     R_LED_SIGN,2    ;bmi
                
		movfw   UserBMIH
		movwf   F_bh
		movfw	UserBMIL
		movwf   F_bl 
		
		movlw   	085h              	   ; 18.5
		subwf   	F_bl,0
		movlw   	01h
		subwfc  	F_bh,0
		btfsc       status,c
		goto        mw_go4_20
		bsf     R_LED_SIGN,4    ;ƫ��
		goto	mw_go4_25	
mw_go4_20:	
	    movlw   	40h              	   ; 23.9
		subwf   	F_bl,0
		movlw   	02h
		subwfc  	F_bh,0
		btfsc       status,c
		goto        mw_go4_21
		bsf     R_LED_SIGN,5    ;����
		goto	mw_go4_25
mw_go4_21:
        movlw   	070h              	   ; 26.9
		subwf   	F_bl,0
		movlw   	02h
		subwfc  	F_bh,0
		btfsc       status,c
		goto        mw_go4_22
		bsf     R_LED_SIGN,6    ;ƫ��
		goto	mw_go4_25
mw_go4_22:
        bsf     R_LED_SIGN,7    ;����
mw_go4_25: 		        
;		call    sub_Hex2BCD        
		call	sub_adjust_wd10
		call	sub_Dsp1
		
		goto    mw_go4_e
;------------------------------
mw_go4_4:                          ;���������ʾ
		btfss	UserFlag,F_set_height
		goto	mw_go4_0
		
;		clrf	temp_h
;		clrf	temp_l
        btfsc   UserFlag,F_set_fast
        goto    mw_go4_41
        btfss   UserFlag,shan
        goto    mw_go4_40
mw_go4_41:
		clrf	R_LED_SIGN
		clrf	F_eah
		clrf	F_eal
		clrf	F_ah
		movfw	UserHeight
		movwf   F_al            
		call    sub_Hex2BCD
		call	sub_adjust_wd10
		call	sub_Dsp
		bsf		LED7,0          ;Cm�ַ�			
		goto    mw_go4_e	
mw_go4_40:	
        clrf	LCDG
        clrf	LCDS
        clrf	LCDB
        clrf	LCDQ
        clrf	R_LED_SIGN
        call	SUB_DSP_REAL
        bsf         led7,1 
		bcf		LED7,0          ;Cm�ַ�			
		goto    mw_go4_e	
;=============================================		
mw_go4_0:
	    btfsc   full_flag,0
	    bcf     full_flag,0
	    
		call    Sub_Real_Wlbkg    			  ;ת����ǰ��λ		
		clrf    F_eal
		clrf    F_eah		
		btfss   Unit_Flag,Unit_lb			  ;lb       
        bcf		F_bl,0			  			  ;lbֻ��ʾ2 4 6 8   
        call    sub_Hex2BCD
        
        btfss   weight_flag,0   
        goto    mw_go4_8
        clrf    F_bl                         ;��ֵ����ʾ
        clrf    F_bh
        clrf    F_ebl
mw_go4_8:                  				
		call	sub_adjust_wd
		call	sub_Dsp
		call    sub_ifdsp_dotu    			  ;display unit and dot
		btfss   disp_flash_flag,6
		goto    mw_go4_e
mw_go4_5: 
        bsf		LED6,6
        btfsc   cmp_flag,6
        goto    mw_go4_7
        bsf     cmp_flag,6                ;�����ַ�
             
        btfss    cmp_flag,0
        goto    mw_go4_6
        call    write_2kg_data1
        goto    mw_go4_7
mw_go4_6:
        call    com_write_eep
        goto    mw_go4_7
mw_go4_7:
        goto    mw_go4_e
;------------------------------------------------------


;go5-------------���ȴ�������------------------------
;
;------------------------------------------------------
mw_go5_s:
        
        movlw	0c8h
		subwf	r_wl,0
		movlw	00h
		subwfc	r_wh,0
		jc
		goto	mw_go5_s1
		
		btfss       UserFlag,F_set_height
        goto        mw_go5_s1
        bcf     	UserFlag,F_set_height
        bcf         UserFlag,shan
        clrf        disp_flash_cnt
        clrf        same_w_times
        goto        mw_go3_e
mw_go5_s1:        
		call    sub_if_locked_o				   ;�Ƿ��ȶ�
		movff   r_wh,lr_wh
		movff   r_wl,lr_wl
		btfsc	Ad_Flag,lock_dsp
		goto	mw_start   		
		
		
		movlw	f0h
		subwf	r_wl,0
		movlw	23h
		subwfc r_wh,0
		btfss	status,c
		goto	mw_go5_s1_1
		
		movlw   0ah
		subwf   same_w_times,0   
		btfsc   status,c
		goto	mw_lc_over
		goto	mw_go5_s1_2
		
mw_go5_s1_1:
	
		movlw   06h
		subwf   same_w_times,0   
		btfsc   status,c
		goto	mw_lc_over	
mw_go5_s1_2:
	
		movlw	08h				;0ah
		subwf	Get_zero_count,0
		btfss   status,c
		goto	mw_go5_s2
		
		clrf	Get_zero_count			;������λ�������
		
		movff   AdcBuf0l,Ad0_Zerol                        
		movff   AdcBuf0h,Ad0_Zeroh		
		
mw_go5_s2:
		goto	mw_go5_e
;------------------------------------------------------


;----------------�������������----------------------
;
;----------------------------------------------------
mw_lc_over:	
        
mw_lc_over0:
		btfsc		Ad_Flag,AdC_Err    
		goto		mp_wo_s_b0	
	
		call   		SUB_WC_MEM_APP          ;���� yes/no 0.3kg
			
		call		Sub_Real_Wlbkg    			  ;ת����ǰ��λ		
		clrf		F_eal
		clrf		F_eah		
		btfss		Unit_Flag,Unit_lb			  ;lb       
        bcf			F_bl,0			  			  ;lbֻ��ʾ2 4 6 8   
        call		sub_Hex2BCD                 				
		call		sub_adjust_wd
		call		sub_Dsp
		call		sub_ifdsp_dotu    			  ;display unit and dot	
	
		movff   	r_wh,w_memh
		movff   	r_wl,w_mem		
		
		MOVLW		 255						;;;���������ʱ��ǿ�û�����
		call		 F_Delay_Ms
		MOVLW		 255						;;;���������ʱ��ǿ�û�����
		call		 F_Delay_Ms	
		
mp_wo_s_b0:	
;        btfss       Unit_Flag,cal_weight
;        goto        mp_wo_s_2
; 		movlw       12
;		call        sub_delay_s						  ;���³������¸�0.0�����½����������
;		goto        mp_weight_over
        movlf		050h,weight_1_times       ;e2 20s
	    clrf		weight_2_times
        call        Sub_Cali_biaoding
        btfsc       zero_flag,c_flag
		goto        mp_scan_c               ;��ֵ��0.5����ֱ������
mp_wo_s_2:		
		movlf   	050h,Ad_Dsp_Delay     	  ;ע�������޸Ĺ��������в���һ��. ������8��ػ�  3cH
mp_wo_s:
		decfsz  	Ad_Dsp_Delay,1
		goto    	mp_wo_s_1
		goto    	mp_weight_over            ;û���³ƽ���ɨ��
mp_wo_s_1:		
		call		Sub_Check_Weight
		btfsc		SYS_FLAG1,F_returnLock
		goto		mp_wo_s
		
		
		
;		bcf         UserFlag,suo
        btfsc       UserFlag,pan
        goto        mp_scan_c
        btfss       UserFlag,7
        goto        mp_wo_s_exit
		clrf        disp_flash_flag
		clrf        disp_flash_cnt
		clrf        disp_flash_cnt1
		bsf         disp_flash_flag,7
		bsf         disp_flash_flag,0
		movfw       w_mem               
        movwf       F_bl
        movfw       w_memh               
        movwf       F_bh
		call        sub_Real_BMI
		movfw       w_mem               
        movwf       F_bl
        movfw       w_memh               
        movwf       F_bh
		call        compare
		btfss       Ad_Flag,biaoding_err
		goto        mp_wo_s_3
		bcf         Ad_Flag,biaoding_err
		bcf         disp_flash_flag,7
		goto        mp_wo_s_exit
mp_wo_s_3:
        bsf			Ad_Flag,lock_dsp
        goto        mp_wo_s_exit                
mp_wo_s_exit:
		bcf         Ad_Flag,biaoding_err	
;        btfss       Ad_Flag,cal_model	     					
;		bsf			Ad_Flag,lock_dsp			;������ʾ
		bsf			SYS_FLAG1,closeTime			;���ùػ�ʱ��		
	    movff		Ad_Dsp_Delay,weight_1_times
	    clrf		weight_2_times
	    call		sub_weight_initialize		;����ǰRAM��ʼ�� 						 							
		goto    	mw_start	
;-----------------------------------------------------
mp_scan_c:
		btfsc       Ad_Flag,biaoding_err
		bcf         Ad_Flag,biaoding_err
        call		sub_weight_initialize		;����ǰRAM��ʼ�� 	
        movlf   	08h,Ad_Dsp_Delay
        movff       F_bl,w_mem 
		movff       F_bh,w_memh 
        clrf        zero_flag
        clrf        Cali_cnt
        bcf         UserFlag,suo
;        call	    sub_c_weight  
;		btfss       zero_flag,c_flag
;		goto        mp_scan_c3
mp_scan_c0:   
            
        decfsz  	Ad_Dsp_Delay,1
        goto        mp_scan_c2
        goto        mp_scan_c4
mp_scan_c2: 
mp_scan_c1:        
;        call	    sub_change_keyunit
;        btfsc       SYS_FLAG2,bf_cal			;����궨
;		goto        Sub_Cali_adz_T
;		btfsc       SYS_FLAG2,wt_cal			;;;����궨
;		goto        Sub_Cali_adz_T

        call		zero_Check_Weight1
;        btfsc		SYS_FLAG1,F_returnLock  
        goto        mp_scan_c0
        movff       F_bl,w_mem 
		movff       F_bh,w_memh
		bsf			SYS_FLAG1,closeTime			;���ùػ�ʱ��		
	    movff		Ad_Dsp_Delay,weight_1_times
	    clrf		weight_2_times
	    call		sub_weight_initialize		;����ǰRAM��ʼ�� 						 							
		goto    	mw_start			  		;�����������������
       
mp_scan_c3: 
        btfss       zero_flag,1
        goto        mp_weight_over
mp_scan_c4:        
        movff   	AdcBuf0l,Ad0_Zerol                        
		movff   	AdcBuf0h,Ad0_Zeroh   	    
        clrf      	F_bl 
		clrf      	F_bh  
		;clrf        w_mem
		;clrf        w_memh
		clrf        zero_flag
		clrf        disp_flash_flag
		clrf        disp_flash_cnt
		clrf        disp_flash_cnt1
		bcf         weight_flag,0
        
        movlf		dsleep_l,weight_1_times
	    movlf		dsleep_h,weight_2_times
	    call		sub_weight_initialize		;����ǰRAM��ʼ�� 
        goto        mw_start   ;mp_weight_over

;---------------�ػ������-----------------------------	
;
;------------------------------------------------------					               			
mp_weight_over:
        movff       AdBuf0l,zero_AdBuf0l
		movff       AdBuf0h,zero_AdBuf0h
		clrf        disp_flash_flag
        bcf			SYS_FLAG2,wt_cal
		bsf			P_LED,B_LED0				;�ر���	
		clrf		mem_time
		clrf		mem_timeh
		
		movlw       00h
		movwf       inte
		bcf         intf,tm1if
		movlw	    00
		movwf	    TM1IN
		clrf        cnt2
;		movlw	    00000000b
;		movwf	    TM1CON		
		bcf     	ad_flag,weight0
		call    	Sub_Dsp_Lcd_Null
		bcf		    LED6,6
		bcf			Ad_Flag,lock_dsp			;������ʾ
		bcf			Ad_Flag,lock_open					
		goto    	main_kmg	
;-----------------------------------------------------









