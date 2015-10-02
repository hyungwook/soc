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
	if (ret < 0) {
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
	SURFACE* bmpsurf = 0;
	U16* fpga_videodata = (U16*)malloc(180 * 120 * 2);
	U16* lcd = (U16*)malloc(180 * 120 * 2);
	U16* gray = (U16*)malloc(180 * 120 * 2);

	float* hue_joon = (float*)malloc(180 * 120 * 4);
	float* satur_tmp = (float*)malloc(180 * 120 * 4);
	float* v_compare = (float*)malloc(180 * 120 * 4);

	float* red = (float*)malloc(180 * 120 * 4);
	float* green = (float*)malloc(180 * 120 * 4);
	float* blue = (float*)malloc(180 * 120 * 4);

	int* xxx = (int*)malloc(180 * 120 * 4);
	int* out_i = (int*)malloc(180 * 120 * 4);
	int* out_j = (int*)malloc(180 * 120 * 4);
	int* st4_green = (int*)malloc(180 * 120 * 4);
	int* st6_red = (int*)malloc(180 * 120 * 4);

	int i = 0, j = 0, k = 0, l = 0;
	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	int ret,delta;
	char input;
	int b_loop = 0;
	int stage = 100;
	//외곽선
	int first_out = 0;
	int r_sum_left = 0, r_sum_right = 0;
	int l_sum_left = 0, l_sum_right = 0;
	int r_sum = 0, l_sum = 0;
	int cnt0 = 0;
	int motion1 = 0;
	float first_x = 0, first_y = 0, second_x = 0, second_y = 0, outline_x = 0, outline_y = 0;
	int firstx = 0, firsty = 0, secondx = 0, secondy = 0;
	int result = 0;
	double degree = 0;
	int go = 0;
	//파란장애물
	int cnt = 0, cnt1 = 0;
	int cnt_st1 = 0;
	int motion0 = 0;
	int stop = 0;
	int blue_up = 0, blue_right = 0, blue_left = 0, blue_center = 0;
	//바리케이트
	int motion2 = 0, cnt2 = 0;
	//허들
	int cnt3 = 0, motion3 = 0;
	int cnt_st3 = 0;
	int st3_right = 0, st3_left = 0;
	//초록계단
	int cnt4 = 0, motion4 = 0, st4_av_i = 0, st4_sum_i = 0, cnt4_b_w = 0, cnt4_green = 0;
	int st4_left = 0, st4_right = 0, green4_l = 0, green4_r = 0,cnt_st4=0;
	//골프공
	//빨간계단
	int cnt6 = 0, motion6 = 0, st6_sum_i = 0, st6_av_i = 0;
	int red6_l = 0, red6_r = 0,cnt6_red = 0,cnt_st6=0;
	int st6_left = 0, st6_right = 0;
	//바리케이트2
	int cnt7 = 0, motion7 = 0;


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

		OUTLINE:
			if (first_out == 1)//제일처음에 한번 무시하기위해서
			{
				if (motion1 == 0)//오른쪽고개돌리기 및 초기화
				{
					printf("start\n");
					r_sum_left = 0, r_sum_right = 0;
					r_sum = 0;
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					DelayLoop(40000000);

					read_fpga_video_data(fpga_videodata);

					for (i = 0; i < 180 * 120; i++)
					{
						b = ((*(fpga_videodata + i)) & 31);
						g = (((*(fpga_videodata + i)) >> 6) & 31);
						r = (((*(fpga_videodata + i)) >> 11) & 31);

						int graay = (int)(b + g + r) / 3;
						int gray1 = (graay << 11);
						int gray2 = (graay << 6);
						*(gray + i) = gray1 + gray2 + graay; // 그레이하는과정

						*(lcd + i) = *(fpga_videodata + i);
					}

					motion1 = 1;
					goto OUTLINE;
				}
		

				else if (motion1 == 1)//오른쪽에서 영상처리 값따기(r_sum_right, r_sum_left)
				{
					int n = 1;
					r_sum_left = 0, r_sum_right = 0;
					
					Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
					Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
					Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

					//Mask1[0] = -1.0f; Mask1[1] = 0.0f; Mask1[2] = 1.0f;
					//Mask1[3] = -1.0f; Mask1[4] = 0.0f; Mask1[5] = 1.0f;
					//Mask1[6] = -1.0f; Mask1[7] = 0.0f; Mask1[8] = 1.0f;
					
						for (j = 88 - n; j > n; j--){
							//index1 = i * 180;
							for (i = 120 - n; i > n; i--){
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
								
								if (sum1 > 65530){
									*(lcd + i * 180 + j) = 0xffff;
									break;

								}

								else{
									*(lcd + i * 180 + j) = 0x0000;
									if (j >= 44)
										r_sum_right++;
									else
										r_sum_left++;
								}
							}
						}

						r_sum = r_sum_left + r_sum_right;
						printf("sum : %d  right : %d  left : %d\n", r_sum, r_sum_right, r_sum_left);

					//printf("%d\n", cnt_mask);
					printf("mask end\n");
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					motion1 = 2;
					goto OUTLINE;
				}
				
				else if (motion1 == 2)//거리 비교
				{					
					go = 0;
					if (r_sum<6500) // 왼쪽으로 한걸음 가야할듯
					{
						printf("Go Left!\n");
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(40000000);
					}
					else if (r_sum > 7500) // 오른쪽으로 한걸음 가야할듯
					{
						printf("Go Right!\n");
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(40000000);
					}
					else
						go += 1;

					if (r_sum_left > r_sum_right + 400) // 오른쪽으로 돌아야함
					{
						printf("Turn Right!\n");
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						Send_Command(0x0a, 0xf5);
						DelayLoop(40000000);

						motion1 = 0;
						goto OUTLINE;

					}
					else if (r_sum_right > r_sum_left + 300) // 왼쪽으로 돌아야함
					{
						printf("Turn Left!\n");
						Send_Command(0x09, 0xf6);
						Send_Command(0x09, 0xf6);
						Send_Command(0x09, 0xf6);
						DelayLoop(40000000);

						motion1 = 0;
						goto OUTLINE;
					}
					else{
						go += 1;
						motion1 = 0;
						if (go == 2) // 이제 가자
						{
							printf("GoGo\n");
							Send_Command(0x0c, 0xf3);
							Send_Command(0x0c, 0xf3);
							Send_Command(0x0c, 0xf3);
							DelayLoop(40000000);

							motion1 = 0;
							goto GOUP;
						}
						goto OUTLINE;
					}
										
				}
				
			}

			////////////////////////////////////////////////////////////////

		GOUP:

			read_fpga_video_data(fpga_videodata);			

			for (i = 0; i < 180 * 120; i++)
			{

				b = ((*(fpga_videodata + i)) & 31);
				g = (((*(fpga_videodata + i)) >> 6) & 31);
				r = (((*(fpga_videodata + i)) >> 11) & 31);

				*(red + i) = r;
				*(green + i) = g;
				*(blue + i) = b;
				
				if (r > g)
					if (r > b)
					{
						max = r;
						min = g > b ? b : g;
					}
					else
					{
						max = b;
						min = g;
					}
				else
					if (g > b)
					{
						max = g;
						min = r > b ? b : r;
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
			
			}

			for (i = 0; i < 120; i++)
				for (j = 0; j < 180; j++)
					*(lcd + i * 180 + j) = *(fpga_videodata + i * 180 + j);

					/*///////////////////////////색깔 조건
					if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20) && ((int)*(v_compare + i * 180 + j) > 22))
						*(xxx + i * 180 + j) = 1;//흰색을표시

					else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10) && ((int)*(v_compare + i * 180 + j) < 10))
						*(xxx + i * 180 + j) = 2;//검정을표시

					else if (((int)*(red + i * 180 + j) > 15) && ((int)*(green + i * 180 + j) < 15) && ((int)*(blue + i * 180 + j) < 15) && ((((int)*(hue_joon + i * 180 + j) > 300)) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시
					else if ((*(green + i * 180 + j) < *(red + i * 180 + j)) && (*(blue + i * 180 + j) < *(red + i * 180 + j)) && (((int)*(hue_joon + i * 180 + j) > 300) || ((int)*(hue_joon + i * 180 + j) < 60)))
						*(xxx + i * 180 + j) = 3;//빨강을표시

					else if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 40) && ((int)*(hue_joon + i * 180 + j) < 90))
						*(xxx + i * 180 + j) = 4;//노랑을표시

					else if (((int)*(red + i * 180 + j) < 15) && ((int)*(green + i * 180 + j) > 15) && ((int)*(blue + i * 180 + j) < 15) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
						*(xxx + i * 180 + j) = 5;//초록을표시
					else if ((*(red + i * 180 + j) < *(green + i * 180 + j)) && (*(blue + i * 180 + j) < *(green + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 80) && ((int)*(hue_joon + i * 180 + j) < 150))
						*(xxx + i * 180 + j) = 5;//초록을표시

					else if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250) && *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 20))
						*(xxx + i * 180 + j) = 6;//파랑을표시

					else
						*(xxx + i * 180 + j) = 7;//나머지
					*/	
			
			///////////////////// 1번째 장애물 ///////////////////////////// 
			if (stage == 1)
			{
				//첫번째 바리케이트
				printf("stage=%d\n", stage);
				cnt2 = 0;
				for (i = 0; i < 100; i++)
				{
					for (j = 20; j < 160; j++)
					{
						*(lcd + 180 * i + j) = 0x0000;
						//노란색
						if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15)
							&& ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 40) && ((int)*(hue_joon + i * 180 + j) < 90))
						{
							cnt2++;
							*(lcd + 180 * i + j) = 0xf000;
						}

					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				printf("cnt2=%d\n", cnt2);


				if (motion2 == 0)
				{
					printf("slow go1!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(75000000);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(75000000);

					motion2 = 1;
					goto GOUP;
				}

				else if (motion2 == 1)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 > 50)
						motion2 = 2;//멈춰
					goto GOUP;
				}

				else if (motion2 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt2 < 50)
						motion2 = 3;//가
					goto GOUP;
				}

				else if (motion2 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");

					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(50000000);

					stage = 2;
					first_out = 1;
					goto OUTLINE;

				}
			}

			///////////////////////////////////////////////////////////////


			/////////////////////// 2번째 장애물 //////////////////////
			else if (stage == 2)
			{
				//빨간 계단 장애물
				cnt6 = 0, st6_sum_i = 0, st6_av_i = 0, cnt6_red = 0;
				red6_l = 0, red6_r = 0;
				st6_left = 0, st6_right = 0;

				for (i = 80; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{
						if (*(xxx + 180 * i + j) == 3)
						{
							if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j + 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j + 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * i + j - 1) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j) == 4)
								|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i - 1) + j - 1) == 4))//흰빨일 경우
							{
								//*(lcd + 180 * i + j) = 0x000f;
								*(st6_red + cnt6) = i;
								cnt6++;

							}
							//else
							//*(lcd + 180 * i + j) = 0xffff;
						}
					}
				}
				for (i = 90; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{
						if (*(xxx + 180 * i + j) == 3)
						{
							cnt6_red++;
							*(lcd + 180 * i + j) = 0x000f;
						}
					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				for (i = 0; i < cnt6; i++)
				{
					st6_sum_i += *(st6_red + i);
				}

				st6_av_i = st6_sum_i / cnt6;

				printf("cnt6=%d\n", cnt6);
				printf("cnt6_red=%d\n", cnt6_red);
				printf("st6_av_i=%d\n", st6_av_i);

				for (i = 0; i < 120; i++) // 빨간색에서 균형잡기
				{
					for (j = 0; j < 180; j++)
					{
						if (*(xxx + 180 * i + j) == 3)
						{
							if (j < 70)
								st6_left++;
							else
								st6_right++;
						}
					}
				}

				if (cnt_st6 == 10)
				{
					motion6 = 6;
					cnt_st6++;
					goto GOUP;
				}

				if (motion6 == 0)
				{
					if (st6_av_i >85 && cnt6 > 32)
					{
						printf("command up!\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(100000000);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(100000000);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(30000000);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(30000000);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(30000000);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(30000000);

						printf("Walk End!\n");

						//총총걸음 한 10걸음? 하다가 계단오르기!!!!! 로직으로
						motion6 = 6;
						goto GOUP;

					}
					
					else
					{
						printf("no!\n");
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(30000000);
						cnt_st6++;
						goto GOUP;
					}
				}

				else if (motion6 == 6)
				{
					if (st6_left > st6_right + 600)
					{
						Send_Command(0x16, 0xe9);
						Send_Command(0x16, 0xe9);
						Send_Command(0x16, 0xe9);
						DelayLoop(50000000);
						motion6 = 6;
						goto GOUP;
					}
					else if (st6_right > st6_left + 600)
					{
						Send_Command(0x17, 0xe8);
						Send_Command(0x17, 0xe8);
						Send_Command(0x17, 0xe8);
						DelayLoop(50000000);
						motion6 = 6;
						goto GOUP;
					}
					else
					{
						motion6 = 1;
						goto GOUP;
					}
				}

				else if (motion6 == 1)
				{
					printf("up\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(250000000);
					Send_Command(0x13, 0xec);
					Send_Command(0x13, 0xec);
					Send_Command(0x13, 0xec);//오르기
					DelayLoop(250000000);
					motion6 = 2;
					goto GOUP;
				}

				else if (motion6 == 2)
				{
					st6_left = 0, st6_right = 0;
					for (i = 0; i < 80; i++) // 빨간색에서 균형잡기
					{
						for (j = 0; j < 180; j++)
						{
							if (*(xxx + 180 * i + j) = 3)
							{
								if (j < 70)
									st6_left++;
								else
									st6_right++;
							}
						}
					}



					/*
					if (st6_left > st6_right + 2000)
					{
					printf("go left\n");
					Send_Command(0x16, 0xe9);
					Send_Command(0x16, 0xe9);
					Send_Command(0x16, 0xe9);
					DelayLoop(50000000);



					goto GOUP;
					}
					else if (st6_right > st6_left + 2000)
					{
					printf("go right\n");

					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					Send_Command(0x17, 0xe8);
					DelayLoop(50000000);

					goto GOUP;
					}
					*/


					printf("center!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);//바닥보고 총총걸음(이건 한~두걸음씩)
					DelayLoop(75000000);

					if (cnt6_red < 125)
					{
						printf("Command Down!\n");
						motion6 = 3;
						goto GOUP;
					}
					else
					{
						printf("nono\n");
						goto GOUP;
					}
					goto GOUP;


				}


				else if (motion6 == 3)
				{
					printf("GoDown!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(100000000);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(100000000);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(100000000);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(100000000);

					motion6 = 4;
					goto GOUP;

				}

				else if (motion6 == 4)
				{
					printf("Down!\n");


					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					Send_Command(0x14, 0xeb);
					DelayLoop(125000000);
					motion6 = 5;
					goto GOUP;
				}
				else if (motion6 == 5)
				{
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(250000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(250000000);
					stage = 3;
					goto OUTLINE;
				}


			}

			//////////////////////////////////////////////////////////



			
			/////////////////////// 3번째 장애물 /////////////////////////////
			else if (stage == 3)
			{
				//허들 장애물
				first_out = 1;
				cnt3 = 0;
				st3_left = 0, st3_right = 0;

				for (i = 60; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{

						if (*(xxx + 180 * i + j) == 6)//파랑일 경우
						{
							*(lcd + 180 * i + j) = 0xf000;

							cnt3++;
						}

					}
				}

				for (i = 60; i < 120; i++)
				{
					for (j = 20; j < 160; j++)
					{
						if (*(xxx + 180 * i + j) == 6)//파랑일 경우
						{
							if (j < 95)
								st3_left++;
							else
								st3_right++;
						}
					}
				}
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				printf("cnt3=%d\n", cnt3);

				if (cnt3 > 300)
				{
					printf("Command, 10 walk\n");
					if (st3_left>st3_right + 300)
					{
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(50000000);
					}
					else if (st3_right > st3_left + 300)
					{
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(50000000);
					}

					motion3 = 1;
				}

				if (cnt_st3 == 10)
				{
					motion3 = 1;
					cnt_st3++;
				}

				if (motion3 == 0)
				{
					printf("slow go!\n");
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(30000000);
					cnt_st3++;
					goto GOUP;
				}
				else if (motion3 == 1)
				{
					printf("10walk\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(100000000);

					motion3 = 2;
					goto GOUP;
				}
				else if (motion3 == 2)
				{

					printf("10walk,one more\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(100000000);
					motion3 = 3;
					goto GOUP;
				}

				else if (motion3 == 3)
				{
					printf("jump\n");
					Send_Command(0x10, 0xef);
					Send_Command(0x10, 0xef);
					Send_Command(0x10, 0xef);
					DelayLoop(400000000);
					motion3 = 4;
					goto GOUP;
				}
				else if (motion3 == 4)
				{
					printf("GO,and turn!\n");
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(150000000);
					
					printf("Turn1\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(80000000);
					printf("Turn2\n");
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					Send_Command(0x07, 0xf8);
					DelayLoop(80000000);
					
					printf("GO!\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(150000000);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(150000000);

					stage = 4;
					
					goto OUTLINE;
				}
			}

			/////////////////////////////////////////////////////////////////
			
			///////////////////// 4번째,7번째 장애물 /////////////////////////////
			else if (stage == 100 || stage == 7)
			{
				//first_out = 1;
				//goto OUTLINE;
				//파란 장애물
				if (motion0 == 0)
				{
					cnt1 = 0;
					blue_right = 0;
					blue_left = 0;
					blue_center = 0;
					for (i = 60; i < 120; i++)
					{
						for (j = 0; j < 180; j++)
						{
							*(lcd + i * 180 + j) = 0x0000;
							if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && (*(blue + i * 180 + j)>10)
								&& ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250)
								&& *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 15))//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
							{
								cnt1++;
								blue_center += j;
								*(lcd + i * 180 + j) = 0x001f;
							}
						}

					}
					for (i = 0; i < 60; i++){
						for (j = 0; j < 10; j++)
						{
							*(lcd + i * 180 + j) = 0x0000;
							if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && (*(blue + i * 180 + j)>10)
								&& ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250)
								&& *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 15))//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
							{
								blue_left++;
								blue_center += j;
								*(lcd + i * 180 + j) = 0x001f;
							}
						}
						for (j = 170; j < 180; j++)
						{
							*(lcd + i * 180 + j) = 0x0000;
							if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j)) && (*(blue + i * 180 + j)>10)
								&& ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250)
								&& *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 15))//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
							{
								blue_right++;
								blue_center += j;
								*(lcd + i * 180 + j) = 0x001f;
							}
						}

					}
					
					blue_center = blue_center/(cnt1 + 1);

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					printf("cnt1 : %d %d\n", cnt1, blue_right+blue_left);
				if (blue_right > 100){
					Send_Command(0x05, 0xfa);
					Send_Command(0x05, 0xfa);
					Send_Command(0x05, 0xfa);
					DelayLoop(75000000);

					Send_Command(0x05, 0xfa);
					Send_Command(0x05, 0xfa);
					Send_Command(0x05, 0xfa);
					DelayLoop(75000000);

					motion0 = 2;
					goto GOUP;
				}
				else if (blue_left > 100){
					Send_Command(0x06, 0xf9);
					Send_Command(0x06, 0xf9);
					Send_Command(0x06, 0xf9);
					DelayLoop(75000000);

					Send_Command(0x06, 0xf9);
					Send_Command(0x06, 0xf9);
					Send_Command(0x06, 0xf9);
					DelayLoop(75000000);

					motion0 = 2;
					goto GOUP;
				}
					else if (cnt1 > 800)//앞에 파란장애물 보일 때
					{
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						DelayLoop(55000000);//고개올리기
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						Send_Command(0x0d, 0xf2);
						DelayLoop(55000000);//고개올리기
						printf("down\n");
						motion0 = 1;
					}
					
					else{
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);//종종
						DelayLoop(75000000);
					}

					goto GOUP;

				}
			
				else if (motion0 == 1){
					blue_left = 0;
					blue_right = 0;
					for (i = 0; i < 60; i++)
					{
						for (j = 0; j < 180; j++)
						{
							*(lcd + i * 180 + j) = 0x0000;

							if ((*(red + i * 180 + j) < *(blue + i * 180 + j)) && (*(green + i * 180 + j) < *(blue + i * 180 + j))
								&& ((int)*(hue_joon + i * 180 + j) > 180) && ((int)*(hue_joon + i * 180 + j) < 250)
								&& *(satur_tmp + i * 180 + j) > 30 && ((int)*(v_compare + i * 180 + j) < 20))//파란색 발견하면 cnt1증가 가로축j의 합을 sum2에 저장
							{
								*(lcd + i * 180 + j) = 0x001f;
								
								if (j > 90)
									blue_left++;
								else
									blue_right++;
							}
						}

					}

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();
					printf("%d %d\n", blue_left, blue_right);
					if (blue_right > blue_left){//왼쪽으로 한걸음
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(75000000);

						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(75000000);

						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						Send_Command(0x05, 0xfa);
						DelayLoop(75000000);
					}

					else{
						Send_Command(0x06, 0xf9);//오른쪽으로 한걸음
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(75000000);

						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(75000000);

						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						Send_Command(0x06, 0xf9);
						DelayLoop(75000000);
						
					}
					printf("gggggo\n");
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);//종종걸음 15걸음
					DelayLoop(75000000);
					
					stage++;
					motion0 = 0;
					goto GOUP;
				}
				
				else if (motion0 == 2){
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);//종종걸음 15걸음
					DelayLoop(75000000);
					
					stage++;
					motion0 = 0;
					goto GOUP;
				}
			}
			
			///////////////////////////////////////////////////////////////

			/////////////////////// 5번째 장애물 /////////////////////////////
			//걸어오고있다.
			else if (stage == 5)
			{
				for (i = 0; i < 120; i++)
					for (j = 0; j < 180; j++){
						if (((int)*(red + i * 180 + j) >20) && ((int)*(green + i * 180 + j) >20) && ((int)*(blue + i * 180 + j) > 20)
							&& ((int)*(v_compare + i * 180 + j) > 22))
							*(xxx + i * 180 + j) = 1;//흰색을표시

						else if (((int)*(red + i * 180 + j) < 10) && ((int)*(green + i * 180 + j) < 10) && ((int)*(blue + i * 180 + j) < 10)
							&& ((int)*(v_compare + i * 180 + j) < 10))
							*(xxx + i * 180 + j) = 2;//검정을표시

						else if ((*(red + i * 180 + j) < *(green + i * 180 + j)) && (*(blue + i * 180 + j) < *(green + i * 180 + j)) 
							&& ((int)*(hue_joon + i * 180 + j) > 120) && ((int)*(hue_joon + i * 180 + j) < 170))
							*(xxx + i * 180 + j) = 5;//초록을표시
					}

				//초록계단 장애물
				cnt4_green = 0, cnt_st4 = 0;
				cnt4 = 0, cnt4_b_w = 0;
				st4_av_i = 0, st4_sum_i = 0;
				green4_l = 0, green4_r = 0;
				st4_left = 0, st4_right = 0;
				
			
				if (motion4 == 0)
				{
					for (i = 0; i < 120; i++)
						for (j = 0; j < 180; j++){
							*(lcd + 180 * i + j) = 0x0000;
							if (*(xxx + 180 * i + j) == 5)
							//	if ((*(xxx + 180 * i + j) + *(xxx + 180 * i + j + 1) == 7)
							//		|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j) == 7)
							//		|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j + 1) == 7))//초검일 경우
								{
									*(lcd + 180 * i + j) = 0x000f;
									*(st4_green + cnt4) = i;
									cnt4++;
								}
						}
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					for (i = 0; i < cnt4; i++)
						st4_sum_i += *(st4_green + i);

					st4_av_i = st4_sum_i / cnt4;

					printf("cnt_st4=%d cnt4=%d\n", cnt_st4,cnt4);
					
					if (st4_av_i >65 && cnt4 > 5)
					{
						printf("command up!\n");
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(150000000);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);
						Send_Command(0x0b, 0xf4);// 고개숙이고 총총걸음 10걸음짜리 행동으로 따로넣어야할듯
						DelayLoop(150000000);
						

						printf("Walk End!\n");

						//총총걸음 한 10걸음? 하다가 계단오르기!!!!! 로직으로
						motion4 = 1;
						goto GOUP;

					}
					
					else
					{
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						Send_Command(0x0c, 0xf3);
						DelayLoop(50000000);
						printf("no!\n");
						
						goto GOUP;
					}
				}

				
				else if (motion4 == 1) // 올라가기 직전에 평행맞추기
				{
					for (i = 0; i < 120; i++) // 초록색에서 균형잡기
						for (j = 0; j < 180; j++)
							if (*(xxx + 180 * i + j) == 5)
							{
								if (j < 73)
									st4_left++;
								else
									st4_right++;
							}

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					if (st4_left > st4_right + 600)
					{
						Send_Command(0x16, 0xe9);
						Send_Command(0x16, 0xe9);
						Send_Command(0x16, 0xe9);
						DelayLoop(50000000);
						motion4 = 1;
						goto GOUP;
					}
					else if (st4_right > st4_left + 600)
					{
						Send_Command(0x17, 0xe8);
						Send_Command(0x17, 0xe8);
						Send_Command(0x17, 0xe8);
						DelayLoop(50000000);
						motion4 = 1;
						goto GOUP;
					}
					else
					{
						motion4 = 2;
						goto GOUP;
					}
				}

				else if (motion4 == 2)
				{
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(50000000);
					printf("up\n");
					Send_Command(0x0e, 0xf1);
					Send_Command(0x0e, 0xf1);
					Send_Command(0x0e, 0xf1);//오르기
					DelayLoop(250000000);
					
					motion4 = 3;
					goto GOUP;
				}



				else if (motion4 == 3)//올라간상태 총총걸음
				{
					for (i = 0; i < 70; i++)
						for (j = 10; j < 170; j++)
							if (*(xxx + 180 * i + j) == 5)
								cnt4_green++;

					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					if (cnt4_green<800)
					{
						motion4 = 4;
						goto GOUP;
					}

					st4_left = 0, st4_right = 0;
					
					for (i = 0; i < 120; i++) // 초록색에서 균형잡기
						for (j = 0; j < 180; j++)
							if (*(xxx + 180 * i + j) == 5)
							{
								if (j < 73)
									st4_left++;
								else
									st4_right++;
							}					
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					if (st4_left > st4_right + 2000)
					{
						printf("go left\n");
						Send_Command(0x18, 0xe7);
						Send_Command(0x18, 0xe7);
						Send_Command(0x18, 0xe7);
						DelayLoop(50000000);

					}

					else if (st4_right > st4_left + 2000)
					{
						printf("go right\n");
						Send_Command(0x19, 0xe6);
						Send_Command(0x19, 0xe6);
						Send_Command(0x19, 0xe6);
						DelayLoop(50000000);
						
					}

					else
					{
						printf("center!\n");
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);
						Send_Command(0x12, 0xed);//바닥보고 총총걸음(이건 한~두걸음씩)
						DelayLoop(80000000);
				
						goto GOUP;	
					}
					
					goto GOUP;

				}

				else if (motion4 == 4)
				{//마지막 계단 내려가기 전에 평행맞추기
					for (i = 0; i < 60; i++)
						for (j = 40; j < 140; j++)
							if (*(xxx + 180 * i + j) == 2)
								if ((*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j + 1) == 3)
									|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j) == 3)
									|| (*(xxx + 180 * i + j) + *(xxx + 180 * (i + 1) + j - 1) == 3))
								{
									*(out_i + cnt_st4) = i;
									*(out_j + cnt_st4) = j;
									cnt_st4++;
									*(lcd + 180 * i + j) = 0xf000;

								}
					draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
					draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
					flip();

					firsty = 0;
					firstx = 0;
					secondy = 0;
					secondx = 0;

					for (i = 0; i < 5; i++)
					{
						firsty += *(out_i + (cnt_st4 / 2) - 5 + i);
						firstx += *(out_j + (cnt_st4 / 2) - 5 + i);
						secondy += *(out_i + (cnt_st4 / 2) + i);
						secondx += *(out_j + (cnt_st4 / 2) + i);
					}

					first_y = (int)(firsty / 5);
					first_x = (int)(firstx / 5);
					second_y = (int)(secondy / 5);
					second_x = (int)(secondx / 5);

					outline_y = second_y - first_y;
					outline_x = second_x - first_x;
					degree = atan2(outline_y, outline_x) * 180 / 3.14;

					printf("degree=%d\n", (int)degree);

					if ((int)degree > 10 && (int)degree < 60)
					{
						Send_Command(0x1b, 0xe4);
						Send_Command(0x1b, 0xe4);
						Send_Command(0x1b, 0xe4);
						DelayLoop(50000000);

						goto GOUP;
					}
					else if ((int)degree <= 179 && (int)degree >=110)
					{
						Send_Command(0x1a, 0xe5);
						Send_Command(0x1a, 0xe5);
						Send_Command(0x1a, 0xe5);
						DelayLoop(50000000);
						goto GOUP;
					}

					else
					{
						motion4 = 5;
						goto GOUP;
					}
				}

				else if (motion4 == 5)
				{

					printf("Command Down!\n");
					
					/*
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(70000000);
					*/
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(70000000);

					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					Send_Command(0x0c, 0xf3);
					DelayLoop(70000000);
					
					Send_Command(0x1d, 0xe2);
					Send_Command(0x1d, 0xe2);
					Send_Command(0x1d, 0xe2);
					DelayLoop(150000000);

					printf("Down!\n");
					Send_Command(0x0f, 0xf0);
					Send_Command(0x0f, 0xf0);
					Send_Command(0x0f, 0xf0);//내리기
					DelayLoop(250000000);
					printf("Stage Clear!!\n");
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(150000000);
					stage = 6;
					goto OUTLINE;
				}
			

			}
			//////////////////////////////////////////////////////////
			
			
			////////////////////////6번째 장애물///////////////////////
			else if (stage == 6)
			{
				//골프공
				Send_Command(0x1c, 0xe3);
				Send_Command(0x1c, 0xe3);
				Send_Command(0x1c, 0xe3);
				DelayLoop(150000000);
				Send_Command(0x1c, 0xe3);
				Send_Command(0x1c, 0xe3);
				Send_Command(0x1c, 0xe3);
				DelayLoop(150000000);
				
				printf("Turn1\n");
				Send_Command(0x07, 0xf8);
				Send_Command(0x07, 0xf8);
				Send_Command(0x07, 0xf8);
				DelayLoop(110000000);
				printf("Turn2\n");
				Send_Command(0x07, 0xf8);
				Send_Command(0x07, 0xf8);
				Send_Command(0x07, 0xf8);
				DelayLoop(110000000);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				Send_Command(0x0b, 0xf4);
				DelayLoop(150000000);
				
			
				stage = 7;
				goto OUTLINE;

			}
			//////////////////////////////////////////////////////////

			

			//////////////////////////8번재 장애물//////////////////////////
			//노란함정
			else if (stage == 8)
			{
				stage = 9;
				goto GOUP;
			}

			/////////////////////////////////////////////////////////////
			
			////////////////////////9번째장애물/////////////////////////////////
			else if (stage == 9)
			{
				//마지막 바리케이트
				cnt7 = 0;
				for (i = 0; i < 100; i++)
				{
					for (j = 20; j < 160; j++)
					{
						*(lcd + 180 * i + j) = 0x0000;
						//노란색
						if (((int)*(red + i * 180 + j) > 18) && ((int)*(green + i * 180 + j) > 18) && ((int)*(blue + i * 180 + j) < 15)
							&& ((int)*(v_compare + i * 180 + j) > 15) && ((int)*(hue_joon + i * 180 + j) > 40) && ((int)*(hue_joon + i * 180 + j) < 90))
						{
							cnt7++;
							*(lcd + 180 * i + j) = 0x7000;
						}
							
					}
				}

				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();

				if (motion7 == 0)
				{
					printf("slow go2!\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(200000000);
					printf("slow go3!\n");
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					Send_Command(0x0b, 0xf4);
					DelayLoop(200000000);
					
					motion7 = 1;
					goto GOUP;
				}

				else if (motion7 == 1)
				{
					printf("STOP and Wait\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt7 > 50)
						motion7 = 2;//멈춰
					goto GOUP;
				}

				else if (motion7 == 2)
				{
					printf("STOP!!!!!!!!!!!!!!\n");
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					Send_Command(0x01, 0xfe);
					DelayLoop(10000000);
					if (cnt7 < 50)
						motion7 = 3;//가
					goto GOUP;
				}

				else if (motion7 == 3)
				{
					printf("GOGOGOGOGO!!!!!!!!!!!\n");
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					Send_Command(0x1c, 0xe3);
					DelayLoop(70000000);
					
					goto GOUP;
				}
			}

			
		}

	}

	free(fpga_videodata);
	free(lcd);

	free(hue_joon);
	free(satur_tmp);
	free(v_compare);

	free(xxx);
	free(out_i);
	free(out_j);
	free(st4_green);
	free(st6_red);

	uart_close();
	if (bmpsurf != 0)
		release_surface(bmpsurf);
	close_graphic();

	return 0;
}
