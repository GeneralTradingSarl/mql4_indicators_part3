//+------------------------------------------------------------------+
//|                                                         Swapping |
//|                    https://www.mql5.com/ru/users/Sommersy/seller |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
   EventSetTimer(60);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   double f;
   long id=ChartFirst();
   int i=0;
   while(i<100)
     {
      f=iClose(ChartSymbol(id),1,0);
      f=iClose(ChartSymbol(id),5,0);
      f=iClose(ChartSymbol(id),15,0);
      f=iClose(ChartSymbol(id),30,0);
      f=iClose(ChartSymbol(id),60,0);
      f=iClose(ChartSymbol(id),240,0);
      f=iClose(ChartSymbol(id),1440,0);
      f=iClose(ChartSymbol(id),10080,0);
      f=iClose(ChartSymbol(id),43200,0);
      id=ChartNext(id);
      if(id<0){break;}
      i++;
     }
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
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }
//+------------------------------------------------------------------+
