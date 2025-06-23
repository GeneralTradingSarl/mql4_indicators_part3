//+--------------------------------------------+
//|                           TickRecorder.mq4 |
//|           Copyright (c) 2016 David Ruzicka |
//| https://www.mql5.com/en/users/davidruzicka |
//+--------------------------------------------+
#property copyright "Copyright (c) 2016 David Ruzicka"
#property link      "https://www.mql5.com/en/users/davidruzicka"
#property indicator_chart_window
//+------------------------------------------------------------------+
string fileName;
int fileHandle;
//+------------------------------------------------------------------+
long lastTickVolume=-1;
datetime lastFlushTime;
//+------------------------------------------------------------------+
#import "kernel32.dll"
void GetLocalTime(int &TimeArray[]);
#import
//+------------------------------------------------------------------+
int OnInit()
  {
   int result=INIT_FAILED;

   fileName=Symbol()+"_tick.csv";

   if(OpenFileHandle(fileHandle,fileName))
     {
      result=INIT_SUCCEEDED;
     }

   lastFlushTime=TimeCurrent();

   return( result );
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(fileHandle!=INVALID_HANDLE)
     {
      FileClose(fileHandle);
     }
  }
//+------------------------------------------------------------------+
int OnCalculate(
                const int rates_total,      // size of input time series 
                const int prev_calculated,  // bars handled in previous call 
                const datetime& time[],     // Time 
                const double& open[],       // Open 
                const double& high[],       // High 
                const double& low[],        // Low 
                const double& close[],      // Close 
                const long& tick_volume[],  // Tick Volume 
                const long& volume[],       // Real Volume 
                const int& spread[]         // Spread 
                )
  {
   int TimeArray[4];
   GetLocalTime(TimeArray);
   int milliSeconds=TimeArray[3]>>16;
   string milliSecondsStr=IntegerToString(milliSeconds,3,'0');

   datetime serverTime=TimeCurrent();

   string dateTimeStr=TimeToString(serverTime,TIME_DATE|TIME_MINUTES|TIME_SECONDS);

   ArraySetAsSeries(tick_volume,true);
   long tickVolume=tick_volume[0];
   long tickVolumeDiff=(lastTickVolume==-1) ? 1 :(tickVolume>lastTickVolume ? tickVolume-lastTickVolume : tickVolume);
   lastTickVolume=tickVolume;

   uint bytesWritten=FileWrite(fileHandle,dateTimeStr+"."+milliSecondsStr,NormalizeDouble(Bid,Digits),NormalizeDouble(Ask,Digits),tickVolumeDiff);
   if(bytesWritten==0)
     {
      Alert(StringFormat("Failed to write tick file data into \"%s\"; error: %d",fileName,GetLastError()));
     }

// flush after 10 seconds
   if(serverTime-lastFlushTime>10)
     {
      FileFlush(fileHandle);
      lastFlushTime=TimeCurrent();
     }

   return(0);
  }
//+------------------------------------------------------------------+
bool OpenFileHandle(int &handle,string name)
  {
   handle=FileOpen(name,FILE_SHARE_READ|FILE_CSV|FILE_WRITE|FILE_READ,',');
   if(handle==INVALID_HANDLE)
     {
      Alert("Failed to open tick file \"",name,"\"; error: ",GetLastError());
      return(false);
     }
   else if(FileSize(handle)==0)
     {
      uint bytesWritten=FileWrite(handle,"datetime","bid","ask","volume");
      if(bytesWritten==0)
        {
         Alert("Failed to write tick file header into \"",name,"\"; error: ",GetLastError());
         return(false);
        }
     }
   else
     {
      FileSeek(handle,0,SEEK_END);
     }

   return(true);
  }
//+------------------------------------------------------------------+
