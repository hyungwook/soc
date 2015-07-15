#include <linux/module.h>
#include <linux/slab.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/string.h>
#include <linux/init.h>
#include <asm/uaccess.h>
#include <asm/irq.h>
#include <asm/hardware.h>
#include <asm/io.h>
#include <asm/arch/regs-gpio.h>
//#include <daccess.h>

#include "amazon2_sdk.h"
#include "surface.h"
#include "tmem.h"

#define AMAZON2_LED_PORT    AMAZON2_PORT14_7

#define AMAZON2_GRAPHIC_MAJOR 124

#define AMAZON2_GRAPHIC_NAME  "amazon2_graphic"

#define GE_DEBUG 1

#if GE_DEBUG != 0
#define PRINTLINE printk("%s , %d \r\n",__FILE__,__LINE__)
#define PRINTVAR(A)	printk("%s=0x%x(%d)\r\n",#A,A,A)

#else
#define PRINTLINE
#define PRINTVAR(A)	
#endif

#define SCREEN_W 320
#define SCREEN_H 480
#define SCREEN_BPP 16

#define MAX_FRAMEBUFFER 2
static SURFACE Surface_framebuffer[MAX_FRAMEBUFFER];
static u32 _ge_CurCommandNum = 0;///< 현재 Packet의 넘버 0-2047
struct timer_list cam_timer;

u32 get_screen_width(void)
{
	return SCREEN_W;
}
u32 get_screen_height(void)
{
	return SCREEN_H;
}

int get_screen_bpp(void)
{
	return SCREEN_BPP;
}

u32 get_curcommandnum(void)
{
	return _ge_CurCommandNum;
}

#define MAX_COMMAND			2048
#define MAX_COMMAND_MASK	(MAX_COMMAND-1)


/*
 * v0.1 : Initial release
 * v0.4 : Add DRAW_FPGA_VIDEO_DATA_FULL 
 * v0.5 : Add DRAW_IMG_FROM_BUFFER
 */

#define AMAZON2_GRAPHIC_VERSION "v0.5"

#define AMAZON2_GRAPHIC_DEBUG	1



void ge_wait_empty_cmd_q(void)
{
	while (*R_GE_PRP != _ge_CurCommandNum);
}

void ge_wait_cmd_complete()
{
	while (!((*R_GE_CDB) & (1 << 24)));
}
static BOOL b_ge_single_cmd = FALSE;

void ge_end_cmd(void)
{
	//single mode
	//#define CMD_SINGLE_MODE
#ifdef CMD_SINGLE_MODE
#if 1
	ge_wait_cmd_complete();
#else
	while (*R_GE_PRP != _ge_CurCommandNum);
#endif
#endif // CMD_SINGLE_MODE
	if (b_ge_single_cmd)
	{
		ge_wait_cmd_complete();
		b_ge_single_cmd = FALSE;
	}
	//check alpha or transparency
	U16 pd0 = *(vU16*)(TEXTURE_MEM_START_ADDR + (_ge_CurCommandNum << 7));
	if ((pd0 & (1 << 9)) || (pd0 & (1 << 7)))
	{
		b_ge_single_cmd = TRUE;
	}
	_ge_CurCommandNum = (_ge_CurCommandNum + 1) & MAX_COMMAND_MASK;
	//wait when command queue is full.
	while (*R_GE_PRP == _ge_CurCommandNum)
	{
		//DEBUGPRINTF("GE COMMAND FULL : %08x,%08x(%d)\r\n",*R_GE_PRP ,_ge_CurCommandNum,i);
		printk("GE COMMAND FULL : %08x,%08x\r\n", *R_GE_PRP, _ge_CurCommandNum);
	}

	*R_GE_PWP = _ge_CurCommandNum;
}


static void flip(void)
{
	while (*R_GE_FCC != 0);

	*R_GE_FCC = 0; // reset flip count
	*R_GE_FCC = 1; // increase flip count
	GE_WriteCmd(0, (1 << 1));
	GE_WriteCmd(1, 0);
	ge_end_cmd();
}

static void flip_wait(void)
{
	while (*R_GE_FCC != 0);
	*R_GE_FCC = 0; // reset flip count
	*R_GE_FCC = 1; // increase flip count
	GE_WriteCmd(0, (1 << 1));
	GE_WriteCmd(1, 0);
	ge_end_cmd();
	while (*R_GE_FCC != 0);
}


SURFACE* get_back_buffer(void)
{
	U8 bank;
	while (*R_GE_FCC);
	bank = ((*R_DC_FESR) >> 8) + 1;
	bank = bank % MAX_FRAMEBUFFER;
	return &Surface_framebuffer[bank];
}

SURFACE *get_front_buffer(void)
{
	U8 bank;
	while (*R_GE_FCC);
	bank = ((*R_DC_FESR) >> 8);
	bank = bank % MAX_FRAMEBUFFER;
	return &Surface_framebuffer[bank];
}

SURFACE* get_ge_target_buffer(void)
{
	if ((*R_DC_FESR) & (1 << 4))
		return get_back_buffer();

	return get_front_buffer();
}

static void ge_draw_rectfill(int x, int y, int w, int h, EGL_COLOR c)
{
	int EndX, EndY;
	U8 r, g, b;
	SURFACE* targetsurf = get_ge_target_buffer();
	if (w <= 0)
		return;
	if (h <= 0)
		return;
	EXTRACT_RGB(c, r, g, b);
	EndX = x + w - 1;
	EndY = y + h - 1;
	if (targetsurf->clip.x > x)
	{
		x = targetsurf->clip.x;
	}
	if (targetsurf->clip.y > y)
	{
		y = targetsurf->clip.y;
	}
	if (targetsurf->clip.endx < EndX)
	{
		EndX = targetsurf->clip.endx;
	}
	if (targetsurf->clip.endy < EndY)
	{
		EndY = targetsurf->clip.endy;
	}

	GE_WriteCmd(1, (U16)((1 << 0) | (1 << 4)));
	if (get_screen_bpp() == 32)
	{
		GE_WriteCmd(0, (U16)((1 << 14) | (1 << 8)));
	}
	else
	{
		GE_WriteCmd(0, (U16)(1 << 8));
	}

	GE_WriteCmd(2, (U16)x);
	GE_WriteCmd(3, (U16)y);
	GE_WriteCmd(4, (U16)EndX);
	GE_WriteCmd(5, (U16)EndY);
	GE_WriteCmd(21, 0);
	GE_WriteCmd(22, (U16)(g << 8 | b));
	GE_WriteCmd(23, (U16)r);
	ge_end_cmd();
}

PALETTE* create_palette(int bpp, int nColors)
{
	PALETTE* pal = (PALETTE*)kmalloc(sizeof(PALETTE), GFP_KERNEL);
	if (pal == 0)
		return 0;
	memset(pal, 0, sizeof(PALETTE));
	if (tmemalign(&pal->tm, 4096, (bpp / 8)*nColors) == 0)
	{
		kfree(pal);
		return 0;
	}
	pal->colors = (EGL_COLOR*)(pal->tm.offset + TEXTURE_MEM_START_ADDR);
	pal->bpp = bpp;
	pal->nColors = nColors;
	//pal->colorkey=-1;
	return pal;
}

SURFACE* create_surface(U32 w, U32 h, U32 bpp)
{
	if (!((bpp == 32) || (bpp == 24) || (bpp == 16) || (bpp == 4) || (bpp == 8)))
		return 0;
	SURFACE* surface = NULL;

	if ((w == 0) || (h == 0))
		return NULL;
	if (w > 2047)
		return NULL;
	surface = (SURFACE*)kmalloc(sizeof(SURFACE), GFP_KERNEL);
	if (surface == 0)
	{
		printk("Not enough memory\r\n");
		return 0;
	}
	memset(surface, 0, sizeof(SURFACE));
	surface->bpp = bpp;
	surface->w = w;
	surface->h = h;
	surface->clip.x = 0;
	surface->clip.y = 0;
	surface->clip.endx = w;
	surface->clip.endy = h;
	if (bpp == 32)
	{
		surface->pixtype = PIX_FMT_ARGB;
	}
	else if (bpp == 24)
	{
		surface->pixtype = PIX_FMT_RGB888;
	}
	else
	{
		if (bpp == 16)
			surface->pixtype = PIX_FMT_RGB565;
		else
		{
			surface->pixtype = PIX_FMT_PALETTE;
			if (bpp == 4)
				surface->pal = create_palette(32, 16);
			else
				surface->pal = create_palette(32, 256);
			if (surface->pal == 0)
			{
				kfree(surface);
				return 0;
			}
		}

	}
	int i;
	for (i = 3; i < 0x13; i++)
	{
		if (surface->w <= (1 << i))
		{
			break;
		}
	}
	surface->TileXSize = i - 3;
#if 0
	if (bpp == 24)
	{
		surface->pitch = (1 << i) * 4;
		if (surface->pitch == (2048 * 4))
			surface->pitch -= 4;
	}
	else
	{
		surface->pitch = ((1 << i)*bpp) / 8;
		if (surface->pitch / (bpp / 8) == 2048)
			surface->pitch -= (bpp / 8);
	}

#else
	if (bpp == 24)
	{
		surface->pitch = surface->w * 4;
	}
	else
		surface->pitch = (surface->w*bpp) / 8;
	//4byte align
	surface->pitch = (surface->pitch + 3) & ~3;
#endif
	for (i = 3; i < 0x13; i++)
	{
		if (surface->h <= (1 << i))
		{
			break;
		}
	}
	surface->TileYSize = i - 3;
	U32 texturewidth, textureheight;
	texturewidth = surface->pitch;
	//textureheight =  1<<(surface->TileYSize + 3);
	textureheight = surface->h;
	if (tmemalign(&surface->tm, 128, texturewidth*textureheight) == 0)
	{
		if (surface->pal)
		{
			release_palette(surface->pal);
		}
		kfree(surface);
		return 0;
	}
	surface->pixels = (void*)(TEXTURE_MEM_START_ADDR + surface->tm.offset);
	return surface;
}

void release_palette(PALETTE* pal)
{
	if (pal == 0)
		return;
	tmemfree(&pal->tm);
	kfree(pal);
}

void release_surface(SURFACE* surf)
{
	if (surf == 0)
		return;
	if (surf->pixels)
	{
		tmemfree(&surf->tm);
	}
	if (surf->pal)
	{
		release_palette(surf->pal);
	}
	kfree(surf);
}

void set_colors(SURFACE* surf, U32* colors, int index, int cnt)
{
	memcpy(surf->pal->colors + index, colors, cnt * 4);
}

/*

Draw API

*/
BOOL sw_draw_surface(SURFACE* src_surf, int dx, int dy);
BOOL sw_draw_surface_rect(SURFACE* ssrf, int dx, int dy, int sx, int sy, int w, int h);
BOOL sw_draw_surface_scale(SURFACE* src_surf, int dx, int dy, int dw, int dh);
BOOL sw_draw_surface_scalerect(SURFACE* src_surf, int dx, int dy, int dw, int dh, int sx, int sy, int sw, int sh);


BOOL ge_check_clipwindow(S32* InitDX, S32* InitDY, S32* EndX, S32* EndY,
	S32* InitSX, S32* InitSY, S32 dxSx, S32 dxSy, S32 dySx, S32 dySy)
{
	SURFACE* targetsurf = get_ge_target_buffer();
	S32 diff;
	if (*InitDX < targetsurf->clip.x)
	{
		diff = targetsurf->clip.x - *InitDX;
		*InitSX += diff * dxSx;
		*InitSY += diff * dxSy;
		*InitDX = targetsurf->clip.x;
	}

	if (*InitDY < targetsurf->clip.y)
	{
		diff = targetsurf->clip.y - *InitDY;
		*InitSX += diff * dySx;
		*InitSY += diff * dySy;
		*InitDY = targetsurf->clip.y;
	}

	if (*EndX > targetsurf->clip.endx)
		*EndX = targetsurf->clip.endx;

	if (*EndY > targetsurf->clip.endy)
		*EndY = targetsurf->clip.endy;

	if (*InitDX > *EndX)
		return FALSE;

	if (*InitDY > *EndY)
		return FALSE;
	return TRUE;
}

BOOL  ge_draw(SURFACE *src, S32 InitDX, S32 InitDY, S32 EndX, S32 EndY,
	S32 InitSX, S32 InitSY, S32 dxSx, S32 dxSy, S32 dySx, S32 dySy)
{
	U16 mode = src->drawmode | DRAWMODE_TEXTURE;
	U16 mode2 = GROUP_E0 | GROUP_E1 | GROUP_E2 | GROUP_E6;

	if (src->pixtype == PIX_FMT_ARGB)
	{
		mode |= DRAWMODE_ALPHA;
		src->sblendmode = BLEND_SRCALPHA;
		src->dblendmode = 0x8 | BLEND_SRCALPHA;
	}
	if (ge_check_clipwindow(&InitDX, &InitDY, &EndX, &EndY, &InitSX, &InitSY, dxSx, dxSy, dySx, dySy) == FALSE)
		return FALSE;
	GE_WriteCmd(2, (U16)InitDX);
	GE_WriteCmd(3, (U16)InitDY);
	GE_WriteCmd(4, (U16)EndX);
	GE_WriteCmd(5, (U16)EndY);
	GE_WriteCmd(6, (U16)((U16)InitSX & 0xffff));
	GE_WriteCmd(7, (U16)((U16)(InitSX >> 16) & 0xffff));
	GE_WriteCmd(8, (U16)((U16)InitSY & 0xffff));
	GE_WriteCmd(9, (U16)((U16)(InitSY >> 16) & 0xffff));
	GE_WriteCmd(10, (U16)((U16)dxSx & 0xffff));
	GE_WriteCmd(11, (U16)((U16)(dxSx >> 16) & 0xffff));
	GE_WriteCmd(12, (U16)((U16)dxSy & 0xffff));
	GE_WriteCmd(13, (U16)((U16)(dxSy >> 16) & 0xffff));
	GE_WriteCmd(14, (U16)((U16)dySx & 0xffff));
	GE_WriteCmd(15, (U16)((U16)(dySx >> 16) & 0xffff));
	GE_WriteCmd(16, (U16)((U16)dySy & 0xffff));
	GE_WriteCmd(17, (U16)((U16)(dySy >> 16) & 0xffff));

	if ((mode & DRAWMODE_ALPHA) == DRAWMODE_ALPHA)
	{
		mode2 |= GROUP_E3;
		GE_WriteCmd(18, src->alphaConstColor.g << 8 | src->alphaConstColor.b);
		GE_WriteCmd(19, src->alphaConstColor.a << 8 | src->alphaConstColor.r);
		GE_WriteCmd(20, src->dblendmode << 8 | src->sblendmode);
	}

	U32 ImageOffset = (U32)(src->pixels) - TEXTURE_MEM_START_ADDR;
	GE_WriteCmd(28, (U16)(ImageOffset >> 6));
	GE_WriteCmd(29, (U16)(ImageOffset >> 22));

	if (src->bpp == 4 || src->bpp == 8)
	{
		U32 paloffset = (U32)(src->pal->colors) - TEXTURE_MEM_START_ADDR;
		mode |= DRAWMODE_PALETTEINDEX;//palette update
		GE_WriteCmd(30, (U32)(paloffset) >> 12);
	}

	if ((src->drawmode & DRAWMODE_SHADE) == DRAWMODE_SHADE)
	{
		mode2 |= GROUP_E4;
		GE_WriteCmd(21, 0);

		if (src->bpp == 16)
		{
			GE_WriteCmd(22, (U16)(((src->ShadeColor.g & 0xfc) << 8) | (src->ShadeColor.b & 0xf8)));
			GE_WriteCmd(23, (U16)(((src->ShadeColor.a & 0xff) << 8) | (src->ShadeColor.r & 0xf8)));
		}
		else
		{
			GE_WriteCmd(22, (U16)((src->ShadeColor.g << 8) | (src->ShadeColor.b & 0xff)));
			GE_WriteCmd(23, (U16)(((src->ShadeColor.a & 0xff) << 8) | (src->ShadeColor.r & 0xf8)));
		}
	}

	if ((src->drawmode & DRAWMODE_TRANSPARENCY) == DRAWMODE_TRANSPARENCY)
	{
		mode2 |= GROUP_E5;

		if (src->bpp == 4 || src->bpp == 8)
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xff) << 8) | (src->transColor.b & 0xff)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xff));
		}
		else if (src->bpp == 16)
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xfc) << 8) | (src->transColor.b & 0xf8)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xf8));
		}
		else
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xff) << 8) | (src->transColor.b & 0xff)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xff));
		}
	}

	U16 pd31;
	pd31 = (U16)((src->TileXSize & 0x0f)) | (U16)((src->TileYSize & 0x0f) << 4);

	switch (src->bpp)
	{
	case 4:
		pd31 |= (0) << 8;
		pd31 |= (U16)((src->pal->LUT4Bank & 0x0f) << 12);
		break;

	case 8:
		pd31 |= (1) << 8;
		break;

	case 16:
		pd31 |= (2) << 8;
		break;
	case 24:
	case 32:
		pd31 |= (4) << 8;
		break;
	}

	if (get_screen_bpp() == 32)
		mode |= (1) << 14;

	GE_WriteCmd(31, pd31);

	GE_WriteCmd(32, src->w);//real width

	if (src->bpp == 4)
		GE_WriteCmd(33, src->pitch * 2);
	else if (src->bpp == 8)
		GE_WriteCmd(33, src->pitch);
	else if (src->bpp == 16)
		GE_WriteCmd(33, src->pitch / 2);
	else if (src->bpp == 24)
		GE_WriteCmd(33, src->pitch / 4);
	else if (src->bpp == 32)
		GE_WriteCmd(33, src->pitch / 4);
	GE_WriteCmd(34, src->h);

	GE_WriteCmd(0, mode);
	GE_WriteCmd(1, mode2);
	ge_end_cmd();
	return TRUE;
}

BOOL draw_surface_rect(SURFACE *surf, int dx, int dy, int sx, int sy, int w, int h)
{
	return draw_surface_scalerect(surf, dx, dy, w, h, sx, sy, w, h);
}

BOOL draw_surface(SURFACE *src_surf, int dx, int dy)
{
	if (src_surf->bpp <= 8)
	{
		if (src_surf->pal->colorkey != -1)
		{
			src_surf->drawmode |= DRAWMODE_TRANSPARENCY;
			src_surf->transColor = *(sARGB*)&src_surf->pal->colors[src_surf->pal->colorkey];
		}
		else
		{
			src_surf->drawmode &= ~DRAWMODE_TRANSPARENCY;
		}
	}
	return draw_surface_rect(src_surf, dx, dy, 0, 0, src_surf->w, src_surf->h);
}

BOOL surface_set_alpha(SURFACE *surf, U8 a)
{
	//pixel 단위가 아님
	surf->drawmode |= DRAWMODE_ALPHA;
	surf->alphaConstColor.a = a;
	surf->alphaConstColor.r = a;
	surf->alphaConstColor.g = a;
	surf->alphaConstColor.b = a;
	surf->sblendmode = BLEND_INVERSION | BLEND_CONSTANT;
	surf->dblendmode = BLEND_CONSTANT;
	return TRUE;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
/// <summary>	Draw surface with scale. </summary>
///
/// <remarks>	Kkh, 2013-01-18. </remarks>
///
/// <param name="surf">	The source Surface. </param>
/// <param name="dx">  	The x-coordiate, in logical units, of the upper-left of destination rectangle. </param>
/// <param name="dy">  	The y-coordiate, in logical units, of the upper-left of destination rectangle. </param>
/// <param name="dw">  	The width, in logical units, of the the destination rectangle. </param>
/// <param name="dh">  	The height, in logical units, of the the destination rectangle. </param>
/// <param name="sx">  	The x-coordiate, in logical units, of the upper-left of source rectangle. </param>
/// <param name="sy">  	The y-coordiate, in logical units, of the upper-left of source rectangle. </param>
/// <param name="sw">  	The width, in logical units, of the the source rectangle. </param>
/// <param name="sh">  	The height, in logical units, of the the source rectangle. </param>
///
/// <returns>	true if it succeeds, false if it fails. </returns>
////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL draw_surface_scalerect(SURFACE *surf, int dx, int dy, int dw, int dh, int sx, int sy, int sw, int sh)
{
	S32 InitDX, InitDY, EndX, EndY;
	S32 InitSX, InitSY;
	S32 dxSx, dxSy, dySx, dySy;
	InitDX = dx;
	InitDY = dy;
	EndX = dx + dw - 1;
	EndY = dy + dh - 1;
	InitSX = sx;
	InitSY = sy;
	if (surf->pixtype == PIX_FMT_A000)//not H/W
	{
		return sw_draw_surface_scalerect(surf, dx, dy, dw, dh, sx, sy, sw, sh);
	}

	if (surf->flipmode & PIVOT_HFLIP)
	{
		InitSX = (sx + sw - 1) << 9;
		dxSx = -(sw << 9) / dw;
		dxSy = 0;
	}
	else
	{
		InitSX = (sx << 9);
		dxSx = (sw << 9) / dw;
		dxSy = 0;
	}

	if (surf->flipmode & PIVOT_VFLIP)
	{
		InitSY = (sy + sh - 1) << 9;
		dySx = 0;
		dySy = -(sh << 9) / dh;
	}
	else
	{
		InitSY = (sy << 9);
		dySx = 0;
		dySy = (sh << 9) / dh;
	}

	return ge_draw(surf, InitDX, InitDY, EndX, EndY, InitSX, InitSY, dxSx, dxSy, dySx, dySy);
}
BOOL draw_surface_scale(SURFACE *surf, int dx, int dy, int dw, int dh)
{
	S32 InitDX, InitDY, EndX, EndY;
	S32 InitSX, InitSY;
	S32 dxSx, dxSy, dySx, dySy;

	InitDX = dx;
	InitDY = dy;
	EndX = dx + dw - 1;
	EndY = dy + dh - 1;


	if (surf->flipmode & PIVOT_HFLIP)
	{
		InitSX = (surf->w - 1) << 9;
		dxSx = -(surf->w << 9) / dw;
		dxSy = 0;
	}
	else
	{
		InitSX = 0;
		dxSx = (surf->w << 9) / dw;
		dxSy = 0;
	}

	if (surf->flipmode & PIVOT_VFLIP)
	{
		InitSY = (surf->h - 1) << 9;
		dySx = 0;
		dySy = -(surf->h << 9) / dh;
	}
	else
	{
		InitSY = 0;
		dySx = 0;
		dySy = (surf->h << 9) / dh;
	}

	return ge_draw(surf, InitDX, InitDY, EndX, EndY, InitSX, InitSY, dxSx, dxSy, dySx, dySy);
}

BOOL set_texture(SURFACE* src)
{
	U16 mode = src->drawmode | DRAWMODE_TEXTURE;
	U16 mode2 = GROUP_E6;

	if (src->pixtype == PIX_FMT_ARGB)
	{
		mode |= DRAWMODE_ALPHA;
		src->sblendmode = BLEND_SRCALPHA;
		src->dblendmode = 0x8 | BLEND_SRCALPHA;
	}


	if ((mode & DRAWMODE_ALPHA) == DRAWMODE_ALPHA)
	{
		mode2 |= GROUP_E3;
		GE_WriteCmd(18, src->alphaConstColor.g << 8 | src->alphaConstColor.b);
		GE_WriteCmd(19, src->alphaConstColor.a << 8 | src->alphaConstColor.r);
		GE_WriteCmd(20, src->dblendmode << 8 | src->sblendmode);
	}

	U32 ImageOffset = (U32)(src->pixels) - TEXTURE_MEM_START_ADDR;
	GE_WriteCmd(28, (U16)(ImageOffset >> 6));
	GE_WriteCmd(29, (U16)(ImageOffset >> 22));

	if (src->bpp == 4 || src->bpp == 8)
	{
		U32 paloffset = (U32)(src->pal->colors) - TEXTURE_MEM_START_ADDR;
		mode |= DRAWMODE_PALETTEINDEX;//palette update
		GE_WriteCmd(30, (U32)(paloffset) >> 12);
	}

	if ((src->drawmode & DRAWMODE_SHADE) == DRAWMODE_SHADE)
	{
		mode2 |= GROUP_E4;
		GE_WriteCmd(21, 0);

		if (src->bpp == 16)
		{
			GE_WriteCmd(22, (U16)(((src->ShadeColor.g & 0xfc) << 8) | (src->ShadeColor.b & 0xf8)));
			GE_WriteCmd(23, (U16)(((src->ShadeColor.a & 0xff) << 8) | (src->ShadeColor.r & 0xf8)));
		}
		else
		{
			GE_WriteCmd(22, (U16)((src->ShadeColor.g << 8) | (src->ShadeColor.b & 0xff)));
			GE_WriteCmd(23, (U16)(((src->ShadeColor.a & 0xff) << 8) | (src->ShadeColor.r & 0xf8)));
		}
	}

	if ((src->drawmode & DRAWMODE_TRANSPARENCY) == DRAWMODE_TRANSPARENCY)
	{
		mode2 |= GROUP_E5;

		if (src->bpp == 4 || src->bpp == 8)
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xff) << 8) | (src->transColor.b & 0xff)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xff));
		}
		else if (src->bpp == 16)
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xfc) << 8) | (src->transColor.b & 0xf8)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xf8));
		}
		else
		{
			GE_WriteCmd(24, (U16)(((src->transColor.g & 0xff) << 8) | (src->transColor.b & 0xff)));
			GE_WriteCmd(25, (U16)(src->transColor.r & 0xff));
		}
	}

	U16 pd31;
	pd31 = (U16)((src->TileXSize & 0x0f)) | (U16)((src->TileYSize & 0x0f) << 4);

	switch (src->bpp)
	{
	case 4:
		pd31 |= (0) << 8;
		pd31 |= (U16)((src->pal->LUT4Bank & 0x0f) << 12);
		break;

	case 8:
		pd31 |= (1) << 8;
		break;

	case 16:
		pd31 |= (2) << 8;
		break;

	case 32:
		pd31 |= (4) << 8;
		break;
	}

	if (get_screen_bpp() == 32)
		mode |= (1) << 14;

	GE_WriteCmd(31, pd31);

	GE_WriteCmd(32, src->w);//real width

	if (src->bpp == 4)
		GE_WriteCmd(33, src->pitch * 2);
	else if (src->bpp == 8)
		GE_WriteCmd(33, src->pitch);
	else if (src->bpp == 16)
		GE_WriteCmd(33, src->pitch / 2);
	else if (src->bpp == 24)
		GE_WriteCmd(33, src->pitch / 4);
	else if (src->bpp == 32)
		GE_WriteCmd(33, src->pitch / 4);
	GE_WriteCmd(34, src->h);

	GE_WriteCmd(0, mode);
	GE_WriteCmd(1, mode2);
	ge_end_cmd();
	return TRUE;
}

BOOL draw_texture_rect(SURFACE *surf, int dx, int dy, int sx, int sy, int w, int h)
{
	return draw_texture_scalerect(surf, dx, dy, w, h, sx, sy, w, h);
}

BOOL draw_texture(SURFACE* src, int x, int y)
{
	draw_texture_rect(src, x, y, 0, 0, src->w, src->h);

	return TRUE;
}

BOOL draw_texture_scalerect(SURFACE* surf, int dx, int dy, int dw, int dh, int sx, int sy, int sw, int sh)
{
	S32 InitDX, InitDY, EndX, EndY;
	S32 InitSX, InitSY;
	S32 dxSx, dxSy, dySx, dySy;
	InitDX = dx;
	InitDY = dy;
	EndX = dx + dw - 1;
	EndY = dy + dh - 1;
	InitSX = sx;
	InitSY = sy;
	if (surf->pixtype == PIX_FMT_A000)//not H/W
	{
		return sw_draw_surface_scalerect(surf, dx, dy, dw, dh, sx, sy, sw, sh);
	}

	if (surf->flipmode & PIVOT_HFLIP)
	{
		InitSX = (sx + sw - 1) << 9;
		dxSx = -(sw << 9) / dw;
		dxSy = 0;
	}
	else
	{
		InitSX = (sx << 9);
		dxSx = (sw << 9) / dw;
		dxSy = 0;
	}

	if (surf->flipmode & PIVOT_VFLIP)
	{
		InitSY = (sy + sh - 1) << 9;
		dySx = 0;
		dySy = -(sh << 9) / dh;
	}
	else
	{
		InitSY = (sy << 9);
		dySx = 0;
		dySy = (sh << 9) / dh;
	}
	U16 mode = surf->drawmode | DRAWMODE_TEXTURE;
	U16 mode2 = GROUP_E0 | GROUP_E1 | GROUP_E2;
	if (ge_check_clipwindow(&InitDX, &InitDY, &EndX, &EndY, &InitSX, &InitSY, dxSx, dxSy, dySx, dySy) == FALSE)
		return FALSE;
	GE_WriteCmd(2, (U16)InitDX);
	GE_WriteCmd(3, (U16)InitDY);
	GE_WriteCmd(4, (U16)EndX);
	GE_WriteCmd(5, (U16)EndY);
	GE_WriteCmd(6, (U16)((U16)InitSX & 0xffff));
	GE_WriteCmd(7, (U16)((U16)(InitSX >> 16) & 0xffff));
	GE_WriteCmd(8, (U16)((U16)InitSY & 0xffff));
	GE_WriteCmd(9, (U16)((U16)(InitSY >> 16) & 0xffff));
	GE_WriteCmd(10, (U16)((U16)dxSx & 0xffff));
	GE_WriteCmd(11, (U16)((U16)(dxSx >> 16) & 0xffff));
	GE_WriteCmd(12, (U16)((U16)dxSy & 0xffff));
	GE_WriteCmd(13, (U16)((U16)(dxSy >> 16) & 0xffff));
	GE_WriteCmd(14, (U16)((U16)dySx & 0xffff));
	GE_WriteCmd(15, (U16)((U16)(dySx >> 16) & 0xffff));
	GE_WriteCmd(16, (U16)((U16)dySy & 0xffff));
	GE_WriteCmd(17, (U16)((U16)(dySy >> 16) & 0xffff));

	GE_WriteCmd(0, mode);
	GE_WriteCmd(1, mode2);
	ge_end_cmd();
	return TRUE;
}


/*
RGB888 ==> RGB888 or ARGB ==> RGB888
*/
static BOOL blit32to32(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x, y;
	register U8 r, g, b, a;
	register U32 bg_r, bg_g, bg_b;
	int spitch, dpitch;
	U32* argbbuf;

	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;
	if (ssrf->bpp == 32)
	{
		if (ssrf->pixtype == PIX_FMT_ARGB)
		{
			for (y = 0; y < h; y++)
			{
				argbbuf = (U32*)((U32)src + (spitch * y));
				rRGB* rrgbbuf = (rRGB*)((U32)dest + (dpitch * y));
				for (x = 0; x < w; x++)
				{
					a = argbbuf[x] >> 24;
					if (a)
					{
						b = argbbuf[x] >> 0;
						g = argbbuf[x] >> 8;
						r = argbbuf[x] >> 16;
						if (a != 255)
						{
							a = 255 - a;
							bg_r = rrgbbuf[x].rrgb.r;
							bg_g = rrgbbuf[x].rrgb.g;
							bg_b = rrgbbuf[x].rrgb.b;
							r += (((bg_r - (int)r) * a) >> 8);
							g += (((bg_g - (int)g) * a) >> 8);
							b += (((bg_b - (int)b) * a) >> 8);
						}
						rrgbbuf[x] = (rRGB)MAKE_RGB888(r, g, b);
					}
				}
			}
			//dcache_invalidate_way();
			return TRUE;
		}
		else
		{
			printk("Not Supported format yet(Source %dbpp, Destination %d)\n", ssrf->bpp, dsrf->bpp);
			return FALSE;
		}
	}
	else if (ssrf->bpp == 16)
	{
		for (y = 0; y < h; y++)
		{
			RGB565* buf565 = (RGB565*)((U32)src + (ssrf->pitch * y));
			rRGB* rrgbbuf = (rRGB*)((U32)dest + (dsrf->pitch * y));
			for (x = 0; x < w; x++)
			{
				r = buf565[x].r;
				g = buf565[x].g;
				b = buf565[x].b;
				rrgbbuf[x] = (rRGB)MAKE_RGB888(r, g, b);
			}
		}
		//dcache_invalidate_way();
		return TRUE;
	}
	else if (ssrf->bpp == 8)
	{
		if (ssrf->pal == 0)
			return FALSE;
		sARGB* pal = (sARGB*)ssrf->pal->colors;
		for (y = 0; y < h; y++)
		{
			U8* indexbuf = (U8*)((U32)src + (ssrf->pitch * y));
			rRGB* rrgbbuf = (rRGB*)((U32)dest + (dsrf->pitch * y));
			if (ssrf->pixtype == PIX_FMT_A000)
			{
				for (x = 0; x < w; x++)
				{
					a = indexbuf[x];
					if (a)
					{
						r = pal->r;
						g = pal->g;
						b = pal->b;
						if (a != 255) //
						{
							//a = 255-a;
							bg_r = rrgbbuf[x].rrgb.r;
							bg_g = rrgbbuf[x].rrgb.g;
							bg_b = rrgbbuf[x].rrgb.b;
							r += (((bg_r - (int)r) * a) >> 8);
							g += (((bg_g - (int)g) * a) >> 8);
							b += (((bg_b - (int)b) * a) >> 8);
						}
						rrgbbuf[x].data32 = MAKE_RGB888(r, g, b);
					}
				}
			}
			else
			{
				for (x = 0; x < w; x++)
				{
					int index = indexbuf[x];
					if (index != ssrf->pal->colorkey)
						rrgbbuf[x].data32 = MAKE_RGB888(pal[index].r, pal[index].g, pal[index].b);
				}
			}
		}
		//dcache_invalidate_way();
		return TRUE;
	}
	return FALSE;
}

/*
ARGB ==> RGB565
*/
static BOOL blit32to16(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x, y;
	register U8 r, g, b, a;
	register U32 bg_r, bg_g, bg_b;
	int spitch, dpitch;
	U32* argbbuf;
	U16* bg16buf;

	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;
	if (ssrf->pixtype == PIX_FMT_ARGB)
	{
		for (y = 0; y < h; y++)
		{
			argbbuf = (U32*)((U32)src + (spitch * y));
			bg16buf = (U16*)((U32)dest + (dpitch * y));
			for (x = 0; x < w; x++)
			{
				a = argbbuf[x] >> 24;
				if (a)
				{
					b = argbbuf[x] >> 0;
					g = argbbuf[x] >> 8;
					r = argbbuf[x] >> 16;

					if (a != 255) //
					{
						a = 255 - a;
						U16 bg_rgb = bg16buf[x];
						bg_r = (bg_rgb & 0xf100) >> 8;
						bg_g = (bg_rgb & 0x07e0) >> 3;
						bg_b = (bg_rgb & 0x01f) << 3;
						r += (((bg_r - (int)r) * a) >> 8);
						g += (((bg_g - (int)g) * a) >> 8);
						b += (((bg_b - (int)b) * a) >> 8);
					}
					bg16buf[x] = MAKE_RGB565(r, g, b);
				}
			}
		}
		//dcache_invalidate_way();
		return TRUE;
	}//ssrf->pixtype == PIX_FMT_ARGB
	else if (ssrf->pixtype == PIX_FMT_RGB888)
	{
		for (y = 0; y < h; y++)
		{
			rRGB* rgbbuf = (rRGB*)((U32)src + (spitch * y));
			U16* bg16buf = (U16*)((U32)dest + (dpitch * y));
			for (x = 0; x < w; x++)
			{
				r = rgbbuf[x].rrgb.r;
				g = rgbbuf[x].rrgb.g;
				b = rgbbuf[x].rrgb.b;
				bg16buf[x] = MAKE_RGB565(r, g, b);
			}
		}
		//dcache_invalidate_way();
		return TRUE;
	}//ssrf->pixtype == PIX_FMT_RGB888
	else
	{
		printk("Not Supported format (Source %dbpp, Destination %d)\n", ssrf->bpp, dsrf->bpp);
		return FALSE;
	}
}
static BOOL blit8to16(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x;
	register int y;
	register sARGB* pal;
	register U8 r, g, b, a;
	register U32 bg_r, bg_g, bg_b;
	register int spitch, dpitch;

	if (ssrf->pal == 0)
		return FALSE;
	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;

	pal = (sARGB*)ssrf->pal->colors;
	for (y = 0; y < h; y++)
	{
		U8* indexbuf = (U8*)((U32)src + (spitch * y));
		U16* bg16buf = (U16*)((U32)dest + (dpitch * y));
		if (ssrf->pixtype == PIX_FMT_A000) //first palette is used for color
		{
			r = pal->r;
			g = pal->g;
			b = pal->b;
			U16 rgb565 = MAKE_RGB565(r, g, b);
			for (x = 0; x < w; x++)
			{
				a = indexbuf[x];
				if (a)
				{
					if (a != 255) //
					{
						//a = 255-a;
						U16 bg_rgb = bg16buf[x];
						bg_r = (bg_rgb & 0xf100) >> 8;
						bg_r |= 0x7;
						bg_g = (bg_rgb & 0x07e0) >> 3;
						bg_g |= 0x3;
						bg_b = (bg_rgb & 0x01f) << 3;
						bg_b |= 0x3;
						r += (((bg_r - (int)r) * a) >> 8);
						g += (((bg_g - (int)g) * a) >> 8);
						b += (((bg_b - (int)b) * a) >> 8);
						bg16buf[x] = MAKE_RGB565(r, g, b);
					}
					else
						bg16buf[x] = rgb565;
				}
			}
		}
		else
		{
			for (x = 0; x < w; x++)
			{
				int index = indexbuf[x];
				if (index != ssrf->pal->colorkey)
					bg16buf[x] = MAKE_RGB565(pal[index].r, pal[index].g, pal[index].b);
			}
		}
	}
	//dcache_invalidate_way();
	return TRUE;
}
static BOOL blit8to32(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x;
	register int y;
	register sARGB* pal;
	register U8 r, g, b, a;
	register U32 bg_r, bg_g, bg_b;
	register int spitch, dpitch;

	if (ssrf->pal == 0)
		return FALSE;
	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;

	pal = (sARGB*)ssrf->pal->colors;
	for (y = 0; y < h; y++)
	{
		U8* indexbuf = (U8*)((U32)src + (spitch * y));
		U32* bg32buf = (U32*)((U32)dest + (dpitch * y));
		if (ssrf->pixtype == PIX_FMT_A000) //first palette is used for color
		{
			r = pal->r;
			g = pal->g;
			b = pal->b;
			U16 rgb = MAKE_RGB888(r, g, b);
			for (x = 0; x < w; x++)
			{
				a = indexbuf[x];
				if (a)
				{
					if (a != 255) //
					{
						//a = 255-a;
						U32 bg_rgb = bg32buf[x];
						EXTRACT_RGB(bg_rgb, bg_r, bg_g, bg_b);
						r += (((bg_r - (int)r) * a) >> 8);
						g += (((bg_g - (int)g) * a) >> 8);
						b += (((bg_b - (int)b) * a) >> 8);
						bg32buf[x] = MAKE_RGB888(r, g, b);
					}
					else
						bg32buf[x] = rgb;
				}
			}
		}
		else
		{
			for (x = 0; x < w; x++)
			{
				int index = indexbuf[x];
				if (index != ssrf->pal->colorkey)
					bg32buf[x] = MAKE_RGB888(pal[index].r, pal[index].g, pal[index].b);
			}
		}
	}
	//dcache_invalidate_way();
	return TRUE;
}

static BOOL blit4to16(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x;
	register int y;
	register sARGB* pal;
	register int spitch, dpitch;

	if (ssrf->pal == 0)
		return FALSE;
	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;
	pal = (sARGB*)ssrf->pal->colors;
	for (y = 0; y < h; y++)
	{
		U8* indexbuf = (U8*)((U32)src + (spitch * y));
		U16* bg16buf = (U16*)((U32)dest + (dpitch *  y));

		for (x = 0; x < w / 2; x++)
		{
			int index1 = (indexbuf[x] & 0xf0) >> 4;
			int index2 = indexbuf[x] & 0xf;

			if (index1 != ssrf->pal->colorkey)
				bg16buf[x * 2] = MAKE_RGB565(pal[index1].r, pal[index1].g, pal[index1].b);
			if (index2 != ssrf->pal->colorkey)
				bg16buf[x * 2 + 1] = MAKE_RGB565(pal[index2].r, pal[index2].g, pal[index2].b);
		}
	}
	//dcache_invalidate_way();
	return TRUE;
}

static BOOL blit4to32(U8* dest, SURFACE* dsrf, U8* src, SURFACE* ssrf, int w, int h)
{
	register int x;
	register int y;
	register sARGB* pal;
	register int spitch, dpitch;

	if (ssrf->pal == 0)
		return FALSE;
	spitch = ssrf->pitch;
	dpitch = dsrf->pitch;
	pal = (sARGB*)ssrf->pal->colors;
	for (y = 0; y < h; y++)
	{
		U8* indexbuf = (U8*)((U32)src + (spitch * y));
		U32* bg32buf = (U32*)((U32)dest + (dpitch * y));

		for (x = 0; x < w / 2; x++)
		{
			int index1 = (indexbuf[x] & 0xf0) >> 4;
			int index2 = indexbuf[x] & 0xf;

			if (index1 != ssrf->pal->colorkey)
				bg32buf[x * 2] = MAKE_RGB888(pal[index1].r, pal[index1].g, pal[index1].b);
			if (index2 != ssrf->pal->colorkey)
				bg32buf[x * 2 + 1] = MAKE_RGB888(pal[index2].r, pal[index2].g, pal[index2].b);
		}
	}
	//dcache_invalidate_way();
	return TRUE;
}
/*
return true, if coordinate is in clip-windows, otherwise return false
*/
static BOOL check_clipwindow(SURFACE* dsrf, int* dx, int* dy, int* sx, int* sy, int* w, int* h)
{
	int diff;
	if (*dx < dsrf->clip.x)
	{
		diff = dsrf->clip.x - *dx;
		*dx = dsrf->clip.x;
		*sx += diff;
		*w -= diff;
		if (*w <= 0)
			return false;
	}
	if (*dy < dsrf->clip.y)
	{
		diff = dsrf->clip.y - *dy;
		*dy = dsrf->clip.y;
		*sy += diff;
		*h -= diff;
		if (*h <= 0)
			return false;
	}
	if ((*dx + *w) > dsrf->clip.endx)
	{
		diff = (*dx + *w) - dsrf->clip.endx;
		*w -= diff;
		if (*w <= 0)
			return false;
	}
	if ((*dy + *h) > dsrf->clip.endy)
	{
		diff = (*dy + *h) - dsrf->clip.endy;
		*h -= diff;
		if (*h <= 0)
			return false;
	}
	return TRUE;
}
/*
ignore destination alpha value
*/
BOOL sw_draw_surface_rect(SURFACE* ssrf, int dx, int dy, int sx, int sy, int w, int h)
{
	U8* src;
	U8* dest;
	SURFACE* dsrf = get_ge_target_buffer();
	if (dy >= dsrf->h)
		return FALSE;
	if (dx >= dsrf->w)
		return FALSE;
	if ((dsrf->w - dx) < w)
		w = dsrf->w - dx;
	if ((dsrf->h - dy) < h)
		h = dsrf->h - dy;
	if (!((dsrf->bpp == 16) || (dsrf->bpp == 32)))
		return FALSE;
	if (check_clipwindow(ssrf, &dx, &dy, &sx, &sy, &w, &h) == false)
		return FALSE;
	src = (U8*)(((U32)ssrf->pixels) + (ssrf->pitch * sy) + (sx * (ssrf->bpp / 8)));
	dest = (U8*)(((U32)dsrf->pixels) + (dsrf->pitch * dy) + (dx * (dsrf->bpp / 8)));
	if ((dsrf->bpp == ssrf->bpp) && (dsrf->pixtype == ssrf->pixtype))
	{
		// 		dcache_invalidate_way();
		// 		dma_blockcpy(dest, src, dsrf->pitch, ssrf->pitch, w * (dsrf->bpp / 8), h);
		// 		return TRUE;
		return FALSE;
	}
	else
	{
		if (dsrf->bpp == 16)
		{
			if (ssrf->bpp == 32)
			{
				return blit32to16(dest, dsrf, src, ssrf, w, h);
			}//ssrf->bpp==32
			else if (ssrf->bpp == 8)
			{
				return blit8to16(dest, dsrf, src, ssrf, w, h);
			} // end ssrf->bpp==8
			else if (ssrf->bpp == 4)
			{
				return blit4to16(dest, dsrf, src, ssrf, w, h);
			} // end ssrf->bpp==8
		}
		else if (dsrf->bpp == 32)
		{
			if (dsrf->pixtype == PIX_FMT_RGB888)
				return blit32to32(dest, dsrf, src, ssrf, w, h);
			else if (ssrf->bpp == 8)
				return blit8to32(dest, dsrf, src, ssrf, w, h);
			else if (ssrf->bpp == 4)
				return blit4to32(dest, dsrf, src, ssrf, w, h);
		}
	}
	printk("Not Supported format yet(Source %dbpp, Destination %d)\n", ssrf->bpp, dsrf->bpp);
	return FALSE;
}

BOOL sw_draw_surface(SURFACE* src_surf, int dx, int dy)
{
	return draw_surface_rect(src_surf, dx, dy, 0, 0, src_surf->w, src_surf->h);
}


static BOOL ScaleLine(int dx, int dy, int dw, SURFACE* srcf, int sx, int sy, int sw)
{
	int NumPixels = dw;
	int IntPart = sw / dw;
	int FractPart = sw % dw;
	int E = 0;
	U8 a, r, g, b;

	SURFACE* targetsurface = get_ge_target_buffer();
	if (targetsurface->bpp == 16)
	{
		U16* dest = (U16*)(((U32)targetsurface->pixels) + (targetsurface->pitch*dy) + (dx * 2));
		if (srcf->bpp == 16)
		{
			U16* src = (U16*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			while (NumPixels-- > 0) {
				*dest = *src;
				dest++;
				src += IntPart;
				E += FractPart;
				if (E >= dw) {
					E -= dw;
					src++;
				} /* if */
			} /* while */
			return TRUE;
		}
		else if (srcf->bpp == 32)
		{
			U32* src = (U32*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			if (srcf->pixtype == PIX_FMT_ARGB)
			{
				while (NumPixels-- > 0) {
					a = (*src) >> 24;
					if (a)
					{
						b = (*src) >> 0;
						g = (*src) >> 8;
						r = (*src) >> 16;
						if (a != 255)
						{
							a = 255 - a;
							U8 bg_r, bg_g, bg_b;
							U16 bg_rgb = *dest;

							bg_r = (bg_rgb & 0xf100) >> 8;
							bg_g = (bg_rgb & 0x07e0) >> 3;
							bg_b = (bg_rgb & 0x01f) << 3;
							r += (((bg_r - (int)r)*a) >> 8);
							g += (((bg_g - (int)g)*a) >> 8);
							b += (((bg_b - (int)b)*a) >> 8);
						}
						*dest = MAKE_RGB565(r, g, b);
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
			else if (srcf->pixtype == PIX_FMT_RGB888)
			{
				while (NumPixels-- > 0) {
					b = (*src) >> 0;
					g = (*src) >> 8;
					r = (*src) >> 16;
					*dest = MAKE_RGB565(r, g, b);
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
		}
		else if (srcf->bpp == 8)
		{
			U8* src = (U8*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			sARGB* pal = (sARGB*)srcf->pal->colors;
			if (srcf->pixtype == PIX_FMT_A000)//first palette is used for color
			{
				U16 rgb565;
				r = pal->r;
				g = pal->g;
				b = pal->b;
				rgb565 = MAKE_RGB565(r, g, b);

				while (NumPixels-- > 0) {
					a = *src;
					if (a)
					{
						if (a != 255)
						{
							U8 bg_r, bg_g, bg_b;
							U16 bg_rgb = *dest;
							U8 r2 = r, g2 = g, b2 = b;
							a = 255 - a;
							bg_r = (bg_rgb & 0xf100) >> 8;
							bg_r |= 0x7;
							bg_g = (bg_rgb & 0x07e0) >> 3;
							bg_g |= 0x3;
							bg_b = (bg_rgb & 0x01f) << 3;
							bg_b |= 0x3;
							r2 += (((bg_r - (int)r2)*a) >> 8);
							g2 += (((bg_g - (int)g2)*a) >> 8);
							b2 += (((bg_b - (int)b2)*a) >> 8);

							*dest = MAKE_RGB565(r2, g2, b2);
						}
						else
						{
							*dest = rgb565;
						}
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
			else
			{
				while (NumPixels-- > 0) {
					if (*src != srcf->pal->colorkey)
					{
						*dest = MAKE_RGB565(pal[*src].r, pal[*src].g, pal[*src].b);
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
		}
		else if (srcf->bpp == 4)
		{
			U8* src = (U8*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			sARGB* pal = (sARGB*)srcf->pal->colors;
			U8* src_org = src;
			U32  src_offset = 0;
			while (NumPixels-- > 0) {
				if (*src != srcf->pal->colorkey)
				{
					U8 index = *(src_org + (src_offset >> 1));
					if (src_offset & 1)
						index = index & 0xf;
					else
						index = (index >> 4) & 0xf;

					*dest = MAKE_RGB565(pal[index].r, pal[index].g, pal[index].b);
				}
				dest++;
				src_offset += IntPart;
				E += FractPart;
				if (E >= dw) {
					E -= dw;
					src_offset++;
				} /* if */
			} /* while */
			return TRUE;
		}
	}
	else if (targetsurface->bpp == 32) //dest PIX_FMT_RGB888
	{
		U32* dest = (U32*)(((U32)targetsurface->pixels) + (targetsurface->pitch*dy) + (dx * 4));
		if (srcf->bpp == 16)
		{
			U16* src = (U16*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			while (NumPixels-- > 0) {
				r = ((*src) >> 8) & 0xf8;
				g = ((*src) >> 3) & 0xfc;
				b = ((*src) << 3);
				*dest = MAKE_RGB888(r, g, b);

				dest++;
				src += IntPart;
				E += FractPart;
				if (E >= dw) {
					E -= dw;
					src++;
				} /* if */
			} /* while */
			return TRUE;
		}
		else if (srcf->bpp == 32)
		{
			U32* src = (U32*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			U8 a, r, g, b;
			if (srcf->pixtype == PIX_FMT_ARGB)
			{
				while (NumPixels-- > 0) {
					a = (*src) >> 24;
					if (a)
					{
						b = (*src) >> 0;
						g = (*src) >> 8;
						r = (*src) >> 16;
						if (a != 255)
						{
							a = 255 - a;
							U8 bg_r, bg_g, bg_b;
							bg_r = (*dest) >> 16;
							bg_g = (*dest) >> 8;
							bg_b = (U8)(*dest);
							r += (((bg_r - (int)r)*a) >> 8);
							g += (((bg_g - (int)g)*a) >> 8);
							b += (((bg_b - (int)b)*a) >> 8);
						}
						*dest = MAKE_RGB888(r, g, b);
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
			else if (srcf->pixtype == PIX_FMT_RGB888)
			{
				while (NumPixels-- > 0) {
					*dest = *src;
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
		}
		else if (srcf->bpp == 8)
		{
			U8* src = (U8*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			sARGB* pal = (sARGB*)srcf->pal->colors;
			if (srcf->pixtype == PIX_FMT_A000)//first palette is used for color
			{
				U32 rgb888;
				r = pal->r;
				g = pal->g;
				b = pal->b;
				rgb888 = MAKE_RGB888(r, g, b);
				while (NumPixels-- > 0) {
					a = *src;
					if (a)
					{
						if (a != 255)
						{
							U8 bg_r, bg_g, bg_b;
							U32 bg_rgb = *dest;
							U8 r2 = r, g2 = g, b2 = b;
							a = 255 - a;
							bg_r = (bg_rgb & 0xf100) >> 8;
							bg_r |= 0x7;
							bg_g = (bg_rgb & 0x07e0) >> 3;
							bg_g |= 0x3;
							bg_b = (bg_rgb & 0x01f) << 3;
							bg_b |= 0x3;
							r2 += (((bg_r - (int)r2)*a) >> 8);
							g2 += (((bg_g - (int)g2)*a) >> 8);
							b2 += (((bg_b - (int)b2)*a) >> 8);

							*dest = MAKE_RGB888(r2, g2, b2);
						}
						else
						{
							*dest = rgb888;
						}
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
			else
			{
				while (NumPixels-- > 0) {
					if (*src != srcf->pal->colorkey)
					{
						*dest = MAKE_RGB888(pal[*src].r, pal[*src].g, pal[*src].b);
					}
					dest++;
					src += IntPart;
					E += FractPart;
					if (E >= dw) {
						E -= dw;
						src++;
					} /* if */
				} /* while */
				return TRUE;
			}
		}
		else if (srcf->bpp == 4)
		{
			U8* src = (U8*)(((U32)srcf->pixels) + (srcf->pitch*sy) + (sx*srcf->bpp / 8));
			sARGB* pal = (sARGB*)srcf->pal->colors;
			U8* src_org = src;
			U32  src_offset = 0;
			while (NumPixels-- > 0) {
				if (*src != srcf->pal->colorkey)
				{
					U8 index = *(src_org + (src_offset >> 1));
					if (src_offset & 1)
						index = index & 0xf;
					else
						index = (index >> 4) & 0xf;

					*dest = MAKE_RGB888(pal[index].r, pal[index].g, pal[index].b);
				}
				dest++;
				src_offset += IntPart;
				E += FractPart;
				if (E >= dw) {
					E -= dw;
					src_offset++;
				} /* if */
			} /* while */
			return TRUE;
		}
	}
	printk("Not Supports format ("__FILE__")\r\n");
	return FALSE;
}

BOOL sw_draw_surface_scalerect(SURFACE* src_surf, int dx, int dy, int dw, int dh, int sx, int sy, int sw, int sh)
{
	//calculate clip and surface 
	float d;
	SURFACE* targetsurface = get_ge_target_buffer();
	if (dx >= targetsurface->w)
		return FALSE;
	if (dy >= targetsurface->h)
		return FALSE;
	if (sx >= src_surf->w)
		return FALSE;
	if (sy >= src_surf->h)
		return FALSE;
	if (sx + sw > src_surf->w)
		sw = src_surf->w - sx;
	if (sy + sh > src_surf->h)
		sh = src_surf->h - sy;

	if (dx < 0)
	{
		d = (float)sw / dw;
		sx += (int)(d*(0 - dx));
		sw -= (int)(d*(0 - dx));
		dw -= (0 - dx);
		dx = 0;
	}

	if (dy < 0)
	{
		d = (float)sy / dy;
		sy += (int)(d*(0 - dy));
		sh -= (int)(d*(0 - dy));
		dh -= (0 - dy);
		dy = 0;
	}

	if (dx + dw > targetsurface->w)
	{
		d = (float)sw / dw;
		sw -= (int)(d*((dw + dx) - targetsurface->w));
		dw = targetsurface->w - dx;
	}
	if (dy + dh > targetsurface->h)
	{
		d = (float)sh / dh;
		sh -= (int)(d*((dh + dy) - targetsurface->h));
		dh = targetsurface->h - dy;
	}

	int NumPixels = dh;
	int IntPart = (sh / dh);
	int FractPart = sh% dh;
	int E = 0;
	while (NumPixels > 0)
	{
		if (ScaleLine(dx, dy, dw, src_surf, sx, sy, sw) == FALSE)
		{
			//dcache_invalidate_way();
			return FALSE;
		}
		dy++;
		sy += IntPart;
		E += FractPart;
		if (E >= dh)
		{
			E -= dh;
			sy++;
		}
		NumPixels--;
	}
	//dcache_invalidate_way();
	return TRUE;
}

BOOL sw_draw_surface_scale(SURFACE* src_surf, int dx, int dy, int dw, int dh)
{
	return sw_draw_surface_scalerect(src_surf, dx, dy, dw, dh, 0, 0, src_surf->w, src_surf->h);
}


//============== end of low-level api

//---------------------------------------------------------------------
// Video Capture Engine
//---------------------------------------------------------------------
#define ICE_BASE            0xF4002000
#define R_VCE_CTRL		((volatile unsigned int*)(ICE_BASE + 0x00))
#define R_VCE_STATS		((volatile unsigned int*)(ICE_BASE + 0x04))
#define R_VCE_YBUF(N)	((volatile unsigned int*)(ICE_BASE + 0x8 + (N*0xc)))
#define R_VCE_CBBUF(N)	((volatile unsigned int*)(ICE_BASE + 0xc + (N*0xc)))
#define R_VCE_CRBUF(N)	((volatile unsigned int*)(ICE_BASE + 0x10 + (N*0xc)))
#define R_VCE_OFFSET	((volatile unsigned int*)(ICE_BASE + 0x38))
#define R_VCE_NUMLINECUT0	((volatile unsigned int*)(ICE_BASE + 0x3C))
#define R_VCE_NUMLINECUT1 	((volatile unsigned int*)(ICE_BASE + 0x40))
#define R_VCE_NUMPXLCUT0 	((volatile unsigned int*)(ICE_BASE + 0x44))
#define R_VCE_NUMPXLCUT1 	((volatile unsigned int*)(ICE_BASE + 0x48))
#define R_VCE_WIDTH 	((volatile unsigned int*)(ICE_BASE + 0x4C))
#define YCCAP_EN              1<<0
#define HALF_REQ              1<<1
#define UYVY		          2<<2
#define VYUY		          3<<2
#define YUYV		          0<<2
#define YVYU		          1<<2
#define DECOD_EN              1<<4
#define VCLK_INV	          1<<5
#define ODD_INTEN             1<<6
#define EVEN_INTEN            1<<7
//#define USE2NDBUF	          1<<8
//#define PXCNTLNVLD	      1<<9
#define COPYOFF	      		1<<10
#define CSCEN		  		1<<11
#define CS_RGB888	  		1<<12
#define RGB565		  		0
#define HALFLINE	  		1<<13
#define EVENFLD	  	  		1<<14
#define ODDFLD	  	  		~EVENFLD
#define ALLFLD	  	  		1<<15

static BOOL vce_on_surface(SURFACE* dst, int x, int y, BOOL halfmode)
{
	if (halfmode)
	{
		if (((dst->w - x) < 360) || ((dst->h - y) < 240))
			return FALSE;

	}
	else
	{
		if (((dst->w - x) < 720) || ((dst->h - y) < 480))
			return FALSE;
	}

	int bytepp;
	if (dst->bpp < 16)
		return FALSE;
	if (dst->bpp == 16)
		bytepp = 2;
	else  // 24, 32bpp
		bytepp = 4;

	*R_VCE_NUMLINECUT0 = 0;
	*R_VCE_NUMLINECUT1 = 0;
	*R_VCE_NUMPXLCUT0 = 0;
	*R_VCE_NUMPXLCUT1 = 0;
	*R_VCE_WIDTH = dst->pitch / bytepp;

	*R_VCE_YBUF(0) = *R_VCE_YBUF(1) = *R_VCE_YBUF(2) = *R_VCE_YBUF(3) = (U32)dst->pixels + (x * bytepp) + (y * dst->pitch);
	int mode = YCCAP_EN | DECOD_EN | CSCEN | UYVY;
	if (bytepp == 4)
	{
		mode |= CS_RGB888;
	}
	if (halfmode)
	{
		mode |= HALFLINE;
		*R_VCE_OFFSET = *R_VCE_WIDTH - 360;
	}
	else
	{
		mode |= ALLFLD;
		*R_VCE_OFFSET = *R_VCE_WIDTH - 720;
	}

	*R_VCE_CTRL = mode;
	return TRUE;
}
#if 0
static void vce_off()
{
	*R_DC_FESR = 0;
	*R_DC_FESR = (1 << 4) | (1 << 1);
	*R_VCE_CTRL = 0;
}
#endif

//============= external video capture

#define CAM_DISP_INTERVAL	(HZ/20)

int enable_direct_cam=FALSE;
static SURFACE* Surface_Cam;

static SURFACE* Surface_fpga_Cam;


static int amazon2_graphic_open(struct inode *inode, struct file *file)
{
	MOD_INC_USE_COUNT;
	return 0;
}

static int amazon2_graphic_release(struct inode *inode, struct file *file)
{
	MOD_DEC_USE_COUNT;
	return 0;
}

//#define GPIO_BASE	0xf0001c00

#define R_GPFED(ch) ((volatile unsigned int*)(GPIO_BASE+0x24+(0x40*(ch))))
#define R_GPEDS(ch) ((volatile unsigned int*)(GPIO_BASE+0x28+(0x40*(ch))))
#define SOURCE_ADDR 	0x60000000


#define _AXI_DMA_BASE_	0xF4002c00
#define R_XDMAEN	((volatile U32 *)_AXI_DMA_BASE_)
#define R_XDMAIEN	((volatile U32 *)(_AXI_DMA_BASE_+4))
#define R_XDMASRC(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x80+(ch*40)))
#define R_XDMADST(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x84+(ch*40)))
#define R_XDMACON0(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x8c+(ch*40)))
#define R_XDMACON1(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x90+(ch*40)))
#define R_XDMASCOA(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x94+(ch*40)))
#define R_XDMADCOA(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x98+(ch*40)))
#define R_XDMAST(ch)	((volatile U32 *)(_AXI_DMA_BASE_+0x9c+(ch*40)))

static void inline dma_memcpy(void* dest, void* src, U32 bytelen)
{
	U32 conval = 0;
	U32 bitwidth = 8;
	U32 transfer_size = bytelen;

	int dmach = 0;

	if (bytelen > 4)
	{
		if (((U32)dest & 0x3) == 0) //32bit
		{
			conval |= 1 << 3;
		}
		else if (((U32)dest & 0x1) == 0) //16bit
		{
			conval |= 1 << 2;
		}

		if (((U32)src & 0x3) == 0) //32bit
		{
			conval |= 1 << 11;
			transfer_size = bytelen >> 2;
			bitwidth = 32;
		}
		else if (((U32)src & 0x1) == 0) //16bit
		{
			conval |= 1 << 10;
			transfer_size = bytelen >> 1;
			bitwidth = 16;
		}
	}
	conval |= 0x1 << 8 | 0x1; //address increment

	*R_XDMASRC(dmach) = (U32)src;
	*R_XDMADST(dmach) = (U32)dest;

	U32 reloadcnt = transfer_size >> 11; // devide by 0x800

	if (reloadcnt)
	{
		*R_XDMACON0(dmach) = 0x800 << 20 | conval;

		*R_XDMASCOA(dmach) = 0x0;
		*R_XDMADCOA(dmach) = 0x0;

		*R_XDMAST(dmach) = reloadcnt - 1;
		*R_XDMACON1(dmach) = 1 << 18 | 1 << 12 | 1 << 4;

		*R_XDMAEN = 0x1;
		*R_XDMAIEN |= 0x1 << dmach;

		while ((*R_XDMAIEN) & (1 << dmach));

		U32 totaltx = (bitwidth / 8) * 0x800 * reloadcnt;
		U32 remain = bytelen - totaltx;

		if (remain)
		{
			memcpy((U8*)dest + totaltx, (U8*)src + totaltx, remain);
		}
	}
	else
	{
		conval |= transfer_size << 20;
		*R_XDMACON0(dmach) = conval;
		*R_XDMACON1(dmach) = 0;

		*R_XDMAEN = 0x1;
		*R_XDMAIEN = 0x1 << dmach;
		while (((*R_XDMAIEN) & (1 << dmach)));
		U32 totaltx = (bitwidth / 8) * transfer_size;
		U32 remain = bytelen - totaltx;
		if (remain)
		{
			memcpy((U8*)dest + totaltx, (U8*)src + totaltx, remain);
		}
	}
}
static void inline read_fpga_data(u8 *buf) //180*120*2 byte
{
	*(volatile U32*)0xF0000400 |= 1 << 1; // SRAM CS 0 data bus width 16bit
	*R_GPFED(3) = (3 << 5);

	*R_GPEDS(3) = 3 << 5;//clear
	U8 stat = *R_GPEDS(3);


	while (!(stat & (3 << 5)))
	{
		stat = *R_GPEDS(3);
	}

	if (stat  & (1 << 5))
	{
		dma_memcpy(buf, (void*)SOURCE_ADDR, 180 * 2 * 120);
		*R_GPEDS(3) = 1 << 5;
	}
	else if (stat & (1 << 6))
	{
		dma_memcpy(buf, (void*)(SOURCE_ADDR + 0x10000), 180 * 2 * 120);
		*R_GPEDS(3) = 1 << 6;
	}
}
static void inline write_fpga_data(u8* buf)
{
	int y;
	u8* dest = Surface_fpga_Cam->pixels;

	for (y = 0; y < Surface_fpga_Cam->h; y++, buf += 180 * 2)
	{
		memcpy(dest + (y * Surface_fpga_Cam->pitch), buf, Surface_fpga_Cam->w * 2);
	}
}

static int amazon2_graphic_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
{
	int ret = 0;
	//get_user(tmp, (int*)arg);
	//printk("cmd : %d, arg : %x\n", cmd, arg);
	
	switch (cmd) {
	case AMAZON2_IOCTL_CLEAR_SCREEN:
		ge_draw_rectfill(0, 0, SCREEN_W, SCREEN_H, MAKE_COLORREF(255, 255, 255));
		break;
	
	case AMAZON2_IOCTL_GET_DIRECT_CAMERA_SURFACE:
		if (enable_direct_cam==0) {
			vce_on_surface(Surface_Cam, 0, 0, TRUE);
			enable_direct_cam = 1;
		}
		return (int)Surface_Cam;

	case AMAZON2_IOCTL_CREATE_SURFACE:
	{
		CreateSurfaceArg ar;
		copy_from_user(&ar, (void*)arg, sizeof(CreateSurfaceArg));
		return (int)create_surface(ar.w, ar.h, ar.bpp);
	}
		break;
	
	case AMAZON2_IOCTL_RELEASE_SURFACE:
		release_surface((SURFACE*)arg);
		break;
	
	case AMAZON2_IOCTL_DRAW_SURFACE:
	{
		DrawSurfaceArg ar;
		copy_from_user(&ar, (void*)arg, sizeof(DrawSurfaceArg));
		draw_surface(ar.surf,ar.dx,ar.dy);
		break;
	}

	case AMAZON2_IOCTL_DRAW_SURFACE_RECT:
	{
		DrawSurfaceRectArg ar;
		copy_from_user(&ar, (void*)arg, sizeof(DrawSurfaceRectArg));
		draw_surface_rect(ar.surf, ar.dx, ar.dy, ar.rect.x, ar.rect.y, ar.rect.w, ar.rect.h);
		break;
	}
	
	case AMAZON2_IOCTL_DRAW_SURFACE_SCALE_RECT:
	{
		DrawSurfaceScaleRectArg ar;
		copy_from_user(&ar, (void*)arg, sizeof(DrawSurfaceScaleRectArg));
		draw_surface_scalerect(ar.surf, ar.dest_rect.x, ar.dest_rect.y, ar.dest_rect.w, ar.dest_rect.h, ar.surf_rect.x, ar.surf_rect.y, ar.surf_rect.w, ar.surf_rect.h);
		break;
	}
	
	case AMAZON2_IOCTL_FLIP:
		flip();
		break;
	
	case AMAZON2_IOCTL_FLIPWAIT:
		flip_wait();
		break;
	
	case AMAZON2_IOCTL_READ_FPGA_VIDEO_DATA:
		//read from FPGA
		read_fpga_data((void*)arg);
		break;
	case AMAZON2_IOCTL_DRAW_FPGA_VIDEO_DATA:
	{
		DrawFPGADataArg ar;
		copy_from_user(&ar, (DrawFPGADataArg*)arg, sizeof(DrawFPGADataArg));
		write_fpga_data((void*)ar.buf);
		draw_surface(Surface_fpga_Cam, ar.dx, ar.dy);
		break;
	}

	case AMAZON2_IOCTL_DRAW_FPGA_VIDEO_DATA_FULL:
	{
		write_fpga_data((void*)arg);

		int org_mode = Surface_fpga_Cam->drawmode;

		Surface_fpga_Cam->drawmode |= DRAWMODE_NOREPEAT;

		// ge_draw(Surface_fpga_Cam, 0, 0, 319, 479, 0, 60416, 0, -189, 189, 0);	// zoom : 2.7
		// ge_draw(Surface_fpga_Cam, 0, 0, 319, 479, 0, 60440, 0, -192, 192, 0);	// zoom : 2.66
		ge_draw(Surface_fpga_Cam, 0, 0, 319, 479, 0, 60928, 0, -191, 191, 0);	// zoom : 2.67

		Surface_fpga_Cam->drawmode = org_mode;
		break;
	}

	case AMAZON2_IOCTL_DRAW_IMG_FROM_BUFFER:
	{
		DrawRaw_value draw_value;
		int org_mode = Surface_fpga_Cam->drawmode;

		copy_from_user(&draw_value, (DrawRaw_value*)arg, sizeof(DrawRaw_value));

		write_fpga_data((void *)draw_value.imgbuf);
		Surface_fpga_Cam->drawmode |= DRAWMODE_NOREPEAT;

		ge_draw(Surface_fpga_Cam, draw_value.InitDX, draw_value.InitDY, draw_value.EndX, draw_value.EndY, draw_value.InitSX, draw_value.InitSY, draw_value.dxSx, draw_value.dxSy, draw_value.dySx, draw_value.dySy);

		Surface_fpga_Cam->drawmode = org_mode;
		break;
	}
	
	case AMAZON2_IOCTL_DRAW_RECT_FILL:
	{
		DrawRectFillArg ar;
		copy_from_user(&ar, (DrawRectFillArg*)arg, sizeof(DrawRectFillArg));
		ge_draw_rectfill(ar.rect.x, ar.rect.y, ar.rect.w, ar.rect.h, ar.clr);
		break;
	}

	case AMAZON2_IOCTL_CAM_DISP_ON:
		if(enable_direct_cam)
			break;
		else {
			enable_direct_cam = 1;
			cam_timer.expires = jiffies + CAM_DISP_INTERVAL;
			add_timer(&cam_timer);
		}
		break;

	case AMAZON2_IOCTL_CAM_DISP_OFF:
		enable_direct_cam = 0;
		del_timer(&cam_timer);	
		break;

	case AMAZON2_IOCTL_CAM_DISP_STAT:
		return enable_direct_cam;
		break;
	
	default:
		ret = -1;
		break;
	}

	return ret;
}

static struct file_operations amazon2_graphic_fops = {
	owner:THIS_MODULE,
	read : NULL,
	write : NULL,
	poll : NULL,
	ioctl : amazon2_graphic_ioctl,
	fasync : NULL,
	open : amazon2_graphic_open,
	release : amazon2_graphic_release,
};

void led_toggle(void)
{
	unsigned int status;

	status = amazon2_gpio_getpin(AMAZON2_LED_PORT);

	if(status & (0x1 << 7))
		amazon2_gpio_setpin(AMAZON2_LED_PORT, 0);	// LED ON
	else
		amazon2_gpio_setpin(AMAZON2_LED_PORT, 1);	// LED OFF
}

void cam_timer_handler(unsigned long data)
{
	SURFACE* src = Surface_Cam;
	int orgmode = src->drawmode;

	led_toggle();
	
	src->drawmode |= DRAWMODE_NOREPEAT;
	ge_draw(src, 0, 0, 319, 479, 4608, 119808, 0, -364, 364, 0);
	src->drawmode = orgmode;
	
	flip();

	if(enable_direct_cam) {
		cam_timer.expires = jiffies + CAM_DISP_INTERVAL;
		add_timer(&cam_timer);
	}
}

#define	GEC_RUN2D			1
#define	GEC_CANCEL2D		0

#define	GEC_DITHERNONE		(0x0<<6)
#define	GEC_DITHER2x2		(0x1<<6)
#define	GEC_DITHER4x4		(0x2<<6)

u8 cambuf[180 * 120 * 2];

int __init  init_module(void)
{
	int ret;
	if ((ret = register_chrdev(AMAZON2_GRAPHIC_MAJOR, AMAZON2_GRAPHIC_NAME, &amazon2_graphic_fops)) != 0) {
		printk(KERN_ERR "Cannot register " AMAZON2_GRAPHIC_NAME "\n");
		return ret;
	}
	ge_wait_cmd_complete();

	// graphic engine was initialized by bootloader

	int i;
	for (i = 0; i < MAX_FRAMEBUFFER; i++)
	{
		Surface_framebuffer[i].bpp = 16;//RGB565
		Surface_framebuffer[i].w = 320;
		Surface_framebuffer[i].h = 480;
		Surface_framebuffer[i].pitch = 1024;
		Surface_framebuffer[i].TileXSize = 9 - 3;
		Surface_framebuffer[i].TileYSize = 9;

		Surface_framebuffer[i].clip.x = 0;
		Surface_framebuffer[i].clip.y = 0;
		Surface_framebuffer[i].clip.endx = SCREEN_W - 1;
		Surface_framebuffer[i].clip.endy = SCREEN_H - 1;
		Surface_framebuffer[i].pixtype = PIX_FMT_RGB565;
	}
	Surface_framebuffer[0].pixels = (void*)0xc4000000;
	Surface_framebuffer[1].pixels = (void*)0xc4080000;

	_ge_CurCommandNum = *R_GE_PWP;

	Surface_Cam = create_surface(360, 240, 16);
	Surface_fpga_Cam = create_surface(180, 120, 16);

	ge_draw_rectfill(0, 0, SCREEN_W, SCREEN_H, MAKE_COLORREF(0, 0, 0));
	flip();
	
	ge_draw_rectfill(0, 0, SCREEN_W, SCREEN_H, MAKE_COLORREF(0, 0, 0));
	flip();

	enable_direct_cam = 1;

	if(enable_direct_cam)
		vce_on_surface(Surface_Cam, 0, 0, TRUE);
	
	init_timer(&cam_timer);

	cam_timer.function = cam_timer_handler;
	cam_timer.data = 0;
	cam_timer.expires = jiffies + CAM_DISP_INTERVAL;
	add_timer(&cam_timer);

	printk("AMAZON2 Graphic Engine Driver init Done." AMAZON2_GRAPHIC_VERSION "\n");


	return ret;
}

void __exit  cleanup_module(void)
{
	ge_draw_rectfill(0, 0, SCREEN_W, SCREEN_H, MAKE_COLORREF(0, 0, 0));
	flip();

	amazon2_gpio_setpin(AMAZON2_LED_PORT, 1);   // LED OFF	
	del_timer(&cam_timer);
	unregister_chrdev(AMAZON2_GRAPHIC_MAJOR, AMAZON2_GRAPHIC_NAME);
}

MODULE_AUTHOR("SW Team <http://www.adc.co.kr>");
MODULE_DESCRIPTION("AMAZON2 2D GRAPHIC ENGINE Driver");
MODULE_LICENSE("GPL");

