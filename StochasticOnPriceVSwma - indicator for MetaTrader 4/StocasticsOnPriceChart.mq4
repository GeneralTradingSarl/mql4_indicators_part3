//+------------------------------------------------------------------+
//|                                  StochasticONpricePriceVSwma.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "perky_z@yahoo.com"
//----
#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Violet
#property indicator_color2 Aqua
//---- input parameters
extern int K_Period=5;
extern int D_Period=3;
extern int Slowing=3;
//----
int shift=0,cnt=0,prevbars=0,loopbegin=0;
double MAValue,Stoch;
bool first=true;
//---- buffers
double TrendBuffer[];
double LoBuffer[];
double HiBuffer[];
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
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,Yellow);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2,Aqua);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Stochinchart("+")");
//
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
   if(counted_bars==0) limit--;

   for(shift=limit; shift>=0;shift--)
     {
      int bars_count=BarsPerWindow();
      double hl1,hl2,hl;
      int ind1=Highest(NULL,0,MODE_HIGH,bars_count,1);
      int ind2=Lowest(NULL,0,MODE_LOW,bars_count,1);

      if(ind1==-1 || ind2==-1)
        {
         TrendBuffer[shift]=EMPTY_VALUE;
         LoBuffer[shift]=EMPTY_VALUE;
         continue;
        }
      hl1=High[ind1];
      hl2=Low[ind2];
      hl=(hl1+hl2)/2;
      //Comment (bars_count,"hl",hl,"hl1 ",hl1,"hl2 ",hl2);
      TrendBuffer[shift]=((((iStochastic(NULL,0,K_Period,D_Period,Slowing,MODE_SMA,0,MODE_SIGNAL,shift))-50))/10000+hl);
      LoBuffer[shift]=((((iStochastic(NULL,0,K_Period,D_Period,Slowing,MODE_SMA,0,MODE_MAIN,shift))-50))/10000+hl);

     }
   return(0);
  }
//+------------------------------------------------------------------+
