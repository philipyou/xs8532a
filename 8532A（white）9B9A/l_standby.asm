;=====================================================
;  				待机部分代码
;=====================================================
;	待机部分代码主要完成的事情如下：
;   0、高速采集AD,2KHZ采集4笔
;	1、判断人是否下秤
;	2、同时满足人下秤和大于开机重量时开机
;
;=====================================================
main_kmg:
	
	    ;------温度测试冷却时间处理-------------------
	    movfw	TEMP_CDT_L
	    iorwf	TEMP_CDT_H,w
	    btfsc	status,z	
	    goto	main_kmg_2		;为零时不再计数
main_kmg_1:	    
		movlw	01h
		subwf	TEMP_CDT_L,f
		movlw	00h
		subwfc	TEMP_CDT_H,f
		
		movfw	TEMP_CDT_L
	    iorwf	TEMP_CDT_H,w
	    btfsc	status,z	
		bcf		TEMP_FRESH,F_CD_TIME	;为零时，冷却时间够允许温度采集
main_kmg_2:
	    
	    ;---------------------------------------------   	
		incfsz  mem_time,1
		goto	$+2
		incf	mem_timeh,1
		movlw   60h			            ;6个小时清记忆值
		subwf   mem_time,0
		movlw	54h
		subwfc	mem_timeh,0
		btfss   status,c
		goto    main_kmg_3
		clrf    w_mem
		clrf    w_memh
main_kmg_3:
	    	;------清看门狗使能模拟电源-------------------
        clrwdt
	    clrf    wdtcon	
		movlf	00100011b,NETF			   
	    movlf   11000000b,NETE  
		;------判断是否符合唤醒条件--------------------
test_adc:
		;---读四次AD值并计算重量		
		call    Sub_Get_hAdc
		;---清SFR节省功耗，假如达不到起秤重量为睡眠做准备    
		mc_clrf   
		call    Sub_Get_Pure_WC 
		  
		;---自动上秤条件判断     		
  	   	btfss   Calu_Flag,R_Is_MBE
  	   	;---负重量置起下称标志并---进入睡眠 
  	   	goto    sleep_up_weight       			
	   	movfw   open_weightl
	   	subwf   AdBuf0l,0
	   	movfw   open_weighth
	   	subwfc  AdBuf0h,0	   
	   	btfss   STATUS,C 
	   	;---小于起称重量---进入睡眠             	
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
	   	    	
		;---判断下称标志是否置起
       	btfsc   ad_flag,weight0 
       	;---下秤标志置起并且大于起秤重量---唤醒      	
       	goto    sub_weight0_ok  
       	;---下秤标志没有置起---进入睡眠           
       	goto    sleep_no_weight0 


		;------判断人下秤--------------------------------
auto_sleep:      
        btfsc   ad_flag,weight0       	;判断下秤标志是否置起
        goto    sleep_no_weight0      	;已置起，不再判断是否下称

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
        bsf     ad_flag,weight0       	;小于起称重量 - 30h(6*8=48) 则设下称标志     
		sleep_no_weight0:
	    bcf		SYS_FLAG1,OpenTime		;;;关机时间变为10s		                 
        movlf   10000100b,wdtcon   		;;1s
        movlw   0bbh
        movwf   wdtin
        goto	main_sleep
             	
       	     	
		;------唤醒前初始化部分代码----------------------------	
sub_weight0_ok:
		;---保存零点和单位标志
		movff	Ad0_Zerol,R_Sub
		movff	Ad0_Zeroh,R_Subh
		movff	Unit_Flag,Adf_Times
		movff   w_mem,buffer11
		movff   w_memh,buffer12
		movff	UserHeight,buffer13
		
		;---清80H后115个byte的RAM
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
	  	;---恢复之前保存的零点
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
	    ;---置自动上称标志并唤醒	    
        bsf     Sys_Flag2,bf_AutoOpen       
		bsf		Calu_Flag,scan_zero		;第一次去零标志			
        goto	P_POWER_ON				;开机			 	        


		;------睡眠部分代码-------------------------------------		
main_sleep:
        clrf     cnt2 
        
	    bsf		P_LED,B_LED0	    ;关背光 
	    bcf     SYS_FLAG1,F_kaiji
	    bcf     Unit_Flag,keyflag 
	    bsf     inte,gie
	    bsf     inte,e0ie
	    bsf		P_LED,B_LED0	    ;关背光       
        sleep
        nop
        nop
		;---按键唤醒
        movlw    200
		call     sub_delay_1ms 		;;;20MS   
		btfsc	hard_key,UINT
		goto	main_sleep
;		bcf		SYS_FLAG1,ScanKey
        bsf     Sys_Flag2,bf_AutoOpen
        bsf     Unit_Flag,keyflag
		goto	P_POWER_ON
;===============================================================
;待机部分代码   CODE SECTION END	
;===============================================================
		
		
		
		
		