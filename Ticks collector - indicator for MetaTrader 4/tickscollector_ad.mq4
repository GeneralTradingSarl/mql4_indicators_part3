#property copyright "Scriptong"
#property link      "http://advancetools.net"
#property description "English: Record a tick stream to a file and the formation of non-standard timeframes.\nDescription available online AdvanceTools.net in the \"Tick volume - Collector ticks.\"\n\nRussian: Запись тикового потока в файл и формирование нестандартных таймфреймов.\nОписание доступно на сайте AdvanceTools.net в разделе \"Тиковые объемы - Сборщик тиков.\""
#property version "1.02"


#property strict

#property indicator_separate_window
#property indicator_buffers 2 
#property indicator_color1 clrTurquoise
#property indicator_color2 clrRed

#include <TicksCollector_Classes_AD.mqh>

#define MAX_VIRTUAL_TICKS 1000000                                                                  // Максимально допустимое количество тиков, хранимое в памяти компьютера

struct NonStandartWindow                                                                           // Данные графика нестандартного таймфрейма
{
   int hWindow;                                                                                    // Дескриптор окна
   int hFile;                                                                                      // Описатель исторического файла
   datetime lastBar;                                                                               // Время открытия последнего обработанного бара графика
};

enum ENUM_YESNO
{
    YES,                                                                                           // Yes / Да
    NO                                                                                             // No / Нет
};


// Настроечные параметры индикатора

input string     i_string1                      = "The ticks collecting params / Параметры сбора тиков";// =========================
input ENUM_YESNO i_collectTicks                 = YES;                                             // Use ticks collecting? / Производить сбор тиков?
input ENUM_YESNO i_setUserFileName              = NO;                                              // Set the custom file name? / Установить свое имя тикового файла?
input string     i_userFileName                 = "user.tks";                                      // Name of ticks file / Имя тикового файла
input ENUM_YESNO i_useForcedUpdate              = YES;                                             // Use file flush? / Принудительно сбрасывать данные в файл?
input int        i_everyNTicks                  = 10;                                              // File flush every N ticks / Сброс данных каждые N тиков
input int        i_maxShowTicksCount            = 1000;                                            // Maximal showing ticks / Количество отображаемых тиков

input string     i_string2                      = "Equal time chart / Равновременной график";      // =========================
input ENUM_YESNO i_convertToTime                = NO;                                              // Create the chart? / Создавать график?
input int        i_secondsPerBar                = 30;                                              // Period in seconds / Период в секундах
input int        i_resultTimeTFInMinutes        = 312;                                             // Name of TF in minutes / Наименование ТФ в минутах
input ENUM_BID_ASK_TYPE i_timeBidAskType        = BID_ASK_TYPE_ONLY_BID;                           // Price type / Ценовой тип 

input string     i_string3                      = "Chart of Range-bar / График Range-баров";       // =========================
input ENUM_YESNO i_convertToPoints              = NO;                                              // Create the chart? / Создавать график?
input int        i_pointsPerBar                 = 10;                                              // Points per one bar / Пунктов на один бар
input int        i_resultPointsTFInMinutes      = 313;                                             // Name of TF in minutes / Наименование ТФ в минутах
input ENUM_BID_ASK_TYPE i_pointBidAskType       = BID_ASK_TYPE_ONLY_BID;                           // Ценовой тип построения графика

input string     i_string4                      = "Equal volume chart / График эквиобъемных баров";// =========================
input ENUM_YESNO i_convertToTicksVolume         = NO;                                              // Create the chart? / Создавать график?
input int        i_ticksPerBar                  = 10;                                              // Ticks per one bar / Тиков на один бар
input int        i_resultTicksTFInMinutes       = 314;                                             // Name of TF in minutes / Наименование ТФ в минутах
input ENUM_BID_ASK_TYPE i_volumeBidAskType      = BID_ASK_TYPE_ONLY_BID;                           // Price type / Ценовой тип 


bool g_activate;

int g_mt4Message,                                                                                  // Дескриптор сообщений МТ4
    g_newTicksCnt,                                                                                 // Текущее количество тиков, которые не были записаны в файл
    g_everyNTicks,                                                                                 // Частота сохранения данных в файл, измеряемая в тиках
    g_ticksCnt;                                                                                    // Количество текущих набранных тиков
    
TickStruct g_nonWritedTicks[];                                                                     // Буфер тиков, которые не были записаны в файл
    

NonStandartTFChart g_chartTime(i_convertToTime == YES, i_resultTimeTFInMinutes, i_secondsPerBar, CONVERT_TYPE_TF, i_timeBidAskType, _Digits, _Point, _Symbol),
                   g_chartPoint(i_convertToPoints == YES, i_resultPointsTFInMinutes, i_pointsPerBar, CONVERT_TYPE_POINT, i_pointBidAskType, _Digits, _Point, _Symbol),                                                                   
                   g_chartTick(i_convertToTicksVolume == YES, i_resultTicksTFInMinutes, i_ticksPerBar, CONVERT_TYPE_VOLUME, i_volumeBidAskType, _Digits, _Point, _Symbol);                                                                    

// Массивы буферов ндикатора
double g_bid[];
double g_ask[];

//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit()
{
   g_activate = false;
   
   if (!TuningParameters())                                                                        // Проверка корректности значений настроечных параметров
      return INIT_FAILED; 
      
   if (!IsTicksBufferReady())                                                                      // Инициализация буфера тиков
      return INIT_FAILED;                                

   if (!BuffersBind())                                                                             // Выделение памяти для индикаторных буферов
      return INIT_FAILED;       
      
   if (!IsFilesReady())
      return INIT_FAILED;                        
                                                   
   g_activate = true;
   return INIT_SUCCEEDED;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка корректности настроечных параметров                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool TuningParameters()
{
   string name = WindowExpertName();
   bool isRussian = TerminalInfoString(TERMINAL_LANGUAGE) == "Russian";
   

   if (i_maxShowTicksCount < 2)
   {
      if (isRussian)
         Alert(name, ": максимальное количество отображаемых тиков не может быть меньше 2. Индикатор отключен.");
      else
         Alert(name, ": the maximal amount of showing ticks could not be less than 2. Indicator is off.");
      return false;
   } 
   
   if (i_maxShowTicksCount > Bars)
   {
      if (isRussian)
         Alert(name, ": максимальное количество отображаемых тиков не может быть больше ", Bars,". Индикатор отключен.");
      else
         Alert(name, ": the maximal amount of showing ticks could not be more than ", Bars, ". Indicator is off.");
      return false;
   } 

   g_everyNTicks = i_everyNTicks;
   if (i_useForcedUpdate == NO)
      g_everyNTicks = MAX_VIRTUAL_TICKS;
   
   if (i_useForcedUpdate == YES && i_everyNTicks < 1)
   {
      if (isRussian)
         Alert(name, ": количество тиков, через которые должен осущесвляться сброс тиков в файл, должно быть больше нуля. Индикатор отключен.");
      else
         Alert(name, ": the value of parameter \"File flush every N ticks\" could not be less than 1. Indicator is off.");
      
      return false;
   } 

   ENUM_YESNO convertToTime = i_convertToTime;
   ENUM_YESNO convertToPoints = i_convertToPoints;
   ENUM_YESNO convertToTicksVolume = i_convertToTicksVolume;
   if (!IsDllsAllowed() && (i_convertToTime == YES || i_convertToPoints == YES || i_convertToTicksVolume == YES))
   {
      if (isRussian)
         Alert(name, ": для поддержки нестандартных таймфреймов необходимо разрешить импорт DLL функций. Поддержка принудительно выключена.");
      else
         Alert(name, ": the DLL import should be allowed if updating of non-standard timeframes needed.");
      
      convertToTime = NO;
      convertToPoints = NO;
      convertToTicksVolume = NO;
   }

   if (!IsThreeParametersCorrect(convertToTime, i_secondsPerBar,  i_resultTimeTFInMinutes, "Period in seconds / Период в секундах", "Name of TF in minutes / Наименование ТФ в минутах")) 
      return false;
      
   if (!IsThreeParametersCorrect(convertToPoints, i_pointsPerBar, i_resultPointsTFInMinutes, "Points per one bar / Пунктов на один бар", "Name of TF in minutes / Наименование ТФ в минутах")) 
      return false;

   if (!IsThreeParametersCorrect(convertToTicksVolume, i_ticksPerBar, i_resultTicksTFInMinutes, "Ticks per one bar / Тиков на один бар", "Name of TF in minutes / Наименование ТФ в минутах")) 
      return false;

   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка корректности значений трех настроечных параметров, относящихся к определенному типу нестандартного графика                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsThreeParametersCorrect(bool isConvert, int param, int tf, string paramName, string tfName)
{
   if (!isConvert)
      return (true);
      
   string name = WindowExpertName();
      
   if (param < 1)
   {
      if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         Alert(name, ": значение параметра ", paramName, " должно быть натуральным числом. Индикатор отключен.");
      else
         Alert(name, ": the value of parameter ", paramName," could be the natural number. Indicator is off.");
      return false;
   }

   if (IsTFCorrect(tf))
   {
      if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         Alert(name, ": значение параметра ", tfName, " не должно указывать на стандартный таймфрейм. Индикатор отключен.");
      else
         Alert(name, ": the value of parameter ", tfName," could not be specified the standard timeframe. Indicator is off.");
      return false;
   }
   
   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка корректности периода графика                                                                                                                                                             |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTFCorrect(int tf)
{
   return (tf == PERIOD_M1  || tf == PERIOD_M5 || tf == PERIOD_M15 || 
           tf == PERIOD_M30 || tf == PERIOD_H1 || tf == PERIOD_H4  ||
           tf == PERIOD_D1  || tf == PERIOD_W1 || tf == PERIOD_MN1);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Инициализация буфера временного хранения тиков                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTicksBufferReady()
{
   g_ticksCnt = 0;
   g_newTicksCnt = 0;
        
   if (ArrayResize(g_nonWritedTicks, g_everyNTicks) != g_everyNTicks)
   {
      if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         Alert(WindowExpertName(), ": не удалось выделить память для буфера тиков. Индикатор отключен.");
      else
         Alert(WindowExpertName(), ": unable to allocate memory for ticks buffer. Indicator is off.");
      return false;
   }
   
   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IsFileFlush(true);

   g_chartPoint.CloseFile();
   g_chartTime.CloseFile();
   g_chartTick.CloseFile();
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Связывание буферов индикатора с массивами                                                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool BuffersBind()
{
   string name = WindowExpertName();
   
   // Связывание буферов индикатора с массивами
   if (!SetIndexBuffer(0, g_bid) ||
       !SetIndexBuffer(1, g_ask))
   {
      int error = GetLastError();
      if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         Alert(name, ": ошибка связывания массивов с буферами индикатора. Ошибка №", error);
      else
         Alert(name, ": unable to bind the arrays to the indicator buffers. Indicator is off. Error N", error);
      
      return false;
   }

   // Задание графического типа буферов
   for (int i = 0; i < 2; i++)
      SetIndexStyle(i, DRAW_LINE);
   
   SetIndexLabel(0, "Bid");
   SetIndexLabel(1, "Ask");
   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Открытие файла тиковой истории                                                                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTicksFileOpen(int &hTicksFile)
{
   string fileName = GetTicksFileName();
   hTicksFile = FileOpen(fileName, FILE_BIN | FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE);
   if (hTicksFile >= 0)
      return true;

   if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
      Alert(WindowExpertName(), ": не удалось открыть файл ", fileName, ". Индикатор отключен.");
   else
      Alert(WindowExpertName(), ": unable to open the file ", fileName, ". Indicator is off.");
   return false;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Открытие файлов для записи тикового потока и синтетических свечей                                                                                                                                 |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsFilesReady()
{
   // Открытие файлов истории
   return g_chartPoint.CreateHistoryFile() && 
          g_chartTime.CreateHistoryFile() && 
          g_chartTick.CreateHistoryFile();
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Генерация имени файла, используемого для записи тикового потока                                                                                                                                   |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetTicksFileName()
{
   if (i_setUserFileName == YES)
      return (i_userFileName);
      
   return (Symbol() + ".tks");
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Чтение данных из файла в буфера индикатора                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ReadFile(bool fillOnlyBuffers)
{
   // Открытие файла
   int hTicksFile = -1;
   if (!IsTicksFileOpen(hTicksFile))
      return;

   // Определение начальных значений переменных
   int recSize = sizeof(TickStruct);                                                               // Размер структуры, которая будет прочитана за один раз
   ulong sizeInRec = FileSize(hTicksFile) / recSize;                                               // Размер файла в размерах структуры (размер файла должен быть кратен размеру структуры)
   g_ticksCnt = (int)MathMin(i_maxShowTicksCount, sizeInRec);                                      // Количество тиков, которое будет записано в буфера индикатора
   
   int cnt = g_ticksCnt - 1;                                                                       // Индекс буфера индикатора, в который будет произведена запись
   ulong startRecNumber = sizeInRec - g_ticksCnt;                                                  // Номер записи (в размерах структуры), с которого начнется копирование данных в буфера индикатора
   ulong currentRec = 0;                                                                           // Текущий номер записи
   TickStruct tick;                                                                                // Буфер для временного хранения данных о прочитанной записи
   
   while (currentRec < sizeInRec)
   {
      // Чтение одной записи
      uint bytesCnt = FileReadStruct(hTicksFile, tick);
      if (bytesCnt != recSize)
      {
         int error = GetLastError();
         if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
            Alert(WindowExpertName(), ": ошибка чтения исходного файла №", error);
         else
            Alert(WindowExpertName(), ": unable to read the source file. Error N", error);
         
         return;
      }

      // Заполнение буферов индикатора
      if (currentRec >= startRecNumber)
         FillIndicatorBuffers(tick, cnt);
      currentRec++;   
         
      // Не выполняем обновление графиков, если произошла подкачка истории
      if (fillOnlyBuffers)   
         continue;
         
      // Конвертация тиков во временнЫе, равновысокие и эквиобъемные свечи
      bool isWrite = g_chartTime.ConvertData(tick, false) &&
                     g_chartPoint.ConvertData(tick, false) &&
                     g_chartTick.ConvertData(tick, false);
      if (!isWrite)
      {
         g_activate = false;
         return;
      }
   }

   // Переход к дозаписи данных в файлы
   FileClose(hTicksFile);
   g_chartTime.SetPointerToEndOfFile();
   g_chartPoint.SetPointerToEndOfFile();
   g_chartTick.SetPointerToEndOfFile();
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Заполнение буферов индикатора                                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void FillIndicatorBuffers(TickStruct &tick, int& cnt)
{
   g_bid[cnt] = tick.bid;
   g_ask[cnt] = tick.ask; 
   cnt--;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Перемещение данных индикатора на один элемент влево                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void MoveDataToTheLeft()
{
   for (int i = g_ticksCnt - 1; i > 0; i--)
   {
      g_bid[i] = g_bid[i - 1];
      g_ask[i] = g_ask[i - 1];
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Сброс данных каждые g_everyNTicks тиков в файл тиковой истории                                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsFileFlush(bool isDeinit)
{
   if (i_collectTicks == NO)
      return true;

   // Запись данных в буфер
   g_nonWritedTicks[g_newTicksCnt].time = TimeCurrent();
   g_nonWritedTicks[g_newTicksCnt].bid = Bid;
   g_nonWritedTicks[g_newTicksCnt].ask = Ask;
   g_newTicksCnt++;
   if (g_newTicksCnt < g_everyNTicks && !isDeinit)
      return true;
   
   // Запись данных в файл
   int hTicksFile = -1;
   if (!IsTicksFileOpen(hTicksFile))
      return false;
     
   FileSeek(hTicksFile, 0, SEEK_END);
   for (int i = 0; i < g_newTicksCnt; i++)
   {
      if (FileWriteStruct(hTicksFile, g_nonWritedTicks[i]) == sizeof(TickStruct))
         continue;
         
      int error = GetLastError();
      if (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         Alert(WindowExpertName(), ": ошибка записи данных в файл ", error, ". Индикатор откючен.");
      else
         Alert(WindowExpertName(), ": uunable to save the data to file. Error N", error, ". Indicator is off.");
      
      return false;
   }
   
   // Закрытие файла и переход к новому сбору тиков
   FileClose(hTicksFile);
   g_newTicksCnt = 0;

   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Запись очередного тика в буфера индикатора, в файлы истории и тиков                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool SaveRegularTick()
{
   TickStruct tick(TimeCurrent(), Bid, Ask);

   // Обновление нестандартных графиков
   bool isWrite = g_chartTime.ConvertData(tick, true) &&
                  g_chartPoint.ConvertData(tick, true) &&
                  g_chartTick.ConvertData(tick, true);
   if (!isWrite)
      return false;

   g_chartTime.UpdateChart();
   g_chartPoint.UpdateChart();
   g_chartTick.UpdateChart();
   
   // Запись данных в буфера индикатора
   g_bid[0] = Bid;
   g_ask[0] = Ask;
   
   return IsFileFlush(false);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Расчет значений индикатора                                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool CalcIndicatorData()
{
   static datetime lastBarTime = 0;
   
   if (g_ticksCnt < i_maxShowTicksCount)
      g_ticksCnt++;

   if (lastBarTime == Time[0])
      MoveDataToTheLeft();
   else
      lastBarTime = Time[0];
   
   return SaveRegularTick();
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
{
   if (!g_activate)
      return rates_total;

   // Загрузка имеющихся тиков
   if (g_ticksCnt == 0)
   {
      ReadFile(false);
      if (g_ticksCnt > 0)
         return rates_total;
   }
 
   // Обновление данных с каждым новым тиком   
   if (!CalcIndicatorData())
      g_activate = false;

   return rates_total;
}
