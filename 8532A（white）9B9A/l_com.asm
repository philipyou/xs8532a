
;------ 编译代码选项 ------
; 
;--- 选择哪种显示驱动方式
;COMP_LCD		EQU 1
COMP_LED		EQU 1

;--- 选择LB为单位
;DUNIT_LB		EQU 1


;------IO资源使用情况-------
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

;按键
hard_key		EQU PT1
open     		EQU 4	  ;开机
UINT		    EQU 0	  ;单位
lb				EQU 1	  ;单位拨动开关		

;标定引脚
P_CAL			EQU PT1
cal				EQU 3

;超重容量选择引脚
P_CAP			EQU PT1
caption			EQU 5

;背光控制
P_LED			EQU PT1
B_LED0			EQU 4

;24C02的I/O口设置
E2SCL			EQU	3		;E2PROM的SCL引脚
E2SDA			EQU	2		;E2PROM的SDA引脚
P_E2SDA			EQU	PT2		;E2PROM的SDA使用的端口号
P_E2SCL			EQU	PT2		;E2PROM的SCL使用的端口号
P_E2PtEN		EQU	PT2EN
P_E2PtPU		EQU	PT2PU








