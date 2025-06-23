#property copyright   "BestForexScript.Com"
#property link        "https://bestforexscript.com"
#property version   "1.01"
#property description "Download Expert Advisors and Indicator for FREE!"
#property description "Want an EA with Indicator, contact me on telegram: @sopheak_khmer_trader"
#property strict

#property indicator_chart_window
#property indicator_buffers 4

#property indicator_color1 Blue
#property indicator_width1 1
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID
#property indicator_label1 "Range High"

#property indicator_color2 Blue
#property indicator_width2 1
#property indicator_type2 DRAW_LINE
#property indicator_style2 STYLE_SOLID
#property indicator_label2 "Range Low"

#property indicator_color3 DodgerBlue
#property indicator_width3 1
#property indicator_type3 DRAW_HISTOGRAM
#property indicator_style3 STYLE_DOT

#property indicator_color4 Red
#property indicator_width4 1
#property indicator_type4 DRAW_HISTOGRAM
#property indicator_style4 STYLE_DOT

input string InpFromTime = "00:00";  // Range Start Time
input string InpToTime = "05:00";    // Range End Time
input string InpEndTime = "20:00";   // Trade End Time
input int InpMinPip = 250;//Minimum Size (point)
input int InpMaxPip = 500;//Maximum Size (point)

int maxday = 10;
double histohigh[], histolow[], zonehigh[], zonelow[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   IndicatorDigits(_Digits);
   SetIndexBuffer(0,zonehigh);
   SetIndexBuffer(1,zonelow);
   SetIndexBuffer(2,histohigh);
   SetIndexBuffer(3,histolow);
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
   SetIndexEmptyValue(2,EMPTY_VALUE);
   SetIndexEmptyValue(3,EMPTY_VALUE);
   IndicatorShortName("RangeBreakOut (" + InpFromTime + "-" + InpToTime + ")");
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
   
   if(PeriodSeconds(PERIOD_CURRENT) > PeriodSeconds(PERIOD_H1))return(0);
   if(maxday > iBars(_Symbol,PERIOD_D1)) maxday = iBars(_Symbol,PERIOD_D1);
   datetime dtime = iTime(_Symbol,PERIOD_D1,maxday -1);
   int limit = iBarShift(_Symbol,_Period,dtime,false); 
   for(int i = limit; i>=0; i--)
   {
      int yr = TimeYear(time[i]);
      int mt = TimeMonth(time[i]);
      int dy = TimeDay(time[i]);
      datetime fromtime = StringToTime(string(yr)+"."+string(mt)+"."+string(dy) + " " + InpFromTime + ":00");
      datetime totime = StringToTime(string(yr)+"."+string(mt)+"."+string(dy) + " " + InpToTime + ":00");
      datetime endtime = StringToTime(string(yr)+"."+string(mt)+"."+string(dy) + " " + InpEndTime + ":00");
      int fromshift = iBarShift(_Symbol,_Period,fromtime,false);
      int toshift = iBarShift(_Symbol,_Period,totime,false);
      int endshit = iBarShift(_Symbol,_Period,endtime,false);
      int hightest = iHighest(_Symbol,_Period,MODE_HIGH,fromshift-toshift+1,toshift);
      int lowest = iLowest(_Symbol,_Period,MODE_LOW,fromshift-toshift+1,toshift);
      double zhigh = high[hightest];
      double zlow = low[lowest];
      double zlength = zhigh - zlow;
      if(time[i] >= fromtime && time[i] <= endtime)
      {
         if(time[i] <= totime)
         {
            if(zlength >= InpMinPip*_Point && zlength <= InpMaxPip*_Point)
            {
               histohigh[i] = zhigh;
               histolow[i] = zlow;
            }
            else
            {
               histohigh[i] = zlow;
               histolow[i] = zhigh;
            }
         }
         zonehigh[i] = zhigh;
         zonelow[i] = zlow;
      }  
   }
   return(rates_total);
}

