//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 1999-2008, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_color5 Red
#property indicator_color6 Blue
//----
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 1
#property indicator_width6 1
//----
extern int TM_Period=7;
extern int TM_Shift=2;
extern int MinADX=22;
extern int MinRisingADX=15;
extern int MoveArrowFromCandleInPoints=10;
extern double NTMinGap=5;
extern bool risingADXoverrides=true;
//----
double SpanA_Buffer[];
double SpanB_Buffer[];
double BufferBuySignals[];
double BufferSellSignals[];
double BufferExitBuySignals[];
double BufferExitSellSignals[];
int a_begin;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   a_begin=TM_Shift;
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(0,SpanB_Buffer);
   SetIndexDrawBegin(0,TM_Period+a_begin-1);
   SetIndexLabel(0,"TM_Period+");
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,SpanA_Buffer);
   SetIndexDrawBegin(1,TM_Period+a_begin-1);
   SetIndexLabel(1,"TM_Period");
   //
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexBuffer(2,BufferBuySignals);
   SetIndexArrow(2,233);
   SetIndexLabel(2,"BUY");
   //
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexBuffer(3,BufferSellSignals);
   SetIndexArrow(3,234);
   SetIndexLabel(3,"SELL");
   //
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexBuffer(4,BufferExitBuySignals);
   SetIndexArrow(4,217);
   SetIndexLabel(4,"CLOSE");
   //
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexBuffer(5,BufferExitSellSignals);
   SetIndexArrow(5,218);
   SetIndexLabel(5,"CLOSE");
   IndicatorShortName("TRENDMGRNT");
//----
   string SymbolText=Symbol();
     if (StringLen(SymbolText)==7){
      SymbolText=StringSubstr(SymbolText, 0,6);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double high,low,price;
//----
   if(Bars<=TM_Period) return(0);
   if(counted_bars<1)
     {
      for(i=1;i<=TM_Period;i++)
        {
         SpanA_Buffer[Bars-i]=0;
         SpanB_Buffer[Bars-i]=0;
         BufferBuySignals[Bars-i]=0;
         BufferSellSignals[Bars-i]=0;
         BufferExitBuySignals[Bars-i]=0;
         BufferExitSellSignals[Bars-i]=0;
        }
     }
   i=Bars-TM_Period;
   if(counted_bars>TM_Period) i=Bars-counted_bars-1;
   while(i>=0)
     {
      high=High[i]; low=Low[i]; k=i-1+TM_Period;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price)  low=price;
         k--;
        }
      SpanA_Buffer[i] =(high+low)/2.0;
      SpanB_Buffer[i] =SpanA_Buffer[i+TM_Shift];
      BufferBuySignals[i]=0;
      BufferSellSignals[i]=0;
      BufferExitBuySignals[i]=0;
      BufferExitSellSignals[i]=0;
//----
        if (CheckClose(i, OP_BUY)==true) 
        {
         BufferExitBuySignals[i]=Low[i]-Point*MoveArrowFromCandleInPoints;
        }
        if (CheckClose(i, OP_SELL)==true) 
        {
         BufferExitSellSignals[i]=High[i]+Point*MoveArrowFromCandleInPoints;
        }
        if (SpanA_Buffer[i]!= SpanB_Buffer[i]) 
        {
           if ((SpanA_Buffer[i] >  SpanB_Buffer[i]) && (SpanA_Buffer[i+1]<= SpanB_Buffer[i+1])) 
           {
              if (CheckAdx(i, OP_BUY)==true) 
              {
               BufferBuySignals[i]=Low[i]-Point*MoveArrowFromCandleInPoints;
                 if (i==1) 
                 {
                  Alert("Buy on TM");
                 }
              }
            else
              {
               BufferBuySignals[i]=0;
              }
           }
           else   if ((SpanA_Buffer[i] <  SpanB_Buffer[i]) && (SpanA_Buffer[i+1]>= SpanB_Buffer[i+1])) 
           {
                 if (CheckAdx(i, OP_SELL)==true) 
                 {
                  BufferSellSignals[i]=High[i]+Point*MoveArrowFromCandleInPoints;
                    if (i==1) 
                    {
                     Alert("Sell on TM");
                    }
                 }
                 else
                 {
                  BufferSellSignals[i]=0;
                 }
              }
        }
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  bool CheckClose(int i, int OrderTyp) 
  {
   bool retval=false;
   // get the WindowFind
   //double NewTrend = iCustom(Symbol(),Period(), 9,9,PRICE_CLOSE,i);
   double NewTrendSilver=iCustom(Symbol(),Period(), "NewTrend",14,9,0, i);
   double NewTrendOrange=iCustom(Symbol(),Period(), "NewTrend",14,9,1, i);
   double OldNewTrendSilver=iCustom(Symbol(),Period(), "NewTrend",14,9,0, i+1);
   double OldNewTrendOrange=iCustom(Symbol(),Period(), "NewTrend",14,9,1, i+1);
   double Perc=MathAbs(1-(NewTrendSilver/NewTrendOrange))*100;
//----
     if (Perc > NTMinGap) 
     {
        if (OrderTyp==OP_BUY) 
        {
         if ((OldNewTrendSilver < OldNewTrendOrange) && (NewTrendSilver > NewTrendOrange) )
         {retval=true;}
        }
        if (OrderTyp==OP_SELL) 
        {
         if ((OldNewTrendSilver > OldNewTrendOrange) && (NewTrendSilver < NewTrendOrange) )
         {retval=true;}
        }
     }
//----
   return(retval);
  }
// check all filters here, not just adx
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  bool CheckAdx(int i, int OrderTyp) 
  {
   bool retval=false;
   // get the WindowFind
   //double NewTrend = iCustom(Symbol(),Period(), 9,9,PRICE_CLOSE,i);
   double NewTrendSilver=iCustom(Symbol(),Period(), "NewTrend",14,9,0, i);
   double NewTrendOrange=iCustom(Symbol(),Period(), "NewTrend",14,9,1, i);
   // silver coming back over zero line might be good exits?
   double Perc=MathAbs(1-(NewTrendSilver/NewTrendOrange))*100;
   // silver > orange is buy
   //double Juice = iCustom(Symbol(),Period(), "Juice",0, i);
   //double redflattrend = iCustom(Symbol(),Period(), "flat trend",Period(),0, i);
   //double greenflattrend = iCustom(Symbol(),Period(), "flat trend",Period(),1, i);
   //double yellowflattrend = iCustom(Symbol(),Period(), "flat trend",2, i);
   double adx=iADX(Symbol(),Period(), 14, PRICE_CLOSE, MODE_MAIN,i);
   double adxold=iADX(Symbol(),Period(), 14, PRICE_CLOSE, MODE_MAIN,i+1);
   bool adxvalid=false;
//----
   if (risingADXoverrides ==true)
     {
      if (adxold < adx) // rising
        {
         if  (adx > MinRisingADX)
         {  adxvalid=true;}
        }
      else //falling
        {
         if  (adx > MinADX)
         {  adxvalid=true;}
        }
     }
   else
     {
        if (adx>=MinADX) 
        {
         adxvalid=true;
        }
     }
   if (OrderTyp==OP_BUY)
     {
      if ((NewTrendSilver > NewTrendOrange) &&  (adxvalid==true) && (Perc > NTMinGap)  )
         //if ((Juice >= minJuice) && (adx >= MinADX)  )(SolarWind >= minSolarWind) && (Juice >= minJuice) &&&& (greenflattrend>0)
        {
         retval=true;
        }
      else
        {
         retval=false;
        }
     }
   else if (OrderTyp==OP_SELL)
        {
         if ((NewTrendSilver < (NewTrendOrange - NTMinGap)) &&  (adxvalid==true)&& (Perc > NTMinGap)   )
            //if ((Osma <= -minOsma)  && (SolarWind <= minSolarWind) && (Juice >= minJuice) && (adxvalid == true) && (redflattrend>0)  )
            //   if ((Juice >= minJuice) && (adx >= MinADX)  )
           {
            retval=true;
           }
         else
           {
            retval=false;
           }
        }
//----
   return(retval);
  }
//+------------------------------------------------------------------+