//+------------------------------------------------------------------+
//|                                             alx_RSI_BANDS_MA.mq4 |
//|                                                       alx_Babon |
//+------------------------------------------------------------------+
#property copyright "alx_Babon"
#property link      "babon82@gmail.com"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Yellow
#property indicator_color2 DarkBlue
#property indicator_color3 White
#property indicator_color4 White
#property indicator_color5 White
//---- input parameters
extern int       RSI_Per=8;
extern int       MA_Per=8;
extern int       Bands_Per=20;
extern int       SmoothType=0;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double Sostoyanie;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string type;
   switch(SmoothType)
   {
   case MODE_EMA: type="EMA";break;
   case MODE_SMMA: type="SMMA";break;
   case MODE_LWMA: type="LWMA";break;
   default: type="LWMA";SmoothType=0;break; // если ни один вариант не подошел
   }

   SetIndexStyle(0,DRAW_LINE,0,1);
   SetIndexBuffer(0,ExtMapBuffer1);//Свойства RSI
   SetIndexLabel(0,"RSI("+RSI_Per+")");
   SetIndexStyle(1,DRAW_LINE,0,2);
   SetIndexBuffer(1,ExtMapBuffer2);//Свойства MA
   SetIndexLabel(1,"MA ("+MA_Per+"), "+type);
   SetIndexStyle(2,DRAW_LINE,2,1);
   SetIndexBuffer(2,ExtMapBuffer3);//Свойства Bands
   SetIndexLabel(2,"Bands ("+Bands_Per+")");
   SetIndexStyle(3,DRAW_LINE,2,1);
   SetIndexBuffer(3,ExtMapBuffer4);//Свойства Bands
   SetIndexLabel(3,"Bands ("+Bands_Per+")");
   SetIndexStyle(4,DRAW_LINE,2,1);
   SetIndexBuffer(4,ExtMapBuffer5);//Свойства Bands
   SetIndexLabel(4,"Bands ("+Bands_Per+")");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int limit,cnt;
   int cnt_rsi,cnt_bb,cnt_ma;
   if (counted_bars==0) 
      {
      limit=Bars-RSI_Per-1;
      for(cnt=limit;cnt>=0;cnt--)
         {
          ExtMapBuffer1[cnt]=iRSI(NULL,0,RSI_Per,PRICE_CLOSE,cnt);
         }
      for(cnt=1;cnt<=Bars;cnt++)
         {
          ExtMapBuffer6[cnt]= iMA(NULL,0,MA_Per,0,SmoothType,PRICE_CLOSE,cnt);
                
         }
      for(cnt=limit-MA_Per;cnt>=0;cnt--)
         {
          ExtMapBuffer2[cnt]=iMAOnArray(ExtMapBuffer1,0,MA_Per,0,SmoothType,cnt);
         }          
      for(cnt=limit-Bands_Per;cnt>=0;cnt--)
         {
          ExtMapBuffer3[cnt]=iBandsOnArray(ExtMapBuffer1,0,Bands_Per,2,0,MODE_LOWER,cnt);
         }
      for(cnt=limit-Bands_Per;cnt>=0;cnt--)
         {
          ExtMapBuffer4[cnt]=iBandsOnArray(ExtMapBuffer1,0,Bands_Per,2,0,MODE_UPPER,cnt);
         }  
      for(cnt=limit-Bands_Per;cnt>=0;cnt--)
         {
          ExtMapBuffer5[cnt]=iBandsOnArray(ExtMapBuffer1,0,Bands_Per,2,0,MODE_MAIN,cnt);
         } 
         
      }
      cnt_rsi=limit;
      cnt_bb=limit-Bands_Per;
      cnt_ma=limit-MA_Per;
      Comment(
               "RSI (",RSI_Per,")=",ExtMapBuffer1[1],"\n",
          "Bolinger (",Bands_Per,")=",ExtMapBuffer5[1],"\n",
                "MA (",MA_Per,")=",ExtMapBuffer2[1],"\n"
                //,"MA CNT (",MA_Per,")=",ExtMapBuffer6[8],"\n"
                //,"CNT_MA (",cnt_ma,")"
             );
//----
      //ObjectCreate("Arrow", OBJ_ARROW, 0, 0, 5);
      //ObjectSet("Arrow",OBJPROP_ARROWCODE,OBJ_PERIOD_M15 | OBJ_PERIOD_H1);
      //ObjectSetText("PivotText", "Pivot Point (DJ)", fontsize, "Arial", 
                 //colorPivot);
//----
   return(0);
  }
//+------------------------------------------------------------------+