;============================================
; CSU8RP10188 Special Register Address Definition
; Author jack lee 
; Data:2015.7.13
;============================================
; Data Memory Organization 00h-07h                                                   上电复位值    
                                                                                            
IND0         EQU     000H     ; Uses contents of FSR0 to address data memory           xxxxxxxx                
IND1         EQU     001H     ; Uses contents of FSR1 to address data memory           xxxxxxxx                
FSR0         EQU     002H     ; Indirect data memory, address point 0                  00000000                
FSR1         EQU     003H     ; Indirect data memory, address point 1                  00000000                
STATUS       EQU     004H     ; { 0 , 0 , 0, PD, TO, DC, C, Z}                         uuu00xxx                
WORK         EQU     005H     ; Work register                                          00000000                
INTF         EQU     006H     ; { 0, 0,  0, TMIF, 0, ADIF, E1IF, E0IF}                 uuu0u000                
INTE         EQU     007H     ; {GIE, 0, 0, TMIE, 0, ADIE, E1IE, E0IE}                 0uu0u000  
BSR          EQU     008H     ; {IRP0,IRP1,0,0,0,0,0,0,}                        00uuuuuu 
               
EADRH        EQU     00AH     ; {0,0,0,PARH[4:0]}                                      uuu00000
EADRL        EQU     00BH     ; {PARL[7:0]}                                            00000000                
EDAT         EQU     00CH     ;  EDAT[7:0]                                             11111111                
;WDTCON       EQU     00DH     ;  {WTDEN, 0, 0,  Wdt_lcd, WTS[3:0]}                     0uu00000                
;TMOUT        EQU     00EH     ;  TMOUT[7:0]                                            00000000                 
;TMCON        EQU     00FH     ;  {TRST, 0, 0, 0, TMEN, INS[2:0]}                       1uuu0000                
ADOH         EQU     010H     ;  ADO[23:16]                                            00000000                
ADOL         EQU     011H     ;  AD0[15:8]                                             00000000                
ADOLL        EQU     012H     ;  AD0[7:0]                                              00000000                
ADCON        EQU     013H     ; {ADFS_SEL,     CBFS_SEL,0,     COMBS,0,ADM[2:0]}       00u0u000                
MCK          EQU     014H     ; {0 ,0, 0, 0, 0, M2_CK, M1_CK,0}                        uuuuu00u                
PCK          EQU     015H     ; {0,LCDSCKS[3:0],S_beep[1:0],0}                         u000000u                
;MCK2         EQU     016H     ; {TMSEL[1:0],XTALSEL,CST_E,CST_IN,EO_SLP,M3_CK,CLK_SEL} 00110000                
NETA         EQU     018H     ; {SINL[2:0], CM_SEL, 0,0,0,0}                           0000uuuu                
;NETB         EQU     019H     ; {0, 0, 0, 0, ERV, 0, 0, 0,}                            uuuuxuuu                
NETC         EQU     01AH     ; {CHOPM[1:0],0,      ADG_M,  0,      ADG,         ADEN,      0}         00u0u00u                
;NETD         EQU     01BH     ; {0, 0, 0,0, VLCDX[1:0],    LCDREF[1:0]}                uuuu0000                
NETE         EQU     01CH     ; {LDOS[1:0], 0,SILB[2:0], ENLB,0}                       00u0000u                
NETF         EQU     01DH     ; {CHP_VPP,LVR_EN,ENVDDA,0,0,BGID[1:0],ENVB              000uu000
SVD          EQU     01FH     ; {0,0,0,0,0,0,LBOUT}                                    uuuuuuux                
PT1          EQU     020H     ; {PT1[7:4]}                                             xxxxuuuu                
PT1EN        EQU     021H     ; {PT1EN[7:4]}                                           0000uuuu                
PT1PU        EQU     022H     ; {PT1PU[7:4]}                                           0000uuuu                
AIENB        EQU     023H     ; {0, 0, 0, 0,AIENB1,0, 0, 0}                            uuuu0uuu                
PT2          EQU     024H     ; {PT2[7:0]}                                             xxxxxxxx                
PT2EN        EQU     025H     ; {PT2EN[7:0]}                                           00000000                
PT2PU        EQU     026H     ; {PT2PU[7:0]}                                           00000000                
;PT2MR        EQU     027H     ; {BZEN, 0, 0, E1M[1:0], E0M[1:0]}                       0uuu0000                
PT2CON       EQU     028H     ; {SEGCON1,SEGCON0,0,0,BZSEL,0,0,0}                      00uu0uuu                
PTINT        EQU     029H     ; {0,PTW1[2:0],0,0,PTW0[1:0]}                            u100uu10                
INTF2        EQU     032H     ; {0,0,0,0,0, TKIF          URTIF       URRIF }          uuuuu000                
INTE2        EQU     033H     ; {0,0,0,0,0, TKIE         URTIE       URRIE }           uuuuu000                
LCD1         EQU     040H     ; SEG1[3:0]                                              uuuu0000                
LCD2         EQU     041H     ; SEG2[3:0]                                              uuuu0000                
LCD3         EQU     042H     ; SEG3[3:0]                                              uuuu0000                
LCD4         EQU     043H     ; SEG4[3:0]                                              uuuu0000                
LCD5         EQU     044H     ; SEG5[3:0]                                              uuuu0000                
LCD6         EQU     045H     ; SEG6[3:0]                                              uuuu0000                
LCD7         EQU     046H     ; SEG7[3:0]                                              uuuu0000                
LCD8         EQU     047H     ; SEG8[3:0]                                              uuuu0000                
LCD9         EQU     048H     ; SEG9[3:0]                                              uuuu0000                
LCD10        EQU     049H     ; SEG10[3:0]                                             uuuu0000                
LCD11        EQU     04AH     ; SEG11[3:0]                                             uuuu0000                
LCD12        EQU     04BH     ; SEG12[3:0]                                             uuuu0000                
LCD13        EQU     04CH     ; SEG13[3:0]                                             uuuu0000                
LCD14        EQU     04DH     ; SEG14[3:0]                                             uuuu0000                
LEDCN        EQU     056H     ; {0,0,0,0,0,0,cont_sel,LEDEN}                           uuuuuu00                
LCDCN1       EQU     057H     ; {0,0,0,0,CSE_LCD,0,0,0 }                               uuuu0uuu                
LCDENR       EQU     058H     ; {LCDCKS[1:0],LCDEN,LCDWS,LEVEL,LCD_DUTY[1:0],ENPMPL}   00000110                
METCH        EQU     059H     ; METCH [7:0]                                            00000000                
TKCTL0       EQU     05BH     ; { TK_EN,   0,0,TK_TBSEL,0,       TK_CLR,   TK_SEL[1:0] }      0uu0u000                                     
TKCTL1       EQU     05CH     ; {  0, 0, 0, TMBCK[2:0],TKCLK_SEL[1:0]   }             uuu00000                                       
TKIO         EQU     05DH     ; { 0, 0, 0,0,   TK3IO,        TK2IO,      TK1IO,      TK0IO  }       uuuu0000                                     
TKIOS        EQU     05EH     ; { 0, 0, 0,0,   TK3S,  TK2S,        TK1S,        TK0S   }       uuuu0000                                     
TKRC_C       EQU     05FH     ;  TKRC_C[7:0]                                           10000000                                                       
WDT_C        EQU     060H     ;  WDT_C[7:0]                                            10000000                
IOSC_C       EQU     061H     ;  IOSC_C[7:0]                                           10000000                
TMBIN1L      EQU     062H     ;  TMBIN1[7:0]                                           00000000                
TMBIN1H      EQU     063H     ;  TMBIN1[15:8]                                          00000000                
TMBIN2L      EQU     064H     ;  TMBIN2[7:0]                                           00000000                
TMBIN2H      EQU     065H     ;  TMBIN2[15:8]                                          00000000                
TMBIN2HH     EQU     066H     ;  TMBIN2[23:16]                                         00000000                
TMACNTL      EQU     067H     ;  TMA_CNT[7:0]                                          00000000                
TMACNTH      EQU     068H     ;  TMA_CNT[15:8]                                         00000000                
TEST         EQU     070H     ;  TEST[7:0]                                             00000000                
TK0_THREL    EQU     071H     ;  TK0_THRE[7:0]                                         00000000                
TK0_THREH    EQU     072H     ;  TK0_THRE[15:8]                                        00000000                
TK1_THREL    EQU     073H     ;  TK1_THRE[7:0]                                         00000000                
TK1_THREH    EQU     074H     ;  TK1_THRE[15:8]                                        00000000                
TK2_THREL    EQU     075H     ;  TK2_THRE[7:0]                                         00000000                
TK2_THREH    EQU     076H     ;  TK2_THRE[15:8]                                        00000000                
TK3_THREL    EQU     077H     ;  TK3_THRE[7:0]                                         00000000                
TK3_THREH    EQU     078H     ;  TK3_THRE[15:8]                                        00000000                
SCON1        EQU     07AH     ;  { SM0,SM1,SM2,REN,TB8,RB8,UART_SEL,UARTEN }           00000000                
SCON2        EQU     07BH     ;  { SMOD,0,0,,0,0,0,0,0 }                               0uuuuuuu                
SBUF         EQU     07CH     ;   SBUF[7:0]                                            00000000                
METCH2       EQU     07EH     ;   METCH2[7:0]                                          00001000   


;-------------------------------------------
; Status register bit map
;-------------------------------------------
Z       EQU     0
C       EQU     1
DC      EQU     2
TO      EQU     3
PD      EQU     4
;-------------------------------------------
; Interrupt flag register bit map
;-------------------------------------------
E0IF    EQU     0
E1IF    EQU     1
ADIF    EQU     2
TMIF    EQU     4
;-------------------------------------------
; Interrupt enable register bit map
;-------------------------------------------
E0IE    EQU     0
E1IE    EQU     1
ADIE    EQU     2
TMIE    EQU     4
GIE     EQU     7
;-------------------------------------------
; BSR register bit map
;-------------------------------------------
IRP1    EQU     6
IRP0    EQU     7
;-------------------------------------------
; WDTCON register bit map
;-------------------------------------------
WDTS0   EQU     0
WDTS1   EQU     1
WDTS2   EQU     2
WDTS3   EQU     3
Wdt_lcd EQU     4
WDTEN   EQU     7
;-------------------------------------------
; TMCON register bit map
;-------------------------------------------
INS0    EQU     0
INS1    EQU     1
INS2    EQU     2
TMEN    EQU     3
TRST    EQU     7
;-------------------------------------------
; ADCON register bit map
;-------------------------------------------
ADM0    EQU     0
ADM1    EQU     1
ADM2    EQU     2
ADSC    EQU     3
;-------------------------------------------
; MCK register bit map
;-------------------------------------------
M1_CK   EQU     1
M2_CK   EQU     2
;-------------------------------------------
; PCK register bit map
;-------------------------------------------
S_BEEP0  EQU    1
S_BEEP1  EQU    2
LCDSCKS0 EQU    3
LCDSCKS1 EQU    4
LCDSCKS2 EQU    5
LCDSCKS3 EQU    6
;-------------------------------------------
; NETA register bit map
;-------------------------------------------
CHPCKS0  EQU    0
CHPCKS1  EQU    1
CHPCKS2  EQU    2
CM_SEL   EQU    4
ACM      EQU    5
SINL0    EQU    6
SINL1    EQU    7
;-------------------------------------------
; NETB register bit map
;-------------------------------------------
ERV     EQU     3
;-------------------------------------------
; NETC register bit map
;-------------------------------------------
ADEN    EQU     1
ADG0    EQU     2
ADG1    EQU     3
ADG_M0  EQU     4
ADG_M1  EQU     5
CHOPM0  EQU     6
CHOPM1  EQU     7
;-------------------------------------------
; NETD register bit map
;-------------------------------------------
LCDREF0 EQU     0
LCDREF1 EQU     1
VLCDX0  EQU     2
VLCDX1  EQU     3
Level_s EQU     4
LCDCH   EQU     5
;-------------------------------------------
; NETE register bit map
;-------------------------------------------
ENLB    EQU     1
SILB0   EQU     2
SILB1   EQU     3
SILB2   EQU     4
LDOS0   EQU     6
LDOS1   EQU     7
;-------------------------------------------
; NETF register bit map
;-------------------------------------------
ENVB    EQU     0
BGID0   EQU     1
BGID1   EQU     2
BGID2   EQU     3
BGID3   EQU     4
ENVDDA  EQU     5
LVR_EN  EQU     6
CHP_VPP EQU     7
;-------------------------------------------
; SVD register bit map
;-------------------------------------------
LBOUT   EQU     0
;-------------------------------------------
; AIENB register bit map
;-------------------------------------------
AIENB1  EQU     3
;-------------------------------------------
; PT2MR register bit map
;-------------------------------------------
E0M0    EQU     0
E0M1    EQU     1
E1M0    EQU     2
E1M1    EQU     3
BZEN    EQU     7
;-------------------------------------------
; PT2CON register bit map
;-------------------------------------------
BZSEL	  EQU     3
SEGCON0    EQU     6
SEGCON1    EQU     7
;-------------------------------------------
; PTINT register bit map
;-------------------------------------------
PTW0_0    EQU     0
PTW0_1    EQU     1
PTW1_0    EQU     4
PTW1_1    EQU     5
PTW1_2    EQU     6
;-------------------------------------------
; INTF2 register bit map
;-------------------------------------------
URRIF	  EQU     0
URTIF	  EQU     1
TKIF	  EQU	  2
;-------------------------------------------
; INTE2 register bit map
;-------------------------------------------
URRIE	  EQU     0
URTIE	  EQU     1
TKIE	  EQU     2
;-------------------------------------------
; LCDCN1 register bit map
;-------------------------------------------
	 CSE_LCD  EQU     3
;-------------------------------------------
; LCDENR register bit map
;-------------------------------------------
ENPMPL   EQU    0
LCD_DUTY0    EQU    1
LCD_DUTY1    EQU    2
LEVEL    EQU    3
LCDWS    EQU    4
LCDEN    EQU    5
LCDCKS0  EQU    6
LCDCKS1  EQU    7

;-------------------------------------------
; TKCTL0 register bit map
;-------------------------------------------
TKEN	 EQU    7
;-------------------------------------------
; WDT_C register bit map
;-------------------------------------------
WDT_C1	  EQU     0
WDT_C2	  EQU     1
WDT_C3	  EQU     2
;-------------------------------------------
; SCON1 register bit map
;-------------------------------------------
UARTEN	  EQU     0
UART_SEL	  EQU     1
RB8		  EQU     2
TB8		  EQU     3
REN		  EQU     4
SM2		  EQU     5
SM1		  EQU     6
SM0		  EQU     6
;-------------------------------------------
; SCON2 register bit map
;-------------------------------------------
  SMOD	  EQU     7
;==========================================
W        EQU    0
F        EQU    1