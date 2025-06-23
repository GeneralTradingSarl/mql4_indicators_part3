//+------------------------------------------------------------------+
//|                                                       signal.mq4 |
//|                                                      reza rahmad |
//|                                           reiz_gamer@yahoo.co.id |
//+------------------------------------------------------------------+
#property copyright "reza rahmad"
#property link      "reiz_gamer@yahoo.co.id"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_color1 Blue
#property indicator_color2 Red
//--- indicator buffers
extern string    ma= "moving average";
extern int       MAperiod = 5;
extern int       Shift = 2;
extern string    sa= "stohastic";
extern int       Kperiod = 14;
extern int       Dperiod = 3;
extern int        Slowing = 3;
extern string    adx= "adx";
extern int        adxperiod = 14;

extern double    poin =100;
extern bool arrowmacd = true;
double buy[];
double sell[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//--- indicator buffers mapping
  SetIndexStyle(0,DRAW_ARROW,EMPTY,3,Green);
   SetIndexArrow(0,233);
   SetIndexBuffer(0,buy);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,3,Red);
   SetIndexArrow(1,234);
   SetIndexBuffer(1,sell);
   SetIndexEmptyValue(1,0.0);
   
   ObjectCreate("signals",OBJ_LABEL,0,0,0,0,0);
          ObjectSet("signals",OBJPROP_CORNER,1);
         ObjectSet("signals",OBJPROP_XDISTANCE,50);         
         ObjectSet("signals",OBJPROP_YDISTANCE,80);        
         ObjectSetText("signals","TAHAN",40,"Times New Roman",Magenta);
      
      ObjectCreate("signals1",OBJ_LABEL,0,0,0,0,0);
          ObjectSet("signals1",OBJPROP_CORNER,1);
         ObjectSet("signals1",OBJPROP_XDISTANCE,50);         
         ObjectSet("signals1",OBJPROP_YDISTANCE,20);        
         ObjectSetText("signals1","created by reza rahmad",15,"Times New Roman",Magenta);
   return(0);
  }
  
int deinit()
{

ObjectDelete("signals");
ObjectDelete("signals1");

return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
double Main0,Main1,Sig0,Sig1;
   int macd;
 
  

   int counted_bars=IndicatorCounted(),
       limit;
 
if(counted_bars>0)
      counted_bars--;
   
   limit=Bars-counted_bars;
   
   if(limit>poin)
      limit=poin;
  
 
  for(int i=0;i<limit;i++)
  { 
       
    Main0=  iStochastic(NULL,0,Kperiod,Dperiod,Slowing,MODE_SMA,0,MODE_MAIN,i);
    Main1 = iStochastic(NULL,0,Kperiod,Dperiod,Slowing,MODE_SMA,0,MODE_MAIN,i+1);
    Sig0 =iStochastic(NULL,0,Kperiod,Dperiod,Slowing,MODE_SMA,0,MODE_SIGNAL,i);
    Sig1 =iStochastic(NULL,0,Kperiod,Dperiod,Slowing,MODE_SMA,0,MODE_SIGNAL,i+1);
    
    buy [i] = 0; sell [i] = 0;
    if (Main0 > Sig0 && Main1 < Sig1 && High[i] > iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i) && Low[i] > iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i))
    {
        macd = 1;
     if (arrowmacd==true)
     {
      buy [i] = Low [i] - 5 * Point;
      
      if (Period () >= PERIOD_M30) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_H1) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_H4) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_D1) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_W1) buy [i] -= 12 * Point;
      if (Period () >= PERIOD_MN1) buy [i] -= 60 * Point;
      }
      
    }
     if (Main0 > Sig0 && Main1 < Sig1 && High[i] > iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i)&& Low[i] < iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i))
    {
      buy [i] = Low [i] - 5 * Point;
      
      if (Period () >= PERIOD_M30) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_H1) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_H4) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_D1) buy [i] -= 8 * Point;
      if (Period () >= PERIOD_W1) buy [i] -= 12 * Point;
      if (Period () >= PERIOD_MN1) buy [i] -= 60 * Point;
      }
    
    
    if (Main0 < Sig0 && Main1 > Sig1 && Low[i] < iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i)&& High[i] > iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i ))
    {
       macd = 2;
     if (arrowmacd==true){
      sell [i] = High [i] + 5 * Point;
      
       if (Period () >= PERIOD_M30) sell [i] += 8 * Point;
      if (Period () >= PERIOD_H1) sell [i] += 8 * Point;
      if (Period () >= PERIOD_H4) sell [i] += 8 * Point;
      if (Period () >= PERIOD_D1) sell [i] += 8 * Point;
      if (Period () >= PERIOD_W1) sell [i] += 12 * Point;
      if (Period () >= PERIOD_MN1) sell [i] += 60 * Point;
        
      }      
    }  
     if (Main0 < Sig0 && Main1 > Sig1 && Low[i] < iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i)&& High[i] < iMA(NULL,0,MAperiod,Shift,MODE_SMA,PRICE_TYPICAL,i ))
     {
          sell [i] = High [i] + 5 * Point;
     if (Period () >= PERIOD_M30) sell [i] += 8 * Point;
      if (Period () >= PERIOD_H1) sell [i] += 8 * Point;
      if (Period () >= PERIOD_H4) sell [i] += 8 * Point;
      if (Period () >= PERIOD_D1) sell [i] += 8 * Point;
      if (Period () >= PERIOD_W1) sell [i] += 12 * Point;
      if (Period () >= PERIOD_MN1) sell [i] += 60 * Point;
        
     
     }
    if(iADX(NULL,0,adxperiod,PRICE_CLOSE,MODE_MINUSDI,0)>iADX(NULL,0,14,PRICE_CLOSE,MODE_PLUSDI,0)){
       ObjectSetText("signals", "Trend SELL", 20, "Tahoma", Tomato);
      
      }else
      {
       ObjectSetText("signals", "Trend  BUY", 20, "Tahoma",Green );
    
      }
      

    
      
    
  }
  
   return(0);
  }
//+------------------------------------------------------------------+
