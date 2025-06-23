//+------------------------------------------------------------------+
//|                                            sideway or  trend.mq4 |
//|                                                      reza rahmad |
//|                                           reiz_gamer@yahoo.co.id |
//+------------------------------------------------------------------+
#property copyright "reza rahmad"
#property link      "reiz_gamer@yahoo.co.id"

#property indicator_chart_window
extern int period_adx = 14;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators 
        ObjectCreate("side",OBJ_LABEL,0,0,0,0,0);
         ObjectSet("side",OBJPROP_XDISTANCE,40);         
         ObjectSet("side",OBJPROP_YDISTANCE,40);        
         
         
         ObjectCreate("side1",OBJ_LABEL,0,0,0,0,0);
         ObjectSet("side1",OBJPROP_XDISTANCE,80);
         ObjectSet("side1",OBJPROP_YDISTANCE,60);
         
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
ObjectDelete("side");
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
//----
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0)&& iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) >iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0)) 
   {
   ObjectSet("side",OBJPROP_CORNER,1);
    ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","SIDEWAY BUY",15,"TAHOMA",Magenta);
   ObjectSetText("side1",CharToStr(75),30,"Wingdings",Magenta);
   
   }
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0)&& iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) < iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0)) 
   { ObjectSet("side",OBJPROP_CORNER,1);
   ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","SIDEWAY SELL",15,"TAHOMA",Magenta);
    ObjectSetText("side1",CharToStr(75),30,"Wingdings",Magenta);
   }
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) > iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0 && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0) < 20) ) 
   {
   ObjectSet("side",OBJPROP_CORNER,1);
    ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","SIDEWAY BUY",15,"TAHOMA",Magenta);
   ObjectSetText("side1",CharToStr(75),30,"Wingdings",Magenta);
   
   }
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) < iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0 && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0) < 20) ) 
   { ObjectSet("side",OBJPROP_CORNER,1);
   ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","SIDEWAY SELL",15,"TAHOMA",Magenta);
    ObjectSetText("side1",CharToStr(75),30,"Wingdings",Magenta);
   }
   
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)<iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) >iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0))
   {
    ObjectSet("side",OBJPROP_CORNER,1);
    ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","TREND BUY",15,"TAHOMA",Green);
   ObjectSetText("side1",CharToStr(221),30,"Wingdings",Green);
   }
   
   if(iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MAIN,0)<iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0) && iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_PLUSDI,0) < iADX(NULL,0,period_adx,PRICE_CLOSE,MODE_MINUSDI,0))
   {
    ObjectSet("side",OBJPROP_CORNER,1);
    ObjectSet("side1",OBJPROP_CORNER,1);
   ObjectSetText("side","TREND SELL",15,"TAHOMA",Tomato);
    ObjectSetText("side1",CharToStr(222),30,"Wingdings",Tomato);
   }
   
//---

   return(0);
  }
  
//+------------------------------------------------------------------+