//+------------------------------------------------------------------+
//|              indicator                 wajdyss_Moslim_trader.mq4 |
//|                                           Copyright 2007 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Green

extern int hour=10;
extern int minute=15;
extern int TextSize=14;
extern color TextColor1=Black;
extern color TextColor2=Red;
extern color TextColor3=Blue;
extern color TextColor4=White;
color TextColor5=Chartreuse;
//bool manual=true;
//int w=0,ww=0;
double CrossUp1[];
double CrossUp11[];
int eyear=9999;
int emonth=9;
int eday=9;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,CrossUp1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(1,CrossUp11);

//----
   SetIndexDrawBegin(0,5);
//---- indicator buffers mapping
   SetIndexBuffer(0,CrossUp1);
   SetIndexBuffer(1,CrossUp11);

//---- initialization done

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

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//a
   if(ObjectFind("a label")!=0)
     {
      ObjectCreate("a label",OBJ_LABEL,0,0,0);
      ObjectSetText("a label","ÈÓã Çááå ÇáÑÍãä ÇáÑÍíã",TextSize,"Arial",TextColor1);
      ObjectSet("a label",OBJPROP_XDISTANCE,350);
      ObjectSet("a label",OBJPROP_YDISTANCE,0);
     }

//b
   if(ObjectFind("b label")!=0)
     {
      ObjectCreate("b label",OBJ_LABEL,0,0,0);
      ObjectSetText("b label","wajdyss V Lines indicator",TextSize,"Arial",TextColor2);
      ObjectSet("b label",OBJPROP_XDISTANCE,315);
      ObjectSet("b label",OBJPROP_YDISTANCE,25);
     }

// c

   if(ObjectFind("c label")!=0)
     {
      ObjectCreate("c label",OBJ_LABEL,0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com",TextSize,"Arial",TextColor3);
      ObjectSet("c label",OBJPROP_XDISTANCE,335);
      ObjectSet("c label",OBJPROP_YDISTANCE,50);
     }

   if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
     {
      //d
      if(ObjectFind("d label")!=0)
        {
         ObjectCreate("d label",OBJ_LABEL,0,0,0);
         ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
         ObjectSet("d label",OBJPROP_XDISTANCE,250);
         ObjectSet("d label",OBJPROP_YDISTANCE,75);
        }
      return(0);
     }
   else
   if(ObjectFind("d label")!=0)
     {
      ObjectCreate("d label",OBJ_LABEL,0,0,0);
      ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
      ObjectSet("d label",OBJPROP_XDISTANCE,265);
      ObjectSet("d label",OBJPROP_YDISTANCE,75);
     }

   if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday)) return(0);
   if(Period()>=1440) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   for(int j=limit;j>=1;j--)
     {
      if(TimeMinute(Time[j])==minute && TimeHour(Time[j])==hour)
        {
         CrossUp1[j]  = 999;
         CrossUp11[j] =  0;
        }
     }
// Comment("Hour = ",TimeHour(iTime(Symbol(),PERIOD_H1,0)));

   return(0);
  }
//+------------------------------------------------------------------+
