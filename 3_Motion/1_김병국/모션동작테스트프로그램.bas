
'****************************************
'***** ��Ż������ ���� ���α׷� *******
'****************************************

'******* �������� ***********************
DIM A AS BYTE
DIM I AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM ������� AS BYTE
DIM ONE AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE

'**** ���⼾����Ʈ ����

CONST �յڱ���AD��Ʈ = 2
CONST �¿����AD��Ʈ = 3

'*****  2012�� ���� ���� ****
'CONST ����Ȯ�νð� = 10  'ms
'CONST min = 100			'�ڷγѾ�������
'CONST max = 160			'�����γѾ�������
'CONST COUNT_MAX = 30
'

'**** 2012�� ��� ���� *****
CONST ����Ȯ�νð� = 5  'ms
CONST MIN = 61			'�ڷγѾ�������
CONST MAX = 107			'�����γѾ�������
CONST COUNT_MAX = 20

'*******************
������� = 0

'*******���͹��⼳��*********************
DIR G6A,1,0,0,1,0,0	'���ʴٸ�:����0~5��
DIR G6D,0,1,1,0,1,0	'�����ʴٸ�:����18~23��
DIR G6B,1,1,1,1,1,1	'������:����6~11��
DIR G6C,0,0,0,0,0,0	'��������:����12~17��


'*******���͵��������****************
PTP SETON 		'�����׷캰 ���������� ����
PTP ALLON		'��ü���� ������ ���� ����

'*******������ġ���ǵ��****************
GOSUB MOTOR_GET

'*******���ͻ�뼳��********************
GOSUB MOTOR_ON

'*******�ǿ����Ҹ�����******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** �ʱ��ڼ��� **********************
'GOSUB GYRO_INIT
'GOSUB GYRO_ON
'GOSUB GYRO_ST
SPEED 5
GOSUB �⺻�ڼ�


ONE = 1

'***** ���� �ݺ���ƾ **************
MAIN:

    IF ONE=1 THEN
        'GOTO ���ʿ����λ�5
        'GOTO ���ʿ�������2
        'GOTO �����ʿ����λ�5
        'GOTO �����ʿ�������2
        'GOTO �����ʿ�����70
        GOTO �����ʿ�����20
        'GOTO �����δ���
        'GOTO ��ܿ����߿�����2cm
        'GOTO ��ܿ޹߳�����2cm
       ' GOTO �����޸�������
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************

�⺻�ڼ�:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,100,  83, 137,  95, 100, 100
    MOVE G6D,100,  84, 137,  95, 100, 100
    MOVE G6B,99,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT

    GOSUB GYRO_OFF
    RETURN
    '******************************************************

�����޸�������:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 10
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    MOVE G6A,95,  80, 145,  93, 101
    MOVE G6D,100,  80, 145,  93, 98
    WAIT
    '**********************

�����޸�������_1:
    FOR I = 0 TO 5
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT


        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT

        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT


        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
        
    NEXT I
    MOVE G6A,96,  95, 100, 120, 104
    MOVE G6D,101, 78, 146,  91, 100
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    MOVE G6A,96,  75, 122, 120, 104
    MOVE G6D,101, 80, 146,  89, 100
    WAIT


    MOVE G6A,103, 70, 145, 103, 102
    MOVE G6D, 96, 88, 160,  62, 100
    WAIT
    
    
    MOVE G6A,102,  78, 140,  98, 100, 101
    MOVE G6D,98,  84, 145,  85, 100, 100
	WAIT

    GOTO �����޸�������_����
    ' ***************************************************************8



�����޸�������_����:

    HIGHSPEED SETOFF
    SPEED 20

    GOSUB �⺻�ڼ�


    GOSUB Leg_motor_mode1
    'ONE=0
    'GOSUB GYRO_OFF

    'GOTO ����������������
    DELAY 8000
    GOTO RX_EXIT
    
'*************************************************************************************

�����ʿ�����70:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT


    SPEED 12
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,90,  76, 143,  93, 107, 100

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�

    DELAY 5000

    GOTO RX_EXIT
    '*************

���ʿ�����70:

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100
    MOVE G6D,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT


    SPEED 12
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,90,  76, 143,  93, 107, 100

    SPEED 5
    MOVE G6A,99,  76, 146,  93, 100, 100
    MOVE G6D,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�

    DELAY 5000

    GOTO RX_EXIT
    '*************

�����ʿ�����20:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 104, 100
    MOVE G6A,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 109, 100
    WAIT


    SPEED 12
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,90,  76, 143,  93, 102, 100

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�

    DELAY 5000

    GOTO RX_EXIT
    '*************



�����ʿ����λ�5:

    'FOR I = 0 TO 1
    'GOSUB �⺻�ڼ�
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 8
    MOVE G6D, 101,  80, 148, 92, 100, 100
    MOVE G6A,83,  78, 140,  95, 115, 100
    WAIT


    SPEED 8
    MOVE G6D,100,  78, 146,  93, 100, 100
    MOVE G6A,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 10
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB �⺻�ڼ�


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT


    '**********************************************************************************************8
���ʿ����λ�5:

    'GOSUB �⺻�ڼ�
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT

    SPEED 8
    MOVE G6A, 102,  80, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 8
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,92,  76, 146,  93, 100, 100
    WAIT

    SPEED 5
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  81, 140,  94, 100, 100
    MOVE G6D,99,  80, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15	
    GOSUB �⺻�ڼ�

    DELAY 5000

    'GOTO MAIN
    GOTO RX_EXIT

    '**********************************************************************************************8
�����ʿ�������2:

    'FOR I = 0 TO 1
    'GOSUB �⺻�ڼ�
    SPEED 12
    MOVE G6D, 90,  90, 120, 105, 104, 100
    MOVE G6A,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 12
    MOVE G6D, 101,  78, 148, 92, 100, 100
    MOVE G6A,83,  78, 140,  95, 109, 100
    WAIT


    SPEED 10
    MOVE G6D,100,  78, 146,  93, 100, 100
    MOVE G6A,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB �⺻�ڼ�


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT
    '****************************************************************************************
���ʿ�������2:

    'FOR I = 0 TO 1
    'GOSUB �⺻�ڼ�
    SPEED 12
    MOVE G6A, 90,  90, 120, 105, 104, 100
    MOVE G6D,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 12
    MOVE G6A, 101,  78, 148, 92, 100, 100
    MOVE G6D,83,  78, 140,  95, 109, 100
    WAIT


    SPEED 10
    MOVE G6A,100,  78, 146,  93, 100, 100
    MOVE G6D,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB �⺻�ڼ�


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT
    '****************************************************************************************

��ܿ����߿�����2cm: 'UPSTAIR GREEN

    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 2
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 2
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,110,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 4
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,110,  71, 155,  90,  94
    WAIT


    SPEED 4
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,110,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 4
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,110,  70, 155,  90,  100
    WAIT

    SPEED 4
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 107
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 4
    MOVE G6D, 112, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************************************************
    GOSUB Leg_motor_mode2	
    SPEED 4
    MOVE G6D, 113, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 4
    MOVE G6D, 113, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 4
    MOVE G6D, 113, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 4
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB All_motor_Reset

    GOSUB �⺻�ڼ�

    DELAY 5000

    GOTO RX_EXIT

    '****************************************************************************************


��ܿ޹߳�����2cm: ' GREEN USE
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,112,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 4
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 4
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 4
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 4
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  155, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,75,  125, 140,  88,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2	
    SPEED 4
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2	
    SPEED 4
    MOVE G6A,111, 75, 128, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 2
    MOVE G6A,111, 80, 128, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 2
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 2
    GOSUB �⺻�ڼ�
    GOSUB All_motor_Reset


    GOTO RX_EXIT




    '************************************************
    '************************************************



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



�⺻�ڼ�2:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 190
    MOVE G6C,100,  30,  80, 100, 128, 100
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

GYRO_INIT:
    GYRODIR G6A, 0, 0, 0, 0, 1
    GYRODIR G6D, 1, 0, 0, 0, 0
    RETURN
GYRO_ON:
    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,
    RETURN
GYRO_OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0
    RETURN
GYRO_MAX:
    GYROSENSE G6A,255,255,255,255
    GYROSENSE G6D,255,255,255,255
    RETURN
GYRO_MID:
    GYROSENSE G6A,255,100,100,100
    GYROSENSE G6D,255,100,100,100
    RETURN
GYRO_MIN:
    GYROSENSE G6A,100,50,50,50,50
    GYROSENSE G6D,100,50,50,50,50
    RETURN
GYRO_ST:
    GYROSENSE G6A,100,30,20,10,
    GYROSENSE G6D,100,30,20,10 ,
    RETURN






