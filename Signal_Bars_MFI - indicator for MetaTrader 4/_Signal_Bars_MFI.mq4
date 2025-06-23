//+------------------------------------------------------------------+
//|                                        #Signal_Bars_v3_Daily.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property link      " cja "
//----
#property indicator_chart_window
//----
extern bool  Corner_of_Chart_RIGHT_TOP=true;
extern bool  Show_Price=false;
extern bool  Show_Xtra_Details=true;
extern bool  Show_Smaller_Size=false;
extern int   Shift_UP_DN =0;
extern int   Adjust_Side_to_side =20;
extern color BarLabel_color=LightBlue;
extern color CommentLabel_color=LightBlue;
//****************************************
extern int MFI_Period=9;
//extern int MFI_PRICE_TYPE = 0;
extern int RVI_Period=9;
//extern int RVI_PRICE_TYPE = 1;
extern int CCI_Period=13;
extern int CCI_PRICE_TYPE=0;
extern int Mom_Period=10;
extern int Mom_PRICE_TYPE=0;
extern int MA_Fast=1;
extern int MA_Slow=62;
extern int MA_MODE=1;
extern int MA_PRICE_TYPE=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0,OBJ_LABEL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //***********************************************************************************************************************
   //MFI Signals 
   int    counted_bars=IndicatorCounted();
   string  MFI_StrH1="",  MFI_StrM15="",  MFI_StrM5="",  MFI_StrM1="",  MFI_StrH4 ="",  MFI_StrM30= "",  MFI_StrD1= "",  MFI_StrW1= "";
   color  color_signal,color_M1,color_M5,color_M15,color_M30,color_M60,color_M240,color_M1440;
//----
   double MFI_M1=iMFI(NULL, PERIOD_M1, MFI_Period , 0 );
   double MFI_M5=iMFI(NULL, PERIOD_M5, MFI_Period , 0 );
   double MFI_M15=iMFI(NULL, PERIOD_M15, MFI_Period , 0 );
   double MFI_M30=iMFI(NULL, PERIOD_M30, MFI_Period , 0 );
   double MFI_H1=iMFI(NULL, PERIOD_H1, MFI_Period , 0 );
   double MFI_H4=iMFI(NULL, PERIOD_H4, MFI_Period , 0 );
   double MFI_D1=iMFI(NULL, PERIOD_D1, MFI_Period , 0 );
//----
   if (MFI_M1 > 80){ MFI_StrM1="-";  color_M1=Green;}
   if (MFI_M5 > 80){ MFI_StrM5="-";  color_M5=Green;}
   if (MFI_M15 > 80){ MFI_StrM15="-";  color_M15=Green;}
   if (MFI_M30 > 80){ MFI_StrM30="-";  color_M30=Green;}
   if (MFI_H1 > 80){ MFI_StrH1="-";  color_M60=Green;}
   if (MFI_H4 > 80){ MFI_StrH4="-";  color_M240=Green;}
   if (MFI_D1 > 80){ MFI_StrD1="-";  color_M1440=Green;}
   if (MFI_M1 < 20){ MFI_StrM1="-";  color_M1=Red;}
   if (MFI_M5 < 20){ MFI_StrM5="-";  color_M5=Red;}
   if (MFI_M15 < 20){ MFI_StrM15="-";  color_M15=Red;}
   if (MFI_M30 < 20){ MFI_StrM30="-";  color_M30=Red;}
   if (MFI_H1 < 20){ MFI_StrH1="-";  color_M60=Red;}
   if (MFI_H4 < 20){ MFI_StrH4="-";  color_M240=Red;}
   if (MFI_D1 < 20){ MFI_StrD1="-";  color_M1440=Red;}
   if (MFI_M1 > 50){ MFI_StrM1="-";  color_M1=Lime;}
   if (MFI_M5 > 50){ MFI_StrM5="-";  color_M5=Lime;}
   if (MFI_M15 > 50){ MFI_StrM15="-";  color_M15=Lime;}
   if (MFI_M30 > 50){ MFI_StrM30="-";  color_M30=Lime;}
   if (MFI_H1 > 50){ MFI_StrH1="-";  color_M60=Lime;}
   if (MFI_H4 > 50){ MFI_StrH4="-";  color_M240=Lime;}
   if (MFI_D1 > 50){ MFI_StrD1="-";  color_M1440=Lime;}
   if (MFI_M1 < 50){ MFI_StrM1="-";  color_M1=Orange;}
   if (MFI_M5 < 50){ MFI_StrM5="-";  color_M5=Orange;}
   if (MFI_M15 < 50){ MFI_StrM15="-";  color_M15=Orange;}
   if (MFI_M30 < 50){ MFI_StrM30="-";  color_M30=Orange;}
   if (MFI_H1 < 50){ MFI_StrH1="-";  color_M60=Orange;}
   if (MFI_H4 < 50){ MFI_StrH4="-";  color_M240=Orange;}
   if (MFI_D1 < 50){ MFI_StrD1="-";  color_M1440=Orange;}
   if (Corner_of_Chart_RIGHT_TOP==true)
     {
      ObjectCreate("Numbers", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Numbers", "    M1     M5  M15   M30   H1    H4    D1", 5, "Tahoma Narrow", BarLabel_color);
      ObjectSet("Numbers", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("Numbers", OBJPROP_XDISTANCE, 17+Adjust_Side_to_side);
      ObjectSet("Numbers", OBJPROP_YDISTANCE, 28+Shift_UP_DN);
     }
   if (Corner_of_Chart_RIGHT_TOP==false)
     {
      ObjectCreate("Numbers", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Numbers", "   M1     M5   M15   M30   H1    H4    D1", 5, "Tahoma Narrow", BarLabel_color);
      ObjectSet("Numbers", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
      ObjectSet("Numbers", OBJPROP_XDISTANCE, 17+Adjust_Side_to_side);
      ObjectSet("Numbers", OBJPROP_YDISTANCE, 24+Shift_UP_DN);
     }
   ObjectCreate("MFIM1t", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIM1t", "MFI", 6, "Tahoma Narrow", BarLabel_color);
   ObjectSet("MFIM1t", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIM1t", OBJPROP_XDISTANCE, 155+Adjust_Side_to_side);
   ObjectSet("MFIM1t", OBJPROP_YDISTANCE, 36+Shift_UP_DN);
   //
   ObjectCreate("MFIM1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIM1", MFI_M1, 40, "Tahoma Narrow", color_M1);
   ObjectSet("MFIM1", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIM1", OBJPROP_XDISTANCE, 130+Adjust_Side_to_side);
   ObjectSet("MFIM1", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFIM5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIM5", MFI_M5, 40, "Tahoma Narrow", color_M5);
   ObjectSet("MFIM5", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIM5", OBJPROP_XDISTANCE, 110+Adjust_Side_to_side);
   ObjectSet("MFIM5", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFIM15", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIM15", MFI_M15, 40, "Tahoma Narrow", color_M15);
   ObjectSet("MFIM15", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIM15", OBJPROP_XDISTANCE, 90+Adjust_Side_to_side);
   ObjectSet("MFIM15", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFIM30", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIM30", MFI_M30, 40, "Tahoma Narrow", color_M30);
   ObjectSet("MFIM30", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIM30", OBJPROP_XDISTANCE, 70+Adjust_Side_to_side);
   ObjectSet("MFIM30", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFIH1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIH1", MFI_H1, 40, "Tahoma Narrow", color_M60);
   ObjectSet("MFIH1", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIH1", OBJPROP_XDISTANCE, 50+Adjust_Side_to_side);
   ObjectSet("MFIH1", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFIh4", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFIH4", MFI_H4, 40, "Tahoma Narrow", color_M240);
   ObjectSet("MFIH4", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFIH4", OBJPROP_XDISTANCE, 30+Adjust_Side_to_side);
   ObjectSet("MFIH4", OBJPROP_YDISTANCE, 0+Shift_UP_DN);
   //
   ObjectCreate("MFID1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("MFID1", MFI_D1, 40, "Tahoma Narrow", color_M1440);
   ObjectSet("MFID1", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("MFID1", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
   ObjectSet("MFID1", OBJPROP_YDISTANCE, 0+Shift_UP_DN); 
   //*************************************************************************************************************** 
   //STR Signals 
   double RVI_d1=iRVI(NULL, PERIOD_D1, RVI_Period , MODE_MAIN, 0 );
   double RVI_h4=iRVI(NULL, PERIOD_H4, RVI_Period ,  MODE_MAIN, 0 );
   double RVI_h1=iRVI(NULL, PERIOD_H1, RVI_Period ,  MODE_MAIN, 0 );
   double RVI_m30=iRVI(NULL, PERIOD_M30, RVI_Period ,  MODE_MAIN, 0 );
   double RVI_m15=iRVI(NULL, PERIOD_M15, RVI_Period ,  MODE_MAIN, 0 );
   double RVI_m5=iRVI(NULL, PERIOD_M5, RVI_Period , MODE_MAIN,  0 );
   double RVI_m1=iRVI(NULL, PERIOD_M1, RVI_Period , MODE_MAIN,  0 );
   double Mom_D1=iMomentum(NULL, PERIOD_D1, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_H4=iMomentum(NULL, PERIOD_H4, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_H1=iMomentum(NULL, PERIOD_H1, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_M30=iMomentum(NULL, PERIOD_M30, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_M15=iMomentum(NULL, PERIOD_M15, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_M5=iMomentum(NULL, PERIOD_M5, Mom_Period , Mom_PRICE_TYPE, 0);
   double Mom_M1=iMomentum(NULL, PERIOD_M1, Mom_Period , Mom_PRICE_TYPE, 0);
   double cci_DD1=iCCI(NULL, PERIOD_D1,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_HH4=iCCI(NULL, PERIOD_H4,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_HH1=iCCI(NULL, PERIOD_H1,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_MM30=iCCI(NULL, PERIOD_M30,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_MM15=iCCI(NULL, PERIOD_M15,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_MM5=iCCI(NULL, PERIOD_M5,CCI_Period , CCI_PRICE_TYPE, 0);
   double cci_MM1=iCCI(NULL, PERIOD_M1,CCI_Period , CCI_PRICE_TYPE, 0);
   string STR_h1="", STR_m15="", STR_m5="", STR_m1="", STR_h4 ="",STR_m30= "",STR_d1= "",STR_w1= "";
   // color  color_signal,color_m1,color_m5,color_m15,color_m30,color_m60,color_m240,color_m1440;
   if ((RVI_d1 > 0) && (Mom_D1 > 100) && (cci_DD1 > 0)) { STR_d1="-";color_M1440=Green;}
   if ((RVI_h4 > 0) && (Mom_H4 > 100) && (cci_HH4 > 0)) { STR_h4="-";color_M240=Green;}
   if ((RVI_h1 > 0) && (Mom_H1 > 100) && (cci_HH1 > 0)) { STR_h1="-";color_M60=Green;}
   if ((RVI_m30 > 0) && (Mom_M30 > 100) && (cci_MM30 > 0)) { STR_m30="-";color_M30=Green; }
   if ((RVI_m15 > 0) && (Mom_M15 > 100) && (cci_MM15 > 0)) { STR_m15="-";color_M15=Green; }
   if ((RVI_m5 > 0) && (Mom_M5 > 100) && (cci_MM5 > 0)) { STR_m5="-"; color_M5=Green;}
   if ((RVI_m1 > 0) && (Mom_M1 > 100) && (cci_MM1 > 0)) { STR_m1="-";  color_M1=Green;}
   if ((RVI_d1 < 0) && (Mom_D1 < 100) && (cci_DD1 < 0)) { STR_d1="-";color_M1440=Red;}
   if ((RVI_h4 < 0) && (Mom_H4 < 100) && (cci_HH4 < 0)) { STR_h4="-";color_M240=Red;}
   if ((RVI_h1 < 0) && (Mom_H1 < 100) && (cci_HH1 < 0)) { STR_h1="-";color_M60=Red;}
   if ((RVI_m30 < 0) && (Mom_M30 < 100) && (cci_MM30 < 0)) { STR_m30="-";color_M30=Red;}
   if ((RVI_m15 < 0) && (Mom_M15 < 100) && (cci_MM15 < 0)) { STR_m15="-";color_M15=Red;}
   if ((RVI_m5 < 0) && (Mom_M5 < 100) && (cci_MM5 < 0)) { STR_m5="-";color_M5=Red;}
   if ((RVI_m1 < 0) && (Mom_M1 < 100) && (cci_MM1 < 0)) { STR_m1="-"; color_M1=Red;}
   if ((RVI_m1 < 50) && (Mom_M1 > 100) && (cci_MM1 > 0)) { STR_m1="-";  color_M1=Lime;}
   if ((RVI_m1 > 50) && (Mom_M1 < 100) && (cci_MM1 < 0)) { STR_m1="-";  color_M1=Orange;}
   if ((RVI_m1 < 50) && (Mom_M1 > 100) && (cci_MM1 < 0)) { STR_m1="-";  color_M1=Silver;}
   if ((RVI_m1 > 50) && (Mom_M1 < 100) && (cci_MM1 > 0)) { STR_m1="-";  color_M1=Silver;}
   // if ((rsi_m1 > 50) && (Mom_M1 > 100) && (cci_MM1 < 0)) { STR_m1 = "-";  color_M1 = Goldenrod;}  
   // if ((rsi_m1 > 50) && (Mom_M1 < 100) && (cci_MM1 < 0)) { STR_m1 = "-";  color_M1 = Goldenrod;}
   if ((RVI_m5 < 50) && (Mom_M5 > 100) && (cci_MM5 > 0)) { STR_m5="-";  color_M5=Lime;}
   if ((RVI_m5 > 50) && (Mom_M5 < 100) && (cci_MM5 < 0)) { STR_m5="-";  color_M5=Orange;}
   if ((RVI_m5 < 50) && (Mom_M5 > 100) && (cci_MM5 < 0)) { STR_m5="-";  color_M5=Silver;}
   if ((RVI_m5 > 50) && (Mom_M5 < 100) && (cci_MM5 > 0)) { STR_m5="-";  color_M5=Silver;}
   //   if ((rsi_m5 > 50) && (Mom_M5 > 100) && (cci_MM5 < 0)) { STR_m5 = "-";  color_M5 = Goldenrod;}  
   //  if ((rsi_m5 > 50) && (Mom_M5 < 100) && (cci_MM5 < 0)) { STR_m5 = "-";  color_m5 = Goldenrod;}
   if ((RVI_m15 < 50) && (Mom_M15 > 100) && (cci_MM15 > 0)) { STR_m15="-";  color_M15=Lime;}
   if ((RVI_m15 > 50) && (Mom_M15 < 100) && (cci_MM15 < 0)) { STR_m15="-";  color_M15=Orange;}
   if ((RVI_m15 < 50) && (Mom_M15 > 100) && (cci_MM15 < 0)) { STR_m15="-";  color_M15=Silver;}
   if ((RVI_m15 > 50) && (Mom_M15 < 100) && (cci_MM15 > 0)) { STR_m15="-";  color_M15=Silver;}
   // if ((rsi_m15 > 50) && (Mom_M15 > 100) && (cci_MM15 < 0)) { STR_m15 = "-";  color_M15 = Goldenrod;}  
   // if ((rsi_m15 > 50) && (Mom_M15 < 100) && (cci_MM15 < 0)) { STR_m15 = "-";  color_M15 = Goldenrod;}
   if ((RVI_m30 < 50) && (Mom_M30 > 100) && (cci_MM30 > 0)) { STR_m30="-";  color_M30=Lime;}
   if ((RVI_m30 > 50) && (Mom_M30 < 100) && (cci_MM30 < 0)) { STR_m30="-";  color_M30=Orange;}
   if ((RVI_m30 < 50) && (Mom_M30 > 100) && (cci_MM30 < 0)) { STR_m30="-";  color_M30=Silver;}
   if ((RVI_m30 > 50) && (Mom_M30 < 100) && (cci_MM30 > 0)) { STR_m30="-";  color_M30=Silver;}
   //  if ((rsi_m30 > 50) && (Mom_M30 > 100) && (cci_MM30 < 0)) { STR_m30 = "-";  color_M30 = Goldenrod;}  
   //  if ((rsi_m30 > 50) && (Mom_M30 < 100) && (cci_MM30 < 0)) { STR_m30 = "-";  color_M30 = Goldenrod;}
   if ((RVI_h1 < 50) && (Mom_H1 > 100) && (cci_HH1 > 0)) { STR_h1="-";  color_M60=Lime;}
   if ((RVI_h1 > 50) && (Mom_H1 < 100) && (cci_HH1 < 0)) { STR_h1="-";  color_M60=Orange;}
   if ((RVI_h1 < 50) && (Mom_H1 > 100) && (cci_HH1 < 0)) { STR_h1="-";  color_M60=Silver;}
   if ((RVI_h1 > 50) && (Mom_H1 < 100) && (cci_HH1 > 0)) { STR_h1="-";  color_M60=Silver;}
   //  if ((rsi_h1 > 50) && (Mom_H1 > 100) && (cci_HH1 < 0)) { STR_h1 = "-";  color_M60 = Goldenrod;}  
   //  if ((rsi_h1 > 50) && (Mom_H1 < 100) && (cci_HH1 < 0)) { STR_h1 = "-";  color_M60 = Goldenrod;}
   if ((RVI_h4 < 50) && (Mom_H4 > 100) && (cci_HH4 > 0)) { STR_h4="-";  color_M240=Lime;}
   if ((RVI_h4 > 50) && (Mom_H4 < 100) && (cci_HH4 < 0)) { STR_h4="-";  color_M240=Orange;}
   if ((RVI_h4 < 50) && (Mom_H4 > 100) && (cci_HH4 < 0)) { STR_h4="-";  color_M240=Silver;}
   if ((RVI_h4 > 50) && (Mom_H4 < 100) && (cci_HH4 > 0)) { STR_h4="-";  color_M240=Silver;}
   //  if ((rsi_h4 > 50) && (Mom_H4 > 100) && (cci_HH4 < 0)) { STR_h4 = "-";  color_M240 = Goldenrod;}  
   //   if ((rsi_h4 > 50) && (Mom_H4 < 100) && (cci_HH4 < 0)) { STR_h4 = "-";  color_M240 = Goldenrod;}
   if ((RVI_d1 < 50) && (Mom_D1 > 100) && (cci_DD1 > 0)) { STR_d1="-";  color_M1440=Lime;}
   if ((RVI_d1 > 50) && (Mom_D1 < 100) && (cci_DD1 < 0)) { STR_d1="-";  color_M1440=Orange;}
   if ((RVI_d1 < 50) && (Mom_D1 > 100) && (cci_DD1 < 0)) { STR_d1="-";  color_M1440=Silver;}
   if ((RVI_d1 > 50) && (Mom_D1 < 100) && (cci_DD1 > 0)) { STR_d1="-";  color_M1440=Silver;}
   //  if ((rsi_d1 > 50) && (Mom_D1 > 100) && (cci_DD1 < 0)) { STR_d1 = "-";  color_M1440 = Goldenrod;}  
   //  if ((rsi_d1 > 50) && (Mom_D1 < 100) && (cci_DD1 < 0)) { STR_d1 = "-";  color_M1440 = Goldenrod;}
   ObjectCreate("SignalSTRM1t", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM1t","STR", 6, "Tahoma Narrow",  BarLabel_color);
   ObjectSet("SignalSTRM1t", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM1t", OBJPROP_XDISTANCE, 155+Adjust_Side_to_side);
   ObjectSet("SignalSTRM1t", OBJPROP_YDISTANCE, 46+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM1", STR_m1, 40, "Tahoma Narrow",  color_M1);
   ObjectSet("SignalSTRM1", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM1", OBJPROP_XDISTANCE, 130+Adjust_Side_to_side);
   ObjectSet("SignalSTRM1", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM5", STR_m5, 40, "Tahoma Narrow",  color_M5);
   ObjectSet("SignalSTRM5", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM5", OBJPROP_XDISTANCE, 110+Adjust_Side_to_side);
   ObjectSet("SignalSTRM5", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM15", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM15", STR_m15, 40, "Tahoma Narrow",  color_M15);
   ObjectSet("SignalSTRM15", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM15", OBJPROP_XDISTANCE, 90+Adjust_Side_to_side);
   ObjectSet("SignalSTRM15", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM30", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM30", STR_m30, 40, "Tahoma Narrow",  color_M30);
   ObjectSet("SignalSTRM30", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM30", OBJPROP_XDISTANCE, 70+Adjust_Side_to_side);
   ObjectSet("SignalSTRM30", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM60", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM60", STR_h1, 40, "Tahoma Narrow",  color_M60);
   ObjectSet("SignalSTRM60", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM60", OBJPROP_XDISTANCE, 50+Adjust_Side_to_side);
   ObjectSet("SignalSTRM60", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM240", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM240", STR_h4, 40, "Tahoma Narrow",  color_M240);
   ObjectSet("SignalSTRM240", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM240", OBJPROP_XDISTANCE, 30+Adjust_Side_to_side);
   ObjectSet("SignalSTRM240", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //
   ObjectCreate("SignalSTRM1440", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalSTRM1440", STR_d1, 40, "Tahoma Narrow",  color_M1440);
   ObjectSet("SignalSTRM1440", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalSTRM1440", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
   ObjectSet("SignalSTRM1440", OBJPROP_YDISTANCE, 10+Shift_UP_DN);
   //******************************************************************************************************************
   //EMA Signals
   double EMA_M1=iMA(Symbol(),1,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_m1=iMA(Symbol(),1,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_M5=iMA(Symbol(),5,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_m5=iMA(Symbol(),5,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_M15=iMA(Symbol(),15,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_m15=iMA(Symbol(),15,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_M30=iMA(Symbol(),30,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_m30=iMA(Symbol(),30,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_H1=iMA(Symbol(),60,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_h1=iMA(Symbol(),60,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_H4=iMA(Symbol(),240,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_h4=iMA(Symbol(),240,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   double EMA_D1=iMA(Symbol(),1440,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   double ema_d1=iMA(Symbol(),1440,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   // double EMA_W1 = iMA(Symbol(),10080,MA_Fast,0,MA_MODE,MA_PRICE_TYPE,0);
   // double ema_w1 = iMA(Symbol(),10080,MA_Slow,0,MA_MODE,MA_PRICE_TYPE,0);
   string M1_EMA= "",M5_EMA= "", M15_EMA= "", M30_EMA= "", H1_EMA= "", H4_EMA= "", D1_EMA= "",PRC1;
   color  color_EMAm1,color_EMAm5,color_EMAm15,color_EMAm30,color_EMAm60,color_EMAm240,color_EMAm1440;
//----
   if (EMA_M1 > ema_m1) {M1_EMA= "-";color_EMAm1=MediumSeaGreen; }
   if (EMA_M1<=ema_m1) {M1_EMA= "-";color_EMAm1=Red; }
   if (EMA_M5 > ema_m5) {M5_EMA= "-";color_EMAm5=MediumSeaGreen; }
   if (EMA_M5<=ema_m5) {M5_EMA= "-";color_EMAm5=Red; }
   if (EMA_M15 > ema_m15) {M15_EMA= "-";color_EMAm15=MediumSeaGreen; }
   if (EMA_M15<=ema_m15) {M15_EMA= "-";color_EMAm15=Red; }
   if (EMA_M30 > ema_m30) {M30_EMA= "-";color_EMAm30=MediumSeaGreen; }
   if (EMA_M30<=ema_m30) {M30_EMA= "-";color_EMAm30=Red; }
   if (EMA_H1 > ema_h1) {H1_EMA= "-";color_EMAm60=MediumSeaGreen; }
   if (EMA_H1<=ema_h1) {H1_EMA= "-";color_EMAm60=Red; }
   if (EMA_H4 > ema_h4) {H4_EMA= "-";color_EMAm240=MediumSeaGreen; }
   if (EMA_H4<=ema_h4) {H4_EMA= "-";color_EMAm240=Red; }
   if (EMA_D1 > ema_d1) {D1_EMA= "-";color_EMAm1440=MediumSeaGreen; }
   if (EMA_D1<=ema_d1) {D1_EMA= "-";color_EMAm1440=Red; }
//----
   ObjectCreate("SignalEMAM1t", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM1t","EMA", 5, "Tahoma Narrow",  BarLabel_color);
   ObjectSet("SignalEMAM1t", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM1t", OBJPROP_XDISTANCE, 155+Adjust_Side_to_side);
   ObjectSet("SignalEMAM1t", OBJPROP_YDISTANCE, 58+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM1", M1_EMA, 40, "Tahoma Narrow",  color_EMAm1);
   ObjectSet("SignalEMAM1", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM1", OBJPROP_XDISTANCE, 130+Adjust_Side_to_side);
   ObjectSet("SignalEMAM1", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM5", M5_EMA, 40, "Tahoma Narrow",  color_EMAm5);
   ObjectSet("SignalEMAM5", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM5", OBJPROP_XDISTANCE, 110+Adjust_Side_to_side);
   ObjectSet("SignalEMAM5", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM15", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM15", M15_EMA, 40, "Tahoma Narrow",  color_EMAm15);
   ObjectSet("SignalEMAM15", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM15", OBJPROP_XDISTANCE, 90+Adjust_Side_to_side);
   ObjectSet("SignalEMAM15", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM30", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM30", M30_EMA, 40, "Tahoma Narrow",  color_EMAm30);
   ObjectSet("SignalEMAM30", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM30", OBJPROP_XDISTANCE, 70+Adjust_Side_to_side);
   ObjectSet("SignalEMAM30", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM60", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM60", H1_EMA, 40, "Tahoma Narrow",  color_EMAm60);
   ObjectSet("SignalEMAM60", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM60", OBJPROP_XDISTANCE, 50+Adjust_Side_to_side);
   ObjectSet("SignalEMAM60", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM240", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM240", H4_EMA, 40, "Tahoma Narrow",  color_EMAm240);
   ObjectSet("SignalEMAM240", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM240", OBJPROP_XDISTANCE, 30+Adjust_Side_to_side);
   ObjectSet("SignalEMAM240", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //
   ObjectCreate("SignalEMAM1440", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalEMAM1440", D1_EMA, 40, "Tahoma Narrow",  color_EMAm1440);
   ObjectSet("SignalEMAM1440", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
   ObjectSet("SignalEMAM1440", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
   ObjectSet("SignalEMAM1440", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
   //*****************************************************************************************************
   //Info
   double Price1=iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
   PRC1=DoubleToStr(Price1,Digits);
//----
   if (Show_Smaller_Size ==false)
     {
      if (Show_Price ==true)
        {
         ObjectCreate("Signalprice", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("Signalprice",""+PRC1+"", 20, "Arial",  Orange);
         ObjectSet("Signalprice", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
         ObjectSet("Signalprice", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
         ObjectSet("Signalprice", OBJPROP_YDISTANCE, 66+Shift_UP_DN);
        }
     }
   if (Show_Smaller_Size ==true)
     {
      if (Show_Price ==true)
        {
         ObjectCreate("Signalprice", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("Signalprice",""+PRC1+"", 10, "Arial",  Orange);
         ObjectSet("Signalprice", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
         ObjectSet("Signalprice", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
         ObjectSet("Signalprice", OBJPROP_YDISTANCE, 66+Shift_UP_DN);
        }
     }
   int R1=0,R5=0,R10=0,R20=0,RAvg=0,i=0;
   R1= (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   for(i=1;i<=5;i++)
      R5=R5  +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=10;i++)
      R10= R10 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   for(i=1;i<=20;i++)
      R20= R20 +  (iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/Point;
   R5=R5/5;
   R10=R10/10;
   R20=R20/20;
   RAvg=(R1+R5+R10+R20)/4;
//----
   string HI="",LO="",SPREAD="",PIPS="",DAV="",HILO="",PRC,Pips="",Av="",AV_Yest="";
   color color_pip,color_av;
   double OPEN=iOpen(NULL,1440,0);
   double CLOSE=iClose(NULL,1440,0);
   double SPRD=(Ask - Bid)/Point;
   double High_Today=iHigh(NULL,1440,0);
   double Low_Today=iLow(NULL,1440,0);
   PIPS= DoubleToStr((CLOSE-OPEN)/Point,0);
   SPREAD=(DoubleToStr(SPRD,Digits-4));
   DAV=(DoubleToStr(RAvg,Digits-4));
   AV_Yest= (iHigh(NULL,PERIOD_D1,1)-iLow(NULL,PERIOD_D1,1))/Point;
   HILO=DoubleToStr((High_Today-Low_Today)/Point,0);
//----   
   if (CLOSE>=OPEN) {Pips= "-";color_pip=Green; }
   if (CLOSE < OPEN) {Pips= "-";color_pip=OrangeRed; }
   if (DAV > AV_Yest) {Av= "-";color_av=Green; }
   if (DAV < AV_Yest) {Av= "-";color_av=OrangeRed; }
   if (Show_Smaller_Size ==false)
     {
      if (Show_Xtra_Details==true)
        {
         if (Show_Price ==true)
           {
            ObjectCreate("MMLEVELS7", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS7","Spread", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS7", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS7", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS7", OBJPROP_YDISTANCE, 100+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS8", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS8",""+SPREAD+"", 10, "Arial Bold", Black);
            ObjectSet("MMLEVELS8", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS8", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS8", OBJPROP_YDISTANCE, 100+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS9", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS9","Pips to Open", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS9", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS9", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS9", OBJPROP_YDISTANCE, 115+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS10", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS10",""+PIPS+"", 10, "Arial Bold", color_pip);
            ObjectSet("MMLEVELS10", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS10", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS10", OBJPROP_YDISTANCE, 115+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS11", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS11","Hi to Low", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS11", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS11", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS11", OBJPROP_YDISTANCE, 130+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS12", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS12",""+HILO+"", 10, "Arial Bold", Black);
            ObjectSet("MMLEVELS12", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS12", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS12", OBJPROP_YDISTANCE, 130+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS13", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS13","Daily Av", 10, "Arial",CommentLabel_color);
            ObjectSet("MMLEVELS13", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS13", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS13", OBJPROP_YDISTANCE, 145+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS14", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS14",""+DAV+"", 10, "Arial Bold", color_av);
            ObjectSet("MMLEVELS14", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS14", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS14", OBJPROP_YDISTANCE, 145+Shift_UP_DN);
           }
         }
       }
   //*****************************************************************
   //Shift if price not wanted
   if (Show_Smaller_Size ==false)
     {
      if (Show_Xtra_Details==true)
        {
         if (Show_Price ==false)
           {
            ObjectCreate("MMLEVELS7", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS7","Spread", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS7", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS7", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS7", OBJPROP_YDISTANCE, 60+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS8", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS8",""+SPREAD+"", 10, "Arial Bold", Black);
            ObjectSet("MMLEVELS8", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS8", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS8", OBJPROP_YDISTANCE, 60+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS9", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS9","Pips to Open", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS9", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS9", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS9", OBJPROP_YDISTANCE, 75+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS10", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS10",""+PIPS+"", 10, "Arial Bold", color_pip);
            ObjectSet("MMLEVELS10", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS10", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS10", OBJPROP_YDISTANCE, 75+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS11", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS11","Hi to Low", 10, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS11", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS11", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS11", OBJPROP_YDISTANCE, 90+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS12", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS12",""+HILO+"", 10, "Arial Bold", Black);
            ObjectSet("MMLEVELS12", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS12", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS12", OBJPROP_YDISTANCE, 90+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS13", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS13","Daily Av", 10, "Arial",CommentLabel_color);
            ObjectSet("MMLEVELS13", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS13", OBJPROP_XDISTANCE, 45+Adjust_Side_to_side);
            ObjectSet("MMLEVELS13", OBJPROP_YDISTANCE, 105+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS14", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS14",""+DAV+"", 10, "Arial Bold", color_av);
            ObjectSet("MMLEVELS14", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS14", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS14", OBJPROP_YDISTANCE, 105+Shift_UP_DN);
           }
         }
       }
   //***********************************************************************
   //Smaller type option     
   if (Show_Smaller_Size ==true)
     {
      if (Show_Xtra_Details==true)
        {
         if (Show_Price ==true)
           {
            ObjectCreate("MMLEVELS7", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS7","Spread", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS7", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS7", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS7", OBJPROP_YDISTANCE, 80+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS8", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS8",""+SPREAD+"", 8, "Arial Bold", Black);
            ObjectSet("MMLEVELS8", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS8", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS8", OBJPROP_YDISTANCE, 80+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS9", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS9","Pips to Open", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS9", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS9", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS9", OBJPROP_YDISTANCE, 95+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS10", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS10",""+PIPS+"", 8, "Arial Bold", color_pip);
            ObjectSet("MMLEVELS10", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS10", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS10", OBJPROP_YDISTANCE, 95+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS11", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS11","Hi to Low", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS11", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS11", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS11", OBJPROP_YDISTANCE, 110+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS12", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS12",""+HILO+"", 8, "Arial Bold", Black);
            ObjectSet("MMLEVELS12", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS12", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS12", OBJPROP_YDISTANCE, 110+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS13", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS13","Daily Av", 8, "Arial",CommentLabel_color);
            ObjectSet("MMLEVELS13", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS13", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS13", OBJPROP_YDISTANCE, 125+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS14", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS14",""+DAV+"", 8, "Arial Bold", color_av);
            ObjectSet("MMLEVELS14", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS14", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS14", OBJPROP_YDISTANCE, 125+Shift_UP_DN);
           }
         }
       }
   //****************************************************************
   // Shift if Price not needed
   if (Show_Smaller_Size ==true)
     {
      if (Show_Xtra_Details==true)
        {
         if (Show_Price ==false)
           {
            ObjectCreate("MMLEVELS7", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS7","Spread", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS7", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS7", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS7", OBJPROP_YDISTANCE, 60+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS8", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS8",""+SPREAD+"", 8, "Arial Bold", Black);
            ObjectSet("MMLEVELS8", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS8", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS8", OBJPROP_YDISTANCE, 60+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS9", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS9","Pips to Open", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS9", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS9", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS9", OBJPROP_YDISTANCE, 75+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS10", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS10",""+PIPS+"", 8, "Arial Bold", color_pip);
            ObjectSet("MMLEVELS10", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS10", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS10", OBJPROP_YDISTANCE, 75+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS11", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS11","Hi to Low", 8, "Arial", CommentLabel_color);
            ObjectSet("MMLEVELS11", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS11", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS11", OBJPROP_YDISTANCE, 90+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS12", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS12",""+HILO+"", 8, "Arial Bold", Black);
            ObjectSet("MMLEVELS12", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS12", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS12", OBJPROP_YDISTANCE, 90+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS13", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS13","Daily Av", 8, "Arial",CommentLabel_color);
            ObjectSet("MMLEVELS13", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS13", OBJPROP_XDISTANCE, 40+Adjust_Side_to_side);
            ObjectSet("MMLEVELS13", OBJPROP_YDISTANCE, 105+Shift_UP_DN);
            //
            ObjectCreate("MMLEVELS14", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("MMLEVELS14",""+DAV+"", 8, "Arial Bold", color_av);
            ObjectSet("MMLEVELS14", OBJPROP_CORNER, Corner_of_Chart_RIGHT_TOP);
            ObjectSet("MMLEVELS14", OBJPROP_XDISTANCE, 10+Adjust_Side_to_side);
            ObjectSet("MMLEVELS14", OBJPROP_YDISTANCE, 105+Shift_UP_DN);
           }
         }
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+