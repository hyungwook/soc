
'******** 메탈파이터 기본형 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM 자세 AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM 물건집은상태 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 넘어진확인 AS BYTE

DIM 반복횟수 AS BYTE
DIM 기울기센서측정여부 AS BYTE
DIM 홍보모드방향지시여부 AS BYTE


DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S11 AS BYTE
DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE


'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3

'*****  2012년 이전 센서 ****
'CONST 기울기확인시간 = 10  'ms
'CONST min = 100			'뒤로넘어졌을때
'CONST max = 160			'앞으로넘어졌을때
'CONST COUNT_MAX = 30
'

'**** 2012년 사용 센서 *****
CONST 기울기확인시간 = 5  'ms
CONST MIN = 61			'뒤로넘어졌을때
CONST MAX = 107			'앞으로넘어졌을때
CONST COUNT_MAX = 20

'*******************


CONST 하한전압 = 103	'약6V전압

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,0,0		'모터12~17번
DIR G6D,0,1,1,0,1,0		'모터18~23번


'***** 초기선언 *********************************
모터ONOFF = 0
보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
넘어진확인 = 0
기울기센서측정여부 = 1
홍보모드방향지시여부 = 0
물건집은상태 = 0
'****Action_mode(초기액션모드)******************
Action_mode = 0	'D(CODE 27):댄스모드
'Action_mode = 1	'F(CODE 32):파이트모드
'Action_mode = 2	'G(CODE 23):게임모드
'Action_mode = 3	'B(CODE 20):축구모드
'Action_mode = 4	'E(CODE 18):장애물경주모드
'Action_mode = 5	'C(CODE 17):카메라모드
'Action_mode = 6	'A(CODE 15):홍보모드



'****초기위치 *****************************
OUT 52,0	'눈 LED 켜기

SPEED 5
GOSUB 전원초기자세
GOSUB 기본자세



GOTO MAIN
'************************************************
'************************************************

MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    모터ONOFF = 0
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

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
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
    '*******기본자세관련*****************************
    '************************************************
전원초기자세:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,100,  45,  90, 100, 100, 100
    MOVE G6C,100,  45,  90, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    자세 = 0

    RETURN
    '************************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    자세 = 0
    물건집은상태 = 0
    RETURN
    '************************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    자세 = 2
    RETURN
    '************************************************
앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    자세 = 1

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
    '******* 피에조 소리 관련 ***********************
    '************************************************


시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
엔터테이먼트음:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
게임음:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
파이트음:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
경고음:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
비프음:
    TEMPO 180
    MUSIC "A"
    DELAY 300

    RETURN
    '************************************************
싸이렌음:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************

축구게임음:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN
    '************************************************

장애물게임음:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN
    '************************************************
    '************************************************
전진달리기50:
    넘어진확인 = 0

    SPEED 12
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_4
    ENDIF


    '**********************

전진달리기50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  78, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진달리기50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT



전진달리기50_3:
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 9600,A, 전진달리기50_4
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    '*********************************

전진달리기50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  78, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진달리기50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT



전진달리기50_6:
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 9600,A, 전진달리기50_1
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤


    GOTO 전진달리기50_1


전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
왼쪽옆으로70:

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
    GOSUB 기본자세
    GOTO RX_EXIT

오른쪽옆으로70:

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
    GOSUB 기본자세
    GOTO RX_EXIT

왼쪽턴20:
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

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO RX_EXIT

왼쪽턴45:

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
    GOSUB 외각선확인
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

오른쪽턴45:

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
    GOSUB 외각선확인
    GOSUB Leg_motor_mode1

    GOTO RX_EXIT
왼쪽턴20:
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

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO RX_EXIT

전진종종10걸음:
    '    넘어진확인 = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 135
    WAIT

    '        GOTO 전진종종걸음_1
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO 전진종종걸음_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 9
전진종종10걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


전진종종10걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종10걸음_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB 앞뒤기울기측정
        '    IF 넘어진확인 = 1 THEN
        '        넘어진확인 = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, 전진종종걸음_4
        '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

        '*********************************

전진종종10걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


전진종종10걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종10걸음_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

전진종종10걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    '보행순서=0
    GOTO RX_EXIT



    '*****************************************************


전진종종2걸음:
    '    넘어진확인 = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 135
    WAIT

    '        GOTO 전진종종걸음_1
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO 전진종종걸음_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 1
전진종종2걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


전진종종2걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종2걸음_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB 앞뒤기울기측정
        '    IF 넘어진확인 = 1 THEN
        '        넘어진확인 = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, 전진종종걸음_4
        '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

        '*********************************

전진종종2걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


전진종종2걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종2걸음_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

전진종종2걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    '보행순서=0
    GOTO RX_EXIT

올려보기:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 60, 100
    WAIT

    GOTO RX_EXIT

계단오른발오르기2cm: 'UPSTAIR GREEN
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
    GOSUB 기본자세
    '보행순서=0
    GOTO RX_EXIT

    '********************************************************

계단왼발내리기2cm:
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

    GOSUB 기본자세
    GOTO RX_EXIT

    '********************************************************








MAIN: '라벨설정


    'GOSUB LOW_Voltage
    'GOSUB 앞뒤기울기측정
    ' GOSUB 좌우기울기측정


    'GOSUB 모터ONOFF_LED

    ERX 9600,A,MAIN
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
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
    GOSUB 전진달리기50
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
    GOTO 왼쪽옆으로70
    'DELAY 1000
    GOTO RX_EXIT
KEY6:
    ETX 9600,6
    GOTO 오른쪽옆으로70
    'DELAY 1000
    GOTO RX_EXIT
KEY7:
    ETX 9600,7
    GOTO 왼쪽턴45
    'DELAY 1000
    GOTO RX_EXIT
KEY8:
    ETX 9600,8
    GOTO 오른쪽턴45
    'DELAY 1000
    GOTO RX_EXIT
KEY9:
    ETX 9600,9
    GOTO 왼쪽턴20
    'DELAY 1000
    GOTO RX_EXIT
KEY10:
    ETX 9600,10
    GOTO 오른쪽턴20
    'DELAY 1000
    GOTO RX_EXIT
KEY11:
    ETX 9600,11
    GOTO 전진종종10걸음
    'DELAY 1000
    GOTO RX_EXIT
KEY12:
    ETX 9600,12
    GOTO 전진종종2걸음
    'DELAY 1000
    GOTO RX_EXIT
KEY13:
    ETX 9600,13
    GOTO 올려보기
    'DELAY 1000
    GOTO RX_EXIT
KEY14:
    ETX 9600,14
    GOTO 계단오른발오르기2cm
    'DELAY 1000
    GOTO RX_EXIT
KEY15:
    ETX 9600,15
    GOTO 계단왼발내리기2cm
    'DELAY 1000
    GOTO RX_EXIT
    END
