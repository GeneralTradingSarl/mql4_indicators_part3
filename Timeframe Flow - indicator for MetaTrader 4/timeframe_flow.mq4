//+------------------------------------------------------------------+
//|                                               Timeframe Flow.mq4 |
//|                                                           Jas Wu |
//|                                                                  |
//+------------------------------------------------------------------+
#property description "Timeframe Flow"
#property description "By Jas Wu"
#property version   "1.01"
#property strict
#property indicator_separate_window
#property indicator_buffers 16
#property indicator_plots   8

#property indicator_label1  "FlatBody"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrGray
#property indicator_width1  8

#property indicator_label2  "BullBody"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrLime
#property indicator_width2  8

#property indicator_label3  "BearBody"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrWheat
#property indicator_width3  8

#property indicator_label4  "BodyOpenForAll"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrBlack
#property indicator_width4  8

#property indicator_label5  "FlatWick"
#property indicator_type5   DRAW_HISTOGRAM
#property indicator_color5  clrGray
#property indicator_width5  2

#property indicator_label6  "BullWick"
#property indicator_type6   DRAW_HISTOGRAM
#property indicator_color6  clrLime
#property indicator_width6  2

#property indicator_label7  "BearWick"
#property indicator_type7   DRAW_HISTOGRAM
#property indicator_color7  clrWheat
#property indicator_width7  2

#property indicator_label8  "LowWick"
#property indicator_type8   DRAW_HISTOGRAM
#property indicator_color8  clrBlack
#property indicator_width8  2

extern string NNN = "--------Input Any Number below to micmic Higher Timeframe-------"; //-
extern int Timeframez = 2; //23 = 24x Current, 2=3x Current, 5=6x Current, 11=12x Current
extern int MAP = 8; //MidLine Period
extern int Shift = 0; //MidLine Shift
input  ENUM_MA_METHOD MaMethod = MODE_EMA; //MA Matheod
extern string FFF = "--------------ATR Bands Settings-------------"; //-
extern int ATRP = 100;// ATR Band Period
extern double ATRM = 1.0; //ATR Band Multiplier
color HLC = clrDodgerBlue; //high low Color Buffer
int HLCOff = 500; //high low Arrow Offset
color Ran = clrRed; //Both Side Equal Color
int RanOff = 750; //Both Side Equal Offset
color IIII = clrOrange; //Higher high or Lower low Color
int IIIOff = 300; //Higher high or Lower low Offset
extern string DDDD = "-----------Color Settings-------------"; //-
extern color UpperBand = clrMediumBlue; //Uppder Band Breakout Arrow Color
extern color LowerBand = clrRed; //Lower Band Breakout Arrow Color
extern color UpMid = clrGreen; //Price Cross MidLine Upward Arrow Color
extern color DnMid = clrRed; //Price Cross MidLine Downward Arrow Color
extern color ATRBColor = clrDeepPink; //ATR Band's Color
extern color MidLColor = clrDodgerBlue; //Mid Line Color

int barstocursor=0;
string UprDown = "";

double LLHH[], HHLL[], Range[], HighWick[], HL_Same[], FlatBody[], BullBody[], BearBody[], BodyOpen[], FlatWick[], BullWick[], BearWick[], LowWick[], StoreClose[], Baseline[], DownCross[], UpCross[], ATRUP[], ATRDN[], ATR_UCross[], ATR_DCross[], DualPierce[];
int mamethod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
   IndicatorShortName("Timeframe Flow "+" = Current Timeframe "+IntegerToString(_Period)+" Multiplies by "+IntegerToString((Timeframez+1))+"  ");
   IndicatorBuffers(16);
   IndicatorDigits(6);

// body
   SetIndexBuffer(0,FlatBody);
   SetIndexLabel(0, NULL);
   SetIndexBuffer(1,BullBody);
   SetIndexLabel(1, NULL);
   SetIndexBuffer(2,BearBody);
   SetIndexLabel(2, NULL);
   SetIndexBuffer(3,BodyOpen);
   SetIndexLabel(3, NULL);
// wick
   SetIndexBuffer(4,FlatWick);
   SetIndexLabel(4, NULL);
   SetIndexBuffer(5,BullWick);
   SetIndexLabel(5, NULL);
   SetIndexBuffer(6,BearWick);
   SetIndexLabel(6, NULL);
   SetIndexBuffer(7,LowWick);
   SetIndexLabel(7, NULL);

   SetIndexStyle(8,DRAW_NONE, STYLE_SOLID, 1, clrSpringGreen);
   SetIndexBuffer(8,StoreClose);
   SetIndexLabel(8, NULL); //(close + open) * 0.5

   SetIndexStyle(9,DRAW_LINE, STYLE_SOLID, 1, MidLColor);
   SetIndexBuffer(9,Baseline);
   SetIndexLabel(9, "MidLine");

   SetIndexBuffer(10,DownCross);
   SetIndexStyle(10,DRAW_ARROW, STYLE_SOLID, 1, DnMid);
   SetIndexArrow(10, 110);
   SetIndexLabel(10, NULL);

   SetIndexBuffer(11,UpCross);
   SetIndexStyle(11,DRAW_ARROW, STYLE_SOLID, 1, UpMid);
   SetIndexArrow(11, 110);
   SetIndexLabel(11, NULL);

   SetIndexStyle(12,DRAW_LINE, STYLE_SOLID, 1, ATRBColor);
   SetIndexBuffer(12,ATRUP);
   SetIndexLabel(12, "ATR_UpBand");

   SetIndexStyle(13,DRAW_LINE, STYLE_SOLID, 1, ATRBColor);
   SetIndexBuffer(13,ATRDN);
   SetIndexLabel(13, "ATR_DnBand");

   SetIndexBuffer(14,ATR_UCross);
   SetIndexStyle(14,DRAW_ARROW, STYLE_SOLID, 2, UpperBand);
   SetIndexArrow(14, 162);
   SetIndexLabel(14, NULL);

   SetIndexBuffer(15,ATR_DCross);
   SetIndexStyle(15,DRAW_ARROW, STYLE_SOLID, 2, LowerBand);
   SetIndexArrow(15, 162);
   SetIndexLabel(15, NULL);

//---
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
//---
   int ExtCountedBars=IndicatorCounted();
   if(ExtCountedBars<0)
      return(-1);
   int pos;
   int limit=Bars-Timeframez-2;
   if(ExtCountedBars>2)
      limit=Bars-ExtCountedBars-1;
   pos=limit;

   for(int t=0; t<=limit; t++)//Main Loop for drawing Timeframe Flow Candles
     {
      if(close[t] > open[t+Timeframez])
        {
         BullBody[t] = close[t];
         BodyOpen[t] = open[t+Timeframez];
         BullWick[t] = high[iHighest(NULL, 0, MODE_HIGH, 1+Timeframez, t)];
         LowWick[t] = low[iLowest(NULL, 0, MODE_LOW, 1+Timeframez, t)];
         StoreClose[t] = (close[t]+open[t+Timeframez])*0.5;
         BearBody[t] = EMPTY_VALUE;
         BearWick[t] = EMPTY_VALUE;
         FlatBody[t] = EMPTY_VALUE;
         FlatWick[t] = EMPTY_VALUE;
        }

      if(close[t] < open[t+Timeframez])
        {
         BearBody[t] = open[t+Timeframez];
         BodyOpen[t] = close[t];
         BearWick[t] = high[iHighest(NULL, 0, MODE_HIGH, 1+Timeframez, t)];
         LowWick[t] = low[iLowest(NULL, 0, MODE_LOW, 1+Timeframez, t)];
         StoreClose[t] = (close[t]+open[t+Timeframez])*0.5;
         BullBody[t] = EMPTY_VALUE;
         BullWick[t] = EMPTY_VALUE;
         FlatBody[t] = EMPTY_VALUE;
         FlatWick[t] = EMPTY_VALUE;
        }

      if(close[t] == open[t+Timeframez])
        {
         FlatBody[t] = close[t];
         BodyOpen[t] = close[t];
         FlatWick[t] = high[iHighest(NULL, 0, MODE_HIGH, 1+Timeframez, t)];
         LowWick[t] = low[iLowest(NULL, 0, MODE_LOW, 1+Timeframez, t)];
         StoreClose[t] = close[t];
         BearBody[t] = EMPTY_VALUE;
         BearWick[t] = EMPTY_VALUE;
         BullBody[t] = EMPTY_VALUE;
         BullWick[t] = EMPTY_VALUE;
        }

     }

//Draw Midline(Moving Average) based on Timeframe Flow Candles-------------------
   for(int t=0; t<=limit; t++)
     {
      Baseline[t] = iMAOnArray(StoreClose, 0, MAP, Shift, mamethod, t);
     }

//Arrows for MidLine Crosses-------------------------------------------
   for(int t=0; t<=limit; t++)
     {
      if(close[t] > Baseline[t] && close[t+1] < Baseline[t+1])
        {
         UpCross[t] = Baseline[t];
         DownCross[t] = EMPTY_VALUE;
        }
      else
         if(close[t] < Baseline[t] && close[t+1] > Baseline[t+1])
           {
            DownCross[t] = Baseline[t];
            UpCross[t] = EMPTY_VALUE;
           }

      if(close[t] > Baseline[t])
         DownCross[t] = EMPTY_VALUE;
      if(close[t] < Baseline[t])
         UpCross[t] = EMPTY_VALUE;
     }
//Arrows for MidLine Crosses-------------------------------------------


//Constructing ATR Bands--------------------------------------------
   for(int t=0; t<=limit; t++)
     {
      ATRUP[t] = Baseline[t]+iATR(_Symbol, _Period, ATRP, t)*ATRM;
      ATRDN[t] = Baseline[t]-iATR(_Symbol, _Period, ATRP, t)*ATRM;
     }
//Constructing ATR Bands--------------------------------------------

//Arrows for Band Breakouts--------------------------------------------
   for(int t=0; t<=limit; t++)
     {

      if(BullBody[t] != EMPTY_VALUE && BearBody[t] == EMPTY_VALUE && BullBody[t] > ATRUP[t])   //Bull Candle close Above ATR Up Band--------------
        {
         ATR_UCross[t] = ATRUP[t];
         ATR_DCross[t] = EMPTY_VALUE;
        }
      else
         if(BearBody[t] != EMPTY_VALUE && BullBody[t] == EMPTY_VALUE && BodyOpen[t] > ATRUP[t])   //Bear Candle close Above ATR Up Band(Rarely Ever Happens)-----------------
           {
            ATR_UCross[t] = ATRUP[t];
            ATR_DCross[t] = EMPTY_VALUE;
           }
         else
            ATR_UCross[t] = EMPTY_VALUE;


      if(BearBody[t] != EMPTY_VALUE && BullBody[t] == EMPTY_VALUE && BodyOpen[t] < ATRDN[t])   //Bear Candle close Below ATR Down Band--------------
        {
         ATR_DCross[t] = ATRDN[t];
         ATR_UCross[t] = EMPTY_VALUE;
        }
      else
         if(BullBody[t] != EMPTY_VALUE && BearBody[t] == EMPTY_VALUE && BullBody[t] < ATRDN[t])   //Bull Candle close Below ATR Dn Band(Rarely Ever Happens)-----------------
           {
            ATR_DCross[t] = ATRDN[t];
            ATR_UCross[t] = EMPTY_VALUE;
           }
         else
            ATR_DCross[t] = EMPTY_VALUE;

     }
//Arrows for Band Breakouts--------------------------------------------


//--- return value of prev_calculated for next call
   return(rates_total);
  }