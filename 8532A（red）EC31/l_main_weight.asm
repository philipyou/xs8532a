;=====================================================
;  				主循环程序段
;=====================================================
;	包括的程序段如下：
;   0、mw_go0			关机时间处理程序段
;	1、mw_go1			进入标定处理程序段
;	2、mw_go2			防误开机处理程序段
;	3、mw_go3			低电超重处理程序段
;	4、mw_go4			单位转换和显示处理程序段
;	5、mw_go5			判稳处理程序段
;	6、mw_lc_over		重量锁定程序段
;	7、mp_weight_over	关机程序段
;=====================================================
		
;go0-------------关机时间处理程序段-------------------
;
;-----------------------------------------------------		
mw_go0_s:
		;---显示0.0 kg的关机时间   20s
		movfw   weight_0_times
        addlw   0ffh-0a0h                 	
        jnc
		goto    mp_weight_over
		
		;---不稳定关机时间   15s 
		movlw	01h
		subwf	weight_1_times,1			
		movlw	00h
		subwfc	weight_2_times,1
		jc
		goto	mp_weight_over
		goto	mw_go0_e
;-----------------------------------------------------


;go1-------------进入标定处理程序段-------------------
;
;-----------------------------------------------------
mw_go1_s:
;		call	sub_scan_cal				;PIN进标定检查			
;		call	sub_change_keyunit			;处理按键选单位
							
;		btfsc   SYS_FLAG2,bf_cal			;进入标定
;		goto    Sub_Cali_adz_T
;;		btfsc   SYS_FLAG2,wt_cal			;;;进入标定
;		goto    Sub_Cali_adz_T
		goto	mw_go1_e
;-----------------------------------------------------


;go2-------------防误开机处理程序段-------------------
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
		goto    main_kmg             		;防误开机    
		
mw_go2_1:
		bcf		P_LED,B_LED0				;开背光
				        
        bcf     sys_flag2,bf_AutoOpen
		goto	mw_go2_e
;-----------------------------------------------------


;go3-------------低电超重处理程序段-------------------
;
;-----------------------------------------------------
mw_go3_s:
		call    Sub_Test_Battery
		btfsc   Ad_Flag,AdC_Err    			;低电检测
		goto    MR_BAT_ERR      	
		
				  	
		call    sub_kgerr_range
		BTFSS   Ad_Flag,AdC_Err
		goto    mw_go3_1
		incf    err_times,1
		movlw   02h                			;两次出ERR才认为是ERR
		subwf   err_times,0
		btfss   status,c
		goto    mw_go3_0				
		call    sub_over_err
		movlw   3ah
;		btfsc   err_times,7         		;是否显示ERR四次  2秒，若是关机
        subwf   err_times,0
        btfsc   status,c
		goto    mp_weight_over	
		
	    btfsc   Cali_flag,1    ;标定状态下不检测超重
		goto	mw_go4_e
 		goto    mw_start
mw_go3_0:
        btfsc   Cali_flag,1    ;标定状态下不检测超重
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


;go4-------------单位转换和显示处理程序段--------------
;
;------------------------------------------------------
mw_go4_s:
        btfss   disp_flash_flag,7
        goto    mw_go4_4
        btfsc   disp_flash_flag,0
        goto    mw_go4_0               ;显示当前重量
        btfsc   disp_flash_flag,1
        goto    mw_go4_1
        btfsc   disp_flash_flag,2
        goto    mw_go4_2
mw_go4_1:                               ;差值对比显示
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
        bsf		R_LED_SIGN,1     ;小数点
        
		call	sub_Dsp1
		
		btfsc   cmp_flag,up
        goto    mw_go4_10
        bsf     Led7,7          ;下
        goto    mw_go4_e
mw_go4_10:    
        bsf     Led2,3          ;上
		goto    mw_go4_e
mw_go4_2:                         ;BMI值显示
;        clrf	temp_h
;		clrf	temp_l
		clrf	R_LED_SIGN
		clrf	F_eah
		clrf	F_eal	
		bsf     R_LED_SIGN,1    ;小数点
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
		bsf     R_LED_SIGN,4    ;偏瘦
		goto	mw_go4_25	
mw_go4_20:	
	    movlw   	40h              	   ; 23.9
		subwf   	F_bl,0
		movlw   	02h
		subwfc  	F_bh,0
		btfsc       status,c
		goto        mw_go4_21
		bsf     R_LED_SIGN,5    ;正常
		goto	mw_go4_25
mw_go4_21:
        movlw   	070h              	   ; 26.9
		subwf   	F_bl,0
		movlw   	02h
		subwfc  	F_bh,0
		btfsc       status,c
		goto        mw_go4_22
		bsf     R_LED_SIGN,6    ;偏胖
		goto	mw_go4_25
mw_go4_22:
        bsf     R_LED_SIGN,7    ;肥胖
mw_go4_25: 		        
;		call    sub_Hex2BCD        
		call	sub_adjust_wd10
		call	sub_Dsp1
		
		goto    mw_go4_e
;------------------------------
mw_go4_4:                          ;身高设置显示
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
		bsf		LED7,0          ;Cm字符			
		goto    mw_go4_e	
mw_go4_40:	
        clrf	LCDG
        clrf	LCDS
        clrf	LCDB
        clrf	LCDQ
        clrf	R_LED_SIGN
        call	SUB_DSP_REAL
        bsf         led7,1 
		bcf		LED7,0          ;Cm字符			
		goto    mw_go4_e	
;=============================================		
mw_go4_0:
	    btfsc   full_flag,0
	    bcf     full_flag,0
	    
		call    Sub_Real_Wlbkg    			  ;转换当前单位		
		clrf    F_eal
		clrf    F_eah		
		btfss   Unit_Flag,Unit_lb			  ;lb       
        bcf		F_bl,0			  			  ;lb只显示2 4 6 8   
        call    sub_Hex2BCD
        
        btfss   weight_flag,0   
        goto    mw_go4_8
        clrf    F_bl                         ;负值不显示
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
        bsf     cmp_flag,6                ;记忆字符
             
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


;go5-------------判稳处理程序段------------------------
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
		call    sub_if_locked_o				   ;是否稳定
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
		
		clrf	Get_zero_count			;处于零位更新零点
		
		movff   AdcBuf0l,Ad0_Zerol                        
		movff   AdcBuf0h,Ad0_Zeroh		
		
mw_go5_s2:
		goto	mw_go5_e
;------------------------------------------------------


;----------------重量锁定程序段----------------------
;
;----------------------------------------------------
mw_lc_over:	
        
mw_lc_over0:
		btfsc		Ad_Flag,AdC_Err    
		goto		mp_wo_s_b0	
	
		call   		SUB_WC_MEM_APP          ;记忆 yes/no 0.3kg
			
		call		Sub_Real_Wlbkg    			  ;转换当前单位		
		clrf		F_eal
		clrf		F_eah		
		btfss		Unit_Flag,Unit_lb			  ;lb       
        bcf			F_bl,0			  			  ;lb只显示2 4 6 8   
        call		sub_Hex2BCD                 				
		call		sub_adjust_wd
		call		sub_Dsp
		call		sub_ifdsp_dotu    			  ;display unit and dot	
	
		movff   	r_wh,w_memh
		movff   	r_wl,w_mem		
		
		MOVLW		 255						;;;锁定后的延时增强用户体验
		call		 F_Delay_Ms
		MOVLW		 255						;;;锁定后的延时增强用户体验
		call		 F_Delay_Ms	
		
mp_wo_s_b0:	
;        btfss       Unit_Flag,cal_weight
;        goto        mp_wo_s_2
; 		movlw       12
;		call        sub_delay_s						  ;若下称则重新复0.0并重新进入测试重量
;		goto        mp_weight_over
        movlf		050h,weight_1_times       ;e2 20s
	    clrf		weight_2_times
        call        Sub_Cali_biaoding
        btfsc       zero_flag,c_flag
		goto        mp_scan_c               ;负值在0.5以下直接清零
mp_wo_s_2:		
		movlf   	050h,Ad_Dsp_Delay     	  ;注：我已修改过，试运行测试一下. 锁定后8秒关机  3cH
mp_wo_s:
		decfsz  	Ad_Dsp_Delay,1
		goto    	mp_wo_s_1
		goto    	mp_weight_over            ;没有下称进入扫描
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
;		bsf			Ad_Flag,lock_dsp			;锁定显示
		bsf			SYS_FLAG1,closeTime			;重置关机时间		
	    movff		Ad_Dsp_Delay,weight_1_times
	    clrf		weight_2_times
	    call		sub_weight_initialize		;称重前RAM初始化 						 							
		goto    	mw_start	
;-----------------------------------------------------
mp_scan_c:
		btfsc       Ad_Flag,biaoding_err
		bcf         Ad_Flag,biaoding_err
        call		sub_weight_initialize		;称重前RAM初始化 	
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
;        btfsc       SYS_FLAG2,bf_cal			;进入标定
;		goto        Sub_Cali_adz_T
;		btfsc       SYS_FLAG2,wt_cal			;;;进入标定
;		goto        Sub_Cali_adz_T

        call		zero_Check_Weight1
;        btfsc		SYS_FLAG1,F_returnLock  
        goto        mp_scan_c0
        movff       F_bl,w_mem 
		movff       F_bh,w_memh
		bsf			SYS_FLAG1,closeTime			;重置关机时间		
	    movff		Ad_Dsp_Delay,weight_1_times
	    clrf		weight_2_times
	    call		sub_weight_initialize		;称重前RAM初始化 						 							
		goto    	mw_start			  		;大于重量，进入称重
       
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
	    call		sub_weight_initialize		;称重前RAM初始化 
        goto        mw_start   ;mp_weight_over

;---------------关机程序段-----------------------------	
;
;------------------------------------------------------					               			
mp_weight_over:
        movff       AdBuf0l,zero_AdBuf0l
		movff       AdBuf0h,zero_AdBuf0h
		clrf        disp_flash_flag
        bcf			SYS_FLAG2,wt_cal
		bsf			P_LED,B_LED0				;关背光	
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
		bcf			Ad_Flag,lock_dsp			;解锁显示
		bcf			Ad_Flag,lock_open					
		goto    	main_kmg	
;-----------------------------------------------------









