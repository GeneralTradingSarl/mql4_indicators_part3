//+------------------------------------------------------------------+
//|                                                                  |
//|                 // Ticker FATL.mq4.                              |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mandorr@gmail.com"
#property indicator_separate_window
#property indicator_buffers 2
//-----
#property indicator_color1 Red
#property indicator_width1 1
#property indicator_style1 0
//-----
#property indicator_color2 Red
#property indicator_width2 2
#property indicator_style2 0
//-----
extern int CountBars=1000;   // Количество отображаемых баров
//-----
int count;
int price;
int price_prev;
//-----
double ticker[100];           // буфер тиков
double FATL[100];             // буфер FATL
double buffer0[];
double buffer1[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Ticker");
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,"FATL");
   SetIndexDrawBegin(1,0);
//----
   count=ArrayResize(ticker,CountBars);
   count=ArrayResize(FATL,CountBars);
   count=0;
   ArrayInitialize(FATL,EMPTY_VALUE); // EMPTY_VALUE=+2147483647
   price_prev=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int i, j;
   double sum, value;
   price=MathRound(Bid/Point);
   if (price_prev==0)
     {
      count=0;
      price_prev=price;
      ticker[0]=price*Point;
      buffer0[0]=ticker[0];
      IndicatorShortName("Ticker ("+count+") FATL");
      return;
     }
   if (price==price_prev) return;
   price_prev=price;
   for(i=count; i>=0; i--)
     {
      ticker[i+1]=ticker[i];
      FATL[i+1]=FATL[i];
     }
   ticker[0]=price*Point;
   if (count<CountBars-1) count++;
   if (count>=38)
      FATL[0]=0
      +0.4360409450*ticker[ 0]
      +0.3658689069*ticker[ 1]
      +0.2460452079*ticker[ 2]
      +0.1104506886*ticker[ 3]
      -0.0054034585*ticker[ 4]
      -0.0760367731*ticker[ 5]
      -0.0933058722*ticker[ 6]
      -0.0670110374*ticker[ 7]
      -0.0190795053*ticker[ 8]
      +0.0259609206*ticker[ 9]
      +0.0502044896*ticker[10]
      +0.0477818607*ticker[11]
      +0.0249252327*ticker[12]
      -0.0047706151*ticker[13]
      -0.0272432537*ticker[14]
      -0.0338917071*ticker[15]
      -0.0244141482*ticker[16]
      -0.0055774838*ticker[17]
      +0.0128149838*ticker[18]
      +0.0226522218*ticker[19]
      +0.0208778257*ticker[20]
      +0.0100299086*ticker[21]
      -0.0036771622*ticker[22]
      -0.0136744850*ticker[23]
      -0.0160483392*ticker[24]
      -0.0108597376*ticker[25]
      -0.0016060704*ticker[26]
      +0.0069480557*ticker[27]
      +0.0110573605*ticker[28]
      +0.0095711419*ticker[29]
      +0.0040444064*ticker[30]
      -0.0023824623*ticker[31]
      -0.0067093714*ticker[32]
      -0.0072003400*ticker[33]
      -0.0047717710*ticker[34]
      +0.0005541115*ticker[35]
      +0.0007860160*ticker[36]
      +0.0130129076*ticker[37]
      +0.0040364019*ticker[38];
   for(i=0; i<=count; i++)
     {
      buffer0[i]=ticker[i];
      buffer1[i]=FATL[i];
     }
   IndicatorShortName("Ticker ("+count+") FATL");
  }
//+------------------------------------------------------------------+