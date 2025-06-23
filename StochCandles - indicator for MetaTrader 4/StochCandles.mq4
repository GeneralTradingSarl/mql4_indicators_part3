//+------------------------------------------------------------------+
//|                                                 StochCandles.mq4 |
//|                      Colored Candles, based on Stochastic Signal |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Christof Risch (iya)"
#property link      "http://www.forexfactory.com/showthread.php?t=13321"
//----
#property indicator_chart_window
#property indicator_buffers 8
//----
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Lime
#property indicator_color4 Tomato
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Lime
#property indicator_color8 Tomato
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 3
#property indicator_width6 3
#property indicator_width7 3
#property indicator_width8 3
//---- stoch settings
extern int      Stoch_K=30,
Stoch_D        =10,
Stoch_Slowing  =10,
Overbought     =80,
Oversold=20;
//---- input parameters
extern int      BarWidth=1,
CandleWidth=3;
extern bool      HeikenAshi=true,
HeikenAshiMA=false;
extern int      HAMA_Method=1,
HAMA_Period=3;
//---- buffers
double Bar1[],
Bar2[],
Bar3[],
Bar4[],
Candle1[],
Candle2[],
Candle3[],
Candle4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorShortName("Colored Candles: Stoch("+Stoch_K+","+Stoch_D+","+Stoch_Slowing+")");
   IndicatorBuffers(8);
   SetIndexBuffer(0,Bar1);
   SetIndexBuffer(1,Bar2);
   SetIndexBuffer(2,Bar3);
   SetIndexBuffer(3,Bar4);
   SetIndexBuffer(4,Candle1);
   SetIndexBuffer(5,Candle2);
   SetIndexBuffer(6,Candle3);
   SetIndexBuffer(7,Candle4);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,BarWidth);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,BarWidth);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,BarWidth);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,BarWidth);
   SetIndexStyle(4,DRAW_HISTOGRAM,0,CandleWidth);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,CandleWidth);
   SetIndexStyle(6,DRAW_HISTOGRAM,0,CandleWidth);
   SetIndexStyle(7,DRAW_HISTOGRAM,0,CandleWidth);
   return(0);
  }
//+------------------------------------------------------------------+
double Stoch_Main(int i=0)
  {
   return(iStochastic(NULL,0,Stoch_K,Stoch_D,Stoch_Slowing,MODE_SMA,0,MODE_MAIN,i));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Stoch_Signal(int i=0)
  {
   return(iStochastic(NULL,0,Stoch_K,Stoch_D,Stoch_Slowing,MODE_SMA,0,MODE_SIGNAL,i));
  }
//+------------------------------------------------------------------+
void SetCandleColor(int col,int i)
  {
   double   high=High[i],
   low=Low[i],
   open=Open[i],
   close=Close[i],
   bodyHigh=MathMax(open,close),
   bodyLow=MathMin(open,close);
   if(HeikenAshi || HeikenAshiMA)
     {
      double   lastBodyHigh=MathMax(Candle1[i+1],MathMax(Candle2[i+1],MathMax(Candle3[i+1],Candle4[i+1]))),
      lastBodyLow=MathMin(Candle1[i+1],MathMin(Candle2[i+1],MathMin(Candle3[i+1],Candle4[i+1])));
      if(HeikenAshiMA)
        {
         high=iMA(NULL,0,HAMA_Period,0,HAMA_Method,MODE_HIGH,i);
         low=iMA(NULL,0,HAMA_Period,0,HAMA_Method,MODE_LOW,i);
         open=iMA(NULL,0,HAMA_Period,0,HAMA_Method,MODE_OPEN,i);
         close=iMA(NULL,0,HAMA_Period,0,HAMA_Method,MODE_CLOSE,i);
        }
      double   haOpen=0.5*(lastBodyHigh+lastBodyLow),
      haClose=0.25*(open+high+low+close);
      //----
      bodyHigh=MathMax(haOpen,haClose);
      bodyLow  =MathMin(haOpen,haClose);
      high     =MathMax(high,bodyHigh);
      low=MathMin(low,bodyLow);
     }
   Bar1[i]=low;   Candle1[i]=bodyLow;
   Bar2[i]=low;   Candle2[i]=bodyLow;
   Bar3[i]=low;   Candle3[i]=bodyLow;
   Bar4[i]=low;   Candle4[i]=bodyLow;
   switch(col)
     {
      case 1:    Bar1[i]=high;   Candle1[i]=bodyHigh;   break;
      case 2:    Bar2[i]=high;   Candle2[i]=bodyHigh;   break;
      case 3:    Bar3[i]=high;   Candle3[i]=bodyHigh;   break;
      case 4:    Bar4[i]=high;   Candle4[i]=bodyHigh;   break;
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(1,HAMA_Period);

   for(int i=limit; i>=0; i--)
     {
      double   stochMain=Stoch_Main(i),
      stochSignal=Stoch_Signal(i);
      if(stochMain>Overbought) SetCandleColor(3,i);
      else   if(stochMain<Oversold) SetCandleColor(4,i);
      else   if(stochMain>stochSignal) SetCandleColor(1,i);
      else   if(stochMain<stochSignal) SetCandleColor(2,i);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
