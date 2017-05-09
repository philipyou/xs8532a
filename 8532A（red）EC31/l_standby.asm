;=====================================================
;  				�������ִ���
;=====================================================
;	�������ִ�����Ҫ��ɵ��������£�
;   0�����ٲɼ�AD,2KHZ�ɼ�4��
;	1���ж����Ƿ��³�
;	2��ͬʱ�������³Ӻʹ��ڿ�������ʱ����
;
;=====================================================
main_kmg:
	
	    ;------�¶Ȳ�����ȴʱ�䴦��-------------------
	    movfw	TEMP_CDT_L
	    iorwf	TEMP_CDT_H,w
	    btfsc	status,z	
	    goto	main_kmg_2		;Ϊ��ʱ���ټ���
main_kmg_1:	    
		movlw	01h
		subwf	TEMP_CDT_L,f
		movlw	00h
		subwfc	TEMP_CDT_H,f
		
		movfw	TEMP_CDT_L
	    iorwf	TEMP_CDT_H,w
	    btfsc	status,z	
		bcf		TEMP_FRESH,F_CD_TIME	;Ϊ��ʱ����ȴʱ�乻�����¶Ȳɼ�
main_kmg_2:
	    
	    ;---------------------------------------------   	
		incfsz  mem_time,1
		goto	$+2
		incf	mem_timeh,1
		movlw   60h			            ;6��Сʱ�����ֵ
		subwf   mem_time,0
		movlw	54h
		subwfc	mem_timeh,0
		btfss   status,c
		goto    main_kmg_3
		clrf    w_mem
		clrf    w_memh
main_kmg_3:
	    	;------�忴�Ź�ʹ��ģ���Դ-------------------
        clrwdt
	    clrf    wdtcon	
		movlf	00100011b,NETF			   
	    movlf   11000000b,NETE  
		;------�ж��Ƿ���ϻ�������--------------------
test_adc:
		;---���Ĵ�ADֵ����������		
		call    Sub_Get_hAdc
		;---��SFR��ʡ���ģ�����ﲻ���������Ϊ˯����׼��    
		mc_clrf   
		call    Sub_Get_Pure_WC 
		  
		;---�Զ��ϳ������ж�     		
  	   	btfss   Calu_Flag,R_Is_MBE
  	   	;---�����������³Ʊ�־��---����˯�� 
  	   	goto    sleep_up_weight       			
	   	movfw   open_weightl
	   	subwf   AdBuf0l,0
	   	movfw   open_weighth
	   	subwfc  AdBuf0h,0	   
	   	btfss   STATUS,C 
	   	;---С���������---����˯��             	
	   	goto    auto_sleep 
	   	
	   	incf     cnt2,1 
	   	movlw    02h		            
		subwf    cnt2,0
	   	jc
	   	goto     main_kmg_3
	   	clrf     cnt2       
	   	
	   	movlf   zero_AdBuf0l,fsr0
        movff2   AdBuf0l,A_BesL
        call    Sub_Sub_Abs_BES
	   	movfw   open_weightl            ;;
		subwf   R_Sub,0
		movfw   open_weighth
		subwfc  R_Subh,0
		btfsc   status,c 
	   	goto     sub_weight0_ok   
	   	    	
		;---�ж��³Ʊ�־�Ƿ�����
       	btfsc   ad_flag,weight0 
       	;---�³ӱ�־�����Ҵ����������---����      	
       	goto    sub_weight0_ok  
       	;---�³ӱ�־û������---����˯��           
       	goto    sleep_no_weight0 


		;------�ж����³�--------------------------------
auto_sleep:      
        btfsc   ad_flag,weight0       	;�ж��³ӱ�־�Ƿ�����
        goto    sleep_no_weight0      	;�����𣬲����ж��Ƿ��³�

        movff   open_weightl,F_al
        movff   open_weighth,F_ah
              
        movlw   10h
        subwf   F_al,1
        movlw   00h
        subwfc  F_ah,1
             
	    movfw   F_al
	    subwf   AdBuf0l,0
	    movfw   F_ah
	    subwfc  AdBuf0h,0
	    btfss   STATUS,C              	
		sleep_up_weight:	          
        bsf     ad_flag,weight0       	;С��������� - 30h(6*8=48) �����³Ʊ�־     
		sleep_no_weight0:
	    bcf		SYS_FLAG1,OpenTime		;;;�ػ�ʱ���Ϊ10s		                 
        movlf   10000100b,wdtcon   		;;1s
        movlw   0bbh
        movwf   wdtin
        goto	main_sleep
             	
       	     	
		;------����ǰ��ʼ�����ִ���----------------------------	
sub_weight0_ok:
		;---�������͵�λ��־
		movff	Ad0_Zerol,R_Sub
		movff	Ad0_Zeroh,R_Subh
		movff	Unit_Flag,Adf_Times
		movff   w_mem,buffer11
		movff   w_memh,buffer12
		movff	UserHeight,buffer13
		
		;---��80H��115��byte��RAM
		bcf      bsr,7		
	   	movlf   115,80h
	   	movlf   08ch,fsr0	   	  	   
		mw_clrf_loop1:
	  	movlf   00h,ind0
	  	incf    fsr0,1
	  	clrc
	  	decfsz   80h,1
	  	goto     mw_clrf_loop1
	  	
	  	bsf      bsr,7
	    movlf    128,100h
	    movlf    101h,fsr0	   	  	   
mw_clrf_loop4:
	    movlf    00h,ind0
	    incf     fsr0,1
	    clrc
	    decfsz   100h,1
	    goto     mw_clrf_loop4
	    bcf      bsr,7
	  	;---�ָ�֮ǰ��������
	    movff	R_Sub,Ad0_Zerol
	    movwf	cAd0_Zerol
	    movff	R_Subh,Ad0_Zeroh
	    movwf	cAd0_Zeroh
	    movff   buffer11,w_mem
		movff   buffer12,w_memh
		movff	buffer13,UserHeight
	    movff	Adf_Times,Unit_Flag
	    clrf	Adf_Times
	    bcf		    Ad_Flag,cal_model
	    bcf         Ad_Flag,biaoding_err
	    ;---���Զ��ϳƱ�־������	    
        bsf     Sys_Flag2,bf_AutoOpen       
		bsf		Calu_Flag,scan_zero		;��һ��ȥ���־			
        goto	P_POWER_ON				;����			 	        


		;------˯�߲��ִ���-------------------------------------		
main_sleep:
        clrf     cnt2 
        
	    bsf		P_LED,B_LED0	    ;�ر��� 
	    bcf     SYS_FLAG1,F_kaiji
	    bcf     Unit_Flag,keyflag 
	    bsf     inte,gie
	    bsf     inte,e0ie
	    bsf		P_LED,B_LED0	    ;�ر���       
        sleep
        nop
        nop
		;---��������
        movlw    200
		call     sub_delay_1ms 		;;;20MS   
		btfsc	hard_key,UINT
		goto	main_sleep
;		bcf		SYS_FLAG1,ScanKey
        bsf     Sys_Flag2,bf_AutoOpen
        bsf     Unit_Flag,keyflag
		goto	P_POWER_ON
;===============================================================
;�������ִ���   CODE SECTION END	
;===============================================================
		
		
		
		
		