//+------------------------------------------------------------------+
//|                                          KM-TRADING COMMENTS.mq4 |
//|                                                  Khurram Mustafa |
//|                             https://www.mql5.com/en/users/kc1981 |
//+------------------------------------------------------------------+
#property copyright "KHURRAM MUSTAFA"
#property link      "https://www.mql5.com/en/users/kc1981/seller"
#property version   "1.0"
#property description "TRADING COMMENTS"
#property description "THANKING YOU DODACHARTS FOR HELPED ME TO MAKE THIS INDICATOR"
#property description "RECOMMEND: Higher Time Frames"
#property description "STRATEGY: Always Trades With Minimum Lots For Better Results"
#property description "WISH: My Best Wishes Always With My Friends"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

double myadxvalue;
double ema7, ema14, ema21;
string emaresult, emaresultexit;
bool EMABuyAlert=false, EMASellAlert=false, EMAExitLong=false, EMAExitShort=false, EMABuy = false, EMASell = false, EMABuyExit=False, EMASellExit=False; 
double myatr, mystd,EMAtempvar,EMAtempvarexit;
string atrresult;
int    counted_bars;
int ii;
int EMALastSignal;

double mainvar;
datetime adxtime;

int init()
  {
//---- indicators

ObjectCreate("myema",OBJ_LABEL,0,0,0);
ObjectCreate("myemaexit",OBJ_LABEL,0,0,0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
ObjectDelete("myema");   
ObjectDelete("myemaexit");   
ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  string MyMessage1 = Symbol()+" M"+IntegerToString(Period());
  counted_bars=IndicatorCounted();
//----

    counted_bars=IndicatorCounted();

  ii = Bars - 1;
  counted_bars = IndicatorCounted();
   if ( counted_bars > 1 )
      ii = Bars - counted_bars - 1;
   
   while ( ii >= 1 )
   {   
  
   ema7 = iMA(NULL,0,7,0,MODE_EMA,PRICE_CLOSE,ii);
   ema14 = iMA(NULL,0,14,0,MODE_EMA,PRICE_CLOSE,ii);
   ema21 = iMA(NULL,0,21,0,MODE_EMA,PRICE_CLOSE,ii);
  
  
  if ( ema7 > ema14 && ema7 > ema21 && ema14 > ema21 && EMABuy==False )
       
   {
  emaresult = "Go Long @";
  EMAtempvar = iClose(NULL,0,ii);      
  adxtime = iTime(NULL,0,ii);
  EMALastSignal = 1;
  EMABuy = True;
  EMASell = False;
   
   }
   ////
   /// when to exit long
   if ( ema14 > ema7 && ema14 > ema21  && ema21 > ema7 && EMABuyExit==False )
   {

   emaresultexit = "Exit long @";
  EMAtempvarexit = iClose(NULL,0,ii);      
  EMALastSignal = 11;
  EMABuyExit = True;
  EMASellExit = False;
   
   }
// when to go short
      if ( ema21 > ema7 && ema21 > ema14 && ema14 > ema7 && EMASell==False )
         {
         emaresult = "Go Short @";
         EMAtempvar = iClose(NULL,0,ii);      
         adxtime = iTime(NULL,0,ii);
         EMALastSignal = 2;
         EMASell = True;
         EMABuy = False;
         }   
      
//when to exit short
   if ( ema7 > ema14 && ema7 < ema21 && EMASellExit==False )
   {
   emaresultexit = "Exit short @";
   EMAtempvarexit = iClose(NULL,0,ii);      
   EMALastSignal = 22;
   EMASellExit = true;
   EMABuyExit = False;  
   }
     ii--;
   }  //end of while loop

   if (emaresultexit == "")
      {
         emaresultexit = "No Results";
      }
   if(emaresult == "")
     {
         emaresult = "No Results";
     }
   
if (EMALastSignal ==1)
{
ObjectSetText("myema",StringConcatenate("EMA: ", emaresult, " ", DoubleToStr(EMAtempvar ,Digits),"   " ), 10, "Arial", Green);
ObjectDelete("myHline3");
ObjectDelete("myVline3");
ObjectCreate("myHline3", OBJ_HLINE, 0, adxtime, EMAtempvar, 0, 0);
ObjectCreate("myVline3", OBJ_VLINE, 0, adxtime, EMAtempvar, 0, 0);
ObjectSet("myHline3", OBJPROP_COLOR, Lime);
ObjectSet("myVline3", OBJPROP_COLOR, Lime);   
ObjectSet("myVline3", OBJPROP_STYLE, STYLE_DOT);   
ObjectSet("myHline3", OBJPROP_STYLE, STYLE_DOT);   

}

if (EMALastSignal ==2)
{
ObjectSetText("myema",StringConcatenate("EMA: ", emaresult, " ", DoubleToStr(EMAtempvar ,Digits),"   " ), 10, "Arial", Red);

ObjectDelete("myHline3");
ObjectDelete("myVline3");
ObjectCreate("myHline3", OBJ_HLINE, 0, adxtime, EMAtempvar, 0, 0);
ObjectCreate("myVline3", OBJ_VLINE, 0, adxtime, EMAtempvar, 0, 0);
ObjectSet("myHline3", OBJPROP_COLOR, Red);
ObjectSet("myVline3", OBJPROP_COLOR, Red);   
ObjectSet("myHline3", OBJPROP_STYLE, STYLE_DOT);   
ObjectSet("myVline3", OBJPROP_STYLE, STYLE_DOT);   

}
ObjectSet("myema",OBJPROP_XDISTANCE,250);
ObjectSet("myema",OBJPROP_YDISTANCE,268);
ObjectSet("myema", OBJPROP_CORNER, 3);

ObjectSetText("myemaexit",StringConcatenate("EMA: ", emaresultexit, " ", DoubleToStr(EMAtempvarexit ,Digits)), 10, "Arial", Red);
ObjectSet("myemaexit",OBJPROP_XDISTANCE,260);
ObjectSet("myemaexit",OBJPROP_YDISTANCE,288);
ObjectSet("myemaexit", OBJPROP_CORNER, 3);

//----
   return(0);
  }
//+------------------------------------------------------------------+