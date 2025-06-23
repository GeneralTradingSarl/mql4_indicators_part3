//*
//* my_DailyOpen_indicator
//*
//* Revision 1.1  2005/11/13 Midnite
//* Initial DailyOpen indicator
//
// *** The original indicator has input for drawing a horizontal line on the hour (9:00, 11:00, 15:00 etc) 
// *** but not past the hour (09:30, 15:15 etc).
// *** Edits by file45 : 
// *** Added - the ability to input minutes and set the horizontal line start time 
// *** at any minute past the hour (9:30, 10:42, 12:56 etc).
// *** Added - Alerts to hours entry > 23 and minutes entry > 59.

#property copyright "Midnite"
#property link      "me@home.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_style1 0
#property indicator_width1 0

double TodayOpenBuffer[];
extern int Hour_= 9;
extern int Minutes = 30;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()

{
   if (Hour_>23){
   Alert ("Please enter a value lower than 24 hours");
   return(0);}

   if (Minutes>59){
   Alert ("Please enter a value lower than 60 minutes");
   return (0);}
  
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
   int lastbar;
   int counted_bars= IndicatorCounted();
   
   if (counted_bars>0) counted_bars--;
   lastbar = Bars-counted_bars;	
   DailyOpen(0,lastbar);
   
   return (0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DailyOpen(int offset, int lastbar)
{
   int shift;
   int tzdiffsec= (Hour_*3600)+(Minutes*60);
   double barsper30= 1.0*PERIOD_M30/Period();
   bool ShowDailyOpenLevel= True;
   // lastbar+= barsperday+2;  // make sure we catch the daily open		 
   lastbar= MathMin(Bars-20*barsper30-1, lastbar);

	for(shift=lastbar;shift>=offset;shift--){
	  TodayOpenBuffer[shift]= 0;
     if (ShowDailyOpenLevel){
       if(TimeDay(Time[shift]-tzdiffsec) != TimeDay(Time[shift+1]-tzdiffsec)){      // day change
         TodayOpenBuffer[shift]= Open[shift];         
         TodayOpenBuffer[shift+1]= 0;                                                           // avoid stairs in the line
       }
       else{
         TodayOpenBuffer[shift]= TodayOpenBuffer[shift+1];
       }
	  }
   }
   return(0);
}