//+------------------------------------------------------------------+
//|                                                    SAR_COLOR.mq4 |
//|                                                          Kalenzo |
//|                                       http://www.foreksik.prv.pl |
//+------------------------------------------------------------------+
#property copyright "Kalenzo"
#property link      "http://www.foreksik.prv.pl"
//----
#property indicator_color1 Magenta
#property indicator_color2 Yellow
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_width1 2
#property indicator_width2 2
//----
double sarUp[],sarDn[];//buffers
extern double Step=0.05;//was .01
extern double Maximum=0.2;
extern int Precision=4;
extern bool SoundON=true;
double alertBar;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,STYLE_DOT);
   SetIndexStyle(1,DRAW_ARROW,STYLE_DOT);
   SetIndexBuffer(0,sarUp);
   SetIndexBuffer(1,sarDn);
   SetIndexArrow(0,108);
   SetIndexArrow(1,108);
   //
   IndicatorShortName("SAR COLORED");
   SetIndexLabel(0,"SAR Up Channel");
   SetIndexLabel(1,"SAR Down Channel");
   //
   SetIndexDrawBegin(0,2);
   SetIndexDrawBegin(1,2);
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
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) counted_bars=0;
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- 
   for(int i=0; i<limit ;i++)
     {
      double sar=NormalizeDouble(iSAR(Symbol(),0,Step,Maximum,i),Precision);
      if(sar>=iHigh(Symbol(),0,i))
        {
         if(SoundON==true && sarUp[i]==0 && Bars>alertBar)
           {
            Alert("Sar Channel Going Down on ",Symbol(),"-",Period());
            alertBar=Bars;
           }
         sarUp[i]=sar;
         sarDn[i]=0;
        }
      else
        {
         if(SoundON==true && sarDn[i]==0 && Bars>alertBar)
           {
            Alert("Sar Channel Going Up on ",Symbol(),"-",Period());
            alertBar=Bars;
           }
         sarUp[i]=0;
         sarDn[i]=sar;
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+