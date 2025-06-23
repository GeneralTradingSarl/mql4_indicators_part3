//+------------------------------------------------------------------+
//|                                                  PriceAction.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                   https://M2P_Design@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://M2P_Design@hotmail.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 5
#property indicator_buffers 6
#property indicator_color1 clrLime
#property indicator_color2 clrRed
#property indicator_color3 clrBlue
#property indicator_color4 clrOrange
#property indicator_color5 clrDarkGreen
#property indicator_color6 clrLightCoral
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2

double PinBarU[];
double PinBarD[];
double InBarU[];
double InBarD[];
double EnBarU[];
double EnBarD[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,PinBarU);
   SetIndexBuffer(1,PinBarD);
   SetIndexBuffer(2,InBarU);
   SetIndexBuffer(3,InBarD);
   SetIndexBuffer(4,EnBarU);
   SetIndexBuffer(5,EnBarD);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexStyle(4,DRAW_HISTOGRAM);
   SetIndexStyle(5,DRAW_HISTOGRAM);
   SetIndexLabel(0,"PinBar UP");
   SetIndexLabel(1,"PinBar Down");
   SetIndexLabel(2,"Inside Bar UP");
   SetIndexLabel(3,"Inside Bar Down");
   SetIndexLabel(4,"Engulfing Bar UP");
   SetIndexLabel(5,"Engulfing Bar Down");
   IndicatorShortName("BOLA-PriceAction");

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int limit=rates_total-prev_calculated;
//---- main loop
   for(int i=0; i<limit; i++)
     {
      switch(PinBar(i))
        {
         case 2:PinBarU[i]= 1;continue;
         case 4:PinBarU[i]= 2;continue;
         case 6:PinBarU[i]= 3;continue;
         case 8:PinBarU[i]= 4;continue;
         case 1:PinBarD[i]= 1;continue;
         case 3:PinBarD[i]= 2;continue;
         case 5:PinBarD[i]= 3;continue;
         case 7:PinBarD[i]= 4;continue;
         case -1:PinBarU[i]=0;PinBarD[i]=0;
        }

      switch(InBar(i))
        {
         case 2:InBarU[i]= 1;continue;
         case 4:InBarU[i]= 2;continue;
         case 6:InBarU[i]= 3;continue;
         case 8:InBarU[i]= 4;continue;
         case 1:InBarD[i]= 1;continue;
         case 3:InBarD[i]= 2;continue;
         case 5:InBarD[i]= 3;continue;
         case 7:InBarD[i]= 4;continue;
         case -1:InBarU[i]=0;InBarD[i]=0;
        }

      switch(EnBar(i))
        {
         case 2:EnBarU[i]= 1;continue;
         case 4:EnBarU[i]= 2;continue;
         case 6:EnBarU[i]= 3;continue;
         case 8:EnBarU[i]= 4;continue;
         case 1:EnBarD[i]= 1;continue;
         case 3:EnBarD[i]= 2;continue;
         case 5:EnBarD[i]= 3;continue;
         case 7:EnBarD[i]= 4;continue;
         case -1:EnBarU[i]=0;EnBarD[i]=0;
        }
      //---
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| PinBar function                                                  |
//+------------------------------------------------------------------+
int PinBar(int i)
  {
   double Nose,Body,Wick;
   double High1=iHigh(NULL,0,i+1);
   double High2=iHigh(NULL,0,i+2);
   double High3=iHigh(NULL,0,i+3);
   double High4=iHigh(NULL,0,i+4);
   double Low1=iLow(NULL,0,i+1);
   double Low2=iLow(NULL,0,i+2);
   double Low3=iLow(NULL,0,i+3);
   double Low4=iLow(NULL,0,i+4);

//-------------
// UpCandle
//-------------
   if((High[i]-Open[i])>(High[i]-Close[i]))
     {
      Nose = High[i]-Close[i];
      Body = Close[i]-Open[i];
      Wick = Open[i]-Low[i];

      // HangMan
      if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2
         && High[i]>High3 && High[i]>High4)  return(8);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2
         && High[i]>High3)                      return(6);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2) return(4);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1)                      return(2);


      // Hammer
      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2
         && Low[i]<Low3 && Low[i]<Low4)    return(8);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2
         && Low[i]<Low3)                       return(6);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2)    return(4);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1)                       return(2);

      else return(-1);
     }

//-------------
// DownCandle
//-------------
   else if((High[i]-Open[i])<(High[i]-Close[i]))
     {
      Nose = High[i]-Open[i];
      Body = Open[i]-Close[i];
      Wick = Close[i]-Low[i];

      // HangMan
      if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2
         && High[i]>High3 && High[i]>High4)  return(7);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2
         && High[i]>High3)                      return(5);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1 && High[i]>High2) return(3);

      else if(Nose>(Wick*2) && Nose>(Body*2)
         && High[i]>High1)                      return(1);


      // Hammer
      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2
         && Low[i]<Low3 && Low[i]<Low4)    return(7);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2
         && Low[i]<Low3)                       return(5);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1 && Low[i]<Low2)    return(3);

      else if(Wick>(Nose*2) && Wick>(Body*2)
         && Low[i]<Low1)                       return(1);

      else return(-1);
     }
   else return(-1);
  }
//+------------------------------------------------------------------+
//| Inside Bar function                                              |
//+------------------------------------------------------------------+
int InBar(int i)
  {
   double High1=iHigh(NULL,0,i+1);
   double High2=iHigh(NULL,0,i+2);
   double High3=iHigh(NULL,0,i+3);
   double High4=iHigh(NULL,0,i+4);
   double Low1=iLow(NULL,0,i+1);
   double Low2=iLow(NULL,0,i+2);
   double Low3=iLow(NULL,0,i+3);
   double Low4=iLow(NULL,0,i+4);

//-------------
// UpCandle
//-------------
   if((High[i]-Open[i])>(High[i]-Close[i]))
     {
      if(High[i]<=High1 && Low[i]>=Low1
         && High[i]<=High2 && Low[i]>=Low2
         && High[i]<=High3 && Low[i]>=Low3
         && High[i]<=High4 && Low[i]>=Low4) return(8);

      else if(High[i]<=High1 &&  Low[i]>=Low1
         &&  High[i]<=High2&& Low[i]>=Low2
                      && High[i]<=High3 && Low[i]>=Low3) return(6);

      else if(High[i]<=High1 && Low[i]>=Low1
         && High[i]<=High2 && Low[i]>=Low2) return(4);

      else if(High[i]<=High1 && Low[i]>=Low1) return(2);

      else return(-1);
     }

//-------------
// DownCandle
//-------------
   else if((High[i]-Open[i])<(High[i]-Close[i]))
     {
      if(High[i]<=High1 && Low[i]>=Low1
         && High[i]<=High2 && Low[i]>=Low2
         && High[i]<=High3 && Low[i]>=Low3
         && High[i]<=High4 && Low[i]>=Low4) return(7);

      else if(High[i]<=High1 &&  Low[i]>=Low1
         &&  High[i]<=High2&& Low[i]>=Low2
                      && High[i]<=High3 && Low[i]>=Low3) return(5);

      else if(High[i]<=High1 && Low[i]>=Low1
         && High[i]<=High2 && Low[i]>=Low2) return(3);

      else if(High[i]<=High1 && Low[i]>=Low1) return(1);

      else return(-1);
     }

   else return(-1);
  }
//+------------------------------------------------------------------+
//| Engulfing Bar function                                           |
//+------------------------------------------------------------------+
int EnBar(int i)
  {
   double High1=iHigh(NULL,0,i+1);
   double High2=iHigh(NULL,0,i+2);
   double High3=iHigh(NULL,0,i+3);
   double High4=iHigh(NULL,0,i+4);
   double Low1=iLow(NULL,0,i+1);
   double Low2=iLow(NULL,0,i+2);
   double Low3=iLow(NULL,0,i+3);
   double Low4=iLow(NULL,0,i+4);

//-------------
// UpCandle
//-------------
   if((High[i]-Open[i])>(High[i]-Close[i]))
     {
      if(High[i]>=High1 && Low[i]<=Low1
         && High[i]>=High2 && Low[i]<=Low2
         && High[i]>=High3 && Low[i]<=Low3
         && High[i]>=High4 && Low[i]<=Low4) return(8);

      else if(High[i]>=High1 &&  Low[i]<=Low1
         &&  High[i]>=High2&& Low[i]<=Low2
                      && High[i]>=High3 && Low[i]<=Low3) return(6);

      else if(High[i]>=High1 && Low[i]<=Low1
         && High[i]>=High2 && Low[i]<=Low2) return(4);

      else if(High[i]>=High1 && Low[i]<=Low1) return(2);

      else return(-1);
     }

//-------------
// DownCandle
//-------------
   else if((High[i]-Open[i])<(High[i]-Close[i]))
     {
      if(High[i]>=High1 && Low[i]<=Low1
         && High[i]>=High2 && Low[i]<=Low2
         && High[i]>=High3 && Low[i]<=Low3
         && High[i]>=High4 && Low[i]<=Low4) return(7);

      else if(High[i]>=High1 && Low[i]<=Low1
         && High[i]>=High2 && Low[i]<=Low2
                     && High[i]>=High3 && Low[i]<=Low3) return(5);

      else if(High[i]>=High1 && Low[i]<=Low1
         && High[i]>=High2 && Low[i]<=Low2) return(3);

      else if(High[i]>=High1 && Low[i]<=Low1) return(1);

      else return(-1);
     }

   else return(-1);
  }
//+------------------------------------------------------------------+
