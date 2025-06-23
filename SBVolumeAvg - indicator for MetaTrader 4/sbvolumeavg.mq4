//+------------------------------------------------------------------+
//|                                                  SBVolumeAvg.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 30/12/2015 |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "https://www.mql5.com/en/users/3rjfx. ~ By 3rjfx ~ Created: 2015/12/30"
#property link      "http://www.mql5.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "1.00"
//--
#property description "SBVolumeAvg is the Forex Indicator (MT4) for calculate Average Volume on the Swing Bars,"
#property description "by a zigzag trend line that is bounded by two vertical lines."
#property description "This indicator may be useful for traders who use the average daily trading volume strategy."
//---
#property indicator_chart_window
//--
extern int       SwingBarsCalculation = 26; // Count of bars for calculation Highest/Lowest price
extern int    MultiplicationDepthBars = 5;
extern int             TuningScanBars = 7;
extern int                 TuningStep = 12;
extern int    DigitsAfterDecimalPoint = 2;
extern color   TrendLineDowntoUpColor = clrBlue;
extern color   TrendLineUptoDownColor = clrRed;
extern color        VerticalLineColor = clrGold;
extern color                TextColor = clrSnow;
extern ENUM_LINE_STYLE      LineStyle = STYLE_SOLID;
extern ENUM_ANCHOR_POINT TextPosition = ANCHOR_RIGHT;
extern int               TextFontSize = 8;
extern string            TextFontName = "Arial Black"; //"Courier" //"Calibri" //"Cambria" //"Bodoni MT Black"
extern int              LineWidthSize = 1;
extern int           TopBottomDotSize = 15;
//--
//--- the Main arrays buffers
double Vol[];
datetime Times[];
//--
double tpb0p1;
double tpt0p1;
double tpb0p2;
double tpt0p2;
double avgV1;
double avgV2;
//--
int prvup;
int prvdn;
int vpos1;
int vpos2;
//--
datetime fb0p1;
datetime ft0p1;
datetime fb0p2;
datetime ft0p2;
//--
int digs;
int bars;
int hilo;
int limit;
int xlimit;
int window;
//--
bool res;
bool VolUp;
bool VolDn;
long chart_ID;
//--
string shortname;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   shortname=StringConcatenate("SBVA,",_Symbol,",TF:",strTF(_Period));
   chart_ID=ChartID();
   bars=171;
   xlimit=(int)bars/2;
   digs=DigitsAfterDecimalPoint;
//--
   hilo=SwingBarsCalculation;
//--
   IndicatorDigits(digs);
   IndicatorShortName(shortname);
//--
   if(hilo>=xlimit)
     {
      Print("-----"," ",shortname," Warning: SwingBarsCalculation is more than Bars calculation.");
      window=ChartWindowFind();
      res=ChartIndicatorDelete(0,window,shortname);
      return(REASON_INITFAILED);
     }
//--
   if(MultiplicationDepthBars*TuningScanBars>xlimit)
     {
      Print("-----"," ",shortname," Warning: TuningScanBars multiplied by MultiplicationDepth value is too large.");
      window=ChartWindowFind();
      res=ChartIndicatorDelete(0,window,shortname);
      return(REASON_INITFAILED);
     }
//--
   if(MultiplicationDepthBars*TuningStep>xlimit)
     {
      Print("-----"," ",shortname," Warning: TuningStep multiplied by MultiplicationDepth value is too large.");
      window=ChartWindowFind();
      res=ChartIndicatorDelete(0,window,shortname);
      return(REASON_INITFAILED);
     }
//--
   limit=Bars_Calculate();
//--
//--- initialization done.!
   return(INIT_SUCCEEDED);
  }
//---
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   PrintFormat("%s: Deinitialization reason code: %d",__FUNCTION__,reason);
   if(reason==REASON_REMOVE)
     {
      PrintFormat("An indicator %s has deleted from the chart..!!",shortname,__FILE__);
      //--
     }
//--
   ObjectsDeleteAll();
   GlobalVariablesDeleteAll();
//----
   return;
  }
//---
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
//--- check for rates total
   limit=rates_total-prev_calculated;
   if(rates_total<=bars)
      return(0);
   if(prev_calculated>0)
     {limit=Bars_Calculate();}
//--
   ResetLastError();
   ChartRedraw(0);
   RefreshRates();
//---
//---
//--
   int v,x;
   int vbar0;
   int stbar=0;
   int xhilo=hilo;
   int tunstep=TuningStep;
   int scan=TuningScanBars;
   int tunebar=MultiplicationDepthBars;
//--
   double sumVol=0.0;
   double avgVol=0.0;
//--
//---
//----
//---
//--
   if(!IsStopped())
     {
      for(x=0; x<tunstep && xhilo<xlimit; x++)
        {
         //--  
         int ft0=iHighest(_Symbol,0,MODE_HIGH,xhilo,stbar);
         int fb0=iLowest(_Symbol,0,MODE_LOW,xhilo,stbar);
         if(ft0!=-1) double tpttest=iHigh(_Symbol,0,ft0);
         if(fb0!=-1) double tpbtest=iLow(_Symbol,0,fb0);
         //--
         if((tpttest>=iHigh(_Symbol,0,iHighest(_Symbol,0,MODE_HIGH,scan,ft0+1))) && (tpbtest<=iLow(_Symbol,0,iLowest(_Symbol,0,MODE_LOW,scan,fb0+1))))
           {
            double tpt0=iHigh(_Symbol,0,ft0);
            double tpb0=iLow(_Symbol,0,fb0);
            break;
           }
         else {xhilo=hilo+(tunebar*x);}
         //--
        }
     }
//--
   if(ft0<fb0)
     {
      //--
      vbar0=fb0-ft0+1;
      //--
      for(v=fb0; v>=ft0; v--)
        {sumVol+=Vol[v];}
      avgVol=NormalizeDouble(sumVol/vbar0,digs);
      avgV1=avgVol;
      VolDn=true;
      VolUp=false;
      fb0p1=Times[fb0];
      tpb0p1=tpb0;
      ft0p1=Times[ft0];
      tpt0p1=tpt0;
      vpos1=Times[ft0+1];
      prvdn=1;
      //--
      string objnameDn10_=shortname+": VerticalLineSwingBarsUp1_";
      string objnameDn20_=shortname+": VerticalLineSwingBarsUp2_";
      string objname10=shortname+": TrendSwingBarsUp";
      string objname20=shortname+": SwingBarsPosTop0";
      string objname30=shortname+": SwingBarsPosBottom0";
      string objname40=shortname+": AverageVolumeSwingBarsUp";
      ObjectDelete(objname10);
      ObjectDelete(objname20);
      ObjectDelete(objname30);
      ObjectDelete(objname40);
      ObjectDelete(objnameDn10_);
      ObjectDelete(objnameDn20_);
      //--
      ObjectCreate(chart_ID,objnameDn10_,OBJ_VLINE,0,Times[fb0],0);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameDn10_,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objnameDn20_,OBJ_VLINE,0,Times[ft0],0);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameDn20_,OBJPROP_HIDDEN,true);
      //---
      ObjectCreate(chart_ID,objname10,OBJ_TREND,0,Times[fb0],tpb0,Times[ft0],tpt0);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objname10,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname20,OBJ_TEXT,0,Times[ft0],tpt0);
      ObjectSetString(chart_ID,objname20,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname20,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname20,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname20,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname30,OBJ_TEXT,0,Times[fb0],tpb0);
      ObjectSetString(chart_ID,objname30,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname30,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname30,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname30,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname40,OBJ_TEXT,0,Times[ft0+1],tpt0);
      ObjectSetInteger(chart_ID,objname40,OBJPROP_COLOR,TextColor);
      ObjectSetString(chart_ID,objname40,OBJPROP_TEXT,DoubleToString(avgVol,digs));
      ObjectSetString(chart_ID,objname40,OBJPROP_FONT,TextFontName);
      ObjectSetInteger(chart_ID,objname40,OBJPROP_FONTSIZE,TextFontSize);
      ObjectSetInteger(chart_ID,objname40,OBJPROP_ANCHOR,TextPosition);
      ObjectSetInteger(chart_ID,objname40,OBJPROP_HIDDEN,true);
      //--
      //---
      if((VolDn) && (prvup==1))
        {
         prvup=0;
         //--
         string objnameUp10p=shortname+": VerticalLineSwingBarsDn1-";
         string objnameUp20p=shortname+": VerticalLineSwingBarsDn2-";
         string objname10p=shortname+": TrendSwingBarsDown2";
         string objname20p=shortname+": SwingBarsPosTop0p";
         string objname30p=shortname+": SwingBarsPosBottom0p";
         string objname40p=shortname+": AverageVolumeSwingBarsDown0p";
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
         ObjectCreate(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,vpos2,tpb0p2);
         ObjectSetInteger(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TextColor);
         ObjectSetString(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,DoubleToString(avgV2,digs));
         ObjectSetString(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,TextFontName);
         ObjectSetInteger(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TextFontSize);
         ObjectSetInteger(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,TextPosition);
         ObjectSetInteger(chart_ID,objname40p+string(TimeToString(vpos2,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
        }
      //---
     }
//---
//---
   if(ft0>fb0)
     {
      //--
      vbar0=ft0-fb0+1;
      //--
      for(v=ft0; v>=fb0; v--)
        {sumVol+=Vol[v];}
      avgVol=NormalizeDouble(sumVol/vbar0,digs);
      avgV2=avgVol;
      VolUp=true;
      VolDn=false;
      fb0p2=Times[fb0];
      tpb0p2=tpb0;
      ft0p2=Times[ft0];
      tpt0p2=tpt0;
      vpos2=Times[fb0+1];
      prvup=1;
      //--
      string objnameUp10_=shortname+": VerticalLineSwingBarsDn1_";
      string objnameUp20_=shortname+": VerticalLineSwingBarsDn2_";
      string objname11=shortname+": TrendSwingBarsDown";
      string objname21=shortname+": SwingBarsPosTop1";
      string objname31=shortname+": SwingBarsPosBottom1";
      string objname41=shortname+": AverageVolumeSwingBarsDown";
      ObjectDelete(objname11);
      ObjectDelete(objname21);
      ObjectDelete(objname31);
      ObjectDelete(objname41);
      ObjectDelete(objnameUp10_);
      ObjectDelete(objnameUp20_);
      //--
      ObjectCreate(chart_ID,objnameUp10_,OBJ_VLINE,0,Times[ft0],0);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameUp10_,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objnameUp20_,OBJ_VLINE,0,Times[fb0],0);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_COLOR,VerticalLineColor);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objnameUp20_,OBJPROP_HIDDEN,true);
      //---
      ObjectCreate(chart_ID,objname11,OBJ_TREND,0,Times[ft0],tpt0,Times[fb0],tpb0);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_RAY_RIGHT,false);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_STYLE,LineStyle);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_WIDTH,LineWidthSize);
      ObjectSetInteger(chart_ID,objname11,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname21,OBJ_TEXT,0,Times[ft0],tpt0);
      ObjectSetString(chart_ID,objname21,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname21,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname21,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_COLOR,TrendLineUptoDownColor);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname21,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname31,OBJ_TEXT,0,Times[fb0],tpb0);
      ObjectSetString(chart_ID,objname31,OBJPROP_TEXT,CharToStr(119));
      ObjectSetString(chart_ID,objname31,OBJPROP_FONT,"Wingdings");
      ObjectSetInteger(chart_ID,objname31,OBJPROP_FONTSIZE,TopBottomDotSize);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_COLOR,TrendLineDowntoUpColor);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_ANCHOR,ANCHOR_CENTER);
      ObjectSetInteger(chart_ID,objname31,OBJPROP_HIDDEN,true);
      //--
      ObjectCreate(chart_ID,objname41,OBJ_TEXT,0,Times[fb0+1],tpb0);
      ObjectSetInteger(chart_ID,objname41,OBJPROP_COLOR,TextColor);
      ObjectSetString(chart_ID,objname41,OBJPROP_TEXT,DoubleToString(avgVol,digs));
      ObjectSetString(chart_ID,objname41,OBJPROP_FONT,TextFontName);
      ObjectSetInteger(chart_ID,objname41,OBJPROP_FONTSIZE,TextFontSize);
      ObjectSetInteger(chart_ID,objname41,OBJPROP_ANCHOR,TextPosition);
      ObjectSetInteger(chart_ID,objname41,OBJPROP_HIDDEN,true);
      //--
      //---
      if((VolUp) && (prvdn==1))
        {
         //--
         prvdn=0;
         //--
         string objnameDn1p=shortname+": VerticalLineSwingBarsUp1-";
         string objnameDn2p=shortname+": VerticalLineSwingBarsUp2-";
         string objname11p=shortname+": TrendSwingBarsUp1";
         string objname21p=shortname+": SwingBarsPosTop1p";
         string objname31p=shortname+": SwingBarsPosBottom1p";
         string objname41p=shortname+": AverageVolumeSwingBarsUp1p";
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
         ObjectCreate(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJ_TEXT,0,vpos1,tpt0p1);
         ObjectSetInteger(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_COLOR,TextColor);
         ObjectSetString(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_TEXT,DoubleToString(avgV1,digs));
         ObjectSetString(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONT,TextFontName);
         ObjectSetInteger(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_FONTSIZE,TextFontSize);
         ObjectSetInteger(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_ANCHOR,TextPosition);
         ObjectSetInteger(chart_ID,objname41p+string(TimeToString(vpos1,TIME_DATE|TIME_MINUTES)),OBJPROP_HIDDEN,true);
         //--
        }
      //---
     }
//---
//---
   return(rates_total);
  }
//---//
//---//

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
   return(period);
  }
//---/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Bars_Calculate()
  {
//--
   bars=171;
//--
   int b;
   ArrayResize(Vol,bars);
   ArrayResize(Times,bars);
   ArraySetAsSeries(Vol,true);
   ArraySetAsSeries(Times,true);
//--
//--- last bar counting position
   for(b=bars-1,limit=0; b>=0; b--,limit++)
     {
      Vol[b]=iVolume(_Symbol,0,b);
      Times[b]=iTime(_Symbol,0,b);
     }
//---
//---)
   return(limit);
//--
  }
//----//
//+------------------------------------------------------------------+
