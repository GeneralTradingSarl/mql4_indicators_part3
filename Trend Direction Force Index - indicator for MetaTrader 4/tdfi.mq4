//https://www.tradingview.com/script/HUpIful1-Trend-Direction-Force-Index-v2-TDFI-wm/
#property copyright "Bugscoder Studio"
#property link      "https://www.bugscoder.com/"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 4
#property indicator_level1  0
#property indicator_type1   DRAW_NONE
#property indicator_type2   DRAW_NONE
#property indicator_type3   DRAW_NONE
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrOrange
#property indicator_width4  2


input int lookback = 13;
input int mmaLength = 13;
input ENUM_MA_METHOD mmaMode = MODE_EMA;
input int smmaLength = 13;
input ENUM_MA_METHOD smmaMode = MODE_EMA;
input int nLength = 3;
input ENUM_APPLIED_PRICE price = PRICE_CLOSE;

double mma[], smma[], tdfAbs[], tdf[];
string obj_prefix = "RSIMACDOBOS_";

int OnInit() {
   IndicatorDigits(3);
   SetIndexLabel(0, "mma");
   SetIndexBuffer(0, mma);
   SetIndexLabel(1, "smma");
   SetIndexBuffer(1, smma);
   SetIndexLabel(2, "tdfAbs");
   SetIndexBuffer(2, tdfAbs);
   SetIndexLabel(3, "tdf (3)");
   SetIndexBuffer(3, tdf);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {

   int startPos = rates_total-prev_calculated-2;
   if (startPos <= 1) { startPos = 1; }
   
   //for(int pos=0; pos<=startPos; pos++) {
   for(int pos=startPos; pos>=0; pos--) {
      mma[pos]  = iMA(NULL, 0, mmaLength, 0, mmaMode, price*1000, pos);
      smma[pos] = iMAOnArray(mma, 0, smmaLength, 0, smmaMode, pos);
      
      double impetmma  = mma[pos]  - mma[pos+1];
      double impetsmma = smma[pos] - smma[pos+1];
      double divma     = MathAbs(mma[pos] - smma[pos]);
      double averimpet = (impetmma + impetsmma)/2;
      
      tdf[pos]    = MathPow(divma, 1) * MathPow(averimpet, nLength);
      tdfAbs[pos] = MathAbs(tdf[pos]);
      tdf[pos]    = tdf[pos] / tdfAbs[ArrayMaximum(tdfAbs, lookback * nLength, pos)];
   }

   return(rates_total);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, obj_prefix);
}