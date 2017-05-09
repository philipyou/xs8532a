;------------------------------------------------------------------
;				连续写N个数据(2)
;------------------------------------------------------------------
;FSR0   :保存将要写入的E2PROM地址
;R_Cnt1	:保存要读取数据的个数
;IND1   :保存要写到E2PROM的数据，FSR1则为保存数据的单元地址
;------------------------------------------------------------------
F_E2P_Write:
	CALL		F_E2P_Start
	MOVLW		0A0H
	CALL		F_E2P_Send
	MOVFW		FSR0
	CALL		F_E2P_Send
E2P_Write_Lp:
	MOVFW		IND1
	CALL		F_E2P_Send
	INCF		FSR1,1
	DECFSZ		R_Cnt1,1
	GOTO		E2P_Write_Lp
	CALL		F_E2P_Stop
	MOVLW		100
	call		F_Delay_Ms
    return
;------------------------------------------------------------------
;				连续读N个数据(2)
;------------------------------------------------------------------
;FSR0   :保存第一个变量的E2PROM地址
;R_Cnt1	:保存要读取数据的个数
;IND1   :保存从E2PROM读到的数据，FSR1则为保存数据的单元地址
;------------------------------------------------------------------
F_E2P_Read:
	CALL		F_E2P_Start
	MOVLW		0A0H
	CALL		F_E2P_Send
	MOVFW		FSR0
	CALL		F_E2P_Send
	CALL		F_E2P_Start
	MOVLW		0A1H
	CALL		F_E2P_Send
	DECFSZ		R_Cnt1,1
	GOTO		E2P_Read_Lp
	GOTO		E2P_Read_One
E2P_Read_Lp:
	CALL		F_E2P_Rece
	BCF			P_E2SDA,E2SDA
	NOP
	BSF			P_E2SCL,E2SCL		;发送应答信号ACK给24C02
	CALL		F_Delay3
	BCF			P_E2SCL,E2SCL
	INCF		FSR1,1
	DECFSZ		R_Cnt1,1
	GOTO		E2P_Read_Lp
	
E2P_Read_One:
	CALL		F_E2P_Rece
	BSF			P_E2SDA,E2SDA		;发送非应答信号给24C02以停止操作
	CALL		F_Delay2
	BSF			P_E2SCL,E2SCL		;发送应答信号ACK给24C02
	CALL		F_Delay3
	BCF			P_E2SCL,E2SCL	
	GOTO		F_E2P_Stop

;------------------------------------------------------------------
;				E2PROM操作(1)
;------------------------------------------------------------------
;启动子程序
F_E2P_Start:
	BCF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BSF			P_E2SDA,E2SDA
	CALL		F_Delay2
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BCF			P_E2SDA,E2SDA
	CALL		F_Delay2
	BCF			P_E2SCL,E2SCL
	RETURN
;------------------------------------------------------------------
;停止子程序(1)
F_E2P_Stop:
	BCF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BCF			P_E2SDA,E2SDA
	CALL		F_Delay2
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BSF			P_E2SDA,E2SDA
	CALL		F_Delay2
	BCF			P_E2SCL,E2SCL
RETURN
;------------------------------------------------------------------
;发送1字节子程序(1)
;使用R_Temp1、R_Cnt0
;------------------------------------------------------------------
F_E2P_Send:
	MOVWF		R_Send_Data
	MOVLW		8
	MOVWF		R_Cnt0
E2P_Send_Lp:
	RLF			R_Send_Data,1
	BTFSS		STATUS,C
	BCF			P_E2SDA,E2SDA
	BTFSC		STATUS,C
	BSF			P_E2SDA,E2SDA
	CALL		F_Delay2
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay3
	BCF			P_E2SCL,E2SCL
	DECFSZ		R_Cnt0,1
	GOTO		E2P_Send_Lp
	
	NOP
	BCF			P_E2PtEN,E2SDA		;释放总线，给一个时钟，接收ACK
	CALL		F_Delay3
	NOP
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay3			;使用125KHZ时钟
	BCF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BSF			P_E2PtEN,E2SDA
RETURN
;------------------------------------------------------------------
;读1字节子程序(1)
;R_Cnt0	:读8bits数据
;IND1	:保存从E2PROM读到的数据
;------------------------------------------------------------------
F_E2P_Rece:
	MOVLW		8
	MOVWF		R_Cnt0
	BCF			P_E2PtEN,E2SDA		;更改为输入脚
	BSF			P_E2PtPU,E2SDA		;打开上拉电阻
	CLRF		IND1
E2P_Rece_Lp:
	BCF			STATUS,C
	RLF			IND1,1
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BTFSC		P_E2SDA,E2SDA
	INCF		IND1,1
	BCF			P_E2SCL,E2SCL
	DECFSZ		R_Cnt0,1
	GOTO		E2P_Rece_Lp
	BSF			P_E2PtEN,E2SDA		;更改为输出脚
RETURN




;*********************************************
;				延迟子程序(0)
;*********************************************
;R_A1	:保存ms的单位
;R_A0	:用于组成ms的单元
;**********************************************
F_Delay_Ms:
	MOVWF		R_delay_k1
Delay_Ms_Lp1:
	MOVLW		0FAH
	MOVWF		R_delay_k2
Delay_Ms_Lp2:
	NOP
	DECFSZ		R_delay_k2,1
	GOTO		Delay_Ms_Lp2
	DECFSZ		R_delay_k1,1
	GOTO		Delay_Ms_Lp1
RETURN
;***********************************************
;				延迟子程序(0)
;***********************************************
F_Delay:
	NOP
	NOP
	RETURN	
;;;==============================================
F_Delay2:
F_Delay3:	
SUB_PIN_DELAY:
        NOP
        NOP
        NOP
sub_pin_delay2:
        NOP
        NOP
        NOP
sub_pin_delay1:
        NOP
        NOP
        NOP
        NOP
        RETURN	
;===========================================
