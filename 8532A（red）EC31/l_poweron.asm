;=========================================
;  上电初始化部分代码
;=========================================
;   第一次上电从P_POWER_ON_S开始跑
;   待机唤醒都从P_POWER_ON 开始跑
;   并且不跑3、4、5的内容
; 初始化内容：
;	0、清除RAM
;	1、外设寄存器初始化IO、AD等
;	2、读OTP初始化
;	3、全显示 
;	4、根据IO确定开机单位 
;   5、获取零点	 
;   6、计算开机重量
;
;=========================================
P_POWER_ON_S: 
	;---第一次上电开机才跑这里		
	call	mw_clrf_ram	
	movlw	140			;设置身高参数
    movwf	UserHeight			 	
	bsf		SYS_FLAG1,OpenTime		 ;首次开机时间长
	bcf		TEMP_FRESH,F_CD_TIME		
	
	MOVLW		 255				 ;;;上电增加250MS稳定时间
	call		 F_Delay_Ms
	
P_POWER_ON:	
	;1---5SP寄存器初始化----------------
		;---测温度	
	;---设置温度采集的冷却等待时间，待机状态计数用
	;---看门狗1S钟复位一次，708H=1800=30*60	相当于30分钟重新测试
	movlw	01h					
	movwf	TEMP_CDT_H	
	movlw	2ch
	movwf	TEMP_CDT_L
	
	btfsc	TEMP_FRESH,F_CD_TIME	;允许测量温度标志，0有效
	goto	PO_1_1
	
	call	Sub_temperature_SET
	call	Sub_Get_T_Adc			;第一次采集的4笔AD不要
	call	Sub_Get_T_Adc			;第二次的采用
	call	Sub_temperature_BACK
	call	sub_calu_temp
	
	;---置起已经采集温度的标志
	bsf		TEMP_FRESH,F_CD_TIME
		
PO_1_1:
		
PO_1:  
	call    sub_mp_option
					
	call	Sub_LED_init
	MOVLW   20
	call	F_Delay_Ms	
	
	clrf	Get_zero_count
	
	btfsc	Sys_Flag2,bf_AutoOpen
	goto    PO_1_2
	btfsc   pt1,1
	goto    PO_1_2
	btfsc   pt1,3
	goto    PO_1_2
	MOVLW   20
	call	F_Delay_Ms
	btfsc   pt1,1
	goto    PO_1_2
	btfsc   pt1,3
	goto    PO_1_2
	goto    Test_Mode
PO_1_2:
	/*
	;----test亮度均匀性
	bsf		LED1,0
	movlw	3
	call	sub_delay_s	
	bsf		LED2,1
	movlw	3
	call	sub_delay_s		
	bsf		LED1,6
	movlw	3
	call	sub_delay_s		
	bsf		LED2,2
	movlw	3
	call	sub_delay_s		
	bsf		LED4,6
	movlw	3
	call	sub_delay_s		
	bsf		LED2,3
	movlw	3
	call	sub_delay_s		
	bsf	    LED7,0
	movlw	3
	call	sub_delay_s		
	
	
	bsf		LED2,0
	movlw	3
	call	sub_delay_s	
	bsf		LED5,0
	movlw	3
	call	sub_delay_s		
	bsf		LED1,1
	movlw	3
	call	sub_delay_s		
	bsf		LED3,7
	movlw	3
	call	sub_delay_s		
	bsf		LED3,1
	movlw	3
	call	sub_delay_s		
	bsf		LED7,7
	movlw	3
	call	sub_delay_s		
	bsf	    LED7,1
	movlw	3
	call	sub_delay_s
	
	nop
	goto	$-1
	*/						
    ;2---读OTP--------------------------
	bsf		Unit_Flag,cal_weight        
	movlf   05h,MR_E2P
PO_2:
	bcf     Unit_Flag,FullDisp
	mc_read_otp_to_ram_scounter  20h,00h,c0h,7		
    call    sub_CaluOtp_XOR
    call	sub_compure_XOR
	btfss   Ad_Flag,AdC_Err
	goto	PO_3
	decfsz  MR_E2P,1
    goto    PO_2
    
	;--初始化失败用默认值
	bsf     Unit_Flag,FullDisp
	call    sub_pau_e2_data		
		
	;3---开机全显示----------------------	
PO_3:
	;---判断是不是自动开机，自动开机不全显，不切换单位
	btfsc	Sys_Flag2,bf_AutoOpen
	goto	PO_5		
	bcf		P_LED,B_LED0		;开背光
    
    btfss   Unit_Flag,FullDisp
    goto    PO_30
    call    Sub_Dsp_Lcd_All0
    goto    PO_4
PO_30:      						
	call	Sub_Dsp_Lcd_All		;全显
	
	;4---按键确定单位--------------------
PO_4:
;	call	sub_scan_unit		;拔动开关lb单位
		
	;5---获取零点------------------------
PO_5:   					
	movlf   09h,filter_xs
	;---自动开机不追零	   
	btfsc	Sys_Flag2,bf_AutoOpen
	goto	PO_6
	movlf   30h,sz_temp	
    mw_sz_loop:
	decfsz  sz_temp,1
	goto	mw_sz_loop1 
	goto    mw_sz_ok 
    mw_sz_loop1:	
	call    Sub_Get_Adc	   		
	call    Sub_Adc_Filter

	je_fd   Adf_Times,08H
	goto    mw_sz_loop   	
      
    mw_sz_ok:       	
	movff   AdBuf0h,Ad0_Zeroh
	movff   AdBuf0l,Ad0_Zerol
	   
	movff   AdBuf0h,cAd0_Zeroh
	movff   AdBuf0l,cAd0_Zerol
    
    ;---计算开机重量---------------------
PO_6:	    
    call    sub_calu_openweight
	call    Sub_Get_Adc 

	movlw   d1s						;指令延时一秒
	call    sub_delay_12m823
	
	call	sub_initialize_time	
	call	sub_weight_initialize	;称重前RAM初始化 
	;--开启LED功能
;	call	Sub_LED_init
	;---测量温度
P0_7:
	/*
	call	Sub_temperature_SET
	call	Sub_Get_T_Adc			;第一次采集的4笔AD不要
	call	Sub_Get_T_Adc			;第二次的采用
	call	Sub_temperature_BACK
	call	sub_calu_temp
	*/
	
	call	sub_show_temp
	
	;bsf		    Ad_Flag,cal_model		;;;标定完测试
	;bsf         Ad_Flag,biaoding_err
	
	
	goto	mw_start
;========================================
;P_POWER_ON   CODE SECTION END	
;========================================

/*测试排序函数用
	call	sub_clr_sort
	;1
	movlw	1
	movwf	Radcl
	movlw	0
	movwf	Radceh
	call	sub_sort_cal
	;2
	movlw	13h
	movwf	Radcl
	movlw	25h
	movwf	Radceh
	call	sub_sort_cal
	;3
	movlw	13h
	movwf	Radcl
	movlw	27h
	movwf	Radceh
	call	sub_sort_cal
	;4
	movlw	13h
	movwf	Radcl
	movlw	20h
	movwf	Radceh
	call	sub_sort_cal
	;5
	movlw	18h
	movwf	Radcl
	movlw	20h
	movwf	Radceh
	call	sub_sort_cal
	;6
	movlw	13h
	movwf	Radcl
	movlw	17h
	movwf	Radceh
	call	sub_sort_cal
	;7
	movlw	13h
	movwf	Radcl
	movlw	29h
	movwf	Radceh
	call	sub_sort_cal
	;8
	movlw	13h
	movwf	Radcl
	movlw	f0h
	movwf	Radceh
	call	sub_sort_cal
	;8
	movlw	13h
	movwf	Radcl
	movlw	f0h
	movwf	Radceh
	call	sub_sort_cal
	*/

	
	