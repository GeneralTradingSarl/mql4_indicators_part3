//+------------------------------------------------------------------+
//|                                                       ZigZag.mq4 |
//|                             Copyright 2000-2025, MetaQuotes Ltd. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2000-2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1  Red
//---- indicator parameters
input int     InpDepth          = 12;     // Depth
input int     InpDeviation      = 5;      // Deviation
input int     InpBackstep       = 3;      // Backstep
input bool    DrawFibRet        = false;  // Draw Retracement
input color   ClrUpRet          = LawnGreen; // Color Uptrend
input color   ClrDnRet          = IndianRed; // Color Downtrend
input bool    DrawFibExp        = false;  // Draw Expansion
input color   ClrUpExp          = YellowGreen;   // Color Uptrend
input color   ClrDnExp          = PaleVioletRed; //Color Downtrend
input int     SwingIndex        = 0;      // Swing Index ( 0 = Last )

//---- indicator buffers
double ExtZigzagBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
//--- globals
int    ExtLevel = 3; // recounting's depth of extremums
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpBackstep >= InpDepth)
     {
      Print("Backstep cannot be greater or equal to Depth");
      return(INIT_FAILED);
     }
//--- 2 additional buffers
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0, DRAW_SECTION);
//---- indicator buffers
   SetIndexBuffer(0, ExtZigzagBuffer);
   SetIndexBuffer(1, ExtHighBuffer);
   SetIndexBuffer(2, ExtLowBuffer);
   SetIndexEmptyValue(0, 0.0);
//---- indicator short name
   IndicatorShortName("ZigZag(" + string(InpDepth) + "," + string(InpDeviation) + "," + string(InpBackstep) + ")");
//---- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int    i, limit, counterZ, whatlookfor = 0;
   int    back, pos, lasthighpos = 0, lastlowpos = 0;
   double extremum;
   double curlow = 0.0, curhigh = 0.0, lasthigh = 0.0, lastlow = 0.0;
//--- check for history and inputs
   if(rates_total < InpDepth || InpBackstep >= InpDepth)
      return(0);
//--- first calculations
   if(prev_calculated == 0)
      limit = InitializeAll();
   else
     {
      //--- find first extremum in the depth ExtLevel or 100 last bars
      i = counterZ = 0;
      while(counterZ < ExtLevel && i < 100)
        {
         if(ExtZigzagBuffer[i] != 0.0)
            counterZ++;
         i++;
        }
      //--- no extremum found - recounting all from begin
      if(counterZ == 0)
         limit = InitializeAll();
      else
        {
         //--- set start position to found extremum position
         limit = MathMin(i - 1, rates_total - 1); // FIX: avoid exceeding array size
         //--- what kind of extremum?
         if(ExtLowBuffer[i] != 0.0)
           {
            //--- low extremum
            curlow = ExtLowBuffer[i];
            //--- will look for the next high extremum
            whatlookfor = 1;
           }
         else
           {
            //--- high extremum
            curhigh = ExtHighBuffer[i];
            //--- will look for the next low extremum
            whatlookfor = -1;
           }
         //--- clear the rest data
         for(i = limit - 1; i >= 0; i--)
           {
            ExtZigzagBuffer[i] = 0.0;
            ExtLowBuffer[i] = 0.0;
            ExtHighBuffer[i] = 0.0;
           }
        }
     }
//--- main loop
   for(i = limit; i >= 0; i--)
     {
      //--- find lowest low in depth of bars
      extremum = low[iLowest(NULL, 0, MODE_LOW, InpDepth, i)];
      //--- this lowest has been found previously
      if(extremum == lastlow)
         extremum = 0.0;
      else
        {
         //--- new last low
         lastlow = extremum;
         //--- discard extremum if current low is too high
         if(low[i] - extremum > InpDeviation * Point)
            extremum = 0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back = 1; back <= InpBackstep; back++)
              {
               pos = i + back;
               if(pos < rates_total) // FIX: prevent out of range
                 {
                  if(ExtLowBuffer[pos] != 0 && ExtLowBuffer[pos] > extremum)
                     ExtLowBuffer[pos] = 0.0;
                 }
              }
           }
        }
      //--- found extremum is current low
      if(low[i] == extremum)
         ExtLowBuffer[i] = extremum;
      else
         ExtLowBuffer[i] = 0.0;
      //--- find highest high in depth of bars
      extremum = high[iHighest(NULL, 0, MODE_HIGH, InpDepth, i)];
      //--- this highest has been found previously
      if(extremum == lasthigh)
         extremum = 0.0;
      else
        {
         //--- new last high
         lasthigh = extremum;
         //--- discard extremum if current high is too low
         if(extremum - high[i] > InpDeviation * Point)
            extremum = 0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back = 1; back <= InpBackstep; back++)
              {
               pos = i + back;
               if(pos < rates_total) // FIX: prevent out of range
                 {
                  if(ExtHighBuffer[pos] != 0 && ExtHighBuffer[pos] < extremum)
                     ExtHighBuffer[pos] = 0.0;
                 }
              }
           }
        }
      //--- found extremum is current high
      if(high[i] == extremum)
         ExtHighBuffer[i] = extremum;
      else
         ExtHighBuffer[i] = 0.0;
     }
//--- final cutting
   if(whatlookfor == 0)
     {
      lastlow = 0.0;
      lasthigh = 0.0;
     }
   else
     {
      lastlow = curlow;
      lasthigh = curhigh;
     }
   for(i = limit; i >= 0; i--)
     {
      switch(whatlookfor)
        {
         case 0: // look for peak or lawn
            if(lastlow == 0.0 && lasthigh == 0.0)
              {
               if(ExtHighBuffer[i] != 0.0)
                 {
                  lasthigh = High[i];
                  lasthighpos = i;
                  whatlookfor = -1;
                  ExtZigzagBuffer[i] = lasthigh;
                 }
               if(ExtLowBuffer[i] != 0.0)
                 {
                  lastlow = Low[i];
                  lastlowpos = i;
                  whatlookfor = 1;
                  ExtZigzagBuffer[i] = lastlow;
                 }
              }
            break;
         case 1: // look for peak
            if(ExtLowBuffer[i] != 0.0 && ExtLowBuffer[i] < lastlow && ExtHighBuffer[i] == 0.0)
              {
               ExtZigzagBuffer[lastlowpos] = 0.0;
               lastlowpos = i;
               lastlow = ExtLowBuffer[i];
               ExtZigzagBuffer[i] = lastlow;
              }
            if(ExtHighBuffer[i] != 0.0 && ExtLowBuffer[i] == 0.0)
              {
               lasthigh = ExtHighBuffer[i];
               lasthighpos = i;
               ExtZigzagBuffer[i] = lasthigh;
               whatlookfor = -1;
              }
            break;
         case -1: // look for lawn
            if(ExtHighBuffer[i] != 0.0 && ExtHighBuffer[i] > lasthigh && ExtLowBuffer[i] == 0.0)
              {
               ExtZigzagBuffer[lasthighpos] = 0.0;
               lasthighpos = i;
               lasthigh = ExtHighBuffer[i];
               ExtZigzagBuffer[i] = lasthigh;
              }
            if(ExtLowBuffer[i] != 0.0 && ExtHighBuffer[i] == 0.0)
              {
               lastlow = ExtLowBuffer[i];
               lastlowpos = i;
               ExtZigzagBuffer[i] = lastlow;
               whatlookfor = 1;
              }
            break;
        }
     }

   double swingPrices[100] = {};
   int swingTimes[100] = {};
   int swingCount = 0;
   for(i = 0; i < rates_total && swingCount < 100; i++)
     {
      if(ExtZigzagBuffer[i] != 0.0)
        {
         swingPrices[swingCount] = ExtZigzagBuffer[i];
         swingTimes[swingCount] = i;
         swingCount++;
        }
     }

   if(DrawFibRet)
     {
      if(swingCount > SwingIndex + 1)
        {
         double price0 = swingPrices[SwingIndex];   // Harga swing terakhir
         double price1 = swingPrices[SwingIndex + 1]; // Harga swing sebelumnya
         int time0 = swingTimes[SwingIndex];        // Waktu swing terakhir
         int time1 = swingTimes[SwingIndex + 1];    // Waktu swing sebelumnya

         string fibName = "ZigZagFiboRet";
         ObjectDelete(0, fibName);
         if(ObjectCreate(0, fibName, OBJ_FIBO, 0, Time[time1], price1, Time[time0], price0))
           {
            // Atur level Fibonacci secara eksplisit
            double fiboLevels[] = {0.0, 0.236, 0.382, 0.5, 0.618, 1.0, 1.618, 2.618, 4.236};
            int totalLevels = ArraySize(fiboLevels);
            
            // Hitung harga untuk setiap level
            double priceDiff = MathAbs(price0 - price1); // Selisih harga
            bool isUptrend = price1 < price0;
            
            ObjectSetInteger(0, fibName, OBJPROP_FIBOLEVELS, totalLevels);
            ObjectSet(fibName, OBJPROP_COLOR, isUptrend ? ClrUpRet : ClrDnRet);
            ObjectSet(fibName, OBJPROP_LEVELCOLOR, isUptrend ? ClrUpRet : ClrDnRet);
            ObjectSet(fibName, OBJPROP_LEVELSTYLE, STYLE_SOLID);      

            for(int level = 0; level < totalLevels; level++)
              {
               ObjectSetDouble(0, fibName, OBJPROP_LEVELVALUE, level, fiboLevels[level]);
               
               double levelPrice;
               if(isUptrend)
                  levelPrice = price0 - (priceDiff * fiboLevels[level]);
               else
                  levelPrice = price0 + (priceDiff * (fiboLevels[level]));
                  
               string des = StringFormat("%.1f%% - %." + IntegerToString(_Digits) + "f", fiboLevels[level] * 100, levelPrice);
               ObjectSetFiboDescription(fibName, level, des);
              }
           }
        }
     }

   if(DrawFibExp)
     {
      if(swingCount > SwingIndex + 2)
        {
         double price0 = swingPrices[SwingIndex];   
         double price1 = swingPrices[SwingIndex + 1];
         double price2 = swingPrices[SwingIndex + 2];
         int time0 = swingTimes[SwingIndex];
         int time1 = swingTimes[SwingIndex + 1];
         int time2 = swingTimes[SwingIndex + 2];

         string fibName = "ZigZagFiboExp";
         ObjectDelete(0, fibName);
         if(ObjectCreate(0, fibName, OBJ_EXPANSION, 0, Time[time2], price2, Time[time1], price1, Time[time0], price0))
           {
            // Atur level Fibonacci Expansion
            double fiboLevels[] = {0.618, 1.0, 1.618};
            int totalLevels = ArraySize(fiboLevels);
            
            // Hitung harga untuk setiap level Expansion
            double priceDiff = MathAbs(price2 - price1); // Selisih harga
            bool isUptrend = price2 < price1;
            
            ObjectSetInteger(0, fibName, OBJPROP_FIBOLEVELS, totalLevels);
            ObjectSet(fibName, OBJPROP_COLOR, isUptrend ? ClrUpExp : ClrDnExp);
            ObjectSet(fibName, OBJPROP_LEVELCOLOR, isUptrend ? ClrUpExp : ClrDnExp);
            ObjectSet(fibName, OBJPROP_LEVELSTYLE, STYLE_DOT);  

            for(int level = 0; level < totalLevels; level++)
              {
               ObjectSetDouble(0, fibName, OBJPROP_LEVELVALUE, level, fiboLevels[level]);
               
               double levelPrice;
               if(isUptrend)
                  levelPrice = price0 + (priceDiff * fiboLevels[level]);
               else
                  levelPrice = price0 - (priceDiff * (fiboLevels[level]));
                  
               string des = StringFormat("FE %.1f%% - %." + IntegerToString(_Digits) + "f", fiboLevels[level] * 100, levelPrice);
               ObjectSetFiboDescription(fibName, level, des); // Perbaikan di sini
              }
           }
        }
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int InitializeAll()
  {
   ArrayInitialize(ExtZigzagBuffer, 0.0);
   ArrayInitialize(ExtHighBuffer, 0.0);
   ArrayInitialize(ExtLowBuffer, 0.0);
//--- first counting position
   return(Bars - InpDepth);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// Hapus objek Fibo ketika indikator dihapus dari chart
   ObjectDelete(0, "ZigZagFiboRet");
   ObjectDelete(0, "ZigZagFiboExp");
  }
//+------------------------------------------------------------------+
