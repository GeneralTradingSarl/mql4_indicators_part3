//+------------------------------------------------------------------+
//|                                            PricePercentRange.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "https://www.mql5.com/en/users/3rjfx. ~ By 3rjfx ~ Created: 2015/12/20"
#property link      "http://www.mql5.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "2.00"
#property strict
//--
#property description "Price(%)Range is the indicator for the MT4, which calculates the price movement"
#property description "based on percentage High (Highest) and Low (Lowest) price on 100 bars."
/*
 //--Update 01: Update 1 (22/01/2016) : Added SwingBars and Vertical Line on the chart.
*/
//--
//---
#property indicator_separate_window
#property indicator_buffers 9
//--- 
extern    ENUM_APPLIED_PRICE   Price  = PRICE_TYPICAL; // Price
extern    bool            SoundAlerts = true;
extern    bool            MsgAlerts   = true;
extern    bool            eMailAlerts = false;
extern    string       SoundAlertFile = "alert.wav";
extern    color           MoveUpColor = clrBlue;
extern    color         MoveDownColor = clrRed;
extern    color    WaitDirectionColor = clrYellow;
extern    color       MoveLinkColor   = clrAqua;
extern    color             TextColor = clrSnow;
extern    color          RoundedColor = clrYellow;
extern   color   BorderlinePricesRise = clrBlue;
extern   color   BorderlinePricesDown = clrRed;
extern   int            LineWidthSize = 1;
extern color   TrendLineDowntoUpColor = clrBlue;
extern color   TrendLineUptoDownColor = clrRed;
extern color        VerticalLineColor = clrGold;
extern ENUM_LINE_STYLE      LineStyle = STYLE_SOLID;
extern ENUM_ANCHOR_POINT TextPosition = ANCHOR_RIGHT;
extern int               TextFontSize = 8;
extern string            TextFontName = "Arial Black"; //"Courier" //"Calibri" //"Cambria" //"Bodoni MT Black"
extern int           TopBottomDotSize = 15;
//--
//--- the Main arrays buffers
double ExtCPRBuffer[];
double ExtHPRBuffer[];
double ExtMHPRBuffer[];
double ExtMDPBuffer[];
double ExtMLPRBuffer[];
double ExtLPRBuffer[];
double ExtEMABuffer[];
double ExtEMABuffUp[];
double ExtEMABuffDn[];
double ema04[];
double ema24[];
double ema39[];
//--
double cph;
double cpl;
double cpr0;
double cpr1;
//--
double tpb0p1;
double tpt0p1;
double tpb0p2;
double tpt0p2;
//--
datetime fb0p1;
datetime ft0p1;
datetime fb0p2;
datetime ft0p2;
//--
bool barUp;
bool barDn;
//--- spacing &  coordinate
int scaleYt=18;
int offsetX=171;
int offsetY=3;
int fontSize=9;
int corner=1;
color arrow;
//--- bars maximum for calculation
int DATA_LIMIT;
int bigema=39;
int medema=24;
int smlema=4;
int barcnt;
int hilo;
int pos;
int prvup;
int prvdn;
//--
int cal;
int pal;
int cmnt;
int pmnt;
//--
long chart_ID;
string short_name;
string alBase,alSubj,alMsg;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffer mapping
   IndicatorBuffers(9);
//--
   short_name=StringConcatenate("Price(%R,",_Symbol,",TF:",strTF(_Period),")");
   chart_ID=ChartID();
   DATA_LIMIT=135;
   barcnt=DATA_LIMIT-1;
   hilo=100;
   pos=0;
//--- set levels - color - levelstyle
   IndicatorSetInteger(INDICATOR_LEVELS,4);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,23.6);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,38.2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,2,61.8);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,3,76.4);
//--
   IndicatorSetInteger(INDICATOR_LEVELCOLOR,clrLightSlateGray);
   IndicatorSetInteger(INDICATOR_LEVELSTYLE,STYLE_SOLID);
//--- set maximum and minimum for subwindow 
   IndicatorSetDouble(INDICATOR_MINIMUM,0);
   IndicatorSetDouble(INDICATOR_MAXIMUM,100);
//--
//---
   SetIndexBuffer(0,ExtEMABuffer); // Moving Average 39
   SetIndexBuffer(1,ExtCPRBuffer);  // Current Price%R value
   SetIndexBuffer(2,ExtHPRBuffer);  // High Price%R value
   SetIndexBuffer(3,ExtMHPRBuffer);  // Medium High Price%R value
   SetIndexBuffer(4,ExtMDPBuffer);  // Medium Price%R value
   SetIndexBuffer(5,ExtMLPRBuffer);  // Medium Low Price%R value
   SetIndexBuffer(6,ExtLPRBuffer);  // Low Price%R value
   SetIndexBuffer(7,ExtEMABuffUp);  // Moving Average 39 Up
   SetIndexBuffer(8,ExtEMABuffDn);  // Moving Average 39 Down
                                    //-- indicator drawing shape styles
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveLinkColor);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveLinkColor);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveUpColor);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveUpColor);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,LineWidthSize,WaitDirectionColor);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveDownColor);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,LineWidthSize,MoveDownColor);
   SetIndexStyle(7,DRAW_LINE,STYLE_SOLID,2,BorderlinePricesRise);
   SetIndexStyle(8,DRAW_LINE,STYLE_SOLID,2,BorderlinePricesDown);
//--
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,"Price(%)R");
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,NULL);
   SetIndexLabel(5,NULL);
   SetIndexLabel(6,NULL);
   SetIndexLabel(7,"(%R)Ups");
   SetIndexLabel(8,"(%R)Down");
//--
   IndicatorDigits(_Digits);
   IndicatorShortName(short_name);
//--
//--- initialization done
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   ObjectsDeleteAll();
   GlobalVariablesDeleteAll();
//----
   return;
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
//----
//--
   ResetLastError();
   RefreshRates();
//--
   if(rates_total<DATA_LIMIT) return(0);
//--- last counted bar will be recounted
   if(prev_calculated==0)
      DATA_LIMIT=1+(int)WindowBarsPerChart();
   barcnt=DATA_LIMIT-1;
//--- Resize the Arrays
   ArrayResize(ExtCPRBuffer,DATA_LIMIT);
   ArrayResize(ExtHPRBuffer,DATA_LIMIT);
   ArrayResize(ExtMHPRBuffer,DATA_LIMIT);
   ArrayResize(ExtMDPBuffer,DATA_LIMIT);
   ArrayResize(ExtMLPRBuffer,DATA_LIMIT);
   ArrayResize(ExtLPRBuffer,DATA_LIMIT);
   ArrayResize(ExtEMABuffer,DATA_LIMIT);
   ArrayResize(ExtEMABuffUp,DATA_LIMIT);
   ArrayResize(ExtEMABuffDn,DATA_LIMIT);
   ArrayResize(ema04,DATA_LIMIT);
   ArrayResize(ema24,DATA_LIMIT);
   ArrayResize(ema39,DATA_LIMIT);
//--
   ArraySetAsSeries(ExtCPRBuffer,true);
   ArraySetAsSeries(ExtHPRBuffer,true);
   ArraySetAsSeries(ExtMHPRBuffer,true);
   ArraySetAsSeries(ExtMDPBuffer,true);
   ArraySetAsSeries(ExtMLPRBuffer,true);
   ArraySetAsSeries(ExtLPRBuffer,true);
   ArraySetAsSeries(ExtEMABuffer,true);
   ArraySetAsSeries(ExtEMABuffUp,true);
   ArraySetAsSeries(ExtEMABuffDn,true);
   ArraySetAsSeries(ema04,true);
   ArraySetAsSeries(ema24,true);
   ArraySetAsSeries(ema39,true);
//--
   cal=0;
   int i;
   int z;
   int x=1;
   int scan=7;
   int stbar=0;
   int xbars=26;
   int xhilo=26;
   int tunebar=5;
   int tunstep=12;
   int xlimit=100;
//--
   cph=0.0;
   cpl=0.0;
   int ft0=-1;
   int fb0=-1;
   double tpt0=0.0;
   double tpb0=0.0;
   double tpttest=0.0;
   double tpbtest=0.0;
//--
//---
//--
   for(i=barcnt; i>=pos; i--)
     {ema04[i]=iMA(_Symbol,0,4,0,1,5,i);}
//--
   for(i=barcnt; i>=pos; i--)
     {ema24[i]=iMAOnArray(ema04,0,24,0,1,i);}
   for(i=barcnt; i>=pos; i--)
     {ema39[i]=iMAOnArray(ema24,0,39,0,1,i);}
//--
   int inH=iHighest(_Symbol,0,MODE_HIGH,hilo,pos);
   int inL=iLowest(_Symbol,0,MODE_LOW,hilo,pos);
   if(inH>=0) cph=iHigh(_Symbol,0,inH);
   if(inL>=0) cpl=iLow(_Symbol,0,inL);
//--
   double ma24d[],ma04d[];
   ArrayResize(ma24d,DATA_LIMIT);
   ArrayResize(ma04d,DATA_LIMIT);
   ArraySetAsSeries(ma24d,true);
   ArraySetAsSeries(ma04d,true);
//---
//---
   if(!IsStopped())
     {
      for(z=0; z<tunstep && xhilo<xlimit; z++)
        {
         //--  
         ft0=iHighest(_Symbol,0,MODE_HIGH,xhilo,stbar);
         fb0=iLowest(_Symbol,0,MODE_LOW,xhilo,stbar);
         if(ft0>=0) tpttest=iHigh(_Symbol,0,ft0);
         if(fb0>=0) tpbtest=iLow(_Symbol,0,fb0);
         //--
         if((tpttest>=iHigh(_Symbol,0,iHighest(_Symbol,0,MODE_HIGH,scan,ft0+1))) && (tpbtest<=iLow(_Symbol,0,iLowest(_Symbol,0,MODE_LOW,scan,fb0+1))))
           {
            tpt0=iHigh(_Symbol,0,ft0);
            tpb0=iLow(_Symbol,0,fb0);
            break;
           }
         else {xhilo=xbars+(tunebar*z);}
         //--
        }
     }
//--
//--
   if(ft0<fb0)
     {
      //--
      barDn=true;
      barUp=false;
      fb0p1=time[fb0];
      tpb0p1=tpb0;
      ft0p1=time[ft0];
      tpt0p1=tpt0;
      prvdn=1;
      //--
      string objnameDn10_=short_name+": VerticalLineSwingBarsUp1_";
      string objnameDn20_=short_name+": VerticalLineSwingBarsUp2_";
      string objname10=short_name+": TrendSwingBarsUp";
      string objname20=short_name+": SwingBarsPosTop0";
      string objname30=short_name+": SwingBarsPosBottom0";
      ObjectDelete(objname10);
      ObjectDelete(objname20);
      ObjectDelete(objname30);
      ObjectDelete(objnameDn10_);
      ObjectDelete(objnameDn20_);
      //--
      ObjectCreate(chart_ID,objnameDn10_,OBJ_VLINE,0,time[fb0],0);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objnameDn20_,OBJ_VLINE,0,time[ft0],0);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_HIDDEN,true);
      //---
      ObjectCreate(chart_ID,objname10,OBJ_TREND,0,time[fb0],tpb0,time[ft0],tpt0);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname20,OBJ_TEXT,0,time[ft0],tpt0);
      ObjectSetString(chart_ID,objname20,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname20,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname20,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname30,OBJ_TEXT,0,time[fb0],tpb0);
      ObjectSetString(chart_ID,objname30,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname30,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname30,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_HIDDEN,true);
      //--
      //---
      if((barDn) && (prvup==1))
        {
         prvup=0;
         //--
         string objnameUp10p=short_name+": VerticalLineSwingBarsDn1-";
         string objnameUp20p=short_name+": VerticalLineSwingBarsDn2-";
         string objname10p=short_name+": TrendSwingBarsDown2";
         string objname20p=short_name+": SwingBarsPosTop0p";
         string objname30p=short_name+": SwingBarsPosBottom0p";
         //--
         ObjectCreate(chart_ID,objnameUp10p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJ_VLINE,0,fb0p2,0);
         ObjectSetInteger(chart_ID,objnameUp10p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,VerticalLineColor);
         ObjectSetInteger(chart_ID,objnameUp10p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objnameUp10p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objnameUp10p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objnameUp20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJ_VLINE,0,ft0p2,0);
         ObjectSetInteger(chart_ID,objnameUp20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,VerticalLineColor);
         ObjectSetInteger(chart_ID,objnameUp20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objnameUp20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objnameUp20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //---
         ObjectCreate(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJ_TREND,0,ft0p2,tpt0p2,fb0p2,tpb0p2);
         ObjectSetInteger(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineUptoDownColor);
         ObjectSetInteger(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_RAY_RIGHT,false);
         ObjectSetInteger(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objname10p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,ft0p2,tpt0p2);
         ObjectSetString(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,CharToStr(119));
         ObjectSetString(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TopBottomDotSize);
         ObjectSetInteger(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineUptoDownColor);
         ObjectSetInteger(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,ANCHOR_CENTER);
         ObjectSetInteger(chart_ID,objname20p+string(TimeToString(ft0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,fb0p2,tpb0p2);
         ObjectSetString(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,CharToStr(119));
         ObjectSetString(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TopBottomDotSize);
         ObjectSetInteger(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineDowntoUpColor);
         ObjectSetInteger(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,ANCHOR_CENTER);
         ObjectSetInteger(chart_ID,objname30p+string(TimeToString(fb0p2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
        }
      //---
     }
//---
//---
   if(ft0>fb0)
     {
      //--
      barUp=true;
      barDn=false;
      fb0p2=time[fb0];
      tpb0p2=tpb0;
      ft0p2=time[ft0];
      tpt0p2=tpt0;
      prvup=1;
      //--
      string objnameUp10_=short_name+": VerticalLineSwingBarsDn1_";
      string objnameUp20_=short_name+": VerticalLineSwingBarsDn2_";
      string objname11=short_name+": TrendSwingBarsDown";
      string objname21=short_name+": SwingBarsPosTop1";
      string objname31=short_name+": SwingBarsPosBottom1";
      ObjectDelete(objname11);
      ObjectDelete(objname21);
      ObjectDelete(objname31);
      ObjectDelete(objnameUp10_);
      ObjectDelete(objnameUp20_);
      //--
      ObjectCreate(chart_ID,objnameUp10_,OBJ_VLINE,0,time[ft0],0);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objnameUp20_,OBJ_VLINE,0,time[fb0],0);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_HIDDEN,true);
      //---
      ObjectCreate(chart_ID,objname11,OBJ_TREND,0,time[ft0],tpt0,time[fb0],tpb0);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname21,OBJ_TEXT,0,time[ft0],tpt0);
      ObjectSetString(chart_ID,objname21,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname21,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname21,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname31,OBJ_TEXT,0,time[fb0],tpb0);
      ObjectSetString(chart_ID,objname31,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname31,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname31,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_HIDDEN,true);
      //--
      //---
      if((barUp) && (prvdn==1))
        {
         //--
         prvdn=0;
         //--
         string objnameDn1p=short_name+": VerticalLineSwingBarsUp1-";
         string objnameDn2p=short_name+": VerticalLineSwingBarsUp2-";
         string objname11p=short_name+": TrendSwingBarsUp1";
         string objname21p=short_name+": SwingBarsPosTop1p";
         string objname31p=short_name+": SwingBarsPosBottom1p";
         string objname41p=short_name+": AverageVolumeSwingBarsUp1p";
         //--
         ObjectCreate(chart_ID,objnameDn1p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJ_VLINE,0,fb0p1,0);
         ObjectSetInteger(chart_ID,objnameDn1p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,VerticalLineColor);
         ObjectSetInteger(chart_ID,objnameDn1p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objnameDn1p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objnameDn1p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objnameDn2p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJ_VLINE,0,ft0p1,0);
         ObjectSetInteger(chart_ID,objnameDn2p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,VerticalLineColor);
         ObjectSetInteger(chart_ID,objnameDn2p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objnameDn2p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objnameDn2p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //---
         ObjectCreate(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJ_TREND,0,fb0p1,tpb0p1,ft0p1,tpt0p1);
         ObjectSetInteger(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineDowntoUpColor);
         ObjectSetInteger(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_RAY_RIGHT,false);
         ObjectSetInteger(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_STYLE,LineStyle);
         ObjectSetInteger(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_WIDTH,LineWidthSize);
         ObjectSetInteger(chart_ID,objname11p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,ft0p1,tpt0p1);
         ObjectSetString(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,CharToStr(119));
         ObjectSetString(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TopBottomDotSize);
         ObjectSetInteger(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineUptoDownColor);
         ObjectSetInteger(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,ANCHOR_CENTER);
         ObjectSetInteger(chart_ID,objname21p+string(TimeToString(ft0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
         ObjectCreate(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,fb0p1,tpb0p1);
         ObjectSetString(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,CharToStr(119));
         ObjectSetString(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TopBottomDotSize);
         ObjectSetInteger(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TrendLineDowntoUpColor);
         ObjectSetInteger(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,ANCHOR_CENTER);
         ObjectSetInteger(chart_ID,objname31p+string(TimeToString(fb0p1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
        }
      //---
     }
//---
//----
   for(i=barcnt; i>=pos; i--)
     {
      //---
      switch(Price)
        {
         case 0:
            cpr0=Close[i];
            cpr1=Close[i+1];
            break;
         case 1:
            cpr0=Open[i];
            cpr1=Open[i+1];
            break;
         case 2:
            cpr0=High[i];
            cpr1=High[i+1];
            break;
         case 3:
            cpr0=Low[i];
            cpr1=Low[i+1];
            break;
         case 4:
            cpr0=(High[i]+Low[i])/2;
            cpr1=(High[i+1]+Low[i+1])/2;
            break;
         case 5:
            cpr0=(High[i]+Low[i]+Close[i])/3;
            cpr1=(High[i+1]+Low[i+1]+Close[i+1])/3;
            break;
         case 6:
            cpr0=(High[i]+Low[i]+Close[i]+Close[i])/4;
            cpr1=(High[i+1]+Low[i+1]+Close[i+1]+Close[i+1])/4;
            break;
        }
      //--
      ExtCPRBuffer[i]=((cpr0-cpl)/(cph-cpl))*100;
      ExtEMABuffer[i]=((ema39[i]-cpl)/(cph-cpl))*100;
      ma24d[i]=((ema24[i]-cpl)/(cph-cpl))*100;
      ma04d[i]=((ema04[i]-cpl)/(cph-cpl))*100;
      //--
      if(ma04d[i]>ExtEMABuffer[i]) {ExtEMABuffUp[i]=ExtEMABuffer[i]; ExtEMABuffDn[i]=EMPTY_VALUE; arrow=clrBlue;}
      if(ma04d[i]<ExtEMABuffer[i]) {ExtEMABuffDn[i]=ExtEMABuffer[i]; ExtEMABuffUp[i]=EMPTY_VALUE; arrow=clrRed; arrow=clrBlue;}
      if((ma24d[i]>ExtEMABuffer[i])&&(ma04d[i]>ma04d[i+1])) {ExtEMABuffUp[i]=ExtEMABuffer[i]; ExtEMABuffDn[i]=EMPTY_VALUE;}
      if((ma24d[i]<ExtEMABuffer[i])&&(ma04d[i]<ma04d[i+1])) {ExtEMABuffDn[i]=ExtEMABuffer[i]; ExtEMABuffUp[i]=EMPTY_VALUE; arrow=clrRed;}
      //--
      if((ExtCPRBuffer[i]>=76.4) && (ExtCPRBuffer[i]<100.0))
        {
         ExtHPRBuffer[i]=ExtCPRBuffer[i];
         ExtMHPRBuffer[i]=EMPTY_VALUE;
         ExtMDPBuffer[i]=EMPTY_VALUE;
         ExtMLPRBuffer[i]=EMPTY_VALUE;
         ExtLPRBuffer[i]=EMPTY_VALUE;
         MoveLinkColor=MoveUpColor;
        }
      else if((ExtCPRBuffer[i]>=61.8) && (ExtCPRBuffer[i]<76.4))
        {
         ExtHPRBuffer[i]=EMPTY_VALUE;
         ExtMHPRBuffer[i]=ExtCPRBuffer[i];
         ExtMDPBuffer[i]=EMPTY_VALUE;
         ExtMLPRBuffer[i]=EMPTY_VALUE;
         ExtLPRBuffer[i]=EMPTY_VALUE;
         MoveLinkColor=MoveUpColor;
        }
      else if((ExtCPRBuffer[i]>=38.2) && (ExtCPRBuffer[i]<61.8))
        {
         ExtHPRBuffer[i]=EMPTY_VALUE;
         ExtMHPRBuffer[i]=EMPTY_VALUE;
         ExtMDPBuffer[i]=ExtCPRBuffer[i];
         ExtMLPRBuffer[i]=EMPTY_VALUE;
         ExtLPRBuffer[i]=EMPTY_VALUE;
         MoveLinkColor=WaitDirectionColor;
        }
      else if((ExtCPRBuffer[i]>=23.6) && (ExtCPRBuffer[i]<38.2))
        {
         ExtHPRBuffer[i]=EMPTY_VALUE;
         ExtMHPRBuffer[i]=EMPTY_VALUE;
         ExtMDPBuffer[i]=EMPTY_VALUE;
         ExtMLPRBuffer[i]=ExtCPRBuffer[i];
         ExtLPRBuffer[i]=EMPTY_VALUE;
         MoveLinkColor=MoveDownColor;
        }
      else if((ExtCPRBuffer[i]>=0.0) && (ExtCPRBuffer[i]<23.6))
        {
         ExtHPRBuffer[i]=EMPTY_VALUE;
         ExtMHPRBuffer[i]=EMPTY_VALUE;
         ExtMDPBuffer[i]=EMPTY_VALUE;
         ExtMLPRBuffer[i]=EMPTY_VALUE;
         ExtLPRBuffer[i]=ExtCPRBuffer[i];
         MoveLinkColor=MoveDownColor;
        }
      //--
      //---
      if(i==0)
        {
         //---
         if(ExtCPRBuffer[i]>ExtCPRBuffer[i+1])
           {
            //--
            ObjectDelete(chart_ID,"txCons"+string(x));
            ObjectDelete(chart_ID,"txCons"+string(x)+"a");
            ObjectDelete(chart_ID,"txCons"+string(x)+"a"+"1");
            //--
            ObjectCreate(chart_ID,"txCons"+string(x),OBJ_LABEL,1,0,0);
            ObjectSetString(chart_ID,"txCons"+string(x),OBJPROP_FONT,"Wingdings");
            ObjectSetString(chart_ID,"txCons"+string(x),OBJPROP_TEXT,CharToString(164));
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_FONTSIZE,27);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_COLOR,RoundedColor);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_XDISTANCE,offsetX-6);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_YDISTANCE,scaleYt+offsetY+19);
            //--
            ObjectCreate(chart_ID,"txCons"+string(x)+"a",OBJ_LABEL,1,0,0);
            ObjectSetString(chart_ID,"txCons"+string(x)+"a",OBJPROP_FONT,"Wingdings");
            ObjectSetString(chart_ID,"txCons"+string(x)+"a",OBJPROP_TEXT,CharToString(217));
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_FONTSIZE,20);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_COLOR,arrow);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_CORNER,corner);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_XDISTANCE,offsetX-10);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_YDISTANCE,offsetY+24);
            //--
            if(cpr0>cpr1)
              {
               ObjectCreate(chart_ID,"txCons"+string(x)+"a"+"1",OBJ_LABEL,1,0,0);
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_TEXT,"UP");
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONTSIZE,7);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_COLOR,TextColor);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_CORNER,corner);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_XDISTANCE,offsetX-14);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_YDISTANCE,2*scaleYt+offsetY+33);
              }
            //--
            else
              {
               ObjectCreate(chart_ID,"txCons"+string(x)+"a"+"1",OBJ_LABEL,1,0,0);
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_TEXT,"WAIT");
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONTSIZE,7);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_COLOR,TextColor);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_CORNER,corner);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_XDISTANCE,offsetX-7);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_YDISTANCE,2*scaleYt+offsetY+33);
              }
           }
         //---
         else if(ExtCPRBuffer[i]<ExtCPRBuffer[i+1])
           {
            //--
            ObjectDelete(chart_ID,"txCons"+string(x));
            ObjectDelete(chart_ID,"txCons"+string(x)+"a");
            ObjectDelete(chart_ID,"txCons"+string(x)+"a"+"1");
            //--
            ObjectCreate(chart_ID,"txCons"+string(x),OBJ_LABEL,1,0,0);
            ObjectSetString(chart_ID,"txCons"+string(x),OBJPROP_FONT,"Wingdings");
            ObjectSetString(chart_ID,"txCons"+string(x),OBJPROP_TEXT,CharToString(164));
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_FONTSIZE,27);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_COLOR,RoundedColor);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_XDISTANCE,offsetX-6);
            ObjectSetInteger(chart_ID,"txCons"+string(x),OBJPROP_YDISTANCE,scaleYt+offsetY+29);
            //--
            ObjectCreate(chart_ID,"txCons"+string(x)+"a",OBJ_LABEL,1,0,0);
            ObjectSetString(chart_ID,"txCons"+string(x)+"a",OBJPROP_FONT,"Wingdings");
            ObjectSetString(chart_ID,"txCons"+string(x)+"a",OBJPROP_TEXT,CharToString(218));
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_FONTSIZE,20);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_COLOR,arrow);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_CORNER,corner);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_XDISTANCE,offsetX-10);
            ObjectSetInteger(chart_ID,"txCons"+string(x)+"a",OBJPROP_YDISTANCE,3*scaleYt+offsetY+16);
            //--
            if(cpr0<cpr1)
              {
               ObjectCreate(chart_ID,"txCons"+string(x)+"a"+"1",OBJ_LABEL,1,0,0);
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_TEXT,"DOWN");
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONTSIZE,7);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_COLOR,TextColor);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_CORNER,corner);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_XDISTANCE,offsetX-6);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_YDISTANCE,scaleYt+offsetY+21);
              }
            //--
            else
              {
               ObjectCreate(chart_ID,"txCons"+string(x)+"a"+"1",OBJ_LABEL,1,0,0);
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_TEXT,"WAIT");
               ObjectSetString(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_FONTSIZE,7);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_COLOR,TextColor);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_CORNER,corner);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_XDISTANCE,offsetX-8);
               ObjectSetInteger(chart_ID,"txCons"+string(x)+"a"+"1",OBJPROP_YDISTANCE,scaleYt+offsetY+21);
              }
           }
         //---
         if((ma04d[i+1]<=ExtEMABuffer[i+1])&&(ma04d[i]>ExtEMABuffer[i])&&(cpr0>cpr1)&&(ExtEMABuffUp[i]!=EMPTY_VALUE)) {cal=391;}
         if((ma04d[i+1]>=ExtEMABuffer[i+1])&&(ma04d[i]<ExtEMABuffer[i])&&(cpr0<cpr1)&&(ExtEMABuffDn[i]!=EMPTY_VALUE)) {cal=390;}
         if((ma04d[i]>ExtEMABuffer[i])&&(ExtCPRBuffer[i]<80.0)&&(cpr0>cpr1)&&(ma04d[i]>ma04d[i+1])&&(ExtEMABuffUp[i]!=EMPTY_VALUE)) {cal=393;}
         if((ma04d[i]<ExtEMABuffer[i])&&(ExtCPRBuffer[i]>20.0)&&(cpr0<cpr1)&&(ma04d[i]<ma04d[i+1])&&(ExtEMABuffDn[i]!=EMPTY_VALUE)) {cal=392;}
         if((ExtCPRBuffer[i+1]<23.6)&&(ExtCPRBuffer[i]>23.6)&&(ExtEMABuffer[i]>38.2)&&(cpr0>cpr1)) {cal=395;}
         if((ExtCPRBuffer[i+1]>76.4)&&(ExtCPRBuffer[i]<76.4)&&(ExtEMABuffer[i]<61.8)&&(cpr0<cpr1)) {cal=394;}
         if((ExtCPRBuffer[i]<23.6)&&(inL<inH)&&(ExtEMABuffer[i]>61.8)&&(ma04d[i]>ma04d[i+1])&&(cpr0>cpr1)) {cal=397;}
         if((ExtCPRBuffer[i]>76.4)&&(inH<inL)&&(ExtEMABuffer[i]<38.2)&&(ma04d[i]<ma04d[i+1])&&(cpr0<cpr1)) {cal=396;}
         //---
        }
      //---
     }
//---
   ChartRedraw(0);
   RefreshRates();
   p_alerts(cal);
//---
//--- done!
   return(rates_total);
  }
//----//

void Do_Alerts(string msgText,string eMailSub)
  {
//--
   if(MsgAlerts) Alert(msgText);
   if(SoundAlerts) PlaySound(SoundAlertFile);
   if(eMailAlerts) SendMail(eMailSub,msgText);
//--
  }
//---/

//---/
string strTF(int period)
  {
   switch(period)
     {
      //--
      case PERIOD_M1: return("M1");
      case PERIOD_M5: return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H4: return("H4");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN");
      //--
     }
   return(string(period));
  }
//---/

void p_alerts(int alert)
  {
//--
   cmnt=(int)Minute();
   if(cmnt!=pmnt)
     {
      //---
      //--
      if((cal!=pal) && (alert==391))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Up,");
         alMsg=StringConcatenate(alSubj," Action: Open BUY.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==390))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Down,");
         alMsg=StringConcatenate(alSubj," Action: Open SELL.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==393))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Up,");
         alMsg=StringConcatenate(alSubj," Action: Open BUY.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==392))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Down,");
         alMsg=StringConcatenate(alSubj," Action: Open SELL.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==395))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Up,");
         alMsg=StringConcatenate(alSubj," Action: Open BUY.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==394))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Down,");
         alMsg=StringConcatenate(alSubj," Action: Open SELL.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==397))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Up,");
         alMsg=StringConcatenate(alSubj," Action: Open BUY.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      if((cal!=pal) && (alert==396))
        {
         alBase=StringConcatenate(short_name," ",_Symbol,", TF: ",strTF(_Period)," @ ",TimeToStr(TimeCurrent(),TIME_MINUTES|TIME_SECONDS));
         alSubj=StringConcatenate(alBase,". The Price Goes Down,");
         alMsg=StringConcatenate(alSubj," Action: Open SELL.!!");
         pmnt=cmnt;
         pal=cal;
         Do_Alerts(alMsg,alSubj);
        }
      //--
      //---
     }
//--
   return;
//--
//----
  } //-end p_alerts()
//---/
//+------------------------------------------------------------------+
