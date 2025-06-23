//+------------------------------------------------------------------+
//|                                      wajdyss_H_L_C_indicator.mq4 |
//|                                           Copyright 2008 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
extern int Candle=1;
 int TextSize=14;
 extern color TextColor1=Black;
 extern color TextColor2=Red;
 extern color TextColor3=Blue;
 extern color TextColor4=Black;
 color TextColor5=Chartreuse;
 color TextColor6=DodgerBlue;

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


   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  double H=iHigh(Symbol(),PERIOD_D1,0);
  int H2=H;
  //a
          if(ObjectFind("a label") != 0)
   {
      ObjectCreate("a label", OBJ_LABEL, 0,0,0);
      ObjectSetText("a label","ÈÓã Çááå ÇáÑÍãä ÇáÑÍíã" , TextSize, "Arial", TextColor1);
      ObjectSet("a label", OBJPROP_XDISTANCE,350);
     ObjectSet("a label", OBJPROP_YDISTANCE,0);
   }
   
   //b
      if(ObjectFind("b label") != 0)
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label","wajdyss_Candle_Length_indicator"  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,280);
     ObjectSet("b label", OBJPROP_YDISTANCE,25);
   }
   
   // c

   
      if(ObjectFind("c label") != 0)
   {
      ObjectCreate("c label", OBJ_LABEL, 0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com"  , TextSize, "Arial", TextColor3);
      ObjectSet("c label", OBJPROP_XDISTANCE,335);
     ObjectSet("c label", OBJPROP_YDISTANCE,50);
   }
   
 // if (Period()>1440) return(0);
double A=((iHigh(Symbol(),0,Candle)-iLow(Symbol(),0,Candle))/Point);
int AA=A;
   
    ObjectDelete("d label");
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","Candle Length = "+AA  , TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,340);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);


 //   ObjectDelete("e label");
   //   ObjectCreate("e label", OBJ_LABEL, 0,0,0);
  //    ObjectSetText("e label","today low = "+DoubleToStr(iLow(Symbol(),PERIOD_D1,0),Digits)  , TextSize, "Arial", TextColor5);
  //    ObjectSet("e label", OBJPROP_XDISTANCE,345);
  //   ObjectSet("e label", OBJPROP_YDISTANCE,100);

//    ObjectDelete("f label");
  //    ObjectCreate("f label", OBJ_LABEL, 0,0,0);
    //  ObjectSetText("f label","today close = "+DoubleToStr(iClose(Symbol(),PERIOD_D1,0),Digits)   , TextSize, "Arial", TextColor6);
  //    ObjectSet("f label", OBJPROP_XDISTANCE,340);
   //  ObjectSet("f label", OBJPROP_YDISTANCE,125);
     
   return(0);
  }

