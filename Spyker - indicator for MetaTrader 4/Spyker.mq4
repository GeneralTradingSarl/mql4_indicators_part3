//+------------------------------------------------------------------+
//|                                                       Spyker.mq4 |
//|                                 Copyright © 2006, Jimmy Boucher. |
//|                                    EMail: j_boucher@telkomsa.net |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2006, Jimmy Boucher."
#property  link      "EMail: j_boucher@telkomsa.net"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Gold
#property  indicator_width1  1
//---- indicator parameters
extern int JimmyEMA=1;
extern int SignalSMA=375;
//---- indicator buffers
double     MacdBuffer[];
double     SignalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,SignalSMA);
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Spyker ("+JimmyEMA+","+SignalSMA+")");
   SetIndexLabel(0,"Spyker");
   SetIndexLabel(1,"Signal");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,JimmyEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,JimmyEMA,0,MODE_EMA,PRICE_OPEN,i);
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- done
   return(0);
  }
//+------------------------------------------------------------------+