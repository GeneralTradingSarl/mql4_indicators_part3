//+------------------------------------------------------------------+
//|                                                                  |
//|                 Ticker Trail.                                    |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mandorr@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gray
#property indicator_width1 1
#property indicator_style1 0
#property indicator_color2 Gray
#property indicator_width2 2
#property indicator_style2 0
//----
extern int Trail=10;         // Трал
extern int CountBars=1000;   // Количество отображаемых баров
//----
int count;
int price;
int price_prev;
int trail;
double ticker[10];           // буфер тиков
double buffer0[];
double buffer1[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Value");
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,"Trail");
   SetIndexDrawBegin(1,0);
   count=ArrayResize(ticker,CountBars);
   count=0;
   price_prev=0;
   trail=0; if (Trail>0) trail=Trail;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int i, value;
   price=MathRound(Bid/Point);
   if (price_prev==0)
     {
      count=0;
      price_prev=price;
      ticker[0]=price*Point;
      buffer0[0]=ticker[0];
      buffer1[0]=ticker[0];
      IndicatorShortName("Ticker ("+count+") Trail ("+trail+")");
      return;
     }
   if (price==price_prev) return;
   price_prev=price;
   for(i=count; i>=0; i--)
     {
      ticker[i+1]=ticker[i];
     }
   ticker[0]=price*Point;
   if (count<CountBars-1) count++;
   value=MathRound(ticker[count]/Point);
   for(i=count; i>=0; i--)
     {
      buffer0[i]=ticker[i];
      price=MathRound(ticker[i]/Point);
      if (value<price-trail) value=price-trail;
      if (value>price+trail) value=price+trail;
      buffer1[i]=value*Point;
     }
   IndicatorShortName("Ticker ("+count+") Trail ("+trail+")");
  }
//+------------------------------------------------------------------+