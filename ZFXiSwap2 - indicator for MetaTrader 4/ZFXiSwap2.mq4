//+------------------------------------------------------------------+
//|                                                    ZFXiSwap2.mq4 |
//|                                         Copyright © 2013, ZeonFX |
//|                                 http://www.mql4.com/users/ZeonFX |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013, ZeonFX"
#property link      "http://www.mql4.com/users/ZeonFX"
#property indicator_separate_window

extern string  Symbols   = "EURUSD,GBPUSD,USDCHF";
extern bool    Daydiffpip= true; //pip or %
extern bool    HiLo      = true;
extern int     FontSize  = 10;
extern string  FontName  = "Tahoma";
extern color   FontColor = Silver;
extern color    Color2   = Lime;
extern color    Color3   = Red;
extern color    Color4   = Aqua;
extern color    Color5   = DodgerBlue;
extern color    Color6   = DarkOrange;
//+------------------------------------------------------------------------------------------------------------------+
int     NumberOfinf   = 9;
string  inf[]         = {"Symbol","Bid","LastDayDiff","Spread","Swap Buy","Swap Sell","Hi-Lo Today","Hi-Lo Week","Hi-Lo Mounth"};
int     PosX          = 3;
int     PosY          = 3;
string  ShortName     = "ZFXiSwap2";
string SymbolsArray[1], CurrentSymbol, bid, daydiff, spread, buy, sell, subsar;
double point, hlto, hlwe, hlmo;
int digits, size, Q, G, wsname, X, K;
//+------------------------------------------------------------------+
int init()
  {
RefreshRates();
string delim = ",";
if(StringLen(Symbols)==0)
   {size = 1;}
  else
   {size = 1+StringFindCount(Symbols,delim);}

ArrayResize(SymbolsArray,size);
  if(StringLen(Symbols)>0){StrToStringArray(Symbols,SymbolsArray,delim);}

if(Digits==5||Digits==3){Q=10;G=1000;}
 else{Q=1;G=100;}

if(Digits<4){point=0.01;digits=2;}
 else{point=0.0001;digits=4;}
   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
for(int w=0;w<size;w++)
   {
    ObjectDelete("ZFXiPairs"+w);
    ObjectDelete("ZFXiinf"+w);
    ObjectDelete("ZFXiBid"+w);
    ObjectDelete("ZFXiDayDif"+w);
    ObjectDelete("ZFXiSpread"+w);
    ObjectDelete("ZFXiBuy"+w);
    ObjectDelete("ZFXiSell"+w);
    ObjectDelete("ZFXiHLTO"+w);
    ObjectDelete("ZFXiHLWE"+w);
    ObjectDelete("ZFXiHLMO"+w);
   }
   return(0);
  }
//+------------------------------------------------------------------+
int start()
{
for(int s=0; s<ArraySize(SymbolsArray); s++)
 {
  if(StringLen(SymbolsArray[s])>0)
  {
   CurrentSymbol = StringTrim(SymbolsArray[s]);
  }
 }
if(HiLo){NumberOfinf = 9;}
 else {NumberOfinf = 6;}
  wsname = WindowFind(ShortName);
for(int v=0;v<NumberOfinf;v++)
 {
  CreateLabel("ZFXiinf"+v,wsname,inf[v],FontSize,FontName,FontColor,0,PosX,v*13+PosY+12);
 }
for(int w=0;w<size;w++)
 {
  X = w*55+PosX+90;
  subsar = (StringSubstr(SymbolsArray[w],0,6));
  bid = DoubleToStr(MarketInfo(subsar,MODE_BID),MarketInfo(subsar,MODE_DIGITS));
  if(Daydiffpip==true)daydiff = DoubleToStr((iClose(SymbolsArray[w], PERIOD_D1, 0) - iOpen(SymbolsArray[w], PERIOD_D1, 0))*10000,0);
   else daydiff = DoubleToStr((((MarketInfo(subsar,MODE_BID)/iClose(subsar,PERIOD_D1,1))-1)*100)/Q,2)+"%";
  if(Daydiffpip==true){if (SymbolsArray[w]=="GOLD"||(SymbolsArray[w]=="SILVER")||(StringFind(SymbolsArray[w], "JPY", 0)!= -1)||(StringSubstr(SymbolsArray[w],0,6))=="XAUUSD"||(StringSubstr(SymbolsArray[w],0,6))=="XAGUSD"){
   daydiff = DoubleToStr((iClose(SymbolsArray[w], PERIOD_D1, 0) - iOpen(SymbolsArray[w], PERIOD_D1, 0))*100,0);}}
  spread = DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],13),0)/Q,1);
  buy = DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],18),2),2);
  sell = DoubleToStr(NormalizeDouble(MarketInfo(SymbolsArray[w],19),2),2);
  hlto = (iHigh(SymbolsArray[w],1440,0)-iLow(SymbolsArray[w],1440,0));
  hlwe = (iHigh(SymbolsArray[w],1440*7,0)-iLow(SymbolsArray[w],1440*7,0));
  hlmo = (iHigh(SymbolsArray[w],1440*30,0)-iLow(SymbolsArray[w],1440*30,0));
  
  CreateLabel("ZFXiPairs"+w,wsname,subsar,FontSize,FontName,Color4,0,X,PosY+12);
  CreateLabel("ZFXiBid"+w,wsname,bid,FontSize,FontName,FontColor,0,X,PosY+25);
  CreateLabel("ZFXiDayDif"+w,wsname,daydiff,FontSize,FontName,FontColor,0,X,PosY+38);
  CreateLabel("ZFXiSpread"+w,wsname,spread,FontSize,FontName,Color5,0,X,PosY+51);
  CreateLabel("ZFXiBuy"+w,wsname,buy,FontSize,FontName,Color2,0,X,PosY+64);
  CreateLabel("ZFXiSell"+w,wsname,sell,FontSize,FontName,Color2,0,X,PosY+77);
  if(HiLo){
  CreateLabel("ZFXiHLTO"+w,wsname,DoubleToStr(hlto/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6,0,X,PosY+90);
  CreateLabel("ZFXiHLWE"+w,wsname,DoubleToStr(hlwe/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6,0,X,PosY+103);
  CreateLabel("ZFXiHLMO"+w,wsname,DoubleToStr(hlmo/MarketInfo(SymbolsArray[w],MODE_POINT)/Q,0),FontSize,FontName,Color6,0,X,PosY+116);}
      
 if (SymbolsArray[w]=="GOLD")
    { 
     ObjectSetText("ZFXiPairs"+w,SymbolsArray[w],FontSize,FontName,Gold);
     ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/Q ,1),FontSize,FontName,Color5);
     ObjectSetText("ZFXiHLTO"+w,DoubleToStr(hlto /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLWE"+w,DoubleToStr(hlwe /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLMO"+w,DoubleToStr(hlmo /G /Point,0),FontSize,FontName,Color6);
    }
 if (SymbolsArray[w]=="SILVER")
    {
     ObjectSetText("ZFXiPairs"+w,SymbolsArray[w],FontSize,FontName,Silver);
     ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10 ,1),FontSize,FontName,Color5);
     ObjectSetText("ZFXiHLTO"+w,DoubleToStr(hlto /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLWE"+w,DoubleToStr(hlwe /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLMO"+w,DoubleToStr(hlmo /G /Point,0),FontSize,FontName,Color6);
    }
 if ((StringSubstr(SymbolsArray[w],0,6))=="XAUUSD")
    { 
     ObjectSetText("ZFXiPairs"+w,"GOLD",FontSize,FontName,Gold);
     ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10 ,1),FontSize,FontName,Color5);
     ObjectSetText("ZFXiHLTO"+w,DoubleToStr(hlto /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLWE"+w,DoubleToStr(hlwe /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLMO"+w,DoubleToStr(hlmo /G /Point,0),FontSize,FontName,Color6);
    }
 if ((StringSubstr(SymbolsArray[w],0,6))=="XAGUSD")
    {
     ObjectSetText("ZFXiPairs"+w,"SILVER",FontSize,FontName,Silver);
     ObjectSetText("ZFXiSpread"+w,DoubleToStr(MarketInfo(SymbolsArray[w],13)/10 ,1),FontSize,FontName,Color5);
     ObjectSetText("ZFXiHLTO"+w,DoubleToStr(hlto /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLWE"+w,DoubleToStr(hlwe /G /Point,0),FontSize,FontName,Color6);
     ObjectSetText("ZFXiHLMO"+w,DoubleToStr(hlmo /G /Point,0),FontSize,FontName,Color6);
    }

 if (MarketInfo(subsar,MODE_BID)>iMA(subsar, PERIOD_M1, 1, 0, MODE_EMA, PRICE_CLOSE, 1))
     ObjectSetText("ZFXiBid"+w,bid,FontSize,FontName,Color2);
 if (MarketInfo(subsar,MODE_BID)<iMA(subsar, PERIOD_M1, 1, 0, MODE_EMA, PRICE_CLOSE, 1))
     ObjectSetText("ZFXiBid"+w,bid,FontSize,FontName,Color3);

 if (StrToDouble(daydiff)>0)
     ObjectSetText("ZFXiDayDif"+w,"+"+daydiff,FontSize,FontName,Color2);
 else
     ObjectSetText("ZFXiDayDif"+w,daydiff,FontSize,FontName,Color3);

 if (MarketInfo(SymbolsArray[w],18)>=0)
     ObjectSetText("ZFXiBuy"+w,"+"+buy,FontSize,FontName,Color2);
 else
     ObjectSetText("ZFXiBuy"+w,buy,FontSize,FontName,Color3);

 if (MarketInfo(SymbolsArray[w],19)>=0)
     ObjectSetText("ZFXiSell"+w,"+"+sell,FontSize,FontName,Color2);
 else
     ObjectSetText("ZFXiSell"+w,sell,FontSize,FontName,Color3);
 }
   return(0);
  }
//+------------------------------------------------------------------+
void CreateLabel(string Name, int Window, string Txt, int FontS, string FontName, color FontColor, int Corner, int x, int y)
  {
   if(ObjectFind(Name)!=0) ObjectCreate(Name, OBJ_LABEL, Window, 0, 0);
   ObjectSetText(Name, Txt, FontS, FontName, FontColor);
   ObjectSet(Name, OBJPROP_CORNER, Corner);
   ObjectSet(Name, OBJPROP_XDISTANCE, x);
   ObjectSet(Name, OBJPROP_YDISTANCE, y);
   ObjectSet(Name, OBJPROP_BACK, false );
  }
//+------------------------------------------------------------------+
int StringFindCount(string str, string str2)
//+------------------------------------------------------------------+
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
{
  int c = 0;
  for (int i=0; i<StringLen(str); i++)
    if (StringSubstr(str,i,StringLen(str2)) == str2)  c++;
  return(c);
}
//+------------------------------------------------------------------+
int StrToStringArray(string str, string &a[], string delim=",", string init="")  {
//+------------------------------------------------------------------+
// Breaks down a single string into string array 'a' (elements delimited by 'delim')
  for (int i=0; i<ArraySize(a); i++)
    a[i] = init;
  if (str == "")  return(0);  
  int z1=-1, z2=0;
  if (StringRight(str,1) != delim)  str = str + delim;
  for (i=0; i<ArraySize(a); i++)  {
    z2 = StringFind(str,delim,z1+1);
    if (z2>z1+1)  a[i] = StringSubstr(str,z1+1,z2-z1-1);
    if (z2 >= StringLen(str)-1)   break;
    z1 = z2;
  }
  return(StringFindCount(str,delim));
}
//+------------------------------------------------------------------+
string StringTrim(string str)
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
{
  string outstr = "";
  for(int i=0; i<StringLen(str); i++)  {
    if (StringSubstr(str,i,1) != " ")
      outstr = outstr + StringSubstr(str,i,1);
  }
  return(outstr);
}
//+------------------------------------------------------------------+
string StringRight(string str, int n=1)
//+------------------------------------------------------------------+
// Returns the rightmost N characters of STR, if N is positive
// Usage:    string x=StringRight("ABCDEFG",2)  returns x = "FG"
//
// Returns all but the leftmost N characters of STR, if N is negative
// Usage:    string x=StringRight("ABCDEFG",-2)  returns x = "CDEFG"
{
  if (n > 0)  return(StringSubstr(str,StringLen(str)-n,n));
  if (n < 0)  return(StringSubstr(str,-n,StringLen(str)-n));
  return("");
}
//+------------------------------END---------------------------------+