//+------------------------------------------------------------------+
//|                                            RogueTickDetector.mq4 |
//|                                               AwarenessForex.com |
//|                                    http://www.AwarenessForex.com |
//+------------------------------------------------------------------+
#property copyright "AwarenessForex.com"
#property link      "http://www.AwarenessForex.com"

#property indicator_chart_window
extern bool PopupAlert = true;
extern bool EmailAlert = false;
extern bool EnableAuditTrailLogging = true;
datetime lastTickTime;
double lastBid;
double lastAsk;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   lastTickTime = MarketInfo(Symbol(), MODE_TIME);
   //Open the log file
   if (EnableAuditTrailLogging) {
      OpenAuditLogFile();
   }
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   CloseAuditLogFile();
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   // Check for rogue ticks which trigger close all
   datetime curTickTime = MarketInfo(Symbol(), MODE_TIME);
   if (lastTickTime > curTickTime) {
      MyAlerts("Rogue tick detected for Symbol " + Symbol() + 
                ", Rogue Tick Time " + TimeToStr(curTickTime, TIME_DATE|TIME_SECONDS) +
                " , Bid " + DoubleToStr( lastBid, Digits ) + " / Ask " + DoubleToStr( lastAsk, Digits ) +
                "; Last Tick Time " + TimeToStr(lastTickTime, TIME_DATE|TIME_SECONDS) +
                " / Bid " + MarketInfo(Symbol(), MODE_BID) +
                " / Ask " + MarketInfo(Symbol(), MODE_ASK),
                "Rogue Tick " + Symbol(),
                PopupAlert, EmailAlert, false, false, EnableAuditTrailLogging);
      lastTickTime = curTickTime;
      lastBid = MarketInfo(Symbol(), MODE_BID);
      lastAsk = MarketInfo(Symbol(), MODE_ASK);
   }
   lastTickTime = curTickTime;
   lastBid = MarketInfo(Symbol(), MODE_BID);
   lastAsk = MarketInfo(Symbol(), MODE_ASK);
   return(0);
}

int MyAlerts(string AlertText, string SubjectText, bool UseAlert, bool UseEmail, bool UseVoice, bool UseSnapShoot, bool UseLog) {

   if (UseAlert) Alert(AlertText);

   if (UseEmail){
      if (SubjectText != "") SendMail(SubjectText, AlertText);
      else SendMail(AlertText, AlertText);
   }

   if (UseSnapShoot) {
      string SnapShootFilename = StringConcatenate(AlertText, ".gif");
      WindowScreenShot(SnapShootFilename, 640, 480);
      if (UseAlert) Alert(Symbol(), " Snapshot taken");
   }


   if (UseLog)
      WriteAuditLog(AlertText);

   return (0);
}

//+------------------------------------------------------------------+
//| AUDIT LOG FILE |
//+------------------------------------------------------------------+
int AuditLogFileHandle = -1;
void OpenAuditLogFile() {
   string auditLogFileName = TimeToStr(TimeLocal(), TIME_DATE) + " - Rogue Tick - " + Symbol() + " " + " Activity.log";
   AuditLogFileHandle = FileOpen(auditLogFileName, FILE_BIN | FILE_WRITE | FILE_READ);

   if (AuditLogFileHandle > 0) {
      int error = GetLastError();
      FileSeek(AuditLogFileHandle, 0, SEEK_END);

      if ((error > 0) && (error != 4200) && (error != 4058))
         Print("Log File Error : ", auditLogFileName + " " , error);
   }
}


void CloseAuditLogFile() {
  if (AuditLogFileHandle != -1)
     FileClose(AuditLogFileHandle);
}

int WriteAuditLog(string text) {

   if (AuditLogFileHandle == -1 && !EnableAuditTrailLogging)
      return;

   string TempText = StringConcatenate(TimeToStr(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), " - ", text, "\n");

   FileWriteString(AuditLogFileHandle, TempText, StringLen(TempText));

   FileFlush(AuditLogFileHandle);

   return (0);
}

//+------------------------------------------------------------------+