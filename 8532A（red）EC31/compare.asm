compare_clr_eep:	
		movlw	ffh
		movwf	data_test
				
		bsf		bsr,irp0
		mc_ram_to_otp_scounter  20h,20h,70h,80
		bcf		bsr,irp0		
		return
		
/*		movlw	20h
		movwf	EADRH
		movlw	20h
		movwf	O_RaddL
		call	sub_read_otp
		
		call	compare_clr
		mc_read_otp_to_ram_scounter  20h,20h,50h,80
		
		return*/


compare_clr:
		bsf		bsr,irp0
		
		movlw	80
		movwf	data_count
		
		movlw	data_test
		movwf	fsr0
compare_clr_loop:
		clrf	ind0
		
		incf	fsr0,f
		decfsz	data_count,f
		goto	compare_clr_loop		
		
		return		


compare_data:
		bsf		bsr,irp0
		movlw	0ffh
		movwf	data_th
		movlw	0ffh
		movwf	data_tl
		
		movlw	40
		movwf	data_count
		
		movlw	data_test
		movwf	fsr0
compare_data_loop:
				
		movfw	data_tl
		movwf	ind0
		incf	fsr0,f
		movfw	data_th
		movwf	ind0	
		incf	fsr0,f
		
/*		movlw	100
		addwf	data_tl,f
		movlw	0
		addwfc	data_th,f*/
		
		decfsz	data_count,f
		goto	compare_data_loop		
		
		return
;=====================================
sub_read_otp1:
         movlw	   20h
		 movwf	   EADRH
         movff    O_RaddL,EADRL
         movp
         movwf    OTP_dataL        
         return
;-----------------------------------------

compare:
         movlw     70h            ;地址2070存放数组个数
         movwf     O_RaddL
         call      sub_read_otp1
         movff     OTP_dataL,cmp_cnt
         movlw     71h            ;地址2070存放数组覆盖位置
         movwf     O_RaddL
         call      sub_read_otp1
         movff     OTP_dataL,cmp_cnt1
         
         movlw     0ffh
         xorwf     cmp_cnt,0
         btfss     status,z
         goto      com_read_eep
         clrf      cmp_cnt
         clrf      cmp_cnt1
         clrf      cmp_cnt_bak
         clrf      cmp_cnt1_bak
         movff     f_bl,eep_data_l
		 movff     f_bh,eep_data_h
		 bcf       cmp_flag,0
		 bcf       cmp_flag,1
		 bsf       cmp_flag,2
		 return
         goto      com_write_eep   ;没存数据，不用比较直接写入
;-----------------
com_read_eep:
         clrf      cmp_flag
         
         clrf      cmp_buff2kg_h
         clrf      cmp_buff2kg_l
         clrf      cmp_buff5kg_h
         clrf      cmp_buff5kg_l
         movlw     20h            ;地址从2020开始读数据  40组数据地址20H-6FH
         movwf     O_RaddL
         movff     cmp_cnt,counter2
com_read_loop:         
         call      sub_read_otp1
         movff     OTP_dataL,cmp_data_l
         clrc         
	     movlw     01h
	     addwf     O_RaddL,1
	     call      sub_read_otp1
	     movff     OTP_dataL,cmp_data_h
	     
	     
com_read_loop0:	     
	     movlf     F_bl,fsr0   
		 movff2    cmp_data_l,A_BesL    		;;;;|down-up|   
		 call      Sub_Sub_Abs_BES		;;;;|ind1-ind0|
		 movlw     0cdh		
		 subwf     R_Sub,0
		 movlw     00H
		 subwfc    R_Subh,0   	;;;	0-2kg
		 btfss     status,c
		 goto      com_read_2kg   ;差值在2KG以内
		 movlw     0f9h		
		 subwf     R_Sub,0
		 movlw     01H
		 subwfc    R_Subh,0   	;;;	2.1-5kg
		 btfss     status,c
		 goto      com_read_2_5kg
		 goto      com_read_5kg  ;5.1kg以上
com_read_2kg:
         btfsc     cmp_flag,0
         goto	   com_read_2kg1
                  
         bsf       cmp_flag,0
         bcf       cmp_flag,1
         bcf       cmp_flag,2
         clrf      cmp_buff5kg_h
         clrf      cmp_buff5kg_l
         movff     R_Subh,cmp_buff2kg_h
         movff     R_Sub,cmp_buff2kg_l
         movff     O_RaddL,cmp_addr2kg_h         
	     decf      O_RaddL,1 
	     movff     O_RaddL,cmp_addr2kg_l
	     movlw     01h
	     addwf     O_RaddL,1
	     
	     bcf       cmp_flag,down
	     bcf       cmp_flag,up
	     btfsc     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,down
         btfss     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,up
         goto      com_read_loop1
com_read_2kg1:              
         movfw     R_Sub
         subwf     cmp_buff2kg_l,0
         movfw     R_Subh
         subwfc    cmp_buff2kg_h,0
         btfss     status,c
		 goto      com_read_loop1
		 movff     R_Sub,cmp_buff2kg_l        ;每次读取数据跟上次读取数据比较，差值小的放入cmp_buff2kg
		 movff     R_Subh,cmp_buff2kg_h  
		 movff     O_RaddL,cmp_addr2kg_h         
	     decf      O_RaddL,1 
	     movff     O_RaddL,cmp_addr2kg_l
	     movlw     01h
	     addwf     O_RaddL,1
	     
	     bcf       cmp_flag,down
	     bcf       cmp_flag,up
	     btfsc     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,down
         btfss     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,up
		 goto      com_read_loop1
com_read_2_5kg:                      ;差值在2-5KG以内，建新的存储地址
         
         btfsc     cmp_flag,0
         goto      com_read_loop1 	
         btfsc     cmp_flag,1
         goto	   com_read_2_5kg1
         bsf       cmp_flag,1
         bcf       cmp_flag,2
         clrf      cmp_buff2kg_h
         clrf      cmp_buff2kg_l
         movff     R_Subh,cmp_buff5kg_h
         movff     R_Sub,cmp_buff5kg_l
         
         bcf       cmp_flag,down
	     bcf       cmp_flag,up
         btfsc     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,down
         btfss     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,up
         goto      com_read_loop1
com_read_2_5kg1: 
                 
         movfw     R_Sub
         subwf     cmp_buff5kg_l,0
         movfw     R_Subh
         subwfc    cmp_buff5kg_h,0
         btfss     status,c
		 goto      com_read_loop1
		 movff     R_Sub,cmp_buff5kg_l
		 movff     R_Subh,cmp_buff5kg_h  
		 
		 bcf       cmp_flag,down
	     bcf       cmp_flag,up
		 btfsc     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,down
         btfss     Calu_Flag,R_Is_MBE
         bsf       cmp_flag,up  
		 goto      com_read_loop1
com_read_5kg:                        ;差值在5KG以上
         btfsc     cmp_flag,0
         goto      com_read_loop1 	
         btfsc     cmp_flag,1
         goto	   com_read_loop1
		 bsf       cmp_flag,2
com_read_loop1:		
         clrc         
	     movlw     01h
	     addwf     O_RaddL,1	 
	     decfsz    counter2,1
	     goto      com_read_loop
	     btfsc     cmp_flag,0
	     goto      write_2kg_data
	     btfsc     cmp_flag,1
	     goto      com_write_eep0
	     btfsc     cmp_flag,2
	     goto      com_write_eep1
	     return
write_2kg_data:
         movff     cmp_buff2kg_l,chazhi_data_l       
		 movff     cmp_buff2kg_h,chazhi_data_h 
		 movff     f_bl,eep_data_l
		 movff     f_bh,eep_data_h
		 return
write_2kg_data1:		 
         movff     cmp_addr2kg_l,otp_writeL
         movlw     02h               
         movwf     counter2
;         bsf		bsr,irp0
;         movff     cmp_buff2kg_l,fsr0
         call      com_write_Data
         return
;;-----------------------------------
com_write_eep0:
         movff     cmp_buff5kg_l,chazhi_data_l       
		 movff     cmp_buff5kg_h,chazhi_data_h 
com_write_eep1:		 
		 movff     f_bl,eep_data_l
		 movff     f_bh,eep_data_h
		 movff     cmp_cnt1,cmp_cnt1_bak
		 movff     cmp_cnt,cmp_cnt_bak
		 return
com_write_eep:
         bcf      status,c
         rlf      cmp_cnt1_bak,0
         addlw    20h
         movwf    otp_writeL   
         movlw    02h               
         movwf    counter2
         movff    eep_data_l,fsr0		 
write_eep_loop:
		 call     com_write_Data
	     incf     cmp_cnt1_bak,1
	     movlw    40
	     subwf    cmp_cnt1_bak,0
	     btfss    status,c
	     goto     write_eep_loop1    ;最多存取40组数据
	     clrf     cmp_cnt1_bak
write_eep_loop1:
	     incf     cmp_cnt_bak,1
	     movlw    41
	     subwf    cmp_cnt_bak,0
	     btfss    status,c
	     goto     write_eep_loop0
	     movlw    40
	     movwf    cmp_cnt_bak
write_eep_loop0:  
         MOVLW    20H
         MOVWF    EADRH                   ;数组值存入70H,数组覆盖值存入71H
         clrwdt
		 movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		 
		 movlw    70h                 
         movwf    EADRL 
          
         movlw	  00h
         movwf	  EDAT
         
         clrwdt
         movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		        
         movfw    cmp_cnt_bak
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
         clrwdt
         
		 movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		 
		 movlw    71h                 
         movwf    EADRL 
          
         movlw	  00h
         movwf	  EDAT
         
         clrwdt
         movlw	  96h
		 movwf	  EOPEN
		 movlw	  69h
		 movwf	  EOPEN
		 movlw	  5Ah
		 movwf	  EOPEN
		        
         movfw    cmp_cnt1_bak
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
	     return     
;-------------------  
com_write_Data:
         MOVLW    20H
         MOVWF    EADRH
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
		        
         movfw    eep_data_l
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
                 

         clrc
	     movlw    01h
	     addwf    otp_writeL,1
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
		        
         movfw    eep_data_h
         
         TBLP     130
         
         movlw	  1
         call	  sub_delay_1ms
         
	     clrf	  wdtcon
	     clrwdt 
	     return	     