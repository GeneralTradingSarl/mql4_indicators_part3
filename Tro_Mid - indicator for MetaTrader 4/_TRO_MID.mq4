//+------------------------------------------------------------------+
//|                             _TRO_MID                             |
//|                                                                  |
//|   Copyright © 2007, Avery T. Horton, Jr. aka TheRumpledOne       |
//|                                                                  |
//|   PO BOX 43575, TUCSON, AZ 85733                                 |
//|                                                                  |
//|   GIFT AND DONATIONS ACCEPTED                                    |
//|                                                                  |
//|    http://docs.mql4.com/constants/wingdings                      |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Avery T. Horton, Jr. aka TheRumpledOne"
#property link      "therumpledone@gmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 2
//----
#property indicator_color1 MediumTurquoise
#property indicator_color2 Magenta
#property indicator_color3 MediumTurquoise
#property indicator_color4 Red
#property indicator_color5 Yellow
#property indicator_color6 Orange
#property indicator_color7 OrangeRed
//---- For the small screens
// extern string    Display_infos         = "=== If true, displayed on the chart ===";
// extern bool      display_on_chart      =  true ;  // If true, the open trade analysis, daily pivots and daily range will be displayed on the chart window
// indicators parameters
extern bool iPlotChart=true ;
extern bool iPlotGauge=false ;
extern int LocalTimeZone= 0;
extern int DestTimeZone= 0;
extern int myPeriod =1440 ;
extern int myOffset =1;
extern int myChartY=1 ;
extern int myStyle1 =2 ;
extern int myStyle2 =2 ;
extern int myStyle3 =2 ;
extern int myStyle4 =2 ;
extern int myStyle5 =2 ;
extern int myStyle6 =2 ;
extern int myStyle7 =2 ;
extern int myWingDing1 =115 ;
extern int myWingDing2 =115 ;
extern int myWingDing3 =115 ;
extern int myWingDing4 =115 ;
extern int myWingDing5 =115 ;
extern int myWingDing6 =115 ;
extern int myWingDing7 =115 ;
extern color myColor1 =MediumTurquoise ;
extern color myColor2 =Magenta;
extern color myColor3 =MediumTurquoise ;
extern color myColor4 =Red;
extern color myColor5 =Yellow;
extern color myColor6 =Orange;
extern color myColor7 =OrangeRed;
//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];
double P5Buffer[];
double P6Buffer[];
double P7Buffer[];
//----
double yesterday_high=0;
double yesterday_open=0;
double yesterday_low=0;
double yesterday_close=0;
double today_open=0;
double today_high=0;
double today_low=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- name for indicator window
   string short_name=" ";
   IndicatorShortName(short_name);
   SetIndexBuffer(0, P1Buffer);
   SetIndexBuffer(1, P2Buffer);
   SetIndexBuffer(2, P3Buffer);
   SetIndexBuffer(3, P4Buffer);
   SetIndexBuffer(4, P5Buffer);
   SetIndexBuffer(5, P6Buffer);
   SetIndexBuffer(6, P7Buffer);
//----
   SetIndexArrow(0, myWingDing1);
   SetIndexArrow(1, myWingDing2);
   SetIndexArrow(2, myWingDing3);
   SetIndexArrow(3, myWingDing4);
   SetIndexArrow(4, myWingDing5);
   SetIndexArrow(5, myWingDing6);
   SetIndexArrow(6, myWingDing7);
//----   
   SetIndexStyle(0, DRAW_ARROW, myStyle1, 1);
   SetIndexStyle(1, DRAW_ARROW, myStyle2, 1);
   SetIndexStyle(2, DRAW_ARROW, myStyle3, 1);
   SetIndexStyle(3, DRAW_ARROW, myStyle4, 1);
   SetIndexStyle(4, DRAW_ARROW, myStyle5, 1);
   SetIndexStyle(5, DRAW_ARROW, myStyle6, 1);
   SetIndexStyle(6, DRAW_ARROW, myStyle7, 1);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("MID");
   ObjectDelete("line5MID");
   ObjectDelete("X01_LabelMID");
   ObjectDelete("X01_ValueMID");
   ObjectDelete("X02_LabelMID");
   ObjectDelete("X02_ValueMID");
   ObjectDelete("X03_LabelMID");
   ObjectDelete("X03_ValueMID");
   ObjectDelete("X04_LabelMID");
   ObjectDelete("X04_ValueMID");
   ObjectDelete("X05_LabelMID");
   ObjectDelete("X05_ValueMID");
   ObjectDelete("X06_LabelMID");
   ObjectDelete("X06_ValueMID");
   ObjectDelete("X07_LabelMID");
   ObjectDelete("X07_ValueMID");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, dayi, counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0)
      return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0)
      counted_bars--;
   int limit=Bars - counted_bars;
//----   
   for(i=limit - 1; i>=0; i--)
     {
      double X01=(iHigh(NULL,0,i) + iLow(NULL,0,i)) * 0.5;
      double X02=(iHigh(NULL,0,i+1) + iLow(NULL,0,i+1)) * 0.5 ;
      double X03=0 ;
      double X04=0 ;
      double X05=0 ;
      double X06=0 ;
      double X07=0 ;
        if(iPlotChart)
        {
         P1Buffer[i]=X01 ;
         P2Buffer[i]=X02 ;
         P3Buffer[i]=X03 ;
         P4Buffer[i]=X04 ;
         P5Buffer[i]=X05 ;
         P6Buffer[i]=X06 ;
         P7Buffer[i]=X07 ;
        } // iPlotChart
     } // FOR 
     if(iPlotGauge)
     {
      string StrX01="Mid";
      string StrX02="Prev";
      string StrX03="-XO3";
      string StrX04="-XO4";
      string StrX05="-XO5";
      string StrX06="-XO6";
      string StrX07="-XO7";
//----
      color color_MID_1=Orchid;
      color color_X01=Red;
      color color_X02=Red;
      color color_X03=Red;
      color color_X04=Red;
      color color_X05=Red;
      color color_X06=Red;
      color color_X07=Red;
//----
      if(Close[0] < X01) { color_X01=Lime; }
      if(Close[0] < X02) { color_X02=Lime; }
      if(Close[0] < X03) { color_X03=Lime; }
      if(Close[0] < X04) { color_X04=Lime; }
      if(Close[0] < X05) { color_X05=Lime; }
      if(Close[0] < X06) { color_X06=Lime; }
      //	if( Close[0] < X07) { color_X07=Lime; }		
      int Precision, dig;
      if(StringFind( Symbol(), "JPY", 0)!=-1){ Precision=100; dig=2;}
      else                                        { Precision=10000; dig=4; }
      int sPeriod= Period();
      if (myPeriod!=NULL){ sPeriod= myPeriod ;}
      //---- Set labels
      int WindowToUse;
      int Corner_line, Xdist_line;
      int Corner_text, Corner_ValueMID, Xdist_text, Xdist_ValueMID;
      int Ydist_line5;
      int Corner_pivots, Xdist_pivots, Ydist_pivots;
      int Ydist_X01, Ydist_X02, Ydist_X03, Ydist_X04, Ydist_X05, Ydist_X06, Ydist_X07;
      int YdistInc ;
//----
      WindowToUse= 0;
      Corner_line=1;
      Corner_text=1;
      Corner_ValueMID=1;
      Xdist_line=21;
      Xdist_text=93;
      Xdist_ValueMID=23;
      Corner_pivots=1;
      Xdist_pivots=21;
//----
      Ydist_pivots=myChartY;
      Ydist_line5=
      Ydist_pivots + 11;
      YdistInc=15 ;
      Ydist_X01=Ydist_pivots + 25;
      Ydist_X02=Ydist_X01 + YdistInc;
      Ydist_X03=Ydist_X01 + YdistInc*2;
      Ydist_X04=Ydist_X01 + YdistInc*3;
      Ydist_X05=Ydist_X01 + YdistInc*4;
      Ydist_X06=Ydist_X01 + YdistInc*5;
      Ydist_X07=Ydist_X01 + YdistInc*6;
//----
      ObjectCreate("MID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("MID",sPeriod + " MID ",9, "Verdana", color_MID_1);
      ObjectSet("MID", OBJPROP_CORNER, Corner_pivots);
      ObjectSet("MID", OBJPROP_XDISTANCE, Xdist_pivots);
      ObjectSet("MID", OBJPROP_YDISTANCE, Ydist_pivots);
      //
      ObjectCreate("line5MID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("line5MID","---------------------",7, "Verdana", color_MID_1);
      ObjectSet("line5MID", OBJPROP_CORNER, Corner_line);
      ObjectSet("line5MID", OBJPROP_XDISTANCE, Xdist_line);
      ObjectSet("line5MID", OBJPROP_YDISTANCE, Ydist_line5);
      //
      ObjectCreate("X01_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("X01_LabelMID",StrX01,9, "Verdana", myColor1);
      ObjectSet("X01_LabelMID", OBJPROP_CORNER, Corner_text);
      ObjectSet("X01_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
      ObjectSet("X01_LabelMID", OBJPROP_YDISTANCE, Ydist_X01);
      //
      ObjectCreate("X01_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("X01_ValueMID"," "+DoubleToStr(X01,dig),9, "Verdana", color_X01);
      ObjectSet("X01_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
      ObjectSet("X01_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
      ObjectSet("X01_ValueMID", OBJPROP_YDISTANCE, Ydist_X01);
      //
      ObjectCreate("X02_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("X02_LabelMID",StrX02,9, "Verdana", myColor2);
      ObjectSet("X02_LabelMID", OBJPROP_CORNER, Corner_text);
      ObjectSet("X02_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
      ObjectSet("X02_LabelMID", OBJPROP_YDISTANCE, Ydist_X02);
      //
      ObjectCreate("X02_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
      ObjectSetText("X02_ValueMID"," "+DoubleToStr(X02,dig),9, "Verdana", color_X02);
      ObjectSet("X02_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
      ObjectSet("X02_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
      ObjectSet("X02_ValueMID", OBJPROP_YDISTANCE, Ydist_X02);
/*
   ObjectCreate("X03_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X03_LabelMID",StrX03,9, "Verdana", myColor3 );
   ObjectSet("X03_LabelMID", OBJPROP_CORNER, Corner_text);
   ObjectSet("X03_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("X03_LabelMID", OBJPROP_YDISTANCE, Ydist_X03);   
   ObjectCreate("X03_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X03_ValueMID"," "+DoubleToStr(X03,dig),9, "Verdana", color_X03);
   ObjectSet("X03_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
   ObjectSet("X03_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
   ObjectSet("X03_ValueMID", OBJPROP_YDISTANCE, Ydist_X03);
   ObjectCreate("X04_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X04_LabelMID",StrX04,9, "Verdana", myColor4 );
   ObjectSet("X04_LabelMID", OBJPROP_CORNER, Corner_text);
   ObjectSet("X04_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("X04_LabelMID", OBJPROP_YDISTANCE, Ydist_X04);
   ObjectCreate("X04_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X04_ValueMID"," "+DoubleToStr(X04,dig),9, "Verdana", color_X04);
   ObjectSet("X04_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
   ObjectSet("X04_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
   ObjectSet("X04_ValueMID", OBJPROP_YDISTANCE, Ydist_X04);
   ObjectCreate("X05_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X05_LabelMID",StrX05,9, "Verdana", myColor5 );
   ObjectSet("X05_LabelMID", OBJPROP_CORNER, Corner_text);
   ObjectSet("X05_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("X05_LabelMID", OBJPROP_YDISTANCE, Ydist_X05);
   ObjectCreate("X05_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X05_ValueMID"," "+DoubleToStr(X05,dig),9, "Verdana", color_X05);
   ObjectSet("X05_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
   ObjectSet("X05_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
   ObjectSet("X05_ValueMID", OBJPROP_YDISTANCE, Ydist_X05);
   ObjectCreate("X06_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X06_LabelMID",StrX06,9, "Verdana", myColor6 );
   ObjectSet("X06_LabelMID", OBJPROP_CORNER, Corner_text);
   ObjectSet("X06_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("X06_LabelMID", OBJPROP_YDISTANCE, Ydist_X06);
   ObjectCreate("X06_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X06_ValueMID"," "+DoubleToStr(X06,dig),9, "Verdana", color_X06);
   ObjectSet("X06_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
   ObjectSet("X06_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
   ObjectSet("X06_ValueMID", OBJPROP_YDISTANCE, Ydist_X06);
   ObjectCreate("X07_LabelMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X07_LabelMID",StrX07,9, "Verdana", myColor7 );
   ObjectSet("X07_LabelMID", OBJPROP_CORNER, Corner_text);
   ObjectSet("X07_LabelMID", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("X07_LabelMID", OBJPROP_YDISTANCE, Ydist_X07);
   ObjectCreate("X07_ValueMID", OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSetText("X07_ValueMID"," "+DoubleToStr(X07,dig),9, "Verdana", color_X07);
   ObjectSet("X07_ValueMID", OBJPROP_CORNER, Corner_ValueMID);
   ObjectSet("X07_ValueMID", OBJPROP_XDISTANCE, Xdist_ValueMID);
   ObjectSet("X07_ValueMID", OBJPROP_YDISTANCE, Ydist_X07);
*/
     } // iPlotGauge
   return(0);
  }
//+------------------------------------------------------------------+