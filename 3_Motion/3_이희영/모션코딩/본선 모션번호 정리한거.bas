
DIM I AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ������� AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER
DIM ����Ȯ��Ƚ�� AS BYTE
DIM �Ѿ���Ȯ�� AS BYTE
DIM ���⼾���������� AS BYTE
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
CONST min = 61			'�ڷγѾ�������
CONST max = 107			'�����γѾ�������
CONST COUNT_MAX = 20


����Ȯ��Ƚ�� = 0
�Ѿ���Ȯ�� = 0
���⼾���������� = 1




PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5�� �׷��� ����
DIR G6B,1,1,1,1,1,1		'����6~11�� �׷��� ����
DIR G6C,0,0,0,0,0,0		'����12~17�� �׷��� ����
DIR G6D,0,1,1,0,1,0		'����18~23�� �׷��� ����


'*****************��������******************

������� = 0

'*****************�ʱ⵿��******************

'GETMOTORSET G6A,1,1,1,1,1,0
'GETMOTORSET G6B,1,1,1,0,0,0
'GETMOTORSET G6C,1,1,1,0,0,0
'GETMOTORSET G6D,1,1,1,1,1,0

SPEED 5
GOSUB MOTOR_ON
GOSUB MOTOR_READ
TEMPO 220
MUSIC "O23EAB7EA>3#C"
GOSUB �⺻�ڼ�
GOTO MAIN

'*****************�ǿ����Ҹ�����******************



MOTOR_READ:
    FOR I = 1 TO 15
        b=MOTORIN(2)
    NEXT I
    RETURN


MOTOR_ON:
    MOTOR G6A				'����0~7�� �׷��� ����
    MOTOR G6B				'����8~15�� �׷��� ����
    MOTOR G6C				'����16~23�� �׷��� ����
    MOTOR G6D				'����24~31�� �׷��� ����
    RETURN

    '*****************�ǿ����Ҹ�����******************
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
    GYROSENSE G6A,120,50,40,30,100
    GYROSENSE G6D,120,50,40,30,100
    RETURN

RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT

    '************************************************




�⺻�ڼ�:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST

    MOVE G6A,100,  83, 137,  94, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT

    'GOSUB GYRO_OFF
    RETURN

�⺻�ڼ�2:
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 	, 100, 100
    MOVE G6C,102 ,  30,  80, 100, 190, 100
    WAIT
    RETURN
����ȭ�ڼ�:
    MOVE G6A,98,  77, 145,  93, 101, 100
    MOVE G6D,99,  75, 145,  93, 101, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,102,  31,  80, 100, 135, 100
    WAIT
    RETURN


�����ڼ�:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************

��������: 'COMPLETE

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    ����ӵ� = 10'5
    �¿�ӵ� = 5'8'3
    �¿�ӵ�2 = 4'5'2
    '�Ѿ���Ȯ�� = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '�����ʱ���
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,100,37
    MOVE G6C,100,35,,,
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,109,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO ��������50_1



��������_1:
    FOR I = 0 TO 3

        SPEED ����ӵ�
        '�޹߻�������
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,108,  77, 146,  93,  92
        WAIT



        SPEED �¿�ӵ�
        'GOSUB Leg_motor_mode3
        '�޹��߽��̵�
        MOVE G6A,108,  76, 144, 100,  93
        MOVE G6D,86, 93, 155,  71, 112
        WAIT



        SPEED ����ӵ�
        'GOSUB Leg_motor_mode2
        '�����ߵ��10
        MOVE G6A,110,  77, 146,  93, 94
        MOVE G6D,90, 100, 105, 110, 114
        MOVE G6B,110
        MOVE G6C,90
        WAIT



��������_2:


        SPEED ����ӵ�
        '�����߻�������
        MOVE G6D,87,  44, 163, 113, 117
        MOVE G6A,108,  77, 147,  94,  92
        WAIT

        SPEED �¿�ӵ�
        'GOSUB Leg_motor_mode3
        '�������߽��̵�
        MOVE G6D,108,  76, 144, 100,  93
        MOVE G6A, 85, 93, 155,  71, 112
        WAIT


        SPEED ����ӵ�
        'GOSUB Leg_motor_mode2
        '�޹ߵ��10
        MOVE G6A, 90, 100, 105, 110, 114
        MOVE G6D,110,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT



    NEXT I

    SPEED ����ӵ�
    '�޹߻�������
    MOVE G6A, 85,  44, 163, 113, 117
    MOVE G6D,108,  77, 146,  93,  92
    WAIT



    SPEED �¿�ӵ�
    'GOSUB Leg_motor_mode3
    '�޹��߽��̵�
    MOVE G6A,108,  76, 144, 100,  93
    MOVE G6D,86, 93, 155,  71, 112
    WAIT



    SPEED ����ӵ�
    'GOSUB Leg_motor_mode2
    '�����ߵ��10
    MOVE G6A,110,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT




    'GOSUB ����ȭ�ڼ�2
    GOSUB �⺻�ڼ�
    GOSUB GYRO_OFF

    'GOTO MAIN
    'GOSUB �յڱ�������
    'GOSUB �¿��������

    GOTO RX_EXIT


������10: ' COMPLETE

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT



������20: ' COMPLETE
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  100, 145,  68, 105, 100
    MOVE G6D,95,  50, 145,  118, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 15
    MOVE G6A,93,  100, 145,  68, 105, 100
    MOVE G6D,93,  50, 145,  118, 105, 100
    WAIT
    SPEED 8
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
������45: ' COMPLETE
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  116, 145,  53, 105, 100
    MOVE G6D,93,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************************************************
��������10����:


    SPEED 15
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,97,  76, 145,  93, 101
        MOVE G6D,100,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ��������10����_1
    ELSE
        ������� = 0
        MOVE G6D,97,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ��������10����_4
    ENDIF



    '**********************
��������10����_1:
    FOR I = 0 TO 5
        '����������������_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '����������������_2:
        MOVE G6A,97,  83, 130, 103, 103
        MOVE G6D,102,  79, 146, 90, 100
        WAIT

        '����������������_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  81, 147,  90, 102
        WAIT

        '����������������_4:
        MOVE G6D,97,  97, 120,  101, 103
        MOVE G6A,103, 78, 146,  92,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '����������������_5:
        MOVE G6D,97,  85, 130, 103, 103
        MOVE G6A,102, 79, 147, 90, 100
        WAIT

        '����������������_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   81, 144,  91, 102
        WAIT
    NEXT I
    GOTO ��������10��������


��������10����_4:
    FOR I = 0 TO 5
        '����������������_4:
        MOVE G6D,97,  97, 120,  101, 103
        MOVE G6A,103, 78, 146,  92,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '����������������_5:
        MOVE G6D,97,  85, 130, 103, 103
        MOVE G6A,102, 79, 147, 90, 100
        WAIT

        '����������������_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   81, 144,  91, 102
        WAIT

        '����������������_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '����������������_2:
        MOVE G6A,97,  83, 130, 103, 103
        MOVE G6D,102,  79, 146, 90, 100
        WAIT

        '����������������_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  81, 147,  90, 102
        WAIT


    NEXT I
    GOTO ��������10��������

��������10��������:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�


    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO RX_EXIT




��90����������3����:
    GOSUB �⺻�ڼ�2
    SPEED 13
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    MOVE G6D,97,  76, 145,  93, 101
    MOVE G6A,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100,  35
    WAIT

    GOTO ��90����������3����_1
    'ENDIF

��90����������3����_1:
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C, 80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 101
    MOVE G6A, 100,  73, 146,  98, 100
    WAIT
    '--------------------------------------
    '1:
    MOVE G6A,96,  88, 128, 105, 101
    MOVE G6D,102, 80, 146,  95,  100
    MOVE G6B, 80
    MOVE G6C,120
    WAIT

    '2:
    MOVE G6A,96,   78, 126, 114, 101
    MOVE G6D,102,  79, 146,  91, 100
    WAIT

    '3:
    MOVE G6A,100,  78, 135,  107, 101
    MOVE G6D,100,  77, 146,  93, 100
    WAIT
    '--------------------------------------
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C, 80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 101
    MOVE G6A, 100,  73, 146,  98, 100
    WAIT


    GOTO ��90����������3��������

��90����������3��������:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�2



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO RX_EXIT

    '**********************************************************************************



��������10: ' COMPLETE


    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D,97,  86, 145,  83, 103, 100
    MOVE G6A,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 10
    MOVE G6D,94,  86, 145,  83, 101, 100
    MOVE G6A,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 7
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB Leg_motor_mode1
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT


��������20: ' COMPLETE


    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D,95,  90, 145,  78, 105, 100
    MOVE G6A,95,  60, 145,  108, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 10
    MOVE G6D,93,  100, 145,  68, 105, 100
    MOVE G6A,93,  50, 145,  118, 105, 100

    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 100, 100
    MOVE G6A,101,  76, 146,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1


    GOTO RX_EXIT

��������30: ' COMPLETE
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6A,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


��������45: ' COMPLETE

    GOSUB �⺻�ڼ�
    SPEED 12
    MOVE G6D,95,  126, 145,  43, 105, 100
    MOVE G6A,95,  26, 145,  143, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  126, 145,  43, 105, 100
    MOVE G6A,90,  26, 145,  143, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT

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

    'DELAY 5000

    GOTO RX_EXIT
    '*************

���ʿ�����20:

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 104, 100
    MOVE G6D,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 109, 100
    WAIT


    SPEED 12
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,90,  76, 143,  93, 102, 100

    SPEED 5
    MOVE G6A,99,  76, 146,  93, 100, 100
    MOVE G6D,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�

    'DELAY 5000

    GOTO RX_EXIT
    '*************
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

    'DELAY 5000

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

    'DELAY 5000

    GOTO RX_EXIT
    '*************
    '*******************************************************************************************************************************
    '��90����,������
��90��������10: ' COMPLETE

    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT



��90��������20: ' COMPLETE
    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  100, 145,  68, 105, 100
    MOVE G6D,95,  50, 145,  118, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 15
    MOVE G6A,93,  100, 145,  68, 105, 100
    MOVE G6D,93,  50, 145,  118, 105, 100
    WAIT
    SPEED 8
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
��90��������45: ' COMPLETE
    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  116, 145,  53, 105, 100
    MOVE G6D,93,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT




��90����������10: ' COMPLETE


    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D,97,  86, 145,  83, 103, 100
    MOVE G6A,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 10
    MOVE G6D,94,  86, 145,  83, 101, 100
    MOVE G6A,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 7
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB Leg_motor_mode1
    GOSUB �⺻�ڼ�2
    GOTO RX_EXIT


��90����������20: ' COMPLETE


    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D,95,  90, 145,  78, 105, 100
    MOVE G6A,95,  60, 145,  108, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 10
    MOVE G6D,93,  100, 145,  68, 105, 100
    MOVE G6A,93,  50, 145,  118, 105, 100

    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 100, 100
    MOVE G6A,101,  76, 146,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode1


    GOTO RX_EXIT

��90����������30: ' COMPLETE
    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6A,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


��90����������45: ' COMPLETE

    GOSUB �⺻�ڼ�2
    SPEED 12
    MOVE G6D,95,  126, 145,  43, 105, 100
    MOVE G6A,95,  26, 145,  143, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  126, 145,  43, 105, 100
    MOVE G6A,90,  26, 145,  143, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    GOTO RX_EXIT

��90�������ʿ�����20:

    GOSUB �⺻�ڼ�2
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
    GOSUB �⺻�ڼ�2

    'DELAY 5000

    GOTO RX_EXIT
    '*************

��90�����ʿ�����20:

    GOSUB �⺻�ڼ�2
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 104, 100
    MOVE G6D,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 109, 100
    WAIT


    SPEED 12
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,90,  76, 143,  93, 102, 100

    SPEED 5
    MOVE G6A,99,  76, 146,  93, 100, 100
    MOVE G6D,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�2

    'DELAY 5000

    GOTO RX_EXIT
    '*************
��90�������ʿ�����70:

    GOSUB �⺻�ڼ�2
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
    GOSUB �⺻�ڼ�2

    'DELAY 5000

    GOTO RX_EXIT
    '*************

��90�����ʿ�����70:

    GOSUB �⺻�ڼ�2
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
    GOSUB �⺻�ڼ�2

    'DELAY 5000

    GOTO RX_EXIT
    '*************


    '*******************************************************************************************************************************



�����δ���:

    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,100
    MOVE G6C,160,  30,  85,,
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,130,  70,  20
    MOVE G6C,130,  70,  20,,190
    WAIT

    SPEED 15
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20,,190
    WAIT


    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,173,  42,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 15
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 160, 120
    MOVE G6C,190, 160, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB �����ڼ�

    SPEED 10
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT

�����δ���2:




    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,100
    MOVE G6C,160,  30,  85,,
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,170,  10, 100
    MOVE G6C,170,  10, 100
    WAIT


    SPEED 5
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20,,190
    WAIT


    DELAY 20

    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20,,190
    WAIT


    SPEED 12
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70,
    WAIT

    SPEED 12
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,173,  42,  70
    WAIT

    SPEED 12
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70
    WAIT
    DELAY 50

    SPEED 10
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB �����ڼ�

    SPEED 10
    GOSUB �⺻�ڼ�



    GOTO RX_EXIT


�ܰ����ڼ�:

    MOVE G6A,100,  85, 137,  94, 100, 100
    MOVE G6D,100,  86, 137,  94, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 152, 100
    WAIT

    RETURN

���ѱ�: 'USE




    SPEED 13
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  100,  80, 100, 100, 100
    MOVE G6C,102 , 100,  80, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT

    SPEED 10
    MOVE G6A,90,  82, 145,  86, 110, 100
    MOVE G6D,90,  83, 145,  86, 110, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT



    SPEED 10
    MOVE G6A, 90,  76, 145,  93, 110, 100
    MOVE G6D, 90,  76, 145,  93, 110, 100
    MOVE G6B, 185,  10,  100
    MOVE G6C, 190,  14,  100
    WAIT

    SPEED 6
    MOVE G6A, 90,  75, 145,  140, 110, 100
    MOVE G6D, 90,  76, 145,  140, 110, 100
    MOVE G6B, 185,  10,  80 , 100, 100
    MOVE G6C, 190,  14,  80 , 100, 190
    WAIT
    '=------------------------------------------
    SPEED 6
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 152,  35,  85
    MOVE G6C, 155,  35,  85
    WAIT

    SPEED 6
    MOVE G6A,100,  100, 95,  10, 100, 100
    MOVE G6D,100,  100, 95,  10, 100, 100
    MOVE G6B, 152,  20,  85
    MOVE G6C, 155,  24,  85
    WAIT


    '-------------------------------------
    SPEED 6
    MOVE G6A,100,  15, 55,  139, 100, 100
    MOVE G6D,100,  11, 51,  140, 100, 100
    MOVE G6B, 97,  26,  80
    MOVE G6C, 100,  30,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  10, 55,  140, 100, 100
    MOVE G6D,100,  10, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  10, 55,  140, 190, 100
    MOVE G6D,100,  10, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  60, 55,  140, 190, 100
    MOVE G6D,100,  60, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  60, 55,  140, 100, 100
    MOVE G6D,100,  60, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT



    '--------------------------------------------
    SPEED 10
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 10
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    SPEED 10
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '-------------- �Ͼ�� -----------------
    SPEED 9
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,160,  32, 70, 100, 100, 100
    MOVE G6C,160,  32, 70, 100, 100, 100
    WAIT


    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT
    '''''''''''''''''''''''''=

    '---------------'�߰���'-----------------
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    SPEED 9
    MOVE G6A,100, 130,  48, 136, 100, 100
    MOVE G6D,100, 130,  48, 136, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT


    '---------------------------------------




    SPEED 10
    GOSUB �⺻�ڼ�
    'DELAY 600
    GOTO RX_EXIT



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
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 4
    MOVE G6D, 112, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
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

    GOTO RX_EXIT
    '********************************************************

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
    GOSUB �յڱ�������
    GOSUB �¿��������

    GOTO RX_EXIT



�޹߰�����:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_MIN

    GOSUB Leg_motor_mode3
    SPEED 3

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 3
    MOVE G6D,106,  75, 145,  100,  98
    MOVE G6A, 83,  85, 122,  105, 108
    MOVE G6C,100,  48,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 5
    MOVE G6D,111,  81, 141,  87,  95
    MOVE G6A, 83,  20, 172,  135, 110
    MOVE G6B,50
    MOVE G6C,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 4
    MOVE G6D,111,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    SPEED 4
    MOVE G6D,111,  77, 145,  95,  93	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 4
    MOVE G6D,106,  77, 145,  93,  93, 100	
    MOVE G6A, 83,  71, 152,  91, 110, 100
    WAIT


    SPEED 3
    GOSUB �⺻�ڼ�	
    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    DELAY 1500

    'GOTO MAIN
    GOTO RX_EXIT

    '********************************************************************************************************************************************
�յڱ�������:
    '  IF ���⼾���������� = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN GOSUB �����

    IF A > MAX THEN GOSUB �����

    '    GOSUB GOSUB_RX_EXIT

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN  GOSUB �ڷ��Ͼ��
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN GOSUB �������Ͼ��
    RETURN
    '**************************************************
�¿��������:
    '  IF ���⼾���������� = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
        RETURN

    ENDIF
    RETURN
    '**************************************************
    '**************************************************
�������Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB All_motor_Reset


    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1
    RETURN


�ڷ��Ͼ��:

    '    IF ����ONOFF = 1 THEN
    '        GOSUB MOTOR_ON
    '    ENDIF
    HIGHSPEED SETOFF
    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
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

    �Ѿ���Ȯ�� = 1
    RETURN







MAIN:


    ERX 9600,A, MAIN



    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9
    ,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18,KEY19,KEY20,KEY21
    ,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28,KEY29,KEY30,KEY31,KEY32,KEY33
    ,KEY34,KEY35,KEY36,KEY37,KEY38,KEY39,KEY40,KEY41
    GOTO MAIN
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************
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


KEY1:

    GOTO �⺻�ڼ�
    GOTO MAIN
KEY2:

    GOTO �⺻�ڼ�2
    GOTO MAIN
KEY3:

    GOTO ��������
    GOTO MAIN
KEY4: '�⺻�ȱ�
KEY5: '�⺻�ȱ�
KEY6: '�⺻�ȱ�
KEY7: '�⺻�ȱ�
KEY8: '��������
    GOTO ��90����������3����
    GOTO MAIN
KEY9: '��������
    GOTO ��������10����
    GOTO MAIN
KEY10: '��������
KEY11: '��������
KEY12: '��������
KEY13: '�޸���
KEY14: '�޸���
KEY15: '�޸���
KEY16: '�޸���
KEY17: '�޸���
KEY18: '��
    GOTO ��������10
    GOTO MAIN
KEY19: '��
    GOTO ��������20
    GOTO MAIN
KEY20: '��
    GOTO ��������45
    GOTO MAIN
KEY21: '��
    GOTO ������10
    GOTO MAIN
KEY22: '��
    GOTO ������20
    GOTO MAIN
KEY23: '
    GOTO ������45
    GOTO MAIN
KEY24: '�����ΰ���
    GOTO �����ʿ�����20
    GOTO MAIN	
KEY25: '�����ΰ���
    GOTO �����ʿ�����70
    GOTO MAIN
KEY26: '�����ΰ���
    GOTO ���ʿ�����20
    GOTO MAIN
KEY27: '�����ΰ���
    GOTO ���ʿ�����70
    GOTO MAIN
KEY28: '��90����
    GOTO ��90����������10
    GOTO MAIN
KEY29: '��90����
    GOTO ��90����������20
    GOTO MAIN
KEY30: '��90����
    GOTO ��90����������45
    GOTO MAIN
KEY31: '��90����
    GOTO ��90��������10
    GOTO MAIN
KEY32: '��90����
    GOTO ��90��������20
    GOTO MAIN
KEY33: '��90�������ΰ���
    GOTO ��90��������45
    GOTO MAIN
KEY34: '��90�������ΰ���
    GOTO ��90�������ʿ�����20
    GOTO MAIN
KEY35: '��90�������ΰ���
    GOTO ��90�������ʿ�����70
    GOTO MAIN
KEY36: '��90�������ΰ���
    GOTO ��90�������ʿ�����20
    GOTO MAIN
KEY37: '��90�������ΰ���
    GOTO ��90�������ʿ�����70
    GOTO MAIN
KEY38:'��������ֹ��ձ�����οö󰡱�

    GOTO �����δ���
    GOTO MAIN
KEY39:

    GOTO �ܰ����ڼ�
    GOTO MAIN

KEY40: '��������ֹ��ձ�����γ�������
	
	GOTO �����δ���2
	GOTO MAIN

KEY41:

    GOTO ���ѱ�
    GOTO MAIN
KEY42:

    GOTO ��ܿ����߿�����2cm
    GOTO MAIN
KEY43:

    GOTO ��ܿ޹߳�����2cm
    GOTO MAIN
KEY44:

    GOTO �޹߰�����
    GOTO MAIN
KEY45: '������ֹ��ö󰡱�
KEY46: '������ֹ���������

