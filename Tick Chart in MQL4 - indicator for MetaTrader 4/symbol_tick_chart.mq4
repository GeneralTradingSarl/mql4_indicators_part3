//+------------------------------------------------------------------+
//|                                            Symbol_Tick_Chart.mq4 |
//|                                     Copyright 2020,JAFFER WILSON |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020,JAFFER WILSON"
#property version   "1.00"
#property indicator_chart_window
#property strict 

// Please uncomment the include file
//#include <WinUser32.mqh>

int ExtPeriodMultiplier=1;
int        ExtHandle=-1;
int last_fpos,i_time,obj_count,i_period;
datetime last_visit;
int    hwnd=0;
datetime last_time;
string c_symbol;
int OnInit()
  {
   hwnd=0;
   int    version=400;
   string c_copyright;
   c_symbol=Symbol()+"_tick";
   i_period=Period()*ExtPeriodMultiplier;
   int    i_digits=Digits;
   int    i_unused[13];
//----
   ExtHandle=FileOpenHistory(c_symbol+i_period+".hst",FILE_BIN|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ);
   if(ExtHandle < 0)
      return(-1);
   c_copyright="(C)opyright 2020-, Jaffer Wilson.";
   FileWriteInteger(ExtHandle, version, LONG_VALUE);
   FileWriteString(ExtHandle, c_copyright, 64);
   FileWriteString(ExtHandle, c_symbol, 12);
   FileWriteInteger(ExtHandle, i_period, LONG_VALUE);
   FileWriteInteger(ExtHandle, i_digits, LONG_VALUE);
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);
   FileWriteArray(ExtHandle, i_unused, 0, 13);
   i_time=0;

   last_fpos = FileTell(ExtHandle);
   FileFlush(ExtHandle);
   Print("i_time: ",i_time,"  last_fpos: ",last_fpos);
   last_time=LocalTime()-5;
   last_time=Time[0];
   return(INIT_SUCCEEDED);
  }
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
   if(last_visit!=time[rates_total-1])
     {
      last_visit=time[rates_total-1];
     }
   int cur_time=LocalTime();
//---- check for new rates
   FileSeek(ExtHandle,last_fpos,SEEK_SET);
   i_time+=PeriodSeconds()*ExtPeriodMultiplier;
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   double d_close = tick.bid;
//----
   FileWriteInteger(ExtHandle, i_time, LONG_VALUE);
   FileWriteDouble(ExtHandle, d_close, DOUBLE_VALUE);
   FileWriteDouble(ExtHandle, d_close, DOUBLE_VALUE);
   FileWriteDouble(ExtHandle, d_close, DOUBLE_VALUE);
   FileWriteDouble(ExtHandle, d_close, DOUBLE_VALUE);
   FileWriteDouble(ExtHandle, 1, DOUBLE_VALUE);
   FileFlush(ExtHandle);
   last_fpos = FileTell(ExtHandle);
//----
   if(hwnd==0)
     {
      hwnd=WindowHandle(c_symbol,i_period);
      if(hwnd!=0)
         Print("Chart window detected");
     }

// Please uncomment the below lines after downloading the file
//if(hwnd!=0)// && cur_time-last_time>=2)
//  {
//   PostMessageA(hwnd,WM_COMMAND,33324,0);
//   last_time=cur_time;
//  }



   return(rates_total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   if(ExtHandle>=0)
     {
      FileClose(ExtHandle);
      ExtHandle=-1;
     }
  }
//+------------------------------------------------------------------+
