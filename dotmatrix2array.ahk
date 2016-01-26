
#NoEnv
#Include gdip.ahk
; FileEncoding, UTF-8
SetWorkingDir %A_ScriptDir%
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

Gui, 1:Default
Gui, +hwndgui1
Gui, Color, ffffff
Gui, Font, s10, Console
Gui, Add ,Text, Section y+15 ,x 轴点数：
Gui, Add ,Text, xs y+15 ,y 轴点数：
Gui, Add ,Text, xs y+15 ,像素点宽：
Gui, Add ,Text, xs y+15,像素点高：
Gui, Add ,Text, xs y+15,x 间隔：
Gui, Add ,Text, xs y+15,y 间隔：
Gui, Add,Edit, Number Section w120 x+5 ys R1 +BackgroundTrans vwn,32
Gui, Add,Edit, Number xs R1 wp +BackgroundTrans vhn,32
Gui, Add,Edit, Number xs R1 wp +BackgroundTrans vw,10
Gui, Add,Edit, Number xs R1 wp +BackgroundTrans vh,10
Gui, Add,Edit, Number xs R1 wp +BackgroundTrans vmx,1
Gui, Add,Edit, Number xs R1 wp +BackgroundTrans vmy,1
Gui, Add,Button, xm w180 r4 gcreate,生成
Gui, Add,Text, Right r2,script by:Nigh`njiyucheng007@gmail.com
Gui, Show, AutoSize

Return

;~ hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
;~ SetImage(hwnd, hBitmap)

;~ pBrushFront := Gdip_BrushCreateSolid(Foreground), pBrushBack := Gdip_BrushCreateSolid(Background)
;~ pBitmap := Gdip_CreateBitmap(Posw, Posh), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4)
;~ Gdip_FillRectangle(G, pBrushBack, 0, 0, Posw, Posh)
;~ Gdip_FillRoundedRectangle(G, pBrushFront, 4, 4, (Posw-8)*(Percentage/100), Posh-8, (Percentage >= 3) ? 3 : Percentage)
;~ Gdip_DeleteBrush(pBrushFront), Gdip_DeleteBrush(pBrushBack)
;~ Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
; DeleteObject(hBitmap)
; Gdip_SetPixel(pBitmap, x, y, ARGB)

create:
Gui, 1:Submit

ToolTip, 正在生成...



pBrush1 := Gdip_BrushCreateSolid(0xFF77AAFF)
pBrush2 := Gdip_BrushCreateSolid(0xFF333432)
pBitmap1 := Gdip_CreateBitmap(w, h), G1 := Gdip_GraphicsFromImage(pBitmap1), Gdip_SetSmoothingMode(G1, 1)
pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 1)
Gdip_FillRectangle(G1, pBrush1, 0, 0, w, h)
Gdip_FillRectangle(G2, pBrush2, 0, 0, w, h)
hBitmap1 := Gdip_CreateHBITMAPFromBitmap(pBitmap1)
hBitmap2 := Gdip_CreateHBITMAPFromBitmap(pBitmap2)

pBitmap_Ex := Gdip_CreateBitmap(wn, hn), G_Ex := Gdip_GraphicsFromImage(pBitmap_Ex), Gdip_SetSmoothingMode(G_Ex, 1)
Gdip_FillRectangle(G_Ex, pBrush2, 0, 0, wn, hn)
; Gdip_DeleteBrush(pBrush1)
; Gdip_DeleteBrush(pBrush2)

Gui, 2:Default
Gui, +hwndgui2 +AlwaysOnTop
Gui, Color, ffffff
harray:=Object()
Loop, % wn
{
	x_index:=A_Index
	x:=(w+mx)*(A_Index-1)
	Loop, % hn
	{
		y_index:=A_Index
		y:=(h+my)*(A_Index-1)
		Gui, Add, Pic, % "x" x+w " y" y+h " w" w " h" h " hwndtemp" " 0xe gdotclick"
		harray[x_index,y_index,"hwnd"]:=temp
		harray[x_index,y_index,"statu"]:=0
		SetImage(temp, hBitmap2)
	}
}

Gui, Add,Text, xm Section, 起始位置：
Gui, Add,Radio,Group vr1 r1.2 Checked gsubmit, 左上
Gui, Add,Radio,x+0 vr2 r1.2 gsubmit, 右上
Gui, Add,Radio,xs vr3 r1.2 gsubmit, 左下
Gui, Add,Radio,x+0 vr4 r1.2 gsubmit, 右下

Gui, Add,Text,ys Section, 方向：
Gui, Add,Radio,Group vrx r1.2 Checked gsubmit, 横向
Gui, Add,Radio,vry r1.2 gsubmit, 纵向

Gui, Add,Text,ys Section, 位顺序：
Gui, Add,Radio,Group vlsb r1.2 Checked gsubmit, 低位在前
Gui, Add,Radio, vmsb r1.2 gsubmit, 高位在前
Gui, Add,Button, r3 ys w50 gclear, 清空

Gui, Add,Checkbox,visTranspose gtranspose r1.2 xm, 转置
Gui, Add,Text, x+10, 透明度：
Gui, Add,Slider, x+0 w200 gchangeTrans vtransValue hwndhSlider, 0

Gui, Add, Pic, w%wn% h%hn% hwndbitmap 0xe,X

_editwidth:=(w+mx)*(wn)-mx < 230 ? 230 : (w+mx)*(wn)-mx
Gui, Add, Edit, % "ReadOnly R" (wn+3>16?16:wn+3) " x" w " w" _editwidth " voutput"
Gui, Show, AutoSize
Gui, Submit, NoHide
ToolTip
SetFormat, Integer, hex

OnMessage(0x200,"onMousemove")
OnMessage(0x201,"onMouseDown")
OnMessage(0x202,"onMouseUp")
Return

SetImage_simple(byref pBitmap,handle)
{
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(handle, hBitmap)
	DeleteObject(hBitmap)
}

onMousemove()
{
	global oldHandler
	If(GetKeyState("LButton","P")=1)
	{
		MouseGetPos,,,,handler,2
		if(oldHandler!=handler)
		{
			Gosub, dotclickEx
		}
	}
}

onMouseDown(wp,lp,msg,hwnd)
{
	global
	; ToolTip, % hwnd
	if(hwnd=hSlider){
		SetTimer, changeTrans, 25
	}
}

onMouseUp(wp,lp,msg,hwnd)
{
	global
	SetTimer, changeTrans, Off
}



submit:
Gui, 2:Submit, NoHide
Gosub, output
Return

changeTrans:
gui, 2:Submit, NoHide
TransparentV:=255-(transValue)*2.3
if(TransparentV<30)
	TransparentV:=30
WinSet, Transparent, %TransparentV%, ahk_id %gui2%
Return

transpose:
gui, 2:Submit, NoHide
Gosub, output
Return

clear:
Loop, % wn
{
	x_index:=A_Index
	Loop, % hn
	{
		y_index:=A_Index
		harray[x_index,y_index,"statu"]:=0
		SetImage(harray[x_index,y_index,"hwnd"], hBitmap2)
	}
}
Gdip_FillRectangle(G_Ex, pBrush2, 0, 0, wn, hn)
SetImage_simple(pBitmap_Ex,bitmap)
Goto output

dotclickEx:
isMouseMove:=1
dotclick:
MouseGetPos,,,,handler,2
oldHandler:=handler
Loop, % wn
{
	x_index:=A_Index
	Loop, % hn
	{
		y_index:=A_Index
		If(harray[x_index,y_index,"hwnd"]=handler)
		{
			if(isMouseMove)
			{
				harray[x_index,y_index,"statu"]:=oldAction
			}
			Else
			{
				harray[x_index,y_index,"statu"]:=!harray[x_index,y_index,"statu"]
				oldAction:=harray[x_index,y_index,"statu"]
			}
			If(harray[x_index,y_index,"statu"]=1)
			{
				SetImage(handler, hBitmap1)
				Gdip_SetPixel(pBitmap_Ex, x_index, y_index, 0xFF77AAFF)
			}
			Else
			{
				SetImage(handler, hBitmap2)
				Gdip_SetPixel(pBitmap_Ex, x_index, y_index, 0xFF333432)
			}
			Break 2
		}
	}
}
SetImage_simple(pBitmap_Ex,bitmap)
isMouseMove:=0

output:
SetFormat, Integer, Hex
o_input:=Object()
If(ry)
{
	Loop, % hn
	{
		y_index:=A_Index
		Loop, % wn
		{
			x_index:=A_Index
			o_input[y_index,x_index,"statu"]:=harray[x_index,y_index,"statu"]
		}
	}
	wnR:=hn
	hnR:=wn
;~ 	转置后坐标调换(后面的说明均使用转置后的坐标)
	o_input_bak:=ObjClone(o_input,wnR,hnR)
	If(r2)	;Y轴倒转
	{
		Gosub, invYAxis
	}
	Else If(r3)	;X轴倒转
	{
		Gosub, invXAxis
	}
	Else If(r4)	;两轴倒转
	{
		Gosub, invYAxis
		o_input_bak:=ObjClone(o_input,wnR,hnR)
		Gosub, invXAxis
	}
}
Else	;If(rx)
{
	wnR:=wn
	hnR:=hn
	o_input:=ObjClone(harray,wnR,hnR)
	o_input_bak:=ObjClone(o_input,wnR,hnR)
	If(r2)	;X轴倒转
	{
		Gosub, invXAxis
	}
	Else If(r3)	;Y轴倒转
	{
		Gosub, invYAxis
	}
	Else If(r4)	;两轴倒转
	{
		Gosub, invYAxis
		o_input_bak:=ObjClone(o_input,wnR,hnR)
		Gosub, invXAxis
	}
}
o_output:=Object()
x_out:=1
y_out:=1
x_max:=Ceil(wnR/8)
y_max:=Ceil(hnR)

Loop, % hnR
{
	y_index:=A_Index
	hex:=0
	Loop, % wnR
	{
		x_index:=A_Index
		hex|=o_input[x_index,y_Index,"statu"]<<Mod(x_index-1,8)
		If(A_Index=wnR)
		{
			o_output[x_out,y_out,"statu"]:=hex
			y_out++
			x_out:=1
		}
		Else If(Mod(x_index,8)=0)
		{
			o_output[x_out,y_out,"statu"]:=hex
			x_out++
			hex:=0
		}
		
	}
}

if(!isTranspose)
{
	outputs:="array[" y_max "][" x_max "]=`n{`n"
	Loop, % y_max
	{
		y_out:=A_Index
		outputs.="`t{"
		Loop, % x_max
		{
			if(A_Index>1)
				outputs.=","
			If(msb)
				outputs.=formatHex(invhex(o_output[A_Index,y_out,"statu"]))
			Else
				outputs.=formatHex(o_output[A_Index,y_out,"statu"])
		}
		outputs.="}"
		if(A_Index<y_max)
			outputs.=","
		outputs.="`n"
	}
	outputs.="}"
}
Else
{
	outputs:="array[" x_max "][" y_max "]=`n{`n"
	Loop, % x_max
	{
		x_out:=A_Index
		outputs.="`t{"
		Loop, % y_max
		{
			if(A_Index>1)
				outputs.=","
			If(msb)
				outputs.=formatHex(invhex(o_output[x_out,A_Index,"statu"]))
			Else
				outputs.=formatHex(o_output[x_out,A_Index,"statu"])
		}

		outputs.="}"
		if(A_Index<x_max)
			outputs.=","
		outputs.="`n"
	}
	outputs.="}"
}
SetFormat, Integer, dec
GuiControl,2:, output, %outputs%
Return


ObjClone(object,x,y)
{
	obj:=Object()
	Loop, % y
	{
		iy:=A_Index
		Loop, % x
		{
			ix:=A_Index
			obj[ix,iy,"statu"]:=object[ix,iy,"statu"]
		}
	}
	Return, obj
}


debugx(object,x,y)
{
	formatOld:=A_FormatInteger
	SetFormat, Integer, dec
	Loop, % y
	{
		iy:=A_Index
		Loop, % x
		{
			ix:=A_Index
			output.=object[ix,iy,"statu"] " "
		}
		output.="`n"
	}
	If(formatOld="H")
	SetFormat, Integer, hex
	Return, output
}

invYAxis:
Loop, % hnR
{
	y_index:=A_Index
	Loop, % wnR
	{
		x_index:=A_Index
		o_input[x_index,y_index,"statu"]:=O_input_bak[x_index,hnR-y_index+1,"statu"]
	}
}
Return

invXAxis:
Loop, % wnR
{
	x_index:=A_Index
	Loop, % hnR
	{
		y_index:=A_Index
		o_input[x_index,y_index,"statu"]:=O_input_bak[wnR-x_index+1,y_index,"statu"]
	}
}
Return

2GuiSize:
guimove:
WinGetPos, gui2X, gui2Y, gui2W, , ahk_id %gui2%
WinMove, ahk_id %gui3%,, % gui2X+gui2W , % gui2Y
Return

formathex(hex)
{
	Return, "0x" SubStr("000" SubStr(hex,3),-1)
}

invhex(hex)
{
	nhex:=0
	SetFormat, Integer, H
	Loop, 8
	{
		nhex<<=1
		nhex+=(hex&0x1)
		hex>>=1
	}
	RegExMatch(nhex,"0x(.+)",match)
	If(StrLen(match1)!=2)
	nhex:="0x0" match1
	Else
	nhex:="0x" match1
	Return, nhex+0
}

; F5::
GuiClose:
1GuiClose:
2GuiClose:
Exit:
ExitApp
