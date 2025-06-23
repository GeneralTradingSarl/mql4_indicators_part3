//+------------------------------------------------------------------+
//|                                                                  |
//|                                            ///SK-Days of Week/// |
//|                                        ///Developed by Soheil/// |
//|                                        ///Soheil.4x@Gmail.com/// |
//+------------------------------------------------------------------+
#property copyright "Soheil"
#property indicator_chart_window

//---- input parameters
extern int    BarCount=5000;
extern double TextDistance=14;
extern string Font="Britannic Bold";
extern int    FontSize=11;
extern color  TextColor_Mon=Orange;
extern color  TextColor_Tue=Red;
extern color  TextColor_Wed=DeepSkyBlue;
extern color  TextColor_Thr=LimeGreen;
extern color  TextColor_Fri=Violet;
extern color  TextColor_Sun=CLR_NONE;
extern color  TextColor_Sat=CLR_NONE;
//----Variables
string dayW;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   TextDistance=TextDistance/100;
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i=0;i<Bars;i++)
     {
      ObjectDelete("Mon"+iTime(Symbol(),0,i));
      ObjectDelete("Tue"+iTime(Symbol(),0,i));
      ObjectDelete("Wed"+iTime(Symbol(),0,i));
      ObjectDelete("Thr"+iTime(Symbol(),0,i));
      ObjectDelete("Fri"+iTime(Symbol(),0,i));
      ObjectDelete("Sat"+iTime(Symbol(),0,i));
      ObjectDelete("Sun"+iTime(Symbol(),0,i));
     }
   return(1);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i--;

   if(counted_bars<0 || BarCount<0) return(-1);

   while(i>=0)
     {
      if(TimeDayOfWeek(Time[i])==1 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Mon"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Mon",FontSize,Font,TextColor_Mon);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==2 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Tue"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Tue",FontSize,Font,TextColor_Tue);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==3 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Wed"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Wed",FontSize,Font,TextColor_Wed);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==4 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Thr"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Thr",FontSize,Font,TextColor_Thr);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==5 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Fri"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Fri",FontSize,Font,TextColor_Fri);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==6 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Sat"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Sat",FontSize,Font,TextColor_Sat);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      if(TimeDayOfWeek(Time[i])==0 && TimeHour(Time[i])==0 && TimeMinute(Time[i])==0)
        {
         dayW="Sun"+iTime(Symbol(),0,i);
         ObjectCreate(dayW,OBJ_TEXT,0,Time[i],High[i]+Fasele_ATR(TextDistance,i));
         ObjectSetText(dayW,"Sun",FontSize,Font,TextColor_Sun);
         ObjectSet(dayW,OBJPROP_PRICE1,High[i]+Fasele_ATR(TextDistance,i));
        }

      i--;

     }

   return(0);
  }
//+------------------------------------------------------------------+
//| Fasele ATR                                                       |
//+------------------------------------------------------------------+
double Fasele_ATR(double TextDistance1,int t)
  {
   double Fasele_ATR=TextDistance1*iATR(NULL,PERIOD_D1,5,t);
   return(Fasele_ATR);
  }
//+------------------------------------------------------------------+
//| End of Program                                                   |
//+------------------------------------------------------------------+
