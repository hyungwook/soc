'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 보행순서 AS BYTE
DIM 오른쪽보기 AS BYTE



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번 그룹사용 설정
DIR G6B,1,1,1,1,1,1		'모터6~11번 그룹사용 설정
DIR G6C,0,0,0,0,0,0		'모터12~17번 그룹사용 설정
DIR G6D,0,1,1,0,1,0		'모터18~23번 그룹사용 설정

'************************************************
'ZERO G6A, 100,100,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,100,100,100,100
'ZERO G6D, 100,100,100,100,100,100

'****** 로봇1 ***********************************
'ZERO G6A, 101, 100, 97,102,99,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,101,102,100
'
'****** 로봇2 ***********************************
'ZERO G6A, 100, 99, 97,102,101,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,100,102,100
'****** 로봇3 ***********************************
'ZERO G6A,  99, 98,100,101,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 99,100,100,102,100
'****** 로봇4 ***********************************
'ZERO G6A,  99, 99, 98,102,102,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,97,100,100,100
'ZERO G6D,  99,100,100,100,102,100

'****** 로봇5 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,102,100,101,100
'****** 로봇6 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  97, 98,103,100,102,100
'****** 로봇7 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  96,101,102, 97,102,100
'****** 로봇8 ***********************************
'ZERO G6A, 100,100, 99,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  99,99,102,100,103,100
'****** 로봇9 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,100,100,102,100
'****** 로봇10 **********************************
'ZERO G6A, 101, 98,101,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 96,104,100,102,100
'************************************************



'***** 변수 선언*******************************************

보행순서 = 0
'****초기위치 피드백*****************************

'GETMOTORSET G6A,1,1,1,1,1,0
'GETMOTORSET G6B,1,1,1,0,0,0
'GETMOTORSET G6C,1,1,1,0,0,0
'GETMOTORSET G6D,1,1,1,1,1,0


SPEED 5
GOSUB MOTOR_ON
GOSUB MOTOR_READ

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"

GOSUB 기본자세

'GOSUB 세레모니1

'1
'GOSUB 기본자세
'STOP
'GOSUB 앉은자세
'GOSUB 앉은오른쪽턴
'STOP
'GOTO 1

'GOTO 정면팔올리기
GOTO MAIN	'시리얼 수신 루틴으로 가기

'************************************************
MOTOR_READ:
    FOR I = 1 TO 15
        b=MOTORIN(2)
    NEXT I
    RETURN
    '************************************************

MOTOR_ON:
    MOTOR G6A				'모터0~7번 그룹사용 설정
    MOTOR G6B				'모터8~15번 그룹사용 설정
    MOTOR G6C				'모터16~23번 그룹사용 설정
    MOTOR G6D				'모터24~31번 그룹사용 설정
    RETURN
    '************************************************
자세100:
    MOVE G6A,100,  100,  100, 100, 100, 100
    MOVE G6D,100,  100,  100, 100, 100, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT
    RETURN

차렷자세:
    MOVE G6A,100,  56, 182,  78, 100, 100
    MOVE G6D,100,  56, 182,  78, 100, 100
    MOVE G6B,100,  20,  90, 100, 100, 100
    MOVE G6C,100,  20,  90, 100, 100, 100
    WAIT
    mode = 2
    RETURN
기본자세1:
    MOVE G6A,100,  82, 145,  90, 100, 100
    MOVE G6D,100,  82, 145,  90, 100, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN
기본자세:
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100,  30,  80, 100, 125, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

기본자세2:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 190
    MOVE G6C,100,  30,  80, 100, 128, 100
    WAIT
    RETURN

앉은자세:
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

기본100:
    MOVE G6A,100, 100, 100, 100, 100, 100
    MOVE G6B,100, 100, 100, 100, 100, 100
    MOVE G6C,100, 100, 100, 100, 100, 100
    MOVE G6D,100, 100, 100, 100, 100, 100
    WAIT
    RETURN

    '**********************************************
    '**********************************************
전진달리기50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF 보행순서 = 0 THEN
    '    보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  78, 145,  93, 98
    MOVE G6B,100,  30,  80, 	, 100, 100
    MOVE G6C,100,  30,  80, 100, 125, 100
    WAIT

    GOTO 전진달리기50_1
    'ELSE
    '    보행순서 = 0
    '    MOVE G6D,95,  76, 145,  93, 101
    '    MOVE G6A,101,  78, 145,  93, 98
    '    WAIT

    '    GOTO 전진달리기50_4
    'ENDIF


    '**********************

전진달리기50_1:
    FOR I = 0 TO 2
        MOVE G6A,95,  95, 100, 120, 104
        MOVE G6D,104, 78, 146,  91, 102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT
        '	GOTO 전진달리기50_2
        '전진달리기50_2:
        MOVE G6A,95,  75, 122, 120, 104
        MOVE G6D,104, 80, 146,  89, 100
        WAIT
        '    GOTO 전진달리기50_3
        '전진달리기50_3:
        MOVE G6A,103, 70, 145, 103, 100
        MOVE G6D, 95, 88, 160,  68, 102
        WAIT

        'ERX 4800,A, 전진달리기50_4
        'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

        '*********************************
        '	GOTO 전진달리기50_4
        '전진달리기50_4:
        MOVE G6D,95,  95, 100, 120, 104
        MOVE G6A,104, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT
        '   GOTO 전진달리기50_5
        '전진달리기50_5:
        MOVE G6D,95,  75, 122, 120, 104
        MOVE G6A,104, 80, 146,  89, 100
        WAIT

        '    GOTO 전진달리기50_6

        '전진달리기50_6:
        MOVE G6D,103, 70, 145, 103, 100
        MOVE G6A, 95, 88, 160,  68, 102
        WAIT
    NEXT I

    GOTO 전진달리기50_멈춤

전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO MAIN

RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT
    '************************************************

    '******************************************

왼쪽옆으로70:

    '
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
    GOSUB 기본자세
    GOTO MAIN

오른쪽옆으로70:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
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
    GOTO MAIN

왼쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN
왼쪽턴45:

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
    GOSUB 기본자세2
    GOSUB Leg_motor_mode1
    GOTO MAIN

오른쪽턴45:

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
    GOSUB 기본자세2
    GOSUB Leg_motor_mode1

    GOTO MAIN


오른쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN



안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN




MAIN: '라벨설정
    ETX 9600,48

    'GOSUB 앉은자세
    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
MAIN1:
    'GOTO KEY1
    'A=A+1
    'IF A=44 THEN
    'A=0
    ERX 9600,A, MAIN1
    'GOTO 오른쪽턴2
    A_old = A

    ON A GOTO MAIN1,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8
    'GOTO KEY34
    'DELAY 500

    'GOTO 앉아오른팔뻗기

    GOTO MAIN1	
    '*******************************************
    '		MAIN 라벨로 가기
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
    MOVE G6C,100,  30,  80, 100, 100, 100
    'DELAY 1000

    GOTO MAIN
KEY2:
    ETX  9600,2
    GOTO 전진달리기50
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
    오른쪽보기=1
    'DELAY 1000
    GOTO MAIN
KEY5:
    ETX 9600,5
    GOTO 왼쪽옆으로70
    'DELAY 1000
    GOTO MAIN
KEY6:
    ETX 9600,6
    GOTO 오른쪽옆으로70
    'DELAY 1000
    GOTO MAIN
KEY7:
    ETX 9600,7
    GOTO 왼쪽턴45
    'DELAY 1000
    GOTO MAIN
KEY8:
    ETX 9600,8
    GOTO 오른쪽턴45
    'DELAY 1000
    GOTO MAIN

    END
