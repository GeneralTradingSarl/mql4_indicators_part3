//+------------------------------------------------------------------+
//|                                     ind_DivPeakTroughOsMA_v1.mq4 |
//|                                                                * |
//|                                                                * |
//+------------------------------------------------------------------+
#property copyright "*"
#property link      "*"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Orange
#property indicator_color2 Silver
#property indicator_color3 SlateGray
#property indicator_width2 1
#property indicator_width3 1
//---- input parameters

extern int RSIPeriod=14;
extern int RSIPrice=0; // 0-Close, 1-Open, 2-High, 3-Low, 4-Median, 5-Typical, 6-Weighted
extern int ExtrLeftBars=2; // баров слева от экстремума
extern int ExtrRightBars=1; // баров справа от экстремума
extern double PlusSens=1;
extern double MinusSens=-1;
extern bool DrawLinesSW=true;
extern bool DrawLinesChW=true;
extern color Col_Peak_1=Red;
extern color Col_Peak_2=DeepPink;
extern color Col_Trough_1=LimeGreen;
extern color Col_Trough_2=YellowGreen;
extern string ShortName="DPTRSI";

//---- buffers
double osma[];
double Sig1[];
double Sig2[];
double peack_1_i[];
double peack_2_i[];
double trogh_1_i[];
double trogh_2_i[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(7);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,osma);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,Sig1);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,159);
   SetIndexBuffer(2,Sig2);

   SetIndexBuffer(3,peack_1_i);
   SetIndexBuffer(4,peack_2_i);
   SetIndexBuffer(5,trogh_1_i);
   SetIndexBuffer(6,trogh_2_i);

   IndicatorShortName(ShortName);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if(DrawLinesSW || DrawLinesChW)fObjDeleteByPrefix(ShortName);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+MathMax(ExtrLeftBars,ExtrRightBars);

   for(int i=limit-1;i>=0;i--)
     {
      osma[i]=iRSI(NULL,0,RSIPeriod,RSIPrice,i)-50;
      int extri=i+ExtrRightBars;

      Sig1[i]=EMPTY_VALUE;
      Sig2[i]=EMPTY_VALUE;

      peack_1_i[i]=peack_1_i[i+1];
      peack_2_i[i]=peack_2_i[i+1];
      trogh_1_i[i]=trogh_1_i[i+1];
      trogh_2_i[i]=trogh_2_i[i+1];

      bool PeackNow=false;
      bool TroghNow=false;

      double extrv=osma[extri];

      if(extrv>PlusSens)
        {
         for(int j=i;j<extri;j++)
           {
            if(extrv<=osma[j])
              {
               break;
              }
           }
         if(j==extri)
           {
            int extril=extri+ExtrLeftBars;
            for(j=extril;j>extri;j--)
              {
               if(extrv<=osma[j])
                 {
                  break;
                 }
              }
            if(j==extri)
              {
               PeackNow=true;
               if(peack_1_i[i]==EMPTY_VALUE)
                 {
                  peack_1_i[i]=Time[extri];
                 }
               else
                 {
                  if(osma[extri]>osma[iBarShift(NULL,0,peack_1_i[i],false)])
                    {
                     peack_1_i[i]=Time[extri];
                    }
                 }
              }
           }
        }
      if(extrv<MinusSens)
        {
         for(j=i;j<extri;j++)
           {
            if(extrv>=osma[j])
              {
               break;
              }
           }
         if(j==extri)
           {
            extril=extri+ExtrLeftBars;
            for(j=extril;j>extri;j--)
              {
               if(extrv>=osma[j])
                 {
                  break;
                 }
              }
            if(j==extri)
              {
               TroghNow=true;
               if(trogh_1_i[i]==EMPTY_VALUE)
                 {
                  trogh_1_i[i]=Time[extri];
                 }
               else
                 {
                  if(osma[extri]<osma[iBarShift(NULL,0,trogh_1_i[i],false)])
                    {
                     trogh_1_i[i]=Time[extri];
                    }
                 }
              }
           }
        }

      if(osma[i]>0 && osma[i+1]<=0)
        {
         peack_2_i[i]=peack_1_i[i];
         peack_1_i[i]=EMPTY_VALUE;
        }

      if(osma[i]<0 && osma[i+1]>=0)
        {
         trogh_2_i[i]=trogh_1_i[i];
         trogh_1_i[i]=EMPTY_VALUE;
        }

      string ObjName1=ShortName+"_PeakIW_"+Time[extri];
      string ObjName2=ShortName+"_PeakPW_"+Time[extri];
      ObjectDelete(ObjName1);
      ObjectDelete(ObjName2);

      if(PeackNow)
        {
         if(peack_1_i[i]!=EMPTY_VALUE)
           {
            if(peack_2_i[i]!=EMPTY_VALUE)
              {
               if(osma[extri]>=osma[iBarShift(NULL,0,peack_1_i[i],false)])
                 {
                  int z2=iBarShift(NULL,0,peack_2_i[i],false);
                  int z1=extri;
                  if(osma[z2]<osma[z1] && High[z2]>High[z1])
                    {
                     Sig1[i]=osma[i]+Point/4;
                     if(DrawLinesSW)fObjTrendLine(ObjName1,peack_2_i[i],osma[z2],Time[extri],osma[z1],false,Col_Peak_1,1,WindowFind(ShortName),0,true);
                     if(DrawLinesChW)fObjTrendLine(ObjName2,peack_2_i[i],High[z2],Time[extri],High[z1],false,Col_Peak_1,1,0,0,false);
                    }
                  if(osma[z2]>osma[z1] && High[z2]<High[z1])
                    {
                     Sig2[i]=osma[i]+Point/4;
                     if(DrawLinesSW)fObjTrendLine(ObjName1,peack_2_i[i],osma[z2],Time[extri],osma[z1],false,Col_Peak_2,1,WindowFind(ShortName),0,true);
                     if(DrawLinesChW)fObjTrendLine(ObjName2,peack_2_i[i],High[z2],Time[extri],High[z1],false,Col_Peak_2,1,0,0,false);
                    }
                 }
              }
           }
        }

      ObjName1=ShortName+"_TroghIW_"+Time[extri];
      ObjName2=ShortName+"_TroghPW_"+Time[extri];
      ObjectDelete(ObjName1);
      ObjectDelete(ObjName2);

      if(TroghNow)
        {
         if(trogh_1_i[i]!=EMPTY_VALUE)
           {
            if(trogh_2_i[i]!=EMPTY_VALUE)
              {
               if(osma[extri]<=osma[iBarShift(NULL,0,trogh_1_i[i],false)])
                 {
                  z2=iBarShift(NULL,0,trogh_2_i[i],false);
                  z1=extri;
                  if(osma[z2]>osma[z1] && Low[z2]<Low[z1])
                    {
                     Sig1[i]=osma[i]-Point/4;
                     if(DrawLinesSW)fObjTrendLine(ObjName1,trogh_2_i[i],osma[z2],Time[extri],osma[z1],false,Col_Trough_1,1,WindowFind(ShortName),0,true);
                     if(DrawLinesChW)fObjTrendLine(ObjName2,trogh_2_i[i],Low[z2],Time[extri],Low[z1],false,Col_Trough_1,1,0,0,false);
                    }
                  if(osma[z2]<osma[z1] && Low[z2]>Low[z1])
                    {
                     Sig2[i]=osma[i]-Point/4;
                     if(DrawLinesSW)fObjTrendLine(ObjName1,trogh_2_i[i],osma[z2],Time[extri],osma[z1],false,Col_Trough_2,1,WindowFind(ShortName),0,true);
                     if(DrawLinesChW)fObjTrendLine(ObjName2,trogh_2_i[i],Low[z2],Time[extri],Low[z1],false,Col_Trough_2,1,0,0,false);
                    }
                 }
              }
           }
        }


     }

   return(0);
  }
//+------------------------------------------------------------------+

void fObjTrendLine(
                   string aObjectName,  // 1 имя
                   datetime aTime_1,    // 2 время 1
                   double aPrice_1,     // 3 цена 1
                   datetime aTime_2,    // 4 время 2
                   double aPrice_2,     // 5 цена 2
                   bool aRay=false,     // 6 луч
                   color aColor=Red,    // 7 цвет
                   int aWidth=1,        // 8 толщина
                   int aWindowNumber=0, // 9 окно
                   int aStyle=0,        // 10 0-STYLE_SOLID, 1-STYLE_DASH, 2-STYLE_DOT, 3-STYLE_DASHDOT, 4-STYLE_DASHDOTDOT
                   bool aBack=false     // 11 фон
                   )
  {
   if(ObjectFind(aObjectName)!=aWindowNumber)
     {
      ObjectCreate(aObjectName,OBJ_TREND,aWindowNumber,aTime_1,aPrice_1,aTime_2,aPrice_2);
     }
   ObjectSet(aObjectName,OBJPROP_TIME1,aTime_1);
   ObjectSet(aObjectName,OBJPROP_PRICE1,aPrice_1);
   ObjectSet(aObjectName,OBJPROP_TIME2,aTime_2);
   ObjectSet(aObjectName,OBJPROP_PRICE2,aPrice_2);
   ObjectSet(aObjectName,OBJPROP_RAY,aRay);
   ObjectSet(aObjectName,OBJPROP_COLOR,aColor);
   ObjectSet(aObjectName,OBJPROP_WIDTH,aWidth);
   ObjectSet(aObjectName,OBJPROP_BACK,aBack);
   ObjectSet(aObjectName,OBJPROP_STYLE,aStyle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fObjDeleteByPrefix(string aPrefix)
  {

//fObjDeleteByPrefix("");

   for(int i=ObjectsTotal()-1;i>=0;i--)
     {
      if(StringFind(ObjectName(i),aPrefix,0)==0)
        {
         ObjectDelete(ObjectName(i));
        }
     }
  }
//+------------------------------------------------------------------+
