//+------------------------------------------------------------------+
//|                                            UpDown_Resistance.mq4 |
//|                                                          Z.R Lin |
//|                                        onlycherishlove@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Z.R Lin"
#property link      "onlycherishlove@gmail.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
extern string PERIOD="";
extern double period=6;//the period of MA
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   ObjectCreate("Resistance",OBJ_HLINE,0,0,0,0,0);
   ObjectCreate("Support",OBJ_HLINE,0,0,0,0,0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("Resistance");
   ObjectDelete("Support");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double F1=0,F3=0,MA1,MA2,MA3;
   int    B1,B2,SR=1;
   while(F3==0)
     {
      MA1=iMA(NULL,0,period,0,MODE_SMA,PRICE_CLOSE,SR);
      MA2=iMA(NULL,0,period,0,MODE_SMA,PRICE_CLOSE,SR+1);
      MA3=iMA(NULL,0,period,0,MODE_SMA,PRICE_CLOSE,SR+2);
      if(MA1!=0)
        {
         if(MA1<MA2 && MA2>MA3)
           {
            B1=SR+1;F1=MA1;
           }
         else if(MA1>MA2 && MA2<MA3)
           {
            B2=SR+1;F3=MA1;
           }
        }
      SR++;
     }

   ObjectSet("Resistance",OBJPROP_PRICE1,iHigh(NULL,0,B1));
   ObjectSet("Resistance",OBJPROP_COLOR,Blue);
   ObjectSet("Resistance",OBJPROP_WIDTH,3);
   ObjectSet("Support",OBJPROP_PRICE1,iLow(NULL,0,B2));
   ObjectSet("Support",OBJPROP_COLOR,Red);
   ObjectSet("Support",OBJPROP_WIDTH,3);
   return(0);
  }
//+------------------------------------------------------------------+
