//+------------------------------------------------------------------+
//|   Qualitative Quantitative Estimation Indicator for Metatrader 4 |
//|                                     Copyright © 2006Roman Ignatov |
//|                                   mailto:roman.ignatov@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 200 Roman Ignatov"
#property link      "mailto:roman.ignatov@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Navy
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2
#property indicator_color2 Navy
#property indicator_style2 STYLE_DOT
//----
extern int SF=5;
//----
int RSI_Period=14;
int Wilders_Period;
int StartBar;
//----
double TrLevelSlow[];
double AtrRsi[];
double MaAtrRsi[];
double Rsi[];
double RsiMa[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   Wilders_Period=RSI_Period*2-1;
   if(Wilders_Period<SF)
      StartBar=SF;
   else
      StartBar=Wilders_Period;
//----
   IndicatorBuffers(5);
   SetIndexBuffer(0,RsiMa);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(0,"Value 1");
   SetIndexDrawBegin(0,StartBar);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(1,TrLevelSlow);
   SetIndexLabel(1,"Value 2");
   SetIndexDrawBegin(1,StartBar);
   SetIndexBuffer(2,AtrRsi);
   SetIndexBuffer(3,MaAtrRsi);
   SetIndexBuffer(4,Rsi);
   IndicatorShortName(StringConcatenate("QQE(",SF,")"));
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted,i;
   double rsi0,rsi1,dar,tr,dv;
//----
   if(Bars<=StartBar) return(0);
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   /*if(counted_bars==0)
     {
      ArrayInitialize(TrLevelSlow,0.0);
      ArrayInitialize(AtrRsi,0.0);
      ArrayInitialize(MaAtrRsi,0.0);
      ArrayInitialize(Rsi,0.0);
      ArrayInitialize(RsiMa,0.0);
     }*/
//----
   for(i=limit; i>=0; i--)
      Rsi[i]=iRSI(NULL,0,RSI_Period,PRICE_CLOSE,i);
   for(i=limit; i>0; i--)
     {
      RsiMa[i]=iMAOnArray(Rsi,0,SF,0,MODE_EMA,i);
      AtrRsi[i]=MathAbs(RsiMa[i+1]-RsiMa[i]);
     }
   for(i=limit; i>=0; i--)
      MaAtrRsi[i]=iMAOnArray(AtrRsi,0,Wilders_Period,0,MODE_EMA,i);
   i=limit;
   tr=TrLevelSlow[i];
   rsi1=iMAOnArray(Rsi,0,SF,0,MODE_EMA,i);
   while(i>0)
     {
      i--;
      rsi0=iMAOnArray(Rsi,0,SF,0,MODE_EMA,i);
      dar=iMAOnArray(MaAtrRsi,0,Wilders_Period,0,MODE_EMA,i)*4.236;
      dv=tr;
      if(rsi0<tr)
        {
         tr=rsi0+dar;
         if(rsi1<dv)
            if(tr>dv)
               tr=dv;
        }
      else if(rsi0>tr)
        {
         tr=rsi0-dar;
         if(rsi1>dv)
            if(tr<dv)
               tr=dv;
        }
      TrLevelSlow[i]=tr;
      rsi1=rsi0;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
