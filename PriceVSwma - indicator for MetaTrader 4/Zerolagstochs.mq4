//+------------------------------------------------------------------+
//|                                                   PriceVSwma.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "perky_z@yahoo.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_color2 Red
//---- input parameters
double stok1=0,stok2=0,stok3=0,stok4=0,stok5=0,mov=0,stoksmoothed=0,smoothing=15;
int shift=0,MAType=1,cnt=0,prevbars=0,loopbegin=0;
bool first=true;
//---- buffers
double TrendBuffer[];
double LoBuffer[];
double HiBuffer[];
double PlusSdiBuffer[];
double MinusSdiBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 3 additional buffers are used for counting.
   IndicatorBuffers(3);
//---- indicator buffers
   SetIndexBuffer(0,TrendBuffer);
   SetIndexBuffer(1,LoBuffer);
//
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,White);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2,Red);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Zero Lag Stocs");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Directional Movement Index                               |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(shift=limit; shift>=0;shift--)
     {
      stok1=(iStochastic(NULL,0,8,3,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.05;
      stok2=(iStochastic(NULL,0,89,21,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.43;
      stok3=(iStochastic(NULL,0,55,13,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.26;
      stok4=(iStochastic(NULL,0,34,8,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.16;
      stok5=(iStochastic(NULL,0,21,5,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.10;
      mov  =stok1+stok2+stok3+stok4+stok5;
      stoksmoothed=mov/smoothing+LoBuffer[shift+1]*(smoothing-1)/smoothing;
      //
      TrendBuffer[shift]=mov;
      LoBuffer[shift]=stoksmoothed;
     }
   return(0);
  }
// prevent to previous bars recounting
//+------------------------------------------------------------------+
,NULL,MODE_MAIN,shift))*0.43;
      stok3=(iStochastic(NULL,0,55,13,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.26;
      stok4=(iStochastic(NULL,0,34,8,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.16;
      stok5=(iStochastic(NULL,0,21,5,3,MODE_SMA,NULL,MODE_MAIN,shift))*0.10;
      mov  =stok1+stok2+stok3+stok4+stok5;
      stoksmoothed=mov/smoothing+LoBuffer[shift+1]*(smoothing-1)/smoothing;
      //
      TrendBuffer[shift]=mov;
      LoBuffer[shift]=stoksmoothed;
      //
      loopbegin=loopbegin-1;
     }
   return(0);
  }

// prevent to previous bars recounting
//+------------------------------------------------------------------+
