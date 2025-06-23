//+------------------------------------------------------------------+
//|                                            RSI_Strike(AM)_SW.mq4 |
//|                                               Andrey Matvievskiy |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Andrey Matvievskiy"
#property link      ""

#property indicator_separate_window

#property indicator_buffers 5

#property indicator_color1 Black
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Green
#property indicator_color5 Red

//---- input parameters
extern int Period_MA1 = 34;
extern int Period_MA2 = 5;
extern int Price_MA1 = 4;
extern int Price_MA2 = 4;
extern int Method_MA1 = 0;
extern int Method_MA2 = 0;

extern int RSI_Period1=2;
extern int RSI_Period2=4;
extern int RSI_Period3=6;
extern int RSI_Period4=8;
extern int RSI_Price1=0;
extern int RSI_Price2=0;
extern int RSI_Price3=0;
extern int RSI_Price4=0;

extern int TF=0;

double ExtBuffer0[];
double ExtBuffer1[];
double ExtBuffer2[];

double CrossUp1[];
double CrossDown1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_NONE);
   SetIndexBuffer(0,ExtBuffer0);

   SetIndexStyle(1,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(2,ExtBuffer2);

   SetIndexStyle(3,DRAW_ARROW,0,0);
   SetIndexArrow(3,233);
   SetIndexBuffer(3,CrossUp1);
   SetIndexStyle(4,DRAW_ARROW,0,0);
   SetIndexArrow(4,234);
   SetIndexBuffer(4,CrossDown1);

   SetIndexLabel(0,NULL);
   SetIndexLabel(1,"MACD+");
   SetIndexLabel(2,"MACD-");
   SetIndexLabel(3,"RSI Strike+");
   SetIndexLabel(4,"RSI Strike-");

   IndicatorShortName("RSI_Strike(AM)_SW (TF "+TF+")");

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
   double prev1,current1;

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(int i=0; i<limit; i++)
      ExtBuffer0[i]=iMA(NULL,TF,Period_MA2,0,Method_MA2,Price_MA2,i)-iMA(NULL,TF,Period_MA1,0,Method_MA1,Price_MA1,i);
   bool up1=true;
   for(i=limit-1; i>=0; i--)
     {
      current1=ExtBuffer0[i];
      prev1=ExtBuffer0[i+1];
      if(current1>prev1) up1=true;
      if(current1<prev1) up1=false;
      if(!up1)
        {
         ExtBuffer2[i]=current1;
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=current1;
         ExtBuffer2[i]=0.0;
        }

      double A_1 = iRSI(NULL, TF, RSI_Period1, RSI_Price1, i);
      double A_2 = iRSI(NULL, TF, RSI_Period1, RSI_Price1, i+1);

      double B_1 = iRSI(NULL, TF, RSI_Period2, RSI_Price2, i);
      double B_2 = iRSI(NULL, TF, RSI_Period2, RSI_Price2, i+1);

      double C_1 = iRSI(NULL, TF, RSI_Period3, RSI_Price3, i);
      double C_2 = iRSI(NULL, TF, RSI_Period3, RSI_Price3, i+1);

      double D_1 = iRSI(NULL, TF, RSI_Period4, RSI_Price4, i);
      double D_2 = iRSI(NULL, TF, RSI_Period4, RSI_Price4, i+1);

      if((A_1>B_1) && (A_2<B_2))
        {
         CrossUp1[i]=0;
        }
      else  if((A_1<B_1) && (A_2>B_2))
        {
         CrossDown1[i]=0;
        }

      if((A_1>C_1) && (A_2<C_2))
        {
         CrossUp1[i]=0;
        }
      else  if((A_1<C_1) && (A_2>C_2))
        {
         CrossDown1[i]=0;
        }

      if((A_1>D_1) && (A_2<D_2))
        {
         CrossUp1[i]=0;
        }
      else  if((A_1<D_1) && (A_2>D_2))
        {
         CrossDown1[i]=0;
        }

      if((B_1>C_1) && (B_2<C_2))
        {
         CrossUp1[i]=0;
        }
      else  if((B_1<C_1) && (B_2>C_2))
        {
         CrossDown1[i]=0;
        }

      if((B_1>D_1) && (B_2<D_2))
        {
         CrossUp1[i]=0;
        }
      else  if((B_1<D_1) && (B_2>D_2))
        {
         CrossDown1[i]=0;
        }

      if((C_1>D_1) && (C_2<D_2))
        {
         CrossUp1[i]=0;
        }
      else  if((C_1<D_1) && (C_2>D_2))
        {
         CrossDown1[i]=0;
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
