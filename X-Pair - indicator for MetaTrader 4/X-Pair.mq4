//+------------------------------------------------------------------+
//|                                                           X-Pair |
//|                                         http://www.forex-tsd.com |
//|                            mladen,cja,Xard,ihldiaf,FxSniper,igor |
//+------------------------------------------------------------------+
#property indicator_chart_window
//----
extern string BuySeLL_Settings0="--------------------------";
extern string GBPJPY="  ";
extern string EURUSD="  ";
extern string GBPUSD="  ";
extern string AUDUSD="  ";
extern string USDCAD="  ";
extern string USDJPY="  ";
extern string USDCHF="  ";
extern string DOW="  ";
extern string OIL="  ";
extern string GOLD="  ";
//----
extern int Jendela=0;
extern int Sisi=0;
extern string BuySeLL_Settings1="--------------------------";
extern int TF1=30;
extern int TF2=15;
extern int TF3=5;
extern string BuySeLL_Settings2="--------------------------";
extern int MAFastPeriod=2;
extern int MAFastMethod=3;
extern int MAFastApply_To=0;
extern int MAFastShift=0;
extern string BuySeLL_Settings3="--------------------------";
extern int MASlowPeriod=4;
extern int MASlowMethod=3;
extern int MASlowApply_To=1;
extern int MASlowShift=0;
extern string BuySeLL_Settings4="--------------------------";
extern color Cross_Buy =DodgerBlue;
extern color Cross_Sell=Tomato;
extern string TextColor_Settings="--------------------------";
extern color d1_Color=White;
extern color d2_Color=White;
extern color d3_Color=White;
extern color d4_Color=White;
extern color d5_Color=White;
extern color d6_Color=White;
extern color d7_Color=White;
extern color d8_Color=White;
extern color d9_Color=White;
extern color d10_Color=White;
//----
string CrossUp ="p"; // pakai font "Wingdings 3"
string CrossDn ="q"; // pakai font "Wingdings 3"
//----
double vA, vB, d1, d2,d3,d4,d5,d6,d7,d8,d9,d10;
string BSstatus, BSstatus1, BSstatus2, BSstatus3, Panah;
color  BS_color;
int nDigits;
//----
int init()
  {
   if(Symbol()=="YM") {d1=2;d2=4;d3=4;d4=4;d5=4;d6=2;d7=4;d8=0;d9=2;d10=2;}
   if(Symbol()=="GBPJPY" || Symbol()=="USDJPY" || Symbol()=="WTI" || Symbol()=="XAU") {d1=0;d2=2;d3=2;d4=2;d5=2;d6=0;d7=2;d8=-2;d9=0;d10=0;}
   if(Symbol()=="AUDUSD" || Symbol()=="USDCAD" || Symbol()=="EURUSD" || Symbol()=="GBPUSD") {d1=-2;d2=0;d3=0;d4=0;d5=0;d6=-2;d7=0;d8=-4;d9=-2;d10=-2;}
//----
   return(0);
  }
//----
int deinit()
  {
//----
   for(int i=ObjectsTotal() - 1; i>=0; i--)
     {
      string label=ObjectName(i);
      if(StringSubstr(label, 0, 3)!="MPS")
         continue;
      ObjectDelete(label);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   //----
   Write("MPS_21", Jendela, Sisi, 10, 16, "GBPJPY", 9, "Arial Bold", d1_Color);
   vA=iMA("GBPJPY", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPJPY", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_22", Jendela, Sisi, 70, 16, Panah, 11, "Wingdings 3", BS_color);
//----
   double Gbpjpy=MarketInfo("GBPJPY",MODE_BID);
   Write("MPS_95", Jendela, Sisi, 135, 16, DoubleToStr(Gbpjpy,Digits+d1)+"   "+GBPJPY, 11, "Arial Bold", d1_Color );
//----
   vA=iMA("GBPJPY", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPJPY", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_23", Jendela, Sisi, 90, 16, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("GBPJPY", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPJPY", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_24", Jendela, Sisi, 110, 16, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_01", Jendela, Sisi, 10, 30, "EURUSD", 9, "Arial Bold", d1_Color);
   vA=iMA("EURUSD", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("EURUSD", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_02", Jendela, Sisi, 70, 30, Panah, 11, "Wingdings 3", BS_color);
//----
   double Eurusd=MarketInfo("EURUSD",MODE_BID);
   Write("MPS_94", Jendela, Sisi, 135, 30, DoubleToStr(Eurusd,Digits+d2)+"   "+EURUSD, 11, "Arial Bold", d2_Color );
//----
   vA=iMA("EURUSD", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("EURUSD", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_03", Jendela, Sisi, 90, 30, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("EURUSD", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("EURUSD", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_04", Jendela, Sisi, 110, 30, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_11", Jendela, Sisi, 10, 44, "GBPUSD", 9, "Arial Bold", d3_Color);
   vA=iMA("GBPUSD", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPUSD", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_12", Jendela, Sisi, 70, 44, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("GBPUSD", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPUSD", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_13", Jendela, Sisi, 90, 44, Panah, 11, "Wingdings 3", BS_color);
//----
   double Gbpusd=MarketInfo("GBPUSD",MODE_BID);
   Write("MPS_91", Jendela, Sisi, 135, 44, DoubleToStr(Gbpusd,Digits+d3)+"   "+GBPUSD, 11, "Arial Bold", d3_Color );
//----
   vA=iMA("GBPUSD", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("GBPUSD", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_14", Jendela, Sisi, 110, 44, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_16", Jendela, Sisi, 10, 58, "AUDUSD", 9, "Arial Bold", d4_Color);
   vA=iMA("AUDUSD", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("AUDUSD", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_17", Jendela, Sisi, 70, 58, Panah, 11, "Wingdings 3", BS_color);
//----
   double Audusd=MarketInfo("AUDUSD",MODE_BID);
   Write("MPS_20", Jendela, Sisi, 135, 58, DoubleToStr(Audusd,Digits+d4)+"   "+AUDUSD, 11, "Arial Bold", d4_Color );
//----
   vA=iMA("AUDUSD", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("AUDUSD", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_18", Jendela, Sisi, 90, 58, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("AUDUSD", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("AUDUSD", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_19", Jendela, Sisi, 110, 58, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_26", Jendela, Sisi, 10, 86, "USDCAD", 9, "Arial Bold", d5_Color);
   vA=iMA("USDCAD", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCAD", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_27", Jendela, Sisi, 70, 86, Panah, 11, "Wingdings 3", BS_color);
//----
   double Usdcad=MarketInfo("USDCAD",MODE_BID);
   Write("MPS_30", Jendela, Sisi, 135, 86, DoubleToStr(Usdcad,Digits+d5)+"   "+USDCAD, 11, "Arial Bold", d5_Color );
//----
   vA=iMA("USDCAD", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCAD", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_28", Jendela, Sisi, 90, 86, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("USDCAD", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCAD", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_29", Jendela, Sisi, 110, 86, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_06", Jendela, Sisi, 10, 100, "USDJPY", 9, "Arial Bold", d6_Color);
   vA=iMA("USDJPY", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDJPY", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_07", Jendela, Sisi, 70, 100, Panah, 11, "Wingdings 3", BS_color);
//----
   double Usdjpy=MarketInfo("USDJPY",MODE_BID);
   Write("MPS_93", Jendela, Sisi, 135, 100, DoubleToStr(Usdjpy,Digits+d6)+"   "+USDJPY, 11, "Arial Bold", d6_Color );
//----
   vA=iMA("USDJPY", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDJPY", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_08", Jendela, Sisi, 90, 100, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("USDJPY", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDJPY", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_09", Jendela, Sisi, 110, 100, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_46", Jendela, Sisi, 10, 114, "USDCHF", 9, "Arial Bold", d7_Color);
   vA=iMA("USDCHF", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCHF", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_47", Jendela, Sisi, 70, 114, Panah, 11, "Wingdings 3", BS_color);
//----
   double Usdchf=MarketInfo("USDCHF",MODE_BID);
   Write("MPS_92", Jendela, Sisi, 135, 114, DoubleToStr(Usdchf,Digits+d7)+"   "+USDCHF, 11, "Arial Bold", d7_Color );
//----
   vA=iMA("USDCHF", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCHF", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_48", Jendela, Sisi, 90, 114, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("USDCHF", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("USDCHF", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_49", Jendela, Sisi, 110, 114, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_66", Jendela, Sisi, 10, 142, "DOW", 9, "Arial Bold", d8_Color);
   vA=iMA("YM", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("YM", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_67", Jendela, Sisi, 70, 142, Panah, 11, "Wingdings 3", BS_color);
//----
   double Dow=MarketInfo("YM",MODE_BID);
   Write("MPS_70", Jendela, Sisi, 135, 142, DoubleToStr(Dow,Digits+d8)+"   "+DOW, 11, "Arial Bold", d8_Color );
//----
   vA=iMA("YM", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("YM", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_68", Jendela, Sisi, 90, 142, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("YM", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("YM", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_69", Jendela, Sisi, 110, 142, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_56", Jendela, Sisi, 10, 156, "OIL", 9, "Arial Bold", d9_Color);
   vA=iMA("WTI", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("WTI", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_57", Jendela, Sisi, 70, 156, Panah, 11, "Wingdings 3", BS_color);
//----
   double Oil=MarketInfo("WTI",MODE_BID);
   Write("MPS_60", Jendela, Sisi, 135, 156, DoubleToStr(Oil,Digits+d9)+"   "+OIL, 11, "Arial Bold", d9_Color );
//----
   vA=iMA("WTI", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("WTI", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_58", Jendela, Sisi, 90, 156, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("WTI", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("WTI", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_59", Jendela, Sisi, 110, 156, Panah, 11, "Wingdings 3", BS_color);
//----
   Write("MPS_76", Jendela, Sisi, 10, 170, "GOLD", 9, "Arial Bold", d10_Color);
   vA=iMA("XAU", TF3, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("XAU", TF3, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus3="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus3="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_77", Jendela, Sisi, 70, 170, Panah, 11, "Wingdings 3", BS_color);
//----
   double Xau=MarketInfo("XAU",MODE_BID);
   Write("MPS_80", Jendela, Sisi, 135, 170, DoubleToStr(Xau,Digits+d10)+"   "+GOLD, 11, "Arial Bold", d10_Color );
//----
   vA=iMA("XAU", TF2, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("XAU", TF2, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus2="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus2="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_78", Jendela, Sisi, 90, 170, Panah, 11, "Wingdings 3", BS_color);
//----
   vA=iMA("XAU", TF1, MAFastPeriod, MAFastShift, MAFastMethod, MAFastApply_To, 0);
   vB=iMA("XAU", TF1, MASlowPeriod, MASlowShift, MASlowMethod, MASlowApply_To, 0);
   if (vA>vB)
   { BSstatus1="BUY"; Panah=CrossUp; BS_color=Cross_Buy;}
   else { BSstatus1="SELL"; Panah=CrossDn; BS_color=Cross_Sell;}
   Write("MPS_79", Jendela, Sisi, 110, 170, Panah, 11, "Wingdings 3", BS_color);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Write Procedure                                                  |
//+------------------------------------------------------------------+
void Write(string LBL, int window, double side, int pos_x, int pos_y, string text, int fontsize, string fontname, color Tcolor=CLR_NONE)
  {
   ObjectCreate(LBL, OBJ_LABEL, 0, 0, 0);
   ObjectSet(LBL, OBJPROP_CORNER, side);
   ObjectSet(LBL, OBJPROP_XDISTANCE, pos_x);
   ObjectSet(LBL, OBJPROP_YDISTANCE, pos_y+40);
   ObjectSetText(LBL,text, fontsize, fontname, Tcolor);
  }
//+------------------------------------------------------------------+ame, Tcolor);
  }
//+------------------------------------------------------------------+