//2009/8/18
//+------------------------------------------------------------------+
//| TMA.mq4 gaps
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Orange
#property indicator_color2 Gray
#property indicator_level1 0
#property indicator_levelstyle STYLE_SOLID
#property indicator_levelcolor Teal
//---- buffers
double Buf[];
double SG[];
double BS[];
//---- parameters
extern int FastMA=8;
extern int MidMA=16;
extern int SlowMA=25;
extern int SlowingSMA=3;
extern int SlowingLWMA=8;
//
string Unq="TMAG",Label;
int MAP;
//+------------------------------------------------------------------+
//| init
//+------------------------------------------------------------------+
int init()
{
	MAP=MathMax(SlowingSMA,SlowingLWMA);
	string sp1="("+FastMA+"/"+MidMA+"/"+SlowMA+")",sp2="("+SlowingSMA+","+SlowingLWMA+")";
	IndicatorBuffers(3);
	SetIndexBuffer(0,SG);SetIndexLabel(0,sp1);SetIndexDrawBegin(0,SlowMA+MAP);
	SetIndexBuffer(1,BS);SetIndexLabel(1,sp2);SetIndexDrawBegin(1,SlowMA+MAP);
	SetIndexBuffer(2,Buf);
	Label=Unq+sp1+">>A"+sp2;
	IndicatorShortName(Label);
	return(0);
}
//+------------------------------------------------------------------+
//| main
//+------------------------------------------------------------------+
int start()
{
	int cntbar=IndicatorCounted();
	int limit=Bars-cntbar;
	if(cntbar==0)limit-=SlowMA;
	for(int i=limit-1;i>=0;i--)
	{
		double ma1=iMA(NULL,0,FastMA,0,MODE_SMA,PRICE_CLOSE,i);
		double ma2=iMA(NULL,0,MidMA,0,MODE_SMA,PRICE_CLOSE,i);
		double ma3=iMA(NULL,0,SlowMA,0,MODE_SMA,PRICE_CLOSE,i);
		Buf[i]=MathAbs(ma1-ma2)+MathAbs(ma2-ma3)+MathAbs(ma1-ma3);
		double di=iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,i)-iADX(NULL,0,14,PRICE_LOW,MODE_MINUSDI,i);
		Buf[i]*=di/Point;
	}
	if(cntbar==0)limit-=MAP;
	for(i=limit-1;i>=0;i--)
	{
		SG[i]=iMAOnArray(Buf,0,SlowingSMA,0,MODE_SMA,i);
		BS[i]=iMAOnArray(Buf,0,SlowingLWMA,0,MODE_LWMA,i);
	}
   return(0);
}
//+------------------------------------------------------------------+