;;;****************************************************
Sub_Test_Battery:
        bcf     Ad_Flag,AdC_Err  	;;;pause_low_test          
        btfsc   svd,lbout
        goto    Sub_Test_Battery_ext
        
        incf    svd_cnt,1
        movfw   svd_cnt
        sublw   5
        btfsc   status,c
        return	
battery_low:
        bsf     Ad_Flag,AdC_Err  	;;;pause_low_test
        return
Sub_Test_Battery_ext:
	    clrf    svd_cnt
	    return
;;;***************************************************
sub_clear_allint:
		clrf    INTF
;		clrf    INTE	
		return
;;;************************************************
sub_delay_s:
		movwf	Redun1
de_12m823:
		movlw	d3s
		call	sub_delay_12m823
		decfsz	Redun1,1
		goto	de_12m823
		return
;---------------------------
sub_delay_s1:
		movwf	Redun1
de_12m8230:
		movlw	d2s
		call	sub_delay_12m823
		decfsz	Redun1,1
		goto	de_12m8230
		return
;;;================================================
sub_delay_12m823:
		movwf   delay_k1 
de_12m1:
		movlf   0ffh,delay_k2
de_12m2:
		nop
		decfsz  delay_k2,1
		goto    de_12m2
		decfsz  delay_k1,1
		goto    de_12m1
		return	
;;;=============================================
sub_delay_1ms:
		movwf   delay_k1 
de_1m1:
		movlf   16,delay_k2
de_1m2:
		nop
		decfsz  delay_k2,1
		goto    de_1m2
		decfsz  delay_k1,1
		goto    de_1m1
		return	

;;;******************************************
Sub_Get_Pure_WC:       
        movlf   Ad0_Zerol,fsr0
        movff2   AdBuf0l,A_BesL
        call    Sub_Sub_Abs_BES
        movff   R_Sub,adbuf0l
        movff   R_Subh,adbuf0h
        btfss   Calu_Flag,7
        goto    Sub_Get_Pure_WC0
		bsf     weight_flag,R_Is_MBE  
		goto    Sub_Get_Pure_WC1
Sub_Get_Pure_WC0:  
        bcf     weight_flag,R_Is_MBE     
Sub_Get_Pure_WC1:        
        clrf    adbuf0el
        return
;;;******************************************



	    		
;;;---------追零处理----------------------------
/*sub_samll_weight:
		bcf       	ad_flag,weight0		   ; 清零位标志	
        btfss   	weight_flag,R_Is_MBE   ; 计算重量函数sub_calu_wkg控制该标志，重量为负时置0
        goto    	sub_samll_p   		   ; 负值直接追零处理
        btfss		sys_flag2,bf_AutoOpen  
        goto		sub_samll_weight_l1    ; 正常称重零点处理
        ;---自动开机,第一次特殊处理
        movlw   	0c2h          		   ; 自动开机，设4.5KG起秤
	    subwf   	F_bl,0
	    movlw   	01h
	    subwfc  	F_bh,0
	    jnc
	    return							   ; >4.5kg 退出零位处理
	    goto		sub_samll_weight0      ;小重量置零位，但不追零
        
sub_samll_weight_l1:
	    movlw   	02ch          		   ; 300 = 12ch
	    subwf   	F_bl,0
	    movlw   	01h
	    subwfc  	F_bh,0
	    jnc							
		return						   	   ; >3kg  退出零位处理
		movlw   	022h              	   ; 290 = 122h  
		subwf   	F_bl,0
		movlw   	01h
		subwfc  	F_bh,0
		jnc        
		goto    	sub_samll_weight0      ; 2.9kg<=bh&l<3kg，置零位,不追零	
		
		;---追零处理	
sub_samll_p:
		;--判断稳定8次才追零，否则只置零位标志		      				
		movlw		08h
		subwf		adf_times,0
		jc
		goto      	sub_samll_weight0
sub_samll_zero:        
		movlf   	adcbuf0l,fsr0
		movff2   	cad0_zerol,A_BesL
		call    	Sub_Sub_Abs_BES
		btfsc		Calu_Flag,R_Is_MBE
		goto		sub_samll_zero1
		movfw   	open_weightl            ;;; 小于+/-3KG追零范围
		subwf   	R_Sub,0
		movfw   	open_weighth
		subwfc  	R_Subh,0
		btfsc   	status,c
		goto    	sub_samll_weight0
sub_samll_zero1:        
		movff   	AdcBuf0l,Ad0_Zerol                        
		movff   	AdcBuf0h,Ad0_Zeroh
		bsf			Calu_Flag,scan_zero		;;第一次去零	    
sub_samll_weight0:
		bsf       	ad_flag,weight0
;;;-------------------------------------------
sub_samll_ok:	    		
		btfss		Calu_Flag,scan_zero
		return
sub_samll_0:	    	                     	
		clrf      	F_bl 
		clrf      	F_bh
		return*/

;;;---------追零处理----------------------------
sub_samll_weight:
        clrf        zero_flag
		bcf       	ad_flag,weight0		   ; 清零位标志	
        btfss   	weight_flag,R_Is_MBE   ; 计算重量函数sub_calu_wkg控制该标志，重量为负时置0
        goto    	sub_samll_weight12   		   ; 负值直接追零处理
        btfss		sys_flag2,bf_AutoOpen  
        goto		sub_samll_weight_l1    ; 正常称重零点处理
        ;---自动开机,第一次特殊处理
        movlw   	0c2h          		   ; 自动开机，设4.5KG起秤
	    subwf   	F_bl,0
	    movlw   	01h
	    subwfc  	F_bh,0
	    jnc
	    return							   ; >4.5kg 退出零位处理
	    goto		sub_samll_weight0      ;小重量置零位，但不追零
        
sub_samll_weight_l1:
        movlw   	014h              	   ; 0.2kg 
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jc 
		goto        sub_samll_weight0
		
		bcf         weight_flag,0		
		movlw		04h
		subwf		adf_times,0
		jc
		goto      	sub_samll_weight13
		
		bcf         weight_flag,0
	    movlw   	0b7h     ;0f4h          		   ; 500 = 1f4h  700=2bch
	    subwf   	F_bl,0
	    movlw   	02h    ;01h
	    subwfc  	F_bh,0
	    jc	
	    goto	    sub_samll_weight_l10
	    bcf			Ad_Flag,lock_dsp
	    bcf         disp_flash_flag,7					
		return               ;goto		sub_samll_weight3       ; 4.5kg  退出零位处理
sub_samll_weight_l10:		
;		btfsc       UserFlag,suo
;        goto        sub_samll_weight10
;        btfsc       UserFlag,pan
;        goto        sub_samll_weight10
		movlw   	014h              	   ; 440 = 1b8h  
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jnc        
		goto    	sub_samll_zero1      ; 2kg<=b，置零位,不追零
			
		
sub_samll_zero12:        
        bsf       	ad_flag,weight0       
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
		clrf        Cali_cnt
		return	    
sub_samll_zero1: 
        
;        bsf       	ad_flag,weight0       
        bsf         zero_flag,c_flag
		return	    
sub_samll_weight0:
        btfsc      disp_flash_flag,7
        goto       sub_samll_weight1
        movlf      Ad0_Zerol,fsr0
        movff2     cAd0_Zerol,A_BesL
        call       Sub_Sub_Abs_BES
        movlw      028h		;;;this is is 0.3nkg,
		subwf      R_Sub,0
		movlw      00H
		subwfc     R_Subh,0   	;;;	c=0 in range ,same as  wcurrent & w_mem	
		jnc
        goto       sub_samll_weight1   
        bcf        UserFlag,suo
        movff      Ad0_Zerol,cAd0_Zerol
	    movff      Ad0_Zeroh,cAd0_Zeroh
        
sub_samll_weight1:
        
		bsf       	ad_flag,weight0		
        return
sub_samll_weight13:  
        movlw   	014h              	   ; 440 = 1b8h  
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jc  
		goto        sub_samll_weight1
		btfss       disp_flash_flag,7
		goto        sub_samll_weight1
        bcf			Ad_Flag,lock_dsp 
        bcf         disp_flash_flag,7
        
        btfss		SYS_FLAG1,closeTime
		goto        sub_samll_weight1
		bcf			SYS_FLAG1,closeTime
		call		sub_initialize_time	
        goto        sub_samll_weight1
;---------------------
	
sub_samll_weight12:
		movlw   	014h              	   ;
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jc     
		goto        sub_samll_weight0
		
        bsf         weight_flag,0
        bcf         UserFlag,pan
		movlw		04h
		subwf		adf_times,0
		jc
		goto      	sub_samll_weight0
		
		
		btfsc       UserFlag,suo
        goto        sub_samll_weight11
                
		movlw   	014h              	   ; 
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jc 		  
		goto        sub_samll_zero12
sub_samll_weight11:		 
		 clrf      	F_bl 
		clrf      	F_bh
		;clrf        w_mem
		;clrf        w_memh
sub_samll_weight10:		
        bsf       	ad_flag,weight0 
        bcf         UserFlag,pan
        clrf        Cali_cnt
		bsf         zero_flag,no_disp_c
		return
sub_samll_weight3:
        bsf       	ad_flag,weight0
sub_samll_weight2:
		return
;-----------------------------------------
sub_c_weight:
        btfsc       zero_flag,c_flag
        goto        sub_c_weight2
        bcf         UserFlag,pan
        bcf         UserFlag,suo
	    bsf         zero_flag,c_flag
        call        sub_dsp_c  
sub_c_weight1:
        bsf       	ad_flag,weight0	
        movff   	AdcBuf0l,Ad0_Zerol                        
		movff   	AdcBuf0h,Ad0_Zeroh   
sub_c_weight2:			    
        clrf      	F_bl 
		clrf      	F_bh
		return		
;;;-------------------------------------------
;---------------锁定处理------------------------
sub_dsp_lock:
		btfss		ad_flag,weight0
		goto		sub_lock_dsp			;不处于零位，跳去大重量锁定处理
		
		btfsc		Ad_Flag,lock_open		;处于零位有下秤锁定标志，处理下秤
		nop
;		call		sub_nflash_dw		
		bcf			Ad_Flag,lock_open
		btfss		Ad_Flag,lock_dsp
		goto        sub_dsp_lock2
sub_dsp_lock1:		
		movff		w_mem,F_bl
		movff		w_memh,F_bh		
		return
sub_dsp_lock2:
;        clrf       disp_flash_flag
        btfsc       disp_flash_flag,7
        goto        sub_dsp_lock1
        return
;;;-------------------------------------
sub_lock_dsp:
		btfsc		Ad_Flag,lock_open		;lock_open置起表明下秤过程
		goto		sub_dsp_lock1			;在下秤过程中遇到大重量要锁定
		bcf			Ad_Flag,lock_dsp		;其他过程要解锁
		clrf       disp_flash_flag
		btfss		SYS_FLAG1,closeTime
		return
		bcf			SYS_FLAG1,closeTime
		call		sub_initialize_time		
		return		


		
		
		
;;;*****************************************************
/*
SUB_WC_MEM_APP:			;;;	50/128=0.3906kg
		movff   F_bl,r_wl 
		movff   F_bh,r_wh

        movlw   	01eh          		   ; 50KG以下记忆 0.2kg
	    subwf   	F_bl,0
	    movlw   	00h
	    subwfc  	F_bh,0
	    jc
	    goto        mem_as_e
	    
	    movlf       F_bl,fsr0   
		movff2      w_mem,A_BesL    		;;;;|down-up|   
		call        Sub_Sub_Abs_BES		;;;;|ind1-ind0|
		movlw       019h		;;;this is is 0.3nkg,
		subwf       R_Sub,0
		movlw       00H
		subwfc      R_Subh,0   	;;;	c=0 in range ,same as  wcurrent & w_mem	
		jnc
		goto	    mem_as_e
		goto        mem_as
SUB_WC_MEM_APP1:       
		movlf   F_bl,fsr0   
		movff2   w_mem,A_BesL    		;;;;|down-up|   
		call    Sub_Sub_Abs_BES		;;;;|ind1-ind0|
		movlw   019h  ;02dh		;;;this is is 0.4nkg,
		subwf   R_Sub,0
		movlw   00H
		subwfc  R_Subh,0   	;;;	c=0 in range ,same as  wcurrent & w_mem	
		jnc
		goto	mem_as_e
;;;-------------------------------------
mem_as:				;;;	c=0 as mem
		movff   w_mem,F_bl
		movff   w_memh,F_bh
		movff   w_mem,r_wl
		movff   w_memh,r_wh
mem_as_e:
		
		RETURN
*/
		
sub_renew_weight:
		movff		F_bl,r_wl 
		movff		F_bh,r_wh
		return 
		
		
;;;*****************************************************
;-----------------------------------------------------------------wb-20161009 14:07修改
SUB_WC_MEM_APP:			;;;	50/128=0.3906kg		
		movlw   	01eh          	;;;  3kg	以下不记忆
	    subwf   	r_wl,0
	    movlw   	00h
	    subwfc  	r_wh,0
	    jc
	    goto        mem_as_e	      
	    
	    movlf       r_wl,fsr0		;;;跟上一次记忆重量偏差0.25kg采用记忆值
		movff2      w_mem,A_BesL    		  
		call        Sub_Sub_Abs_BES		
		movlw       23h		
		subwf       R_Sub,0
		movlw       00H
		subwfc      R_Subh,0   	;;;	c=0 in range ,same as  wcurrent & w_mem	
		jnc
		goto	    mem_as_e
		goto        mem_as
;;;-------------------------------------
mem_as:					
		movff   w_mem,r_wl
		movff   w_memh,r_wh
mem_as_e:
		movff   r_wl,F_bl
		movff   r_wh,F_bh
		RETURN
		
		
;;;*******************************************************
sub_nflash_ntk0:	
        movlf   01h,F_nflash
        goto    sub_nflash_ntk3
sub_nflash_ntk:		;;;new flash no test key.
        movlf   03h,F_nflash
sub_nflash_ntk3:
        movfw	LCDG
        movwf	F_dl
        movfw	LCDS
        movwf	F_dh
        movfw	LCDB
        movwf	F_edl
        movfw	LCDQ
        movwf	F_edh
        
        movfw	R_LED_SIGN
        movwf	F_cl        
        
nflash_ntk1:               
        clrf	LCDG
        clrf	LCDS
        clrf	LCDB
        clrf	LCDQ
        clrf	R_LED_SIGN
        bsf     R_LED_SIGN,0 
        call	SUB_DSP_REAL
        bsf         led7,1        
 	 	movlw   2
		call    sub_delay_s1
		 
		movfw	F_dl
        movwf	LCDG
        movfw	F_dh
        movwf	LCDS
        movfw	F_edl
        movwf	LCDB
        movfw	F_edh
        movwf	LCDQ     
        
        movfw	F_cl
        movwf	R_LED_SIGN
        call	SUB_DSP_REAL
        bsf         led7,1 
        ;bsf		lcd6,3		;;; . 
           		
nflash_ntk2:		
 	 	movlw   2
		call    sub_delay_s1		
        decfsz  F_nflash,1
        goto    nflash_ntk1
	    return
	    
;;;#########################################
;单位闪显
;------------------------------------------
sub_nflash_dw:		
		movlf	02h,F_nflash
sub_nflash_dw1:
		movfw	R_LED_SIGN
		movwf	F_dl
		clrf	R_LED_SIGN
		call	SUB_DSP_REAL
		movlw   1
		call    sub_delay_s
		movfw	F_dl
		movwf	R_LED_SIGN
		call	SUB_DSP_REAL
		;bsf		lcd6,3		;;; . 
		
		movlw   3
		call    sub_delay_s		
        decfsz  F_nflash,1
        goto    sub_nflash_dw1
        
        clrf	LCDQ
		clrf	LCDB

		movlw	Lcdch0	;显示0.0
		movwf	LCDS

		movlw	Lcdch0
		movwf	LCDG

		bsf		R_LED_SIGN,4		;;; . 
		call	SUB_DSP_REAL
		;bsf		lcd6,3		;;; . 			
		bcf		Ad_Flag,lock_dsp	;单位闪显表示下称，解锁称重
		return
	    
	    
	    
;;;#########################################
; HexCode to BCDCode Transfer
;-------------------------------------------
; Max Translation
;(FFFFFF)16 in EAX to(16777215)10 in EBX
; Run cycle : 1611
;-------------------------------------------
sub_Hex2BCD:  
		clrf	F_BL
		clrf	F_BH
		clrf	F_EBL
		clrf	F_EBH

		movlf	24,counter0
		clrc
BCD_Lp:
		rlf	F_AL,1
		rlf	F_AH,1
		rlf	F_EAL,1
		rlf4b	F_BL
		decfsz	counter0,1
		goto	AdjDec
		return
AdjDec:
		movlf	F_BL,FSR0
		call	sub_AdjBcd
		movlf	F_BH,FSR0
		call	sub_AdjBcd
		movlf	F_EBL,FSR0
		call	sub_AdjBcd
		movlf	F_EBH,FSR0
		call	sub_AdjBcd
		goto	BCD_Lp
;;;-----------------------------  
sub_AdjBcd:  
		movlw	03h
		addwf	00h,0
		btfsc	WORK,3
		movwf	00h
		movlw	30h
		addwf	00h,0
		btfsc	WORK,7
		movwf	00h
		return
;;;-------------------------------------------------------
MR_BAT_ERR:
		CALL    Sub_Lowbat_Dsp
;;;-------------------------------------
MR_ERR_DSP_DELAY:	
 	 	movlw   18
		call    sub_delay_s			
MR_ERR_Sleep:
		GOTO    mp_weight_over
;;;********************************************************
sub_cleareax:
cleareax:
		clrf          F_al
		clrf          F_ah
cleareal:
		clrf          F_eal
		clrf          F_eah
		return
	
;==================================
sub_edx_ecx:
edx_ecx:
		sub_4b        F_dl,F_cl
		return
;;;==========================================

;;;*****************************************	
Sub_Sub_Abs_BES:    ;;;;|ind1-ind0|    ;;;0 nested		;;;changed fr:   1:50 04092k5 0409ens	
		movfw    ind0
		subwf    A_BesL,0    ;;;ind1 m.
		movwf    R_Sub
	
		incf	 fsr0,1
;;		incf	 fsr1,1
		
		movfw    ind0
		subwfc   A_BesH,0    ;;;ind1 m.
		movwf    R_Subh    
	
		bsf      Calu_Flag,R_Is_MBE
		btfsc    STATUS,C  
		Return			;;;c=1 ,m >= s.
		bcf      Calu_Flag,R_Is_MBE
		decf	 fsr0,1
;;		decf	 fsr1,1
	
		movfw    A_BesL
		subwf    ind0,0    ;;;ind1 m.
		movwf    R_Sub
	
		incf	 fsr0,1
;;		incf	 fsr1,1
	
		movfw    A_BesH
		subwfc   ind0,0    ;;;ind1 m.
		movwf    R_Subh
	
		return
;;;*****************************************		
sub_if_locked_o:
			
sub_if_locked:
		
	
		movlf   r_wl,fsr0   
		movff2   lr_wl,A_BesL    		;;;;|down-up|   
		call    Sub_Sub_Abs_BES		;;;;|ind1-ind0|
		
		movlw	  f0h
		subwf	  r_wl,0
		movlw	  23h
		subwfc  r_wh,0
		btfss	  status,c
		goto	  $+3
		movlw   06h		;大于92kg限制范围变小
		goto	  $+2	
		movlw   08h		;;05h            ;;;this is is 0.2nkg,
			
			
		subwf   R_Sub,0
		movlw   00H
		subwfc  R_Subh,0   	        ;;;	c=0 in range ,same as  wcurrent & w_mem	
 	   	btfsc	status,c
  	  	goto    locked_no
  	  
  	  	movlw	014h
		subwf	r_wl,0
		movlw	00h
		subwfc	r_wh,0
		btfsc	status,c
		goto	locked_f
		incf	Get_zero_count,1
		goto	locked_no1			
locked_no:
		clrf	Get_zero_count
locked_no1:
		clrf    same_w_times	
 	    return
locked_f:	
		incf    same_w_times,1
		movlw	15
		subwf	same_w_times,w
		btfsc	status,c
		decf	same_w_times,1
		return
;;;---------------------------------------------
sub_kgerr_range:
;		btfsc	P_CAP,caption
;		goto	err_183kg
		movlf	0c4h,MaxWeightL
		movwf	DmaxL
		movlf	03bh,MaxWeightH
		movwf	DmaxH
err_range_com:			
		movfw   MaxWeightL	         	;;;;18300 = 477ch    18090 = 46AAH   15300 = 3bc4h
		subwf   F_bl,0
		movfw   MaxWeightH
		subwfc  F_bh,0	
		bsf     Ad_Flag,AdC_Err
		jc	
		bcf     Ad_Flag,AdC_Err
		return
;;;-----------------------------------------
err_183kg:
		movlf	0aah,MaxWeightL
		movwf	DmaxL		
		movlf	046h,MaxWeightH
		movwf	DmaxH		
		goto	err_range_com
		
		
;;;-------------------------------------------				
		
;;;=================================================
sub_if_weight_o:       
        movlw   	14h              	   ; 0.3kg 
		subwf   	F_bl,0
		movlw   	00h
		subwfc  	F_bh,0
		jnc  
		GOTO        sub_weight_times 
;        je_fd	F_bh,0
;        goto	sub_weight_times
;        je_fd	F_bl,0
;        goto	sub_weight_times            	
       	clrf    same_w_times
       	incf	weight_0_times,1
		return
;;;------------------------------------------
sub_weight_times:		
		clrf	weight_0_times
		return             
;;;===========================================		
;;;================================= 
sub_calu_openweight:
        movff   Cali_KBH,F_al
        movff   Cali_KBEH,F_ah
        bcf     status,c
        rrf_2div2   F_al
        rrf_2div2   F_al
        rrf_2div2   F_al
        rrf_2div2   F_al        ;;;3.125kg
        movff2      F_al,open_weightl
        return
;;;======================================
Sub_Cali_biaoding:  
        incf        Cali_cnt,1
        btfsc       Cali_flag,0
        goto        Sub_Cali_biaoding1
        movlw   	eeh    				;350*7.62   450*7.62=3429
		subwf   	AdBuf0l,0					;重量(35kg)-(45KG)就要检测是否进入标定
		movlw   	08h    
		subwfc  	AdBuf0h,0
		btfss       status,c
		goto        Sub_Cali_biaoding3
		movlw       dch				
		subwf   	AdBuf0l,0					;重量35kg-45KG就要检测是否进入标定
		movlw   	11h
		subwfc  	AdBuf0h,0
		btfsc       status,c
		goto        Sub_Cali_biaoding3
		bsf         Cali_flag,0
		movff       AdBuf0h,Cali_KBEL_bak
	    movff       AdBuf0l,Cali_KBL_bak
	    
	    clrf    F_eah
		clrf    F_eal
		movff   Cali_KBEL_bak,F_ah		
		movff   Cali_KBL_bak,F_al  
		clrf    F_ebh
    	clrf    F_ebl
	    CLRF    F_bh
	    movlf   27,F_bl
	    CALL    sub_mul4		;*27
	    
	    clrf    F_ech
        clrf    F_ecl
        clrf    F_ch
   		movlw   20
        movwf   F_cl
		call    sub_4div4	;;;result in ebx  /20
	    	    
	    movff	F_bl,Cali_KBEL_DOWN		;xia xian
	    movff	F_bh,Cali_KBEH_DOWN
	    
	    clrf    F_eah
		clrf    F_eal
		movff   Cali_KBEL_bak,F_ah		
		movff   Cali_KBL_bak,F_al  
		clrf    F_ebh
    	clrf    F_ebl
	    CLRF    F_bh
	    movlf   33,F_bl
	    CALL    sub_mul4		;*33
	    
	    clrf    F_ech
        clrf    F_ecl
        clrf    F_ch
   		movlw   20
        movwf   F_cl
		call    sub_4div4	;;;result in ebx  /20
	    	    
	    movff	F_bl,Cali_KBEL_UP		;shang xian
	    movff	F_bh,Cali_KBEH_UP
	    
	    goto        Sub_Cali_biaoding_ext
Sub_Cali_biaoding1:
        btfsc       Cali_flag,1
        goto        Sub_Cali_biaoding2
        
        movfw       Cali_KBL_bak
	    subwf       AdBuf0l,1
	    movfw       Cali_KBEL_bak
	    subwfc      AdBuf0h,1
	    btfss       status,c
	    goto        Sub_Cali_biaoding3
        
        movfw   	Cali_KBEL_DOWN				
		subwf   	AdBuf0l,0					;重量(50kg)-(70KG)就要检测是否进入标定
		movfw   	Cali_KBEH_DOWN
		subwfc  	AdBuf0h,0
		btfss       status,c
		goto        Sub_Cali_biaoding3
		movfw       Cali_KBEL_UP				
		subwf   	AdBuf0l,0					;重量50kg-70KG就要检测是否进入标定
		movfw   	Cali_KBEH_UP
		subwfc  	AdBuf0h,0
		btfsc       status,c
		goto        Sub_Cali_biaoding3
		bsf         Cali_flag,1
				
		movff       AdBuf0h,Cali_KBEH_bak
	    movff       AdBuf0l,Cali_KBH_bak
	    goto        Sub_Cali_biaoding_ext
Sub_Cali_biaoding2:
        btfsc       Cali_flag,2
        goto        Sub_Cali_biaoding3
        
        movfw       Cali_KBL_bak
	    subwf       AdBuf0l,1
	    movfw       Cali_KBEL_bak
	    subwfc      AdBuf0h,1
        btfss       status,c
        goto        Sub_Cali_biaoding3	           
	    movfw       Cali_KBH_bak
	    subwf       AdBuf0l,1
	    movfw       Cali_KBEH_bak
	    subwfc      AdBuf0h,1
	            
        movfw   	Cali_KBEL_DOWN    ;0c3h				
		subwf   	AdBuf0l,0					;重量(50kg)-(70KG)就要检测是否进入标定
		movfw   	Cali_KBEH_DOWN     ;0ah
		subwfc  	AdBuf0h,0
		btfss       status,c
		goto        Sub_Cali_biaoding31
		movfw       Cali_KBEL_UP				
		subwf   	AdBuf0l,0					;重量50kg-70KG就要检测是否进入标定
		movfw   	Cali_KBEH_UP
		subwfc  	AdBuf0h,0
		btfsc       status,c
		goto        Sub_Cali_biaoding3
		bsf         Cali_flag,2
		movfw       Cali_cnt
		xorlw       03
		btfss       status,z
		goto        Sub_Cali_biaoding3
;		call        sub_over_err		
		movff       AdBuf0h,Cali_EKBEH_bak
	    movff       AdBuf0l,Cali_EKBH_bak
	    
	    movff       Cali_KBL_bak,Cali_KBL
	    movff       Cali_KBEL_bak,Cali_KBEL
	    movff       Cali_KBH_bak,Cali_KBH
	    movff       Cali_KBEH_bak,Cali_KBEH
	    movff       Cali_EKBH_bak,Cali_EKBH
	    movff       Cali_EKBEH_bak,Cali_EKBEH
sub_save_eeprom:	    
	    clrwdt
	    clrf	    wdtcon	    
		call		sub_CaluOtp_XOR
		movff		F_al,Cali_XORL
		clrf		adctimes
;		bcf			tmcon,tmen
;		bcf			inte,tmie
		bcf			Calu_Flag,cal_time				               	    	     

	    movff       Ad0_Zerol,cAd0_Zerol
	    movff       Ad0_Zeroh,cAd0_Zeroh
        bcf         sys_flag2,program
        call        Sub_Dsp_Lcd_Null
		mc_write_ram_to_otp_scounter  20h,00h,c0h,7        
sub_save_ok:     
		btfsc   	Sys_Flag2,program
		goto    	sub_save_err1
sub_save_e2ok:		      
		call    	sub_dsp_pass
		goto    	sub_save_ok1
sub_save_err1:
		call    	sub_over_err
		goto    	sub_save_ok1
sub_save_ok1:
        call        sub_calu_openweight
 	 	movlw       1
		call        sub_delay_s	    	    	    
		bcf         ad_flag,weight0
	    movlf       19h,filter_xs		       
		call	    sub_clear_allint
		bsf		    Ad_Flag,cal_model		;;;标定完测试
		bsf         Ad_Flag,biaoding_err
;		bcf		    Ad_Flag,lock_open
;		bcf		    Ad_Flag,lock_dsp
        goto        Sub_Cali_biaoding32
Sub_Cali_biaoding3:
        movlw   	02h				
		subwf   	f_bl,0					;重量减小的重量小于5kg就要解锁了
		movlw   	00h
		subwfc  	f_bh,0
		btfsc       status,c
		goto        Sub_Cali_biaoding33
		bcf         zero_flag,c_flag
		goto        Sub_Cali_biaoding30
Sub_Cali_biaoding33:	
	    movlw   	070h				
		subwf   	f_bl,0					;重量减小的重量小于7kg就要解锁了
		movlw   	00h
		subwfc  	f_bh,0
		btfsc       status,c
	    goto        Sub_Cali_biaoding30
	    bsf         zero_flag,c_flag
Sub_Cali_biaoding30:	
	    btfss       Ad_Flag,cal_model
        call    	sub_nflash_ntk 	
Sub_Cali_biaoding32: 
        movfw       Cali_cnt
        sublw       3
        btfsc       status,c
        goto        Sub_Cali_biaoding34
        movlw       4
        movwf        Cali_cnt
Sub_Cali_biaoding34:       
        clrf        Cali_flag	
        clrf        Cali_KBL_bak  
        clrf        Cali_KBEL_bak  
        clrf        Cali_KBH_bak    
        clrf        Cali_KBEH_bak  
        clrf        Cali_EKBH_bak   
        clrf        Cali_EKBEH_bak	          
	    return
Sub_Cali_biaoding31:
        movlw   	05bh    ;0c3h				
		subwf   	AdBuf0l,0					;重量(18kg)-(50KG)就要清除EEPROM
		movlw   	05h     ;0ah
		subwfc  	AdBuf0h,0
		btfss       status,c
		goto        Sub_Cali_biaoding3
		movfw       Cali_cnt
		xorlw       03
		btfss       status,z
		goto        Sub_Cali_biaoding3
		
		call        sub_dsp_clr
		call	    compare_clr_eep
		clrf        Cali_flag
        clrf        Cali_cnt	
        clrf        Cali_KBL_bak  
        clrf        Cali_KBEL_bak  
        clrf        Cali_KBH_bak    
        clrf        Cali_KBEH_bak  
        clrf        Cali_EKBH_bak   
        clrf        Cali_EKBEH_bak	          
;	    movlw       10
;		call        sub_delay_s	
		return
Sub_Cali_biaoding_ext:

        btfsc       Cali_flag,1
        goto        Sub_Cali_biaoding_ext1
        btfsc       Cali_flag,2
        goto        Sub_Cali_biaoding_ext1
        btfss       Ad_Flag,cal_model
        call    	sub_nflash_ntk		      ;下面是重量锁定后判断是否在规定次数内下称，    
        bsf         UserFlag,suo
        bsf         UserFlag,fuzhisuo    
        return
Sub_Cali_biaoding_ext1:   
	    btfss       Ad_Flag,cal_model
        call        sub_nflash_ntk0
         return
;---------------------------------------------------
sub_check_weight: 		
		call        Sub_Get_Adc					;;;;获取AD值	
		call        Sub_Get_Pure_WC				;;;计算相对变化量
		call        Sub_Adc_Filter    			;;;;滤波 enter:AdBuf0l   ;;;outport: AdBuf0l
		call        sub_calu_wkg   				;;;;计算重量 input AdBuf0l ;;ouput bl,bh,ebl and this is all kg.
;		call	    sub_samll_weight        	;;;;min samll weight
		
sub_check_weight_04:
		bsf			SYS_FLAG1,F_returnLock
		bcf         UserFlag,7
		movlf   	F_bl,fsr0
		movff2   	w_mem,A_BesL		
		call    	Sub_Sub_Abs_BES	
		
		btfsc		Calu_Flag,R_Is_MBE
		goto		sub_check_weight_1		;重量变小的处理
											;重量变大的处理
		movlw		c8h
		subwf		R_Sub,0                 
		movlw		0h
		subwfc		R_Subh,0
		btfss		status,c              ;重量增大的幅度要大于2kg往下执行，否则退出
		return
/*		movlw		08h
		subwf		adf_times,0
		jc
		goto        sub_check_weight*/
		btfss       Ad_Flag,biaoding_err
		goto		sub_check_weight_4
		return							
sub_check_weight_1: 			
        movlw   	0b3h				
		subwf   	f_bl,0					;重量减小的重量小于5kg就要解锁了
		movlw   	02h
		subwfc  	f_bh,0
		bsf			SYS_FLAG1,F_returnLock		
		btfsc   	status,c
		return  
		movlw		01h
		subwf		adf_times,0
		jc
		goto      	sub_check_weight
		
		bcf         UserFlag,suo
		bcf         UserFlag,pan
		movlw   	014h				
		subwf   	f_bl,0					;重量减小的重量小于0.4kg就要清标志
		movlw   	00h
		subwfc  	f_bh,0		
		btfsc   	status,c
		goto        sub_check_weight_20
		
		;bsf       	ad_flag,weight0	
        ;movff   	AdcBuf0l,Ad0_Zerol                        
		;movff   	AdcBuf0h,Ad0_Zeroh  
		
		bsf         UserFlag,7
		bcf         UserFlag,pan
		goto        sub_check_weight_2
sub_check_weight_20:
        nop
		;bsf         UserFlag,pan
sub_check_weight_2:	

        clrf        Cali_flag
        clrf        Cali_cnt	
        clrf        Cali_KBL_bak  
        clrf        Cali_KBEL_bak  
        clrf        Cali_KBH_bak    
        clrf        Cali_KBEH_bak  
        clrf        Cali_EKBH_bak   
        clrf        Cali_EKBEH_bak
;        bcf			Ad_Flag,lock_open				;;;解锁显示
;        return
sub_check_weight_4:        
		bcf			SYS_FLAG1,F_returnLock
		bcf			Ad_Flag,lock_open				;;;解锁显示			
;		btfsc		Calu_Flag,R_Is_MBE				;;;
;		bsf			Ad_Flag,lock_open				;;;显示仍然锁着	 记忆重量比较大，说明是下称，重量显示要锁着					
		return	
;-------------------------------------------
zero_check_weight1:  
        call	sub_c_weight            	;;;;min samll weight
                                            ;下面子程序用做延时功能
		call    Sub_Get_Adc_Delay			;;;;获取AD值
		
        /*
		call    Sub_Get_Adc
		call    Sub_Get_Pure_WC				;;;计算相对变化量
		call    Sub_Adc_Filter    			;;;;滤波 enter:AdBuf0l   ;;;outport: AdBuf0l
		call    sub_calu_wkg   				;;;;计算重量 input AdBuf0l ;;ouput bl,bh,ebl and this is all kg.
		*/
		
		return
;		movlf   	F_bl,fsr0
;		movff2   	w_mem,A_BesL		
;		call    	Sub_Sub_Abs_BES	
		
		btfss		Calu_Flag,R_Is_MBE
		goto		zero_check_weight1_1		;重量变小的处理
											;重量变大的处理
		movlw		c2h
		subwf		F_bl,0
		movlw		01h
		subwfc		F_bh,0
		bsf			SYS_FLAG1,F_returnLock
		btfss		status,c
		return
		goto		zero_check_weight1_2		;重量增大的幅度要大于4.5kg才解锁
zero_check_weight1_1: 			
		movlw   	0c2h				
		subwf   	F_bl,0					;重量减小的幅度大于3kg就要解锁了
		movlw   	01h
		subwfc  	F_bh,0
		bsf			SYS_FLAG1,F_returnLock		
		btfss   	status,c
		return
zero_check_weight1_2:		
		bcf			SYS_FLAG1,F_returnLock
		bcf			Ad_Flag,lock_open				;;;解锁显示			
;		btfsc		Calu_Flag,R_Is_MBE				;;;
;		bsf			Ad_Flag,lock_open				;;;显示仍然锁着	 记忆重量比较大，说明是下称，重量显示要锁着	
		clrf        zero_flag				
		return
			
;;;*****************************************
Sub_Adc_Filter:		;;;changed the zero shift to ex,inoder to protect the zero pure.
		movlf   AdBuf0l,fsr0
		movff2   Adf_old,A_BesL    		;;;;|down-up| 
		call    Sub_Sub_Abs_BES		;;;;|ind1-ind0|
		MOVfw   filter_xs
		subwf   R_Sub,0
		movlw   00h
		subwfc  R_Subh,0	
		
		;movff   AdBuf0l,Adf_old
		;movff   AdBuf0h,Adf_oldh
	
		btfss   status,c	
		goto    Adc_Filter_R1
		
		btfsc	ad_filter_en,f_ad_fil_en		;连续两次超过范围才刷新缓存
		goto	Sub_Adc_Filter_PRE
		bsf		ad_filter_en,f_ad_fil_en
		goto	adf_8all_times					;用会上一次的AD
Sub_Adc_Filter_PRE:	
		bcf		ad_filter_en,f_ad_fil_en
		movff   AdBuf0l,Adf_old
		movff   AdBuf0h,Adf_oldh
		call    sub_clr_adbuf					;;;CLBUF_A_FT    F_Adf1,F_Adf1+0FH
		clrf    Adf_Times
		return		    						;;;dsp_this_and_no_need_save
;;;------------------------------------------
Adc_Filter_R1:
;;;------------------------------------------
		bcf		ad_filter_en,f_ad_fil_en
		je_fd   Adf_Times,03h		;第一次从不稳定到稳定要判断是否刷新关机时间
		goto    Adc_Filter_R2
		
		movlw	81h					;接近18秒才稳定要刷新关机时间
		subwf	weight_0_times,w
		btfsc   status,c
		call	sub_initialize_time	
		
Adc_Filter_R2:
		movfw   Adf_Times
		andlw   00001111b
		movwf   Adf_Times 
		incf    Adf_Times,1
;;;==========================================
		je_fd   Adf_Times,0fh
		goto    Adf_Load_Over
;;;-------------------------------------
		movlf   0eh,Adf_Times
;;;-------------------------------------	
Adf_Load_Over:
;;;=================================================
		movfw   Adf_Times
		andlw   00101111b
		addpcw
		goto    adf_8all_times	
		goto    adc_fi_load1
		goto    adc_fi_load2
		goto    adc_fi_load3
		goto    adc_fi_load4
		goto    adc_fi_load5
		goto    adc_fi_load6
		goto    adc_fi_load7
	
		goto    adc_fi_load8
		goto    adc_fi_load9
		goto    adc_fi_loada
		goto    adc_fi_loadb	
		goto    adc_fi_loadc		
		goto    adc_fi_loadd		
		goto    adc_fi_loade		
		goto    adc_fi_loadf
;;;---------------------------------------
adc_fi_load1:
        movff2  AdBuf0l,F_Adf1
adc_fi_load2:
        movff2  AdBuf0l,F_Adf2	
adc_fi_load3:
        movff2  AdBuf0l,F_Adf3
adc_fi_load4:
        movff2  AdBuf0l,F_Adf4		
adc_fi_load5:
        movff2  AdBuf0l,F_Adf5
adc_fi_load6:
        movff2  AdBuf0l,F_Adf6	
adc_fi_load7:
        movff2  AdBuf0l,F_Adf7
adc_fi_load8:
        movff2  AdBuf0l,F_Adf8		
;;;-------------------------------------------------
adf_8all_times:
		call    sub_adf_all_add
		Byte_3Div2   AdBuf0l
		Byte_3Div2   AdBuf0l
		Byte_3Div2   AdBuf0l
		movff   AdBuf0l,Adf_old
		movff   AdBuf0h,Adf_oldh
		return
;;;*************************************************
adc_fi_load9:
adc_fi_loada:
adc_fi_loadb:
adc_fi_loadc:	
adc_fi_loadd:	
adc_fi_loade:	
adc_fi_loadf:
        movff2  F_Adf2,F_Adf1
		movff2  F_Adf3,F_Adf2
		movff2  F_Adf4,F_Adf3
		movff2  F_Adf5,F_Adf4
		movff2  F_Adf6,F_Adf5
		movff2  F_Adf7,F_Adf6
		movff2  F_Adf8,F_Adf7
        movff2  AdBuf0l,F_Adf8  
        goto    adf_8all_times
;;;=================================================		
sub_clr_adbuf:
		movlf   F_Adf1,clr_raml
		movlf   F_Adf8h,clr_ramh
sub_clr_ram:
		incf    clr_ramh,1
		movff   clr_raml,fsr0
C_Buf_L0:
		clrf    ind0
		incf    fsr0,1
		je_ff   fsr0,clr_ramh
		goto    C_Buf_L0
		return
;;;-----------------------------------

sub_adf_all_add:
		clrf    AdBuf0l
		clrf    AdBuf0h
		clrf    AdBuf0el
		movlf   Adf_SAdd,fsr0
Adc_All_Add:	
		movfw   ind0
		addwf   AdBuf0l,1
		incf	fsr0,1
		
		movfw   ind0
		addwfc  AdBuf0h,1         ;;;changed addwfc  3/11/2k3
		movlw   00h
		addwfc  AdBuf0el,1
		incf	fsr0,1
		
		JE_FD   fsr0,AdBuf0l     ;;;ok?????   ok see it add 1 is 0a0h.
		goto    Adc_All_Add
		return
;;;=========================================		
             	     		         	