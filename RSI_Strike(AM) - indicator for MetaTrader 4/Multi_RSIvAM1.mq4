//+------------------------------------------------------------------+
//|                                                Multi_RSI(AM).mq4 |
//|                                               Andrey Matvievskiy |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Andrey Matvievskiy"
#property link      ""

#property indicator_separate_window


#property indicator_buffers 8

#property indicator_minimum 0
#property indicator_maximum 100

//---- input parameters
extern int RSI_Period1 = 2;
extern int RSI_Period2 = 4;
extern int RSI_Period3 = 3;
extern int RSI_Period4 = 5;
extern int RSI_Period5 = 6;
extern int RSI_Period6 = 8;
extern int RSI_Period7 = 10;
extern int RSI_Period8 = 12;

extern int Price=0; // Low/High 0, Close/Close 1

double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];
double Buffer5[];
double Buffer6[];
double Buffer7[];
double Buffer8[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE,EMPTY,1,Red);
   SetIndexBuffer(0,Buffer1);

   SetIndexStyle(1,DRAW_LINE,EMPTY,1,Orange);
   SetIndexBuffer(1,Buffer2);

   SetIndexStyle(2,DRAW_LINE,EMPTY,1,Gold);
   SetIndexBuffer(2,Buffer3);

   SetIndexStyle(3,DRAW_LINE,EMPTY,1,Lime);
   SetIndexBuffer(3,Buffer4);

   SetIndexStyle(4,DRAW_LINE,EMPTY,1,Aqua);
   SetIndexBuffer(4,Buffer5);

   SetIndexStyle(5,DRAW_LINE,EMPTY,1,Blue);
   SetIndexBuffer(5,Buffer6);

   SetIndexStyle(6,DRAW_LINE,EMPTY,1,Purple);
   SetIndexBuffer(6,Buffer7);

   SetIndexStyle(7,DRAW_LINE,EMPTY,1,Silver);
   SetIndexBuffer(7,Buffer8);

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
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   for(int i=limit; i>=0; i--)
     {
      //----
      Buffer1[i] = iRSI (NULL,0,RSI_Period1,Price,i);
      Buffer2[i] = iRSI (NULL,0,RSI_Period2,Price,i);
      Buffer3[i] = iRSI (NULL,0,RSI_Period3,Price,i);
      Buffer4[i] = iRSI (NULL,0,RSI_Period4,Price,i);
      Buffer5[i] = iRSI (NULL,0,RSI_Period5,Price,i);
      Buffer6[i] = iRSI (NULL,0,RSI_Period6,Price,i);
      Buffer7[i] = iRSI (NULL,0,RSI_Period7,Price,i);
      Buffer8[i] = iRSI (NULL,0,RSI_Period8,Price,i);
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
