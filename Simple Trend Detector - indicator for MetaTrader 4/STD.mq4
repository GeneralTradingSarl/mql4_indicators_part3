//The Simple Trend Detector. Based on code RSI.mq4,  Copyright © 2004, MetaQuotes Software Corp. http://www.metaquotes.net/
#property  copyright "Copyright © 2004, MetaQuotes Software Corp., BECEMAL 2010"
#property  link      "http://www.becemal.ru/"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_level1 0.3
#property indicator_level2 0.7
#property indicator_buffers 3
#property indicator_color1 RoyalBlue
extern int STDPeriod=15;
double Buffer[];
double PosBuffer[];
double NegBuffer[];
bool init_flag=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool prepare_buffer()
  {
   if(init_flag) return(true);
   PosBuffer[0]=0;
   NegBuffer[0]=0;
   init_flag=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string   short_name="STD("+STDPeriod+")";
   SetIndexBuffer(1,PosBuffer);
   SetIndexBuffer(2,NegBuffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexBuffer(0,Buffer);
   IndicatorShortName(short_name);
   SetIndexLabel(0,"STD");
   SetIndexDrawBegin(0,STDPeriod);
   init_flag=false;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(!init_flag) {prepare_buffer();}
   int    i,ii,counted_bars=IndicatorCounted();
   double rel,negative,positive,Den;
   if(Bars<=STDPeriod) return(0);
   if(counted_bars<1)
      for(i=1;i<=STDPeriod;i++) Buffer[Bars-i]=0.5;
   i=Bars-STDPeriod-1;
   if(counted_bars>=STDPeriod) i=Bars-counted_bars-1;
   ii=i;
   while(i>=0) 
     {
      positive=0.0; negative=0.0;
      rel=Close[i]-Open[i];
      if(rel>0) positive = rel;
      else      negative =-rel;
      PosBuffer[i] = positive;
      NegBuffer[i] = negative;
      i--;
     }
   i=ii;
   while(i>=0) 
     {
      positive=0.0; negative=0.0;
      for(int j=0;j<STDPeriod;j++) 
        {
         double Norm=STDPeriod-j+1;
         positive+=Norm*PosBuffer[i+j];
         negative+=Norm*NegBuffer[i+j]; 
        }
      Den=positive+negative;
      if(Den==0.0) Buffer[i]=1.0;
      else Buffer[i]=positive/Den;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+
