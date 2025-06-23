//+----------------------------------------------------------------+
//| RoNz Higher Timeframe High and Low.mq4 v1.0 (15.01.25) by RoNz |
//+----------------------------------------------------------------+
#property copyright   "2015, Rony Nofrianto, Indonesia."
#property link        "https://www.mql5.com/en/users/ronz"
#property description "Show High and Low for Selected Timeframe"
#property version   "1.0"
#property strict

#property indicator_chart_window

const string FontType="Arial";
const int FontSize=8;

const string Days[7]={"SUN","MON","TUE","WED","THU","FRI","SAT"};
enum EN_STD_TIMEFRAMES { M1=1,M5=5,M15=15,M30=30,H1=60,H4=240,D1=PERIOD_D1,W1=PERIOD_W1,MN1=PERIOD_MN1 };

//---- Indicator Buffers
double ExtUpperStopBuffer[],ExtLowerStopBuffer[];

//----  Indicator Inputs
extern EN_STD_TIMEFRAMES inpHigherPeriod=PERIOD_W1;//Higher Timeframe
extern bool inpUseAutoShift=false;//Use Auto Shift

int inpStopPointShift=0;//Shift
//----
string MyShortName="RoNz Timeframe High and Low";

#property indicator_buffers 2

#property indicator_label1  "Upper Period High Price"
#property indicator_color1 clrBlue
#property  indicator_type1 DRAW_LINE
#property  indicator_style1 STYLE_DOT

#property indicator_label2  "Upper Period Low Price"
#property indicator_color2 clrRed
#property  indicator_type2 DRAW_LINE
#property  indicator_style2 STYLE_DOT
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   MyShortName=MyShortName;

   if (inpUseAutoShift)
      inpStopPointShift=inpHigherPeriod/Period();
    else
      inpStopPointShift=0;

   ChartSetInteger(0,CHART_SHIFT,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,true);

//ObjectsDeleteAll(WindowFind(MyShortName));
//----   
   IndicatorShortName(MyShortName);
   IndicatorDigits(Digits());
   IndicatorBuffers(2);

   SetIndexBuffer(0,ExtUpperStopBuffer);
   SetIndexLabel(0,"Upper Period High Price");
   SetIndexShift(0,inpStopPointShift);
   SetIndexDrawBegin(0,inpStopPointShift); // Upper Stop Point

   SetIndexBuffer(1,ExtLowerStopBuffer);
   SetIndexLabel(1,"Upper Period Low Price");
   SetIndexShift(1,inpStopPointShift);
   SetIndexDrawBegin(1,inpStopPointShift); // Lower Stop Point

//---- Invisible Value
   for(int i=0; i<2; i++)
      SetIndexEmptyValue(i,0);

//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(IsTesting()) return;

   EventKillTimer();
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
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

//---- Return if no data was calculated before
   if(prev_calculated<0) return(-1);

   int limit;

//---- Calculating Entry Sign and Stop Point Indicator
   if(prev_calculated==0)
     {
      limit=rates_total;
     }
   else
     {
      limit=rates_total;//-(prev_calculated-1);
     }

//---- Calculating entry, Stop Point, and Support/Resistance indicator
   for(int i=0; i<limit && !IsStopped(); i++)
     {
      Draw_PriceStopIndicator(i,time[i]);

      if(TimeToString(time[i],TIME_MINUTES)=="00:00")
         CreateDayLabel("Day"+(string)i,time[i],ExtLowerStopBuffer[i],Days[TimeDayOfWeek(time[i])]);

     }

//---- Return calculated bar
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CreateDayLabel(string lblName,datetime time,double price,string lblText)
  {
   ObjectDelete(lblName);
   ObjectCreate(lblName,OBJ_TEXT,0,time,price);
   ObjectSetText(lblName,lblText,FontSize-3,FontType,clrGray);
   ObjectSetInteger(0,lblName,OBJPROP_SELECTABLE,false);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Draw_PriceStopIndicator(int i,datetime dtTime)
  {
//---- Setting Upper/Lower Stop Indicator   
   int UpperPeriod=inpHigherPeriod;

   int shift=iBarShift(NULL,UpperPeriod,dtTime);

   ExtUpperStopBuffer[i]=iHigh(NULL,UpperPeriod, shift);
   ExtLowerStopBuffer[i]=iLow(NULL,UpperPeriod, shift);
  }
//+------------------------------------------------------------------+