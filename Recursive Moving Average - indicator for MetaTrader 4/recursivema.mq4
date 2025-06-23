//+------------------------------------------------------------------+
//|                                                  RecursiveMA.mq4 |
//|                                                         Galafron |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   ""
#property link        "http://www.mql5.com"
#property version     "1.00"
#property description "Recursive Moving Average unlimited"
#property strict
//+------------------------------------------------------------------+
//| properties                                                       |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_type1   DRAW_LINE
#property indicator_color1  HotPink
#property indicator_width1  1
#property indicator_label1  "Recursive MA"
#property indicator_type2   DRAW_LINE
#property indicator_color2  Yellow
#property indicator_width2  1
#property indicator_label2  "Trigger"
//+------------------------------------------------------------------+
//| input                                                            |
//+------------------------------------------------------------------+
enum  ENUM_MA_METHOD_EXT { MOD_EMA, MOD_SMMA};
input int                InpPeriodMA=2;                 // period
input int                InpIteration=20;               // number of iterations
input ENUM_MA_METHOD_EXT InpMethodMA=MOD_EMA;           // Moving average method
input bool               inpDisplaySignal;              // display arrow
//+------------------------------------------------------------------+
//| globals                                                          |
//+------------------------------------------------------------------+
double                  XemaBuffer[], TriggerBuffer[];
double                  Ema[];
int saveprev=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
   ObjectsDeleteAll(0,MQLInfoString(MQL_PROGRAM_NAME),0);

   SetIndexBuffer(0,XemaBuffer);
   SetIndexBuffer(1,TriggerBuffer);

   SetIndexDrawBegin(0,InpPeriodMA);
   SetIndexDrawBegin(1,InpPeriodMA);

   IndicatorShortName("Recursive MA");

   SetIndexLabel(0,"Recursive MA");
   SetIndexLabel(1,"Trigger ");

   ArrayResize(Ema,InpIteration);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,MQLInfoString(MQL_PROGRAM_NAME),0);
//--- The first way to get a deinitialization reason code
   Print(__FUNCTION__," Deinitialization reason code = ",reason);
//--- The second way to get a deinitialization reason code
   Print(__FUNCTION__," _UninitReason = ",getUninitReasonText(_UninitReason));
//--- The third way to get a deinitialization reason code
   Print(__FUNCTION__," UninitializeReason() = ",getUninitReasonText(UninitializeReason()));
  }
//+------------------------------------------------------------------+
//| Return a textual description of the deinitialization reason code |
//+------------------------------------------------------------------+
string getUninitReasonText(int reasonCode)
  {
   string text="";
//---
   switch(reasonCode)
     {
      case REASON_ACCOUNT:
         text="Account was changed";
         break;
      case REASON_CHARTCHANGE:
         text="Symbol or timeframe was changed";
         break;
      case REASON_CHARTCLOSE:
         text="Chart was closed";
         break;
      case REASON_PARAMETERS:
         text="Input-parameter was changed";
         break;
      case REASON_RECOMPILE:
         text="Program "+__FILE__+" was recompiled";
         break;
      case REASON_REMOVE:
         text="Program "+__FILE__+" was removed from chart";
         break;
      case REASON_TEMPLATE:
         text="New template was applied to chart";
         break;
      default:
         text="Another reason";
     }
//---
   return text;
  }//+------------------------------------------------------------------+
//| main method                                                      |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tickvolume[],
                const long &volume[],
                const int &spread[])
  {

   if(rates_total<3*InpPeriodMA-3)
      return(0);

   int limit=rates_total-prev_calculated-1;

   if(prev_calculated==0)
     {
      ArrayInitialize(XemaBuffer,0);
      ArrayInitialize(TriggerBuffer,0);
      ArrayInitialize(Ema,0);
      for(int i = 0 ; i < ArraySize(Ema) ; i++)
         Ema[i]=open[limit];
      Print(ArrayGetAsSeries(Ema)," ",ArrayGetAsSeries(open)," ",ArrayGetAsSeries(XemaBuffer));
     }

//--- filter in open prices
   if(rates_total==prev_calculated)
      return(rates_total);
//--- calculate MA

   for(int i = limit ; i >= 0; i--)
      if(i<rates_total-1)
        {
         for(int j = 0 ; j < InpIteration ; j++)
            //--- init loop sum up array
            if(j == 0)
               if(InpMethodMA == MOD_EMA)
                  Ema [0] = open [ i ]   * 2.0 / (InpPeriodMA + 1.0) + Ema [ 0 ] * (1 - 2.0 / (InpPeriodMA + 1.0)) ;
               else
                  if(InpMethodMA == MOD_SMMA)
                     Ema [0] = (open [ i ]     + Ema [ 0 ] * (MathMin(i, InpPeriodMA) - 1.0)) / MathMin(i, InpPeriodMA) ;
                  else {}
               //--- fill loop sum up array
            else
               if(InpMethodMA == MOD_EMA)
                  Ema [j] = Ema [ j - 1 ] * 2.0 / (InpPeriodMA + 1.0) + Ema [ j ] * (1 - 2.0 / (InpPeriodMA + 1.0)) ;
               else
                  Ema [j] = (Ema   [ j - 1 ] + Ema [ j ] * (MathMin(i, InpPeriodMA) - 1.0)) / MathMin(i, InpPeriodMA) ;
         XemaBuffer[i] = Ema [ InpIteration - 1 ] ;
         TriggerBuffer[i] = 0;
         for(int j = 0 ; j < InpIteration ; j++)
            TriggerBuffer[i] += (InpIteration - j) * Ema [j] / InpIteration / (InpIteration + 1.0) * 2.0;

         //--- look for signal
         if(inpDisplaySignal)
            if(TriggerBuffer[i-0] > XemaBuffer[i-0] &&
               TriggerBuffer[i+1] < XemaBuffer[i+1])
               if(!ArrowCreate(0,MQLInfoString(MQL_PROGRAM_NAME)+"_ArrowBuy_"+IntegerToString(i)+TimeToStr(time[0],TIME_DATE|TIME_MINUTES),
                               0,time[i],open[i]+SymbolInfoInteger(NULL,SYMBOL_SPREAD)*_Point,clrLime))
                 {}
               else {}
            else
               if(TriggerBuffer[i-0] < XemaBuffer[i-0] &&
                  TriggerBuffer[i+1] > XemaBuffer[i+1])
                  if(!ArrowCreate(0,MQLInfoString(MQL_PROGRAM_NAME)+"_ArrowSell_"+IntegerToString(i)+TimeToStr(time[0],TIME_DATE|TIME_MINUTES),
                                  0,time[i],open[i],clrRed))
                    {}
        }
   int i=0;
   Print(i," XemaBuffer[",i,"] ",XemaBuffer[i]," TriggerBuffer[",i,"] ",TriggerBuffer[i]);
//---filter in open price
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| display arrpow                                                   |
//+------------------------------------------------------------------+
bool ArrowCreate(const long               chart_ID=0,        // chart's ID
                 const string          name="ArrowBuy",   // sign name
                 const int             sub_window=0,      // subwindow index
                 datetime              time=0,            // anchor point time
                 double                price=0,           // anchor point price
                 const color           clr=C'3,95,172',   // sign color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style (when highlighted)
                 const int             width=3,           // line size (when highlighted)
                 const bool            back=false,        // in the background
                 const bool            selection=false,   // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the sign
   if(!ObjectCreate(chart_ID,name,(clr==clrLime ? OBJ_ARROW_BUY:OBJ_ARROW_SELL),sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Buy\" sign! Error code = ",GetLastError());
      return(false);
     }
//--- set a sign color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set a line style (when highlighted)
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set a line size (when highlighted)
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the sign by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
