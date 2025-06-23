#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrSilver
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrSilver
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrSilver
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSilver
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrSilver
#property indicator_width5  2


input int                inpRsiPeriod        = 14;          // RSI period
input ENUM_APPLIED_PRICE inpPrice            = PRICE_CLOSE; // RSI price
input int                inpSmoothing        = 14;          // Smoothing period for RSI
input double             inpOverbought       = 70;          // Overbought level %
input double             inpOversold         = 30;          // Oversold level %
input double             inpUpperNeutral     = 55;          // Upper neutral level %
input double             inpLowerNeutral     = 45;          // Lower neutral level %

double bupu[],bupd[],bdnu[],bdnd[],rsi[];
//+------------------------------------------------------------------+
int OnInit() {
   SetIndexBuffer(0,bupu,INDICATOR_DATA);
   SetIndexBuffer(1,bupd,INDICATOR_DATA);
   SetIndexBuffer(2,bdnu,INDICATOR_DATA);
   SetIndexBuffer(3,bdnd,INDICATOR_DATA);
   SetIndexBuffer(4,rsi,INDICATOR_DATA);
   return(INIT_SUCCEEDED);
}
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
                const int &spread[]) {
   
   int limit = prev_calculated>0 ? rates_total - prev_calculated + 1 : rates_total - 1;
   
   for(int i=limit;i>=0;i--) {
         rsi[i] = iRSI(NULL,PERIOD_CURRENT,inpRsiPeriod,inpPrice,i);
         double _rsi = (rsi[i]!=EMPTY_VALUE) ? rsi[i] : 0;
         double _ob  = iEma(_rsi-inpOverbought  ,inpSmoothing,i,0);
         double _os  = iEma(_rsi-inpOversold    ,inpSmoothing,i,1);
         double _nzu = iEma(_rsi-inpUpperNeutral,inpSmoothing,i,2);
         double _nzd = iEma(_rsi-inpLowerNeutral,inpSmoothing,i,3);
        
         bupu[i] = _ob;
         bupd[i] = _nzu;
         bdnu[i] = _os;
         bdnd[i] = _nzd;
         rsi[i] -= 50;
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
#define _emaInstances 4
#define _emaRingSize 6
double workEma[_emaRingSize][_emaInstances];
//
//---
//
double iEma(double price, double period,int i, int _inst=0)
{
   int _indC = (i  )%_emaRingSize;
   int _indP = (i+1)%_emaRingSize;

   if(i>0 && period>1)
          workEma[_indC][_inst]=workEma[_indP][_inst]+(2.0/(1.0+period))*(price-workEma[_indP][_inst]);
   else   workEma[_indC][_inst]=price;
   return(workEma[_indC][_inst]);
}