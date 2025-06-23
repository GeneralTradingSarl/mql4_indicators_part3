//+------------------------------------------------------------------+
//|                                                         OSMA.mq4 |
//|  10 но€бр€ 2008г.                                    Yuriy Tokman |
//| ICQ#:481-971-287                           yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_separate_window

#property indicator_buffers 3

#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_level1 50
#property indicator_levelcolor       DarkBlue


extern int  period_RSI           = 14;
extern int  applied_price_RSI    = 0;
extern int  period_MA            = 5;
extern int  ma_method            = 3;
extern bool Sound                = true;      

double Buf0[];
double Buf1[];
double Buf2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
       SetIndexBuffer(0,Buf0);
       SetIndexBuffer(1,Buf1);
       SetIndexBuffer(2,Buf2);
       
       SetIndexStyle(0,DRAW_LINE,0,2);
       SetIndexStyle(1,DRAW_LINE,0,2);
       SetIndexStyle(2,DRAW_NONE);
       
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
    {
     Buf2[i]=iRSI(NULL,0,period_RSI,applied_price_RSI,i);
    }
     
   for(i=0; i<limit; i++)
    {
     double r = iMAOnArray(Buf2,0,period_MA,0,ma_method,i) ;
     double r1 = iMAOnArray(Buf2,0,period_MA,0,ma_method,i+1) ;
     if (r<53)  Buf1[i]=r ;
     if (r>47)  Buf0[i]=r ;
     if (Sound == true)
     {
      if(r>=50 && r1<=50) {Alert("Crossing in a bottom\n\" Indicators to order e-mail: yuriytokman@gmail.com \"\nRSI= ", r);}
      if(r<=50 && r1>=50) {Alert("Crossing in top\n\" Indicators to order ISQ#:481-971-287 \"\nRSI= ", r);}
     }
     
    } 
   return(0);
  }
//+------------------------------------------------------------------+