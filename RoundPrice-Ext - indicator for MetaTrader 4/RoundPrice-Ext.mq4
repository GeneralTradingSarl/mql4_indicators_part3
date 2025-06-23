//+------------------------------------------------------------------+
//|                                               RoundPrice-Ext.mq4 |
//|                                                       MetaQuotes |
//|                 http://forum.alpari-idc.ru/viewtopic.php?t=48186 |
//+------------------------------------------------------------------+
#property copyright "MetaQuotes"
#property link      "http://forum.alpari-idc.ru/viewtopic.php?t=48186"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Gold
//---- input parameters
extern double    t3_period=8.0;
extern double    b=0.7;
//---- buffers
double ExtMapBuffer1[];
double e1Buffer[];
double e2Buffer[];
double e3Buffer[];
double e4Buffer[];
double e5Buffer[];
double e6Buffer[];
double c1,c2,c3,c4,n,w1,w2,b2,b3;
double dpo,t3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicators
   IndicatorBuffers(7);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,ExtMapBuffer1);
/*   
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT,1,Red);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT,1,Lime);
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT,1,Aqua);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT,1,Blue);
   SetIndexStyle(5,DRAW_LINE,STYLE_DOT,1,Magenta);
   SetIndexStyle(6,DRAW_LINE,STYLE_DOT,1,Purple);
*/
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,Red);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1,Lime);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1,Aqua);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1,Blue);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1,Magenta);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,1,Purple);
//----
   SetIndexBuffer(1,e1Buffer);
   SetIndexBuffer(2,e2Buffer);
   SetIndexBuffer(3,e3Buffer);
   SetIndexBuffer(4,e4Buffer);
   SetIndexBuffer(5,e5Buffer);
   SetIndexBuffer(6,e6Buffer);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
//   SetIndexEmptyValue(7,0.0);
//---- name for DataWindow and indicator subwindow label
   short_name="RoundPrice-Ext("+t3_period+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   b2=b*b;
   b3=b2*b;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+b+b3);
   c4=(1+3*b+b3+3*b2);
   n=t3_period;
//----
   if(n<1) n=1;
   n=1+0.5*(n-1);
   w1=2/(n + 1);
   w2=1 - w1;
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
   int shift,limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;
//----
   for(shift=limit;shift>=0;shift--)
     {//Begin
      dpo=Close[shift];
      e1Buffer[shift]=w1*dpo + w2*e1Buffer[shift+1];
      e2Buffer[shift]=w1*e1Buffer[shift] + w2*e2Buffer[shift+1];
      e3Buffer[shift]=w1*e2Buffer[shift] + w2*e3Buffer[shift+1];
      e4Buffer[shift]=w1*e3Buffer[shift] + w2*e4Buffer[shift+1];
      e5Buffer[shift]=w1*e4Buffer[shift] + w2*e5Buffer[shift+1];
      e6Buffer[shift]=w1*e5Buffer[shift] + w2*e6Buffer[shift+1];
      //----
      t3=c1*e6Buffer[shift]+c2*e5Buffer[shift]+c3*e4Buffer[shift]+c4*e3Buffer[shift];
      //----
      if(t3==0) t3=0.0001;
      //----
      ExtMapBuffer1[shift]=t3;
     }
   return(0);
  }
//+------------------------------------------------------------------+
