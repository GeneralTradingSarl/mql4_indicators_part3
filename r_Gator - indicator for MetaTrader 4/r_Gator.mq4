//+------------------------------------------------------------------+
//|                                                      r_Gator.mq4 |
//|                                      Copyright © 01/2008, Rosych |
//+------------------------------------------------------------------+
#property copyright "Copyright © 01/2008, Rosych"
#property link      "rosych@mail.ru"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Blue
//----
extern int period=5;
extern int period_1=8;
extern int period_2=13;
extern int bars=300;

//+------------------------------------------------------------------+
//| Local variables                                                  |
//+------------------------------------------------------------------+
int shift=0;
//---- buffers
double ExtMapBuffer1[], ExtMapBuffer2[], ExtMapBuffer3[];
      
double ma1,ma2,ma3,ma4,ma5,ma6,ma7,ma8,ma9,ma10,ma11,ma12,ma13,ma14,
ma15,ma16,ma17,ma18,ma19,ma20,ma21,ma22,ma23,ma24,ma25,ma26,ma27,ma28;

double ma1_1,ma2_1,ma3_1,ma4_1,ma5_1,ma6_1,ma7_1,ma8_1,ma9_1,ma10_1,
ma11_1,ma12_1,ma13_1,ma14_1,ma15_1,ma16_1,ma17_1,ma18_1,ma19_1,
ma20_1,ma21_1,ma22_1,ma23_1,ma24_1,ma25_1,ma26_1,ma27_1,ma28_1;

double ma1_2,ma2_2,ma3_2,ma4_2,ma5_2,ma6_2,ma7_2,ma8_2,ma9_2,ma10_2,
ma11_2,ma12_2,ma13_2,ma14_2,ma15_2,ma16_2,ma17_2,ma18_2,ma19_2,
ma20_2,ma21_2,ma22_2,ma23_2,ma24_2,ma25_2,ma26_2,ma27_2,ma28_2;

double MA, MA_1, MA_2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int    limit;
    if(counted_bars>0)
       counted_bars--;
   
   limit=Bars-counted_bars;
  
   for(int shift=0;shift<limit;shift++)
     {
      ma1=iMA(NULL,0,period,0,MODE_EMA,PRICE_CLOSE,shift);
      ma2=iMA(NULL,0,period,0,MODE_EMA,PRICE_OPEN,shift);
      ma3=iMA(NULL,0,period,0,MODE_EMA,PRICE_HIGH,shift);
      ma4=iMA(NULL,0,period,0,MODE_EMA,PRICE_LOW,shift);
      ma5=iMA(NULL,0,period,0,MODE_EMA,PRICE_MEDIAN,shift);
      ma6=iMA(NULL,0,period,0,MODE_EMA,PRICE_TYPICAL,shift);
      ma7=iMA(NULL,0,period,0,MODE_EMA,PRICE_WEIGHTED,shift);
      
      ma8=iMA(NULL,0,period,0,MODE_SMA,PRICE_CLOSE,shift);
      ma9=iMA(NULL,0,period,0,MODE_SMA,PRICE_OPEN,shift);
      ma10=iMA(NULL,0,period,0,MODE_SMA,PRICE_HIGH,shift);
      ma11=iMA(NULL,0,period,0,MODE_SMA,PRICE_LOW,shift);
      ma12=iMA(NULL,0,period,0,MODE_SMA,PRICE_MEDIAN,shift);
      ma13=iMA(NULL,0,period,0,MODE_SMA,PRICE_TYPICAL,shift);
      ma14=iMA(NULL,0,period,0,MODE_SMA,PRICE_WEIGHTED,shift);
      
      ma15=iMA(NULL,0,period,0,MODE_SMMA,PRICE_CLOSE,shift);
      ma16=iMA(NULL,0,period,0,MODE_SMMA,PRICE_OPEN,shift);
      ma17=iMA(NULL,0,period,0,MODE_SMMA,PRICE_HIGH,shift);
      ma18=iMA(NULL,0,period,0,MODE_SMMA,PRICE_LOW,shift);
      ma19=iMA(NULL,0,period,0,MODE_SMMA,PRICE_MEDIAN,shift);
      ma20=iMA(NULL,0,period,0,MODE_SMMA,PRICE_TYPICAL,shift);
      ma21=iMA(NULL,0,period,0,MODE_SMMA,PRICE_WEIGHTED,shift);
      
      ma22=iMA(NULL,0,period,0,MODE_LWMA,PRICE_CLOSE,shift);
      ma23=iMA(NULL,0,period,0,MODE_LWMA,PRICE_OPEN,shift);
      ma24=iMA(NULL,0,period,0,MODE_LWMA,PRICE_HIGH,shift);
      ma25=iMA(NULL,0,period,0,MODE_LWMA,PRICE_LOW,shift);
      ma26=iMA(NULL,0,period,0,MODE_LWMA,PRICE_MEDIAN,shift);
      ma27=iMA(NULL,0,period,0,MODE_LWMA,PRICE_TYPICAL,shift);
      ma28=iMA(NULL,0,period,0,MODE_LWMA,PRICE_WEIGHTED,shift);
      
      MA=(ma1+ma2+ma3+ma4+ma5+ma6+ma7+ma8+ma9+ma10+ma11+ma12+ma13+ma14+ma15+ma16
          +ma17+ma18+ma19+ma20+ma21+ma22+ma23+ma24+ma25+ma26+ma27+ma28)/28;
      
      ma1_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_CLOSE,shift);
      ma2_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_OPEN,shift);
      ma3_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_HIGH,shift);
      ma4_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_LOW,shift);
      ma5_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_MEDIAN,shift);
      ma6_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_TYPICAL,shift);
      ma7_1=iMA(NULL,0,period_1,0,MODE_EMA,PRICE_WEIGHTED,shift);
      
      ma8_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_CLOSE,shift);
      ma9_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_OPEN,shift);
      ma10_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_HIGH,shift);
      ma11_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_LOW,shift);
      ma12_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_MEDIAN,shift);
      ma13_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_TYPICAL,shift);
      ma14_1=iMA(NULL,0,period_1,0,MODE_SMA,PRICE_WEIGHTED,shift);
      
      ma15_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_CLOSE,shift);
      ma16_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_OPEN,shift);
      ma17_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_HIGH,shift);
      ma18_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_LOW,shift);
      ma19_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_MEDIAN,shift);
      ma20_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_TYPICAL,shift);
      ma21_1=iMA(NULL,0,period_1,0,MODE_SMMA,PRICE_WEIGHTED,shift);
      
      ma22_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_CLOSE,shift);
      ma23_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_OPEN,shift);
      ma24_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_HIGH,shift);
      ma25_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_LOW,shift);
      ma26_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_MEDIAN,shift);
      ma27_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_TYPICAL,shift);
      ma28_1=iMA(NULL,0,period_1,0,MODE_LWMA,PRICE_WEIGHTED,shift);
      
      MA_1=(ma1_1+ma2_1+ma3_1+ma4_1+ma5_1+ma6_1+ma7_1+ma8_1+ma9_1+ma10_1+ma11_1
           +ma12_1+ma13_1+ma14_1+ma15_1+ma16_1+ma17_1+ma18_1+ma19_1+ma20_1
           +ma21_1+ma22_1+ma23_1+ma24_1+ma25_1+ma26_1+ma27_1+ma28_1)/28;

      ma1_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_CLOSE,shift);
      ma2_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_OPEN,shift);
      ma3_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_HIGH,shift);
      ma4_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_LOW,shift);
      ma5_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_MEDIAN,shift);
      ma6_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_TYPICAL,shift);
      ma7_2=iMA(NULL,0,period_2,0,MODE_EMA,PRICE_WEIGHTED,shift);
      
      ma8_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_CLOSE,shift);
      ma9_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_OPEN,shift);
      ma10_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_HIGH,shift);
      ma11_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_LOW,shift);
      ma12_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_MEDIAN,shift);
      ma13_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_TYPICAL,shift);
      ma14_2=iMA(NULL,0,period_2,0,MODE_SMA,PRICE_WEIGHTED,shift);
      
      ma15_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_CLOSE,shift);
      ma16_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_OPEN,shift);
      ma17_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_HIGH,shift);
      ma18_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_LOW,shift);
      ma19_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_MEDIAN,shift);
      ma20_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_TYPICAL,shift);
      ma21_2=iMA(NULL,0,period_2,0,MODE_SMMA,PRICE_WEIGHTED,shift);
      
      ma22_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_CLOSE,shift);
      ma23_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_OPEN,shift);
      ma24_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_HIGH,shift);
      ma25_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_LOW,shift);
      ma26_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_MEDIAN,shift);
      ma27_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_TYPICAL,shift);
      ma28_2=iMA(NULL,0,period_2,0,MODE_LWMA,PRICE_WEIGHTED,shift);
      
      MA_2=(ma1_2+ma2_2+ma3_2+ma4_2+ma5_2+ma6_2+ma7_2+ma8_2+ma9_2+ma10_2+ma11_2
           +ma12_2+ma13_2+ma14_2+ma15_2+ma16_2+ma17_2+ma18_2+ma19_2+ma20_2
           +ma21_2+ma22_2+ma23_2+ma24_2+ma25_2+ma26_2+ma27_2+ma28_2)/28;
//----
      ExtMapBuffer1[shift]=MA;
      ExtMapBuffer2[shift]=MA_1;
      ExtMapBuffer3[shift]=MA_2;
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+