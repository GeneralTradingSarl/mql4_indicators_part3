//+------------------------------------------------------------------+
//|                                            Volatility System.mq4 |
//|                                     Copyright 2008, Walter Choy. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008, Walter Choy."
#property link      ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White
//---- input parameters
extern int       VI_period=14;
extern int       ATR_period=7;
extern double    ARC_constant=3;
//---- buffers
double tblVSAR[];
double tblTR[];
double tblVI[];
double tblATR[];
double tblARC[];
double tblisLong[];
double tblPosition[];
double tblSIC[];

#define EnterNil    0
#define EnterLong   1
#define EnterShort -1
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(8);
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,159);
   SetIndexBuffer(0,tblVSAR);
   SetIndexEmptyValue(0,0.0);
   SetIndexLabel(0, "Volatility Index");
   
   SetIndexBuffer(1, tblTR);
   SetIndexBuffer(2, tblVI);
   SetIndexBuffer(3, tblATR);
   SetIndexBuffer(4, tblARC);
   SetIndexBuffer(5, tblisLong);
   SetIndexBuffer(6, tblPosition);
   SetIndexBuffer(7, tblSIC);
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
   int    counted_bars=IndicatorCounted();
   int    i;
   double TR;
   //static bool isLong;
   //static bool enterShort;
   //static bool enterLong;
   int pos, aPos, bPos;
//----
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   if (limit == Bars) limit -= VI_period;
   
   i = Bars - counted_bars;
   tblTR[i] = High[i] - Low[i];
   i--;
   while(i>=0){
      TR = High[i] - Low[i];
      if (TR < High[i] - Close[i+1]) TR = High[i] - Close[i+1];
      if (TR < Close[i+1] - Low[i]) TR = Close[i+1] - Low[i];
      tblTR[i] = TR;
      i--;
   }
   
   i = limit;
   while(i>=0){
      tblVI[i] = iMAOnArray(tblTR, 0, VI_period, 0, MODE_SMA, i);
      i--;
   }

   i = limit;
   while(i>=0){
      tblATR[i] = iMAOnArray(tblTR, 0, ATR_period, 0, MODE_SMA, i);
      i--;
   }

   i = limit;   
   while(i>=0){
      tblARC[i] = ARC_constant * tblATR[i];
      i--;
   }   
   
   i = limit;
   if (i == Bars - counted_bars - VI_period){
      tblisLong[i] = false;
      i = limit;
      while(i>=0){
         if (Close[i] < Close[i-1] && Close[i-1] > Close[i-2]){
            aPos = i - 1;
            break;
         }
         i--;
      }

      i = limit;
      while(i>=0){
         if (Close[i] > Close[i-1] && Close[i-1] < Close[i-2]){
            bPos = i - 1;
            break;
         }
         i--;
      }

      //enterLong = false; enterShort = false;
      tblPosition[i] = EnterNil;
      
      if (aPos < bPos){
         pos = aPos; //isLong = false; enterShort = true;
      } else {
         pos = bPos; //isLong = true; enterLong = true;
      }

      if (pos > Bars - ATR_period) pos = Bars - ATR_period;  
   } else {
      pos = limit;
   }
   
   i = pos;
  
   //static double SIC;
   while (i>=0){
      if (tblisLong[i+1] == true){
         tblSIC[i] = tblSIC[i+1];
         if (tblPosition[i+1] == EnterLong){
            tblSIC[i] = Close[i+1]; tblPosition[i] = EnterNil;
         }
         if (Close[i+1] > tblSIC[i]) tblSIC[i] = Close[i+1];
         tblVSAR[i] = tblSIC[i] - tblARC[i+1];
         tblisLong[i] = tblisLong[i+1];
         if (tblVSAR[i] > Close[i]){
            tblisLong[i] = false; tblPosition[i] = EnterShort;
         }
      } else {
         tblSIC[i] = tblSIC[i+1];
         if (tblPosition[i+1] == EnterShort){
            tblSIC[i] = Close[i+1]; tblPosition[i] = EnterNil;
         }
         if (Close[i+1] < tblSIC[i]) tblSIC[i] = Close[i+1];
         tblVSAR[i] = tblSIC[i] + tblARC[i+1];
         tblisLong[i] = tblisLong[i+1];
         if (tblVSAR[i] < Close[i]){
            tblisLong[i] = true; tblPosition[i] = EnterLong;
         }
      }
      i--;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+