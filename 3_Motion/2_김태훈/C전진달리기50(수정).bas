
'****************************************
'***** ��Ż������ ���� ���α׷� *******
'****************************************

'******* �������� ***********************
DIM A AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM ������� AS BYTE
'**** ���⼾����Ʈ ����

CONST �յڱ���AD��Ʈ = 2
CONST �¿����AD��Ʈ = 3

'*****  2012�� ���� ���� ****
'CONST ����Ȯ�νð� = 10  'ms
'CONST min = 100         '�ڷγѾ�������
'CONST max = 160         '�����γѾ�������
'CONST COUNT_MAX = 30
'

'**** 2012�� ��� ���� *****
CONST ����Ȯ�νð� = 5  'ms
CONST MIN = 61         '�ڷγѾ�������
CONST MAX = 107         '�����γѾ�������
CONST COUNT_MAX = 20

'*******************

'*******���͹��⼳��*********************
DIR G6A,1,0,0,1,0,0   '���ʴٸ�:����0~5��
DIR G6D,0,1,1,0,1,0   '�����ʴٸ�:����18~23��
DIR G6B,1,1,1,1,1,1   '������:����6~11��
DIR G6C,0,0,0,0,0,0   '��������:����12~17��


'*******���͵��������****************
PTP SETON       '�����׷캰 ���������� ����
PTP ALLON      '��ü���� ������ ���� ����

'*******������ġ���ǵ��****************
GOSUB MOTOR_GET

'*******���ͻ�뼳��********************
GOSUB MOTOR_ON

'*******�ǿ����Ҹ�����******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** �ʱ��ڼ��� **********************
SPEED 5
GOSUB �⺻�ڼ�


������� = 1
'***** ���� �ݺ���ƾ **************
MAIN:

    ERX 4800,A,MAIN
    A_old = A

    IF A = 1 THEN
        GOTO �����޸���30
    ELSEIF A = 2 THEN
        GOTO �����޸���50
    ELSEIF A = 3 THEN
        GOTO ��������50
    ELSEIF A = 4 THEN
        GOTO �����Ͼ��
    ELSEIF A = 5 THEN
        GOTO ����
    ELSE
        MUSIC "F"   
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************

�����޸���30: '������ ª��
    '�Ѿ���Ȯ�� = 0

    SPEED 6
    HIGHSPEED SETON

    IF ������� = 0 THEN
        MOVE G6A,100,  80, 121, 118, 104
        MOVE G6D,102,  75, 150,  93,  102
        MOVE G6B, 80,  30,  80
        MOVE G6C,120,  30,  80

        ������� = 1
        GOTO �����޸���30_2
    ELSE
        MOVE G6D,100,  80, 121, 118, 104
        MOVE G6A,102,  75, 150,  93,  102
        MOVE G6C, 80,  30,  80
        MOVE G6B,120,  30,  80

        ������� = 0
        GOTO �����޸���30_4

    ENDIF



    '********************************************
�����޸���30_1:

    '�޹ߵ��10:
    MOVE G6A,100,  80, 121, 118, 104
    MOVE G6D,100,  75, 150,  93, 102  ''''
    MOVE G6B, 80,  30,  80
    MOVE G6C,120,  30,  80


    ERX 4800, A, �����޸���30_2
    GOSUB �⺻�ڼ�
    HIGHSPEED SETOFF
    GOTO RX_EXIT


�����޸���30_2:

    '�޹��߽��̵�1:
    MOVE G6A,101,  74, 140, 106, 102
    MOVE G6D, 95, 105, 124,  93, 104
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80

    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    GOTO MAIN
    'ENDIF

�����޸���30_3:
    '�����ߵ��10:
    MOVE G6D,100,  80, 121, 118, 104
    MOVE G6A,100,  75, 150,  93, 102   '''''
    MOVE G6C, 80,  30,  80
    MOVE G6B,120,  30,  80




    ERX 4800, A, �����޸���30_4
    GOSUB �⺻�ڼ�
    HIGHSPEED SETOFF
    GOTO RX_EXIT

�����޸���30_4:
    '�������߽��̵�1:
    MOVE G6D,101,  74, 140, 106, 102
    MOVE G6A, 95, 105, 124,  93, 104
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80



    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    GOTO MAIN
    'ENDIF

    '************************************************


    GOTO �����޸���30_1


    GOTO RX_EXIT

    '*********************************************
    '******************************************
�����޸���50:

    SPEED 12
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO �����޸���50_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO �����޸���50_4
    ENDIF


    '**********************

�����޸���50_1:
    'MOVE G6A,95,  95, 100, 120, 104
    'MOVE G6D,104, 78, 146,  91, 102
    'MOVE G6B, 80
    'MOVE G6C,120
    'WAIT
    
    MOVE G6A ,95,  95, 100, 120, 103
    MOVE G6D ,107, 76, 146,  91, 103
    MOVE G6B , 80
    MOVE G6C ,120
    WAIT


�����޸���50_2:
'    MOVE G6A,95,  75, 122, 120, 104
'    MOVE G6D,104, 80, 146,  89, 100
'    WAIT
	
	MOVE G6A,95,  75, 122, 120, 103
    MOVE G6D,107, 86, 137,  91, 102
    WAIT

�����޸���50_3:
    MOVE G6A,103, 70, 145, 103, 100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    ERX 4800,A, �����޸���50_4
    IF A <> A_old THEN  GOTO �����޸���50_����

    '*********************************

�����޸���50_4:
    'MOVE G6D,95,  95, 100, 120, 104
    'MOVE G6A,104, 78, 146,  91, 102
    'MOVE G6C, 80
    'MOVE G6B,120
    'WAIT
    
    MOVE G6D ,95,  95, 100, 120, 103
    MOVE G6A ,107, 76, 146,  91, 103
    MOVE G6C , 80
    MOVE G6B ,120
    WAIT

�����޸���50_5:
    'MOVE G6D,95,  75, 122, 120, 104
    'MOVE G6A,104, 80, 146,  89, 100
    'WAIT

	MOVE G6D,95,  75, 122, 120, 103
    MOVE G6A,107, 86, 137,  91, 102
    WAIT
�����޸���50_6:
    MOVE G6D,103, 70, 145, 103, 100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    ERX 4800,A, �����޸���50_1
    IF A <> A_old THEN  GOTO �����޸���50_����

    GOTO �����޸���50_1

    '*********************************
�����޸���50_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
��������50:
    GOSUB Leg_motor_mode3
    SPEED 4
    '�����ʱ���
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  96
    MOVE G6B,100,35
    MOVE G6C,100,35
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


��������50_1:

    SPEED 10
    '�޹߻�������
    MOVE G6A, 85,  44, 163, 113, 114
    MOVE G6D,110,  77, 146,  93,  94
    WAIT

    SPEED 4
    '�޹��߽��̵�
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,85, 93, 155,  71, 112
    WAIT

    SPEED 10
    '�����ߵ��10
    MOVE G6A,111,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ��������50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        SPEED 5
        '���ʱ���2
        MOVE G6A, 106,  76, 146,  93,  96      
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT   

        SPEED 3
        GOSUB �⺻�ڼ�
        GOSUB Leg_motor_mode1

        GOTO MAIN
    ENDIF
    '**********


��������50_2:

    SPEED 10
    '�����߻�������
    MOVE G6D,85,  44, 163, 113, 114
    MOVE G6A,110,  77, 146,  93,  94
    WAIT

    SPEED 4
    '�������߽��̵�
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 85, 93, 155,  71, 112
    WAIT

    SPEED 10
    '�޹ߵ��10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,111,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, ��������50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        SPEED 5
        '�����ʱ���2
        MOVE G6D, 106,  76, 146,  93,  96      
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 3
        GOSUB �⺻�ڼ�
        GOSUB Leg_motor_mode1
        GOTO MAIN
    ENDIF


    GOTO ��������50_1
    '************************************************
    '******************************************
    '***************************************
�����Ͼ��:

    PTP SETON      
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3
    DELAY 300


    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3   
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    GOSUB �⺻�ڼ�

    GOTO RX_EXIT

    '******************************************************

����:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5   
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT   

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO ���������_LOOP

����_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, ����_1
    '    IF A = 8 THEN GOTO ����_1
    '   IF A = 9 THEN GOTO �����������_LOOP
    '  IF A = 7 THEN GOTO ���������_LOOP

    GOTO �����Ͼ��

����_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    ERX 4800, A, ����_2
    ' IF A = 8 THEN GOTO ����_2
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    GOTO �����Ͼ��

����_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO ����_LOOP





����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '************************************************
    '************************************************
    '******************************************
    '***************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��
    MOTOR G24
    RETURN

    '***********************************
MOTOR_OFF: '����Ʈ�������ͼ�������
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    RETURN
    '***********************************
MOTOR_GET: '��ġ���ǵ��
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '*******�⺻�ڼ�����*****************

�⺻�ڼ�:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '*************************************   
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    RETURN
    '**************************************
�����ڼ�:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN

    '************************************************

RX_EXIT: '���Ű��� �����·�ƾ   

    ERX 4800, A, MAIN

    GOTO RX_EXIT

    '************************************************