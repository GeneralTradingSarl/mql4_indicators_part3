//+----------------------------------------------------------------------------------------------------------------------+
//| TIME, forex sessions and trade hours monitor                                       MT4 indicator  TIME II (VBO).mq4  |
//| ©Vadim Baklanov, 2009                                                              (nickname gip on forum.mql4.com)  |
//| Индикатор для отображения торговых сессий и всемирного времени                                       ispgip@mail.ru  |
//|                                                                                                      ICQ: 123372230  |
//| v2.0 Request updates and bug fixing on ICQ or skype                                                  Skype: adam_vb  |
//+----------------------------------------------------------------------------------------------------------------------+

// en
// Recommended:
// After indicator attached on chart, F8 -> "Common" tab -> Check box "Show object descriptions" and uncheck "Show grid"

// ru
// При установленной галочке дополнительно отображается шкала времени UTC/GMT в нижней части окна индикатора
// Отображение сетки в окне графика цены (Ctrl-G) затрудняет восприятие информации отображаемой индикатором
//
// Индикатор будет дорабатываться в дальнейшем, поэтому прошу всех обращаться по вопросам правильности, 
// удобства работы и состава отображаемой индикатором информации. Мои контактные данные указаны выше.


// References:

// www.timeanddate.com
// http://en.wikipedia.org/wiki/List_of_stock_exchanges
// http://www.wikinvest.com/wiki/List_of_Stock_Exchanges (Market Hours reference)

// New York Stock Exchange (NYSE Euronext)      http://www.nyse.com/ 
// Tokyo Stock Exchange (TSE)                   http://www.tse.or.jp/english/   http://en.wikipedia.org/wiki/Tokyo_stock_exchange
// NASDAQ Stock market                          http://www.nasdaq.com/
// London Stock Exchange (LSE)                  http://www.londonstockexchange.com/home/homepage.htm   http://en.wikipedia.org/wiki/London_Stock_Exchange
// Hong Kong (HKEx)                             http://www.hkex.com.hk/index.htm   http://en.wikipedia.org/wiki/Hong_Kong_Stock_Exchange
// Toronto Stock Exchange                   
// Frankfurt (FSE) Borse Frankfurt, Deutsche Borse Group
//                                              http://www.boerse-frankfurt.de/EN/index.aspx   http://en.wikipedia.org/wiki/Frankfurt_Stock_Exchange 
// Shanghai Stock Exchange (SSE)                http://www.sse.com.cn/sseportal/en_us/ps/home.shtml
// Bolsas y Mercados Espanoles (BME) Spanish Exchanges    
//                                              http://www.bolsamadrid.es/ing/portada.htm   http://en.wikipedia.org/wiki/Bolsa_de_Madrid
// Australian Securities Exchange (ASX)         http://www.asx.com.au/   http://en.wikipedia.org/wiki/Australian_Securities_Exchange
// Swiss Exchange, SWX — $1,318                 http://www.six-swiss-exchange.com/index.html
// Nordic Stock Exchange Group OMX  — $1,296    http://www.nasdaqomx.com/
// Borsa Italiana S.p. A., ISE  — $1,123        http://www.borsaitaliana.it/homepage/homepage.htm
// Bombay Stock Exchange Limited  — $1,005      http://www.bseindia.com/
// KRX Korea Exchange  — $1,001                 http://www.krx.co.kr/index.html
// BM&FBOVESPA                                  http://www.bovespa.com.br/indexi.asp
// NSE National Stock Exchange of India Ltd     http://www.nse-india.com/ 
// ММВБ(Moscow) & MICEX                         http://www.micex.com/
// JSE Securities Exchange South Africa         http://www.jse.co.za/index.jsp
// TAIWAN Stock Exchange                        http://www.twse.com.tw/en/


#property copyright "©Vadim Baklanov(gip), 2009"
#property link      "ispgip@mail.ru"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1


// Brokers standard time zone (EST):
extern int Broker_standard_time_zone = +1;
extern datetime Broker_DST_start     = D'01.01.2001 00:00:00';
extern datetime Broker_DST_end       = D'01.01.2001 00:00:00';
extern color Clock_color= DarkGray;
extern color font_color = DarkGray;
extern string font_name = "Tahoma";
extern int font_size=8;

extern int Number_of_days_display_sessions=10;
extern int Session_borders_line_style = STYLE_SOLID;
extern int Session_borders_line_width = 1;

extern string Customized_time_lines=""; // Example: "12:34,21:43"

                                        // Time of sessions and DST (Daylight saving time) - all in UTC

// south hemisphere
// Sydney. EDT (Eastern Daylight Time) UTC offset +10 DST +1 hour. 
int SydneyTimeZone=+10;
datetime SydneyBegins=D'01.01.2001 23:00:00'; //++
datetime SydneyEnds        = D'01.01.2001 07:00:00';
datetime SydneyDSTStarts   = D'04.10.2009 02:00:00';
datetime SydneyDSTEnds     = D'05.04.2009 03:00:00';
color SydneyColor=DarkSeaGreen;
color SydneyBackColor=C'12,0,60';
datetime ASXOpens         = D'01.01.2001 00:00:00';
string   ASXOpensText     = "+ASX";
string   ASXOpensDescr    = "+Australian SE";
datetime ASXCloses        = D'01.01.2001 06:00:00';
string   ASXClosesText    = "-ASX";
string   ASXClosesDescr   = "-Australian SE";

// north hemisphere
int TokyoTimeZone=+9;
datetime TokyoBegins       = D'01.01.2001 00:00:00'; //+
datetime TokyoEnds         = D'01.01.2001 08:00:00'; //+
color TokyoColor=DeepPink;
color TokyoBackColor=C'43,0,23';
datetime TokyoSEOpens      = D'01.01.2001 00:00:00';
string   TokyoSEOpensText  = "+TSE";
string   TokyoSEOpensDescr = "+Tokyo SE";
datetime TokyoSECloses     = D'01.01.2001 06:00:00';
string   TokyoSEClosesText = "-TSE";
string   TokyoSEClosesDescr= "-Tokyo SE";

// Hong Kong, Shanghai Standard time zone:	UTC +8 hours No DST in 2009
int HongKongTimeZone=+8;
datetime HongKongBegins    = D'01.01.2001 01:00:00';
datetime HongKongEnds      = D'01.01.2001 09:00:00';
color HongKongColor=Red;
color HongKongBackColor=C'43,0,0';
datetime HKExOpens=D'01.01.2001 02:00:00'; // Pre-opening Session 9:30am to 10:00am, Morning Session	begins in 10:00am
string   HKExOpensText     = "+HKEx";
string   HKExOpensDescr    = "+Hong Kong HKEx";
datetime HKExCloses=D'01.01.2001 08:00:00'; // 4:00pm
string   HKExClosesText    = "-HKEx";
string   HKExClosesDescr   = "-Hong Kong HKEx";
datetime SSEOpens=D'01.01.2001 01:30:00'; // Pre-Market Session: 09:15 - 09:25 Normal Trading Session: 09:30 - 15:00
string   SSEOpensText      = "+SSE";
string   SSEOpensDescr     = "+Shanghai SE";
datetime SSECloses=D'01.01.2001 07:00:00'; // The afternoon session is 13:00pm to 15:00pm
string   SSEClosesText     = "-SSE";
string   SSEClosesDescr    = "-Shanghai SE";

// Moscow, MSK (Moscow Standard Time) UTC +3 Daylight saving time:	+1 hour
int MoscowTimeZone=+3;
datetime MoscowDSTStarts   = D'29.03.2009 02:00:00';
datetime MoscowDSTEnds     = D'25.10.2009 03:00:00';
datetime RTSOpens          = D'01.01.2001 07:30:00';
string   RTSOpensText      = "+RTS";
string   RTSOpensDescr     = "+RTS биржа";
datetime RTSCloses         = D'01.01.2001 15:45:00';
string   RTSClosesText     = "-RTS";
string   RTSClosesDescr    = "-RTS биржа";

// CEST, UTC +1 Daylight saving time:	+1 hour
int FrankfurtTimeZone=+1;
datetime FrankfurtDSTStarts= D'29.03.2009 01:00:00';
datetime FrankfurtDSTEnds  = D'25.10.2009 02:00:00';
datetime FrankfurtBegins   = D'01.01.2001 07:00:00';
datetime FrankfurtEnds     = D'01.01.2001 16:00:00';
color FrankfurtColor=Gold;
color FrankfurtBackColor=C'51,33,0';
datetime FSEOpens=D'01.01.2001 08:00:00'; // Trading runs from 09:00 to 17:30 with closing auction from 17:30-17:35
string   FSEOpensText      = "+FSE";
string   FSEOpensDescr     = "+Frankfurt SE";
datetime FSECloses         = D'01.01.2001 16:30:00';
string   FSEClosesText     = "-FSE";
string   FSEClosesDescr    = "-Frankfurt SE";

// Madrid, CET (Central European Time) UTC +1
int MadridTimeZone=+1;
datetime MadridDSTStarts= D'29.03.2009 02:00:00';
datetime MadridDSTEnds  = D'25.10.2009 03:00:00';
// Spanish Stock Market Interconnection System (SIBE), which handles more than 90% of transactions
datetime SIBEOpens=D'01.01.2001 08:00:00'; // Trading on SIBE is conducted from 9am to 5:30pm; open outcry from 10am to 11:30am
string   SIBEOpensText     = "+SIBE";
string   SIBEOpensDescr    = "+Madrid SIBE";
datetime SIBECloses        = D'01.01.2001 16:30:00';
string   SIBEClosesText    = "-SIBE";
string   SIBEClosesDescr   = "-Madrid SIBE";

// GMT, UTC no offset Daylight saving time:	+1 hour
int LondonTimeZone=0;
datetime LondonDSTStarts   = D'29.03.2009 01:00:00';
datetime LondonDSTEnds     = D'25.10.2009 02:00:00';
datetime LondonBegins      = D'01.01.2001 08:00:00';
datetime LondonEnds=D'01.01.2001 17:00:00'; //+
color LondonColor=Orange;
color LondonBackColor=C'12,0,60';
datetime LSEOpens          = D'01.01.2001 08:00:00';
string   LSEOpensText      = "+LSE";
string   LSEOpensDescr     = "+London SE";
datetime LSECloses         = D'01.01.2001 16:30:00';
string   LSEClosesText     = "-LSE";
string   LSEClosesDescr    = "-London SE";

// EST, UTC -5 Daylight saving time:	+1 hour
int NewYorkTimeZone=-5;
datetime NewYorkBegins=D'01.01.2001 13:00:00'; //+
datetime NewYorkEnds       = D'01.01.2001 21:00:00';
datetime NewYorkDSTStarts  = D'08.03.2009 02:00:00';
datetime NewYorkDSTEnds    = D'01.11.2009 02:00:00';
color NewYorkColor=CornflowerBlue;
color NewYorkBackColor=C'12,0,60';
datetime NYSEOpens=D'01.01.2001 14:30:00'; //  The New York Stock Exchange opens Monday through Friday at 9:30 EST
string NYSEOpensText       = "+ NYSE, Toronto SE, NASDAQ, SP500";
string NYSEOpensDescr      = "+ NYSE, Toronto SE, NASDAQ, SP500";
datetime NYSECloses=D'01.01.2001 21:00:00'; // 16:00 EST
string NYSEClosesText      = "- NYSE, Toronto SE, NASDAQ, SP500(+15min)";
string NYSEClosesDescr     = "- NYSE, Toronto SE, NASDAQ, SP500(+15min)";

// CDT, UTC -6 Daylight saving time:	+1 hour
int ChicagoTimeZone=-6;
datetime ChicagoBegins     = D'01.01.2001 14:00:00';
datetime ChicagoEnds       = D'01.01.2001 22:00:00';
datetime ChicagoDSTStarts  = D'08.03.2009 03:00:00';
datetime ChicagoDSTEnds    = D'01.11.2009 01:00:00';
color ChicagoColor=MediumSlateBlue;
color ChicagoBackColor=C'12,0,60';


datetime HistoryDownloadTime=0;
datetime daily[];
int win=0;
double open  = 0;
double high  = 0;
double low   = 0;
double close = 0;
bool SleepMode=false;
bool SessionBordersOn=false;
bool BriefModeOn=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   HistoryDownloadTime=0;

   IndicatorShortName("TIME II (VBO)");

// При первом использовании индикатор включен:
   if(!GlobalVariableCheck("state "+Symbol()+" Sessions borders On"))
      GlobalVariableSet("state "+Symbol()+" Sessions borders On",1);

   win=WindowOnDropped();
   if(win<0)
      win=WindowFind(WindowExpertName());
   if(win<0)
      return(0);

   AllDraw();

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ProcessOptions();
   ClockClose();
   SessionsClose();

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   win=WindowOnDropped();
   if(win<0)
      win=WindowFind(WindowExpertName());
   if(win<0)
      return(0);

   AllDraw();

   return(0);
  }
// Создание графических объектов для отображения индикатора
//
void AllDraw()
  {
// Дозагрузка истории инструмента
   if(HistoryDownloadTime<TimeCurrent()-3600)
     {
      CopySeries(daily,MODE_TIME,Symbol(),PERIOD_D1);
      HistoryDownloadTime=TimeCurrent();
     }

   ProcessOptions();
   ClockDraw();
   SessionsDraw(Number_of_days_display_sessions-1,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProcessOptions()
  {
// >> Drag and Drop на графике индикатора

   SessionBordersOn=GlobalVariableGet("state "+Symbol()+" Sessions borders On");
   BriefModeOn=GlobalVariableGet("state "+Symbol()+" Sessions Brief mode On");

   string mousename="Drag and Drop on Option"; // Drag and Drop
   int mouseX = ObjectGet(mousename, OBJPROP_XDISTANCE);
   int mouseY = ObjectGet(mousename, OBJPROP_YDISTANCE);

   string rectname="Session borders On/Off";
   int rectX  = ObjectGet(rectname, OBJPROP_XDISTANCE);
   int rectY  = ObjectGet(rectname, OBJPROP_YDISTANCE);

   if(MathAbs(mouseX-rectX)<12 && MathAbs(mouseY-rectY)<8)
     {
      SessionBordersOn=!SessionBordersOn;
      GlobalVariableSet("state "+Symbol()+" Sessions borders On",SessionBordersOn);
     }

   string briefname="Brief mode On/Off";
   int underX  = ObjectGet(briefname, OBJPROP_XDISTANCE);
   int underY  = ObjectGet(briefname, OBJPROP_YDISTANCE);

   if(MathAbs(mouseX-underX)<12 && MathAbs(mouseY-underY)<8)
     {
      BriefModeOn=!BriefModeOn;
      GlobalVariableSet("state "+Symbol()+" Sessions Brief mode On",BriefModeOn);
     }

   int obj_total=ObjectsTotal();
   for(int obj=obj_total-1; obj>=0; obj--)
     {
      string objname=ObjectName(obj);
      if(objname == mousename
         || objname == rectname
         || objname == briefname)
         ObjectDelete(objname);
     }

   ObjectCreate(mousename,OBJ_LABEL,win,0,0);
   ObjectSet(mousename,OBJPROP_BACK,false);
   ObjectSet(mousename,OBJPROP_CORNER,1);
   ObjectSet(mousename,OBJPROP_XDISTANCE,5);
   ObjectSet(mousename,OBJPROP_YDISTANCE,4);
   ObjectSetText(mousename,"8",14,"Wingdings",DarkGray);

   ObjectCreate(rectname,OBJ_LABEL,win,0,0);
   ObjectSet(rectname,OBJPROP_BACK,true);
   ObjectSet(rectname,OBJPROP_CORNER,1);
   ObjectSet(rectname,OBJPROP_XDISTANCE,2);
   ObjectSet(rectname,OBJPROP_YDISTANCE,26);
   if(SessionBordersOn)
      string char1=CharToStr(164);
   else
      char1=CharToStr(161);
   ObjectSetText(rectname,char1,14,"Wingdings",DarkGray);

   ObjectCreate(briefname,OBJ_LABEL,win,0,0);
   ObjectSet(briefname,OBJPROP_BACK,true);
   ObjectSet(briefname,OBJPROP_CORNER,1);
   ObjectSet(briefname,OBJPROP_XDISTANCE,2);
   ObjectSet(briefname,OBJPROP_YDISTANCE,48);
   if(BriefModeOn)
      char1=CharToStr(164);
   else
      char1=CharToStr(161);
   ObjectSetText(briefname,char1,14,"Wingdings",DarkGray);

// << Drag and Drop на графике индикатора
  }
// Отображение времени
//
void ClockDraw()
  {
   ClockClose();

   int minutelocal=TimeMinute(TimeLocal());
   int minuteserver=TimeMinute(TimeCurrent());
   bool nobacklog=MathAbs(minuteserver-minutelocal)<3 || (MathAbs(minuteserver-minutelocal)>57);
   if(nobacklog)
      color clockcolor=Clock_color;
   else
      clockcolor=Red;

   datetime UTC=LocalTimeToUTC(TimeCurrent(),Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
   string clockUTC="Time UTC";
   ObjectCreate(clockUTC,OBJ_LABEL,win,0,0);
   ObjectSet(clockUTC,OBJPROP_BACK,false);
   ObjectSet(clockUTC,OBJPROP_CORNER,1);
   ObjectSet(clockUTC,OBJPROP_XDISTANCE,125);
   ObjectSet(clockUTC,OBJPROP_YDISTANCE,3);
   ObjectSetText(clockUTC,TimeToStr(UTC,TIME_MINUTES),12,"System",clockcolor);

   string clock="Time Broker";
   ObjectCreate(clock,OBJ_LABEL,win,0,0);
   ObjectSet(clock,OBJPROP_BACK,false);
   ObjectSet(clock,OBJPROP_CORNER,1);
   ObjectSet(clock,OBJPROP_XDISTANCE, 80); // 30
   ObjectSet(clock, OBJPROP_YDISTANCE, 3); // 23
                                           //ObjectSetText(clock, TimeToStr(TimeCurrent(), TIME_MINUTES), 14, "Terminal", clockcolor);
   ObjectSetText(clock,TimeToStr(TimeCurrent(),TIME_MINUTES),12,"System",clockcolor);

   string local="Time Local";
   ObjectCreate(local,OBJ_LABEL,win,0,0);
   ObjectSet(local,OBJPROP_BACK,false);
   ObjectSet(local,OBJPROP_CORNER,1);
   ObjectSet(local,OBJPROP_XDISTANCE, 35); // 30
   ObjectSet(local, OBJPROP_YDISTANCE, 3); // 43
   ObjectSetText(local,TimeToStr(TimeLocal(),TIME_MINUTES),12,"System",Clock_color);

   string cursor="Current time";
   ObjectCreate(cursor,OBJ_VLINE,0,TimeCurrent(),0);
   ObjectSet(cursor,OBJPROP_BACK,true);
   ObjectSet(cursor,OBJPROP_COLOR,Green);
   ObjectSet(cursor,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(cursor,OBJPROP_WIDTH,1);

  }
// Удалить все графические объекты часов
//
void ClockClose()
  {
   int obj_total=ObjectsTotal();
   for(int obj=obj_total-1; obj>=0; obj--)
     {
      string objname=ObjectName(obj);
      if(StringFind(objname,"Time UTC")>=0
         || StringFind(objname,"Time Broker") >= 0
         || StringFind(objname, "Time Local") >= 0
         || StringFind(objname,"Current time")>= 0)
         ObjectDelete(objname);
     }
  }
// Отображение торговых сессий в заданном интервале времени
//
// barshiftD1from - смещение дневного бара начала периода отображения
// barshiftD1to - смещение дневного бара окончания периода отображения
//
void SessionsDraw(int barshiftD1from,int barshiftD1to)
  {
   SessionsClose();

// На таймфрейме выше M30 ограниченное отображение:
   SleepMode=Period()>PERIOD_M15;
   if(SleepMode)
     {
      string status="Sleep mode";
      ObjectCreate(status,OBJ_LABEL,win,0,0);
      ObjectSet(status,OBJPROP_BACK,true);
      ObjectSet(status,OBJPROP_CORNER,3);
      ObjectSet(status,OBJPROP_XDISTANCE,2);
      ObjectSet(status,OBJPROP_YDISTANCE,2);
      ObjectSetText(status,"© ispgip@mail.ru ICQ: 123372230 Skype: adam_vb",8,"Tahoma",font_color);
     }

// Не рисовать на таймфрейме выше H4:
   if(Period()>=PERIOD_H4)
      return;

   barshiftD1from=MathMax(0,barshiftD1from);
   barshiftD1to=MathMax(0,barshiftD1to);

   for(int daybarshift=barshiftD1from; daybarshift>=barshiftD1to; daybarshift--)
     {
      // Дата отрисовки:
      datetime day=iTime(NULL,PERIOD_D1,daybarshift);
      string idstring=TimeToStr(day,TIME_DATE);

      if(day==0)
         continue;

      // Здесь и далее приводим время к времени брокера, для коректного позиционирования на графике цены.

      // Сиднейская сессия
      datetime SydneySessionBeginUTC=TimeTableToUTC(day,SydneyBegins,SydneyDSTStarts,SydneyDSTEnds);
      datetime SydneySessionBegin=UTCToLocalTime(SydneySessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end)-24*3600;
      datetime SydneySessionEndUTC=TimeTableToUTC(day,SydneyEnds,SydneyDSTStarts,SydneyDSTEnds);
      datetime SydneySessionEnd=UTCToLocalTime(SydneySessionEndUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      OHLC(SydneySessionBegin,SydneySessionEnd);
      PlaceRectangle("Sydney "+idstring,"Sydney",SydneySessionBeginUTC-SydneySessionBegin,SydneySessionBegin,low,SydneySessionEnd,high,SydneyColor,SydneyBackColor,3);

      // Начало следующей сиднейской сессии, исключая пятницу:
      if(TimeDayOfYear(day)==DayOfYear() && DayOfWeek()!=5)
        {
         SydneySessionBeginUTC=TimeTableToUTC(day,SydneyBegins,SydneyDSTStarts,SydneyDSTEnds);
         SydneySessionBegin=UTCToLocalTime(SydneySessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
         SydneySessionEndUTC=TimeTableToUTC(day,SydneyEnds,SydneyDSTStarts,SydneyDSTEnds)+24*3600;
         SydneySessionEnd=UTCToLocalTime(SydneySessionEndUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
         OHLC(SydneySessionBegin,SydneySessionEnd);
         PlaceRectangle("Sydney "+idstring+".","Sydney",SydneySessionBeginUTC-SydneySessionBegin,SydneySessionBegin,low,SydneySessionEnd,high,SydneyColor,SydneyBackColor,3);
        }

      // Токийская сессия
      datetime TokyoSessionBeginUTC=TimeTableToUTC(day,TokyoBegins,0,0);
      datetime TokyoSessionBegin=UTCToLocalTime(TokyoSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime TokyoSessionEnd=TokyoSessionBegin+(TokyoEnds-TokyoBegins);
      OHLC(TokyoSessionBegin,TokyoSessionEnd);
      PlaceRectangle("Tokyo "+idstring,"Tokyo",TokyoSessionBeginUTC-TokyoSessionBegin,TokyoSessionBegin,low,TokyoSessionEnd,high,TokyoColor,TokyoBackColor,0);

      // Гонконгская сессия
      datetime HongKongSessionBeginUTC=TimeTableToUTC(day,HongKongBegins,0,0);
      datetime HongKongSessionBegin=UTCToLocalTime(HongKongSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime HongKongSessionEnd=HongKongSessionBegin+(HongKongEnds-HongKongBegins);
      OHLC(HongKongSessionBegin,HongKongSessionEnd);
      PlaceRectangle("Hong Kong "+idstring,"Hong Kong",HongKongSessionBeginUTC-HongKongSessionBegin,HongKongSessionBegin,low,HongKongSessionEnd,high,HongKongColor,HongKongBackColor,1);

      // Франкфурт
      datetime FrankfurtSessionBeginUTC=TimeTableToUTC(day,FrankfurtBegins,FrankfurtDSTStarts,FrankfurtDSTEnds);
      datetime FrankfurtSessionBegin=UTCToLocalTime(FrankfurtSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime FrankfurtSessionEnd=FrankfurtSessionBegin+(FrankfurtEnds-FrankfurtBegins);
      OHLC(FrankfurtSessionBegin,FrankfurtSessionEnd);
      PlaceRectangle("Frankfurt "+idstring,"Frankfurt, Madrid",FrankfurtSessionBeginUTC-FrankfurtSessionBegin,FrankfurtSessionBegin,low,FrankfurtSessionEnd,high,FrankfurtColor,FrankfurtBackColor,2);

      // Лондон
      datetime LondonSessionBeginUTC=TimeTableToUTC(day,LondonBegins,LondonDSTStarts,LondonDSTEnds);
      datetime LondonSessionBegin=UTCToLocalTime(LondonSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime LondonSessionEnd=LondonSessionBegin+(LondonEnds-LondonBegins);
      OHLC(LondonSessionBegin,LondonSessionEnd);
      PlaceRectangle("London "+idstring,"London",LondonSessionBeginUTC-LondonSessionBegin,LondonSessionBegin,low,LondonSessionEnd,high,LondonColor,LondonBackColor,3);

      // Нью-Йорк
      datetime NewYorkSessionBeginUTC=TimeTableToUTC(day,NewYorkBegins,NewYorkDSTStarts,NewYorkDSTEnds);
      datetime NewYorkSessionBegin=UTCToLocalTime(NewYorkSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime NewYorkSessionEnd=NewYorkSessionBegin+(NewYorkEnds-NewYorkBegins);
      OHLC(NewYorkSessionBegin,NewYorkSessionEnd);
      PlaceRectangle("NewYork "+idstring,"New York",NewYorkSessionBeginUTC-NewYorkSessionBegin,NewYorkSessionBegin,low,NewYorkSessionEnd,high,NewYorkColor,NewYorkBackColor,0);

      // Чикаго
      datetime ChicagoSessionBeginUTC=TimeTableToUTC(day,ChicagoBegins,ChicagoDSTStarts,ChicagoDSTEnds);
      datetime ChicagoSessionBegin=UTCToLocalTime(ChicagoSessionBeginUTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);
      datetime ChicagoSessionEnd=ChicagoSessionBegin+(ChicagoEnds-ChicagoBegins);
      OHLC(ChicagoSessionBegin,ChicagoSessionEnd);
      PlaceRectangle("Chicago "+idstring,"Chicago",ChicagoSessionBeginUTC-ChicagoSessionBegin,ChicagoSessionBegin,low,ChicagoSessionEnd,high,ChicagoColor,ChicagoBackColor,1);

      // Customized line
      int fragments=FragmentsTotal(Customized_time_lines);
      for(int f=0; f<fragments; f++)
        {
         string fragment=StringTrimRight(GetFragment(Customized_time_lines,f));
         if(!EmptyString(fragment))
           {
            datetime time=UTCToLocalTime(StrToTime(TimeToStr(day,TIME_DATE)+" "+fragment),Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);

            if(time>0)
              {
               string lineid="Customized line "+idstring+" "+ShortestTime(time);
               ObjectCreate(lineid,OBJ_VLINE,0,time,0);
               ObjectSet(lineid,OBJPROP_COLOR,DeepPink);
               ObjectSet(lineid,OBJPROP_BACK,1);
               ObjectSet(lineid,OBJPROP_STYLE,STYLE_DOT);
               ObjectSetText(lineid,fragment);

              }
           }
        }

      // Australian Securities Exchange (ASX)
      PlaceImportantPointsUTC(TimeTableToUTC(day,ASXOpens,0,0),ASXOpensText,ASXOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,ASXCloses,0,0),ASXClosesText,ASXClosesDescr);
      // Tokyo TSE
      PlaceImportantPointsUTC(TimeTableToUTC(day,TokyoSEOpens,0,0),TokyoSEOpensText,TokyoSEOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,TokyoSECloses,0,0),TokyoSEClosesText,TokyoSEClosesDescr);
      // Hong Kong HKEx
      PlaceImportantPointsUTC(TimeTableToUTC(day,HKExOpens,0,0),HKExOpensText,HKExOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,HKExCloses,0,0),HKExClosesText,HKExClosesDescr);
      // Shanghai SSE
      PlaceImportantPointsUTC(TimeTableToUTC(day,SSEOpens,0,0),SSEOpensText,SSEOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,SSECloses,0,0),SSEClosesText,SSEClosesDescr);
      // Moscow РТС
      PlaceImportantPointsUTC(TimeTableToUTC(day,RTSOpens,MoscowDSTStarts,MoscowDSTEnds),RTSOpensText,RTSOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,RTSCloses,MoscowDSTStarts,MoscowDSTEnds),RTSClosesText,RTSClosesDescr);
      // Frankfurt FSE
      PlaceImportantPointsUTC(TimeTableToUTC(day,FSEOpens,FrankfurtDSTStarts,FrankfurtDSTEnds),FSEOpensText,FSEOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,FSECloses,FrankfurtDSTStarts,FrankfurtDSTEnds),FSEClosesText,FSEClosesDescr);
      // Madrid SIBE
      PlaceImportantPointsUTC(TimeTableToUTC(day,SIBEOpens,MadridDSTStarts,MadridDSTEnds),SIBEOpensText,SIBEOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,SIBECloses,MadridDSTStarts,MadridDSTEnds),SIBEClosesText,SIBEClosesDescr);
      // London LSE
      PlaceImportantPointsUTC(TimeTableToUTC(day,LSEOpens,LondonDSTStarts,LondonDSTEnds),LSEOpensText,LSEOpensDescr);
      PlaceImportantPointsUTC(TimeTableToUTC(day,LSECloses,LondonDSTStarts,LondonDSTEnds),LSEClosesText,LSEClosesDescr);
      // New York NYSE
      PlaceImportantPointsUTC(NewYorkSessionBeginUTC+(NYSEOpens-NewYorkBegins),NYSEOpensText,NYSEOpensDescr);
      PlaceImportantPointsUTC(NewYorkSessionBeginUTC+(NYSECloses-NewYorkBegins),NYSEClosesText,NYSEClosesDescr);
     }
  }
// Удалить все графические объекты индикатора торговых сессий
//
void SessionsClose()
  {
   int obj_total=ObjectsTotal();
   for(int obj=obj_total-1; obj>=0; obj--)
     {
      string objname=ObjectName(obj);
      if(StringFind(objname," Session Begin")>=0
         || StringFind(objname," Session End")>=0
         || StringFind(objname," Session High") >= 0
         || StringFind(objname, " Session Low") >= 0
         || StringFind(objname," Session label") >= 0
         || StringFind(objname, " Session line") >= 0
         || StringFind(objname, " UTC ") >= 0
         || StringFind(objname, "_UTC ") >= 0
         || StringFind(objname," Session time")>= 0
         || StringFind(objname,"Customized line")>=0
         || StringFind(objname,"Sleep mode")>=0)
         ObjectDelete(objname);
     }
  }
// Отрисовать одну сессию
//
void PlaceRectangle(string session,string description,int toUTC,datetime time1,double price1,datetime time2,double price2,color session_color,color rect_color,int level)
  {
   if(time2<time1 || time2>time1+12*3600)
      return;

   if(!BriefModeOn)
      double Y=WindowPriceMin(win)+(WindowPriceMax(win)-WindowPriceMin(win)) *(0.78-level*0.15);
   else
      Y=WindowPriceMin(win)+(WindowPriceMax(win)-WindowPriceMin(win)) *(0.8-level*0.2);

   if(SessionBordersOn)
     {
      // Рамки сессий на графике цены

      string objname=session+" Session High";
      ObjectCreate(objname,OBJ_TREND,0,time1,price2,time2,price2);
      ObjectSet(objname,OBJPROP_COLOR,session_color);
      ObjectSet(objname,OBJPROP_BACK,true);
      ObjectSet(objname,OBJPROP_STYLE,Session_borders_line_style);
      ObjectSet(objname,OBJPROP_WIDTH,Session_borders_line_width);
      ObjectSet(objname,OBJPROP_RAY,0);

      //objname = session + " Session High label";
      //ObjectCreate(objname, OBJ_TEXT, 0, time2 - 1800, price2);
      //ObjectSet(objname, OBJPROP_BACK, false);
      //ObjectSetText(objname, DoubleToStr(price2, Digits), font_size - 1, "Tahoma", font_color);

      objname=session+" Session Low";
      ObjectCreate(objname,OBJ_TREND,0,time1,price1,time2,price1);
      ObjectSet(objname,OBJPROP_COLOR,session_color);
      ObjectSet(objname,OBJPROP_BACK,true);
      ObjectSet(objname,OBJPROP_STYLE,Session_borders_line_style);
      ObjectSet(objname,OBJPROP_WIDTH,Session_borders_line_width);
      ObjectSet(objname,OBJPROP_RAY,0);

      //objname = session + " Session Low label";
      //ObjectCreate(objname, OBJ_TEXT, 0, time2 - 1800, price1);
      //ObjectSet(objname, OBJPROP_BACK, false);
      //ObjectSetText(objname, DoubleToStr(price1, Digits), font_size - 1, "Tahoma", font_color);

      objname=session+" Session Begin";
      ObjectCreate(objname,OBJ_TREND,0,time1,price2,time1,price1);
      ObjectSet(objname,OBJPROP_COLOR,session_color);
      ObjectSet(objname,OBJPROP_BACK,true);
      ObjectSet(objname,OBJPROP_STYLE,Session_borders_line_style);
      ObjectSet(objname,OBJPROP_WIDTH,Session_borders_line_width);
      ObjectSet(objname,OBJPROP_RAY,0);
      //ObjectSetText(objname, session, font_size, font_name, font_color);

      objname=session+" Session End";
      ObjectCreate(objname,OBJ_TREND,0,time2,price1,time2,price2);
      ObjectSet(objname,OBJPROP_COLOR,session_color);
      ObjectSet(objname,OBJPROP_BACK,true);
      ObjectSet(objname,OBJPROP_STYLE,Session_borders_line_style);
      ObjectSet(objname,OBJPROP_WIDTH,Session_borders_line_width);
      ObjectSet(objname,OBJPROP_RAY,0);

     }

   if(!SleepMode)
     {
      // Длительность сессий в окне индикатора
      objname=session+" Session line";
      ObjectCreate(objname,OBJ_TREND,win,time1,Y,time2,Y);
      ObjectSet(objname,OBJPROP_COLOR,session_color);
      ObjectSet(objname,OBJPROP_BACK,true);
      ObjectSet(objname,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(objname,OBJPROP_WIDTH,2);
      ObjectSet(objname,OBJPROP_RAY,0);

      if(!BriefModeOn)
        {
         objname=session+" Session label";
         ObjectCreate(objname,OBJ_TEXT,win,time1+40*60,Y);
         ObjectSet(objname,OBJPROP_BACK,false);
         ObjectSetText(objname,description,font_size,font_name,font_color);

         // UTC время сессий
         objname=TimeToStr(time1+toUTC,TIME_DATE|TIME_MINUTES)+" UTC ";
         ObjectCreate(objname,OBJ_VLINE,win,0,0);
         ObjectSet(objname,OBJPROP_TIME1,time1+220);
         ObjectSet(objname,OBJPROP_COLOR,-1);
         ObjectSet(objname,OBJPROP_BACK,true);
         ObjectSet(objname,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(objname,OBJPROP_WIDTH,0);
         ObjectSetText(objname,ShortestTime(time1+toUTC));

         objname=TimeToStr(time2+toUTC,TIME_DATE|TIME_MINUTES)+" UTC ";
         ObjectCreate(objname,OBJ_VLINE,win,0,0);
         ObjectSet(objname,OBJPROP_TIME1,time2+220);
         ObjectSet(objname,OBJPROP_COLOR,-1);
         ObjectSet(objname,OBJPROP_BACK,true);
         ObjectSet(objname,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(objname,OBJPROP_WIDTH,0);
         ObjectSetText(objname,ShortestTime(time2+toUTC));
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PlaceImportantPointsUTC(datetime UTC,string text,string description)
  {
   if(SleepMode)
      return;

   datetime time=UTCToLocalTime(UTC,Broker_standard_time_zone,Broker_DST_start,Broker_DST_end);

   string search=TimeToStr(UTC,TIME_DATE|TIME_MINUTES)+" UTC ";
   string objname="";

// Поиск уже размещенной по этому времени метки:
   int obj_total=ObjectsTotal();
   for(int obj=obj_total-1; obj>=0; obj--)
     {
      if(StringFind(ObjectName(obj),search)>=0)
        {
         objname=ObjectName(obj);
         break;
        }
     }

// Если текст входит в наименование объекта, просто добавляем его:
   if(objname==search || objname=="")
     {
      if(objname!="")
         ObjectDelete(objname);
      objname=StringSubstr(search+text,0,63);
     }
   else if(StringLen(objname)+StringLen(text)<62)
     {
      ObjectDelete(objname);
      objname=StringSubstr(objname+", "+text,0,63);
     }
// Текст не входит, необходимо добавить ещё одну линию:
   else
     {
      datetime newtime=time+Period()*60;
      string newobjname=StringSubstr(TimeToStr(UTC+Period()*60,TIME_DATE|TIME_MINUTES)+" UTC "+text,0,63);
      if(!BriefModeOn)
        {
         ObjectCreate(newobjname,OBJ_VLINE,win,0,0);
         ObjectSet(newobjname,OBJPROP_TIME1,newtime);
         ObjectSet(newobjname,OBJPROP_COLOR,DarkGray);
         ObjectSet(newobjname,OBJPROP_BACK,false);
         ObjectSet(newobjname,OBJPROP_STYLE,STYLE_DOT);
         ObjectSet(newobjname,OBJPROP_WIDTH,1);
         ObjectSetText(newobjname,"");
        }
     }

   if(!BriefModeOn)
     {
      ObjectCreate(objname,OBJ_VLINE,win,0,0);
      ObjectSet(objname,OBJPROP_TIME1,time);
      ObjectSet(objname,OBJPROP_COLOR,DarkGray);
      ObjectSet(objname,OBJPROP_BACK,false);
      ObjectSet(objname,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet(objname,OBJPROP_WIDTH,1);
      ObjectSetText(objname,ShortTime(UTC));
     }

   string markname=StringSetChar(objname,StringFind(objname," UTC "),95);
   int barshift=iBarShift(NULL,0,time);
   
   if ((barshift!=-1) && (barshift!=0) && (barshift<Bars-1))
   low=MathMin(MathMin(Low[barshift],Low[barshift+1]),Low[barshift-1]);
   
   if(low<0.1)
      low=Bid;

   if(ObjectFind(search)<0)
     {
      ObjectCreate(search,OBJ_ARROW,0,time,low-8*Point);
      string settext=description;
     }
   else
      settext=ObjectDescription(search)+", "+description;
   ObjectSet(search,OBJPROP_ARROWCODE,191);
   ObjectSet(search,OBJPROP_BACK,true);
   ObjectSet(search,OBJPROP_COLOR,Gray);
   ObjectSetText(search,settext);
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    ПРОЦЕДУРЫ И ФУНКЦИИ
//


bool EmptyString(string str)
  {
   return(StringLen(StringTrimRight(str)) == 0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FragmentsTotal(string text)
  {
   int strlen= StringLen(text);
   int total = 0;
   for(int i = 0; i < strlen; i++)
      if(StringFind(";,|/",StringSubstr(text,i,1))>=0)
         total++;
   return(total+1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetFragment(string text,int number)
  {
   int start=0;
   int strlen=StringLen(text);

   if(number!=0)
     {

      int curnumber=0;
      for(int i=0; i<strlen; i++)
         if(StringFind(";,|/",StringSubstr(text,i,1))>=0)
           {
            curnumber++;
            if(curnumber>=number)
              {
               start=i+1;
               break;
              }
           }
     }

   int end=start;
   while(end<strlen && StringFind(";,|/",StringSubstr(text,end,1))<0)
      end++;

   return(StringSubstr(text, start, end-start));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CopySeries(datetime &array[],int MODE,string SYMBOL,int PERIOD)
  {
   ArrayCopySeries(array,MODE,SYMBOL,PERIOD);
   int lasterror=GetLastError();
   if(lasterror==4066) // ERR_HISTORY_WILL_UPDATED
     {
      int attempt=0;
      while(lasterror==4066 && attempt<10)
        {
         Sleep(5000);
         ArrayCopySeries(array,MODE,SYMBOL,PERIOD);
         lasterror=GetLastError();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OHLC(datetime fromtime,datetime totime)
  {
   int barshiftfrom=iBarShift(NULL,PERIOD_H1,fromtime);
   int barshiftto=iBarShift(NULL,PERIOD_H1,totime-1);
   int highestbarshift=iHighest(NULL,PERIOD_H1,MODE_HIGH,barshiftfrom-barshiftto+1,barshiftto);
   high=iHigh(NULL,PERIOD_H1,highestbarshift);
   int lowestbarshift=iLowest(NULL,PERIOD_H1,MODE_LOW,barshiftfrom-barshiftto+1,barshiftto);
   low=iLow(NULL,PERIOD_H1,lowestbarshift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime TimeTableToUTC(datetime date,datetime time,datetime DSTStarts,datetime DSTEnds)
  {
   datetime UTC = StrToTime(TimeToStr(date,TIME_DATE) + " " + TimeHour(time) + ":" + TimeMinute(time) + ":" + TimeSeconds(time));
   if(DSTStarts<= DSTEnds)
     {
      if(UTC >= DSTStarts && UTC <= DSTEnds)
         UTC -= 3600;
     }
   else
     {
      if(!(UTC>DSTEnds && UTC<DSTStarts))
         UTC-=3600;
     }
   return(UTC);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime LocalTimeToUTC(datetime time,int TimeZone,datetime DSTStarts,datetime DSTEnds)
  {
   datetime UTC=time-TimeZone*3600;

   datetime timeyear= StrToTime("01.01."+TimeYear(UTC));
   datetime dstyear = StrToTime("01.01."+TimeYear(DSTStarts));
   datetime dststart= timeyear+DSTStarts-dstyear;
   datetime dstend=timeyear+DSTEnds-dstyear;

   if(DSTStarts<=DSTEnds && DSTStarts!=0)
     {
      if(UTC >= dststart && UTC <= dstend)
         UTC -= 3600;
     }
   else if(DSTStarts>=DSTEnds && DSTEnds!=0)
     {
      datetime endofyear=StrToTime("31.12."+TimeYear(dststart));

      if((UTC >= timeyear && UTC <= dstend)
         || (UTC >= dststart && UTC <= endofyear))
         UTC-=3600;
     }
   return(UTC);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime UTCToLocalTime(datetime UTC,int TimeZone,datetime DSTStarts,datetime DSTEnds)
  {

   datetime timeyear= StrToTime("01.01."+TimeYear(UTC));
   datetime dstyear = StrToTime("01.01."+TimeYear(DSTStarts));
   datetime dststart= timeyear+DSTStarts-dstyear;
   datetime dstend=timeyear+DSTEnds-dstyear;

   if(DSTStarts<=DSTEnds && DSTStarts!=0)
     {
      if(UTC >= dststart && UTC <= dstend)
         UTC += 3600;
     }
   else if(DSTStarts>=DSTEnds && DSTEnds!=0)
     {
      datetime endofyear=StrToTime("31.12."+TimeYear(dststart));

      if((UTC >= timeyear && UTC <= dstend)
         || (UTC >= dststart && UTC <= endofyear))
         UTC+=3600;
     }
   return(UTC + TimeZone*3600);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ShortTime(datetime time)
  {
   string short1=TimeToStr(time,TIME_MINUTES);
   if(StringSubstr(short1,0,1)=="0")
      return(StringSubstr(short1, 1));
   else
      return(short1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ShortestTime(datetime time)
  {
   if(TimeMinute(time)==0)
     {
      string short1="";
      short1=TimeHour(time);
     }
   else
     {
      short1=TimeToStr(time,TIME_MINUTES);
      if(StringSubstr(short1,0,1)=="0")
         short1=StringSubstr(short1,1);
     }

   return(short1);
  }
//+------------------------------------------------------------------+
