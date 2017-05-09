Int_All:
		movwf	R_BAK_W
		movfw	STATUS
		movwf	R_BAK_S
		;push
		btfsc	intf,tm1if
		goto	inter_timer1		
Inter_ADC:
        btfss   intf,adif
        goto    inter_ex
        
	    bcf     intf,adif		
        movff   adoh,Radceh
        movff   adol,Radcl
        movff   adoll,Radcel
        
        btfsc	UserFlag,F_TEMP
        goto	Int_ok
            
	    movlw   00h    		        
	    addwf   RAdcel,1 
	    movlw   00h
	    addwfc  RAdcl,1
	    movlw   10h
	    addwfc  RAdceh,1
	    	            
	    movlf	02h,COUNTER0
Int_rradc:
	    bcf		STATUS,C						;取17位AD
	    rlf		Radcel,1
	    rlf		Radcl,1	    	    
	    rlf		Radceh,1
	    decfsz	COUNTER0,1
	    goto	Int_rradc
Int_ok:		    	
		incf    adc_int_times,1
		bsf		Calu_Flag,ad_cal
int_height:
        btfss	UserFlag,F_set_height
        goto     int_flash
        incf    disp_flash_cnt,1
		movfw   disp_flash_cnt
		sublw   15                   ;150*33=5000MS
		btfsc   status,c
		goto    int_flash
		clrf    disp_flash_cnt
		btfsc   UserFlag,shan
		goto    int_height1
		bsf     UserFlag,shan
		goto    int_height2
int_height1:
        bcf     UserFlag,shan
int_height2:    
        decfsz	UserSET,f
        goto    int_flash
        bcf		UserFlag,F_set_height
        bcf     UserFlag,shan
int_flash:		
		btfss   disp_flash_flag,7
		goto    int_next
		incf    disp_flash_cnt,1
		movfw   disp_flash_cnt
		sublw   100                   ;150*33=5000MS
		btfsc   status,c
		goto    int_next
		
		btfsc   cmp_flag,2
		goto    int_flash3          ;差值大于5KG，不显示
		
		btfss   disp_flash_flag,0
		goto    int_flash1
		bcf     disp_flash_flag,0
		bsf     disp_flash_flag,1
		bcf     disp_flash_flag,2
		clrf    disp_flash_cnt
		movlf	dsleep_l,weight_1_times
	    movlf	dsleep_h,weight_2_times
		goto    int_next
int_flash1:
        btfss   disp_flash_flag,1
        goto    int_flash2
        bcf     disp_flash_flag,0
		bcf     disp_flash_flag,1
		bsf     disp_flash_flag,2
		clrf    disp_flash_cnt
		movlf	dsleep_l,weight_1_times
	    movlf	dsleep_h,weight_2_times
		goto    int_next
int_flash2:
        btfss   disp_flash_flag,2
        goto    int_next
        bcf     disp_flash_flag,2
		bcf     disp_flash_flag,1
		bsf     disp_flash_flag,0
		clrf    disp_flash_cnt
		movlf	dsleep_l,weight_1_times
	    movlf	dsleep_h,weight_2_times
		incf    disp_flash_cnt1,1
		movlw   3
		subwf   disp_flash_cnt1,0
		btfss   status,c
		goto    int_next
		clrf    disp_flash_flag
		clrf    disp_flash_cnt
		clrf    disp_flash_cnt1
		bsf     disp_flash_flag,6
		movlf	1ch,weight_1_times
	    clrf	weight_2_times
		goto    int_next
int_flash3:                    ;差值大于5KG，不显示
        btfss   disp_flash_flag,0
		goto    int_flash4
		bcf     disp_flash_flag,0
		bcf     disp_flash_flag,1
		bsf     disp_flash_flag,2
		clrf    disp_flash_cnt
		movlf	dsleep_l,weight_1_times
	    movlf	dsleep_h,weight_2_times
		goto    int_next
int_flash4:
        btfss   disp_flash_flag,2
        goto    int_next
        bcf     disp_flash_flag,2
		bcf     disp_flash_flag,1
		bsf     disp_flash_flag,0
		clrf    disp_flash_cnt
		movlf	dsleep_l,weight_1_times
	    movlf	dsleep_h,weight_2_times
		incf    disp_flash_cnt1,1
		movlw   3
		subwf   disp_flash_cnt1,0
		btfss   status,c
		goto    int_next
		clrf    disp_flash_flag
		clrf    disp_flash_cnt
		clrf    disp_flash_cnt1
		bsf     disp_flash_flag,6
		movlf	1ch,weight_1_times
	    clrf	weight_2_times
		goto    int_next
;-----------------------------
int_next:
		btfss	SYS_FLAG1,F_SADC
		goto	sub_scan_key
		goto	interrupt_end     	
;;;------------------------------     
inter_ex:
         btfss   intf,e0if
         goto    inter_timer
         bcf     intf,e0if
         bcf     inte,e0ie
       	 goto	interrupt_end
inter_timer:
		 btfss		intf,tm0if
		 goto		inter_other		 
		 movlf		11101111b,intf
		 goto	interrupt_end

		 
inter_other:
       	 bcf      intf,e0if
       	 bcf      intf,e1if
       	 goto	interrupt_end


inter_timer1:
		bcf		intf,tm1if
		
		incf	R_LED_COUNT,f		;计数器计数
		movlw	8
		subwf	R_LED_COUNT,w
		btfsc	status,c
		clrf	R_LED_COUNT
		

		movlw	ffh
		movwf	pt2
		movwf	PT2CON
		movwf	7FH
		movwf	R_LED_LIGHT
		
		clrf	R_LED_DUTY
		
		movfw	R_LED_COUNT
		addpcw	
		goto	INTERRUPT_LED_P20
		goto	INTERRUPT_LED_P21
		goto	INTERRUPT_LED_P22
		goto	INTERRUPT_LED_P23
		goto	INTERRUPT_LED_P24
		goto	INTERRUPT_LED_P25
		goto	INTERRUPT_LED_P26
		goto	INTERRUPT_LED_P27
		
INTERRUPT_LED_P20:		
		;PT2.0
		btfsc	LED1,0
		incf	R_LED_DUTY,f
		btfsc	LED2,1
		incf	R_LED_DUTY,f
		btfsc	LED1,6
		incf	R_LED_DUTY,f
		btfsc	LED2,2
		incf	R_LED_DUTY,f
		btfsc	LED4,6
		incf	R_LED_DUTY,f
		btfsc	LED2,3
		incf	R_LED_DUTY,f
		btfsc   LED7,0
		incf    R_LED_DUTY,F
		
		btfsc	LED1,0
		bcf		R_LED_LIGHT,1
		btfsc	LED2,1
		bcf		R_LED_LIGHT,2
		btfsc	LED1,6
		bcf		R_LED_LIGHT,3
		btfsc	LED2,2
		bcf		R_LED_LIGHT,4
		btfsc	LED4,6
		bcf		R_LED_LIGHT,5
		btfsc	LED2,3
		bcf		R_LED_LIGHT,6
		btfsc   LED7,0
		bcf		R_LED_LIGHT,7
				
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,0
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH				
		
		movlw	11111110b
		movwf	PT2
		
		goto	INTERRUPT_LED_END
		
INTERRUPT_LED_P21:		
		;PT2.1
		btfsc	LED2,0
		incf	R_LED_DUTY,f
		btfsc	LED5,0
		incf	R_LED_DUTY,f
		btfsc	LED1,1
		incf	R_LED_DUTY,f
		btfsc	LED3,7
		incf	R_LED_DUTY,f
		btfsc	LED3,1
		incf	R_LED_DUTY,f
		btfsc	LED7,7
		incf	R_LED_DUTY,f
		btfsc	LED7,1
		incf	R_LED_DUTY,f
		
		btfsc	LED2,0
		bcf		R_LED_LIGHT,0
		btfsc	LED5,0
		bcf		R_LED_LIGHT,2
		btfsc	LED1,1
		bcf		R_LED_LIGHT,3
		btfsc	LED3,7
		bcf		R_LED_LIGHT,4
		btfsc	LED3,1
		bcf		R_LED_LIGHT,5
		btfsc	LED7,7
		bcf		R_LED_LIGHT,6
		btfsc	LED7,1
		bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,1
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH		
				
		movlw	11111101b
		movwf	PT2
		
		goto	INTERRUPT_LED_END

INTERRUPT_LED_P22:		
		;PT2.2
		btfsc	LED2,5
		incf	R_LED_DUTY,f
		btfsc	LED2,7
		incf	R_LED_DUTY,f
		btfsc	LED5,5
		incf	R_LED_DUTY,f
		btfsc	LED5,7
		incf	R_LED_DUTY,f
		btfsc	LED4,1
		incf	R_LED_DUTY,f
		btfsc	LED4,0
		incf	R_LED_DUTY,f
		btfsc	LED7,2
		incf	R_LED_DUTY,f
				
		btfsc	LED2,5
		bcf		R_LED_LIGHT,0
		btfsc	LED2,7
		bcf		R_LED_LIGHT,1
		btfsc	LED5,5
		bcf		R_LED_LIGHT,3
		btfsc	LED5,7
		bcf		R_LED_LIGHT,4
		btfsc	LED4,1
		bcf		R_LED_LIGHT,5
		btfsc	LED4,0
		bcf		R_LED_LIGHT,6
		btfsc	LED7,2
		bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,2
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH			
		
		movlw	11111011b
		movwf	PT2
		
		goto	INTERRUPT_LED_END


INTERRUPT_LED_P23:		
		;PT2.3
		btfsc	LED2,6
		incf	R_LED_DUTY,f
		btfsc	LED1,5
		incf	R_LED_DUTY,f
		btfsc	LED5,1
		incf	R_LED_DUTY,f
		btfsc	LED5,4
		incf	R_LED_DUTY,f
		btfsc	LED5,3
		incf	R_LED_DUTY,f
		btfsc	LED1,2
		incf	R_LED_DUTY,f		
		btfsc	LED7,3
		incf	R_LED_DUTY,f
		
		
		btfsc	LED2,6
		bcf		R_LED_LIGHT,0
		btfsc	LED1,5
		bcf		R_LED_LIGHT,1
		btfsc	LED5,1
		bcf		R_LED_LIGHT,2
		btfsc	LED5,4
		bcf		R_LED_LIGHT,4
		btfsc	LED5,3
		bcf		R_LED_LIGHT,5
		btfsc	LED1,2
		bcf		R_LED_LIGHT,6
        btfsc	LED7,3
        bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,3
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH		
		
		movlw	11110111b
		movwf	PT2
		
		goto	INTERRUPT_LED_END

INTERRUPT_LED_P24:		
		;PT2.4
		btfsc	LED2,4
		incf	R_LED_DUTY,f
		btfsc	LED5,6
		incf	R_LED_DUTY,f
		btfsc	LED4,7
		incf	R_LED_DUTY,f
		btfsc	LED5,2
		incf	R_LED_DUTY,f
		btfsc	LED4,4
		incf	R_LED_DUTY,f
		btfsc	LED4,3
		incf	R_LED_DUTY,f
		btfsc	LED7,4
		incf	R_LED_DUTY,f
		
		
		
		btfsc	LED2,4
		bcf		R_LED_LIGHT,0
		btfsc	LED5,6
		bcf		R_LED_LIGHT,1
		btfsc	LED4,7
		bcf		R_LED_LIGHT,2
		btfsc	LED5,2
		bcf		R_LED_LIGHT,3
		btfsc	LED4,4
		bcf		R_LED_LIGHT,5
		btfsc	LED4,3
		bcf		R_LED_LIGHT,6
		btfsc	LED7,4
		bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,4
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH		
		
		movlw	11101111b
		movwf	PT2
		
		goto	INTERRUPT_LED_END

INTERRUPT_LED_P25:				
		;PT2.5
		btfsc	LED3,6
		incf	R_LED_DUTY,f
		btfsc	LED3,5
		incf	R_LED_DUTY,f
		btfsc	LED4,5
		incf	R_LED_DUTY,f
		btfsc	LED1,7
		incf	R_LED_DUTY,f
		btfsc	LED4,2
		incf	R_LED_DUTY,f
		btfsc	LED3,4
		incf	R_LED_DUTY,f
		btfsc	LED7,5
		incf	R_LED_DUTY,f
		
				
		btfsc	LED3,6
		bcf		R_LED_LIGHT,0
		btfsc	LED3,5
		bcf		R_LED_LIGHT,1
		btfsc	LED4,5
		bcf		R_LED_LIGHT,2
		btfsc	LED1,7
		bcf		R_LED_LIGHT,3
		btfsc	LED4,2
		bcf		R_LED_LIGHT,4
		btfsc	LED3,4
		bcf		R_LED_LIGHT,6
		btfsc	LED7,5
		bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,5
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH			
		
		movlw	11011111b
		movwf	PT2
		
		goto	INTERRUPT_LED_END

INTERRUPT_LED_P26:		
		;PT2.6
		btfsc	LED1,3
		incf	R_LED_DUTY,f
		btfsc	LED6,7
		incf	R_LED_DUTY,f
		btfsc	LED3,0
		incf	R_LED_DUTY,f
		btfsc	LED1,4
		incf	R_LED_DUTY,f
		btfsc	LED3,3
		incf	R_LED_DUTY,f
		btfsc	LED3,2
		incf	R_LED_DUTY,f		
		btfsc	LED7,6
		incf	R_LED_DUTY,f
		
		
		btfsc	LED1,3
		bcf		R_LED_LIGHT,0
		btfsc	LED6,7
		bcf		R_LED_LIGHT,1
		btfsc	LED3,0
		bcf		R_LED_LIGHT,2
		btfsc	LED1,4
		bcf		R_LED_LIGHT,3
		btfsc	LED3,3
		bcf		R_LED_LIGHT,4
		btfsc	LED3,2
		bcf		R_LED_LIGHT,5
		btfsc	LED7,6
		bcf		R_LED_LIGHT,7
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,6		
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH		
		
		movlw	10111111b
		movwf	PT2
		goto	INTERRUPT_LED_END
		
		
		nop		
INTERRUPT_LED_P27:		
		;PT2.6
		btfsc	LED6,0
		incf	R_LED_DUTY,f
		btfsc	LED6,1
		incf	R_LED_DUTY,f
		btfsc	LED6,2
		incf	R_LED_DUTY,f
		btfsc	LED6,3
		incf	R_LED_DUTY,f
		btfsc	LED6,4
		incf	R_LED_DUTY,f
		btfsc	LED6,5
		incf	R_LED_DUTY,f		
		btfsc	LED6,6
		incf	R_LED_DUTY,f
		
		
		btfsc	LED6,0
		bcf		R_LED_LIGHT,0
		btfsc	LED6,1
		bcf		R_LED_LIGHT,1
		btfsc	LED6,2
		bcf		R_LED_LIGHT,2
		btfsc	LED6,3
		bcf		R_LED_LIGHT,3
		btfsc	LED6,4
		bcf		R_LED_LIGHT,4
		btfsc	LED6,5
		bcf		R_LED_LIGHT,5
		btfsc	LED6,6
		bcf		R_LED_LIGHT,6
		
		movlw	11111111b
		xorwf	R_LED_LIGHT,w
		btfsc	status,z
		goto	INTERRUPT_LED_END
		
		bcf		R_LED_LIGHT,7		
		movfw	R_LED_LIGHT
		movwf	PT2CON
		movwf	7FH		
		
		movlw	01111111b
		movwf	PT2
		goto	INTERRUPT_LED_END
		
		
		nop		
INTERRUPT_LED_END:
		bcf		status,c
		rlf		R_LED_DUTY,f		
		;根据点灯个数做电流调整	
		;111 110 10ma 
		;101 	 15ma 
		;100 	 20ma
		;011	 25ma
		;010	 30ma
		;001	 40ma
		;000	 50ma	
		movfw	R_LED_DUTY
		addpcw	
		nop
		nop
		movlw	10111001b					
		goto	INTERRUPT_LED_END1
		movlw	01111001b					
		goto	INTERRUPT_LED_END1
		movlw	00111001b					
		goto	INTERRUPT_LED_END1
		movlw	00111001b					
		goto	INTERRUPT_LED_END1
		movlw	00111001b					
		goto	INTERRUPT_LED_END1
		movlw	00111001b				
		goto	INTERRUPT_LED_END1
		movlw	00011001b	       			
		goto	INTERRUPT_LED_END1
INTERRUPT_LED_END1:	
        btfsc   full_flag,0
		movlw	01011001b					
		goto	INTERRUPT_LED_END3
INTERRUPT_LED_END3:	
		movwf	LEDCON1	
		
		;根据点灯个数做时间调整
		;1、不做电流调整时候的配置 80 100 120 160 200 240
		movfw	R_LED_DUTY
		addpcw	
		nop
		nop
		movlw	115							
		goto	INTERRUPT_LED_END2
		movlw	139						
		goto	INTERRUPT_LED_END2
		movlw	124
		goto	INTERRUPT_LED_END2
		movlw	130
		goto	INTERRUPT_LED_END2
		movlw	170
		goto	INTERRUPT_LED_END2
		movlw	210
		goto	INTERRUPT_LED_END2
		movlw	255
		goto	INTERRUPT_LED_END2			
INTERRUPT_LED_END2:	
		movwf	TM1IN
		
		
		/*
		;根据点灯个数做时间调整
		;1、不做电流调整时候的配置 80 100 120 160 200 240
		movfw	R_LED_DUTY
		addpcw	
		nop
		nop
		movlw	80							
		goto	INTERRUPT_LED_END2
		movlw	100							
		goto	INTERRUPT_LED_END2
		movlw	120
		goto	INTERRUPT_LED_END2
		movlw	160
		goto	INTERRUPT_LED_END2
		movlw	200
		goto	INTERRUPT_LED_END2
		movlw	240
		goto	INTERRUPT_LED_END2
					
INTERRUPT_LED_END2:	
		movwf	TM1IN
		*/
		
		goto	interrupt_end	



interrupt_end:
		;pop

		movfw	R_BAK_S
		movwf	STATUS
		movfw	R_BAK_W
		retfie



LED_TABLE_IOSET:
		addpcw
		;---LED1	
		retlw	FCH
		retlw	F5H
		retlw	B7H
		retlw	BEH
		retlw	B7H
		retlw	F5H
		retlw	F6H
		retlw	D7H		
		;---LED2
		retlw	FCH
		retlw	FAH
		retlw	EEH
		retlw	BEH
		retlw	EEH
		retlw	FAH
		retlw	F6H
		retlw	F9H
		;---LED3		
		retlw	BBH
		retlw	DDH
		retlw	9FH
		retlw	AFH
		retlw	9FH
		retlw	DDH
		retlw	DEH
		retlw	EDH
		;---LED4
		retlw	BBH
		retlw	DBH
		retlw	CFH
		retlw	AFH
		retlw	CFH
		retlw	DBH
		retlw	DEH
		retlw	EBH
		;---LED5
		retlw	F9H
		retlw	F3H
		retlw	E7H
		retlw	D7H
		retlw	E7H
		retlw	F3H
		retlw	EDH
		retlw	EBH
		;---LED6
		retlw	7EH
		retlw	7DH
		retlw	7BH
		retlw	77H
		retlw	6FH
		retlw	5FH
		retlw	3FH
		retlw	BDH
		;---LED7
		retlw	7EH
		retlw	7DH
		retlw	7BH
		retlw	77H
		retlw	6FH
		retlw	5FH
		retlw	3FH
		retlw	BDH



LED_TABLE_IOL:
		addpcw
		;---LED1	
		retlw	FEH
		retlw	FDH
		retlw	F7H
		retlw	BFH
		retlw	BFH
		retlw	F7H
		retlw	FEH
		retlw	DFH		
		;---LED2
		retlw	FDH
		retlw	FEH
		retlw	FEH
		retlw	FEH
		retlw	EFH
		retlw	FBH
		retlw	F7H
		retlw	FBH
		;---LED3		
		retlw	BFH
		retlw	FDH
		retlw	BFH
		retlw	BFH
		retlw	DFH
		retlw	DFH
		retlw	DFH
		retlw	FDH
		;---LED4
		retlw	FBH
		retlw	FBH
		retlw	DFH
		retlw	EFH
		retlw	EFH
		retlw	DFH
		retlw	FEH
		retlw	EFH
		;---LED5
		retlw	FDH
		retlw	F7H
		retlw	EFH
		retlw	F7H
		retlw	F7H
		retlw	FBH
		retlw	EFH
		retlw	FBH
		;---LED6
		retlw	7FH
		retlw	7FH
		retlw	7FH
		retlw	7FH
		retlw	7FH
		retlw	7FH
		retlw	7FH
		retlw	BFH
		;---LED7
		retlw	FEH
		retlw	FDH
		retlw	FBH
		retlw	F7H
		retlw	EFH
		retlw	DFH
		retlw	BFH
		retlw	FDH




