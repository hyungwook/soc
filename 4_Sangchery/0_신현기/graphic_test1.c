#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <math.h>


#include "amazon2_sdk.h"
#include "graphic_api.h"

#include "uart_api.h"
#include "robot_protocol.h"




#define AMAZON2_GRAPHIC_VERSION		"v0.5"

static struct termios inittio, newtio;

int open_graphic(void);
void close_graphic(void);


static int __uart_dev = -1;


void DelayLoop(int delay_time)
{
	while (delay_time)
		delay_time--;
}


void Send_Command(unsigned char Ldata, unsigned char Ldata1)
{
	unsigned char Command_Buffer[6] = { 0, };

	Command_Buffer[0] = START_CODE;	// Start Byte -> 0xff
	Command_Buffer[1] = START_CODE1; // Start Byte1 -> 0x55
	Command_Buffer[2] = Ldata;
	Command_Buffer[3] = Ldata1;
	Command_Buffer[4] = Hdata;  // 0x00
	Command_Buffer[5] = Hdata1; // 0xff

	uart1_buffer_write(Command_Buffer, 6);
}

int uart_open(void)
{
	int handle;

	if ((handle = open(UART_DEV_NAME, O_RDWR)) < 0) {
		printf("Open Error %s\n", UART_DEV_NAME);
		return -1;
	}

	__uart_dev = handle;

	return 0;
}

void uart_close(void)
{
	close(__uart_dev);
}

int uart_config(int ch, int baud, int bits, int parity, int stops)
{
	struct uart_config uart_conf;

	uart_conf.uart_ch = ch;
	uart_conf.baud = baud;
	uart_conf.bits = bits;
	uart_conf.parity = parity;
	uart_conf.stops = stops;

	return ioctl(__uart_dev, UART_SET_CONFIG, &uart_conf);
}

int uart_tx_buf_full(int ch)
{
	return ioctl(__uart_dev, UART_TXBUF_FULL, ch);
}

int uart_write(int ch, unsigned char *ubuf, int size)
{
	struct uart_data uart_d;

	uart_d.uart_ch = ch;
	uart_d.buf_size = size;
	uart_d.uart_buf = ubuf;

	return ioctl(__uart_dev, UART_DATA_WRITE, &uart_d);
}

int uart_rx_level(int ch)
{
	return ioctl(__uart_dev, UART_RXBUF_LEVEL, ch);
}

int uart_read(int ch, unsigned char *ubuf, int size)
{
	struct uart_data uart_d;

	uart_d.uart_ch = ch;
	uart_d.buf_size = size;
	uart_d.uart_buf = ubuf;

	return ioctl(__uart_dev, UART_DATA_READ, &uart_d);
}

void uart1_buffer_write(unsigned char *buf, int size)
{
	int ret;

	while (uart_tx_buf_full(UART1) == 1);
	ret = uart_write(UART1, buf, size);
	if (ret<0) {
		printf("Maybe UART Buffer is Full!\n");
	}
}

void uart1_buffer_read(unsigned char *buf, int size)
{
	int rx_len = 0;
	int rx_cnt = 0;

	while (1) {
		rx_cnt += rx_len;
		rx_len = uart_rx_level(UART1);
		uart_read(UART1, &buf[rx_cnt], rx_len);
		if (rx_cnt + rx_len >= size) break;
	}
}


void init_console(void)
{
	tcgetattr(0, &inittio);
	newtio = inittio;
	newtio.c_lflag &= ~ICANON;
	newtio.c_lflag &= ~ECHO;
	newtio.c_lflag &= ~ISIG;
	newtio.c_cc[VMIN] = 1;
	newtio.c_cc[VTIME] = 0;

	cfsetispeed(&newtio, B115200);

	tcsetattr(0, TCSANOW, &newtio);
}

int main(void)
{
	int i = 0, j = 0, k = 0, l = 0, cnt = 0, line = 0;
	int state_1 = 0;
	int stage = 1;
	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	//	float point_h = 0.0f, point_s = 0.0f, point_v = 0.0f; //중앙점의 hsv값
	float delta,degree=0;
	char input;
	int hue_min = 45, hue_max = 70, sat_min = 2;
	unsigned char tmpchar;
	int ret, face = 0;
	int b_loop = 0;
	int sum_left = 0, sum_right = 0;
	int sum_i = 0, sum_j = 0;
	int sum1 = 0, sum2 = 0, sum3 = 0;
	int cnt0 = 0, cnt1 = 0;
	float first_x = 0, first_y = 0, second_x = 0, second_y = 0, outline_x = 0, outline_y = 0;
	int result = 0;
	
	int motion2 = 0;

	SURFACE* bmpsurf = 0;
	U16* fpga_videodata = (U16*)malloc(180 * 120 * 2);
	U16* lcd = (U16*)malloc(180 * 120 * 2);
	U16* gray = (U16*)malloc(180 * 120 * 2);

	float* hue_joon = (float*)malloc(180 * 120 * 4);
	float* satur_tmp = (float*)malloc(180 * 120 * 4);
	float* v_compare = (float*)malloc(180 * 120 * 4);
	float* s_temp = (float*)malloc(180 * 120 * 4);
	int* rgb = (int*)malloc(180 * 120 * 4);
	float* red = (float*)malloc(180 * 120 * 4);
	float* green = (float*)malloc(180 * 120 * 4);
	float* blue = (float*)malloc(180 * 120 * 4);
	int* xxx = (int*)malloc(180 * 120 * 4);
	int* out_i = (int*)malloc(180 * 120 * 4);
	int* out_j = (int*)malloc(180 * 120 * 4);



	float Mask[9] = { 0 };
	float Mask1[9] = { 0 };//마스크하기 위한 변수
	int index1 = 0, index2 = 0, index3 = 0;


	init_console();

	ret = uart_open();
	if (ret < 0) return EXIT_FAILURE;

	uart_config(UART1, 9600, 8, UART_PARNONE, 1);

	if (open_graphic() < 0) {
		return -1;
	}

	printf("press the 'x' button to off display\n");   // 코드 추가
	printf("press the 'z' button to on display\n");      // 코드 추가
	scanf("%c", &input);

	if (input == 'x')
	{
		b_loop = 1;
		printf("press the 'a' button to enter values\n"); // 코드 추가
	}
	if (input == 'z') // 코드 추가
		direct_camera_display_on();

	while (b_loop)
	{
		direct_camera_display_off();


		while (1)
		{

		read_fpga:
			printf("read_fpga\n");
			read_fpga_video_data(fpga_videodata);


			for (i = 0; i<180 * 120; i++)
			{

				b = ((*(fpga_videodata + i)) & 31);
				g = (((*(fpga_videodata + i)) >> 6) & 31);
				r = (((*(fpga_videodata + i)) >> 11) & 31);

				*(rgb + i) = b + g + r; //rgb값의 합

				int graay = (int)(b + g + r) / 3;
				int gray1 = (graay << 11);
				int gray2 = (graay << 6);
				*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정

				*(red + i) = r;
				*(green + i) = g;
				*(blue + i) = b;



				if (r>g)
					if (r>b)
					{
						max = r;
						min = g>b ? b : g;
					}
					else
					{
						max = b;
						min = g;
					}
				else
					if (g>b)
					{
						max = g;
						min = r>b ? b : r;
					}
					else
					{
						max = b;
						min = r;
					}

				delta = max - min;
				vf = (r + g + b) / 3.0f;                  // 명도(V) = max(r,g,b)
				sf = (max != 0.0F) ? delta / max : 0.0F;   // 채도(S)을 계산, S=0이면 R=G=B=0

				if (sf == 0.0f)
					hf = 0.0f;
				else
				{
					// 색상(H)를 구한다.
					if (r == max) hf = (g - b) / delta;     // 색상이 Yello와 Magenta사이 
					else if (g == max) hf = 2.0F + (b - r) / delta; // 색상이 Cyan와 Yello사이 
					else if (b == max) hf = 4.0F + (r - g) / delta; // 색상이 Magenta와 Cyan사이
				}
				hf *= 57.295F;
				if (hf < 0.0F) hf += 360.0F;           // 색상값을 각도로 바꾼다.
				*(hue_joon + i) = hf;      //0 ~ 360
				sf = sf * 100;
				*(satur_tmp + i) = sf;   //0 ~ 32
				*(v_compare + i) = vf;   //0 ~ 31
				*(s_temp + i) = *(satur_tmp + i);

			}
			switch (k)
			{
			case 1:
				k = 0;
				goto stage1;
			
			}

			/*
			/////////////////////마스크 추가///////////////////////////
			printf("mask start\n"); // 외곽선추출
			int n = 1;

			Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
			Mask[3] = -1.0f; Mask[4] = 8.0f; Mask[5] = -1.0f;
			Mask[6] = -1.0f; Mask[7] = -1.0f; Mask[8] = -1.0f;

			Mask1[0] = 1.0f; Mask1[1] = 1.0f; Mask1[2] = 1.0f;
			Mask1[3] = 0.0f; Mask1[4] = 0.0f; Mask1[5] = 0.0f;
			Mask1[6] = -1.0f; Mask1[7] = -1.0f; Mask1[8] = -1.0f;

			for (i = n; i < 120 - n; i++){
			index1 = i * 180;
			for (j = n; j < 180 - n; j++){
			float sum1 = 0.0f;
			float sum2 = 0.0f;

			for (k = -n; k <= n; k++){
			index2 = (i + k) * 180;
			index3 = (k + n) * 3;
			for (l = -n; l <= n; l++){
			sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
			//sum2 += gray[index2 + (j + l)] * Mask1[index3 + l + n];
			}
			}
			*(lcd + i * 180 + j) = sum1 ;
			}
			}
			printf("mask end\n");

			//////////////////////////////////////////////////////////
			*/

			cnt = 0;
			int m = 0;
			float grad = 0;

			for (i = 0; i<120; i++)
			{

				for (j = 0; j<180; j++){

					*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);


					if (((int)*(red + i * 180 + j) >17) && ((int)*(green + i * 180 + j) >17) && ((int)*(blue + i * 180 + j) > 17) && ((int)*(v_compare + i * 180 + j) > 20))
						*(xxx + i * 180 + j) = 1;//흰색을표시

					else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						*(xxx + i * 180 + j) = 2;//검정을표시

					else if (((int)*(red + i * 180 + j) > 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(blue + i * 180 + j) < 15) && ((((int)*(hue_joon + i * 180 + j) > 300)) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시

					else if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 50) && ((int)*(hue_joon + i * 180 + j) < 80))
						*(xxx + i * 180 + j) = 4;//노랑을표시

					else if (((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) > 15) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 120))
						*(xxx + i * 180 + j) = 5;//초록을표시

					else if (((int)*(red + i * 180 + j) < 17) && ((int)*(green + i * 180 + j) < 17) && ((int)*(blue + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 270))
						*(xxx + i * 180 + j) = 6;//파랑을표시

					else
						*(xxx + i * 180 + j) = 7;//나머지

					/*
					if (i == 60)
					{
					*(lcd + i * 180 + j) = 0x7000;//lcd에 가로줄 빨간줄 표시코드
					if (j == 90)
					{
					printf("hue: %.1f  sat: %.1f v_: %.1f\n", *(hue_joon + i * 180 + j), *(s_temp + i * 180 + j), *(v_compare + i * 180 + j));
					printf("red : %d, green : %d, blue : %d\n", (int)*(red + i * 180 + j), (int)*(green + i * 180 + j), (int)*(blue + i * 180 + j));
					}

					}
					if (j == 90)
					*(lcd + i * 180 + j) = 0x7000;//lcd에 세로줄 빨간줄 표시코드
					*/
				}


			}

			/*
			for (i = 0; i < 120; i++)
			{
			for (j = 0; j < 180; j++){

			if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1)) == 3) *(lcd + i * 180 + j) = 0x7000;
			else if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j)) == 3) *(lcd + i * 180 + j) = 0x7000;
			else if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1)) == 3) *(lcd + i * 180 + j) = 0x7000; // 흰색과 검정 경계면일경우를 얘기함

			else *(lcd + i * 180 + j) = 0;
			}
			}
			*/

			
			////////////////////////외곽선(로봇중앙맞추기)///////////////////////
			if (stage == 0)
			{
				result = 0;
				cnt0 = 0;
				sum_left = 0;
				sum_right = 0;
				int firstx = 0, firsty = 0, secondx = 0, secondy = 0;
				if (face == 0)
				{
					Send_Command(0x04, 0xfb);
					DelayLoop(100000);
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					face = 1;//오
				}

				else if (face == 1)
				{
					for (j = 30; j < 150; j++)
					{
						for (i = 119; i >= 0; i--)
						{
							if (j < 90)
								sum_left++;
							else
								sum_right++;

							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 3)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 3))
							{
								*(out_i + cnt0) = i;
								*(out_j + cnt0) = j;
								cnt0++;
								*(lcd + i * 180 + j) = 0x7000;

							}
							else
								*(lcd + i * 180 + j) = 0;

							if (*(xxx + 180 * i + j) == 2)
								break;
						}
					}
					firsty = 0;
					firstx = 0;
					secondy = 0;
					secondx = 0;
					for (i = 0; i < 10; i++)
					{
						firsty += *(out_i + cnt0 / 2 - 20 + i);
						firstx += *(out_j + cnt0 / 2 - 20 + i);
						secondy += *(out_i + cnt0 / 2 + 10 + i);
						secondx += *(out_j + cnt0 / 2 + 10 + i);
					}
					first_y = firsty / 10;
					first_x = firstx / 10;
					second_y = secondy / 10;
					second_x = secondx / 10;


					outline_y = second_y - first_y;
					outline_x = second_x - first_x;
					degree = atan2(outline_y, outline_x) * 180 / 3.14;

					printf("%.2f\n", degree);

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();


					if (degree > 45 && degree < 90)
					{
						//Send_Command(0x07, 0xf8);
						DelayLoop(100000000);
						printf("turn left\n");

					}
					else if (degree < -45 && degree > -90)
					{
						//Send_Command(0x08, 0xf7);
						DelayLoop(100000000);
						printf("turn right\n");

					}
					else if (degree > 15 && degree < 45)
					{
						//Send_Command(0x09, 0xf6);
						DelayLoop(100000000);
						printf("turn left little\n");
					}
					else if (degree < -15 && degree > -45)
					{
						//Send_Command(0x0a, 0xf5);
						DelayLoop(100000000);
						printf("turn right little\n");
					}
					else
						result++;

					if (result == 1)
					{
						if (sum_left + sum_right < 2000)
						{//오른쪽을 봤을 때 흰색이 적게 보이면 왼쪽으로 이동
							//Send_Command(0x05, 0xfa);
							DelayLoop(100000000);
							printf("go left\n");

						}
						else if (sum_left + sum_right > 19000)
						{//오른쪽을 봤을 때 흰색이 많이 보이면 오른쪽으로 이동
							//Send_Command(0x06, 0xf9);
							DelayLoop(100000000);
							printf("go right\n");
						}
						else
							result++;
					}

					if (result == 2)
					{
						//Send_Command(0x02, 0xfd);
						DelayLoop(100000000);
						face = 0;
						printf("Go\n");
					}

				}

			}

			////////////////////////////////////////////////////////////////
			

			
			///////////////////// 1번째 장애물 /////////////////////////////
			//앞만 보고 가다가 파란 픽셀이 화면에 많이 잡히면 stop
			//고개를 숙이고 파란 픽셀의 평균값을 확인 후 좌우로 이동
			//고개를 숙인 채로 가운데값을 찾으면 앞으로 다시 이동
			if (stage == 1)
			{
				int aver = 0;
				cnt1 = 0;
				sum1 = 0;
				sum2 = 0;

				for (i = 60; i < 120; i++)
					for (j = 30; j < 150; j++)
						if (*(xxx + 180 * i + j) == 6)//파란색일 때 
						{
							sum1 = sum1 + j;
							cnt1++;
							*(lcd + i * 180 + j) = 0xFFFF;
						}
				sum1 = sum1 / (cnt1 + 1);
				printf("sum1 : %d\n", sum1);
				printf("cnt1 : %d\n", cnt1);

				//cnt1값이 커지면 멈추고 외곽선을 이용해서 몸의 평형으로 맞춤
				//그리고 고개를 올림
				if (cnt1 > 800)
				{
					printf("up start\n");
					Send_Command(0x0d, 0xf2);//고개들기
					
					DelayLoop(80000000);
					printf("up end\n");
					k = 1;
					goto read_fpga;
				stage1:
					printf("stage1\n");
					
					aver = 0;
					cnt1 = 0;
					sum2 = 0;
					sum3 = 0;
					for (i = 0; i < 120; i++)
					{
						
						for (j = 0; j < 180; j++)
						{
							
							if (*(xxx + 180 * i + j) == 6)
							{
								cnt1++;
								sum2 = sum2 + j;
							}

						}

						if (cnt1 > 25)
						{
							aver = aver + cnt1;
							sum3 = sum3 + sum2;
							cnt1 = 0;
							sum2 = 0;
						}
						else
						{
							sum2 = 0;
							cnt1 = 0;
						}
					}

					sum3 = sum3 / (aver + 1);
					//printf("sum1 : %d sum2 : %d\n", sum1,sum2);
					printf("aver : %d  sum3 : %d\n",aver, sum3);
					
					if (sum3>90 && sum3<200)
					{
					printf("right\n");
					Send_Command(0x06, 0xf9);//오른쪽으로 한걸음
					DelayLoop(80000000);
					Send_Command(0x06,0xf9);
					DelayLoop(80000000);
					}

					else if (sum3<90)//왼쪽에 파란픽셀이 많을 때
					{
					printf("left\n");
					Send_Command(0x05, 0xfa);//왼쪽으로 한걸음
					DelayLoop(80000000);
					Send_Command(0x05, 0xfa);
					DelayLoop(80000000);
					}
					

				}

			}
			///////////////////////////////////////////////////////////////
			

			/*
			///////////////////// 2번째 장애물 /////////////////////////////  ***i값 나중에 추가!***
			int cnt2 = 0;
			for (i = 0; i < 120; i++)
			{
				for (j = 0; j < 180; j++)
				{
					if (((*(xxx + i * 180 + j) - *(xxx + i * 180 + j + 1)) == 2) && *(xxx + i * 180 + j) == 4)
					{
						cnt2++;
						*(lcd + 180 * i + j) = 0x7000;
					}
					else
						*(lcd + 180 * i + j) = 0x0000;
				}
			}

			if (cnt2 > 50)
				motion2 = 1;//멈춰

			if (motion2 == 1)
			{
				if (cnt2 < 50)
					motion2 = 2;//가

			}

			if (motion2 == 1)
			{
				printf("STOP!!!!!!!!!!!!!!\n");
				Send_Command(0x04, 0xfb);
				DelayLoop(1000000);
			}

			else if (motion2 == 2 || motion2 == 0)
			{
				printf("GOGOGOGOGO!!!!!!!!!!!\n");
				Send_Command(0x03, 0xfc);
				DelayLoop(200000);

			}

			///////////////////////////////////////////////////////////////
			*/





			//printf("%f \n",*(h+180*60+90));
			//printf("%f %f %f \n",r, g, b);


			//printf("Full < Expension(x2.66), Rotate(90) > (320 x 480)\n");
			//printf("%d\n", cnt);
			//draw_img_from_buffer(lcd, 320, 0, 0, 0, 2.67, 90);
			draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
			draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
			flip();
		}

	}



	//TestItemSelectRobot();

	free(fpga_videodata);
	free(lcd);
	free(hue_joon);
	free(satur_tmp);
	free(v_compare);
	free(s_temp);
	free(xxx);

	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}