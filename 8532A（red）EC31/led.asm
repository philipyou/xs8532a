LED_DISPLAY:
    movlf 00H,PT2
    btfss LED1,0
    goto led_next1_1
    movlw FCH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
led_next1_1 :
	movlf 00H,PT2  
    btfss LED1,1
    goto led_next1_2
    movlw F5H
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
   
 
led_next1_2 : 
	movlf 00H,PT2 
    btfss LED1,2
    goto led_next1_3 
    movlw B7H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
led_next1_3 : 
    movlf 00H,PT2 
    btfss LED1,3
    goto led_next1_4
    movlw BEH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
    
 led_next1_4 : 
    movlf 00H,PT2 
    btfss LED1,4
    goto led_next1_5
    movlw B7H
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
 led_next1_5 : 
 	movlf 00H,PT2 
    btfss LED1,5
    goto led_next1_6
    movlw F5H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
    
led_next1_6 :
    movlf 00H,PT2  
    btfss LED1,6
    goto led_next1_7
    movlw F6H
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
led_next1_7 :
    movlf 00H,PT2  
    btfss LED1,7
    goto led_next2_0
    movlw D7H
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2    
 
led_next2_0 :   
    movlf 00H,PT2
    btfss LED2,0
    goto led_next2_1
    movlw FCH
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
    
led_next2_1 :
    movlf 00H,PT2  
    btfss LED2,1
    goto led_next2_2
    movlw FAH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
   
 
led_next2_2 : 
    movlf 00H,PT2 
    btfss LED2,2
    goto led_next2_3
    movlw EEH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
led_next2_3 : 
    movlf 00H,PT2 
    btfss LED2,3
    goto led_next2_4
    movlw BEH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
    
 led_next2_4 :  
    movlf 00H,PT2
    btfss LED2,4
    goto led_next2_5
    movlw EEH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
 led_next2_5 : 
    movlf 00H,PT2 
    btfss LED2,5
    goto led_next2_6
    movlw FAH
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2
    
    
led_next2_6 : 
    movlf 00H,PT2 
    btfss LED2,6
    goto led_next2_7
    movlw F6H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
led_next2_7 : 
    movlf 00H,PT2 
    btfss LED2,7
    goto led_next3_0
    movlw F9H
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2 
 
led_next3_0 :   
    movlf 00H,PT2
    btfss LED3,0
    goto led_next3_1
    movlw BBH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
led_next3_1 : 
    movlf 00H,PT2 
    btfss LED3,1
    goto led_next3_2
    movlw DDH
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
   
 
led_next3_2 : 
	movlf 00H,PT2 
    btfss LED3,2
    goto led_next3_3
    movlw 9FH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
led_next3_3 :  
    movlf 00H,PT2
    btfss LED3,3
    goto led_next3_4
    movlw AFH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
led_next3_4 : 
    movlf 00H,PT2
    btfss LED3,4
    goto led_next3_5
    movlw 9FH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2
    
led_next3_5 : 
    movlf 00H,PT2 
    btfss LED3,5
    goto led_next3_6
    movlw DDH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2    
    
led_next3_6 :  
    movlf 00H,PT2
    btfss LED3,6
    goto led_next3_7
    movlw DEH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2
    
led_next3_7 : 
    movlf 00H,PT2 
    btfss LED3,7
    goto led_next4_0
    movlw EDH
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2 
    
    
    
led_next4_0 :   
    movlf 00H,PT2
    btfss LED4,0
    goto led_next4_1
    movlw BBH
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2
    
led_next4_1 :
    movlf 00H,PT2 
    btfss LED4,1
    goto led_next4_2
    movlw DBH
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2  
 
led_next4_2 :  
    movlf 00H,PT2
    btfss LED4,2
    goto led_next4_3
    movlw CFH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2
    
led_next4_3 : 
    movlf 00H,PT2 
    btfss LED4,3
    goto led_next4_4
    movlw AFH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
led_next4_4 :
    movlf 00H,PT2  
    btfss LED4,4
    goto led_next4_5
    movlw CFH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
led_next4_5 :
    movlf 00H,PT2  
    btfss LED4,5
    goto led_next4_6
    movlw DBH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2
    
    
led_next4_6 :
    movlf 00H,PT2  
    btfss LED4,6
    goto led_next4_7
    movlw DEH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
led_next4_7 :  
    movlf 00H,PT2
    btfss LED4,7
    goto led_next5_0
    movlw EBH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2 
    
    
    
led_next5_0 : 
    movlf 00H,PT2  
    btfss LED5,0
    goto led_next5_1
    movlw F9H
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
    
led_next5_1 :  
    movlf 00H,PT2
    btfss LED5,1
    goto led_next5_2
    movlw F3H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
   
 
led_next5_2 : 
    movlf 00H,PT2 
    btfss LED5,2
    goto led_next5_3
    movlw E7H
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
led_next5_3 :
    movlf 00H,PT2  
    btfss LED5,3
    goto led_next5_4
    movlw D7H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
led_next5_4 : 
    movlf 00H,PT2 
    btfss LED5,4
    goto led_next5_5
    movlw E7H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
led_next5_5 : 
    movlf 00H,PT2 
    btfss LED5,5
    goto led_next5_6
    movlw F3H
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2
    
    
led_next5_6 : 
    movlf 00H,PT2 
    btfss LED5,6
    goto led_next5_7
    movlw EDH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
led_next5_7 : 
    movlf 00H,PT2 
    btfss LED5,7
    goto led_next6_0
    movlw EBH
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2 
    
led_next6_0 : 
    movlf 00H,PT2  
    btfss LED6,0
    goto led_next6_1
    movlw 7EH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
    
led_next6_1 : 
    movlf 00H,PT2 
    btfss LED6,1
    goto led_next6_2
    movlw 7DH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
   
 
led_next6_2 : 
    movlf 00H,PT2 
    btfss LED6,2
    goto led_next6_3
    movlw 7BH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
    
led_next6_3 : 
    movlf 00H,PT2 
    btfss LED6,3
    goto led_next6_4
    movlw 77H
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
  

  
led_next6_4 :
    movlf 00H,PT2  
    btfss LED6,4
    goto led_next6_5
    movlw 6FH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
    
led_next6_5 :  
    movlf 00H,PT2
    btfss LED6,5
    goto led_next6_6
    movlw 5FH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
    
    
led_next6_6 : 
    movlf 00H,PT2 
    btfss LED6,6
    goto led_next6_7
    movlw 3FH
    movwf PT2CON
    movwf 7FH
    movlf 7FH,PT2
    
led_next6_7 : 
    movlf 00H,PT2 
    btfss LED6,7
    goto led_next7_0
    movlw BDH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2 
    
    
led_next7_0 :   
    movlf 00H,PT2
    btfss LED7,0
    goto led_next7_1
    movlw 7EH
    movwf PT2CON
    movwf 7FH
    movlf FEH,PT2
    
led_next7_1 : 
    movlf 00H,PT2 
    btfss LED7,1
    goto led_next7_2
    movlw 7DH
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
   
 
led_next7_2 : 
    movlf 00H,PT2 
    btfss LED7,2
    goto led_next7_3
    movlw 7BH
    movwf PT2CON
    movwf 7FH
    movlf FBH,PT2
    
led_next7_3 :
    movlf 00H,PT2  
    btfss LED7,3
    goto led_next7_4
    movlw 77H
    movwf PT2CON
    movwf 7FH
    movlf F7H,PT2
    
led_next7_4 : 
    movlf 00H,PT2 
    btfss LED7,4
    goto led_next7_5
    movlw 6FH
    movwf PT2CON
    movwf 7FH
    movlf EFH,PT2
    
led_next7_5 : 
    movlf 00H,PT2 
    btfss LED7,5
    goto led_next7_6
    movlw 5FH
    movwf PT2CON
    movwf 7FH
    movlf DFH,PT2
    
    
led_next7_6 :
    movlf 00H,PT2  
    btfss LED7,6
    goto led_next7_7
    movlw 3FH
    movwf PT2CON
    movwf 7FH
    movlf BFH,PT2
    
led_next7_7 : 
    movlf 00H,PT2 
    btfss LED7,7
    goto led_end
    movlw BDH
    movwf PT2CON
    movwf 7FH
    movlf FDH,PT2
led_end:
	nop
	nop
	nop
	nop
	nop
	
	movlf 00H,PT2
    movlw FFH
    movwf PT2CON
    movwf 7FH
    return