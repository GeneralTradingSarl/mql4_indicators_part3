//+------------------------------------------------------------------+
//|                                                ThreeCombo_v2.mq4 |
//|                                                        Oje Uadia |
//|                                         moneyinthesack@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Oje Uadia"
#property link      "moneyinthesack@yahoo.com"

#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Yellow
//---- input parameters
extern int       short_ma=5;
extern int       long_ma=10;
extern int       rsi_period=21;
extern int       adx_period=14;
//---- buffers
double buy[];
double sell[];
double chill[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,buy);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(1,sell);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(2,chill);
   SetIndexEmptyValue(2,0.0);
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
   if (Bars<0)
   return (-1);
   if (counted_bars>0)
   counted_bars--;
   int limit = Bars-counted_bars;
   int i;
   for (i=0;i<limit;i++)
   {
   int ma_status;
   int rsi_status;
   int adx_status;
   int trade;
   double height = iADX(Symbol(),0,adx_period,0,MODE_MAIN,i);
  
   double fast_ma = iMA(Symbol(),0,short_ma,0,1,0,i);
   double slow_ma = iMA(Symbol(),0,long_ma,0,1,0,i);
   double rsi     = iRSI(Symbol(),0,rsi_period,0,i);
   double plusd   = iADX(Symbol(),0,adx_period,0,MODE_PLUSDI,i);
   double minusd  = iADX(Symbol(),0,adx_period,0,MODE_MINUSDI,i);
   
  if(fast_ma>slow_ma)
  
  ma_status=1;
  else
  ma_status=2;
  
  if (rsi>50)
  
  rsi_status=1;
  else
  rsi_status=2;
  
  if (plusd>minusd)
  
  adx_status=1;
  else
  adx_status=2;
  
  if (ma_status==1 && rsi_status==1 && adx_status==1)
 
  buy[i]=height;
  else
  buy[i]=0.0;
  
  if (ma_status==2 && rsi_status==2 && adx_status==2)

  sell[i]=height;
  else
  sell[i]=0.0;
  
  if (ma_status==1 && rsi_status==1 && adx_status==1)
  trade=1;
  else
  if (ma_status==2 && rsi_status==2 && adx_status==2)
  trade=2;
  else trade = 3;
  
  if (trade==3)
  chill[i]=height;
    
  
  
   
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+