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
	int i = 0, j = 0,k=0,l=0;
	float r = 0, g = 0, b = 0;
	float max = 0.0f, min = 0.0f;
	float hf = 0.0f, sf = 0.0f, vf = 0.0f;
	int ret, delta;
	char input;
	int b_loop = 0;
	int stage = 1;
	//외곽선
	int motion = 0;
	int i_left = 0, i_right = 0, i_cen = 0;
	int cnt = 0;
	//st1


	//st2
	int motion2 = 0, cnt2 = 0;
	//st3
	int cnt3 = 0, motion3 = 1;
	int cnt_st3 = 0;
	int st3_right = 0, st3_left = 0;
	//st4
	int cnt4 = 0, motion4 = 0, st4_av_i = 0, st4_sum_i = 0, cnt4_b_w = 0, cnt4_green = 0;
	int st4_left = 0, st4_right = 0, green4_l = 0, green4_r = 0, cnt_st4 = 0, st4_walk = 0;
	int cnt4_black = 0, cnt4_degree = 0;
	//st5
	//st6
	int cnt6 = 0, motion6 = 0, st6_sum_i = 0, st6_av_i = 0;
	int red6_l = 0, red6_r = 0, cnt6_red = 0, cnt_st6 = 0;
	int st6_left = 0, st6_right = 0;
	//st7
	int cnt7 = 0, motion7 = 0;



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
	int* st4_green = (int*)malloc(180 * 120 * 4);
	int* st6_red = (int*)malloc(180 * 120 * 4);



	float Mask[9] = { 0 };
	int cnt_mask = 0;
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
			
				read_fpga_video_data(fpga_videodata);

				for (i = 0; i < 180 * 120; i++)
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
					*(s_temp + i) = *(satur_tmp + i);

				}


				
				////////////////////////외곽선(로봇중앙맞추기)///////////////////////
				i_left = 0, i_right = 0, i_cen = 0;
				cnt = 0;
			
				///////////////////마스크 추가///////////////////////////
			
				int n = 1;

				Mask[0] = -1.0f; Mask[1] = -1.0f; Mask[2] = -1.0f;
				Mask[3] = 0.0f; Mask[4] = 0.0f; Mask[5] = 0.0f;
				Mask[6] = 1.0f; Mask[7] = 1.0f; Mask[8] = 1.0f;

				cnt_mask = 0;
				for (i = 120 - n; i > n; i--){
					index1 = i * 180;
					for (j = 180 - n; j > n; j--){
						float sum1 = 0.0f;


						for (k = -n; k <= n; k++)
						{
							index2 = (i + k) * 180;
							index3 = (k + n) * 3;
							for (l = -n; l <= n; l++)
							{
								sum1 += gray[index2 + (j + l)] * Mask[index3 + l + n];
							}
						}
						

						if (sum1 > 65530){
							*(lcd + i * 180 + j) = 0xffff;
							cnt_mask++;
							
						}

						else
							*(lcd + i * 180 + j) = 0x0000;



					}
				}
				
				draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
				draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
				flip();
				/////////////////////////////////////////////////////////

				for (i = 120; i >= 0; i--)
				{
					if (*(lcd + 180 * i + 45) == 0xffff)
					{
						i_left = i;
						break;
					}
				}


				for (i = 120; i >= 0; i--)
				{
					if (*(lcd + 180 * i + 75) == 0xffff)
					{
						i_right = i;
						break;
					}
				}

				for (i = 120; i >= 0; i--)
				{
					if (*(lcd + 180 * i + 85) == 0xffff)
					{
						i_cen = i;
						break;
					}
				}

				printf("i_left=%d\n", i_left);
				printf("i_right=%d\n", i_right);
				printf("i_cen=%d\n", i_cen);
				
				if (motion == 0)//준비단계
				{
					printf("Ready\n");
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					Send_Command(0x04, 0xfb);
					DelayLoop(50000000);

					motion = 1;//

					goto OUTLINE;
				}

				else if (motion == 1)
				{
					if (i_left - i_right > 4)
					{
						printf("left turn\n");
						Send_Command(0x09, 0xf6);//왼쪽턴
						DelayLoop(50000000);
					}
					else if (i_right - i_left > 4)
					{
						printf("right turn\n");
						Send_Command(0x0a, 0xf5);//오른쪽턴
						DelayLoop(50000000);
					}
					else
						cnt++;

					if (i_cen < 37)
					{
						printf("go right\n");
						Send_Command(0x17, 0xe8);//오른쪽한걸음
						DelayLoop(50000000);
					}
					else if (i_cen > 52)
					{
						printf("go rleft\n");
						Send_Command(0x16, 0xe9);//왼쪽한걸음
						DelayLoop(50000000);
					}
					else
						cnt++;

					if (cnt == 2)
					{
						motion = 2;
						goto OUTLINE;
					}
					else
					{
						motion = 0;
						goto OUTLINE;
					}
					
				}

				else if (motion == 2)
				{
					printf("gogo\n");
					Send_Command(0x0c, 0xf3);
					DelayLoop(50000000);
					motion = 0;
					goto OUTLINE;
				}

				////////////////////////////////////////////////////////////////
				

			}//while문 끝

		}

		/* 색정보따는코드
		for (i = 0; i < 120; i++)
		{
		for (j = 0; j < 180; j++)
		{
		if (i == 60)
		{
		*(lcd + 180 * i + j) = 0xf000;
		if (j == 75)
		{
		printf("red=%d  ", (int)*(red + 180 * i + j));
		printf("green=%d  ", (int)*(green + 180 * i + j));
		printf("blue=%d\n", (int)*(blue + 180 * i + j));
		printf("hue=%d  ", (int)*(hue_joon + 180 * i + j));
		printf("sat=%d  ", (int)*(satur_tmp + 180 * i + j));
		printf("v=%d\n", (int)*(v_compare + 180 * i + j));
		}
		}
		if (j == 75||j==50)
		{
		*(lcd + 180 * i + j) = 0xf000;
		}


		}
		}

		draw_img_from_buffer(fpga_videodata, 0, 18, 0, 0, 1.77, 0);
		draw_img_from_buffer(lcd, 0, 250, 0, 0, 1.77, 0);
		flip();
		*/




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
