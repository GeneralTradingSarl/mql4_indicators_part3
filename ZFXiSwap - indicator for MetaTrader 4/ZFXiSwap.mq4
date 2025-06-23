//+------------------------------------------------------------------+
//|                                                     ZFXiSwap.mq4 |
//|                                         Copyright © 2013, ZeonFX |
//|                                 http://www.mql4.com/users/ZeonFX |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013, ZeonFX"
#property link      "http://www.mql4.com/users/ZeonFX"
#property indicator_separate_window

extern string  Symbols   = "EURUSD,GBPUSD,USDCHF,AUDUSD,USDJPY,EURJPY,NZDUSD,USDCAD,EURGBP,EURCHF,GBPJPY,GOLD,SILVER";
extern int     FontSize  = 10;
extern string  FontName  = "Tahoma";
extern color   FontColor = Silver;
extern color    Color2   = Lime;
extern color    Color3   = Red;
extern color    Color4   = Aqua;
extern color    Color5   = DodgerBlue;
extern color    Color6   = DarkOrange;
//+------------------------------------------------------------------------------------------------------------------+
int     NumberOfinf=7;
string  inf[]={"Symbol","Spread","Swap Buy","Swap Sell","Hi-Lo Today","Hi-Lo Week","Hi-Lo Mounth"};
int     PosX          = 3;
int     PosY          = 3;
string  ShortName     = "ZFXiSwap";
string SymbolsArray[],CurrentSymbol;
double point;
int digits,size,Q,G;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 
   RefreshRates();
   string delim=",";
   if(StringLen(Symbols)==0)
     {
      size=1;
     }
   else
     {
      size=1+StringFindCount(Symbols,delim);
     }

   ArrayResize(SymbolsArray,size);
   if(StringLen(Symbols)>0){StrToStringArray(Symbols,SymbolsArray,delim);}

   Q=1;
   G=100;

   if(Digits==5 || Digits==3){Q=10;G=1000;}
   else{Q=1;G=100;}

   if(Digits<4){point=0.01;digits=2;}
   else{point=0.0001;digits=4;}
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int w=0;w<size;w++)
     {
      ObjectDelete("ZFXiPairs"+w);
      ObjectDelete("ZFXiinf"+w);
      ObjectDelete("ZFXiSpread"+w);
      ObjectDelete("ZFXiBuy"+w);
      ObjectDelete("ZFXiSell"+w);
      ObjectDelete("ZFXiHLTO"+w);
      ObjectDelete("ZFXiHLWE"+w);
      ObjectDelete("ZFXiHLMO"+w);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   for(int s=0; s<ArraySize(SymbolsArray); s++)
     {
      if(StringLen(SymbolsArray[s])>0)
        {
         CurrentSymbol=StringTrim(SymbolsArray[s]);
        }
     }
//----
   for(int w=0;w<NumberOfinf;w++)
     {
      ObjectCreate("ZFXiinf"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
      ObjectSet("ZFXiinf"+w,OBJPROP_CORNER,0);
      ObjectSet("ZFXiinf"+w,OBJPROP_XDISTANCE,PosX);
      ObjectSet("ZFXiinf"+w,OBJPROP_YDISTANCE,w*13+PosY+12);
      ObjectSetText("ZFXiinf"+w,inf[w],FontSize,FontName,FontColor);
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      ObjectCreate("ZFXiPairs"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
      ObjectSet("ZFXiPairs"+w,OBJPROP_CORNER,0);
      ObjectSet("ZFXiPairs"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
      ObjectSet("ZFXiPairs"+w,OBJPROP_YDISTANCE,PosY+12);
      ObjectSetText("ZFXiPairs"+w,(StringSubstr(SymbolsArray[w],0,6)),FontSize,FontName,Color4);
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      ObjectCreate("ZFXiSpread"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
      ObjectSet("ZFXiSpread"+w,OBJPROP_CORNER,0);
      ObjectSet("ZFXiSpread"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
      ObjectSet("ZFXiSpread"+w,OBJPROP_YDISTANCE,PosY+25);
      ObjectSetText("ZFXiSpread"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],13),0)/Q,1),FontSize,FontName,Color5);
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      ObjectCreate("ZFXiBuy"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
      ObjectSet("ZFXiBuy"+w,OBJPROP_CORNER,0);
      ObjectSet("ZFXiBuy"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
      ObjectSet("ZFXiBuy"+w,OBJPROP_YDISTANCE,PosY+38);
      ObjectSetText("ZFXiBuy"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],18),2),2),FontSize,FontName,Color2);
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      ObjectCreate("ZFXiSell"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
      ObjectSet("ZFXiSell"+w,OBJPROP_CORNER,0);
      ObjectSet("ZFXiSell"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
      ObjectSet("ZFXiSell"+w,OBJPROP_YDISTANCE,PosY+51);
      ObjectSetText("ZFXiSell"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],19),2),2),FontSize,FontName,Color2);
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      if(MarketInfo(SymbolsArray[w],MODE_POINT)!=0)
        {
         ObjectCreate("ZFXiHLTO"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
         ObjectSet("ZFXiHLTO"+w,OBJPROP_CORNER,0);
         ObjectSet("ZFXiHLTO"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
         ObjectSet("ZFXiHLTO"+w,OBJPROP_YDISTANCE,PosY+64);
         ObjectSetText("ZFXiHLTO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0))/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6);
        }
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      if(MarketInfo(SymbolsArray[w],MODE_POINT)!=0)
        {
         ObjectCreate("ZFXiHLWE"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
         ObjectSet("ZFXiHLWE"+w,OBJPROP_CORNER,0);
         ObjectSet("ZFXiHLWE"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
         ObjectSet("ZFXiHLWE"+w,OBJPROP_YDISTANCE,PosY+77);
         ObjectSetText("ZFXiHLWE"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0))/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6);
        }
     }
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      if(MarketInfo(SymbolsArray[w],MODE_POINT)!=0)
        {
         ObjectCreate("ZFXiHLMO"+w,OBJ_LABEL,WindowFind(ShortName),0,0);
         ObjectSet("ZFXiHLMO"+w,OBJPROP_CORNER,0);
         ObjectSet("ZFXiHLMO"+w,OBJPROP_XDISTANCE,w*55+PosX+90);
         ObjectSet("ZFXiHLMO"+w,OBJPROP_YDISTANCE,PosY+90);
         ObjectSetText("ZFXiHLMO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0))/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6);
        }
     }
//----
   for(w=0;w<ArraySize(SymbolsArray);w++)
     {
      if(SymbolsArray[w]=="GOLD")
        {
         ObjectSetText("ZFXiPairs"+w,SymbolsArray[w],FontSize,FontName,Gold);
         ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/Q,1),FontSize,FontName,Color5);
         ObjectSetText("ZFXiHLTO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLWE"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLMO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0))/G/Point,0),FontSize,FontName,Color6);
        }
      if(SymbolsArray[w]=="SILVER")
        {
         ObjectSetText("ZFXiPairs"+w,SymbolsArray[w],FontSize,FontName,Silver);
         ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10,1),FontSize,FontName,Color5);
         ObjectSetText("ZFXiHLTO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLWE"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLMO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0))/G/Point,0),FontSize,FontName,Color6);
        }
      if((StringSubstr(SymbolsArray[w],0,6))=="XAUUSD")
        {
         ObjectSetText("ZFXiPairs"+w,"GOLD",FontSize,FontName,Gold);
         ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10,1),FontSize,FontName,Color5);
         ObjectSetText("ZFXiHLTO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLWE"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLMO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0))/G/Point,0),FontSize,FontName,Color6);
        }
      if((StringSubstr(SymbolsArray[w],0,6))=="XAGUSD")
        {
         ObjectSetText("ZFXiPairs"+w,"SILVER",FontSize,FontName,Silver);
         ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10,1),FontSize,FontName,Color5);
         ObjectSetText("ZFXiHLTO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLWE"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0))/G/Point,0),FontSize,FontName,Color6);
         ObjectSetText("ZFXiHLMO"+w,DoubleToStr((iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0))/G/Point,0),FontSize,FontName,Color6);
        }
      //----
      if(MarketInfo(SymbolsArray[w],18)>=0)
         ObjectSetText("ZFXiBuy"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],18),2),2),FontSize,FontName,Color2);
      else
         ObjectSetText("ZFXiBuy"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],18),2),2),FontSize,FontName,Color3);

      if(MarketInfo(SymbolsArray[w],19)>=0)
         ObjectSetText("ZFXiSell"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],19),2),2),FontSize,FontName,Color2);
      else
         ObjectSetText("ZFXiSell"+w,DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],19),2),2),FontSize,FontName,Color3);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int StringFindCount(string str,string str2)
//+------------------------------------------------------------------+
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
  {
   int c=0;
   for(int i=0; i<StringLen(str); i++)
      if(StringSubstr(str,i,StringLen(str2))==str2) c++;
   return(c);
  }
//+------------------------------------------------------------------+
int StrToStringArray(string str,string &a[],string delim=",",string init="")
  {
//+------------------------------------------------------------------+
// Breaks down a single string into string array 'a' (elements delimited by 'delim')
   for(int i=0; i<ArraySize(a); i++)
      a[i]= init;
   if(str == "")  return(0);
   int z1=-1,z2=0;
   if(StringRight(str,1)!=delim) str=str+delim;
   for(i=0; i<ArraySize(a); i++)
     {
      z2=StringFind(str,delim,z1+1);
      if(z2>z1+1) a[i]=StringSubstr(str,z1+1,z2-z1-1);
      if(z2>=StringLen(str)-1) break;
      z1=z2;
     }
   return(StringFindCount(str,delim));
  }
//+------------------------------------------------------------------+
string StringTrim(string str)
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
  {
   string outstr="";
   for(int i=0; i<StringLen(str); i++)
     {
      if(StringSubstr(str,i,1)!=" ")
         outstr=outstr+StringSubstr(str,i,1);
     }
   return(outstr);
  }
//+------------------------------------------------------------------+
string StringRight(string str,int n=1)
                                    //+------------------------------------------------------------------+
                                    // Returns the rightmost N characters of STR, if N is positive
                                    // Usage:    string x=StringRight("ABCDEFG",2)  returns x = "FG"
                                    //
                                    // Returns all but the leftmost N characters of STR, if N is negative
                                    // Usage:    string x=StringRight("ABCDEFG",-2)  returns x = "CDEFG"
  {
   if(n > 0)  return(StringSubstr(str,StringLen(str)-n,n));
   if(n < 0)  return(StringSubstr(str,-n,StringLen(str)-n));
   return("");
  }
//+------------------------------------------------------------------+
