#property copyright "Copyright 2009 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

  extern  int TextSize=14;
  extern color TextColor1=Red;
  extern color TextColor2=Green;

int eyear=9999;
int emonth=9;
int eday=9;

string Name="wajdyss Account Information Indicator";

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
  Comment("");
 ObjectDelete("a label");
 ObjectDelete("b label");
 ObjectDelete("c label");
 ObjectDelete("d label");
 ObjectDelete("e label");
 ObjectDelete("f label");
 ObjectDelete("g label");
 ObjectDelete("h label");
 ObjectDelete("i label");
 ObjectDelete("j label");
 ObjectDelete("k label");
 ObjectDelete("l label");
 ObjectDelete("m label");
 ObjectDelete("n label");


   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  Comment("");
 ObjectDelete("a label");
 ObjectDelete("b label");
 ObjectDelete("c label");
 ObjectDelete("d label");
 ObjectDelete("e label");
 ObjectDelete("f label");
 ObjectDelete("g label");
 ObjectDelete("h label");
 ObjectDelete("i label");
 ObjectDelete("j label");
 ObjectDelete("k label");
 ObjectDelete("l label");
 ObjectDelete("m label");
 ObjectDelete("n label");

  //a
   
   {
      ObjectCreate("a label", OBJ_LABEL, 0,0,0);
      ObjectSetText("a label","»”„ «··Â «·—Õ„‰ «·—ÕÌ„" , TextSize, "Arial", Green);
      ObjectSet("a label", OBJPROP_XDISTANCE,350);
     ObjectSet("a label", OBJPROP_YDISTANCE,5);
   }
   
   //b
   
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label",Name  , TextSize, "Arial", Black);
      ObjectSet("b label", OBJPROP_XDISTANCE,275);
     ObjectSet("b label", OBJPROP_YDISTANCE,30);
   }
   
   // c
    
   {
      ObjectCreate("c label", OBJ_LABEL, 0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com"  , TextSize, "Arial", Blue);
      ObjectSet("c label", OBJPROP_XDISTANCE,335);
     ObjectSet("c label", OBJPROP_YDISTANCE,55);
   }

   // d

   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","Account Number      : "+AccountNumber()  , TextSize, "Arial", TextColor2);
      ObjectSet("d label", OBJPROP_XDISTANCE,0);
     ObjectSet("d label", OBJPROP_YDISTANCE,80);
   }

   // e

   {
      ObjectCreate("e label", OBJ_LABEL, 0,0,0);
      ObjectSetText("e label","Account Name         : "+AccountName()  , TextSize, "Arial", TextColor1);
      ObjectSet("e label", OBJPROP_XDISTANCE,0);
     ObjectSet("e label", OBJPROP_YDISTANCE,100);
   }

   // f
   {
      ObjectCreate("f label", OBJ_LABEL, 0,0,0);
      ObjectSetText("f label","Account Company   : "+AccountCompany() , TextSize, "Arial", TextColor2);
      ObjectSet("f label", OBJPROP_XDISTANCE,0);
     ObjectSet("f label", OBJPROP_YDISTANCE,120);
   }

   // g

   {
      ObjectCreate("g label", OBJ_LABEL, 0,0,0);
      ObjectSetText("g label","Account Server        : "+AccountServer()  , TextSize, "Arial", TextColor1);
      ObjectSet("g label", OBJPROP_XDISTANCE,0);
     ObjectSet("g label", OBJPROP_YDISTANCE,140);
   }

   // h
   {
      ObjectCreate("h label", OBJ_LABEL, 0,0,0);
      ObjectSetText("h label","Account Currency    : "+AccountCurrency()  , TextSize, "Arial", TextColor2);
      ObjectSet("h label", OBJPROP_XDISTANCE,0);
     ObjectSet("h label", OBJPROP_YDISTANCE,160);
   }

   // i

   {
      ObjectCreate("i label", OBJ_LABEL, 0,0,0);
      ObjectSetText("i label","Account Leverage    : "+AccountLeverage()   , TextSize, "Arial", TextColor1);
      ObjectSet("i label", OBJPROP_XDISTANCE,0);
     ObjectSet("i label", OBJPROP_YDISTANCE,180);
   }

   // j
   {
      ObjectCreate("j label", OBJ_LABEL, 0,0,0);
      ObjectSetText("j label",  "Account Balance      : "+DoubleToStr(AccountBalance(),2) , TextSize, "Arial", TextColor2);
      ObjectSet("j label", OBJPROP_XDISTANCE,0);
     ObjectSet("j label", OBJPROP_YDISTANCE,200);
   }

   // k
   {
      ObjectCreate("k label", OBJ_LABEL, 0,0,0);
      ObjectSetText("k label", "Account Equity         : "+DoubleToStr(AccountEquity(),2) , TextSize, "Arial", TextColor1);
      ObjectSet("k label", OBJPROP_XDISTANCE,0);
     ObjectSet("k label", OBJPROP_YDISTANCE,220);
   }

   // l
   {
      ObjectCreate("l label", OBJ_LABEL, 0,0,0);
      ObjectSetText("l label","Account Profit           : "+DoubleToStr(AccountProfit(),2) , TextSize, "Arial", TextColor2);
      ObjectSet("l label", OBJPROP_XDISTANCE,0);
     ObjectSet("l label", OBJPROP_YDISTANCE,240);
   }

   // m
   {
      ObjectCreate("m label", OBJ_LABEL, 0,0,0);
      ObjectSetText("m label","Account FreeMargin : "+DoubleToStr(AccountFreeMargin(),2) , TextSize, "Arial", TextColor1);
      ObjectSet("m label", OBJPROP_XDISTANCE,0);
     ObjectSet("m label", OBJPROP_YDISTANCE,260);
   }


   // n
   {
      ObjectCreate("n label", OBJ_LABEL, 0,0,0);
      ObjectSetText("n label","Account Margin        : "+DoubleToStr(AccountMargin(),2) , TextSize, "Arial", TextColor2);
      ObjectSet("n label", OBJPROP_XDISTANCE,0);
     ObjectSet("n label", OBJPROP_YDISTANCE,280);
   }



   return(0);
  }

