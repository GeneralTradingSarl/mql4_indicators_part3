//+------------------------------------------------------------------+
//|                                       SymbolSynthesizer_Chart.mq4|
//|                                      Copyright (c)2015, alohafx  |
//+------------------------------------------------------------------+
#property copyright "alohafx"
#property link      "http://alohafx.blog36.fc2.com/"
#property indicator_chart_window
#property version   "1.00"

#include <WinUser32.mqh>

/*
Readme1: (about SymbolSynthesizer_Chart.mq4 from alohafx)------------+

This tool synthesizes any symbol from other symbols on Market Watch window.
Basic use is same with Period_Converter_Opt.mq4 since this is based on it.

Differences in Parameter settings are;
*extern int     spread      = 0;
   Spread in point for the sSym01(attached chart). 0 means current. 
   Since MT4 history file doesn't have past spread data, we need them to
   determine Ask price for the case dividing to calculate the price.
*extern int     vDigits     = 5;
   The digits for synthesized symbol. This is replaced OmitDigit.
*extern string vSymbol   ="EURUSD_v";
   The one you want to make. Any name is OK.
*extern string sSym01    ="EURGBP";
   Source symbol#1. 
   It has to be exact same on Market Watch include prefix and/or suffix.
   You should attach this tool on this chart to avoid getting Insufficient Data error
   when sCal is "D" and if the history file of sSym01 is not sufficient.
*extern string sSym02    ="GBPUSD";
   Source symbol#2.
   It has to be exact same on Market Watch include prefix and/or suffix.
*extern string sCal    ="M";
   The calculation to synthesize. "M" means "Multiply".
   If the price of vSymbol can be calculated by sSym01 multiply sSym02,  put "M".
      Ex: vSymbol="EURUSD"   sSym01="EURGBP"   sSym02="GBPUSD"
          vSymbol="EURJPY"   sSym01="EURGBP"   sSym02="GBPJPY"
          vSymbol="EURJPY"   sSym01="EURUSD"   sSym02="USDJPY"
          vSymbol="BTCJPY"   sSym01="BTCUSD"   sSym02="USDJPY"
      note: sSym01 and sSym02 can be switched each other since we multiply them.
   If the price of vSymbol can be calculated by sSym02 divided by aSym01, put "D" or other string.
      Ex: vSymbol="USDJPY"   sSym01="EURUSD"   sSym02="EURJPY"
          vSymbol="ZARJPY"   sSym01="USDZAR"   sSym02="USDJPY"
          vSymbol="EURUSD"   sSym01="USDJPY"   sSym02="EURJPY"
      note: sSym01 and sSym02 can NOT be switched each other since we divide.
      
Readme1 end:---------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                          Period_Converter_Opt.mq4|
//|                    Copyright (c)2005, MetaQuotes Software Corp.  |
//|                                        http://www.metaquotes.net |
//|                                       Ver.1.6 Modified by micclly|
//|                                       Ver.1.5 Modified by fai    |
//|             Modified by wfy05@talkforex based on Period_Converter|
//|                                        http://www.talkforex.com  |
//+------------------------------------------------------------------+
#property copyright "wfy05@talkforex.com"
#property link      "https://www.mql5.com/en/code/7673"
#property indicator_chart_window

#include <WinUser32.mqh>

Readme:     (about Period_Converter_Opt.mq4 from micclly)

I. Features:
This is an improved version of period converter for MT4 based on the
MT4's default period converter by metaquotes.
The default period converter script do not support real-time refreshing,
and consume lots of CPU (50%-9x%) making the whole system slow.
Also, the default one is a script which do not save when you exit MT4,
so you have to apply every converter script again after restarting, quite
annoying.

This one fixed all above problems:
1. Real-time updating or custom interval millisecond level updating.
2. Low CPU cost, average 5%-10% or less.
3. Works as an indicator, so can be saved and reloaded during restart. 
4. There is no one converter per chart limitation as it is not script
   any more, you can only use one window as source to generate as many
   new timeframe chart as possible.
5. Auto updating if there is new history block loaded.

II. How to use:
Copy the mq4 file to your MT4 indicators folder (experts\indicators)
to install it as an indicator, NOT script. then in the custom indicator 
list, attach period_converter_opt to the chart you want.
It support 4 parameters:
PeriodMultiplier:    new period multiplier factor, default is 2
UpdateInterval:      update interval in milliseconds, 
                     zero means update real-time. default is zero.
Enabled:             You can disable it without remove it with this option.

Other parameters are comments or for debugging, it is safe to ignore them.

Also Make sure you have Allow Dll imports option checked in common tab or
it won't work

After that, File->Open Offline to open the generated offline data. then
the offline data will be updated automatically.

As long as you keep the source chart open and the converter indicator 
running, the generated chart including indicators inside will always 
be updated. also you can close the generated chart and open again 
later from File->Open Offline without problem.

If you want to quit MT4, you can leave those offline chart as other
normal online charts. when you start MT4 next time, those charts will
also be loaded and updated.


III. Notes:
1. Do NOT uncheck the "offline chart" option in offline chart common properties.
   or after MT4 restart, it will treat that chart as online chart and request
   the data from server, resulting empty chart window.
2. You can attach more than one converter to same window with different 
   PeriodMultiplier, e.g: you can attach 3 converter with 
   PeriodMultiplier = 2, 4, 10 to M1 to generate M2, M4, M10 at the same time.
   It is even ok to use the M1 chart to generate Hourly chart like H2, which
   only cost a few more CPU resource during initial conversion. but usually 
   most server don't have much data for those short period. resulting the 
   generated data isn't long enough for long period. so it is suggested 
   to use Hourly/Daily charts as source when needed.
3. The real-time updating mode updates quotes as fast as possible, but as
   this is done via script, and MT will skip calling start() function when
   your PC is busy and lots of quotes income. anyway, this seldom happen,
   and you can at least get 10 updates each seconds which is much more
   than enough.
4. The offline chart don't have a bid line showing in chart, but all data
   in the chart including the indicators is still being updated, 
   so don't worry. you can show the bid line by unclick the "offline chart" 
   option in chart properties. but which don't helps much and if you forget
   to check "offline chart" option before exit. it will cause errors and
   become empty on next startup. you have to close the window and open
   again from File->Open offline, which don't worth the trouble.

IV. History:
2014.03.10  1.6      Modified to support build 600 and later
2009.08.07  1.5      Added 3 options.(ShiftTiming,GMTShift,OmitDigit)
2005.12.24  1.4      faster to detect if data changed by removing float point 
                     operations, added support to output CSV file in real time.
                     OutputCSVFile = 0 means no CSV.
                     OutputCSVFile = 1 means CSV + HST
                     OutputCSVFile = 2 CSV only, no HST .
                     (useful if you want to generate CSV for builtin periods)
                     CSV Filename will be the same as HST file except the extension.
                     added safe checking for PeriodMultiplier.
2005.12.04  1.3      Fixed missing data when there is large amount of data
                     loaded in several blocks, and support auto updating
                     when new history is loaded.
2005.11.29  1.2      Additional fix for missing data and server changing.
2005.11.29  1.1      Fixed missing partial data after restart.
                     Reinitialize after changing server or data corrupted.
2005.11.28  1.0      Initial release
*/

//extern double  Version = 1.0;             // code version
//extern string  BuildInfo = "2014.03.10 by micclly";
extern int     PeriodMultiplier= 1;      // new period multiplier factor
extern int     OutputCSVFile= 0;         // also output CSV file?
extern int     UpdateInterval= 0;        // update interval in milliseconds, zero means update real-time.
bool    Enabled=true;
bool    Debug=false;

extern int     ShiftTiming = 0;//0-3,Using H1Chart and PeriodMultiplier=4;
                               //if 1, ServerH4Chart = 00:00/04:00/08:00/12:00...
//   =>OfflineH4Chart = 01:00/05:00/09:00/13:00...
extern int     GMTShift    = 0;// if 9, ServerTime = GMT+0 -> OfflineChartTime = GMT+9  

extern int     vDigits     = 5;// The digits for synthesized symbol
extern int     spread      = 0;// Spread in point. 0 means current.
extern string  vSymbol="EURJPY_v";//Virtual symbol
string  sSym01="EURUSD";//Source symbol 1
extern string  sSym02="USDJPY";//Source symbol 2
extern string  sCal="M";//Calculation method

int      FileHandle= -1;
int      CSVHandle = -1;
int      varHandle = -1;
int      NewPeriod = 0;
string   MySymbol="";
int      ShiftBase;
#define OUTPUT_HST_ONLY    0
#define OUTPUT_CSV_HST     1
#define OUTPUT_CSV_ONLY    2


#define  CHART_CMD_UPDATE_DATA            33324
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DebugMsg(string msg)
  {
   if(Debug) Alert(msg);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   if(OpenHistoryFile() < 0) return (-1);
   sSym01=_Symbol;
   if(iOpen(sSym01,PERIOD_CURRENT,0)==0 || iOpen(sSym02,PERIOD_CURRENT,0)==0)
     {
      Print("Error: No data");
      return (-1);
     }

   ShiftBase=Period()*60;//sec
   string suffix="";
   if(ShiftTiming != 0) suffix =StringConcatenate(suffix,"s",ShiftTiming);
   if(GMTShift    != 0) suffix =StringConcatenate(suffix,"g",GMTShift);
//if(OmitDigit   != 0) suffix =StringConcatenate(suffix,"o"/*,OmitDigit*/);
   MySymbol=vSymbol+"_"+suffix;
   if(StringLen(MySymbol)>11)
      MySymbol=StringConcatenate(StringSubstr(MySymbol,0,11-StringLen(suffix)),suffix);

//safe checking for PeriodMultiplier.
   if(PeriodMultiplier<=1 && suffix=="") 
     {
      //only output CSV file
      PeriodMultiplier=1;
      //OutputCSVFile = 2;
     }
   NewPeriod= Period() * PeriodMultiplier;
   if(spread==0) spread=SymbolInfoInteger(_Symbol,SYMBOL_SPREAD);
   WriteHistoryHeader();
   UpdateHistoryFile(Bars-1,true);
   UpdateChartWindow();
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
//Close file handle
   if(FileHandle>=0) 
     {
      FileClose(FileHandle);
      FileHandle=-1;
     }
   if(CSVHandle>=0) 
     {
      FileClose(CSVHandle);
      CSVHandle=-1;
     }
   if(varHandle>=0) 
     {
      FileClose(varHandle);
      varHandle=-1;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OpenHistoryFile()
  {
   string name;

   name=MySymbol+NewPeriod;
   if(OutputCSVFile!=OUTPUT_CSV_ONLY) 
     {
      FileHandle=FileOpenHistory(name+".hst",FILE_BIN|FILE_WRITE|FILE_SHARE_READ);
      if(FileHandle < 0) return(-1);
     }
   if(OutputCSVFile!=OUTPUT_HST_ONLY) 
     {
      CSVHandle=FileOpen(name+".csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI,',');
      if(CSVHandle < 0) return(-1);
     }
   varHandle=FileOpen(MySymbol+".csv",FILE_CSV|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI,',');
   if(varHandle < 0) return(-1);

   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int WriteHistoryHeader()
  {
   string c_copyright;
//   int    i_digits = Digits-OmitDigit;
   int    i_unused[13]={0};
   int    version=400;

   if(FileHandle < 0) return (-1);
   c_copyright="(C)opyright 2015, alohafx";
   FileWriteInteger(FileHandle,version,LONG_VALUE);
   FileWriteString(FileHandle,c_copyright,64);
   FileWriteString(FileHandle,MySymbol,12);
   FileWriteInteger(FileHandle,NewPeriod,LONG_VALUE);
   FileWriteInteger(FileHandle,vDigits,LONG_VALUE);
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //timesign
   FileWriteInteger(FileHandle, 0, LONG_VALUE);       //last_sync
   FileWriteArray(FileHandle,i_unused,0,ArraySize(i_unused));

   uint bi;
   if(varHandle>=0) 
     {
      bi=FileWrite(varHandle,
                   DoubleToStr(vDigits,0),
                   sSym01,
                   sSym02,
                   sCal);
      if(bi>0) FileClose(varHandle);
      Print(bi);
     }

   return (0);
  }

static double d_open,d_low,d_high,d_close,d_volume;
static int i_time;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteHistoryData()
  {
   if(FileHandle>=0) 
     {
      FileWriteInteger(FileHandle,i_time+GMTShift*60*60,LONG_VALUE);
      FileWriteDouble(FileHandle,d_open,DOUBLE_VALUE);
      FileWriteDouble(FileHandle,d_low,DOUBLE_VALUE);
      FileWriteDouble(FileHandle,d_high,DOUBLE_VALUE);
      FileWriteDouble(FileHandle,d_close,DOUBLE_VALUE);
      FileWriteDouble(FileHandle,d_volume,DOUBLE_VALUE);
     }
   if(CSVHandle>=0) 
     {
      //      int i_digits = Digits-OmitDigit;

      FileWrite(CSVHandle,
                TimeToStr(i_time,TIME_DATE),
                TimeToStr(i_time,TIME_MINUTES),
                DoubleToStr(d_open,vDigits),
                DoubleToStr(d_high,vDigits),
                DoubleToStr(d_low,vDigits),
                DoubleToStr(d_close,vDigits),
                d_volume);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int UpdateHistoryFile(int start_pos,bool init=false)
  {
   static int last_fpos,csv_fpos;
   int i,ps;
   double open1,open2,high1,high2,low1,low2,close1,close2;
//   int i_digits = Digits-OmitDigit;

   if(FileHandle < 0) return (-1);
// normalize open time
   ps=NewPeriod*60;
   i_time = (Time[start_pos]-ShiftBase*ShiftTiming)/ps;
   i_time =  i_time*ps + ShiftBase*ShiftTiming;
   if(init) 
     {
      //first time, init data
      open1=iOpen(sSym01,PERIOD_CURRENT,start_pos);   open2=iOpen(sSym02,PERIOD_CURRENT,start_pos);
      low1=iLow(sSym01,PERIOD_CURRENT,start_pos);     low2=iLow(sSym02,PERIOD_CURRENT,start_pos);
      high1=iHigh(sSym01,PERIOD_CURRENT,start_pos);   high2=iHigh(sSym02,PERIOD_CURRENT,start_pos);
      close1=iClose(sSym01,PERIOD_CURRENT,start_pos); close2=iClose(sSym02,PERIOD_CURRENT,start_pos);
      if(open1==0 || low1==0 || high1==0 || close1==0) 
        {
         Print("Error! Insufficient Data.");
         return(-1);
        }
      if(sCal=="M")
        {
         d_open= NormalizeDouble(open1*open2,vDigits);
         d_low = NormalizeDouble(low1*low2,vDigits);
         d_high= NormalizeDouble(high1*high2,vDigits);
         d_close=NormalizeDouble(close1*close2,vDigits);
        }
      else
        {
         d_open= NormalizeDouble(open2/(open1+spread*_Point),vDigits);
         d_low = NormalizeDouble(low2/(low1+spread*_Point),vDigits);
         d_high= NormalizeDouble(high2/(high1+spread*_Point),vDigits);
         d_close=NormalizeDouble(close2/(close1+spread*_Point),vDigits);
        }
      d_volume=iVolume(sSym01,PERIOD_CURRENT,start_pos)+iVolume(sSym02,PERIOD_CURRENT,start_pos);
      i=start_pos-1;
      if(FileHandle>= 0) last_fpos = FileTell(FileHandle);
      if(CSVHandle >= 0) csv_fpos = FileTell(CSVHandle);
        } else {
      i=start_pos;
      if(FileHandle>= 0) FileSeek(FileHandle,last_fpos,SEEK_SET);
      if(CSVHandle >= 0) FileSeek(CSVHandle,csv_fpos,SEEK_SET);
     }
   if(i < 0) return (-1);

   int cnt=0;
   int LastBarTime;
//processing bars
   while(i>=0) 
     {
      LastBarTime=Time[i];

      open1=iOpen(sSym01,PERIOD_CURRENT,i);   open2=iOpen(sSym02,PERIOD_CURRENT,i);
      low1=iLow(sSym01,PERIOD_CURRENT,i);     low2=iLow(sSym02,PERIOD_CURRENT,i);
      high1=iHigh(sSym01,PERIOD_CURRENT,i);   high2=iHigh(sSym02,PERIOD_CURRENT,i);
      close1=iClose(sSym01,PERIOD_CURRENT,i); close2=iClose(sSym02,PERIOD_CURRENT,i);
      if(open1==0 || low1==0 || high1==0 || close1==0) 
        {
         Print("Error! Insufficient Data.");
         return(-1);
        }
      //a new bar
      if(LastBarTime>=i_time+ps) 
        {
         //write the bar data
         WriteHistoryData();
         cnt++;
         i_time = (LastBarTime-ShiftBase*ShiftTiming)/ps;
         i_time =  i_time*ps + ShiftBase*ShiftTiming;

         if(sCal=="M")
           {
            d_open= NormalizeDouble(open1*open2,vDigits);
            d_low = NormalizeDouble(low1*low2,vDigits);
            d_high= NormalizeDouble(high1*high2,vDigits);
            d_close=NormalizeDouble(close1*close2,vDigits);
           }
         else
           {
            d_open= NormalizeDouble(open2/(open1+spread*_Point),vDigits);
            d_low = NormalizeDouble(low2/(low1+spread*_Point),vDigits);
            d_high= NormalizeDouble(high2/(high1+spread*_Point),vDigits);
            d_close=NormalizeDouble(close2/(close1+spread*_Point),vDigits);
           }
         d_volume=iVolume(sSym01,PERIOD_CURRENT,i)+iVolume(sSym02,PERIOD_CURRENT,i);
           } else {
         //no new bar
         d_volume+=iVolume(sSym01,PERIOD_CURRENT,i)+iVolume(sSym02,PERIOD_CURRENT,i);
         if(sCal=="M")
           {
            if(low1*low2<d_low) d_low=NormalizeDouble(low1*low2,vDigits);
            if(high1*high2>d_high) d_high=NormalizeDouble(high1*high2,vDigits);
            d_close=NormalizeDouble(close1*close2,vDigits);
           }
         else
           {
            if(low2/(low1+spread*_Point)<d_low) d_low=NormalizeDouble(low2/(low1+spread*_Point),vDigits);
            if(high2/(high1+spread*_Point)>d_high) d_high=NormalizeDouble(high2/(high1+spread*_Point),vDigits);
            d_close=NormalizeDouble(close2/(close1+spread*_Point),vDigits);
           }
        }
      i--;
     }

//record last_fpos before writing last bar.
   if(FileHandle>= 0) last_fpos = FileTell(FileHandle);
   if(CSVHandle >= 0) csv_fpos = FileTell(CSVHandle);

   WriteHistoryData();
   cnt++;
   d_volume-=iVolume(sSym01,PERIOD_CURRENT,0)+iVolume(sSym02,PERIOD_CURRENT,0);

//flush the data writen
   if(FileHandle>= 0) FileFlush(FileHandle);
   if(CSVHandle >= 0) FileFlush(CSVHandle);
   return (cnt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int UpdateChartWindow()
  {
   static int hwnd=0;

   if(FileHandle<0) 
     {
      //no HST file opened, no need updating.
      return (-1);
     }
   if(hwnd==0) 
     {
      //trying to detect the chart window for updating
      hwnd=WindowHandle(MySymbol,NewPeriod);
     }
   if(hwnd!=0) 
     {
      if(IsDllsAllowed()==false) 
        {
         //DLL calls must be allowed
         DebugMsg("Dll calls must be allowed");
         return (-1);
        }
      if(PostMessageA(hwnd,WM_COMMAND,CHART_CMD_UPDATE_DATA,0)==0) 
        {
         //PostMessage failed, chart window closed
         hwnd=0;
           } else {
         //PostMessage succeed
         return (0);
        }
     }
//window not found or PostMessage failed
   return (-1);
  }

/*
int PerfCheck(bool Start)
{
   static int StartTime = 0;
   static int Index = 0;
   
   if (Start) {
      StartTime = GetTickCount();
      Index = 0;
      return (StartTime);
   }
   Index++;
   int diff = GetTickCount() - StartTime;
   Alert("Time used [" + Index + "]: " + diff);
   StartTime = GetTickCount();
   return (diff);
}
*/

static int LastStartTime=0;
static int LastEndTime=0;
static int LastBarCount=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void reinit()
  {
   deinit();
   init();
   LastStartTime=Time[Bars-1];
   LastEndTime=Time[0];
   LastBarCount=Bars;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsDataChanged()
  {
/*
   static int LastBars = 0, LastTime = 0, LastVolume = 0;
   static double LastOpen = 0, LastClose = 0, LastHigh = 0, LastLow = 0;
   
   if (LastVolume != Volume[0] || LastBars != Bars || LastTime != Time[0]|| 
      LastClose != Close[0] || LastHigh != High[0] || LastLow != Low[0] || 
      LastOpen != Open[0]) {

      LastBars = Bars;
      LastVolume = Volume[0];
      LastTime = Time[0];
      LastClose = Close[0];
      LastHigh = High[0];
      LastLow = Low[0];
      LastOpen = Open[0];
      return (true);
   }
   return (false);
*/
/*
   fast version without float point operation
*/
   static int LastBars=0,LastTime=0,LastVolume=0;
   bool ret;

   ret=false;
   if(LastVolume!=Volume[0]) 
     {
      LastVolume=Volume[0];
      ret=true;
     }
   if(LastTime!=Time[0]) 
     {
      LastTime=Time[0];
      ret=true;
     }
   if(LastBars!=Bars) 
     {
      LastBars=Bars;
      ret=true;
     }
   return (ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CheckNewData()
  {
   static string LastServer="";

   if(Bars<2) 
     {
      //the data is not loaded yet.
      DebugMsg("Data not loaded, only "+Bars+" Bars");
      return (-1);
     }

   string serv=ServerAddress();
   if(serv=="") 
     {
      //no server yet
      DebugMsg("No server connected");
      return (-1);
     }

//server changed? check this and reinit to prevent wrong data while changing server.
   if(LastServer!=serv) 
     {
      DebugMsg("Server changed from "+LastServer+" to "+serv);
      LastServer=serv;
      reinit();
      return (-1);
     }

   if(!IsDataChanged()) 
     {
      //return if no data changed to save resource
      //DebugMsg("No data changed");
      return (-1);
     }

   if(Time[Bars-1]!=LastStartTime) 
     {
      DebugMsg("Start time changed, new history loaded or server changed");
      reinit();
      return (-1);
     }

   int i,cnt;

//try to find LastEndTime bar, which should be Time[0] or Time[1] usually,
//so the operation is fast
   for(i=0; i<Bars; i++) 
     {
      if(Time[i]<=LastEndTime) 
        {
         break;
        }
     }

   if(i>=Bars || Time[i]!=LastEndTime) 
     {
      DebugMsg("End time "+TimeToStr(LastEndTime)+" not found");
      reinit();
      return (-1);
     }

   cnt=Bars-i;
   if(cnt!=LastBarCount) 
     {
      DebugMsg("Data loaded, cnt is "+cnt+" LastBarCount is "+LastBarCount);
      reinit();
      return (-1);
     }

//no new data loaded, return with LastEndTime position.
   LastBarCount= Bars;
   LastEndTime = Time[0];
   return (i);
  }
//+------------------------------------------------------------------+
//| program start function                                           |
//+------------------------------------------------------------------+
int start()
  {
   static int last_time=0;

   if(!Enabled) return (0);

//always update or update only after certain interval
   if(UpdateInterval!=0) 
     {
      int cur_time;

      cur_time=GetTickCount();
      if(MathAbs(cur_time-last_time)<UpdateInterval) 
        {
         return (0);
        }
      last_time=cur_time;
     }

//if (Debug) PerfCheck(true);
   int n=CheckNewData();
//if (Debug) PerfCheck(false);   
   if(n < 0) return (0);

//update history file with new data
   UpdateHistoryFile(n);
//refresh chart window
   UpdateChartWindow();
//if (Debug) PerfCheck(false);
   return(0);
  }
//+------------------------------------------------------------------+
