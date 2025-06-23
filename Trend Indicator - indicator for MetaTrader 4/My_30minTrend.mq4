//+------------------------------------------------------------------+
//|                                                 My_HourTrend.mq4 |
//|                             Copyright © 2009, InvestMoneyLab.com |
//|                                    http://www.investmoneylab.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Checking the overall market trend based on the hourly chart      |
//| Return 2 if it is STRONG UP Trend                                |
//| Return 1 if it is WEAK UP Trend                                  |
//| Return 0 if it is NO Trend                                       |
//| Return -1 if it is WEAK DOWN Trend                               |
//| Return -2 if it is STRONG DOWN Trend                             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, InvestMoneyLab.com"
#property link      "http://www.investmoneylab.com"

#property indicator_separate_window
#property indicator_minimum -3
#property indicator_maximum 3
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int       ROCMA_Period=200;
extern int       ROC_Period=200;
extern int       Hist_ShortPeriod=80;
extern int       Hist_LongPeriod=200;
//---- buffers
double Buf_0[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Buf_0);   
   SetIndexDrawBegin(0,Hist_LongPeriod);

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
   int    i, counted_bars=IndicatorCounted();
   double ROC_MA, ROC_MA_Lag;   
   double MADiff_Current, MADiff_Previous;
   int HourIndex, ROCTrend, MADiff_Trend, Overall_Trend;
   static int MADiff_Trend_Previous;
   
//----
   if(Bars<=Hist_LongPeriod) return(0);
   
   i=Bars-counted_bars-1;
   
   Print("Bar is ", Bars);
   Print("Counted Bars is ", counted_bars);
   
   while(i>=0) 
   {
      // Obtain the corresponding bar index on the hourly chart
      HourIndex = iBarShift(NULL,PERIOD_M30,iTime(NULL,0,i));   
      
      if (HourIndex != -1)
      {  
         // Compute ROC Trend
         ROC_MA = iMA(NULL,PERIOD_M30,ROCMA_Period,0,1,PRICE_OPEN,HourIndex);
         ROC_MA_Lag = iMA(NULL,PERIOD_M30,ROCMA_Period,0,1,PRICE_OPEN,HourIndex+ROC_Period);
   
         if (ROC_MA > ROC_MA_Lag) ROCTrend = 1;
         else if (ROC_MA < ROC_MA_Lag) ROCTrend = -1;
         else ROCTrend = 0;
         
         // Compute MADiff Trend
         MADiff_Current = (iMA(NULL,PERIOD_M30,Hist_ShortPeriod,0,1,PRICE_OPEN,HourIndex) - iMA(NULL,PERIOD_M30,Hist_LongPeriod,0,1,PRICE_OPEN,HourIndex));             
         MADiff_Previous = (iMA(NULL,PERIOD_M30,Hist_ShortPeriod,0,1,PRICE_OPEN,HourIndex+1) - iMA(NULL,PERIOD_M30,Hist_LongPeriod,0,1,PRICE_OPEN,HourIndex+1));
      
         if (MADiff_Current > MADiff_Previous && MathAbs(MADiff_Current - MADiff_Previous) < 0.0002 && MADiff_Trend_Previous == -1)
         {
            MADiff_Trend = -1;       
         }     
         else if (MADiff_Current > MADiff_Previous)
         {
            MADiff_Trend = 1;
            MADiff_Trend_Previous = 1;
         }
         else if (MADiff_Current < MADiff_Previous && MathAbs(MADiff_Current - MADiff_Previous) < 0.0002 && MADiff_Trend_Previous == 1)
         {
            MADiff_Trend = 1;              
         }
         else if (MADiff_Current < MADiff_Previous)
         {
            MADiff_Trend = -1;
            MADiff_Trend_Previous = -1;
         }         
         
         if (ROCTrend == 1 && MADiff_Trend == 1) Overall_Trend = 2;    // Strong Up Trend
         else if (ROCTrend == -1 && MADiff_Trend == 1) Overall_Trend = 1;  // Weak Up Trend
         else if (ROCTrend == -1 && MADiff_Trend == -1) Overall_Trend = -2; // Strong Down Trend
         else if (ROCTrend == 1 && MADiff_Trend == -1) Overall_Trend = -1; // Weak Down Trend
         else Overall_Trend = 0;

         Buf_0[i] = Overall_Trend;
      }
            
      i--;
   } 
  
//----
   return(0);
  }
//+------------------------------------------------------------------+