
sub_height_set:
	btfss		UserFlag,F_set_height
	goto		sub_height_set_exit
	
		
	
;	decfsz		UserSET,f
;	goto		sub_height_set_exit
;	bcf			UserFlag,F_set_height

sub_height_set_exit:	
	return
	
	
	
	