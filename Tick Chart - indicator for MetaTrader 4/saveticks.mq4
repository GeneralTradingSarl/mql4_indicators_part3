//+------------------------------------------------------------------+
//|                                                    SaveTicks.mq4 |
//|                                             Copyright 2016, DNG® |
//|                                       http://forex-start.ucoz.ua |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, DNG®"
#property link      "http://forex-start.ucoz.ua"
#property version   "1.00"
#property strict
#property indicator_chart_window
#include <WinUser32.mqh>

MqlRates    rate;
int         ExtHandle=-1;
long        sum_tick_volume=0;
long        sum_real_volume=0;
long        chart;
int         hwnd;
bool        FirstTick;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   chart=-1;
   hwnd=0;

//--- indicator buffers mapping
//---- History header
   int      file_version=401;
   string   c_copyright;
   string   c_symbol=_Symbol;
   int      i_period=999; // coder for ticks timframe (not used by other timeframes)
   int      i_digits=Digits;
   int      i_unused[13];
//---  
   ExtHandle=FileOpenHistory(c_symbol+(string)i_period+".hst",FILE_BIN|FILE_READ|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
   if(ExtHandle<0)
      return(INIT_FAILED);
   if(FileSize(ExtHandle)<=0)
     {
      //--- if open new file make header of history file
      c_copyright="(C)opyright 2016, DNG®";
      ArrayInitialize(i_unused,0);
      //--- write history file header
      FileWriteInteger(ExtHandle,file_version,LONG_VALUE);
      FileWriteString(ExtHandle,c_copyright,64);
      FileWriteString(ExtHandle,c_symbol,12);
      FileWriteInteger(ExtHandle,i_period,LONG_VALUE);
      FileWriteInteger(ExtHandle,i_digits,LONG_VALUE);
      FileWriteInteger(ExtHandle,0,LONG_VALUE);
      FileWriteInteger(ExtHandle,0,LONG_VALUE);
      FileWriteArray(ExtHandle,i_unused,0,13);
     }
   else
     {
      //--- go to end of existing history file
      FileSeek(ExtHandle,0,SEEK_END);
     }
//--- Open new chart with 
   FirstTick=true;
//---
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
//---
   if(rate.time<time[0])
     {
      //--- initilize varies for new candle
      rate.open=open[0];
      sum_tick_volume=0;
      sum_real_volume=0;
     }
   else
     {

      rate.open=rate.close;
     }
//--- calculate tick's candle
   rate.close=close[0];
   sum_tick_volume+=rate.tick_volume=(long)(tick_volume[0]-sum_tick_volume);
   sum_real_volume+=rate.real_volume=(long)(ArraySize(volume)>0 ? (volume[0]-sum_real_volume) : 0);
   rate.spread=(ArraySize(spread)>0 ? spread[0]:(int)((Ask-Bid)/Point));
   rate.time=(datetime)SymbolInfoInteger(_Symbol,SYMBOL_TIME);
   rate.low=fmin(rate.open,rate.close);
   rate.high=fmax(rate.open,rate.close);
//--- save candle to ticks history file
   if(!FirstTick)
     {
      FileWriteStruct(ExtHandle,rate);
      FileFlush(ExtHandle);
      //--- refresh chart
      hwnd=WindowHandle(_Symbol,999);
      if(hwnd==0)
        {
         chart=ChartOpen(_Symbol,999);
         if(chart<=0)
            return INIT_FAILED;
         //--- deleting all indicators from new chart (if its was opened by default template)
         //--- if you want use default template just delete this block
         for(int w=(int)ChartGetInteger(chart,CHART_WINDOWS_TOTAL)-1; w>=0; w--)
            for(int i=ChartIndicatorsTotal(chart,w)-1; i>=0; i--)
              {
               ResetLastError();
               string indy_name=ChartIndicatorName(chart,w,i);
               if(ChartIndicatorDelete(chart,w,indy_name))
                  Print("Error to delete indicator "+indy_name+" "+(string)GetLastError());
              }
         //--- save handle of new chart window
         hwnd=WindowHandle(_Symbol,999);
        }
      else
        if(chart<0)
           {
            chart=ChartFirst();
            while(chart>=0)
              {
               if(hwnd==ChartGetInteger(chart,CHART_WINDOW_HANDLE))
                 {
                  break;
                 }
               else
                 {
                  chart=ChartNext(chart);
                 }
              }
           }
      PostMessageA(hwnd,WM_COMMAND,33324,0);
     }
   else
     {
      FirstTick=false;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- Close ticks history file
   if(ExtHandle>=0)
     {
      FileClose(ExtHandle);
      ExtHandle=-1;
     }
//--- close ticks chart
   if(chart>0)
     {
      ChartClose(chart);
     }
//---
  }
//+------------------------------------------------------------------+
