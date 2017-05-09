;;;****************************************************
mw_clrf_ram:
/*       bcf      bsr,7
       movlf   128,00h
	   movlf   01h,fsr0	   	  	   
mw_clrf_loop0:
	   movlf   00h,ind0
	   incf    fsr0,1
	   clrc
	   decfsz   00h,1
	   goto     mw_clrf_loop0*/
	   
       bcf      bsr,7
	   movlf   128,80h
	   movlf   81h,fsr0	   	  	   
mw_clrf_loop:
	  movlf   00h,ind0
	  incf    fsr0,1
	  clrc
	  decfsz   80h,1
	  goto     mw_clrf_loop
	  bsf      bsr,7
	  movlf   256,100h
	   movlf   101h,fsr0	   	  	   
mw_clrf_loop3:
	  movlf   00h,ind0
	  incf    fsr0,1
	  clrc
	  decfsz   100h,1
	  goto     mw_clrf_loop3
	  bcf      bsr,7
	  return
;;;*****************************************************
       
;;;================================================
sub_initialize_time:
	   clrf		weight_0_times
	   movlf	dsleep_l,weight_1_times
	   movlf	dsleep_h,weight_2_times
	   return		
;;;------------------------------------------------
sub_weight_initialize:
;        clrf	tmcon
;		bcf		inte,tmie
		movlf   19h,filter_xs
		bsf			SYS_FLAG1,ScanKey
	   clrf    same_w_times
	   clrf    weight_0_times	   
	   clrf    r_wh
	   clrf    r_wl
	   clrf    lr_wh
	   clrf    lr_wl
	   clrf    err_times
	   movff	Cali_KBL,cal_weightL
	   movff	Cali_KBEL,cal_weightH
	   bcf		status,c
	   rrf		cal_weightH,1
	   rrf		cal_weightL,1
	   movfw	Cali_KBL
	   addwf	cal_weightL,1
	   movfw	Cali_KBEL
	   addwfc	cal_weightH,1	   
	   return