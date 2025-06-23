//+------------------------------------------------------------------+
//| TheClassicTurtleTrader.mq4
//| Copyright © Pointzero-indicator.com
//+------------------------------------------------------------------+
#property copyright "Copyright © Pointzero-indicator.com"
#property link      "http://www.pointzero-indicator.com"

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
#property indicator_color3 DodgerBlue
#property indicator_color4 Red
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 3
#property indicator_width4 3
#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_DOT

//---- constants to know if we are in or out of the market
#define IN_THE_MARKET 0
#define OUT_OF_MARKET 1

//---- indicator parameters
extern int  TradePeriod         = 20;        // Donchian channel period for trading signals
extern int  StopPeriod          = 10;        // Donchian channel period for exit signals
extern bool StrictEntry         = false;     // Apply strict entry parameters like the Turtles did
extern bool StrictExit          = false;     // Apply strict exit parameters like the Turtles did
extern bool StrictStop          = false;     // Apply strict stop-loss like the turtled did
extern bool Greedy              = false;     // Do not exit a trade unless it is in profit or the SL is hit
extern bool EvaluateStoploss    = true;      // Check if we have been stopped out and show future signals
extern int  ATRPeriod           = 20;        // ATRPeriod to set the stop-loss
extern double ATRStopNumber     = 2;         // N.Factor to calculate the stop-loss
extern bool DisplayAlerts       = false;     // You know...

//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double LongInfo[];
double ShortInfo[];
double TrendDirection[];

//---- alerts
static datetime TimeStamp;
static int AlertCount = 1;

//---- internal
double long_price;
double short_price;
double long_stop;
double short_stop;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   // Three more buffers to store long/short trading info and trend
   IndicatorBuffers(7);
   
   // Drawing settings
   SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0, 233);
   SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1, 234);
   SetIndexStyle(2,DRAW_ARROW); SetIndexArrow(2,159);
   SetIndexStyle(3,DRAW_ARROW); SetIndexArrow(3,159);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   
   // Name and labels
   IndicatorShortName("The Classic Turtle Trader ("+ TradePeriod +"-"+ StopPeriod +")");
   SetIndexLabel(0,"Buy breakout "+ TradePeriod);
   SetIndexLabel(1,"Sell breakout "+ TradePeriod);
   SetIndexLabel(2,"Exit longs "+ StopPeriod);
   SetIndexLabel(3,"Exit shorts "+ StopPeriod);
   
   // Buffers
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);    
   SetIndexBuffer(3,ExtMapBuffer4); 
   SetIndexBuffer(4,LongInfo);
   SetIndexBuffer(5,ShortInfo);
   SetIndexBuffer(6,TrendDirection);
   
   Comment("Copyright © http://www.pointzero-indicator.com");
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
     // More vars here too...
     int start = 0;
     int limit;
     int counted_bars = IndicatorCounted();

     // check for possible errors
     if(counted_bars < 0) 
        return(-1);
        
     // Only check these
     limit = Bars - 1 - counted_bars;
     if(counted_bars==0) limit-=1+1;
     // Check the signal foreach bar
     for(int i = limit; i >= start; i--)
     {           
         // Highs and lows
         double rhigh = iHigh(Symbol(),Period(),iHighest(Symbol(), Period(), MODE_HIGH, TradePeriod,i+1));
         double rlow  = iLow(Symbol(),Period(),iLowest(Symbol(), Period(), MODE_LOW, TradePeriod, i+1));
         double shigh = iHigh(Symbol(),Period(),iHighest(Symbol(), Period(), MODE_HIGH, StopPeriod,i+1));
         double slow  = iLow(Symbol(),Period(),iLowest(Symbol(), Period(), MODE_LOW, StopPeriod, i+1));
         
         // Candle value
         double CLOSE = iClose(Symbol(),0, i);
         double HIGH = iHigh(Symbol(),0, i);
         double LOW = iLow(Symbol(),0, i);
         
         // Stop-losses if we traded here
         double ATRv = iATR(Symbol(), 0, ATRPeriod, i) * ATRStopNumber;
         double ATRup = CLOSE + ATRv;
         double ATRlow = CLOSE - ATRv;
         
         // Respect old trend
         LongInfo[i] = LongInfo[i+1];
         ShortInfo[i] = ShortInfo[i+1];
         TrendDirection[i] = TrendDirection[i+1];
         
         // It might be recalculating bar zero
         ExtMapBuffer1[i] = EMPTY_VALUE;
         ExtMapBuffer2[i] = EMPTY_VALUE;
         ExtMapBuffer3[i] = EMPTY_VALUE;
         ExtMapBuffer4[i] = EMPTY_VALUE;
         
         //
         // 1) Check for exits
         //
             
         // Exit longs taking into account strict exits and the greedy mode
         // Loose mode only applies after the bar has closed
         if(((CLOSE < slow && i > 0) && (CLOSE > long_price || Greedy == false)) || 
            (LOW < slow && StrictExit == true && (LOW > long_price || Greedy == false)) && 
            LongInfo[i] == IN_THE_MARKET)
         {
            LongInfo[i] = OUT_OF_MARKET;
            ExtMapBuffer3[i] = LOW;
         }
         
         // Exit shorts taking into account strict exits and the greedy mode
         // Loose mode only applies after the bar has closed
         if(((CLOSE > shigh && i > 0) && (CLOSE < short_price || Greedy == false)) || 
            (HIGH > shigh && StrictExit == true && (HIGH < short_price || Greedy == false)) &&  
            ShortInfo[i] == IN_THE_MARKET)
         {
            ShortInfo[i] = OUT_OF_MARKET;
            ExtMapBuffer4[i] = HIGH;
         }
         
         //
         // 2) Check for stoploss hits
         //
         
         // Exit longs taking into account strict stoploss
         // Loose mode only applies after the bar has closed
         if(((CLOSE < long_stop && i > 0) || (LOW < long_stop && StrictStop == true)) && LongInfo[i] == IN_THE_MARKET && EvaluateStoploss == true)
         {
            LongInfo[i] = OUT_OF_MARKET;
            ExtMapBuffer3[i] = LOW;
         }
         
         // Exit shorts taking into account strict stoploss
         // Loose mode only applies after the bar has closed
         if(((CLOSE > short_stop && i > 0) || (HIGH > short_stop && StrictStop == true)) &&  ShortInfo[i] == IN_THE_MARKET && EvaluateStoploss == true)
         {
            ShortInfo[i] = OUT_OF_MARKET;
            ExtMapBuffer4[i] = HIGH;
         }
         
         //
         // 3) Check for entries
         //
         
         // Enter long trade taking into account strict entries
         // Loose mode only applies after the bar has closed
         if(((CLOSE > rhigh && i > 0) || (HIGH > rhigh && StrictEntry == true)) &&  LongInfo[i] == OUT_OF_MARKET)
         {
            TrendDirection[i] = OP_BUY;
            LongInfo[i] = IN_THE_MARKET;
            ExtMapBuffer1[i] = LOW;
            long_stop = ATRlow;
            long_price = CLOSE;
         }
         
         // Enter short trade taking into account strict entries
         if(((CLOSE < rlow && i > 0) || (LOW < rlow && StrictEntry == true)) && ShortInfo[i] == OUT_OF_MARKET)
         {
            TrendDirection[i] = OP_SELL;
            ShortInfo[i] = IN_THE_MARKET;
            ExtMapBuffer2[i] = HIGH;
            short_stop = ATRup;
            short_price = CLOSE;
         }
     }
     
     // Alerts
     if(TimeStamp != Time[0] && DisplayAlerts == true)
     {
         // Exit signals
         if(LongInfo[1] == OUT_OF_MARKET && LongInfo[2] == IN_THE_MARKET && AlertCount == 0)
         {
            Alert("[Classic Turtle Trader "+ TradePeriod +"-"+ StopPeriod +"]["+ Symbol() +"] Close longs");
         } else if (ShortInfo[1] == OUT_OF_MARKET && ShortInfo[2] == IN_THE_MARKET && AlertCount == 0) {
            Alert("[Classic Turtle Trader "+ TradePeriod +"-"+ StopPeriod +"]["+ Symbol() +"] Close shorts");
         }
         
         // Enter signals
         if(LongInfo[1] == IN_THE_MARKET && LongInfo[2] == OUT_OF_MARKET && AlertCount == 0)
         {
            Alert("[Classic Turtle Trader "+ TradePeriod +"-"+ StopPeriod +"]["+ Symbol() +"] BUY");
         } else if (ShortInfo[1] == IN_THE_MARKET && ShortInfo[2] == OUT_OF_MARKET && AlertCount == 0) {
            Alert("[Classic Turtle Trader "+ TradePeriod +"-"+ StopPeriod +"]["+ Symbol() +"] SELL");
         }
         TimeStamp = Time[0];
         AlertCount = 0;
     }
    
   // Bye Bye
   return(0);
}