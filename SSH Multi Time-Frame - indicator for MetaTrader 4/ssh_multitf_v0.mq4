//+------------------------------------------------------------------+
//|                                                 SSH_Multi_V0.mq4 |
//|                                   https://t.me/ArazAvsar |
//|                                          https://www.pipcrop.com |
//+------------------------------------------------------------------+
#property copyright "https://t.me/ArazAvsar"
#property link      "https://www.pipcrop.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 clrGreen
#property indicator_color2 clrRed
#property indicator_label1 "SSH High"
#property indicator_label2 "SSH Low"

input string S0 = "Indicator Settings";                              //-------------------------------------
input string Prefix = "Multi-SSH";                                   // Indicator Name (Change if attached more than 1 time)
extern ENUM_TIMEFRAMES TF = PERIOD_H4;                               // Select Higher Time Frame
input int Per = 55;                                                  // MA Period
input ENUM_MA_METHOD myMode = MODE_EMA;                              // MA Method
input string S1 = "Panel Settings";                                  //-------------------------------------
input ENUM_BASE_CORNER BCorner = CORNER_RIGHT_LOWER;                 // Corner
input int CornerX = 5;                                               // Panel X
input int CornerY = 5;                                               // Panel Y
input int XBSize = 50;                                               // Time-Frame Buttons X Size
input int YBSize = 18;                                               // Time-Frame Buttons Y Size
input int FontSize = 10;                                             // Font Size
input color SelColor = clrPink;                                      // Selection Color

ENUM_ANCHOR_POINT PanelAnchor = ANCHOR_LEFT_LOWER;
ENUM_TIMEFRAMES TimeFrame[9];
double Highs[], Lows[], HLV[];
datetime newtime;
int x = 5, y = 15, XX = 250, YY = 100, dx = 3, dy = 3, ycor = 0, Xoff, Yoff, DX1 = 120, DY = 18, DX2 = 55;
string OBJName = "";
color BGColor, TextSel, TextUn;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   BGColor = (color) ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND, 0);
   if(BCorner == CORNER_RIGHT_LOWER)
     {
      PanelAnchor = ANCHOR_RIGHT_LOWER;
      Xoff = CornerX;
      Yoff = CornerY;
     }
   else
      if(BCorner == CORNER_RIGHT_UPPER)
        {
         PanelAnchor = ANCHOR_RIGHT_UPPER;
         Xoff = CornerX;
         Yoff = CornerY;
        }
      else
         if(BCorner == CORNER_LEFT_LOWER)
           {
            PanelAnchor = ANCHOR_LEFT_LOWER;
            Xoff = CornerX;
            Yoff = CornerY;
           }
         else
            if(BCorner == CORNER_LEFT_UPPER)
              {
               PanelAnchor = ANCHOR_LEFT_UPPER;
               Xoff = CornerX;
               Yoff = CornerY;
              }

   TimeFrame[0] = PERIOD_M1;
   TimeFrame[1] = PERIOD_M5;
   TimeFrame[2] = PERIOD_M15;
   TimeFrame[3] = PERIOD_M30;
   TimeFrame[4] = PERIOD_H1;
   TimeFrame[5] = PERIOD_H4;
   TimeFrame[6] = PERIOD_D1;
   TimeFrame[7] = PERIOD_W1;
   TimeFrame[8] = PERIOD_MN1;

   if(!GlobalVariableCheck(Prefix + " TF"))
      GlobalVariableSet(Prefix + " TF", (double) TF);
   if(ObjectFind(0, Prefix + "Bizgul")<0 || Period() != GlobalVariableGet(Prefix + " Period"))
      Graphical();

   SetIndexBuffer(0, Highs, INDICATOR_DATA);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexEmptyValue(0, 0.0);

   SetIndexBuffer(1, Lows, INDICATOR_DATA);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexEmptyValue(1, 0.0);

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
   if(GlobalVariableGet(Prefix + " TF") < Period())
      return(rates_total);
   if(newtime == iTime(Symbol(), Period(), 0))
      return(rates_total);

   FillData();
   return(rates_total);
  }
//+------------------------------------------------------------------+
void FillData()
  {
   ArrayResize(HLV, Bars, 0);
   ArrayInitialize(HLV, 0.0);

   for(int i= Bars-2; i>=0; i--)
     {
      int z = (Period() == GlobalVariableGet(Prefix + " TF"))?i:myiBarShift(i);
      HLV[i] = HLV[i+1];
      double H = iMA(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"), Per, 0, myMode, PRICE_HIGH, z);
      double L = iMA(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"), Per, 0, myMode, PRICE_LOW, z);

      if(iClose(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"), z) > H)
        {
         HLV[i] = 1;
         Highs[i] = H;
         Lows[i] = L;
        }
      else
        {
         HLV[i] = -11;
         Highs[i] = L;
         Lows[i] = H;
        }
     }
  }
//+------------------------------------------------------------------+
int myiBarShift(int i)
  {
   int ret = iBarShift(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"), iTime(Symbol(), Period(), i), false)-1;

   if(ret<0)
      ret=0;
   if(ret>iBars(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF")))
      ret = iBars(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"));

   for(int j=ret; j<iBars(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF")); j++)
      if(iTime(Symbol(), (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF"), j) < iTime(Symbol(), Period(), i))
         return((j-1>=0)?j-1:0);

   return(-1);
  }
//+------------------------------------------------------------------+
void Graphical()
  {
   GlobalVariableSet(Prefix + " Period", (double) Period());
   TF = (ENUM_TIMEFRAMES) GlobalVariableGet(Prefix + " TF");
   XX = DX1 + DX2 + dx * 3;
   YY = (DY + dy) * 10 + dy;
   BGColor = (color) ChartGetInteger(ChartID(), CHART_COLOR_BACKGROUND, 0);

   int Xstart=15, Ystart=10, Xsize = 0, Ysize = 18;
   string BGString = "", S[3];
   BGString = ColorToString(BGColor, false);

   ushort sep = StringGetCharacter(",",0);
   StringSplit(BGString, sep, S);

   double ColorAVG = (StringToInteger(S[0]) + StringToInteger(S[1]) + StringToInteger(S[2]))/3.0;

   TextSel = BGColor;

   int Xset = 0, Yset = 0, counter = 1;
   Xoff += (XBSize) * ((PanelAnchor == ANCHOR_LEFT_UPPER ||  PanelAnchor == ANCHOR_LEFT_LOWER)?0:+1);
   Yoff += (PanelAnchor == ANCHOR_LEFT_UPPER ||  PanelAnchor == ANCHOR_RIGHT_UPPER)?9:(YBSize + dy)+7;

   for(int i=0; i<=8; i++)
     {
      OBJName = Prefix + TimeString(TimeFrame[i]) + " Button";
      ObjectDelete(0, OBJName);

      if(TimeFrame[i] < Period())
         continue;

      ObjectCreate(ChartID(), OBJName, OBJ_EDIT, 0, 0, 0);
      OBJSet(OBJName, TimeString(TimeFrame[i]), Xoff, Yoff, XBSize, YBSize, FontSize, (TF == TimeFrame[i])?SelColor:BGColor,
             clrGray, (TF == TimeFrame[i])?TextSel:TextUn, ALIGN_CENTER, "Arial", ANCHOR_LEFT_UPPER, BCorner);
      ObjectSetInteger(0, OBJName, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);

      Yoff += (YBSize + dy);
      counter++;
     }

   ChartRedraw();

   return;
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(StringFind(sparam, " Button", 0) >=0 && StringFind(sparam, Prefix, 0) >=0)
        {
         if(ObjectGetInteger(0, sparam, OBJPROP_BGCOLOR) == BGColor)
           {
            ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, SelColor);
            ObjectSetInteger(0, sparam, OBJPROP_COLOR, TextSel);
            int z=0;
            for(int i=0; i<=8; i++)
               if(Prefix + TimeString(TimeFrame[i]) + " Button" != sparam)
                 {
                  ObjectSetInteger(0, Prefix + TimeString(TimeFrame[i]) + " Button", OBJPROP_BGCOLOR, BGColor);
                  ObjectSetInteger(0, Prefix + TimeString(TimeFrame[i]) + " Button", OBJPROP_COLOR, TextUn);
                 }
               else
                  z = i;

            TF = TimeFrame[z];
            GlobalVariableSet(Prefix + " TF", (double) TF);
            newtime = 0;
            FillData();
            ChartRedraw();
           }
        }
     }

   return;
  }
//+------------------------------------------------------------------+
string TimeString(ENUM_TIMEFRAMES i)
  {
   if(i == PERIOD_M1)
      return("M1");
   if(i == PERIOD_M5)
      return("M5");
   if(i == PERIOD_M15)
      return("M15");
   if(i == PERIOD_M30)
      return("M30");
   if(i == PERIOD_H1)
      return("H1");
   if(i == PERIOD_H4)
      return("H4");
   if(i == PERIOD_D1)
      return("D1");
   if(i == PERIOD_W1)
      return("W1");
   if(i == PERIOD_MN1)
      return("MN");
   return("");
  }
//+------------------------------------------------------------------+
void OBJSet(string OBJNameSet, string txt, int XDis, int YDis, int XSize, int YSize2, int FSize, color Fill, color Border, color TColor, ENUM_ALIGN_MODE myAlign, string myFont, ENUM_ANCHOR_POINT myAnchor, ENUM_BASE_CORNER myCorner)
  {
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_CORNER, myCorner);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_ANCHOR, myAnchor);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_XDISTANCE, XDis);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_YDISTANCE, YDis);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_XSIZE, XSize);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_YSIZE, YSize2);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_FONTSIZE, FSize);
   ObjectSetString(ChartID(),  OBJNameSet, OBJPROP_TEXT,txt);
   ObjectSetString(ChartID(),  OBJNameSet, OBJPROP_FONT,myFont);

   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_BGCOLOR, Fill);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_BORDER_COLOR, Border);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_COLOR, TColor);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_ALIGN, myAlign);

   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_BACK, false);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_ZORDER,5);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_HIDDEN, true);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_READONLY, true);
   ObjectSetInteger(ChartID(), OBJNameSet, OBJPROP_SELECTABLE, false);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(reason == 1)
     {
      ObjectsDeleteAll(ChartID(), Prefix, 0, -1);
      GlobalVariablesDeleteAll(Prefix);
     }

   return;
  }
//+------------------------------------------------------------------+
