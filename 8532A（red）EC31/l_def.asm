


R_delay_k1      equ  	100h                ;;;延时时间系数	                      
R_delay_k2      equ  	101h


R_Send_Data     equ     102h
R_Temp2         equ     103h
R_Cnt1          equ     104h
R_Cnt0          equ     105h  

R_LED_SIGN		equ		106h
R_BAK_S			equ		107h
R_BAK_W			equ		108h

cnt1            equ     109h
cnt2            equ     10ah
cnt3            equ     10bh
full_flag       equ     10ch
zero_flag       equ     10dh
c_flag          equ     0
no_disp_c       equ     5



R_LED_COUNT		equ		110h	;110h
R_LED_TEMP		equ		111h

R_LED_D1		equ		112h
R_LED_D2		equ		113h
R_LED_D3		equ		114h
R_LED_D4		equ		115h
R_LED_D5		equ		116h
R_LED_D6		equ		117h
R_LED_D7		equ		118h	

R_LED_TEMP1		equ		119h
R_LED_TEMP2		equ		11Ah
R_LED_TEMP3		equ		11Bh
R_LED_TEMP4		equ		11Ch
R_LED_TEMP5		equ		11Dh
R_LED_TEMP6		equ		11Eh
R_LED_TEMP7		equ		11Fh


R_TEM_A			equ		120h
R_TEM_B			equ		121h

R_LED_LIGHT		equ		122h
R_LED_DUTY		equ		123h
svd_cnt         equ     124h
	
cmp_data_l		equ     130h
cmp_data_h      equ     131h
cmp_buff2kg_l   equ     132h
cmp_buff2kg_h   equ     133h
cmp_addr2kg_l   equ     134h
cmp_addr2kg_h   equ     135h
cmp_buff5kg_l   equ     136h
cmp_buff5kg_h   equ     137h
cmp_cnt         equ     138h
cmp_cnt_bak     equ     139h
cmp_cnt1        equ     13ah
cmp_cnt1_bak    equ     13bh
cmp_flag        equ     13ch
up              equ     4
down            equ     5


eep_data_l      equ     13dh
eep_data_h      equ     13eh


UserHeight      equ     140h
ViewWeiL        equ     141h
ViewWeiH        equ     142h
UserBMIL        equ     143h
UserBMIH        equ     144h
UserSET			equ		145h
Usertime		equ		146h


UserFlag		equ		147h
F_set_height	equ		0
F_set_fast		equ		1
F_TEMP			equ		2
suo             equ     3
shan            equ     4
fuzhisuo        equ     5
pan             equ     6

data_tl			equ		14dh
data_th			equ     14eh
data_count		equ     14fh

Cali_XORL_bak   equ     151h
Cali_KBL_bak    equ     152h
Cali_KBEL_bak   equ     153h
Cali_KBH_bak    equ     154h
Cali_KBEH_bak   equ     155h
Cali_EKBH_bak   equ     156h
Cali_EKBEH_bak  equ     157h
Cali_flag       equ     158h
Cali_cnt        equ     159h
w_mem_cal	    equ     15ah
w_memh_cal      equ     15bh
disp_flash_flag equ     15ch
disp_flash_cnt  equ     15dh
disp_flash_cnt1 equ     15eh
chazhi_data_l   equ     15fh
chazhi_data_h   equ     160h


NETA_BAK		equ		161h
NETC_BAK		equ		162h
NETE_BAK		equ		163h
NETF_BAK		equ		164h
Cali_temp_h		equ		165h
Cali_temp_l		equ		166h
ADCON_BAK		equ		167h
TEMPC_BAK		equ		168h
Cali_T_adh		equ		169h
Cali_T_adm		equ		16ah
Cali_T_adl		equ		16bh


data_test		equ		170h

TEMP_FRESH		equ		181h
	F_CD_TIME	equ		0

TEMP_CDT_L		equ		182h
TEMP_CDT_H		equ		183h
TEMP_DA			equ		184h
temp_h          equ     185h
temp_l          equ     186h
Cali_KBEL_UP	equ		187h
Cali_KBEH_UP    equ		188h
Cali_KBEL_DOWN	equ		189h
Cali_KBEH_DOWN  equ		18ah


R_Math_S 		equ		18bh
r_div0			equ R_Math_S 			;r_div0、r_mulre0
r_div1			equ R_Math_S+1			;r_div1、r_mulre1
r_div2			equ R_Math_S+2			;r_div2、r_mulre2
r_div3			equ R_Math_S+3			;r_div3、r_mulre3
r_div4			equ R_Math_S+4			;r_div4、r_mulre4
r_div5			equ R_Math_S+5			;r_div5、r_mulre5
div0			equ R_Math_S+6			;div0、mul0
r_divisor0		equ R_Math_S+7			;r_divisor0、r_mul2
r_divisor1		equ R_Math_S+8			;r_divisor1、r_mul3
r_divisor2		equ R_Math_S+9			;r_divisor2、r_mul4

r_mulre0		equ R_Math_S			;r_div0、r_mulre0
r_mulre1		equ R_Math_S+1			;r_div1、r_mulre1
r_mulre2		equ R_Math_S+2			;r_div2、r_mulre2
r_mulre3		equ R_Math_S+3			;r_div3、r_mulre3
r_mulre4		equ R_Math_S+4			;r_div4、r_mulre4
r_mulre5		equ R_Math_S+5			;r_div5、r_mulre5
mul0			equ R_Math_S+6			;div0、mul0

r_mul0			equ R_Math_S+7			;r_divisor0、r_mul0
r_mul1			equ R_Math_S+8			;r_divisor1、r_mul1
r_mul2			equ R_Math_S+9			;r_divisor2、r_mul2
r_mul3			equ R_Math_S+10			;
r_mul4			equ R_Math_S+11			;
r_mul5			equ R_Math_S+12			;


;LED扫描显示用到的变量
mem_time        equ     1a0h
mem_timeh		equ		1a1h

Get_zero_count	equ		1a2h

;AD滤波用到的变量
ad_sort_h0_l		equ		1a3h
ad_sort_h0_h		equ     1a4h
ad_sort_h1_l		equ		1a5h
ad_sort_h1_h		equ     1a6h
ad_sort_h2_l		equ		1a7h
ad_sort_h2_h		equ     1a8h
ad_sort_h3_l		equ		1a9h
ad_sort_h3_h		equ     1aah
ad_sort_h4_l		equ		1abh
ad_sort_h4_h		equ     1ach

ad_sort_h5_l		equ		1adh
ad_sort_h5_h		equ     1aeh
ad_sort_h6_l		equ		1afh
ad_sort_h6_h		equ     1b0h
ad_sort_h7_l		equ		1b1h
ad_sort_h7_h		equ     1b2h
ad_sort_h8_l		equ		1b3h
ad_sort_h8_h		equ     1b4h

ad_filter_en		equ		1b5h
	f_ad_fil_en		equ		0

;;;*******ram_setup*******************************
;;;===============================================
Range           equ     80h
open_weightl	equ     Range
open_weighth	equ     Range+1
R_Sub           equ     Range+2
R_Subh          equ     Range+3
Adf_Times       equ     Range+4
weight_0_times  equ		Range+5
weight_1_times	equ		Range+6
weight_2_times	equ		Range+7

buffer11        equ   	Range+8
buffer12        equ   	Range+9
buffer13        equ   	Range+10
buffer14        equ   	Range+11



momery_zerol 	equ    	Range+13
momery_zeroh 	equ   	Range+14
err_times    	equ    	Range+15 

zero_AdBuf0l     equ     8dh
zero_AdBuf0h     equ     8eh
;;;eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
adf             equ     90h
Adf_SAdd        equ     adf
Adf_OAdd        equ     adf+15

F_Adf1			equ     adf				;-z  滑动滤波专用变量
F_Adf1h			equ     adf+1
F_Adf2			equ     adf+2
F_Adf2h			equ     adf+3
F_Adf3			equ     adf+4
F_Adf3h			equ     adf+5
F_Adf4			equ     adf+6
F_Adf4h			equ     adf+7
F_Adf5			equ     adf+8 
F_Adf5h			equ     adf+9
F_Adf6			equ     adf+10
F_Adf6h			equ     adf+11
F_Adf7			equ     adf+12
F_Adf7h			equ     adf+13
F_Adf8			equ     adf+14
F_Adf8h			equ     adf+15
;;;-----------------------------------------------
AdBuf           equ     0a0h
AdBuf0l         equ     AdBuf 
AdBuf0h         equ     AdBuf+1
AdBuf0el        equ     AdBuf+2

adcbuf0l        equ     AdBuf+3			;	普通AD处理，快速AD处理，追零处理用到的变量
adcbuf0h        equ     AdBuf+4			;	普通AD处理，快速AD处理，追零处理用到的变量
adcbuf0el       equ     AdBuf+5			;	普通AD处理，快速AD处理，追零处理用到的变量
adcbuf0eh       equ     AdBuf+6			;	普通AD处理，快速AD处理，追零处理用到的变量


;;;----------------------------------------------
delay_k1        equ     AdBuf+9
temp1buf_is		equ		AdBuf+9
delay_k2        equ     AdBuf+10
temp2buf_is		equ		AdBuf+10
temp3buf_is	    equ     AdBuf+11
	   
LCDQ            EQU     AdBuf+12
LCDB            EQU     AdBuf+13
LCDS            EQU     AdBuf+14
LCDG            EQU     AdBuf+15

;;;***********VICTOR_E2ROM***********************
E2RAMAD			EQU  	0B0H
E2PCNT			EQU   	E2RAMAD         ;90H    ;;;GET SEND COUNTER
MaxWeightL		EQU		E2RAMAD
E2P_ADD			EQU   	E2RAMAD+1		;91H    ;;;ERR COUNTER	
MaxWeightH		EQU		E2RAMAD+1
DmaxL			EQU		E2RAMAD+2
GET_BUFFER0		EQU   	E2RAMAD+2		;91H    ;;;GET DATA
O_RTimes		equ   	E2RAMAD+2
DmaxH			EQU		E2RAMAD+3  
SEND_DATA		EQU   	E2RAMAD+3		;91H
O_RaddL			equ   	E2RAMAD+3
WORD_ADRESS		EQU   	E2RAMAD+4		;91H
O_RaddH			equ   	E2RAMAD+4
;;;;**********************************************
clr_raml		equ		0b0h
clr_ramh		equ		0b1h

Ad_Dsp_Delay    equ     0b4h
;;;===============================================

F_adbl            equ     0b5h
F_adbh            equ     0b6h

lcd_temp	    equ     0b7h
counter1		equ     0b7h
counter2        equ     0b8h

;;;--------------------------------------
w_mem           equ     0b9h
w_memh          equ     0bah

Redun1          equ     0bbh
sz_temp			equ		0bbh
AdPause         equ     0bch
lsd				equ		0bdh
msd				equ		0beh
adctimes        equ     0bfh
;;;===============================================
e2data_adt0     equ     0c0h
Cali_XORL       equ     e2data_adt0  
Cali_KBL        equ     e2data_adt0+1
Cali_KBEL       equ     e2data_adt0+2
Cali_KBH        equ     e2data_adt0+3
Cali_KBEH       equ     e2data_adt0+4
Cali_EKBH       equ     e2data_adt0+5
Cali_EKBEH      equ     e2data_adt0+6
cAd0_Zerol      equ     e2data_adt0+7
cAd0_Zeroh      equ     e2data_adt0+8

Otp_addsL       equ     e2data_adt0+10     	;;;首地址
Otp_addsH       equ     e2data_adt0+11
OTP_dataL       equ     e2data_adt0+12   	;;;读出数据  
OTP_dataH       equ     e2data_adt0+13
OTP_writeL      equ     e2data_adt0+14
OTP_writeH      equ     e2data_adt0+15
;;;--------------------------------------------------------
F_dl                equ   0d0h
F_dh                equ   0d1h
F_edl               equ   0d2h
F_edh               equ   0d3h
F_cl                equ   0d4h
F_ch                equ   0d5h
F_ecl               equ   0d6h
F_ech               equ   0d7h
F_bl                equ   0d8h
F_bh                equ   0d9h
F_ebl               equ   0dah
F_ebh               equ   0dbh
F_al                equ   0dch
F_ah                equ   0ddh
F_eal               equ   0deh
F_eah               equ   0dfh
;;;=====================================
MR_E2P          EQU     0D8H
MR_RLCDP        EQU     0D9H

scounter        equ     0ddh
;;;*************************************
E2WS            equ     0E0h

r_wl		    equ     E2WS
r_wh		    equ     E2WS+1   

Ad0_Zerol		equ     E2WS+2
Ad0_Zeroh		equ     E2WS+3
lr_wl			equ     E2WS+4
lr_wh			equ     E2WS+5

Radcel          equ     E2WS+6				;-sc	AD中断中的临时变量
Radcl       	equ     E2WS+7				;-sc	AD中断中的临时变量
Radceh          equ     E2WS+8				;-sc	AD中断中的临时变量
Times_l		    equ     E2WS+9
Times_h			equ		E2WS+10


Adf_old		    equ     E2WS+11				;-z		滑动滤波专用变量
Adf_oldh	    equ     E2WS+12

cal_weightL		equ		E2WS+13
cal_weightH		equ		E2WS+14

Unit_Flag		equ     E2WS+15
cal_weight		equ		0				;;;砝码进入标定
change_unit		equ		1
unit_mode		equ		2
keyflag         equ     3
Unit_Lb         equ     6
FullDisp        equ     7

;;;***************************************
pause           equ     0f0h
adc_int_times   equ     pause
adctimes1       equ     pause+1
same_w_times	equ     pause+2
weight_flag     equ     pause+3
COUNTER0        EQU     pause+4
A_BesL			equ		pause+5			;-sr	求差绝对值函数专用变量，用于输入减数低8位
A_besH			equ		Pause+6			;-sr	求差绝对值函数专用变量，用于输入减数高8位
KeyDown			equ		Pause+7
KeyUp			equ		Pause+8
KeyTimes		equ		Pause+9
WeightEnter		equ		Pause+10
filter_xs     	equ    	Pause+11
F_nflash		equ		Pause+12
;;;=========================================
SYS_FLAG1		equ		0fdh
ScanKey			equ		0
OpenTime		equ		1
closeTime		equ		2
F_WeightCAL		equ		3				;-z		没有标定时压75KG重量进入标定处理函数的标志
F_returnLock	equ		4
F_KeyDelay		equ		5
F_kaiji         equ     6
F_SADC			equ		7			
;;;==============================================
SYS_FLAG2	    equ     0feh
Calu_Flag		equ     0feh
program         equ     0
ad_cal			equ		0
KeyCom			equ		1
wt_cal	     	equ		2
bf_cal          equ     3
bf_AutoOpen     equ     4
cal_time	    equ     5
scan_zero       equ     6
R_Is_MBE		equ     7
;;;====================================================
Ad_Flag			equ     0ffh
cal_model		equ		0
AdC_Err			equ     1
weight0			equ     2
Adc_LD     		equ    	3
biaoding_err    equ     4
lock_dsp		equ		6
lock_open		equ		7

;;;=======================================================
AdBufferl		equ     173h
AdBufferm		equ     174h
AdBufferh		equ     175h
;;;----------------------------------------

dsleep_h		equ		00h
dsleep_l		equ		a0h

d10ms           equ     1
d12m8           equ     1
d25ms           equ     2
d20ms           equ     2
d40ms           equ     3
d50ms           equ     4
d100ms          equ     8

d150ms          equ     12
d166ms          equ     13
d200ms          equ     15
d250ms          equ     19
d500ms          equ     39
d1s             equ     78
d1s5            equ     117
d2s             equ     156
d3s             equ     255
;;;----------------------------------------------
i_stable_times  equ    	09h

DEFINE	L_LED1	"R_LED_TEMP1,0"
DEFINE	L_LED2	"R_LED_TEMP2,0"
DEFINE	L_LED3	"R_LED_TEMP2,5"
DEFINE	L_LED4	"R_LED_TEMP2,6"
DEFINE	L_LED5	"R_LED_TEMP2,4"
DEFINE	L_LED6	"R_LED_TEMP3,6"
DEFINE	L_LED7	"R_LED_TEMP1,3"
DEFINE	L_LED8	"R_LED_TEMP6,0"

DEFINE	L_LED9	"R_LED_TEMP2,1"
DEFINE	L_LED10	"R_LED_TEMP5,0"
DEFINE	L_LED11	"R_LED_TEMP2,7"
DEFINE	L_LED12	"R_LED_TEMP1,5"
DEFINE	L_LED13	"R_LED_TEMP5,6"
DEFINE	L_LED14	"R_LED_TEMP3,5"
DEFINE	L_LED15	"R_LED_TEMP6,7"
DEFINE	L_LED16	"R_LED_TEMP6,1"

DEFINE	L_LED17	"R_LED_TEMP1,6"
DEFINE	L_LED18	"R_LED_TEMP1,1"
DEFINE	L_LED19	"R_LED_TEMP5,5"
DEFINE	L_LED20	"R_LED_TEMP5,1"
DEFINE	L_LED21	"R_LED_TEMP4,7"
DEFINE	L_LED22	"R_LED_TEMP4,5"
DEFINE	L_LED23	"R_LED_TEMP3,0"
DEFINE	L_LED24	"R_LED_TEMP6,2"

DEFINE	L_LED25	"R_LED_TEMP2,2"
DEFINE	L_LED26	"R_LED_TEMP3,7"
DEFINE	L_LED27	"R_LED_TEMP5,7"
DEFINE	L_LED28	"R_LED_TEMP5,4"
DEFINE	L_LED29	"R_LED_TEMP5,2"
DEFINE	L_LED30	"R_LED_TEMP1,7"
DEFINE	L_LED31	"R_LED_TEMP1,4"
DEFINE	L_LED32	"R_LED_TEMP6,3"

DEFINE	L_LED33	"R_LED_TEMP4,6"
DEFINE	L_LED34	"R_LED_TEMP3,1"
DEFINE	L_LED35	"R_LED_TEMP4,1"
DEFINE	L_LED36	"R_LED_TEMP5,3"
DEFINE	L_LED37	"R_LED_TEMP4,4"
DEFINE	L_LED38	"R_LED_TEMP4,2"
DEFINE	L_LED39	"R_LED_TEMP3,3"
DEFINE	L_LED40	"R_LED_TEMP6,4"

DEFINE	L_LED41	"R_LED_TEMP2,3"
DEFINE	L_LED42	"R_LED_TEMP7,7"
DEFINE	L_LED43	"R_LED_TEMP4,0"
DEFINE	L_LED44	"R_LED_TEMP1,2"
DEFINE	L_LED45	"R_LED_TEMP4,3"
DEFINE	L_LED46	"R_LED_TEMP3,4"
DEFINE	L_LED47	"R_LED_TEMP3,2"
DEFINE	L_LED48	"R_LED_TEMP6,5"

DEFINE	L_LED49	"R_LED_TEMP7,0"
DEFINE	L_LED50	"R_LED_TEMP7,1"
DEFINE	L_LED51	"R_LED_TEMP7,2"
DEFINE	L_LED52	"R_LED_TEMP7,3"
DEFINE	L_LED53	"R_LED_TEMP7,4"
DEFINE	L_LED54	"R_LED_TEMP7,5"
DEFINE	L_LED55	"R_LED_TEMP7,6"
DEFINE	L_LED56	"R_LED_TEMP6,6"


;-------------------------------
; LED Character table 
;  __		A		点  4	: 5-6
; |  | 	  F	  B 	kg  3
;  __		G		斤  2
; |  |    E   C		BLE 1
;  __  		D		BAT 0   
;-------------------------------
; LED1  LED2  LED3  LED4

DEFINE	LED1_1U		"L_LED43"
DEFINE	LED1_1D		"L_LED44"
DEFINE	LED1_UU		"L_LED41"
DEFINE	LED1_DD		"L_LED42"
DEFINE	LED1_MM		"L_LED56"
DEFINE	LED1_CM		"L_LED49"
DEFINE	LED1_G		"L_LED8"

DEFINE	LED2_A		"L_LED1"
DEFINE	LED2_B		"L_LED2"
DEFINE	LED2_C		"L_LED3"
DEFINE	LED2_D		"L_LED4"
DEFINE	LED2_E		"L_LED5"
DEFINE	LED2_F		"L_LED6"
DEFINE	LED2_G		"L_LED7"

DEFINE	LED3_A		"L_LED9"
DEFINE	LED3_B		"L_LED10"
DEFINE	LED3_C		"L_LED11"
DEFINE	LED3_D		"L_LED12"
DEFINE	LED3_E		"L_LED13"
DEFINE	LED3_F		"L_LED14"
DEFINE	LED3_G		"L_LED15"

DEFINE	LED4_A		"L_LED17"
DEFINE	LED4_B		"L_LED18"
DEFINE	LED4_C		"L_LED19"
DEFINE	LED4_D		"L_LED20"
DEFINE	LED4_E		"L_LED21"
DEFINE	LED4_F		"L_LED22"
DEFINE	LED4_G		"L_LED23"

DEFINE	LED5_A		"L_LED25"
DEFINE	LED5_B		"L_LED26"
DEFINE	LED5_C		"L_LED27"
DEFINE	LED5_D		"L_LED28"
DEFINE	LED5_E		"L_LED29"
DEFINE	LED5_F		"L_LED30"
DEFINE	LED5_G		"L_LED31"

DEFINE	LED6_A		"L_LED33"
DEFINE	LED6_B		"L_LED34"
DEFINE	LED6_C		"L_LED35"
DEFINE	LED6_D		"L_LED36"
DEFINE	LED6_E		"L_LED37"
DEFINE	LED6_F		"L_LED38"
DEFINE	LED6_G		"L_LED39"

DEFINE	LED7_KG		"L_LED46"
DEFINE	LED7_DOT 	"L_LED45"
DEFINE	LED7_BMI 	"L_LED47"
DEFINE	LED7_C		"L_LED50"
DEFINE	LED7_S		"L_LED51"
DEFINE	LED7_N		"L_LED52"
DEFINE	LED7_F		"L_LED53"
DEFINE	LED7_FAT	"L_LED54"





IFDEF	COMP_LCD
;-------------------------------
; LCD Character table 
;  __		0
; |  | 	  5	  1 
;  __		6
; |  |    4   2
;  __  .	3	7
;-------------------------------
Lcdch0    		equ   00111111b  
Lcdch1    		equ   00000110b        
Lcdch2    		equ   01011011b        
Lcdch3    		equ   01001111b       
Lcdch4    		equ   01100110b        
Lcdch5    		equ   01101101b        
Lcdch6   		equ   01111101b        
Lcdch7    		equ   00000111b       
Lcdch8    		equ   01111111b        
Lcdch9    		equ   01101111b        
LcdchA    		equ   01110111b        
Lcdchb    		equ   01111100b        
LcdchC    		equ   00111001b        
Lcdchd    		equ   01011110b        
LcdchE    		equ   01111001b        
LcdchF    		equ   01110001b        

                             
LcdchL    		equ   00111000b        
Lcdcho    		equ   01011100b             
LcdchP    		equ   01110011b             
Lcdchn    		equ   01010100b  
;-------------------------------
; LCD Character table 
;  __		0
; |  | 	  4	  1 
;  __		5
; |  |    6   2
;  __  		7
;-------------------------------
;Lcdch0    		equ   11010111b  
;Lcdch1    		equ   00000110b        
;Lcdch2    		equ   11100011b        
;Lcdch3    		equ   10100111b       
;Lcdch4    		equ   00110110b        
;Lcdch5    		equ   10110101b        
;Lcdch6   		equ   11110101b        
;Lcdch7    		equ   00000111b       
;Lcdch8    		equ   11110111b        
;Lcdch9    		equ   10110111b        
;LcdchA    		equ   01110111b        
;Lcdchb    		equ   11110100b        
;LcdchC    		equ   11010001b        
;Lcdchd    		equ   11100110b        
;LcdchE    		equ   11110001b        
;LcdchF    		equ   01110001b        
                             
;LcdchL    		equ   11010000b        
;Lcdcho    		equ   11100100b             
;LcdchP    		equ   01110011b             
;Lcdchn    		equ   01100100b  
 
;;;--------------------------
nlcd_9add       equ     48h
nlcd_8add       equ     47h
nlcd_7add       equ     46h
nlcd_6add       equ     45h
nlcd_5add       equ     44h
nlcd_4add       equ     43h
nlcd_3add       equ     42h
nlcd_2add       equ     41h
nlcd_1add       equ     40h

ELSE

;-------------------------------
; LED Character table 
;  __		0		点  4	
; |  | 	  5	  1 	kg  3
;  __		6		斤  2
; |  |    4   2		BLE 1
;  __  		3		BAT 0
;-------------------------------
Lcdch0    		equ   00111111b  
Lcdch1    		equ   00000110b        
Lcdch2    		equ   01011011b        
Lcdch3    		equ   01001111b       
Lcdch4    		equ   01100110b        
Lcdch5    		equ   01101101b        
Lcdch6   		equ   01111101b        
Lcdch7    		equ   00000111b       
Lcdch8    		equ   01111111b        
Lcdch9    		equ   01101111b        
LcdchA    		equ   01110111b        
Lcdchb    		equ   01111100b        
LcdchC    		equ   00111001b        
Lcdchd    		equ   01011110b        
LcdchE    		equ   01111001b        
LcdchF    		equ   01110001b        
                             
LcdchL    		equ   00111000b        
Lcdcho    		equ   01011100b             
LcdchP    		equ   01110011b             
Lcdchn    		equ   01010100b  
Lcdchr          equ   01010000b
;-------------------------------
; LED Character table 
;  __		6		点  1	
; |  | 	  7	  5 	kg  2
;  __		4		斤  3
; |  |    1   3		BLE 4
;  __  		2		BAT 5
;-------------------------------
;Lcdch0    		equ   11101110b  
;Lcdch1    		equ   00101000b        
;Lcdch2    		equ   01110110b        
;Lcdch3    		equ   01111100b       
;Lcdch4    		equ   10111000b        
;Lcdch5    		equ   11011100b        
;Lcdch6   		equ   11011110b        
;Lcdch7    		equ   01101000b       
;Lcdch8    		equ   11111110b        
;Lcdch9    		equ   11111100b        
;LcdchA    		equ   11111010b        
;Lcdchb    		equ   10011110b        
;LcdchC    		equ   11000110b        
;Lcdchd    		equ   00111110b        
;LcdchE    		equ   11010110b        
;LcdchF    		equ   11010010b        
                             
;LcdchL    		equ   10000110b        
;Lcdcho    		equ   00011110b             
;LcdchP    		equ   11110010b             
;Lcdchn    		equ   00011010b  

ENDIF
  
