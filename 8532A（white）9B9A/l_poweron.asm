;=========================================
;  �ϵ��ʼ�����ִ���
;=========================================
;   ��һ���ϵ��P_POWER_ON_S��ʼ��
;   �������Ѷ���P_POWER_ON ��ʼ��
;   ���Ҳ���3��4��5������
; ��ʼ�����ݣ�
;	0�����RAM
;	1������Ĵ�����ʼ��IO��AD��
;	2����OTP��ʼ��
;	3��ȫ��ʾ 
;	4������IOȷ��������λ 
;   5����ȡ���	 
;   6�����㿪������
;
;=========================================
P_POWER_ON_S: 
	;---��һ���ϵ翪����������		
	call	mw_clrf_ram	
	movlw	140			;������߲���
    movwf	UserHeight			 	
	bsf		SYS_FLAG1,OpenTime		 ;�״ο���ʱ�䳤
	bcf		TEMP_FRESH,F_CD_TIME		
	
	MOVLW		 255				 ;;;�ϵ�����250MS�ȶ�ʱ��
	call		 F_Delay_Ms
	
P_POWER_ON:	
	;1---5SP�Ĵ�����ʼ��----------------
		;---���¶�	
	;---�����¶Ȳɼ�����ȴ�ȴ�ʱ�䣬����״̬������
	;---���Ź�1S�Ӹ�λһ�Σ�708H=1800=30*60	�൱��30�������²���
	movlw	01h					
	movwf	TEMP_CDT_H	
	movlw	2ch
	movwf	TEMP_CDT_L
	
	btfsc	TEMP_FRESH,F_CD_TIME	;��������¶ȱ�־��0��Ч
	goto	PO_1_1
	
	call	Sub_temperature_SET
	call	Sub_Get_T_Adc			;��һ�βɼ���4��AD��Ҫ
	call	Sub_Get_T_Adc			;�ڶ��εĲ���
	call	Sub_temperature_BACK
	call	sub_calu_temp
	
	;---�����Ѿ��ɼ��¶ȵı�־
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
	;----test���Ⱦ�����
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
    ;2---��OTP--------------------------
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
    
	;--��ʼ��ʧ����Ĭ��ֵ
	bsf     Unit_Flag,FullDisp
	call    sub_pau_e2_data		
		
	;3---����ȫ��ʾ----------------------	
PO_3:
	;---�ж��ǲ����Զ��������Զ�������ȫ�ԣ����л���λ
	btfsc	Sys_Flag2,bf_AutoOpen
	goto	PO_5		
	bcf		P_LED,B_LED0		;������
    
    btfss   Unit_Flag,FullDisp
    goto    PO_30
    call    Sub_Dsp_Lcd_All0
    goto    PO_4
PO_30:      						
	call	Sub_Dsp_Lcd_All		;ȫ��
	
	;4---����ȷ����λ--------------------
PO_4:
;	call	sub_scan_unit		;�ζ�����lb��λ
		
	;5---��ȡ���------------------------
PO_5:   					
	movlf   09h,filter_xs
	;---�Զ�������׷��	   
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
    
    ;---���㿪������---------------------
PO_6:	    
    call    sub_calu_openweight
	call    Sub_Get_Adc 

	movlw   d1s						;ָ����ʱһ��
	call    sub_delay_12m823
	
	call	sub_initialize_time	
	call	sub_weight_initialize	;����ǰRAM��ʼ�� 
	;--����LED����
;	call	Sub_LED_init
	;---�����¶�
P0_7:
	/*
	call	Sub_temperature_SET
	call	Sub_Get_T_Adc			;��һ�βɼ���4��AD��Ҫ
	call	Sub_Get_T_Adc			;�ڶ��εĲ���
	call	Sub_temperature_BACK
	call	sub_calu_temp
	*/
	
	call	sub_show_temp
	
	;bsf		    Ad_Flag,cal_model		;;;�궨�����
	;bsf         Ad_Flag,biaoding_err
	
	
	goto	mw_start
;========================================
;P_POWER_ON   CODE SECTION END	
;========================================

/*������������
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

	
	