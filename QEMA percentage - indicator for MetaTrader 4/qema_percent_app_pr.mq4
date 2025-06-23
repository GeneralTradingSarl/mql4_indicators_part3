//+---------------------------------------------------------------------+              |
//| Fabrizio Gargiulo 2016 - Formia (LT) ITALY                          |
//| fajuzi@yahoo.it +393496380490                                       |
//| Copyright 2005-2014, MetaQuotes Software Corp.                      |
//+---------------------------------------------------------------------+
#property copyright "Fabrizio Gargiulo 2015"
#property description "qema percentage"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//--- input
input int                  ema_per=50;
input int                  correction=100;
input ENUM_APPLIED_PRICE   applied=PRICE_CLOSE;
//---- buffers
double ema[],ema2[],ema3[],ema4[],ema5[],qema[];
int limit,i;
double k1,k2,k3,k4,k5,k_ema_per;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(6);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID);
   SetIndexBuffer(0,qema);
   SetIndexBuffer(1,ema);
   SetIndexBuffer(2,ema2);
   SetIndexBuffer(3,ema3);
   SetIndexBuffer(4,ema4);
   SetIndexBuffer(5,ema5);
   IndicatorDigits(5);
   SetIndexDrawBegin(0,ema_per*5);
   IndicatorShortName("QEMA("+ema_per+")");
   k1=(1.0+4.0*correction*0.01);
   k2=-10.0*correction*0.01;
   k3=10.0*correction*0.01;
   k4=-5.0*correction*0.01;
   k5=correction*0.01;
   k_ema_per=(ema_per+1.0)/2.0;
//SetIndexLabel(0,short_name);
//----
   return(1);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0 || Bars<5*ema_per) return(-1);
//---- last counted bar will be recounted
   limit=Bars-3;
   if(counted_bars>0) limit=Bars-counted_bars-1;
   else
     {
      ema[limit+1]=GetPrice(limit+1);
      ema2[limit+1]=ema[limit+1];
      ema3[limit+1]=ema[limit+1];
      ema4[limit+1]=ema[limit+1];
      ema5[limit+1]=ema[limit+1];
     }
   for(i=limit; i>=0; i--)
     {
      ema[i]=ema[i+1]+(GetPrice(i)-ema[i+1])/k_ema_per;
      ema2[i]=ema2[i+1]+(ema[i]-ema2[i+1])/k_ema_per;
      ema3[i]=ema3[i+1]+(ema2[i]-ema3[i+1])/k_ema_per;
      ema4[i]=ema4[i+1]+(ema3[i]-ema4[i+1])/k_ema_per;
      ema5[i]=ema5[i+1]+(ema4[i]-ema5[i+1])/k_ema_per;
      qema[i]=k1*ema[i]+k2*ema2[i]+k3*ema3[i]+k4*ema4[i]+k5*ema5[i];
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Get price (o,h,l,c,median,typical,weighted)                      |
//+------------------------------------------------------------------+
double GetPrice(int h)
  {
   switch(applied)
     {
      case PRICE_CLOSE: return(Close[h]);
      case PRICE_MEDIAN: return((High[h]+Low[h])/2.0);
      case PRICE_TYPICAL: return((Close[h]+High[h]+Low[h])/3.0);
      case PRICE_WEIGHTED: return((2.0*Close[h]+High[h]+Low[h])/4.0);
      case PRICE_LOW: return(Low[h]);
      case PRICE_HIGH: return(High[h]);
      case PRICE_OPEN: return(Open[h]);
      default: return(0.5*(High[h]+Low[h]));
     }
  }
//+------------------------------------------------------------------+
