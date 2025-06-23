//+------------------------------------------------------------------+
//|                                                      ROCv2.1.mq4 |
//|                                         Copyright 2015, mrak297. |
//|                            https://www.mql5.com/ru/users/mrak297 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, mrak297."
#property link      "https://www.mql5.com/ru/users/mrak297"
#property version   "2.1"
#property strict
#property indicator_separate_window
//--- input parameters
input string  Pairs="USDJPY,AUDUSD,EURJPY,EURCHF,EURGBP,EURUSD,GBPUSD,USDCHF,USDCAD";
input ENUM_TIMEFRAMES TimeFrame=PERIOD_D1;//Period for calculating
input ENUM_TIMEFRAMES Per   = PERIOD_M15; //Period for new opened charts
input color   UPcolor = clrLimeGreen;     //Color when moved up
input color   DownColor = clrTomato;      //Color when moved down
//---
int    Size=10; //Font size
string Font= "Arial Black";
int    BGcolor;  //Bars background color
int    cF = 100; //Coefficient of scale
int    num,Zero,Wbar,Hbar,Xsize,Ysize;
string PairsArray[];  //Array for Pairs Name
double ChangeArray[]; //Array for Pairs Change
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   EventSetMillisecondTimer(250);
//---
   IndicatorShortName("Rate Of Change ("+PeriodToString(TimeFrame)+")");
   IndicatorSetDouble(INDICATOR_MAXIMUM,1);
   IndicatorSetDouble(INDICATOR_MINIMUM,-1);
//---
   BGcolor=(int)ChartGetInteger(0,CHART_COLOR_BACKGROUND);
//---
   ushort sep=StringGetCharacter(Pairs,6);
   num=StringSplit(Pairs,sep,PairsArray);
//---
   ArrayResize(ChangeArray,num,num);
//---
   Xsize = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,1);
   Ysize = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,1);
//---
   Zero=(int)MathRound(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,1)/2);
//---
   Wbar=(int)MathRound((Xsize-15)/num);
//---
   if(MathRound(Wbar/5)<MathRound(Ysize/7))
      Size=PixToPoints((int)MathRound(Wbar/5));
   else Size=PixToPoints((int)MathRound(Ysize/7));
//---
   int j=5;
//---
   for(int i=0; i<num; i++)
     {
      CreateRecLabel(PairsArray[i]+"Bar",j,Zero,Wbar,10);
      CreateTextLabel(PairsArray[i]+"Text",j,Zero,PairsArray[i],ANCHOR_LEFT_UPPER);
      CreateTextLabel(PairsArray[i]+"Change",j,Zero,"NaN",ANCHOR_LEFT_LOWER);
      j+=Wbar+1;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
//---
   for(int i=0; i<num; i++)
     {
      ObjectDelete(PairsArray[i]+"Bar");
      ObjectDelete(PairsArray[i]+"Text");
      ObjectDelete(PairsArray[i]+"Change");
     }
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
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   for(int i=0; i<num; i++)
     {
      ChangeArray[i]=SymbolChange(PairsArray[i],TimeFrame);
      //---
      if(ChangeArray[i]<0)
        {
         ObjectSetInteger(0,PairsArray[i]+"Bar",OBJPROP_YSIZE,(int)MathAbs(ChangeArray[i]*cF));
         ObjectSetInteger(0,PairsArray[i]+"Bar",OBJPROP_COLOR,DownColor);
         ObjectSetInteger(0,PairsArray[i]+"Text",OBJPROP_COLOR,DownColor);
         ObjectSetInteger(0,PairsArray[i]+"Change",OBJPROP_COLOR,DownColor);
         ObjectSetInteger(0,PairsArray[i]+"Text",OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetInteger(0,PairsArray[i]+"Change",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
         ObjectSetString(0,PairsArray[i]+"Change",OBJPROP_TEXT,DoubleToString(ChangeArray[i],2)+"%");
        }
      else
        {
         ObjectSetInteger(0,PairsArray[i]+"Bar",OBJPROP_YDISTANCE,(int)(Zero-ChangeArray[i]*cF));
         ObjectSetInteger(0,PairsArray[i]+"Bar",OBJPROP_YSIZE,(int)(ChangeArray[i]*cF));
         ObjectSetInteger(0,PairsArray[i]+"Bar",OBJPROP_COLOR,UPcolor);
         ObjectSetInteger(0,PairsArray[i]+"Text",OBJPROP_COLOR,UPcolor);
         ObjectSetInteger(0,PairsArray[i]+"Change",OBJPROP_COLOR,UPcolor);
         ObjectSetInteger(0,PairsArray[i]+"Text",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
         ObjectSetInteger(0,PairsArray[i]+"Change",OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
         ObjectSetString(0,PairsArray[i]+"Change",OBJPROP_TEXT,DoubleToString(ChangeArray[i],2)+"%");
        }
     }
   int max = ArrayMaximum(ChangeArray, WHOLE_ARRAY, 0);
   int min = ArrayMinimum(ChangeArray, WHOLE_ARRAY, 0);
//---
   double tmp=0;
//---
   if(ChangeArray[max]>MathAbs(ChangeArray[min])) tmp=ChangeArray[max];
   else tmp=MathAbs(ChangeArray[min]);
//---
   if(tmp*cF>Ysize/2) cF--;
   if((Ysize/2-tmp*cF)>20) cF++;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      string name=StringSubstr(sparam,0,6);
      ChartOpen(name,Per);
     }
   if(id==CHARTEVENT_CHART_CHANGE) OnInit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbolChange(string symbol,ENUM_TIMEFRAMES period)
  {
   SymbolSelect(symbol,true);
   double perf  = 0;
   double open  = iOpen(symbol, period, 0);
   double close = iClose(symbol, period, 0);
//---
   if(open!=0)
     {
      perf=(close-open);
      perf /= open;
      perf *= 100;
     }
   else Print("Change NaN");
//---
   return(NormalizeDouble(perf, 2));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateTextLabel(string name,int x,int y,string text,ENUM_ANCHOR_POINT anchor)
  {
   ObjectDelete(0,name);
   ResetLastError();
//---
   if(ObjectCreate(0,name,OBJ_LABEL,1,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetString(0,name,OBJPROP_TEXT,text);
      ObjectSetString(0,name,OBJPROP_FONT,Font);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,Size);
      ObjectSetDouble(0,name,OBJPROP_ANGLE,0.0);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlue);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,1);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,"\n");
     }
   else Print("ERROR Creating object.",GetLastError());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateRecLabel(string name,int x,int y,int xsize,int ysize)
  {
   ObjectDelete(0,name);
   ResetLastError();
//---
   if(ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,1,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,xsize);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,ysize);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,BGcolor);
      ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrDodgerBlue);
      ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,"\n");
     }
   else Print("ERROR Creating object.",GetLastError());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PixToPoints(int pix)
  {
   int pt=0;
   int ems[28][2]=
     {
      6,8,7,9,7,10,8,11,9,12,10,13,10,14,11,15,12,16,13,17,13,18,14,19,14,20,15,21,16,22,
      17,23,18,24,20,26,22,29,24,32,26,35,27,36,28,37,29,38,30,40,32,42,34,45,36,48
     };
//---
   if(pix<8)
      return(6);
   if(pix>48)
      return(36);
//---
   for(int i=0; i<28; i++)
     {
      if(pix==ems[i][1])
        {
         pt=ems[i][0];
         break;
        }
     }
   return(pt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PeriodToString(ENUM_TIMEFRAMES tframe)
  {
   string result=" ";
   string PeriodArray[9][2]=
     {
      "M1","1",
      "M5","5",
      "M15","15",
      "M30","30",
      "H1","60",
      "H4","240",
      "D1","1440",
      "W1","10080",
      "MN1","43200"
     };
   for(int i=0; i<9; i++)
     {
      if((string)tframe==PeriodArray[i][1])
        {
         result=PeriodArray[i][0];
         break;
        }
     }
   return(result);
  }
//+--------------------------------------------------------------------+
