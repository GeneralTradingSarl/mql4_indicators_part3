//+------------------------------------------------------------------+
//|                                                          RSI.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_color1 Crimson
#property indicator_color2 LimeGreen
//---- input parameters
extern int RSIPeriod=9;
extern int MA1=10;
extern int MA2=20;
extern int MAMode=MODE_SMA;
extern int MAPrice=PRICE_CLOSE;
//---- buffers
double RSI1Buf[];
double RSI2Buf[];
double MA1Buf[];
double MA2Buf[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator line
   SetIndexBuffer(0,RSI1Buf); SetIndexStyle(0,DRAW_LINE); 
   SetIndexBuffer(1,RSI2Buf); SetIndexStyle(1,DRAW_LINE); 
   SetIndexBuffer(2,MA1Buf); SetIndexStyle(2,DRAW_NONE); 
   SetIndexBuffer(3,MA2Buf); SetIndexStyle(3,DRAW_NONE); 
//----
   SetIndexDrawBegin(0,RSIPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Relative Strength Index                                          |
//+------------------------------------------------------------------+
int start()
{
	int i;
	for (i=Bars-1; i>=0; i--)	MA1Buf[i]=iMA(NULL, 0, MA1, 0, MAMode, MAPrice, i);
	for (i=Bars-1; i>=0; i--)	RSI1Buf[i] = iRSIOnArray(MA1Buf, Bars-1, RSIPeriod, i);

	for (i=Bars-1; i>=0; i--)	MA2Buf[i]=iMA(NULL, 0, MA2, 0, MAMode, MAPrice, i);
	for (i=Bars-1; i>=0; i--)	RSI2Buf[i] = iRSIOnArray(MA2Buf, Bars-1, RSIPeriod, i);
//----
	return(0);
}
//+------------------------------------------------------------------+