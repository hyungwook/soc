
'****************************************
'***** ��Ż������ ���� ���α׷� *******
'**********DIM A AS BYTE******************************

'******* �������� ***********************
DIM A AS BYTE
DIM ONE AS BYTE
DIM I AS BYTE
DIM J AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM ������� AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE


'**** ���⼾����Ʈ ����
ONE = 1
'GOSUB GYRO_INIT
'GOSUB GYRO_ON
'GOSUB GYRO_ST

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




'*******���͵��������****************
PTP SETON 		'�����׷캰 ���������� ����
PTP ALLON		'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,0,0		'����12~17��
DIR G6D,0,1,1,0,1,0		'����18~23��


'*******���ͻ�뼳��********************
GOSUB MOTOR_ON

'*******�ǿ����Ҹ�����******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** �ʱ��ڼ��� **********************
SPEED 5
GOSUB �⺻�ڼ�


������� = 0

'***** ���� �ݺ���ƾ **************
MAIN:

    IF ONE=1 THEN
        'GOTO ��������45
        'GOTO ��������������������
        'GOTO �ܰ�����������
        'GOTO �ܰ����ö󰡱�
        'GOTO �����δ���
        'GOTO ����
        'GOTO ��ܿ����߿�����1cm
        'GOTO ���ö󰡱�
        'GOTO ���ѱ�

        'GOTO ������������

        'GOTO ����������������2����
        'GOTO ����������������50
        DELAY 6000
        'GOTO ��������50
        'GOTO ��ܿ޹߳�����2cm
        'GOTO ��90����������
        'GOTO ��������10����
        'GOTO ����������������50
        'GOTO ���ʴ���
        'GOTO �ܰ�����������20
        'GOTO �ܰ���������20
        'GOTO ����޸���
        'GOTO ������������
        'GOTO �ܰ�����������20
        'GOTO ������������
        'GOTO �����ɾƺ���
        GOTO �����δ���
        'GOTO ���ѱ�
        'GOTO ��������4��

        'GOTO ������45
        'GOTO ��������10
        'GOTO �����ʿ�����10
        'GOTO ���ʿ�����70
        'GOTO ��ܿ����߿�����2cm
        'GOTO ��ܿ޹߳�����2cm
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************
    '����ü��_6: '���ٸ��
    '    GOSUB All_motor_mode3'
    '
    '            SPEED 10
    '            MOVE G6D,96,  116, 62,  146, 130, 100
    '            MOVE G6A,75,  86, 125,  110, 85, 100
    '            MOVE G6C,100,  45,  90,,122
    '            MOVE G6B,100,  28,  81,, , 190
    '            WAIT
    '	DELAY 1000
    '    GOSUB �⺻�ڼ�
    '    ONE = 0
    '    GOTO MAIN




�����ɾƺ���:
    GOSUB All_motor_mode3
    SPEED 4

�����ɾƺ���_1:
    FOR I = 0 TO 5
        MOVE G6A,114, 143,  28, 142,  96, 100
        MOVE G6D, 87, 135,  28, 155, 110, 100
        WAIT


        MOVE G6D,98, 126,  28, 160, 102, 100
        MOVE G6A,98, 160,  28, 125, 102, 100
        WAIT

        '    ERX 4800, A, �����ɾƺ���_2
        '    SPEED 6
        '    IF  ������������ = 0 THEN
        '        GOSUB �����ڼ�
        '    ELSE
        '        MOVE G6A,100, 140,  28, 142, 100, 100
        '        MOVE G6D,100, 140,  28, 142, 100, 100
        '        WAIT
        '        �ڼ� = 1
        '    ENDIF
        '    GOSUB All_motor_Reset
        '    GOTO RX_EXIT

�����ɾƺ���_2:
        MOVE G6D,113, 143,  28, 142,  96, 100
        MOVE G6A, 87, 135,  28, 155, 110, 100
        WAIT

        MOVE G6A,98, 126,  28, 160, 102, 100
        MOVE G6D,98, 160,  28, 125, 102, 100
        WAIT

        '    ERX 4800, A, �����ɾƺ���_1
        '    SPEED 6
        '    IF  ������������ = 0 THEN
        '        GOSUB �����ڼ�
        '    ELSE
        '        MOVE G6A,100, 140,  28, 142, 100, 100
        '        MOVE G6D,100, 140,  28, 142, 100, 100
        '        WAIT
        '        �ڼ� = 1
        '    ENDIF
    NEXT I
    GOSUB �����ڼ�

    GOSUB All_motor_Reset

    GOTO RX_EXIT



��ܿ޹߳�����2cm: ' GREEN USE
    GOSUB �⺻�ڼ�
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,115,  76, 145,  93,  93
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 6
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 5
    MOVE G6A,93, 45, 175, 148, 114,
    MOVE G6D,112,  115, 65,  138,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,92,12, 165, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  154, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A,111, 68, 128, 143, 94
    MOVE G6D,75,  125, 140,  86,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,111, 68, 128, 148, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 2
    MOVE G6A,111, 70, 133, 130, 94
    MOVE G6D,93,  125, 40,  150,114
    WAIT


    GOSUB Leg_motor_mode2
    SPEED 3
    MOVE G6A,111, 75, 128, 117, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 4
    MOVE G6A,111, 80, 128, 113, 94
    MOVE G6D,80,  75,130,  118,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6D, 98, 80, 130, 110,101,
    MOVE G6A,98,  80, 130,  110, 101
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB �⺻�ڼ�
    GOSUB All_motor_Reset
    '    GOSUB �յڱ�������



    GOTO RX_EXIT
    '**********************************************
����޸���:
    '�Ѿ���Ȯ�� = 0
    'GOSUB SOUND_Walk_Ready
    SPEED 15
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO ����޸���_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO ����޸���2_4
    ENDIF


    '**********************

����޸���_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

����޸���_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
����޸���_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5
    '    GOSUB SOUND_REPLAY
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF

    '    ERX 4800,A, ����޸���_4
    '    IF A <> A_old THEN  GOTO ����޸���_����

    '*********************************

����޸���_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


����޸���_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

����޸���_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
    '    GOSUB SOUND_REPLAY
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF''
    '
    '    ERX 4800,A, ����޸���_1
    '    IF A <> A_old THEN  GOTO ����޸���_����
    GOTO ����޸���_����
    '
    '    GOTO ����޸���_1
����޸���2_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


����޸���2_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

����޸���2_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
����޸���2_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

����޸���2_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
����޸���2_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5


����޸���_����:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO MAIN


�⺻�ڼ�0:
    '���̷� ���� �� 90��(TH)
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  85, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN


��90����������: 'COMPLETE GREEN

    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    ����ӵ� = 10'5
    �¿�ӵ� = 5'8'3
    �¿�ӵ�2 = 4'5'2
    '�Ѿ���Ȯ�� = 0
    GOSUB �⺻�ڼ�0
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
    MOVE G6D,112,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO ��������50_1



��90����������_1:
    FOR I = 0 TO 1

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



��90����������_2:


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
        MOVE G6D,112,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT



    NEXT I





    'GOSUB ����ȭ�ڼ�2
    GOSUB �⺻�ڼ�0
    GOTO main
������������:
    '    �Ѿ���Ȯ�� = 0
    '    GOSUB SOUND_Walk_Ready

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ������������2_4
    ENDIF


    '**********************

������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

������������_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    'GOSUB SOUND_REPLAY
    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '   �Ѿ���Ȯ�� = 0
    '   GOTO MAIN
    'ENDIF

    'ERX 4800,A, ������������_4
    'IF A <> A_old THEN  GOTO ������������_����

    '*********************************

������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


������������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

������������_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    '������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '������������_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT


    '    GOSUB SOUND_REPLAY
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    GOTO ������������_����
    '    ENDIF

    '    ERX 4800,A, ������������_1

������������2_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


������������2_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

������������2_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
������������2_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


������������2_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

������������2_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    '������������2_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '������������2_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '������������2_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT

    GOTO ������������_����

������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


��������4����:
    GOSUB �⺻�ڼ�

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

        GOTO ��������4����_1
    ELSE
        ������� = 0
        MOVE G6D,97,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ��������4����_4
    ENDIF



    '**********************
��������4����_1:
    FOR I = 0 TO 2
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
    GOTO ��������4��������


��������4����_4:
    FOR I = 0 TO 2
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
    GOTO ��������4��������

��������4��������:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�


    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO MAIN



������������:
    '    �Ѿ���Ȯ�� = 0

    GOSUB �⺻�ڼ�
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
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
    FOR I = 0 TO 3
������������_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


������������_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

������������_3:
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

������������_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


������������_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

������������_6:
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

������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'�������=0
    GOTO MAIN




��ܿ����߿�����2cm: 'UPSTAIR GREEN

    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,107,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,112,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,112,  71, 155,  90,  94
    WAIT


    SPEED 8
    MOVE G6D,  80, 55, 120, 160, 114,
    MOVE G6A,110,  70, 155,  90,  94
    WAIT

    SPEED 8
    MOVE G6D,  90, 55, 120, 150, 114,
    MOVE G6A,110,  70, 160,  85,  94
    WAIT




    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6D, 106, 75, 100, 150, 100,
    MOVE G6A,95,  90, 165,  65, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 8
    MOVE G6D, 111, 87, 90, 153,100,
    MOVE G6A,95,  100, 165,  62, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 113, 87, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 8
    MOVE G6D, 113, 87, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 8
    MOVE G6D, 113, 90, 110, 128,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 8
    MOVE G6D, 110, 90, 110, 127,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 8
    MOVE G6D, 110, 90, 110, 127,103,
    MOVE G6A,80,  70, 160,  100, 103
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    MOVE G6A, 97, 90, 110, 125,102,
    MOVE G6D,97,  90, 110,  125, 102
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    'SPEED 8
    'MOVE G6A,100,  77, 145,  93, 100, 100
    'MOVE G6D,100,  77, 145,  93, 100, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    'WAIT
    GOSUB All_motor_Reset

    GOSUB �⺻�ڼ�
    GOTO MAIN

qwer��ܿ޹߳�����2cm: ' GREEN USE
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 89,  71, 152,  91, 110
    MOVE G6D,108,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,112,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  155, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,75,  125, 140,  88,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A,111, 75, 128, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 4
    MOVE G6A,111, 80, 128, 113, 94
    MOVE G6D,80,  75,130,  118,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6D, 98, 80, 130, 110,101,
    MOVE G6A,98,  80, 130,  110, 101
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB �⺻�ڼ�
    GOSUB All_motor_Reset
    'GOSUB �յڱ�������
    'GOSUB �¿��������

    GOTO MAIN


�����ʿ�����10:


    SPEED 12
    MOVE G6D, 95,  90, 120, 105, 104, 100
    MOVE G6A,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,92,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB �⺻�ڼ�
    GOTO MAIN

���ʿ�����10:


    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 105,  77, 145, 93, 98, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB �⺻�ڼ�
    GOTO MAIN

������10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,97,  86, 146,  85, 102, 100
    MOVE G6D,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,92,  86, 146,  85, 101, 100
    MOVE G6D,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO MAIN



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
    GOTO MAIN
������45: ' COMPLETE
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  112, 145,  55, 105, 100
    MOVE G6D,95,  38, 145,  129, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  112, 145,  56, 105, 100
    MOVE G6D,93,  38, 145,  127, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO MAIN




��������10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6D,97,  86, 146,  85, 102, 100
    MOVE G6A,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6D,92,  86, 146,  85, 101, 100
    MOVE G6A,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB �⺻�ڼ�
    GOSUB Leg_motor_mode1
    GOTO MAIN


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


    GOTO MAIN

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
    GOTO MAIN


��������45: ' COMPLETE

    GOSUB �⺻�ڼ�
    SPEED 12
    MOVE G6D,95,  116, 145,  53, 105, 100
    MOVE G6A,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  116, 145,  53, 105, 100
    MOVE G6A,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�
    GOTO MAIN



����������������50: 'COMPLETE

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



����������������50_1:
    FOR I = 0 TO 9

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



����������������50_2:


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




    GOSUB ����ȭ�ڼ�2
    'GOSUB �⺻�ڼ�
    GOSUB GYRO_OFF

    'GOTO MAIN
    'GOSUB �յڱ�������
    'GOSUB �¿��������

    GOTO main



��������10����:

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
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35,,,135
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,110,  78, 146,  93,  93
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '        GOTO ��������50_1



��������10����_1:
    FOR I = 0 TO 9
        SPEED ����ӵ�
        '�޹߻�������
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,109,  77, 146,  93,  92
        WAIT



        SPEED �¿�ӵ�
        'GOSUB Leg_motor_mode3
        '�޹��߽��̵�
        MOVE G6A,109,  76, 144, 100,  93
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



��������10����_2:


        SPEED ����ӵ�
        '�����߻�������
        MOVE G6D,85,  44, 163, 113, 117
        MOVE G6A,110,  77, 146,  93,  94
        WAIT

        SPEED �¿�ӵ�
        'GOSUB Leg_motor_mode3
        '�������߽��̵�
        MOVE G6D,109,  76, 144, 100,  93
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

    MOVE G6A,87,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,100 ,  31,  80, 100, 100, 100
    WAIT
    GOSUB �⺻�ڼ�
    'GOSUB GYRO_OFF
    '    ONE=0

    'DELAY 400

    GOSUB GYRO_OFF
    ONE = 0
    GOTO MAIN
�����δ���:

    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,190
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,185,  10, 100
    WAIT


    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,130,  80,  20,,,
    MOVE G6C,130,  80,  20,,190
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  80,  20
    MOVE G6C,140,  80,  20,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  50,  68
    MOVE G6C,171,  50,  70
    WAIT
    DELAY 200
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  50,  70
    MOVE G6C,190,  50,  70,,190
    WAIT

	DELAY 50
    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT
    DELAY 200
    SPEED 13
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 180, 100
    MOVE G6C,190, 180, 100
    WAIT
    DELAY 200
    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT
    DELAY 200
    SPEED 13
    GOSUB �����ڼ�

    SPEED 10
    GOSUB �⺻�ڼ�
    GOTO rx_exit



�����δ���4:

    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,189,  10, 100
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,189,  10, 100
    WAIT

    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,130,  80,  20,,,
    MOVE G6C,130,  80,  20,,180
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  80,  20
    MOVE G6C,140,  80,  20,,180
    WAIT



    DELAY 1000
    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,180
    WAIT
    'DELAY 1000

    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,
    WAIT
    'ELAY 1000
    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,150,  41,  68
    MOVE G6B,150,  40,  70
    WAIT
    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,152,  40,  68
    MOVE G6B,151,  40,  65
    WAIT
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,172,  40,  68
    MOVE G6C,173,  40,  65,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  10
    MOVE G6C,190,  40,  10,,190
    WAIT


    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 10
    MOVE G6C,190, 165, 10
    WAIT


    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT
    SPEED 20
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

    GOTO MAIN

    'goto main

�����δ���2:


    'DELAY 3000
    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85
    WAIT

    SPEED 8	
    MOVE G6A, 100, 155,  60, 165, 100, 100
    MOVE G6D, 100, 157,  55, 165, 100, 100
    MOVE G6B,185,  20, 70
    MOVE G6C,185,  20, 70
    WAIT



    SPEED 12
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
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
    MOVE G6C,173,  41,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70,,
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
    GOSUB �յڱ�������


    GOTO main


�����δ���3:

    SPEED 6
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,
    WAIT


    SPEED 6
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  43, 97
    MOVE G6C,185,  43, 100
    WAIT

    'SPEED 4
    'MOVE G6A,100, 165, 110, 140, 100, 100
    'MOVE G6D,100, 165, 110, 140, 100, 100
    'MOVE G6B,140,  80,  40,,,
    'MOVE G6C,140,  80,  40,,190
    'WAIT

    SPEED 6
    MOVE G6A,100, 78, 140, 147, 100, 100
    MOVE G6D,100, 78, 140, 147, 100, 100
    MOVE G6B,150,  80,  40
    MOVE G6C,150,  90,  40,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  55,  70
    MOVE G6C,150,  55,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,150,  55,  70
    MOVE G6C,150,  55,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  55,  68
    MOVE G6C,171,  55,  70
    WAIT
    DELAY 200
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  55,  70
    MOVE G6C,190,  55,  70,,190
    WAIT
    DELAY 200

    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 13
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
    DELAY 3000
    GOTO �����δ���2
    ' GOSUB �յڱ�������


    'GOTO main

���ʴ���:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB �⺻�ڼ�


    SPEED 15
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6D,83 , 108,  85, 125, 105, 100
    MOVE G6A,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6D,89,  125,  62, 130, 110, 100
    MOVE G6A,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6D, 89, 125,  62, 130, 150, 100
    MOVE G6A,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6D,120, 125,  62, 130, 170, 100
    MOVE G6A,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6D,120, 125,  62, 130, 183, 100
    MOVE G6A,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6D,120, 125,  62, 130, 168, 100
    MOVE G6A,120, 125  62, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6D,105, 125,  62, 130, 183, 100
    MOVE G6A, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6D,107, 125,  62, 132, 113, 100
    MOVE G6A, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�

    ONE = 0
    GOTO MAIN




�ܰ�����������: '���ٸ��
    GOSUB All_motor_mode3


    SPEED 12
    MOVE G6D,96,  116, 67,  135, 130, 100
    MOVE G6A,80,  86, 125,  108, 85, 100
    MOVE G6C,100,  45,  90,,123
    MOVE G6B,100,  180,  140,, , 190
    WAIT

    ONE = 0
    GOTO MAIN

�ܰ����ö󰡱�:
    GOSUB All_motor_mode3	
    SPEED 8
    MOVE G6D,96,  86, 125,  103, 110, 100
    MOVE G6A,95,  76, 145,  93, 100, 100
    MOVE G6C,100,  35,  80,
    MOVE G6B,100,  35,  80,
    WAIT



    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT

    'SPEED 5
    'MOVE G6A,100,  84, 137,  94, 100, 100
    'MOVE G6D,100,  84, 137,  94, 100, 100
    'MOVE G6B,100,  28,  81, 100, 100, 190
    'MOVE G6C,100 ,  32,  80, 100, 135, 100
    'WAIT
    SPEED 5
    MOVE G6A,100,  84, 132,  101, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 190
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT


    SPEED 5
    MOVE G6A,100,  84, 137,  94, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 190
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT


    '**********************************************
    ONE = 0
    GOTO MAIN


�ܰ����ڼ�:

    SPEED 15
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN
�ܰ����ڼ�2:

    SPEED 15
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN


���ڼ�:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  92, 100, 100
    MOVE G6D,101,  85, 137,  92, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN

���ڼ�2:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  92, 100, 100
    MOVE G6D,101,  85, 137,  92, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN


�ܰ�����������10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    SPEED 12
    MOVE G6D,97,  86, 146,  85, 102, 100
    MOVE G6A,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6D,92,  86, 146,  85, 101, 100
    MOVE G6A,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    'mOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


�ܰ�����������20: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    SPEED 6
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  126, 105, 100
    'MOVE G6C,115
    'MOVE G6B,85
    WAIT

    SPEED 6
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  126, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO MAIN


�ܰ���������10: ' COMPLETE

    GOSUB GYRO_OFF

    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    SPEED 12
    MOVE G6A,97,  86, 146,  85, 102, 100
    MOVE G6D,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,92,  86, 146,  85, 101, 100
    MOVE G6D,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT



�ܰ���������20: ' COMPLETE
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    SPEED 8
    MOVE G6A,95,  100, 145,  68, 105, 100
    MOVE G6D,95,  50, 145,  118, 105, 100
    'MOVE G6B,110
    'MOVE G6C,90
    WAIT

    SPEED 8
    MOVE G6A,93,  100, 145,  68, 105, 100
    MOVE G6D,93,  50, 145,  118, 105, 100
    WAIT
    SPEED 8
    MOVE G6A,102,  76, 146,  93, 100, 100
    MOVE G6D,102,  76, 146,  93, 100, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT




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

    '    �Ѿ���Ȯ�� = 1
    RETURN






����������������2����:
    '    �Ѿ���Ȯ�� = 0
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    SPEED 15
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF ������� = 0 THEN
    '        ������� = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,
    MOVE G6C,100,  35,,190
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

����������������2����_1:
    'FOR I = 0 TO 1
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80,,,,,100
    MOVE G6C,120,,
    WAIT


����������������2����_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

����������������2����_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
����������������2����_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80,,,
    MOVE G6B,120,,,
    WAIT


����������������2����_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

����������������2����_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
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

    'NEXT I
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, ������������_1
    '    IF A <> A_old THEN  GOTO ������������_����

����������������2����_����:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB ����ȭ�ڼ�2
    SPEED 10
    GOSUB �⺻�ڼ�3

    DELAY 400

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'�������=0
    'GOTO MAIN
    ONE = 0
    GOTO MAIN

��������������������50:

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
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,109,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO ��������50_1



��������������������50_1:
    'FOR I = 0 TO 10
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



    GOSUB �⺻�ڼ�3
    GOSUB GYRO_OFF
    ONE=0
    'GOTO MAIN
    '    GOSUB �յڱ�������
    '    GOSUB �¿��������

    GOTO main



��������������������:
    '    �Ѿ���Ȯ�� = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35,,,190
        WAIT

        GOTO ��������������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO ��������������������_4
    ENDIF


    '**********************
    'FOR I = 0 TO 10
��������������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '��������������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '��������������������_3:
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

    '��������������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '��������������������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '��������������������_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT


    GOTO ��������������������_����

��������������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '��������������������_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '��������������������_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    '��������������������_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '��������������������_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '��������������������_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT



    GOTO ��������������������_����
    'NEXT I
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, ������������_1
    '    IF A <> A_old THEN  GOTO ������������_����

��������������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�2
    SPEED 10
    GOSUB �⺻�ڼ�3

    DELAY 1600

    GOSUB Leg_motor_mode1
    'ONE=0
    'GOTO RX_EXIT

    GOTO MAIN

    '******************************************
���ʿ�����20:


    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB �⺻�ڼ�
    �������=0
    GOTO MAIN

���ʿ�����70: 'USE


    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40
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
    �������=0
    GOTO MAIN

�����޸���50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF ������� = 0 THEN
    '    ������� = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  78, 145,  93, 98
    WAIT

    '    GOTO �����޸���50_1
    'ELSE
    '    ������� = 0
    '    MOVE G6D,95,  76, 145,  93, 101
    '    MOVE G6A,101,  78, 145,  93, 98
    '    WAIT

    '    GOTO �����޸���50_4
    'ENDIF


    '**********************
    FOR I = 0 TO 5
�����޸���50_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,103, 78, 146,  91, 102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

�����޸���50_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,103, 80, 146,  89, 100
        WAIT

�����޸���50_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 94, 88, 160,  68, 102
        WAIT

        'ERX 4800,A, �����޸���50_4
        'IF A <> A_old THEN  GOTO �����޸���50_����

        '*********************************

�����޸���50_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

�����޸���50_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

�����޸���50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I



�����޸���50_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    �������=0
    GOTO �����޸���50

���ѱ�2: 'USE




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
    '******************************************
    GOTO MAIN






���ѱ�: 'USE
    GOSUB GYRO_OFF
    GOSUB �⺻�ڼ�


    SPEED 13
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  100,  80, 100, 100, 100
    MOVE G6C,102 , 100,  80, 100, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT


    SPEED 15
    MOVE G6A, 100,  75, 145,  140, 100, 100
    MOVE G6D, 100,  76, 145,  140, 100, 100
    MOVE G6B, 175,  50,  80 , 100, 100
    MOVE G6C, 180,  54,  80 , 100, 185
    WAIT
    '=------------------------------------------
    DELAY 500



    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 152, 100, 100
    MOVE G6B,180,  50,  70
    MOVE G6C,180,  54,  70,
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,180,  40,  70
    MOVE G6C,180,  42,  70
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  37,  70
    MOVE G6C,190,  40,  70,,190
    WAIT
    DELAY 50

    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 20
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
    'GOSUB �յڱ�������
    'GOSUB �¿��������



    GOTO MAIN

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

    SPEED 6
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
    '    ERX 4800, A, ����_1
    '    IF A = 8 THEN GOTO ����_1
    '   IF A = 9 THEN GOTO �����������_LOOP
    '  IF A = 7 THEN GOTO ���������_LOOP

    'GOTO �����Ͼ��

����_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 180,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    'ERX 4800, A, ����_2
    ' IF A = 8 THEN GOTO ����_2
    'IF A = 9 THEN GOTO �����������_LOOP
    'IF A = 7 THEN GOTO ���������_LOOP

    'GOTO �����Ͼ��

����_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 170,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO ����_LOOP

��ܿ����߿�����1cm: 'UPSTAIR GREEN
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
    MOVE G6D, 105, 75, 100, 155, 105,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
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
    �������=0
    GOTO MAIN

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

    '����
    GOSUB Leg_motor_mode3


    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 6
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON
    '����_LOOP

    FOR I = 0 TO 5
        MOVE G6D, 100, 160,  55, 160, 100
        MOVE G6A, 100, 145,  75, 160, 100
        MOVE G6C, 175,  25,  70
        MOVE G6B, 190,  50,  40
        WAIT

        '����_2

        MOVE G6D, 100, 140,  80, 160, 100
        MOVE G6A, 100, 140, 120, 120, 100
        MOVE G6C, 160,  25,  70
        MOVE G6B, 190,  25,  70
        WAIT

        MOVE G6A, 100, 160,  55, 160, 100
        MOVE G6D, 100, 145,  75, 160, 100
        MOVE G6B, 175,  25,  70
        MOVE G6C, 190,  50,  40
        WAIT
        '����_1
        MOVE G6A, 100, 150,  70, 160, 100
        MOVE G6D, 100, 140, 120, 120, 100
        MOVE G6B, 160,  25,  70
        MOVE G6C, 190,  25,  70
        WAIT


    NEXT I
    '	�����Ͼ��:

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




����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100
    MOVE G6C,100,  30,  80, 100, 135
    WAIT
    RETURN
    '************************************************
    '************************************************
    '******************************************
    '***************************************

��������50:


    ����ӵ� = 10'5
    �¿�ӵ� = 5'8'3
    �¿�ӵ�2 = 4'5'2
    '�Ѿ���Ȯ�� = 0
    GOSUB Leg_motor_mode3

    SPEED 4
    '�����ʱ���
    MOVE G6A, 88,  71, 152,  91, 116
    MOVE G6D,107,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 116
    MOVE G6D,111,  78, 146,  93,  92
    MOVE G6B,90
    MOVE G6C,110
    WAIT



    '*******************************


��������50_1:
    'FOR I = 0 TO 1
    SPEED ����ӵ�
    '�޹߻�������
    MOVE G6A, 95,  64, 143, 103, 110
    MOVE G6D,108,  77, 146,  93,  94
    WAIT



    SPEED 4
    'GOSUB Leg_motor_mode3
    '�޹��߽��̵�
    MOVE G6A,106,  76, 144, 90,  93
    MOVE G6D,88, 93, 155,  71, 112
    WAIT


    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    GOTO MAIN
    'ENDIF


    SPEED ����ӵ�
    'GOSUB Leg_motor_mode2
    '�����ߵ��10
    MOVE G6A,107,  77, 146,  93, 94
    MOVE G6D,85, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    MOVE G6A,104,  83, 136,  93, 102
    MOVE G6D,100, 80, 143, 90, 103
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    MOVE G6A,99,  83, 137,  94, 98, 100
    MOVE G6D,99,  84, 137,  94, 98, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT



    GOSUB �⺻�ڼ�
    �������=0
    GOTO MAIN
����������������3����:

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
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'����ӵ�
    '�޹ߵ��
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,110,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO ��������50_1



����������������3����_1:
    'FOR I = 0 TO 10
    SPEED ����ӵ�
    '�޹߻�������
    MOVE G6A, 90,  44, 163, 115, 117
    MOVE G6D,108,  77, 146,  95,  90
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



����������������3����_2:


    SPEED ����ӵ�
    '�����߻�������
    MOVE G6D,87,  44, 163, 113, 117
    MOVE G6A,109,  77, 146,  93,  94
    WAIT

    SPEED �¿�ӵ�
    'GOSUB Leg_motor_mode3
    '�������߽��̵�
    MOVE G6D,108,  76, 144, 101,  93
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

    SPEED ����ӵ�
    '�޹߻�������
    MOVE G6A, 90,  44, 163, 115, 117
    MOVE G6D,108,  77, 146,  95,  92
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
    'NEXT I

    GOSUB �⺻�ڼ�4
    GOSUB GYRO_OFF
    'ONE=0
    'GOTO MAIN
    'GOSUB �յڱ�������
    'GOSUB �¿��������
    'ONE = 0

    'DELAY 2000
    GOTO MAIN


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
����ȭ�ڼ�2:
    '    MOVE G6A,98,  77, 145,  93, 101, 100
    '    MOVE G6D,99,  75, 145,  93, 101, 100
    '    MOVE G6B,100,  25,  80, 100, 100, 100
    '    MOVE G6C,102,  31,  80, 100, 190, 100
    '    WAIT
    MOVE G6A,99,  83, 137,  94, 101, 100
    MOVE G6D,99,  84, 137,  94, 101, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN


�⺻�ڼ�:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN

    'GOSUB GYRO_OFF


�⺻�ڼ�2:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN

�⺻�ڼ�3:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN
�⺻�ڼ�4:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
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


    '��������:
��������:

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT


    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 123,  100, 102, 100, 100
    MOVE G6D,100, 123,  100, 102, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB �⺻�ڼ�
    GOSUB �ڷ��Ͼ��
    'GOSUB �յڱ�������
    'GOSUB �¿��������


    ONE = 0
    GOTO MAIN
��������2:

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT

    SPEED 5
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 80, 135,  115, 150, 180, 100
    MOVE G6D, 80, 135,  115, 150, 180, 100
    MOVE G6B,185,  50, 70,  100, 100, 100
    MOVE G6C,185,  50, 70,  100, 100, 100
    WAIT

    SPEED 5
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

    SPEED 5
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
    '    SPEED 10

    GOSUB �⺻�ڼ�
    ONE=0
    GOTO MAIN
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
    '�Ѿ���Ȯ�� = 1
    RETURN



������������:
    '�Ѿ���Ȯ�� = 0

    SPEED 8
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100,  35
    WAIT





    '**********************

������������_1:
    FOR I = 0 TO 1
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6B,115
        MOVE G6C,85
        WAIT


������������_2:
        MOVE G6A,95,  90, 135, 90, 104
        MOVE G6D,104,  77, 146,  91,  100
        WAIT

������������_3:
        MOVE G6A, 103,  79, 146,  89, 100
        MOVE G6D,95,   65, 146, 103,  102
        WAIT

        ' GOSUB �յڱ�������
        'IF �Ѿ���Ȯ�� = 1 THEN
        '    �Ѿ���Ȯ�� = 0
        '    GOTO MAIN
        'ENDIF

        'ERX 4800,A, ������������_4
        'IF A <> A_old THEN  GOTO ������������_����

        '*********************************

������������_4:
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6C,115
        MOVE G6B,85
        WAIT


������������_5:
        MOVE G6A,104,  77, 146,  91,  100
        MOVE G6D,95,  90, 135, 90, 104
        WAIT

������������_6:
        MOVE G6D, 103,  79, 146,  89, 100
        MOVE G6A,95,   65, 146, 103,  102
        WAIT
    NEXT I
    'GOSUB �յڱ�������
    'IF �Ѿ���Ȯ�� = 1 THEN
    '    �Ѿ���Ȯ�� = 0
    '    GOTO MAIN
    'ENDIF

    'ERX 4800,A, ������������_1
    'IF A <> A_old THEN  GOTO ������������_����




������������_����:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

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
