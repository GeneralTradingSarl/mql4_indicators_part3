//+------------------------------------------------------------------+
//|                                               WRB-Hidden-Gap.mq4 |
//|                                     Copyright © 2010, Akif TOKUZ |
//|                                             akifusenet@gmail.com |
//| Identifies Wide Range Bars and Hidden Gaps.                      |
//| WRB and HG definitions are taken from the WRB Analysis Tutorial-1|
//| by M.A.Perry from TheStrategyLab.com                             |
//|                                                                  |
//| History:                                                         |
//| 09.04.2014: Alerts and optimization.                             |
//| 06.04.2010: Correction to make sure Hidden Gaps are not filled   |
//|             with real gaps.                                      |
//| 03.04.2010: Initial release                                      |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Akif TOKUZ and EarnForex.com"
#property link      ""
#property version "1.0"
#property strict
//----
#property description "."
#property description ""
#property description ""
#property description "Alerts and optimization by Andriy Moraru."
//----
#property indicator_chart_window
#property indicator_buffers 1
//----
#property indicator_color1 clrAqua      // WRB symbol
#property indicator_width1 1
//----
#define UNFILLED_PREFIX "HG_UNFILLED_"
#define FILLED_PREFIX "HG_FILLED_"
#define PREFIX "HG_"
//----
extern bool UseWholeBars=false;
extern int WRB_LookBackBarCount= 3;
extern int WRB_WingDingsSymbol = 115;
extern color HGcolor1 = clrDodgerBlue;
extern color HGcolor2 = clrBlue;
extern ENUM_LINE_STYLE HGstyle=STYLE_SOLID;
extern int StartCalculationFromBar=100;
extern bool HollowBoxes=false;
extern bool DoAlerts=false;
//---- buffers
double WRB[];
//----
int totalBarCount=-1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(1);
   IndicatorShortName("WRB+HG");
//----
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,WRB_WingDingsSymbol);
   SetIndexLabel(0,"WRB");
   SetIndexBuffer(0,WRB);
   ArrayInitialize(WRB,EMPTY_VALUE);
   return(0);
  }
//+------------------------------------------------------------------+
//| Delete all objects with given prefix                             |
//+------------------------------------------------------------------+
void ObDeleteObjectsByPrefix(string Prefix)
  {
   int L = StringLen(Prefix);
   int i = 0;
   while(i<ObjectsTotal())
     {
      string ObjName=ObjectName(i);
      if(StringSubstr(ObjName,0,L)!=Prefix)
        {
         i++;
         continue;
        }
      ObjectDelete(ObjName);
     }
  }
//+------------------------------------------------------------------+
//|  intersect: Check two bars intersect or not                      |
//+------------------------------------------------------------------+
int intersect(double H1,double L1,double H2,double L2)
  {
   if( (L1>H2) || (H1<L2) ) return (0);
   if( (H1>=H2) && (L1>=L2) ) return (1);
   if( (H1<=H2) && (L1<=L2) ) return (2);
   if( (H1>=H2) && (L1<=L2) ) return (3);
   if( (H1<=H2) && (L1>=L2) ) return (4);
   return(0);
  }
//+------------------------------------------------------------------+
//|  checkHGFilled: Check if the hidden gap is filled or not         |
//+------------------------------------------------------------------+
void checkHGFilled(int barNumber)
  {
   int j,i;
   string ObjectText;
   string Prefix=UNFILLED_PREFIX;
   double box_H,box_L;
   double HGFillPA_H,HGFillPA_L;
   datetime startTime;
   color objectColor;
//----
   int L=StringLen(Prefix);
   i=0;
   while(i<ObjectsTotal()) // loop over all unfilled boxes
     {
      string ObjName=ObjectName(i);
      if(StringSubstr(ObjName,0,L)!=Prefix)
        {
         i++;
         continue;
        }
      box_H=ObjectGet(ObjName,OBJPROP_PRICE1); // get HG high and low values
      box_L=ObjectGet(ObjName, OBJPROP_PRICE2);
      objectColor=(color)ObjectGet(ObjName,OBJPROP_COLOR);
      startTime=(color)ObjectGet(ObjName,OBJPROP_TIME1);
      //----
      HGFillPA_H = High[barNumber];
      HGFillPA_L = Low[barNumber];
      j=0;
      while((intersect(High[barNumber+j],Low[barNumber+j],box_H,box_L)!=0) && (barNumber+j<Bars) && (startTime<Time[barNumber+j]))
        {
         if(High[barNumber+j] > HGFillPA_H)  HGFillPA_H = High[barNumber+j];
         if(Low[barNumber+j]  < HGFillPA_L)  HGFillPA_L = Low[barNumber+j];
         if((HGFillPA_H>box_H) && (HGFillPA_L<box_L))
           {
            ObjectDelete(ObjName);

            ObjectText=FILLED_PREFIX+TimeToStr(startTime,TIME_DATE|TIME_MINUTES);
            ObjectCreate(ObjectText,OBJ_RECTANGLE,0,startTime,box_H,Time[barNumber],box_L);
            ObjectSet(ObjectText,OBJPROP_STYLE,HGstyle);
            ObjectSet(ObjectText,OBJPROP_COLOR,objectColor);
            ObjectSet(ObjectText,OBJPROP_BACK,!HollowBoxes);
            break;
           }
         j++;
        }

      i++;
     }
  }
//+------------------------------------------------------------------+
//| checkWRB: Check if the given bar is a WRB or not                 |
//| The lookback period can be changed by user input                 |
//+------------------------------------------------------------------+
bool checkWRB(int i)
  {
   int j;
   bool WRB_test;
   double body,bodyPrior;
//----
   WRB_test=true;
   if(UseWholeBars) body=High[i]-Low[i];
   else body=MathAbs(Open[i]-Close[i]);
   for(j=1;j<=WRB_LookBackBarCount; j++)
     {
      if(UseWholeBars) bodyPrior=High[i+j]-Low[i+j];
      else bodyPrior=MathAbs(Open[i+j]-Close[i+j]);
      if(bodyPrior>body)
        {
         WRB_test=false;
         break;
        }
     }
//----
   if(WRB_test)
     {
      if(UseWholeBars) WRB[i]=(High[i]+Low[i])/2;
      else WRB[i]=(Open[i]+Close[i])/2;
     }
   else WRB[i]=EMPTY_VALUE;
//----
   return(WRB_test);
  }
//+------------------------------------------------------------------+
//| checkHG: Checks HG status of the previous bar.                   |
//+------------------------------------------------------------------+
void checkHG(int i)
  {
   string ObjectText;
   double H,L,H2,L2,H1,L1,A,B;
   int j;
   color HGcolor=HGcolor1;
//---- HG-TEST ( test the previous bar i+1)
   if(WRB[i+1]!=EMPTY_VALUE) // First rule to become a HG is to become a WRB
     {
      H2 = High[i+2];
      L2 = Low[i+2];
      H1 = High[i];
      L1 = Low[i];
      //----
      if(UseWholeBars)
        {
         H = High[i + 1];
         L = Low[i + 1];
        }
      else if(Open[i+1]>Close[i+1])
        {
         H = Open[i+1];
         L = Close[i+1];
        }
      else
        {
         H = Close[i+1];
         L = Open[i+1];
        }
      //---- Older bar higher than the newer.
      if(L2>H1)
        {
         A = MathMin(L2, H);
         B = MathMax(H1, L);
        }
      else if(L1>H2)
        {
         A = MathMin(L1, H);
         B = MathMax(H2, L);
        }
      else return;
      //----
      if(A>B)
        {
         int Length=StringLen(UNFILLED_PREFIX);
         j=0;
         while(j<ObjectsTotal()) // loop over all unfilled boxes
           {
            ObjectText=ObjectName(j);
            if(StringSubstr(ObjectText,0,Length)!=UNFILLED_PREFIX)
              {
               j++;
               continue;
              }
            //---- Switch colors if the new Hidden Gap is intersecting with previous Hidden Gap.
            if(intersect(ObjectGet(ObjectText,OBJPROP_PRICE1),ObjectGet(ObjectText,OBJPROP_PRICE2),A,B)!=0)
              {
               HGcolor=(color)ObjectGet(ObjectText,OBJPROP_COLOR);
               if(HGcolor==HGcolor1) HGcolor=HGcolor2;
               else HGcolor=HGcolor1;
               break;
              }
            j++;
           }
         //----
         ObjectText=UNFILLED_PREFIX+TimeToStr(Time[i+1],TIME_DATE|TIME_MINUTES);
         ObjectCreate(ObjectText,OBJ_RECTANGLE,0,Time[i+1],A,TimeCurrent()+10*365*24*60*60,B);
         ObjectSet(ObjectText,OBJPROP_STYLE,HGstyle);
         ObjectSet(ObjectText,OBJPROP_COLOR,HGcolor);
         ObjectSet(ObjectText,OBJPROP_BACK,!HollowBoxes);
        }
     } //End of HG-Test
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObDeleteObjectsByPrefix(PREFIX);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   if(DoAlerts) CheckAlert();
//---- A new bar started.
   if(totalBarCount!=Bars)
     {
      int begin=Bars-IndicatorCounted();
      //---- Need at least WRB_LookBackBarCount bars from the end of the chart to work.
      if(begin>Bars-WRB_LookBackBarCount) begin=Bars-WRB_LookBackBarCount;
      //---- Maximum number of bars to calculate is StartCalculationFromBar.
      if(begin>StartCalculationFromBar) begin=StartCalculationFromBar;
      //----
      for(int i=begin; i>0; i--)
        {
         checkWRB(i);
         checkHG(i);
         checkHGFilled(i);
        }
      totalBarCount=Bars;
     }
//---- Additional check to see if current bar made the Hidden Gap filled.
   checkHGFilled(0);
   WRB[0]=EMPTY_VALUE;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckAlert()
  {
   int total=ObjectsTotal();
//---- Loop over all unfilled boxes.
   for(int j=0; j<total; j++)
     {
      string ObjectText=ObjectName(j);
      //---- Object marked as alerted.
      if(StringSubstr(ObjectText,StringLen(ObjectText)-1,1)=="A")
        {
         //---- Try to find a dupe object (could be result of a bug) and delete it.
         string ObjectNameWithoutA=StringSubstr(ObjectText,0,StringLen(ObjectText)-1);
         if(ObjectFind(ObjectNameWithoutA)>=0) ObjectDelete(ObjectNameWithoutA);
         continue;
        }
      int Length=StringLen(UNFILLED_PREFIX);
      if(StringSubstr(ObjectText,0,Length)!=UNFILLED_PREFIX) continue;
      //----
      double Price1 = ObjectGet(ObjectText, OBJPROP_PRICE1);
      double Price2 = ObjectGet(ObjectText, OBJPROP_PRICE2);
      double bHigh= MathMax(Price1,Price2);
      double bLow = MathMin(Price1,Price2);
      //---- Current price above lower border
      if((Ask>bLow) && (Bid<bHigh))
        {
         Alert(Symbol()+": "+"WRB rectangle breached.");
         PlaySound("alert.wav");
         ObjectSetString(0,ObjectText,OBJPROP_NAME,ObjectText+"A");
         return;
        }
     }
  }
//+------------------------------------------------------------------+
