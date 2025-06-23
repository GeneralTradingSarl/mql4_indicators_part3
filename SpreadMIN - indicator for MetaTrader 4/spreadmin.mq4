//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Red
#property indicator_width1  2
#property indicator_minimum 0 // Set indicator fixed min is 0
//---
double spreadbufferMIN[]; // Buffer to hold the array of spreads
double tempmin=0;
//---
string FileName;
bool SymbolIsValid;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(0); // We don't need to display fractions
//---
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,indicator_width1,indicator_color1);
   SetIndexBuffer(0,spreadbufferMIN);
//---
   IndicatorShortName("spreadmin");
   SetIndexLabel(0,"Spread");
//---
   SymbolIsValid=((MarketInfo(Symbol(),MODE_BID)!=0));
   FileName=Symbol()+EnumToString(PERIOD_CURRENT)+"-MINs.dat";
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(SymbolIsValid) {WriteSpread();} return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetData()
  {
   double MIN;
   int i;
   int handle=FileOpen(FileName,FILE_BIN|FILE_READ);
//---
   if(handle < 0) return;
//---
   while(!FileIsEnding(handle))
     {
      datetime MyTime=(datetime)FileReadLong(handle);
      MIN=FileReadDouble(handle);
      //---
      i=iBarShift(Symbol(),Period(),MyTime,TRUE);
      //---
      if(i>=0)
        {
         spreadbufferMIN[i]=MIN;
        }
     }
   FileClose(handle);
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteSpread()
  {
   int handle=FileOpen(FileName,FILE_BIN|FILE_READ|FILE_WRITE);
//---
   FileSeek(handle,0,SEEK_END);
   FileWriteLong(handle,Time[0]);
   FileWriteDouble(handle,spreadbufferMIN[0]);
   FileClose(handle);
   return;
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
   double MySpread=MarketInfo(Symbol(),MODE_SPREAD);;
//---
   static bool FirstRun=TRUE;
//---
   if(!SymbolIsValid) {GetData(); return(rates_total);}
//---
   if(FirstRun)
     {
      GetData();
      FirstRun=FALSE;
      tempmin = MySpread;
      return(rates_total);
     }
//---
   if(MySpread<=spreadbufferMIN[0])
     {spreadbufferMIN[0]=MySpread; tempmin=MySpread; }
   else
     {spreadbufferMIN[0]=tempmin;}
//---
   WriteSpread();
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
