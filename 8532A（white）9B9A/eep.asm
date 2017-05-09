;------------------------------------------------------------------
;				����дN������(2)
;------------------------------------------------------------------
;FSR0   :���潫Ҫд���E2PROM��ַ
;R_Cnt1	:����Ҫ��ȡ���ݵĸ���
;IND1   :����Ҫд��E2PROM�����ݣ�FSR1��Ϊ�������ݵĵ�Ԫ��ַ
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
;				������N������(2)
;------------------------------------------------------------------
;FSR0   :�����һ��������E2PROM��ַ
;R_Cnt1	:����Ҫ��ȡ���ݵĸ���
;IND1   :�����E2PROM���������ݣ�FSR1��Ϊ�������ݵĵ�Ԫ��ַ
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
	BSF			P_E2SCL,E2SCL		;����Ӧ���ź�ACK��24C02
	CALL		F_Delay3
	BCF			P_E2SCL,E2SCL
	INCF		FSR1,1
	DECFSZ		R_Cnt1,1
	GOTO		E2P_Read_Lp
	
E2P_Read_One:
	CALL		F_E2P_Rece
	BSF			P_E2SDA,E2SDA		;���ͷ�Ӧ���źŸ�24C02��ֹͣ����
	CALL		F_Delay2
	BSF			P_E2SCL,E2SCL		;����Ӧ���ź�ACK��24C02
	CALL		F_Delay3
	BCF			P_E2SCL,E2SCL	
	GOTO		F_E2P_Stop

;------------------------------------------------------------------
;				E2PROM����(1)
;------------------------------------------------------------------
;�����ӳ���
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
;ֹͣ�ӳ���(1)
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
;����1�ֽ��ӳ���(1)
;ʹ��R_Temp1��R_Cnt0
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
	BCF			P_E2PtEN,E2SDA		;�ͷ����ߣ���һ��ʱ�ӣ�����ACK
	CALL		F_Delay3
	NOP
	BSF			P_E2SCL,E2SCL
	CALL		F_Delay3			;ʹ��125KHZʱ��
	BCF			P_E2SCL,E2SCL
	CALL		F_Delay2
	BSF			P_E2PtEN,E2SDA
RETURN
;------------------------------------------------------------------
;��1�ֽ��ӳ���(1)
;R_Cnt0	:��8bits����
;IND1	:�����E2PROM����������
;------------------------------------------------------------------
F_E2P_Rece:
	MOVLW		8
	MOVWF		R_Cnt0
	BCF			P_E2PtEN,E2SDA		;����Ϊ�����
	BSF			P_E2PtPU,E2SDA		;����������
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
	BSF			P_E2PtEN,E2SDA		;����Ϊ�����
RETURN




;*********************************************
;				�ӳ��ӳ���(0)
;*********************************************
;R_A1	:����ms�ĵ�λ
;R_A0	:�������ms�ĵ�Ԫ
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
;				�ӳ��ӳ���(0)
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
