//+------------------------------------------------------------------+
//|                                          !ZL_Countdown Timer.mq4 |
//|                      Copyright 2014, William Kreider (Madhatt30) |
//|                                http://www.metatradersoftware.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, William Kreider (Madhatt30)"
#property link      "http://www.metatradersoftware.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

enum FontSelect 
  {
   Arial=0,
   Times_New_Roman=1,
   Courier=2
  };
//--- input parameters
input int         dispWindow=0;
input int         corner=1;
input FontSelect  selectedFont=1;
input int         textSize=16;
input bool        bold=true;
input color       fntcolor=clrYellow;
input int         XDistance=15;
input int         YDistance=15;

long           thisChart;
int            iFontType;
string         sBoldType;
string         sFontType;
int            timeOffset;
datetime       ServerLocalOffset;
datetime       prevTime,myTime,localtime;
bool           newBar = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   EventSetTimer(1);
   thisChart = ChartID();
   if(bold){
      sBoldType=" Bold";
   }else if(!bold){
      sBoldType="";
   }
   iFontType=selectedFont;
   Comment("");
   switch(iFontType){
      case 0: sFontType="Arial" + sBoldType; break;
      case 1: sFontType="Times New Roman" + sBoldType; break;
      case 2: sFontType="Courier" + sBoldType; break;
   }
   ObjectCreate(thisChart,"BarTimer",OBJ_LABEL,dispWindow,XDistance,YDistance);
//---
   datetime srvtime,tmpOffset;
   // Use RefreshRates to get the current time from TimeCurrent
   // Otherwise you'll just get the last known time
   RefreshRates();
   srvtime = TimeCurrent();
   // Modified
   localtime = TimeLocal()+TimeGMTOffset();
   if(TimeHour(srvtime)>TimeHour(localtime)){
      // Server Time is still ahead of us
      int newOffset = TimeHour(srvtime)-TimeHour(localtime);
      ServerLocalOffset = (newOffset*60*60);
   }else if(TimeHour(srvtime)<TimeHour(localtime)){
      // Server Time is Behind us
      int newOffset = TimeHour(localtime)-TimeHour(srvtime);
      ServerLocalOffset = (newOffset*60*60);
   }else{
      // No modification required
      ServerLocalOffset = srvtime;
   }
   localtime = TimeLocal()-ServerLocalOffset;
   
   tmpOffset = TimeSeconds(srvtime) - TimeSeconds(localtime);
   if(tmpOffset < 30 && tmpOffset >= 0){
      timeOffset = TimeSeconds(srvtime) - TimeSeconds(localtime);
   }
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectDelete("BarTimer");
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
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   datetime localtime;
   localtime = TimeLocal()+(TimeGMTOffset()+(60*60));
   if(ObjectFind(thisChart,"BarTimer")>=0){
      // Found object it exists
      ObjectSet("BarTimer",OBJPROP_CORNER,corner);
      ObjectSet("BarTimer",OBJPROP_XDISTANCE,XDistance);
      ObjectSet("BarTimer",OBJPROP_YDISTANCE,YDistance);
      ObjectSetText("BarTimer",TimeToStr(Time[0]+Period()*60-localtime-timeOffset,TIME_SECONDS ),textSize,sFontType,fntcolor);
   } 
  }
//+------------------------------------------------------------------+
