//+------------------------------------------------------------------+
//|                                        Reverse MACD Zero Lag.mq4 |
//|                                             Guillaume Derouineau |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Guillaume Derouineau"
#property link      "https://www.mql5.com"
#property version   "2.20"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Yellow


extern int FastEMA = 12; // Fast EMA Period
extern int SlowEMA = 26; // Slow EMA Period
extern int SignalEMA=9; // Signal EMA Period
extern bool DrawPoints=false; // if(true) draw point around the line
extern int DrawPointsPath=10; // number of Pips between each point
extern int DrawPointsNb=10; // number of point on each side of the line



double 
MACDZeroLagValue[], 
PriceCustom[], 
MACDZeroLagProjected[],
ReverseMACDUpLine[],
ReverseMACDDownLine[],
ReverseMACDZeroLine[],
EMAFast[],
EMAEMAFast[],
DEMAFast[],
EMASlow[],
EMAEMASlow[],
DEMASlow[],
EMASignal[],
EMAEMASignal[],
MACD[],
emaSignal1[],
Signal[],
Histogramme[]
;



//+------------------------------------------------------------------+
//| Init function                     |
//+------------------------------------------------------------------+
void OnInit(void)
  {
//---- indicators

   IndicatorBuffers(16);
   // main Buffers
   SetIndexBuffer(0,ReverseMACDUpLine);
   SetIndexBuffer(1,ReverseMACDDownLine);
   SetIndexBuffer(2,ReverseMACDZeroLine);
   
   // buffers for calculation
   SetIndexBuffer(3,MACDZeroLagProjected);
   SetIndexBuffer(4,MACD);
   SetIndexBuffer(5,Signal);
   SetIndexBuffer(6,Histogramme);
   SetIndexBuffer(7,PriceCustom);
   SetIndexBuffer(8,EMAFast);
   SetIndexBuffer(9,EMASlow);
   SetIndexBuffer(10,EMAEMAFast);
   SetIndexBuffer(11,EMAEMASlow);
   SetIndexBuffer(12,DEMAFast);
   SetIndexBuffer(13,DEMASlow);
   SetIndexBuffer(14,EMASignal);
   SetIndexBuffer(15,EMAEMASignal);

   IndicatorShortName("Reverse MACD");
   SetIndexLabel(0,"Reverse MACD - Up");
   SetIndexLabel(1,"Reverse MACD - Down");
   SetIndexLabel(2,"Reverse MACD - Return");
   SetIndexStyle(0,DRAW_LINE,EMPTY);
   SetIndexStyle(1,DRAW_LINE,EMPTY);
   SetIndexStyle(2,DRAW_LINE,EMPTY);

  }
//+------------------------------------------------------------------+
//|   deinit function                                                               |
//+------------------------------------------------------------------+
int deinit()
  {
//----
// delete all dots
   string
   name,
   IndicatorId="Reverse MACD"
               ;
   int
   ObjectNb=ObjectsTotal()
            ;
   for(int i=ObjectNb-1; i>=0; i--)
     {
      name=ObjectName(i);
      if(StringFind(name,IndicatorId,0)>=0)
        {
         ObjectDelete(ChartID(),ObjectName(i));

        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|   main function                                                              |
//+------------------------------------------------------------------+
int start()
  {


   double prFast = 2.0 / (FastEMA + 1.0);
   double prSlow = 2.0 / (SlowEMA + 1.0);
   double prSignal=2.0/(SignalEMA+1.0);
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

// Prices for calculation of the ema
   for(int i=0; i<limit; i++)
     {
      PriceCustom[i]=iClose(NULL,0,i);
     }

// calculation MACD Zero LAG
   for(int i=0; i<limit; i++)
     {
      EMAFast[i] = iMAOnArray(PriceCustom, 0, FastEMA, 0, MODE_EMA,i);
      EMASlow[i] = iMAOnArray(PriceCustom, 0, SlowEMA, 0, MODE_EMA, i);
     }
   
   for(int i=0; i<limit-1; i++)
     {
      EMAEMAFast[i]=iMAOnArray(EMAFast,0,FastEMA,0,MODE_EMA,i);
      DEMAFast[i]=2*EMAFast[i]-EMAEMAFast[i];

      EMAEMASlow[i]=iMAOnArray(EMASlow,0,SlowEMA,0,MODE_EMA,i);
      DEMASlow[i]=2*EMASlow[i]-EMAEMASlow[i];
      MACD[i]=DEMAFast[i]-DEMASlow[i];
     }

   for(int i=0; i<limit-1; i++)
     {
      EMASignal[i]=iMAOnArray(MACD,0,SignalEMA,0,MODE_EMA,i);
     }

   for(int i=0; i<limit-1; i++)
     {
      EMAEMASignal[i]=iMAOnArray(EMASignal,0,SignalEMA,0,MODE_EMA,i);
     }
   for(int i=0; i<limit-1; i++)
     {
      Signal[i]=2*EMASignal[i]-EMAEMASignal[i];
     }

   for(int i=0; i<limit-1; i++)
     {
      Histogramme[i]=MACD[i]-Signal[i];
     }
// end Calculation MACD Zero Lag

   // Calculation Of the projected return point
   bool upLine=true,downLine=true;
   for(int i=limit-2; i>=0; i--)
     {
      MACDZeroLagProjected[i]=(-(
                               +EMAFast[i+1]*(
                               (2-prFast) *(1-prFast)
                               *
                               (1-prSignal) *(1-prSignal)
                               )
                               -EMASlow[i+1]*(
                               (2-prSlow) *(1-prSlow)
                               *
                               (1-prSignal) *(1-prSignal)
                               )
                               -EMAEMAFast[i+1]*(
                               (1-prFast)
                               *
                               (1-prSignal) *(1-prSignal)
                               )
                               +EMAEMASlow[i+1]*(
                               (1-prSlow)
                               *
                               (1-prSignal) *(1-prSignal)
                               )
                               -EMASignal[i+1]*(
                               (1-prSignal) *(2-prSignal)
                               )

                               +EMAEMASignal[i+1]*(1-prSignal)

                               ))/

                               (
                               (prFast *(2-prFast)-prSlow *(2-prSlow))
                               *
                               (1-prSignal) *(1-prSignal)
                               )
      ;
      
      // drawing the macd zero lag reverse line
      if(MACDZeroLagProjected[i]>MACDZeroLagProjected[i+1])
        {
         ReverseMACDUpLine[i]=MACDZeroLagProjected[i];
         upLine=true;
         if(downLine==true)
           {
            downLine=false;
            ReverseMACDZeroLine[i]=MACDZeroLagProjected[i];
            ReverseMACDZeroLine[i+1]=MACDZeroLagProjected[i+1];
           }

        }
      else
        {
         ReverseMACDDownLine[i]=MACDZeroLagProjected[i];
         downLine = true;
         if(upLine==true)
           {
            upLine=false;
            ReverseMACDZeroLine[i]=MACDZeroLagProjected[i];
            ReverseMACDZeroLine[i+1]=MACDZeroLagProjected[i+1];
           }
        }
      // adding the point if wanted
      if(DrawPoints==true)
        {

         for(int n=0; n<DrawPointsNb; n++)
           {

            createPoint(MACDZeroLagProjected[i]+n*DrawPointsPath+Point,clrGreen,i);
            createPoint(MACDZeroLagProjected[i]-n*DrawPointsPath+Point,clrRed,i);
           }
        }

     }
   return 0;

  }
//+------------------------------------------------------------------+
//|  function to create a dot                                                                |
//+------------------------------------------------------------------+
void createPoint(double value,color clr,int shift)
  {
   string name="Reverse MACD - "+ IntegerToString(clr)+" - "+DoubleToString(value)+" ";
   datetime time=iTime(NULL,0,shift);
   ObjectCreate(ChartID(),name,OBJ_TREND,0,time,value,time,value);
   ObjectSet(name,OBJPROP_WIDTH,3);
   ObjectSet(name,OBJPROP_COLOR,clr);
   ObjectSet(name,OBJPROP_BACK,true);

  }
//+------------------------------------------------------------------+
//|   recursive function to calculate ema                                                             |
//+------------------------------------------------------------------+

double FutureEMA(int period,double Value,double EMAPrevious)
  {

   double pr=2.0/(period+1.0);
   double EMAActual=Value*pr+EMAPrevious *(1.0-pr);
   return(EMAActual);
  }
//+------------------------------------------------------------------+
