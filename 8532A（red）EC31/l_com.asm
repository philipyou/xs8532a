
;------ �������ѡ�� ------
; 
;--- ѡ��������ʾ������ʽ
;COMP_LCD		EQU 1
COMP_LED		EQU 1

;--- ѡ��LBΪ��λ
;DUNIT_LB		EQU 1


;------IO��Դʹ�����-------
; PT20  --OPEN
; PT21  --UINT
; PT22  --E_SDA
; PT23  --E_SCL
; PT24  --LED
; PT25  --LB
; PT26  --CAP
; PT27	--CAL
;
; PT14
; PT15
; PT16
; PT17
;----------------------------

;����
hard_key		EQU PT1
open     		EQU 4	  ;����
UINT		    EQU 0	  ;��λ
lb				EQU 1	  ;��λ��������		

;�궨����
P_CAL			EQU PT1
cal				EQU 3

;��������ѡ������
P_CAP			EQU PT1
caption			EQU 5

;�������
P_LED			EQU PT1
B_LED0			EQU 4

;24C02��I/O������
E2SCL			EQU	3		;E2PROM��SCL����
E2SDA			EQU	2		;E2PROM��SDA����
P_E2SDA			EQU	PT2		;E2PROM��SDAʹ�õĶ˿ں�
P_E2SCL			EQU	PT2		;E2PROM��SCLʹ�õĶ˿ں�
P_E2PtEN		EQU	PT2EN
P_E2PtPU		EQU	PT2PU








