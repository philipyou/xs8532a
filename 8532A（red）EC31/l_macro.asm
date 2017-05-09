;===========================================
; macro_csu8rp1185_rich.asm		version 1.0	
; User Define macor for CSU8RP1185 used
; Edit by rich_changed	 	4/11/2012
;===========================================




mov_7to8	macro
	movfw	ad_sort_h7_l
	movwf	ad_sort_h8_l
	movfw	ad_sort_h7_h
	movwf	ad_sort_h8_h
	endm

mov_6to7	macro
	movfw	ad_sort_h6_l
	movwf	ad_sort_h7_l
	movfw	ad_sort_h6_h
	movwf	ad_sort_h7_h
	endm

mov_5to6	macro
	movfw	ad_sort_h5_l
	movwf	ad_sort_h6_l
	movfw	ad_sort_h5_h
	movwf	ad_sort_h6_h
	endm

mov_4to5	macro
	movfw	ad_sort_h4_l
	movwf	ad_sort_h5_l
	movfw	ad_sort_h4_h
	movwf	ad_sort_h5_h
	endm

mov_3to4	macro
	movfw	ad_sort_h3_l
	movwf	ad_sort_h4_l
	movfw	ad_sort_h3_h
	movwf	ad_sort_h4_h
	endm

mov_2to3	macro
	movfw	ad_sort_h2_l
	movwf	ad_sort_h3_l
	movfw	ad_sort_h2_h
	movwf	ad_sort_h3_h
	endm

mov_1to2	macro
	movfw	ad_sort_h1_l
	movwf	ad_sort_h2_l
	movfw	ad_sort_h1_h
	movwf	ad_sort_h2_h
	endm

;--------------------------------
; Clear Carry
;--------------------------------
clrC	macro	
	bcf		Status,C
	endm
;--------------------------------
; Set Carry
;--------------------------------	
setC	macro
	bsf		Status,C
	endm
;;;*******************************************
JNE_FD  Macro   f1,d1
	movfw   f1
	xorlw   d1
	btfsc	Status,Z
	endm
;;;*******************************************
JE_FD   Macro   f1,d1
	movfw   f1
	xorlw   d1
	btfss	Status,Z
	endm
;;;*******************************************

JE_FF   Macro   f1,F2
	movfw   f1
	xorwf   f2,0
	btfss	Status,Z
	endm	
;**********************************8
; Skip on Carry
;--------------------------------		
Skip_If_MorE    macro
	btfss		Status,C
	endm
;--------------------------------	
jc	macro	
	btfss		Status,C
	endm
;--------------------------------	
jnc	macro	
	btfsc		Status,C
	endm
;--------------------------------
;;; Move #data to ram     
;--------------------------------
movlf	macro	d1,f1
	movlw	d1
	movwf	f1
	endm
;--------------------------------
; Move ram to ram        
;--------------------------------	
movff	macro	f1,f2
	movfw	f1
	movwf	f2
	endm
	
movff2	macro	f1,f2	
	movff	f1,f2
	movff	f1+1,f2+1
	endm
			
movff3	macro	f1,f2
	movff2	f1,f2
	movff	f1+2,f2+2
	endm

movff4	macro	f1,f2
	movff3  f1,f2
	movff   f1+3,f2+3
	endm
;;;**************************************8
;;   f2 = f1+f2     ;;;kim  ;;;f1 no change
;;-------------------------------------
add_3b	macro	f1,f2
	movfw	f1
	addwf	f2,1
	movfw	f1+1
	addwfc	f2+1,1
	movfw	f1+2
	addwfc	f2+2,1
	endm
;;;************************************	
;;   f2 = f1+f2     ;;;kim
;;-------------------------------------
add_4b	macro	f1,f2
	movfw	f1
	addwf	f2,1
	movfw	f1+1
	addwfc	f2+1,1
	movfw	f1+2
	addwfc	f2+2,1
	movfw	f1+3
	addwfc	f2+3,1
	endm

;;;************************************	
;;   f1 = f1-f2     ;;kim   compare
;;-------------------------------------
Compare_4b	macro	f1,f2
	movfw	f2
	subwf	f1,0
	movfw	f2+1
	subwfc	f1+1,0
	movfw	f2+2
	subwfc	f1+2,0
	movfw	f2+3
	subwfc	f1+3,0
	endm


;;;************************************	
;;   f1 = f1-f2     ;;kim
;;-------------------------------------
sub_4b	macro	f1,f2
	movfw	f2
	subwf	f1,1
	movfw	f2+1
	subwfc	f1+1,1
	movfw	f2+2
	subwfc	f1+2,1
	movfw	f2+3
	subwfc	f1+3,1
	endm
;;;****************************************
;;;    f1 = f1 / 2   ???  notece  cy  ?????
;;;****************************************
rrf4b	macro	f1
	rrf	f1,1
	rrf	f1-1,1
	rrf	f1-2,1
	rrf	f1-3,1
	endm

;;;****************************************
;;;    f1 = f1*2   ???	notece  cy  ?????
;;;****************************************
rlf4b	macro	f1
	rlf	f1,1
	rlf	f1+1,1
	rlf	f1+2,1
	rlf	f1+3,1
	endm
;;;**************************************
rrf3b_sl_c  macro   f1
	bcf     STATUS,C
	rrf	f1+2,1
	rrf	f1+1,1
	rrf	f1,1
	endm
;;;**************************************
rrf4b_sl_c  macro   f1
	bcf     STATUS,C
	rrf f1+3,1
	rrf	f1+2,1
	rrf	f1+1,1
	rrf	f1,1
	endm	
;;;**************************************
rrf4    macro   f1
		bcf		status,c
        rrf     f1,1
        rrf     f1,1
        rrf     f1,1
        rrf     f1,1
        endm
;;;;**********************************************

rlfEAX	macro
	rlf4b	AL
	endm

rlfEBX	macro
	rlf4b	BL
	endm

rrfEAX	macro
	rrf4b	EAH
	endm

rrfEBX	macro
	rrf4b	EBH
	endm
;;;*******************************************
Byte_3Div2   Macro	f1
	bcf     STATUS,C
	rrf	f1+2,1
	rrf	f1+1,1
	rrf	f1,1
	endm
;;;-------------------------------------------
rrf_2div2    Macro   f1
    bcf     status,c
    rrf f1+1,1
    rrf f1,1
    endm	
;;;============================================
mc_clrf     macro
    CLRF    INTF
    clrf    inte
;;	CLRF    NETF
	nop
	CLRF    NETE
	CLRF    ADCON
	clrf    wdtcon
	MOVlF   11111110b,PT1EN   	;;;add pt2.6 is out,pull,out hige 0 IN £ª1 OUT
	MOVlF   00000001b,PT1PU   	;;;00h …œ¿≠
	movlf	00000000b,PT1 
	movlf   00h,pt2pu
	movlf   ffh,pt2en
	movlf   00h,pt2
	
	clrf	pt2con
	clrf	7DH	
	clrf	7FH
	movlw	00000000b
	movwf	CHPCON
	
	endm

;;;=========================================================
;;;=============================================================
mc_read_otp_to_ram_scounter     macro x_otpsaddh,x_otpsaddl,x_ramadd,x_counter
	movlf	 x_otpsaddh,EADRH
    movlf    x_otpsaddL,OTP_addsL
    movlf    x_ramadd,fsr0
    movlf    x_ramadd,COUNTER0        
    movlf    x_counter,scounter
    clrf	O_RTimes
    call     sub_read_otp_str
    endm
;;;=============================================================
mc_check_otp_scounter    macro x_otpsaddh,x_otpsaddl,x_counter
	movlf	 x_otpsaddh,EADRH
    movlf    x_otpsaddL,OTP_addsL          
    movlf    x_counter,scounter
    movlf    01h,O_RTimes
    call     sub_blank_check
    endm 
;;;=============================================================
mc_write_ram_to_otp_scounter    macro x_otpsaddh,x_otpsaddl,x_ramadd,x_counter
	movlf	 x_otpsaddh,EADRH
    movlf    x_otpsaddL,OTP_addsL
    movlf    x_ramadd,COUNTER0           
    movlf    x_counter,scounter
    movlf    01h,O_RTimes    
    call     sub_write_otp
    endm
    

mc_ram_to_otp_scounter    macro x_otpsaddh,x_otpsaddl,x_ramadd,x_counter
	movlf	 x_otpsaddh,EADRH
    movlf    x_otpsaddL,OTP_addsL
    movlf    x_ramadd,COUNTER0           
    movlf    x_counter,scounter
    movlf    01h,O_RTimes    
    call     sub_write_otp2
    endm  
    
    
    