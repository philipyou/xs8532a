;;;=========================================================
;;; INPUT IS AdBuf0l, OUT BL.
sub_calu_wkg:		;;; THIS IS PURE WEIGHT UNIT KG.   LESS THAN : IS 6000H=24576 = 245.76KG
Sub_Calu_Weight:		;;;source: pure_counter
	movff   AdBuf0l,F_al
	movff   AdBuf0h,F_ah	
;;;---------------------------------	
	movfw	Cali_KBL
	subwf	F_al,1
	movfw	Cali_KBEL
	subwfc	F_ah,1
	Skip_If_MorE 
	goto    calu_w_in_1		;;;use: AdBuf0l calu_weight
	movff   F_al,F_eal
	movff   F_ah,F_eah
;;;---------------------------------	
	movfw	Cali_KBH
	subwf	F_eal,1
	movfw	Cali_KBEH
	subwfc	F_eah,1
	Skip_If_MorE 
	goto    calu_w_in_2		;;;use: al calu_weight
	goto    calu_w_in_3		;;;use: eal calu_weight	
;;;-----------------------------------------------------------------	
calu_w_in_1:
; source in ebx, eax (4byte)
; object in ebxeax (8byte)
; eax(msb)|ebx(lsb)=eax*ebx
;;;-------------------------------------------
	clrf    F_ebh
	clrf    F_ebl
	movlf   0fh,F_bh
	movlf   a0h,F_bl		;;;1388h = 50.00kg   0FA0h = 40.00kg
;;;-----------------------
	clrf    F_eah
	clrf    F_eal
	movff   AdBuf0h,F_ah
	movff   AdBuf0l,F_al
	
	call    sub_mul4   ;;;result in ebx   ;;;////
;;;-------------------------------------
; ebx = ebh / ecx
        clrf     F_ech
        clrf     F_ecl
        movff    Cali_KBel,F_ch
        movff    Cali_KBL,F_cl

	call     sub_4div4	;;;result in ebx  is weght_in_s1

	return
;;;------------------------------------------------

;;;-----------------------------------------------------------------	
calu_w_in_2:
; source in ebx, eax (4byte)
; object in ebxeax (8byte)
; eax(msb)|ebx(lsb)=eax*ebx
;;;-------------------------------------------
	clrf    F_ebh
	clrf    F_ebl
	movlf   17h,F_bh
	movlf   70h,F_bl		;;;1388h = 50.00kg   0FA0h = 40.00kg
;;;-----------------------
	clrf    F_eah
	clrf    F_eal
;;      pure counter in al  in s2
	
	call    sub_mul4   ;;;result in ebx
;;;-------------------------------------
; ebx = ebh / ecx
        clrf     F_ech
        clrf     F_ecl
        movff    Cali_KBEH,F_ch
        movff    Cali_KBH,F_cl

	call     sub_4div4	;;;result in ebx  is weght_in_s2
;;;ADD  50KG	IN S2   4000  IS 0fa0H 4005 = 0fa5h   5005 = 138dh  5000 = 1388
	movlw	a0h
	addwf	F_BL,1
	movlw	0fh
	addwfc	F_BH,1
	movlw	00h
	addwfc	F_EBL,1
	movlw	00h
	addwfc	F_EBH,1
	
	return
;;;------------------------------------------------

;;;-----------------------------------------------------------------	
calu_w_in_3:
; source in ebx, eax (4byte)
; object in ebxeax (8byte)
; eax(msb)|ebx(lsb)=eax*ebx
;;;-------------------------------------------
	clrf    F_ebh
	clrf    F_ebl
	movlf   17h,F_bh
	movlf   70h,F_bl		;;;1388h = 50.00kg   0FA0h = 40.00kg
;;;-----------------------
	movff   F_eah,F_ah
	movff   F_eal,F_al    ;;;pure counter in eal
	clrf    F_eah
	clrf    F_eal
	
	call    sub_mul4   ;;;result in ebx
;;;-------------------------------------
; ebx = ebh / ecx
        clrf     F_ech
        clrf     F_ecl
        movff    Cali_EKBEH,F_ch
        movff    Cali_EKBH,F_cl

	call     sub_4div4	;;;result in ebx  is weght_in_s2
	
;;;ADD  100KG  IN S3     8000 = 1f40h 8005 = 1f45h  10005 = 2715h 
	movlw	10h
	addwf	F_BL,1
	movlw	27h
	addwfc	F_BH,1
	movlw	00h
	addwfc	F_EBL,1
	movlw	00h
	addwfc	F_EBH,1
	return
;;;------------------------------------------------
;;;================================================



IFDEF	DUNIT_LB
;;KG*22046/10000
;;;*************************************************
Sub_Real_Wlbkg:		;;;;IN: EBX,   OUT :EAX
		call	sub_mov_ebh_eah	
;;;-----------------------------
		btfsc   Unit_Flag,Unit_lb
		goto	sub_calu_unit
		return
sub_calu_Unit:
        clrf     F_ech
        clrf     F_ecl
      	clrf	 F_ch
        movlf    0ah,F_cl		;;;ah = 10.

		call     sub_4div4	;;;result in ebx  is weght_in_s2
;;;-----------------------------	
; source in ebx, eax (4byte)
; object in ebxeax (8byte)
; eax(msb)|ebx(lsb)=eax*ebx
;;;-------------------------------------------
		clrf    F_eah
		clrf    F_eal
		movlf   2bh,F_ah		;;;22046 IS 561EH   11023 is 2b0fh
		movlf   0fh,F_al		;;;KG*22046/10000
;;;-----------------------
;;;  AL IS ALREADY IN	
		call    sub_mul4   ;;;result in ebx
;;;-------------------------------------
; ebx = ebh / ecx
        clrf     F_ech
        clrf     F_ecl
        movlf    03h,F_ch
        movlf    0e8h,F_cl		;;;3e8h = 1000. 

		call     sub_4div4	;;;result in ebx  is weght_in_s2
	
		call	sub_mov_ebh_eah	
calu_lb_out:
        clrf    F_ech
        clrf    F_ecl
        clrf    F_ch
   		movlw   10
        movwf   F_cl

		call     sub_4div4	;;;result in ebx  is weght_in_s1 	


		clrf    F_eah
		clrf    F_eal
		clrf    F_ah		;;;22046 IS 561EH   11023 is 2b0fh
		movlf   14h,F_al		;;;14h = 20  
;;;-----------------------
;;;  AL IS ALREADY IN	
		call    sub_mul4   ;;;result in ebx
		call	sub_mov_ebh_eah			
		return
;;;------------------------------------------------

ELSE
;斤为单位直接乘以2
;------------------------------------------------
Sub_Real_Wlbkg:
		call	sub_mov_ebh_eah	
		btfss   Unit_Flag,Unit_lb
		return
		bcf		status,c
		rlf		F_bl,f
		rlf		F_bh,f
		rlf		F_ebl,f
		rlf		F_ebh,f
		call	sub_mov_ebh_eah
		return
ENDIF


sub_mov_ebh_eah:
 		movff   F_ebh,F_eah
		movff   F_ebl,F_eal
		movff   F_bh,F_ah
		movff   F_bl,F_al
		return
sub_mov_ebh_ech:
 		movff   F_ebh,F_ech
		movff   F_ebl,F_ecl
		movff   F_bh,F_ch
		movff   F_bl,F_cl
		return
;==============================================
sub_Real_BMI:
;        movlw   a5h             
;        movwf   UserHeight
        movfw   w_mem               
        movwf   ViewWeiL
        movfw   w_memh               
        movwf   ViewWeiH
        movlw   5
        addwf   ViewWeiL,1
        movlw   0
        addwfc  ViewWeiH,1
        
        clrf    F_ebh
		clrf    F_ebl
		movff   ViewWeiH,F_bh
	    movff   ViewWeiL,F_bL
        clrf    F_ech
        clrf    F_ecl
        clrf    F_ch
   		movlw   10
        movwf   F_cl
		call    sub_4div4
		clrf    F_eah
		clrf    F_eal
		clrf    F_ah
		movlw   10		
		movwf   F_al
		CALL    sub_mul4
        movff   F_bh,ViewWeiH
        movff   F_bl,ViewWeil
        
               
        clrf    F_eah
		clrf    F_eal
		clrf    F_ah		
		movFf   UserHeight,F_al  
		clrf    F_ebh
    	clrf    F_ebl
	    CLRF    F_bh
	    movff   UserHeight,F_bl
	    CALL    sub_mul4
	    call	sub_mov_ebh_ech
	    
	    clrf    F_eah
		clrf    F_eal
		movff   ViewWeiH,F_ah
	    movff   ViewWeiL,F_aL
	    clrf    F_ebh
    	clrf    F_ebl
	    movlf   03h,F_bh
	    movlf   e8h,F_bl
	    CALL    sub_mul4
	    
	    CALL    sub_4div4
	    call	sub_mov_ebh_eah
	    call    sub_Hex2BCD
	    movff   F_bh,UserBMIH
	    movff   F_bL,UserBMIL
        RETURN
;;;;========================================
; source in ebx, eax (4byte)
; object in ebxeax (8byte)
; eax(msb)|ebx(lsb)=eax*ebx
; run cycle : ??  B=A*B
;-------------------------------------------
sub_mul4:
	movff4       F_al,buffer11
	movlf        32,counter1       ;32 bits
	call         sub_cleareax
kmul4_lp:
	clrc
	btfsc        F_bl,0
	call         sub_add4b
	rrf4b       F_eah
	rrf4b        F_ebh
	decfsz       counter1,1
	goto         kmul4_lp
	return
sub_add4b:
	add_4b       buffer11,F_al
	return
;-------------------------------------------
;-------------------------------------------
; 4bytes div 4bytes   ;;;use: ea eb,ec,ed, counter1,4 buffer
; eax|ebx=eax|ebh/ecx
; run cycle : ????? B=B/C
;-------------------------------------------
sub_4div4:
	movlf         32,counter1
	clrf          buffer11
	clrf          buffer12
	clrf          buffer13
	clrf          buffer14
kdiv_lp:
	clrc
	rlf4b         F_bl
	rlf4b         buffer11
	movff4        buffer11,F_dl
	call          sub_edx_ecx
	jc
	goto          kdivless
	movff4        F_dl,buffer11
	incf          F_bl,1
kdivless:
	decfsz        counter1,1
	goto          kdiv_lp
	return
;;;;----------------------------------------------


;=========================================================================================
;除法函数48位除以24位
;=========================================================================================
;完成（r_div5、div4、r_div3、r_div2、r_div1、r_div0）/（r_divisor2、r_divisor1、r_divisor0）
;            ->商（r_div2、r_div1、r_div0）余数(r_div5、r_div4、r_div3)
;入口变量：  r_div5,r_div4,r_div3,r_div2,r_div1,r_div0,r_divisor2,r_divisor1,r_divisor0        
;出口变量：  r_div5,r_div4,r_div3,r_div2,r_div1,r_div0,
;中间变量：  div0
;=========================================================================================
F_Div24U:
	movlw	 18h
	movwf	 div0
	
    movlw 	 0               ;判断r_div5是否为零
	xorwf	 r_div5,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法
	movlw 	 0               ;判断r_div4是否为零
	xorwf	 r_div4,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法
	movlw 	 0               ;判断r_div3是否为零
	xorwf	 r_div3,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法
	movlw 	 0               ;判断r_div2是否为零
	xorwf	 r_div2,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法
	movlw 	 0               ;判断r_div1是否为零
	xorwf	 r_div1,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法
	movlw 	 0               ;判断r_div0是否为零
	xorwf	 r_div0,w
	btfss	 status,z 
	goto     L_Div24_1        ;否的话进行除法 
	goto     L_Div24_4
L_Div24_1:
	bcf		 Status,C
	rlf      r_div0,1
	rlf	     r_div1,1
	rlf	     r_div2,1
	rlf	     r_div3,1
	rlf	     r_div4,1
	rlf      r_div5,1
	
	btfsc    Status,C
	goto	 L_Div24_2
	movfw	 r_divisor2		;检测是否余数大于除数
	subwf	 r_div5,0
		
	btfsc    Status,Z	      ;等于0，相等进行次高位比较
	goto     L_Div24_COMP1
	btfss	 Status,C
	goto     L_Div24_3
	goto     L_Div24_2
L_Div24_COMP1:		           ;如果高位相等则检测次高位
	movfw    r_divisor1
	subwf    r_div4,0
	btfsc    Status,Z	      ;等于0，相等进行次高位比较 
	goto     L_Div24_COMP2
	btfss	 Status,C
	goto     L_Div24_3
	goto     L_Div24_2
L_Div24_COMP2:
	movfw    r_divisor0
	subwf    r_div3,0
	btfss	 Status,C
	goto     L_Div24_3
	goto     L_Div24_2
L_Div24_2:
	movfw	 r_divisor0
	subwf	 r_div3,1
	movfw    r_divisor1
	subwfc   r_div4,1
	movfw	 r_divisor2
	subwfc   r_div5,1
	incf	 r_div0,1
L_Div24_3:
	decfsz   div0,1
	goto     L_Div24_1
L_Div24_4:
	return


;========================================================================
;乘法函数 24位乘以24位
;========================================================================
;完成        (r_mul5、r_mul4、r_mul3)*(r_mul2、r_mul1、r_mul0)
;            ->r_mulre5、r_mulre4、r_mulre3、r_mulre2、r_mulre1、r_mulre0
;入口变量：  r_mul5,r_mul4,r_mul3 、r_mul2,r_mul1,r_mul0       
;出口变量：  r_mulre5、r_mulre4、r_mulre3、r_mulre2、r_mulre1、r_mulre0
;中间变量：  mul0
;========================================================================
F_Mul24U:
	movlw	   24
	movwf	   mul0
	clrf	   r_mulre5
	clrf	   r_mulre4
	clrf	   r_mulre3
	clrf	   r_mulre2
	clrf	   r_mulre1
	clrf	   r_mulre0
     
L_Mul24_1:
    bcf		   Status,C       ;clrc
    rlf	       r_mul0,1
    rlf        r_mul1,1
   	rlf        r_mul2,1
   	
    btfss	   Status,C       ;jc
    goto	   L_Mul24_2
    
	movfw	   r_mul3
    addwf	   r_mulre0,1
    movfw	   r_mul4
    addwfc	   r_mulre1,1
    movfw	   r_mul5
    addwfc	   r_mulre2,1
    movlw      0
    addwfc	   r_mulre3,1
    movlw      0
    addwfc	   r_mulre4,1
    movlw      0
    addwfc	   r_mulre5,1
     	
L_Mul24_2:
    decfsz	   mul0,1
    goto	   L_Mul24_3
    return
L_Mul24_3:
    bcf		   Status,C
    rlf	       r_mulre0,1
    rlf	       r_mulre1,1
    rlf	       r_mulre2,1
    rlf	       r_mulre3,1
    rlf	       r_mulre4,1
    rlf	       r_mulre5,1
    goto	   L_Mul24_1








	