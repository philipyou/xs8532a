;**********************************************************
; 				CSU8RP1186����ӳ���
;**********************************************************  
; history:
; 	v1.0	rich_liao 2012-03-14 14:05
;		basic version of body scale
; 	v2.0	wb_you	  2015-10-07 11:06	
;		modified the code layout	 		
; 	v2.1	wb_you	  2015-10-08 15:03
;		optimize the code of "zero process" and "weight lock"	
; 		 	
;********************************************************** 
include csu18mx86.inc
include	l_com.asm
include l_Def.asm
include l_macro.asm
;==========================================================
	    Org     0
MReset:
		Goto    Main_Start
		DW		FFFFH
		DW		FFFFH
		Goto    Main_Start
		Org     4
		Goto    Int_All
;==========================================================
Main_Start:
    	movlf   01000100b,mck       	;4 MHZ   ָ�����ڣ�1000K		               
        nop     
		nop		
        btfsc	status,4     
        goto    main_kmg 				;���Ź���λ                                 
        goto    P_POWER_ON_S			;�ϵ縴λ  
   	
;========================��ѭ��============================
mw_start:		
				
/*				call	compare_clr_eep
        movlw   14h
        movwf   f_bh
        movlw   efh
        movwf   f_bl
		call    compare	*/
							
		goto	mw_go0_s				;�ػ�ʱ�䴦��
mw_go0_e:
		goto	mw_go1_s				;����궨�жϴ���		
mw_go1_e:
;		call	sub_scan_unit			;��ⰴ��ѡ��PIN��
		call	sub_height_set			;������ߴ���						 			
		call    Sub_Get_Adc				;��ȡADֵ
		call    Sub_Get_Pure_WC			;������Ա仯��	
		call    Sub_Adc_Filter    		;�˲� I:AdBuf0l   O: AdBuf0l
		call	sub_weight_cal			;;;����궨					
		call    sub_calu_wkg   			;�������� I:AdBuf0l O:bl,bh,ebl as kg.
		call	sub_samll_weight        ;С������׷�㴦��-
        btfsc   zero_flag,no_disp_c
		goto    mp_scan_c               ;��ֵ��0.5����ֱ������
		call	sub_dsp_lock			;��������
		call	sub_if_weight_o         ;yes/no dsp 0.0kg				
		goto	mw_go2_s				;���󿪻�����
mw_go2_e:
		call	sub_renew_weight
		goto	mw_go3_s				;�͵糬�ش���
mw_go3_e:		
		goto 	mw_go4_s				;��λ�л�����ʾ����	
mw_go4_e:
		goto	mw_go5_s				;���ȴ���	
mw_go5_e:	
		goto    mw_start

;********************************************************** 
include l_interrupt.asm
include l_standby.asm
include l_poweron.asm
include l_main_weight.asm
include l_ad.asm
include l_lcd.asm
include	l_led.asm
include l_setup.asm
include l_glue.asm
include l_calu.asm
include	scan_key.asm
include	l_adcfilter.asm
include otp_program.asm
include eep.asm
include compare.asm
include	l_bmi_set.asm
include	l_temperature.asm
include testmode.asm
END
;********************************************************** 
