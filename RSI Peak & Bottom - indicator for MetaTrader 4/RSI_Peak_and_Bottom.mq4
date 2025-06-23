//+------------------------------------------------------------------+
//|                                            RSI Peak & Bottom.mq4 |
//|                                   Copyright © 2009, Ahmad Yahya. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Ahmad Yahya."
#property link      "fx.power@yahoo.com"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_color1 Aqua
#property indicator_color2 Yellow
#property indicator_color3 Red

//---- input parameters
extern int       PeriodRSI=14;

//---- buffers
double RSILine1[];
double SupLevel2[];
double ResLevel3[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,RSILine1);
   
   SetIndexStyle(1,DRAW_ARROW);
   //SetIndexArrow(1,159);
   SetIndexBuffer(1,SupLevel2);
   SetIndexEmptyValue(1,0.0);
   SetIndexDrawBegin(1,1);
   SetIndexLabel(1,"SupLevel");
   
   SetIndexStyle(2,DRAW_ARROW);
   //SetIndexArrow(2,159);
   SetIndexBuffer(2,ResLevel3);
   SetIndexEmptyValue(2,0.0);
   SetIndexDrawBegin(2,1);
   SetIndexLabel(2,"ResLevel");
   
   
   string short_name="RSI Peak/Bottom Levels ("+PeriodRSI+") ";
   IndicatorShortName(short_name);



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
   int limit;
   int    counted_bars=IndicatorCounted();
   double rsi1,rsi2,rsi3,rsi4;
   
   
//Draw RSI & Plot the Peak/Bottom RSI
if (counted_bars<0) return(-1); 
    
   if (counted_bars>0) counted_bars--; 
    
   limit=Bars-counted_bars; 
   
   for (int i=0; i<limit; i++) 
      { 
         RSILine1[i]=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i);
   
         rsi1=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+1);
         rsi2=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+2);
         rsi3=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+3);
         rsi4=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+4);
   
         if  ((rsi1<rsi2 && rsi2>rsi3) || (rsi1<rsi2 && rsi2==rsi3 && rsi3>rsi4))
            {                    
               ResLevel3[i+2]=rsi2; //Menandai Level Resistance
            }
         if  ((rsi1>rsi2 && rsi2<rsi3) || (rsi1>rsi2 && rsi2==rsi3 && rsi3<rsi4)) 
            {  
               SupLevel2[i+2]=rsi2; //Menandai Level Support
            }
      }


//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+