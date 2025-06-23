//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_style1 4
#property indicator_width1 1

double TodayOpenBuffer[];
extern double TimeZoneOfData=0;
extern double  Horizontaloffset=20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,TodayOpenBuffer);
   SetIndexLabel(0,"Open");
   SetIndexEmptyValue(0,0.0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int lastbar=Bars-counted_bars;
   if(counted_bars==0) lastbar-=1+1;

   DailyOpen(1,lastbar);
   return (0);
  }
//+------------------------------------------------------------------+
//| DailyOpen                                                        |
//+------------------------------------------------------------------+
int DailyOpen(int offset,int lastbar)
  {
   int shift;
   int tzdiffsec=TimeZoneOfData*3600;
   double barsper30=1.0*PERIOD_M30/Period();
   bool ShowDailyOpenLevel=True;
// lastbar+= barsperday+2;  // make sure we catch the daily open		 
   //lastbar=MathMin(Bars-20*barsper30-1,lastbar);

   for(shift=lastbar;shift>=offset;shift--)
     {
      TodayOpenBuffer[shift]=0;
      if(ShowDailyOpenLevel)
        {
         if(TimeDay(Time[shift]-tzdiffsec)!=TimeDay(Time[shift-1]-tzdiffsec))
           {      // day change
            TodayOpenBuffer[shift]=Open[shift];
            TodayOpenBuffer[shift+1]=0;                                                           // avoid stairs in the line
           }
         else
           {
            TodayOpenBuffer[shift]=TodayOpenBuffer[shift+1];
           }
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
