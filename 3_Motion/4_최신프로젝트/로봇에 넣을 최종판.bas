'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM ������� AS BYTE
DIM �����ʺ��� AS BYTE



PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5�� �׷��� ����
DIR G6B,1,1,1,1,1,1		'����6~11�� �׷��� ����
DIR G6C,0,0,0,0,0,0		'����12~17�� �׷��� ����
DIR G6D,0,1,1,0,1,0		'����18~23�� �׷��� ����

'************************************************
'ZERO G6A, 100,100,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,100,100,100,100
'ZERO G6D, 100,100,100,100,100,100

'****** �κ�1 ***********************************
'ZERO G6A, 101, 100, 97,102,99,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,101,102,100
'
'****** �κ�2 ***********************************
'ZERO G6A, 100, 99, 97,102,101,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,100,102,100
'****** �κ�3 ***********************************
'ZERO G6A,  99, 98,100,101,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 99,100,100,102,100
'****** �κ�4 ***********************************
'ZERO G6A,  99, 99, 98,102,102,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,97,100,100,100
'ZERO G6D,  99,100,100,100,102,100

'****** �κ�5 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,102,100,101,100
'****** �κ�6 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  97, 98,103,100,102,100
'****** �κ�7 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  96,101,102, 97,102,100
'****** �κ�8 ***********************************
'ZERO G6A, 100,100, 99,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  99,99,102,100,103,100
'****** �κ�9 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,100,100,102,100
'****** �κ�10 **********************************
'ZERO G6A, 101, 98,101,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 96,104,100,102,100
'************************************************



'***** ���� ����*******************************************

������� = 0
'****�ʱ���ġ �ǵ��*****************************

'GETMOTORSET G6A,1,1,1,1,1,0
'GETMOTORSET G6B,1,1,1,0,0,0
'GETMOTORSET G6C,1,1,1,0,0,0
'GETMOTORSET G6D,1,1,1,1,1,0


SPEED 5
GOSUB MOTOR_ON
GOSUB MOTOR_READ

'*******�ǿ����Ҹ�����******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"

GOSUB �⺻�ڼ�

'GOSUB �������1

'1
'GOSUB �⺻�ڼ�
'STOP
'GOSUB �����ڼ�
'GOSUB ������������
'STOP
'GOTO 1

'GOTO �����ȿø���
GOTO MAIN	'�ø��� ���� ��ƾ���� ����

'************************************************
MOTOR_READ:
    FOR I = 1 TO 15
        b=MOTORIN(2)
    NEXT I
    RETURN
    '************************************************

MOTOR_ON:
    MOTOR G6A				'����0~7�� �׷��� ����
    MOTOR G6B				'����8~15�� �׷��� ����
    MOTOR G6C				'����16~23�� �׷��� ����
    MOTOR G6D				'����24~31�� �׷��� ����
    RETURN
    '************************************************
�ڼ�100:
    MOVE G6A,100,  100,  100, 100, 100, 100
    MOVE G6D,100,  100,  100, 100, 100, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT
    RETURN

�����ڼ�:
    MOVE G6A,100,  56, 182,  78, 100, 100
    MOVE G6D,100,  56, 182,  78, 100, 100
    MOVE G6B,100,  20,  90, 100, 100, 100
    MOVE G6C,100,  20,  90, 100, 100, 100
    WAIT
    mode = 2
    RETURN
    '�⺻�ڼ�1:
    MOVE G6A,100,  82, 145,  90, 100, 100
    MOVE G6D,100,  82, 145,  90, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN
�⺻�ڼ�:
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100,  30,  80, 100, 135, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

�ܰ���Ȯ��:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 190
    MOVE G6C,100,  30,  80, 100, 128, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

�÷�����:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 60, 100
    WAIT
    RETURN

�����ڼ�:
    SPEED 10
    MOVE G6A,100, 151,  27, 145, 100, 100
    MOVE G6D,100, 151,  27, 147, 100, 100
    MOVE G6B,120,  30,  80, , ,
    MOVE G6C,120,  30,  80, , ,
    WAIT

    MOVE G6A,100, 151,  23, 145, 101, 100
    MOVE G6D,100, 151,  23, 147, 101, 100
    MOVE G6B,120,  30,  80, , ,
    MOVE G6C,120,  30,  80, , ,
    WAIT
    mode = 1
    ETX 9600,32
    RETURN

�⺻100:
    MOVE G6A,100, 100, 100, 100, 100, 100
    MOVE G6B,100, 100, 100, 100, 100, 100
    MOVE G6C,100, 100, 100, 100, 100, 100
    MOVE G6D,100, 100, 100, 100, 100, 100
    WAIT
    RETURN

    '**********************************************
    '**********************************************
�����޸���50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF ������� = 0 THEN
    '    ������� = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  78, 145,  93, 98
    MOVE G6B,100,  30,  80,    , 100, 100
    MOVE G6C,100,  30,  80, 100, 135, 100
    WAIT

    GOTO �����޸���50_1

�����޸���50_1:
    FOR I = 0 TO 5
        MOVE G6A,95,  95, 100, 120, 101
        MOVE G6D,106, 88, 136,  91, 105
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

        '   GOTO �����޸���50_2
        '�����޸���50_2:
        MOVE G6A,95,  75, 122, 120, 101
        MOVE G6D,106, 78, 146,  91, 105
        WAIT

        '    GOTO �����޸���50_3
        '�����޸���50_3:
        MOVE G6A,103, 70, 145, 103, 100
        MOVE G6D, 97, 88, 160,  68, 102
        WAIT

        '   GOTO �����޸���50_4
        '�����޸���50_4:
        MOVE G6D,95,  88, 100, 120, 101
        MOVE G6A,108, 78, 146,  91, 105
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '   GOTO �����޸���50_5
        '�����޸���50_5:
        MOVE G6D,95,  75, 122, 120, 101
        MOVE G6A,108, 80, 146,  91, 105
        WAIT

        '    GOTO �����޸���50_6
        '�����޸���50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I

    GOTO �����޸���50_����

�����޸���50_����:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB ����ȭ�ڼ�
    SPEED 6
    GOSUB �⺻�ڼ�

    DELAY 500

    GOSUB Leg_motor_mode1
    GOTO MAIN

RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT
    '************************************************

    '******************************************

���ʿ�����70:

    '
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15	
    GOSUB �⺻�ڼ�
    GOTO MAIN

�����ʿ�����70:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB �⺻�ڼ�
    GOTO MAIN

������20:
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  90, 150,  73, 105, 100
    MOVE G6D,95,  53, 150, 110, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


    SPEED 10
    MOVE G6A,93,  90, 150,  73, 105, 100
    MOVE G6D,93,  53, 150, 110, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO MAIN

������45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,128,100
    WAIT



    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,128,100

    WAIT

    SPEED 8
    GOSUB �ܰ���Ȯ��
    GOSUB Leg_motor_mode1
    GOTO MAIN

��������45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115,,,,128,100
    MOVE G6B,85,,,,,190
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6C,115,,,,128,100
    MOVE G6B,85,,,,,190

    WAIT

    SPEED 8
    GOSUB �ܰ���Ȯ��
    GOSUB Leg_motor_mode1

    GOTO MAIN


��������20:
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,95,  90, 150,  73, 105, 100
    MOVE G6A,95,  53, 150, 110, 105, 100
    MOVE G6C,110
    MOVE G6B,90
    WAIT


    SPEED 10
    MOVE G6D,93,  90, 150,  73, 105, 100
    MOVE G6A,93,  53, 150, 110, 105, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO MAIN




��������10����:
    '    �Ѿ���Ȯ�� = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF ������� = 0 THEN
    '        ������� = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 135
    WAIT

    '        GOTO ������������_1
    '    ELSE
    '        ������� = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO ������������_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 9
��������10����_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


��������10����_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

��������10����_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB �յڱ�������
        '    IF �Ѿ���Ȯ�� = 1 THEN
        '        �Ѿ���Ȯ�� = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, ������������_4
        '    IF A <> A_old THEN  GOTO ������������_����

        '*********************************

��������10����_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


��������10����_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

��������10����_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, ������������_1
    '    IF A <> A_old THEN  GOTO ������������_����

��������10����_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    '�������=0
    GOTO MAIN



    '*****************************************************


��������2����:
    '    �Ѿ���Ȯ�� = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF ������� = 0 THEN
    '        ������� = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 135
    WAIT

    '        GOTO ������������_1
    '    ELSE
    '        ������� = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO ������������_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 1
��������2����_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


��������2����_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

��������2����_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB �յڱ�������
        '    IF �Ѿ���Ȯ�� = 1 THEN
        '        �Ѿ���Ȯ�� = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, ������������_4
        '    IF A <> A_old THEN  GOTO ������������_����

        '*********************************

��������2����_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


��������2����_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

��������2����_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, ������������_1
    '    IF A <> A_old THEN  GOTO ������������_����

��������2����_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    '�������=0
    GOTO MAIN


    '*****************************************************

����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 135, 100
    WAIT
    RETURN

    '********************************************************

��ܿ����߿�����2cm: 'UPSTAIR GREEN
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,105,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 93, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 152, 102,
    MOVE G6A,95,  93, 160,  70, 102
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 110, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 102
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,93,  90, 165,  70, 107
    WAIT

    SPEED 12
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,88,  120, 40,  140, 110
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,88,  95, 90,  145, 110
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 110
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,101,
    MOVE G6D,98,  90, 110,  125,101,
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB �⺻�ڼ�
    '�������=0
    GOTO MAIN

    '********************************************************

��ܿ޹߳�����2cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,111,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,111,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    SPEED 5 ' add
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 55,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT
    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A,108, 64, 132, 137, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,110, 68, 130, 147, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,110, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,110, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, , 80, 130, 105,99,
    MOVE G6A,100,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4

    GOSUB �⺻�ڼ�
    GOTO MAIN

    '********************************************************

����:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  57, 160, 100, 100'
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,186,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 15
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETOFF

    'GOTO ���������_LOOP

����_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 102, 145,  75, 160, 99
    MOVE G6B, 170,  25,  70
    MOVE G6C, 187,  50,  40
    WAIT

����_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 99
    MOVE G6B, 160,  28,  73
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  50, 160, 100
    MOVE G6A, 102, 146,  78, 160, 101
    MOVE G6C, 175,  30,  65
    MOVE G6B, 187,  50,  40
    WAIT


����_2:
    MOVE G6D, 100, 150,  70, 160, 100
    MOVE G6A, 101, 140, 123, 120, 99
    MOVE G6C, 161,  30,  65
    MOVE G6B, 187,  25,  72
    WAIT

    GOTO ����_LOOP

    '********************************************************

���ö󰡱�: 'UPSTAIR RED

    SPEED 15
    MOVE G6B, 190, 100, 100
    MOVE G6C, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B, 190, 10, 100
    MOVE G6C, 190, 10, 100
    WAIT

    SPEED 12
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  10,  100
    MOVE G6C, 190,  10,  100
    WAIT

    SPEED 5
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT


    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  155, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT
    GOTO MAIN

    '********************************************************

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
    �������=0
    GOTO MAIN




MAIN: '�󺧼���
    ETX 9600,48

    'GOSUB �����ڼ�
    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
MAIN1:
    'GOTO KEY1
    'A=A+1
    'IF A=44 THEN
    'A=0
    ERX 9600,A, MAIN1
    'GOTO ��������2
    A_old = A

    ON A GOTO MAIN1,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15
    'GOTO KEY34
    'DELAY 500

    'GOTO �ɾƿ����Ȼ���

    GOTO MAIN1	
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
    ETX  9600,1
    MOVE G6A,100,  82, 145,  90, 100, 100
    MOVE G6D,100,  82, 145,  90, 100, 100
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100,  30,  80, 100, 135, 100
    'DELAY 1000

    GOTO MAIN
KEY2:
    ETX  9600,2
    GOTO �����޸���50
    'DELAY 1000

    GOTO MAIN
KEY3: 'LEFT SIDE
    ETX  9600,3
    MOVE G6A,100,  79, 148,  86, 102, 100
    MOVE G6D,100,  79, 148,  86, 102, 100
    MOVE G6B,100,  18,  88, 100, 100, 10
    MOVE G6C,100,  18,  88, 100, 128, 100
    WAIT
    'DELAY 1000
    GOTO MAIN

KEY4: 'RIGHT SIDE
    ETX  9600,4
    MOVE G6A,100,  74, 148,  95, 102, 100
    MOVE G6D,100,  74, 148,  95, 102, 100
    MOVE G6B,100,  18,  88, 100, 100, 190
    MOVE G6C,100,  18,  88, 100, 128, 100
    WAIT
    'DELAY 1000
    GOTO MAIN
KEY5:
    ETX 9600,5
    GOTO ���ʿ�����70
    'DELAY 1000
    GOTO MAIN
KEY6:
    ETX 9600,6
    GOTO �����ʿ�����70
    'DELAY 1000
    GOTO MAIN
KEY7:
    ETX 9600,7
    GOTO ������45
    'DELAY 1000
    GOTO MAIN
KEY8:
    ETX 9600,8
    GOTO ��������45
    'DELAY 1000
    GOTO MAIN
KEY9:
    ETX 9600,9
    GOTO ������20
    'DELAY 1000
    GOTO MAIN
KEY10:
    ETX 9600,10
    GOTO ��������20
    'DELAY 1000
    GOTO MAIN
KEY11:
    ETX 9600,9
    GOTO ��������10����
    'DELAY 1000
    GOTO MAIN
KEY12:
    ETX 9600,9
    GOTO ��������2����
    'DELAY 1000
    GOTO MAIN
KEY13:
    ETX 9600,9
    GOTO �÷�����
    'DELAY 1000
    GOTO MAIN
KEY14:
    ETX 9600,9
    GOTO ��ܿ����߿�����2cm
    'DELAY 1000
    GOTO MAIN
KEY15:
    ETX 9600,9
    GOTO ��ܿ޹߳�����2cm
    'DELAY 1000
    GOTO MAIN
    END
