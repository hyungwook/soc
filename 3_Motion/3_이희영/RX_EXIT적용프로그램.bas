
'******** ��Ż������ �⺻�� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM �ڼ� AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM ������������ AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM �Ѿ���Ȯ�� AS BYTE

DIM �ݺ�Ƚ�� AS BYTE
DIM ���⼾���������� AS BYTE
DIM ȫ�����������ÿ��� AS BYTE


DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S11 AS BYTE
DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE


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


CONST �������� = 103	'��6V����

PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,0,0		'����12~17��
DIR G6D,0,1,1,0,1,0		'����18~23��


'***** �ʱ⼱�� *********************************
����ONOFF = 0
������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
�Ѿ���Ȯ�� = 0
���⼾���������� = 1
ȫ�����������ÿ��� = 0
������������ = 0
'****Action_mode(�ʱ�׼Ǹ��)******************
Action_mode = 0	'D(CODE 27):�����
'Action_mode = 1	'F(CODE 32):����Ʈ���
'Action_mode = 2	'G(CODE 23):���Ӹ��
'Action_mode = 3	'B(CODE 20):�౸���
'Action_mode = 4	'E(CODE 18):��ֹ����ָ��
'Action_mode = 5	'C(CODE 17):ī�޶���
'Action_mode = 6	'A(CODE 15):ȫ�����



'****�ʱ���ġ *****************************
OUT 52,0	'�� LED �ѱ�

SPEED 5
GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�



GOTO MAIN
'************************************************
'************************************************

MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    ����ONOFF = 0
    RETURN

    '************************************************
    '************************************************
MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

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
    '*******�⺻�ڼ�����*****************************
    '************************************************
�����ʱ��ڼ�:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    �ڼ� = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    �ڼ� = 0

    RETURN
    '************************************************
�⺻�ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    �ڼ� = 0
    ������������ = 0
    RETURN
    '************************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    �ڼ� = 2
    RETURN
    '************************************************
�����ڼ�:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    �ڼ� = 1

    RETURN

    '************************************************
RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT
    '************************************************
GOSUB_RX_EXIT:

    ERX 9600, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '************************************************


    '************************************************
    '******* �ǿ��� �Ҹ� ���� ***********************
    '************************************************


������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
�������̸�Ʈ��:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
������:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
����Ʈ��:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
�����:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
������:
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '************************************************
���̷���:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************

�౸������:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN
    '************************************************

��ֹ�������:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN
    '************************************************
    '************************************************
�����޸���50:
    �Ѿ���Ȯ�� = 0

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
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  78, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


�����޸���50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT



�����޸���50_3:
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 9600,A, �����޸���50_4
    IF A <> A_old THEN  GOTO �����޸���50_����

    '*********************************

�����޸���50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  78, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�����޸���50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT



�����޸���50_6:
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 9600,A, �����޸���50_1
    IF A <> A_old THEN  GOTO �����޸���50_����


    GOTO �����޸���50_1


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
    GOTO RX_EXIT

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
    GOTO RX_EXIT

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
    GOTO RX_EXIT

������45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,135,100
    WAIT



    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    MOVE G6B,115,,,,,190
    MOVE G6C,85,,,,135,100

    WAIT

    SPEED 8
    GOSUB �ܰ���Ȯ��
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

��������45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115,,,,135,100
    MOVE G6B,85,,,,,190
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6C,115,,,,135,100
    MOVE G6B,85,,,,,190

    WAIT

    SPEED 8
    GOSUB �ܰ���Ȯ��
    GOSUB Leg_motor_mode1

    GOTO RX_EXIT
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
    GOTO RX_EXIT

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
    GOTO RX_EXIT



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
    GOTO RX_EXIT

�÷�����:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 60, 100
    WAIT

    GOTO RX_EXIT

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
    GOTO RX_EXIT

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
    GOTO RX_EXIT

    '********************************************************








MAIN: '�󺧼���


    'GOSUB LOW_Voltage
    'GOSUB �յڱ�������
    ' GOSUB �¿��������


    'GOSUB ����ONOFF_LED

    ERX 9600,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15

    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************
    '*******************************************
KEY1:
    ETX  9600,1
    MOVE G6A,100,  82, 145,  90, 100, 100
    MOVE G6D,100,  82, 145,  90, 100, 100
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100,  30,  80, 100, 135, 100
    'DELAY 1000

    GOTO RX_EXIT
    '*******************************************
KEY2:
    ETX  9600,2
    GOSUB �����޸���50
    'DELAY 1000

    GOTO RX_EXIT
KEY3: 'LEFT SIDE
    ETX  9600,3
    MOVE G6A,100,  79, 148,  86, 102, 100
    MOVE G6D,100,  79, 148,  86, 102, 100
    MOVE G6B,100,  18,  88, 100, 100, 40

    MOVE G6C,100,  18,  88, 100, 135, 100
    WAIT
    'DELAY 1000
    GOTO RX_EXIT

KEY4: 'RIGHT SIDE
    ETX  9600,4
    MOVE G6A,100,  74, 148,  95, 102, 100
    MOVE G6D,100,  74, 148,  95, 102, 100
    MOVE G6B,100,  18,  88, 100, 100, 160
    MOVE G6C,100,  18,  88, 100, 135, 100
    WAIT
    'DELAY 1000
    GOTO RX_EXIT
KEY5:
    ETX 9600,5
    GOTO ���ʿ�����70
    'DELAY 1000
    GOTO RX_EXIT
KEY6:
    ETX 9600,6
    GOTO �����ʿ�����70
    'DELAY 1000
    GOTO RX_EXIT
KEY7:
    ETX 9600,7
    GOTO ������45
    'DELAY 1000
    GOTO RX_EXIT
KEY8:
    ETX 9600,8
    GOTO ��������45
    'DELAY 1000
    GOTO RX_EXIT
KEY9:
    ETX 9600,9
    GOTO ������20
    'DELAY 1000
    GOTO RX_EXIT
KEY10:
    ETX 9600,10
    GOTO ��������20
    'DELAY 1000
    GOTO RX_EXIT
KEY11:
    ETX 9600,11
    GOTO ��������10����
    'DELAY 1000
    GOTO RX_EXIT
KEY12:
    ETX 9600,12
    GOTO ��������2����
    'DELAY 1000
    GOTO RX_EXIT
KEY13:
    ETX 9600,13
    GOTO �÷�����
    'DELAY 1000
    GOTO RX_EXIT
KEY14:
    ETX 9600,14
    GOTO ��ܿ����߿�����2cm
    'DELAY 1000
    GOTO RX_EXIT
KEY15:
    ETX 9600,15
    GOTO ��ܿ޹߳�����2cm
    'DELAY 1000
    GOTO RX_EXIT
    END
