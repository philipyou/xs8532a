
;;;********************************************************
;;;                     ����һ������
;;;-------------------------------------------------------
sub_scan_key:
;		bsf			PT2PU,6
;		bcf			PT2EN,6
		
		;btfsc		hard_key,NoKey
		;goto		sub_key_d				        
		;btfsc      	hard_key,lb
		;goto		sub_scan_up                    ;;;�޼�����
		;goto		sub_down_key				   ;;;�м�����
;;;---------------------------------------------------------
sub_key_d:
		btfsc      	hard_key,UINT
		goto		sub_scan_up                    ;;;�޼�����		
;;;---------------------------------------------------------
sub_down_key:		
		clrf		KeyUp	
		incf       	KeyDown,1                      ;;����һ��	
			
		movlw		02h
		subwf		KeyDown,0
		btfss		status,c
		retfie										;;;С��2���˳�
		
		btfsc		SYS_FLAG2,KeyCom				;;;û�мǴ���
		goto		sub_down_long
		incf		KeyTimes,1
		bsf			SYS_FLAG2,KeyCom
		retfie
;;;----------------------------------------------------------
sub_down_long:
		movlw		02h
		subwf		KeyDown,0
		btfss		status,c		
		retfie
		clrf        weight_0_times   	  ;���ùػ�ʱ��
		call        sub_initialize_time
		
		/*
		movlw       04h
		subwf       keyTimes,0
		btfss       status,c		
;		je_fd     	KeyTimes,04h
		goto        sub_key_long
		*/
		
		btfss		UserFlag,F_set_fast
		goto		sub_down_long_1
		
		incf		Usertime,f
		movlw		04h
		subwf		Usertime,W
		btfss		status,c
		goto		sub_down_long_1
		clrf		Usertime
		
		incf		UserHeight,f
		movlw		201
		subwf		UserHeight,w
		btfss		status,c
		goto		$+3	
		movlw		140
		movwf		UserHeight
		movlw		20
		movwf		UserSET
		
sub_down_long_1:			
		movlw		2ch
		subwf		KeyDown,0
		btfss		status,c		    ;;;С��60*33=2S�˳�
		goto        sub_key_long		
		
		
		btfsc		UserFlag,F_set_height
		bsf			UserFlag,F_set_fast
		bsf			UserFlag,F_set_height
		
		clrf		Usertime	
		movlw		20
		movwf		UserSET				
        ;bsf        	Sys_Flag2,bf_cal
            
		goto        sub_key_return
		
;;;===========================================================
sub_scan_up:
		call		sub_key_re
		incf       	KeyUp,1                      	;;����һ��
		movlw		02h
		subwf		KeyUp,0
		btfss		status,c
		retfie										;;;С��2���˳�
		clrf		KeyDown		
		bcf			SYS_FLAG2,KeyCom
				
		movlw		3ch
		subwf		KeyUp,0
		btfss		status,c						;;;2s����
		retfie
		bcf			UserFlag,F_set_fast
;		movlw		20
;		movwf		UserSET	
		goto        sub_key_return
;;		jne_fd     	KeyTimes,01h
;;		clrf		KeyTimes										
;;;-------------------------------------------------------
sub_key_return:
		clrf		KeyTimes
		clrf		KeyDown
		clrf		KeyUp
		bcf			SYS_FLAG2,KeyCom
;		
		retfie			
;;;**************************************************
sub_key_long:
sub_key_key:
		btfss	SYS_FLAG1,F_KeyDelay
		retfie
		
;		bcf			UserFlag,F_set_fast
		btfss		UserFlag,F_set_height
		goto		sub_key_key_0
				
		bcf			SYS_FLAG1,F_KeyDelay				
		bcf			Unit_Flag,unit_mode
		incf		UserHeight,f
		movlw		201
		subwf		UserHeight,w
		btfss		status,c
		goto		$+3	
		movlw		140
		movwf		UserHeight
			
		movlw		20
		movwf		UserSET
		bsf         UserFlag,shan
		clrf        disp_flash_cnt
		retfie
sub_key_key_0:		
		bcf		SYS_FLAG1,F_KeyDelay				
		bcf		Unit_Flag,unit_mode
		bsf		Unit_Flag,change_unit
		retfie		
;		goto	sub_key_return		
sub_key_re:
		bsf		SYS_FLAG1,F_KeyDelay
		retfie
;***********************************************************;
; ����: ������λ�л�
; ˵��: ѭ��˳�� KG - LB - ST - ���� - ��
; ����: �ڳ���ѭ�������     
;***********************************************************;
sub_change_keyunit:
		btfss		Unit_Flag,change_unit
		return
		bcf			Unit_Flag,change_unit
		btfss       unit_flag,unit_lb
		goto	    sub_lb
sub_kg:
        bcf         unit_flag,unit_lb        
        return      
sub_lb: 
        bsf         Unit_Flag,Unit_lb
unit_ck_over:
		return			
;;;----------------------------------------------
sub_weight_cal:
		btfsc	Unit_Flag,cal_weight
		return									;;;�ѱ궨��
sub_weight_cal1:
		bcf		SYS_FLAG2,wt_cal
		movfw	cal_weightL
		subwf	AdBuf0l,0
		movfw	cal_weightH
		subwfc	AdBuf0h,0
		btfsc	Status,c
		goto	sub_WeightEnter
		clrf	WeightEnter
		btfsc	SYS_FLAG1,F_WeightCAL
		bsf		SYS_FLAG2,wt_cal
		bcf		SYS_FLAG1,F_WeightCAL				
		return
;;;-----------------------------------------------
sub_WeightEnter:
		incf	WeightEnter,1
		movlw	07h
		subwf	WeightEnter,0
		btfsc	Status,c
		bsf		SYS_FLAG1,F_WeightCAL		
		return				
;-------------------------------------------------								
						