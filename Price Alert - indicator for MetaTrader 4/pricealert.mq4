//+------------------------------------------------------------------+
//|                                                   PriceAlert.mq4 |
//|                         Copyright © 2009-2011, www.earnforex.com |
//|           Issues sound alerts when price reaches certain levels. |
//|             			modded by Mn ------------------------    |
//+------------------------------------------------------------------+
#property copyright "EarnForex.com"
#property link      "http://www.earnforex.com"

#property indicator_chart_window

extern double SoundWhenPriceGoesAbove = 0;
extern double SoundWhenPriceGoesBelow = 0;
extern double SoundWhenPriceIsExactly = 0;
extern bool SendEmail=false; //If true e-mail is sent to the e-mail address set in your MT4. E-mail SMTP Server settings should also be configured in your MT4
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if(SoundWhenPriceIsExactly>0)
     {
      ObjectCreate("SoundWhenPriceIsExactly",OBJ_HLINE,0,Time[0],SoundWhenPriceIsExactly);
      ObjectSet("SoundWhenPriceIsExactly",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("SoundWhenPriceIsExactly",OBJPROP_COLOR,Yellow);
      ObjectSet("SoundWhenPriceIsExactly",OBJPROP_WIDTH,1);
     }
   if(SoundWhenPriceGoesAbove>0)
     {
      ObjectCreate("SoundWhenPriceGoesAbove",OBJ_HLINE,0,Time[0],SoundWhenPriceGoesAbove);
      ObjectSet("SoundWhenPriceGoesAbove",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("SoundWhenPriceGoesAbove",OBJPROP_COLOR,Green);
      ObjectSet("SoundWhenPriceGoesAbove",OBJPROP_WIDTH,1);
     }
   if(SoundWhenPriceGoesBelow>0)
     {
      ObjectCreate("SoundWhenPriceGoesBelow",OBJ_HLINE,0,Time[0],SoundWhenPriceGoesBelow);
      ObjectSet("SoundWhenPriceGoesBelow",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("SoundWhenPriceGoesBelow",OBJPROP_COLOR,Red);
      ObjectSet("SoundWhenPriceGoesBelow",OBJPROP_WIDTH,1);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("SoundWhenPriceIsExactly");
   ObjectDelete("SoundWhenPriceGoesAbove");
   ObjectDelete("SoundWhenPriceGoesBelow");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
// added by Mn -----------------------------------------------------------
   if(ObjectGet("SoundWhenPriceGoesAbove",1)!=SoundWhenPriceGoesAbove)
      SoundWhenPriceGoesAbove=ObjectGet("SoundWhenPriceGoesAbove",1);
   if(ObjectGet("SoundWhenPriceGoesBelow",1)!=SoundWhenPriceGoesBelow)
      SoundWhenPriceGoesBelow=ObjectGet("SoundWhenPriceGoesBelow",1);
   if(ObjectGet("SoundWhenPriceIsExactly",1)!=SoundWhenPriceIsExactly)
      SoundWhenPriceIsExactly=ObjectGet("SoundWhenPriceIsExactly",1);
// added by Mn -----------------------------------------------------------

   if((Ask>SoundWhenPriceGoesAbove) && (SoundWhenPriceGoesAbove>0))
     {
      Alert("Price above the alert level.");
      PlaySound("alert.wav");
      SendMail("Price for "+Symbol()+" above the alert level "+Ask,"Price for "+Symbol()+" reached "+Ask+" level, which is above your alert level of "+SoundWhenPriceGoesAbove);
      ObjectDelete("SoundWhenPriceGoesAbove");
      SoundWhenPriceGoesAbove=0;
     }
   if((Bid<SoundWhenPriceGoesBelow) && (SoundWhenPriceGoesBelow>0))
     {
      Alert("Price below the alert level.");
      PlaySound("alert.wav");
      SendMail("Price for "+Symbol()+" below the alert level "+Bid,"Price for "+Symbol()+" reached "+Bid+" level, which is below your alert level of "+SoundWhenPriceGoesBelow);
      ObjectDelete("SoundWhenPriceGoesBelow");
      SoundWhenPriceGoesBelow=0;
     }
   if((Bid==SoundWhenPriceIsExactly) || (Ask==SoundWhenPriceIsExactly))
     {
      Alert("Price is exactly at the alert level.");
      PlaySound("alert.wav");
      SendMail("Price for "+Symbol()+" exactly at the alert level "+Ask,"Price for "+Symbol()+" reached "+Ask+"/"+Bid+" level, which is exactly your alert level of "+SoundWhenPriceIsExactly);
      ObjectDelete("SoundWhenPriceIsExactly");
      SoundWhenPriceIsExactly=0;
     }
   return(0);
  }
//+------------------------------------------------------------------+
