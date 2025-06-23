#property version "1.02"
#property copyright "Shows the ATR value as a % relative to the past X years. uwy"
#property strict
#property indicator_separate_window

#property indicator_buffers 4       // Number of buffers
#property indicator_color1 clrLimeGreen     // Color of the 1st line
#property indicator_color2 Red      // Color of the 2nd line
#property indicator_color3 Blue     // Color of the 1st line
#property indicator_color4 Red      // Color of the 2nd line

extern int LookBackBars = 800; // days to use as reference. 260 days in a year
extern int level = 25;
extern int ATR_period = 14;

double Buf_0[],Buf_1[],Buf_2[],Buf_3[];             // Declaring arrays (for indicator buffers)
double ATR, maxATR, minATR;
int i,j, barsCounted;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,Buf_0);         // Assigning an array to a buffer
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);// Line style
   SetIndexBuffer(1,Buf_1);         // Assigning an array to a buffer
   SetIndexStyle (1,DRAW_LINE,STYLE_SOLID,2);// Line style
   SetIndexBuffer(2,Buf_2);         // Assigning an array to a buffer
   SetIndexStyle (2,DRAW_NONE);// Line style
   SetIndexBuffer(3,Buf_3);         // Assigning an array to a buffer
   SetIndexStyle (3,DRAW_NONE);// Line style     
   
   //IndicatorShortName(WindowExpertName() + " - ATR(" + (string)ATR_period + ") % vs " + LookBackBars + " bars -");
   IndicatorShortName(WindowExpertName() + "(" + LookBackBars + "," + level + "," + ATR_period + ")");

   //IndicatorSetDouble(INDICATOR_MAXIMUM,100);
   //IndicatorSetDouble(INDICATOR_MINIMUM,0);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,level);
   ArrayInitialize(Buf_0,0);
   ArrayInitialize(Buf_1,0);
   ArrayInitialize(Buf_2,0);
   ArrayInitialize(Buf_3,0);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int Counted_bars;                // Number of counted bars
   Counted_bars=IndicatorCounted(); // Number of counted bars
   i=Bars-Counted_bars-1;           // Index of the first uncounted
   while(i>=0)                      // Loop for uncounted bars
   {
      if (Bars - i > LookBackBars)
      {
         barsCounted = 0;
         ATR = iATR(NULL,0,ATR_period,i);
         minATR = ATR;
         maxATR = minATR;
   
         for(j = i;j<(Bars - ATR_period - 2);j++)
         {
            barsCounted++;
            if (barsCounted > LookBackBars)
               break;
            maxATR = MathMax(iATR(NULL,0,ATR_period,j), maxATR);
            minATR = MathMin(iATR(NULL,0,ATR_period,j), minATR);
         }
         if ((maxATR - minATR) == 0)
            Buf_0[i] = EMPTY_VALUE;
         else
            Buf_0[i]=((ATR - minATR) / (maxATR - minATR)) * 100;
         if (Buf_0[i] < level)
            Buf_1[i] = Buf_0[i];
         else
            Buf_1[i] = EMPTY_VALUE;
         Buf_2[i]=maxATR;
         Buf_3[i]=minATR;
      }
      else // not enough data
      {  
         Buf_0[i]=100;
         Buf_1[i]=0;
         Buf_2[i]=0;
         Buf_3[i]=0;
      }
      i--;                          // Calculating index of the next bar
   }
   return 0;                          // Exit the special funct. start()
  }
//+------------------------------------------------------------------+
