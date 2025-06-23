//+------------------------------------------------------------------+
//|                                                            Ultra |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
/*
   Ultra by rkdius [Jan 2017]
*/
#property version     "1.60"
#property strict
#property indicator_chart_window
//--- input parameters
enum mode
  {
   Standard,
   Fibonacci,
   Prime
  };
extern mode Pmode=Fibonacci;               // Mode
extern int N_Bars=48;                      // Period (No of M5 Bars)
extern int RSI=10;                         // RSI Period
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ScaleMode
  {
   smFix,// Fixed
   smATR // ATR Function
  };
input ScaleMode sc_mode=smFix;          // Scale Zero Level Mode
extern int ZeroShift=5;                    // Scale Zero Level Shift
//--- Moving Average
extern int l_MA=16;                       // MA Period
extern ENUM_MA_METHOD MAmet=MODE_EMA;      // MA Method
extern ENUM_APPLIED_PRICE MAprice=PRICE_TYPICAL; // MA Applied Price
extern ENUM_TIMEFRAMES MA_TF=PERIOD_H1;    // MA Timeframe
extern color clrLevelMA=HotPink;              // MA Color
extern ENUM_LINE_STYLE StyleMA = 0;        // MA Line Style 
extern int WidthMA = 3;                    // MA Line Width
//---             
extern double Ratio=1.0;                       // Spread/ATR % Ratio  
//---             
extern color clrLevelPP=Crimson;              // Pivot Point Color
extern ENUM_LINE_STYLE StylePP = 0;        // Line Style 
extern int WidthPP = 3;                    // Line Width
extern color clrLevel1=MediumSeaGreen;        // Level 1 Color
extern ENUM_LINE_STYLE Style1 = 0;         // Line Style
extern int Width1 = 2;                     // Line Width
extern color clrLevel2=SteelBlue;             // Level 2 Color
extern ENUM_LINE_STYLE Style2 = 0;         // Line Style
extern int Width2 = 2;                     // Line Width
extern color clrLevel3=Orange;                // Level 3 Color
extern ENUM_LINE_STYLE Style3 = 0;         // Line Style
extern int Width3 = 2;                     // Line Width
extern color clrLevel4=OrangeRed;             // Level 4 Color
extern ENUM_LINE_STYLE Style4 = 0;         // Line Style
extern int Width4 = 2;                     // Line Width
extern color clrRange=Purple;                   // ATR Range Color
extern ENUM_LINE_STYLE StyleRng = 2;       // Line Style
extern int WidthRng = 1;                   // Line Width
extern color clrAskBid=Blue;                  // Ask/Bid Color
extern color clrSpreadAlert=Red;              // Spread Alert Color
extern color clrScaleColor=Black;             // Scale Color
ENUM_LINE_STYLE StyleAskBid=0;           // Bid Line Style
//---             
input bool debugmode=false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double x,xR1,xR2,xR3,xR4,xS1,xS2,xS3,xS4,xPP,xPHi,xPLo;
double x0,x100,xRSI,RSILevel,minRSILevel,maxRSILevel;
double RSIBuffer[];
int PivotBar=0;
ENUM_TIMEFRAMES inpTimeFrame=PERIOD_M5;    // Pivot Period
ENUM_TIMEFRAMES ATRTimeFrame=PERIOD_M1;
int xShift=9;                           // X-Axis Shift
int xLen=2;                            // Line Length
double RSIindSize;
long XZoom=-1;
double pip1=1/pow(10,Digits-1);
string sMA="";
string debug_comment="";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
   SetIndexBuffer(0,RSIBuffer);
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   DrawLevel("RSI",0,0,2,0,3);
   DrawLevel("minRSI",0,0,3,0,2);
   DrawLevel("maxRSI",0,0,3,0,2);
   DrawLevel("PHi",0,StyleRng,WidthRng,clrRange,3);
   DrawLevel("L_R4",0,Style4,Width4,clrLevel4,0);
   DrawLevel("L_R3",0,Style3,Width3,clrLevel3,0);
   DrawLevel("L_R2",0,Style2,Width2,clrLevel2,0);
   DrawLevel("L_R1",0,Style1,Width1,clrLevel1,0);
   DrawLevel("L_PP",0,StylePP,WidthPP,clrLevelPP,0);
   DrawLevel("L_S1",0,Style1,Width1,clrLevel1,0);
   DrawLevel("L_S2",0,Style2,Width2,clrLevel2,0);
   DrawLevel("L_S3",0,Style3,Width3,clrLevel3,0);
   DrawLevel("L_S4",0,Style4,Width4,clrLevel4,0);
   DrawLevel("PLo",0,StyleRng,WidthRng,clrRange,3);
   DrawLevel("Ask",0,StyleAskBid,1,clrAskBid,3);
   DrawLevel("Bid",0,StyleRng,WidthRng,clrAskBid,3);
//   DrawRect("Spread",0,0,0,0,0);
   DrawRSITrail("RSITrailBack",0,0,0,0,0,false);
   DrawRSITrail("RSITrailFront",0,0,0,0,0,false);

   DrawRSITrail("RSIOver",0,0,0,5,Purple,false);
   DrawRSITrail("RSI50",0,0,0,5,Purple,false);
   DrawRSITrail("RSIMid",0,0,0,5,Purple,false);
   DrawRSITrail("RSIUnder",0,0,0,5,Purple,false);

   DrawLevel(sMA,0,0,0,0,0);
//   DrawRect("RSIBack",0,0,0,0,0);
   Scale(false,0,0);
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   debug_comment="";
   double mod=1.0;
   double priceMin=ChartGetDouble(0,CHART_PRICE_MIN,0);
   double priceMax=ChartGetDouble(0,CHART_PRICE_MAX,0);

//--- Pivot Points
   double xOpen=iOpen(NULL,inpTimeFrame,PivotBar);
   double xClose=iClose(NULL,inpTimeFrame,PivotBar);
   double xHigh=iHigh(NULL,inpTimeFrame,PivotBar);
   double xLow=iLow(NULL,inpTimeFrame,PivotBar);
   double PxPP=(xHigh+xLow+xClose)/3;
   double PxRange=xHigh-xLow;
   double div=0.0;
//+------------------------------------------------------------------+
   if(Period()<PERIOD_D1)
     {
      inpTimeFrame=PERIOD_M5;
      ATRTimeFrame=PERIOD_M1;
     }
   else
     {
      inpTimeFrame=PERIOD_H4;
      ATRTimeFrame=PERIOD_H1;
     }
//+------------------------------------------------------------------+
   for(int i=1;i<N_Bars;i++)
     {
      mod=(double)(N_Bars-i);
      mod*=(double)(iVolume(NULL,inpTimeFrame,PivotBar+i));
      xOpen+=mod*iOpen(NULL,inpTimeFrame,PivotBar+i);
      xClose+=mod*iClose(NULL,inpTimeFrame,PivotBar+i);
      xHigh+=mod*iHigh(NULL,inpTimeFrame,PivotBar+i);
      xLow+=mod*iLow(NULL,inpTimeFrame,PivotBar+i);
      div+=mod;
     }
   div+=1.0;

   debug_comment+="\nmod="+DoubleToStr(mod,Digits);
   debug_comment+="\ndiv="+DoubleToStr(div,Digits);

   xOpen/=div;
   xClose/=div;
   xHigh/=div;
   xLow/=div;

   xPP=(xHigh+xLow+xClose)/3;
/*   xPP=(iHigh(NULL,inpTimeFrame,iHighest(NULL,inpTimeFrame,MODE_HIGH,N_Bars,0))
        +iLow(NULL,inpTimeFrame,iLowest(NULL,inpTimeFrame,MODE_LOW,N_Bars,0))+xClose)/3; // */
   double xATR=iHigh(NULL,ATRTimeFrame,iHighest(NULL,ATRTimeFrame,MODE_HIGH,5*N_Bars,0))
               -iLow(NULL,ATRTimeFrame,iLowest(NULL,ATRTimeFrame,MODE_LOW,5*N_Bars,0));
   double xRange=(xHigh-xLow)+xATR;

   xPHi = xLow + xATR;
   xPLo = xHigh - xATR;

   double spread=(Ask-Bid);
   debug_comment+="\nxOpen="+DoubleToStr(xOpen,Digits);
   debug_comment+="\nxClose="+DoubleToStr(xClose,Digits);
   debug_comment+="\nxHigh="+DoubleToStr(xHigh,Digits);
   debug_comment+="\nxLow="+DoubleToStr(xLow,Digits);
   debug_comment+="\nxRange="+DoubleToStr(xRange,Digits);
   debug_comment+="\nxPP="+DoubleToStr(xPP,Digits);
//---
   ChartGetInteger(NULL,CHART_SCALE,0,XZoom);
   if(XZoom<3) xLen=-2;
   else xLen=0;

//--- Standard Pivot
   if(Pmode==Standard)
     {
      xR1 = (2 * xPP) - (xLow) + xATR/2;
      xS1 = (2 * xPP) - (xHigh) - xATR/2;
      xR2 = xPP + (xRange);
      xS2 = xPP - (xRange);
      xR3 = (xHigh) + 2*(xPP - xLow) + 2*xATR;
      xS3 = (xLow) - 2*(xHigh - xPP) - 2*xATR;
     }
//--- Fibonacci's Pivot     
   else if(Pmode==Fibonacci)
     {
      //xR1 = xPP + 0.382 * xRange;
      //xR2 = xPP + 0.618 * xRange;
      //xR3 = xPP + 1.000 * xRange;
      //xR4 = xPP + 1.618 * xRange;
      //xS1 = xPP - 0.382 * xRange;
      //xS2 = xPP - 0.618 * xRange;
      //xS3 = xPP - 1.000 * xRange;
      //xS4 = xPP - 1.618 * xRange;

      xR1 = xPP + 0.236 * xRange;
      xR2 = xPP + 0.382 * xRange;
      xR3 = xPP + 0.618 * xRange;
      xR4 = xPP + 1.0 * xRange;
      xS1 = xPP - 0.236 * xRange;
      xS2 = xPP - 0.382 * xRange;
      xS3 = xPP - 0.618 * xRange;
      xS4 = xPP - 1.0 * xRange;
     }
   else if(Pmode==Prime)
     {
      xR1 = xPP + (89 * xRange / 197);
      xR2 = xPP + (89 * xRange / 103);
      xR3 = xPP + (89 * xRange / 73);
      xR4 = xPP + (89 * xRange / 53);
      xS1 = xPP - (89 * xRange / 197);
      xS2 = xPP - (89 * xRange / 103);
      xS3 = xPP - (89 * xRange / 73);
      xS4 = xPP - (89 * xRange / 53);
     }
//+------------------------------------------------------------------+
//| RSI Indicator                                                    |
//+------------------------------------------------------------------+
   for(int i=0;i<=RSI;i++)
     {
      RSIBuffer[i]=iRSI(NULL,0,RSI,PRICE_CLOSE,i);
     }

   RSIindSize=0.2*(priceMax-priceMin);//*pow(10,Digits-1);//*iATR(NULL,PERIOD_D1,5,0)*sqrt(Period()+5);
   debug_comment+="\nRSIindSize="+DoubleToStr(RSIindSize,Digits);
   debug_comment+="\nPeriod="+DoubleToStr(Period(),Digits);

   //if (RSIindSize>(priceMax-priceMin)) RSIindSize=pow(10,Digits-1)*(xRange);
   x0=xPP-RSIindSize;//((xR3-xS3)*5)/4;
   x100=xPP+RSIindSize;//((xR3-xS3)*5)/4;
   int minRSIidx=ArrayMinimum(RSIBuffer,RSI,0);
   xRSI=RSIBuffer[minRSIidx];
   minRSILevel=x0+(xRSI *(x100-x0)/100);

   int maxRSIidx=ArrayMaximum(RSIBuffer,RSI,0);
   xRSI=RSIBuffer[maxRSIidx];
   maxRSILevel=x0+(xRSI *(x100-x0)/100);

   xRSI=RSIBuffer[0];
   RSILevel=x0+(xRSI *(x100-x0)/100);

   double x30=30 *(RSIindSize*2)/100;
   DrawRSITrail("RSIMid",x0,x100,0,1,Lavender,false);
   DrawRSITrail("RSI50",(x0+x100)/2,(x0+x100)/2,0,1,clrScaleColor,false);
   DrawRSITrail("RSIOver",x100,(x100-x30),0,1,LightCyan,true);
   DrawRSITrail("RSIUnder",x0,(x0+x30),0,1,LightCyan,true);

   DrawRSITrail("RSITrailBack",maxRSILevel,minRSILevel,0,5,Thistle,true);
   if(minRSIidx>maxRSIidx) DrawRSITrail("RSITrailFront",maxRSILevel,RSILevel,0,5,clrMistyRose,true);
   else DrawRSITrail("RSITrailFront",minRSILevel,RSILevel,0,5,clrMistyRose,true);
   DrawRSITrail("RSI",RSILevel,RSILevel,0,3,Purple,false);

//+------------------------------------------------------------------+
//| Moving Average                                                   |
//+------------------------------------------------------------------+
   double vMA=iMA(NULL,MA_TF,l_MA,0,MAmet,MAprice,0);
   sMA="M"+IntegerToString(MA_TF);
   if(MA_TF>=60) sMA="H"+IntegerToString(MA_TF/60);
   switch(MA_TF)
     {
      case  PERIOD_D1:
         sMA="D1";
         break;
      case PERIOD_W1:
         sMA="WK";
         break;
      case PERIOD_MN1:
         sMA="MN";
         break;
      default:
         break;
     }
   debug_comment+="\nMA_TF="+(DoubleToStr(MA_TF,Digits)
                              +"\npriceMax="+DoubleToStr(priceMax-pip1/10,Digits)
                              +"\npriceMin="+DoubleToStr(priceMin-pip1/10,Digits)
                              +"\nvMA="+DoubleToStr(vMA,Digits));
   sMA+="-MA("+IntegerToString(l_MA)+")";

   if(vMA>priceMax) DrawLevel(sMA,priceMax-pip1/6,StyleMA,5,clrLevelMA,12);
   else if(vMA<priceMin) DrawLevel(sMA,priceMin+pip1/6,StyleMA,5,clrLevelMA,12);
   else DrawLevel(sMA,vMA,StyleMA,WidthMA,clrLevelMA,4);

//+------------------------------------------------------------------+
//| Dynamic Pivot Levels                                             |
//+------------------------------------------------------------------+
   DrawLevel("L_PP",xPP,StylePP,WidthPP,clrLevelPP,3);
   DrawLevel("PHi",xPHi,StyleRng,WidthRng,clrRange,5);
   DrawLevel("PLo",xPLo,StyleRng,WidthRng,clrRange,5);

   debug_comment+="\nN_Bars ="+(IntegerToString(N_Bars));
   if(xR2-xS2<(5/pow(10,Digits-1)))
     {
      DrawLevel("L_R4",xR4,Style4,Width4,clrLevel4,3);
      DrawLevel("L_S4",xS4,Style4,Width4,clrLevel4,3);
      DrawLevel("L_S3",xS3,Style3,Width3,clrLevel3,2);
      DrawLevel("L_R3",xR3,Style3,Width3,clrLevel3,2);
      DrawLevel("L_R2",0,Style2,Width2,clrLevel2,2);
      DrawLevel("L_S2",0,Style2,Width2,clrLevel2,2);
      DrawLevel("L_R1",0,Style1,Width1,clrLevel1,2);
      DrawLevel("L_S1",0,Style1,Width1,clrLevel1,2);

     }
   else
     {

      DrawLevel("L_R4",xR4,Style4,Width4,clrLevel4,3);
      DrawLevel("L_S4",xS4,Style4,Width4,clrLevel4,3);
      DrawLevel("L_S3",xS3,Style3,Width3,clrLevel3,2);
      DrawLevel("L_R3",xR3,Style3,Width3,clrLevel3,2);
      DrawLevel("L_R2",xR2,Style2,Width2,clrLevel2,2);
      DrawLevel("L_S2",xS2,Style2,Width2,clrLevel2,2);
      DrawLevel("L_R1",xR1,Style1,Width1,clrLevel1,2);
      DrawLevel("L_S1",xS1,Style1,Width1,clrLevel1,2);
     }

//+------------------------------------------------------------------+
//| Spread Alert                                                     |
//+------------------------------------------------------------------+
   debug_comment+="\nSpread="+DoubleToStr(spread,Digits)
                  +"\nxATR="+DoubleToStr(xATR,Digits)
                  +"\n%ratio="+DoubleToStr(spread/xATR*100,Digits);
   if(spread/xATR*100>Ratio)
     {
      DrawScale("Ask",Ask,2,1,clrSpreadAlert,8);
      DrawScale("Bid",Bid,StyleAskBid,1,clrSpreadAlert,8);
      if(Period()<PERIOD_D1) Scale(true,clrSpreadAlert,3);
     }
   else
     {
      DrawScale("Ask",Ask,2,1,clrAskBid,8);
      DrawScale("Bid",Bid,StyleAskBid,1,clrAskBid,8);
      if(Period()<PERIOD_D1) Scale(true,clrScaleColor,1);
     }

//---
   if(debugmode) Comment(debug_comment);
   Sleep(1000);
   return (0);
  }
//+------------------------------------------------------------------+
//|         FUNCTIONS                                                |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| void DrawLevel()                                                 |
//|     Created by Asteris, modified by Cubicrey [March, 2010]       |
//|   Website: http://www.indo-investasi.com                         |
//|     modified by rkdius                                           |
//+------------------------------------------------------------------+
void DrawLevel(string a_name_0,double ad,int a_style,int Width,color a_color,int a_len)
  {
   double l_price=ad;
   int l_timeA;
   int l_timeB;
   double diff=Period()*60;
   l_timeA=(int)(Time[0] + xShift*diff);
   l_timeB=(int)(Time[0] - (xLen-xShift) * diff);

   if(ad>0.0)
     {
      if(ObjectFind(a_name_0)!=0)
        {
         ObjectCreate(a_name_0,OBJ_TREND,0,l_timeA-(int)(a_len*diff),l_price,l_timeB+(int)(a_len*diff),l_price);
         ObjectSet(a_name_0,OBJPROP_RAY,False);
         ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
         ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
         ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
         ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
         ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
         return;
        }
      ObjectSet(a_name_0,OBJPROP_RAY,False);
        {
         ObjectMove(a_name_0,0,l_timeA-(int)(a_len*diff),l_price);
         ObjectMove(a_name_0,1,l_timeB+(int)(a_len*diff),l_price);
        }
      ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
      ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
      ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
      ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
      ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
      return;
     }
   if(ObjectFind(a_name_0)>=0) ObjectDelete(a_name_0);
  }
//+------------------------------------------------------------------+
void DrawScale(string a_name_0,double ad,int a_style,int Width,color a_color,int a_len)
  {
   double l_price=ad;
   int l_timeA;
   int l_timeB;
   double diff=Period()*60;
   l_timeA=(int)(Time[0] + 4 * diff);
   l_timeB=(int)(Time[0] + 4 * diff - a_len * diff);

   if(ad>0.0)
     {
      if(ObjectFind(a_name_0)!=0)
        {
         ObjectCreate(a_name_0,OBJ_TREND,0,l_timeA,l_price,l_timeB,l_price);
         ObjectSet(a_name_0,OBJPROP_RAY,False);
         ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
         ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
         ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
         ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
         ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
         return;
        }
      ObjectSet(a_name_0,OBJPROP_RAY,False);
      ObjectMove(a_name_0,0,l_timeA,l_price);
      ObjectMove(a_name_0,1,l_timeB,l_price);
      ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
      ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
      ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
      ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
      ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
      return;
     }
   if(ObjectFind(a_name_0)>=0) ObjectDelete(a_name_0);
  }
//+------------------------------------------------------------------+
void Scale(bool drawscale,color clrScale,int sWidth)
  {
#define  ZPERIOD  PERIOD_M15
   double l_zero,tmp_zero;
//--- Option 1 - Fixed 
   l_zero=iClose(NULL,ZPERIOD,ZeroShift)+((iOpen(NULL,ZPERIOD,ZeroShift)-iClose(NULL,ZPERIOD,ZeroShift))/2);
   if(sc_mode==smATR)
     {
      //--- Option 2 - ATR Function
      tmp_zero=iClose(NULL,ZPERIOD,1)+((iOpen(NULL,ZPERIOD,1)-iClose(NULL,ZPERIOD,1))/2);
      double prev_bar=iClose(NULL,ZPERIOD,RSI)+((iOpen(NULL,ZPERIOD,RSI)-iClose(NULL,ZPERIOD,RSI))/2);
      if(prev_bar<tmp_zero) l_zero-=iATR(NULL,ATRTimeFrame,N_Bars,0);
      else if(prev_bar>tmp_zero) l_zero+=iATR(NULL,ATRTimeFrame,N_Bars,0);
      //---   */
     }
   debug_comment+="\nl_zero="+(DoubleToStr(l_zero,Digits));

//   int zoom = (int)(XZoom -1);
//   if(zoom<1) zoom=1;
   int zoom=(XZoom<2)?1:(int)(XZoom-1);
   if(drawscale==true)
     {
      DrawRect("+Over",l_zero+80*pip1,l_zero+100*pip1,0,sWidth,clrScale,6/zoom);

      DrawScale("+70",l_zero+70*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+60",l_zero+60*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+50",l_zero+50*pip1,0,1,clrScaleColor,8/zoom);
      DrawScale("+40",l_zero+40*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+30",l_zero+30*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+25",l_zero+25*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("+20",l_zero+20*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+15",l_zero+15*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("+10",l_zero+10*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("+5",l_zero+5*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("Zero",l_zero,0,1,Black,16/zoom);
      DrawScale("-5",l_zero-5*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("-10",l_zero-10*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("-15",l_zero-15*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("-20",l_zero-20*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("-25",l_zero-25*pip1,0,1,clrScaleColor,2/zoom);
      DrawScale("-30",l_zero-30*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("-40",l_zero-40*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("-50",l_zero-50*pip1,0,1,clrScaleColor,8/zoom);
      DrawScale("-60",l_zero-60*pip1,0,1,clrScaleColor,4/zoom);
      DrawScale("-70",l_zero-70*pip1,0,1,clrScaleColor,4/zoom);

      DrawRect("-Over",l_zero-80*pip1,l_zero-100*pip1,0,sWidth,clrScale,6/zoom);

      //DrawRect("pipATR",Close[1]+iATR(NULL,0,ZeroShift,0),Close[1]-iATR(NULL,0,ZeroShift,0),2,1,clrSilver,5);

      DrawRect("1pip",l_zero+pip1,l_zero-pip1,0,sWidth,clrScale,2/zoom);
      //      DrawRect("SLine",l_zero+80*pip1,l_zero-80*pip1,0,sWidth,clrScale,0);

     }
   else
     {
      DrawRect("+Over",0,0,0,0,0,0);

      DrawScale("+70",0,0,0,0,0);
      DrawScale("+60",0,0,0,0,0);
      DrawScale("+50",0,0,0,0,0);
      DrawScale("+40",0,0,0,0,0);
      DrawScale("+30",0,0,0,0,0);
      DrawScale("+25",0,0,0,0,0);
      DrawScale("+20",0,0,0,0,0);
      DrawScale("+15",0,0,0,0,0);
      DrawScale("+10",0,0,0,0,0);
      DrawScale("+5",0,0,0,0,0);
      DrawScale("Zero",0,0,0,0,0);
      DrawScale("-5",0,0,0,0,0);
      DrawScale("-10",0,0,0,0,0);
      DrawScale("-15",0,0,0,0,0);
      DrawScale("-20",0,0,0,0,0);
      DrawScale("-25",0,0,0,0,0);
      DrawScale("-30",0,0,0,0,0);
      DrawScale("-40",0,0,0,0,0);
      DrawScale("-50",0,0,0,0,0);
      DrawScale("-60",0,0,0,0,0);
      DrawScale("-70",0,0,0,0,0);

      DrawRect("-Over",0,0,0,0,0,0);

      DrawRect("1pip",0,0,0,0,0,0);
      //DrawRect("pipATR",0,0,0,0,0,0);

     }
   return;
  }
//+------------------------------------------------------------------+
void DrawRSITrail(string a_name_0,double ask,double bid,int a_style,int Width,color a_color,bool fill)
  {
   int l_timeA;
   int l_timeB;
   double diff=Period()*60;
   int ax,bx;
   if(XZoom<3){ ax=7; bx=4; }
   else { ax=5; bx=2; }

   l_timeA=(int)(Time[0] + (ax+xShift)*diff);
   l_timeB=(int)(Time[0] + (ax+xShift+bx)*diff);

   if(ask>0.0)
     {
      if(ObjectFind(a_name_0)!=0)
        {
         ObjectCreate(a_name_0,OBJ_RECTANGLE,0,l_timeA,ask,l_timeB,bid);
         ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
         ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
         ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
         ObjectSet(a_name_0,OBJPROP_BACK,fill);
         ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
         ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
         return;
        }
      ObjectMove(a_name_0,0,l_timeA,ask);
      ObjectMove(a_name_0,1,l_timeB,bid);
      ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
      ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
      ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
      ObjectSet(a_name_0,OBJPROP_BACK,fill);
      ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
      ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
      return;
     }
   if(ObjectFind(a_name_0)>=0) ObjectDelete(a_name_0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void DrawRect(string a_name_0,double ask,double bid,int a_style,int Width,color a_color,int a_len)
  {
   int l_timeA;
   int l_timeB;
   double diff=Period()*60;
   l_timeA=(int)(Time[0] + 4 * diff);
   l_timeB=(int)(Time[0] + 4 * diff - a_len * diff);

   if(ask>0.0)
     {
      if(ObjectFind(a_name_0)!=0)
        {
         ObjectCreate(a_name_0,OBJ_RECTANGLE,0,l_timeA,ask,l_timeB,bid);
         ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
         ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
         ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
         ObjectSet(a_name_0,OBJPROP_BACK,false);
         ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
         ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
         return;
        }
      ObjectMove(a_name_0,0,l_timeA,ask);
      ObjectMove(a_name_0,1,l_timeB,bid);
      ObjectSet(a_name_0,OBJPROP_COLOR,a_color);
      ObjectSet(a_name_0,OBJPROP_WIDTH,Width);
      ObjectSet(a_name_0,OBJPROP_STYLE,a_style);
      ObjectSet(a_name_0,OBJPROP_BACK,false);
      ObjectSet(a_name_0,OBJPROP_SELECTABLE,false);
      ObjectSet(a_name_0,OBJPROP_HIDDEN,true);
      return;
     }
   if(ObjectFind(a_name_0)>=0) ObjectDelete(a_name_0);
  }
//+------------------------------------------------------------------+*/
//+------------------------------------------------------------------+
