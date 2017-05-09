;;;***************************************************
;;;烧写首地址 OTP_addsL OTP_addsH
;;;读出数据地址 OTP_dataL OTP_dataH  个数 scounter
;;;
;;;
;;;**************************************************
;;;input   OTP_addsL[H]
;;;output   OTP_dataL[H]
;;;----------------------------------------------------                           
sub_read_otp:
         movff    O_RaddL,EADRL
         movp
         movwf    OTP_dataL        
         return
;;;----------------------------------------------------                
sub_read_otp_str:                 
         movff    Otp_addsL,O_RaddL
         movff    scounter,counter2
otp_read_loop:                         
         call     sub_read_otp
         movff    OTP_dataL,ind0
         incf     fsr0,1
         clrc         
	     movlw    01h
	     addwf    O_RaddL,1
	              	     
	     decfsz   counter2,1
	     goto     otp_read_loop
	     return                        
;-------------------------------------------------

;---------------------------------------------------
sub_write_otp:
         clrf		NETA       
         movlw      d3s
         call       sub_delay_12m823
         movlf    10000001b,NETF       ;;; [chp_vpp,LVR_EN,ENVDDA,0,0,0,0,ENVB]
        movlw      2
         call       sub_delay_s
         movff    Otp_addsL,otp_writeL                  
         movff    scounter,counter2
         movff    COUNTER0,fsr0
		 
		 movlf   10001011b,wdtcon   		;;1s	开看门狗
write_otp_loop:
		 clrwdt
		 movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		                  
         movff    otp_writeL,EADRL 
          
         movlw	  00h
         movwf	  EDAT
         
         clrwdt
         movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		        
         movfw    ind0
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
                 
         incf     fsr0,1
         clrc
	     movlw    01h
	     addwf    otp_writeL,1
	     decfsz   counter2,1
	     goto     write_otp_loop  
	     clrf	  wdtcon
	     clrwdt     
	         
;;;=====================================================
sub_check_otp:
         movff    Otp_addsL,O_RaddL
         movff    scounter,counter2
         movff    COUNTER0,fsr0                  
check_otp_loop:
         call     sub_read_otp
         je_ff    otp_dataL,ind0         
         goto     sub_re_writer_otp
         incf     fsr0,1
         clrc
	     movlw    01h
	     addwf    O_RaddL,1         
         decfsz   counter2,1
         goto     check_otp_loop
         bcf      sys_flag2,program
;;;====================================================
sub_writer_close:
		 movlf		00100011b,NETF		;(0,0,ENVDDA,0,0,0,0,ENVB)  ENVDDA,ENVB高电平使能      
	     movlw		d3s
	     call		sub_delay_12m823
         return
;;;====================================================
sub_re_writer_otp:
         btfsc    sys_flag2,program
         goto     sub_writer_close
         bsf      sys_flag2,program
         goto     sub_write_otp         
;;;----------------------------------------------------

sub_write_otp2:
         clrf		NETA       
         movlw      d3s
         call       sub_delay_12m823
         movlf    10000001b,NETF       ;;; [chp_vpp,LVR_EN,ENVDDA,0,0,0,0,ENVB]
        movlw      2
         call       sub_delay_s
         movff    Otp_addsL,otp_writeL                  
         movff    scounter,counter2
         movff    COUNTER0,fsr0
		 
		 movlf   10001011b,wdtcon   		;;1s	开看门狗
write_otp_loop2:
		 clrwdt
		 movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		                  
         movff    otp_writeL,EADRL 
          
         movlw	  00h
         movwf	  EDAT
         
         clrwdt
         movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		        
         movfw    ind0
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
                 
         clrc
	     movlw    01h
	     addwf    otp_writeL,1
	     decfsz   counter2,1
	     goto     write_otp_loop2  
	     clrf	  wdtcon
	     clrwdt     
	         
;;;=====================================================
sub_check_otp2:
         movff    Otp_addsL,O_RaddL
         movff    scounter,counter2
         movff    COUNTER0,fsr0                  
check_otp_loop2:
         call     sub_read_otp
         je_ff    otp_dataL,ind0         
         goto     sub_re_writer_otp2
         incf     fsr0,1
         clrc
	     movlw    01h
	     addwf    O_RaddL,1         
         decfsz   counter2,1
         goto     check_otp_loop2
         bcf      sys_flag2,program
;;;====================================================
sub_writer_close2:
		 movlf		00100011b,NETF		;(0,0,ENVDDA,0,0,0,0,ENVB)  ENVDDA,ENVB高电平使能      
	     movlw		d3s
	     call		sub_delay_12m823
         return
;;;====================================================
sub_re_writer_otp2:
         btfsc    sys_flag2,program
         goto     sub_writer_close2
         bsf      sys_flag2,program
         goto     sub_write_otp2 
         
;;;-----------------------------------------------------
;;;****************************************************
sub_pau_e2_data:	
/*		movlw   050h
		movwf   Cali_KBL
		movwf   Cali_KBH
		movwf   Cali_EKBH
	
		movlw   00fh
		movwf   Cali_KBEL
		movwf   Cali_KBEH
		movwf   Cali_EKBEH	
		bcf		Unit_Flag,cal_weight*/
		movlw   0e8h
		movwf   Cali_KBL
		movlw   0bh
		movwf   Cali_KBEL
		
		movlw   dch
		movwf   Cali_KBH
		movwf   Cali_EKBH
		movlw   11h
		movwf   Cali_KBEH
		movwf   Cali_EKBEH
		bcf		Unit_Flag,cal_weight
		return		
	
;;;**********************************************************	
sub_CaluOtp_XOR:
    	movlf	Cali_KBL,fsr0
    	movlf	05h,scounter
   	 	movff	ind0,F_al
sub_calu_loop:
 		incf	fsr0,1
		movfw   ind0
		xorwf   F_al,1   	
 		decfsz	scounter,1
 		goto	sub_calu_loop
 		return
;;;------------------------------------------------------	
sub_compure_XOR:	   
		bcf     Ad_Flag,AdC_Err
		je_ff   F_al,Cali_xorl
		goto    E2K_Bad
		return
;;;------------------------------------------------------
E2K_Bad:	
		bsf     Ad_Flag,AdC_Err
		return
;;;*******************************************************    


                                