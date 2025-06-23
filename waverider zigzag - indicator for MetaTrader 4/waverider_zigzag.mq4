//+------------------------------------------------------------------+
//|                                                    WaveRider.mq4 |
//|                      Copyright 2020,Barsam Mansouri Baghbaderani |
//|               cellphone:00989133151450|barsam_mansouri@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020,Barsam Mansouri Baghbaderani"
#property link      "barsam_mansouri@yahoo.com"
#property strict

#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Orange
#property  indicator_width1  1

double     WaveFractals[50],ZigzagBuffer[];
int        FractalsBar[50];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,ZigzagBuffer);
   ArraySetAsSeries(WaveFractals,true);
   ArraySetAsSeries(FractalsBar,true);
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
   int i,x=0;
//----
   ArrayInitialize(ZigzagBuffer,EMPTY_VALUE);
   ArraySetting(Symbol(),Period());
   for(i=FractalsBar[0]; i<=FractalsBar[49]; i++)
     {
      if(i==FractalsBar[x])
        {
         ZigzagBuffer[i]=WaveFractals[x];
         x++;
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Alligator Base Possible Retrace Points                           |
//+------------------------------------------------------------------+
string AlligatorRetrace(string sym,int TF,int shift)
  {
   string A="No Pattern...";
   double lips =iAlligator(sym,TF,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,shift);
   double teeth=iAlligator(sym,TF,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,shift);
   double jaws =iAlligator(sym,TF,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,shift);
   if(iHigh(sym,TF,shift)<MathMin(MathMin(lips,teeth),jaws))A="UP";
   if(iLow(sym,TF,shift)>MathMax(MathMax(lips,teeth),jaws))A="DN";

   return(A);
  }
//+------------------------------------------------------------------+
//| Finding Fractals                                                 |
//+------------------------------------------------------------------+
void FindFractals(string sym,int TF,int InputCandle,double& FractalPrice,int& FractalBar,int& OutputCandle)
  {
   string Direction;
   int Candle=0,i;
   for(i=InputCandle; i<iBars(sym,TF); i++)
     {
      if(AlligatorRetrace(sym,TF,i)=="UP")
        {
         Direction="DNWard";   //Blue Alligator Candle
         Candle=i;
         break;
        }
      if(AlligatorRetrace(sym,TF,i)=="DN")
        {
         Direction="UPWard";   //Red Alligator Candle
         Candle=i;
         break;
        }
     }
   if(Direction=="DNWard")
     {
      for(i=Candle; i<iBars(sym,TF); i++)
        {
         if(AlligatorRetrace(sym,TF,i)=="DN")
           {
            FractalPrice=iHigh(sym,TF,iHighest(sym,TF,MODE_HIGH,MathAbs(i-Candle)+1,Candle));
            FractalBar=iHighest(sym,TF,MODE_HIGH,MathAbs(i-Candle)+1,Candle);
            OutputCandle=i;
            break;
           }
        }
     }
   if(Direction=="UPWard")
     {
      for(i=Candle; i<iBars(sym,TF); i++)
        {
         if(AlligatorRetrace(sym,TF,i)=="UP")
           {
            FractalPrice=iLow(sym,TF,iLowest(sym,TF,MODE_LOW,MathAbs(i-Candle)+1,Candle));
            FractalBar=iLowest(sym,TF,MODE_LOW,MathAbs(i-Candle)+1,Candle);
            OutputCandle=i;
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Put Fractals In To Array                                         |
//+------------------------------------------------------------------+
void ArraySetting(string sym,int TF)
  {
   int out,i,FractalBar,OutputCandle;
   double FractalPrice;
   FindFractals(sym,TF,1,FractalPrice,FractalBar,OutputCandle);
   WaveFractals[1]=FractalPrice;
   FractalsBar[1]=FractalBar;
   for(i=2; i<50; i++)
     {
      out=OutputCandle;
      FindFractals(sym,TF,out,FractalPrice,FractalBar,OutputCandle);
      WaveFractals[i]=FractalPrice;
      FractalsBar[i]=FractalBar;
     }
   if(WaveFractals[1]<=WaveFractals[2])
     {
      FractalsBar[0]=iHighest(sym,TF,MODE_HIGH,FractalsBar[1],0);
      WaveFractals[0]=iHigh(sym,TF,FractalsBar[0]);
     }
   else
     {
      FractalsBar[0]=iLowest(sym,TF,MODE_LOW,FractalsBar[1],0);
      WaveFractals[0]=iLow(sym,TF,FractalsBar[0]);
     }
   for(i=1; i<49; i++)
     {
      if(WaveFractals[i]>=WaveFractals[i+1])
        {
         FractalsBar[i]=iHighest(sym,TF,MODE_HIGH,MathAbs(FractalsBar[i+1]-FractalsBar[i]),FractalsBar[i]);
         WaveFractals[i]=iHigh(sym,TF,FractalsBar[i]);
        }
      else
        {
         FractalsBar[i]=iLowest(sym,TF,MODE_LOW,MathAbs(FractalsBar[i+1]-FractalsBar[i]),FractalsBar[i]);
         WaveFractals[i]=iLow(sym,TF,FractalsBar[i]);
        }
     }
  }


//+------------------------------------------------------------------+
