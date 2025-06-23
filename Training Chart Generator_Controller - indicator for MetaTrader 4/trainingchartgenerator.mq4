//+------------------------------------------------------------------+
//|                                       TrainingChartGenerator.mq4 |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window

input bool bAutoLoadControllerTemplate = true;                          // Auto Apply Template
input string strControllerTemplate = "TrainingChartControllerTemplate"; // Name of Template

string gvNameStart, gvNameNextBar, gvNameStop, gvNameRestart;
int iTgtPeriod;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   if (Period()<PERIOD_D1)
      iTgtPeriod = Period()+1;
   else
      iTgtPeriod = Period()-1;
   
   gvNameStart = "TrainingChart-Start-"+Symbol()+"-"+string(iTgtPeriod);
   gvNameNextBar = "TrainingChart-NextBar-"+Symbol()+"-"+string(iTgtPeriod);
   gvNameStop = "TrainingChart-Stop-"+Symbol()+"-"+string(iTgtPeriod);
   gvNameRestart = "TrainingChart-Restart-"+Symbol()+"-"+string(iTgtPeriod);

   EventSetMillisecondTimer(250);
   
   Comment ("Press 'o' to open training chart.");
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
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

   return(rates_total);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   static bool bFirstTime = true;
   static datetime iPrevStartTime = 0;
   datetime iCurrTime = LocalTime();
   datetime iStartTime = MathMax(Time[Bars-1],datetime(GlobalVariableGet(gvNameStart)));
   datetime iStopTime = datetime(GlobalVariableGet(gvNameStop));

   if (iStartTime==0)
      iStartTime = TimeCurrent();
   if (iStopTime==0)
      iStopTime = iStartTime;
   
   int i;
   MqlRates rate;
   long iChartID = 0;

   static CHistoryFile historyFile();

   if (iPrevStartTime==0)
      iPrevStartTime = iStartTime;
   
   if (iPrevStartTime!=iStartTime || GlobalVariableGet(gvNameRestart)>0 ||
       GlobalVariableGet(gvNameNextBar)<0)
   {
      bFirstTime = true;
      if (iPrevStartTime!=iStartTime || GlobalVariableGet(gvNameRestart)>0)
      {
         iPrevStartTime = iStartTime;
         iStopTime = iStartTime;
      }
      else
      {
         int iStopBar = iBarShift(Symbol(),Period(),iStopTime);
         iStopBar = iStopBar - int(GlobalVariableGet(gvNameNextBar));
         iStopTime = iTime(Symbol(),Period(),MathMin(iBars(Symbol(),Period())-1,iStopBar));
         iStartTime = MathMin(iStartTime,iStopTime);
      }
      historyFile.Reset();
      GlobalVariableSet(gvNameRestart,0);
      GlobalVariableSet(gvNameNextBar,0);
      GlobalVariableSet(gvNameStop,iStopTime);
   }
   
   if (bFirstTime)
   {
      historyFile.Init(Symbol(),iTgtPeriod);
      historyFile.OpenFile();
      historyFile.WriteHeader();
      for(i=iBars(Symbol(),Period())-1; i>=0; i--)
      {
         if (Time[i]>iStopTime)
            break;
         if (FillRate(rate,i))
            historyFile.WriteRate(rate);
      }
      bFirstTime = false;
   }
   else
   if (GlobalVariableGet(gvNameNextBar)>0)
   {
      int iCnt = int(GlobalVariableGet(gvNameNextBar));
      i = iBarShift(Symbol(),Period(),iStopTime);
      while (i>0 && iCnt>0)
      {
         i--; iCnt--;
         if (FillRate(rate,i))
            historyFile.WriteRate(rate);
      }
      GlobalVariableSet(gvNameStop,iTime(Symbol(),Period(),i));
      GlobalVariableSet(gvNameNextBar,0);
   }
   
   long iID = ChartFirst();
   while (iID>=0)
   {
      if (ChartSymbol(iID)==Symbol() && ChartPeriod(iID)==iTgtPeriod && ChartGetInteger(iID,CHART_IS_OFFLINE))
      {
         iChartID = iID;
         ChartRedraw(iChartID);
         ChartSetSymbolPeriod(iChartID,Symbol(),iTgtPeriod);
      }
      iID = ChartNext(iID);
   }
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if (id==CHARTEVENT_KEYDOWN)
   {
      if (TranslateKey((int)lparam)=='o')
      {
         long iID = ChartOpen(Symbol(),iTgtPeriod);
         if (iID!=0)
            if (!ChartApplyTemplate(iID,strControllerTemplate))
               Print ("Template ", strControllerTemplate, " not found!");
      }
   }
}

bool FillRate(MqlRates &rate, int iBar)
{
   if (iBar>=0 && iBar<iBars(Symbol(),Period()))
   {
      rate.open = Open[iBar];
      rate.close = Close[iBar];
      rate.low = Low[iBar];
      rate.high = High[iBar];
      rate.real_volume = 0;
      rate.tick_volume = (long)Volume[iBar];
      rate.spread = 0;
      rate.time = Time[iBar];
      return true;
   }
   return false;
}

class CHistoryFile
{
private:
   string m_strFileName;
   int m_iHandle;
   datetime m_iLastWrittenBarTime;
   ulong    m_iPosSize;
   ulong    m_iLastPos;
   int      m_iVersion;
   string   m_strCopyright;
   string   m_strSymb;
   int      m_iPeriod;
   int      m_iDigits;
   int      m_iUnused[13];

public:
   CHistoryFile();
   ~CHistoryFile();
   void Init(string strSymb, int iPeriod);
   bool OpenFile();
   bool Reset();
   bool WriteHeader();
   bool WriteRate(MqlRates &rate);
};

void CHistoryFile::CHistoryFile()
{
}

void CHistoryFile::Init(string strSymb, int iPeriod)
{
   m_iVersion = 401;
   m_strCopyright = "(C)opyright 2003, MetaQuotes Software Corp.";
   m_strSymb = strSymb;
   m_iPeriod = iPeriod;
   m_strFileName = m_strSymb+(string)m_iPeriod+".hst";
   m_iDigits = Digits;
   
   Reset();
}

void CHistoryFile::~CHistoryFile()
{
   if(m_iHandle>=0)
   {
      FileClose(m_iHandle);
      m_iHandle = -1;
   }
}

bool CHistoryFile::OpenFile()
{
   if (m_iHandle<0)
      FileClose(m_iHandle);
      
   m_iHandle = FileOpenHistory(m_strFileName,FILE_BIN|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ|FILE_ANSI);
   if(m_iHandle<0)
   {
      Print ("History file open error: ", GetLastError());
      return false;
   }
   return true;
}

bool CHistoryFile::Reset()
{
   if (m_iHandle>0)
      FileClose(m_iHandle);

   m_iHandle = FileOpenHistory(m_strFileName,FILE_BIN|FILE_WRITE|FILE_ANSI);
   if (m_iHandle>0)
      FileClose(m_iHandle);
   
   m_iPosSize = 0;
   m_iLastPos = 0;
   m_iLastWrittenBarTime = 0;
   m_iHandle = -1;
   ArrayInitialize(m_iUnused,0);

   return true;
}

bool CHistoryFile::WriteHeader()
{
   FileWriteInteger(m_iHandle,m_iVersion,LONG_VALUE);
   FileWriteString(m_iHandle,m_strCopyright,64);
   FileWriteString(m_iHandle,m_strSymb,12);
   FileWriteInteger(m_iHandle,m_iPeriod,LONG_VALUE);
   FileWriteInteger(m_iHandle,m_iDigits,LONG_VALUE);
   FileWriteInteger(m_iHandle,0,LONG_VALUE);
   FileWriteInteger(m_iHandle,0,LONG_VALUE);
   FileWriteArray(m_iHandle,m_iUnused,0,13);
   
   return true;
}

bool CHistoryFile::WriteRate(MqlRates &rate)
{
   if (m_iLastWrittenBarTime<rate.time)
   {
      uint iWritten = FileWriteStruct(m_iHandle,rate);
      FileFlush(m_iHandle);
      m_iLastWrittenBarTime = rate.time;

      if (m_iPosSize==0)
      {
         if (m_iLastPos==0)
            m_iLastPos = FileTell(m_iHandle);
         ulong m_iCurrPos = FileTell(m_iHandle);
         if (m_iCurrPos>m_iLastPos)
            m_iPosSize = m_iCurrPos-m_iLastPos;
      }
      
      return true;
   }
   
   return false;
}
