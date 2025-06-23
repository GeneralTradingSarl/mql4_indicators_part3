//+------------------------------------------------------------------+
//|                                         True Range Envelopes.mq4 |
//|                                                 Copyright © 2011 |
//|                                             basisforex@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Aqua
#property indicator_color2 Aqua
#property indicator_color3 Aqua
//---- indicator parameters --------
extern int      MA_Period      = 14;
extern int      MA_Shift       = 0;
extern int      MA_Method      = 0;
extern int      Applied_Price  = 0;
//-----
extern int      Period_Ma      = 5;
extern int      Mode_Ma        = 3;
//---- indicator buffers ----------
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double BufferMidle[];
double Buffer1[];
double Buffer2[];
//----
int ExtCountedBars = 0;
double dDeviation;
//+------------------------------------------------------------------+
int init()
  {
   int    draw_begin;
   string short_name;
//---- drawing settings
   IndicatorBuffers(5);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE, STYLE_DOT);
   SetIndexShift(0, MA_Shift);
   SetIndexShift(1, MA_Shift);
   SetIndexShift(2, MA_Shift);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   if(MA_Period<2) MA_Period=14;
   draw_begin=MA_Period-1;
//---- indicator short name
   IndicatorShortName("Env("+MA_Period+")");
   SetIndexLabel(0,"Env("+MA_Period+")Upper");
   SetIndexLabel(1,"Env("+MA_Period+")Lower");
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
//---- indicator buffers mapping
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexBuffer(2, BufferMidle);
   SetIndexBuffer(3, Buffer1);
   SetIndexBuffer(4, Buffer2);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   int i, limit;
   if(Bars<=MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   limit=Bars-ExtCountedBars;
//---- EnvelopesM counted in the buffers
   for(i = 0; i < limit; i++)
    { 
      dDeviation = iATR(NULL, 0, MA_Period, i) * 2;
      //-----
      Buffer1[i] = (1 + dDeviation) * iMA(NULL, 0, MA_Period, 0, MA_Method, Applied_Price, i);
      Buffer2[i] = (1 - dDeviation) * iMA(NULL, 0, MA_Period, 0, MA_Method, Applied_Price, i);
    }
   for(i = 0; i < limit; i++)
    {
      ExtMapBuffer1[i] = iMAOnArray(Buffer1, Bars, Period_Ma, 0, Mode_Ma, i);
      ExtMapBuffer2[i] = iMAOnArray(Buffer2, Bars, Period_Ma, 0, Mode_Ma, i);
      BufferMidle[i] = (ExtMapBuffer1[i] + ExtMapBuffer2[i]) / 2;
    }  
//---- done
   return(0);
  }
//+------------------------------------------------------------------+