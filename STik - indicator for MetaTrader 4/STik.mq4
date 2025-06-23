//+------------------------------------------------------------------+
//|                                                         STik.mq4 |
//|                                                              sem |
//|                                                          http:// |
//+------------------------------------------------------------------+
#property copyright "sem"
#property link      "http://"

#property indicator_separate_window
#property indicator_buffers 1


extern datetime            Start = 0;
extern int                 TikChart = 350;

double ExtMapBuffer1[];
       
int    mass1[120960,2];


bool    tim;
int     tickCounter;
int     Handle1;
int     Handle2;
int init()
  {
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(0,DRAW_LINE,EMPTY,2,White);
   ArrayInitialize(mass1,0);
   IndicatorShortName("STik");
   FileOpenn();
   tickk();
   return(0);
  }
int start()
  {
     int temp;
     mass1[tickCounter,0] = Bid * MathPow(10,Digits);
     mass1[tickCounter,1] = TimeCurrent();
     temp = tickCounter;
     if (Start > 0)
     {while (mass1[temp,1] > Start){temp = LoopRevers(temp);}
       OutChart(temp);}
     else OutChart(tickCounter);
     if (tim && TimeMinute(TimeCurrent()) == 0) deinit();
     if (TimeMinute(TimeCurrent()) > 0) tim = true;
     tickCounter = Loop(tickCounter);
   return(0);
  }
void OutChart(int temp)
  {
   double a,b;
   int c,d,h = 0;
   int g = WindowFind("STik");
   string l;
   ObjectsDeleteAll(g,OBJ_VLINE);
   for(int i = 0;i < TikChart;i++)
    {ExtMapBuffer1[i] = mass1[temp,0] / MathPow(10,Digits);
     while (d >= 2){temp = LoopRevers(temp);
      if (mass1[temp,0] != mass1[LoopRevers(temp),0]) d = 0;}
     if (mass1[temp,0] == mass1[LoopRevers(temp),0])d++;
     else d = 0;
     int t = LoopRevers(temp);
     if (mass1[temp,1] < StrToTime(TimeToStr(Time[h]))) 
      {l = TimeToStr(mass1[LoopRevers(temp),1],TIME_DATE|TIME_SECONDS);
       l = StringConcatenate("PT  ",l);
       ObjectCreate(l,OBJ_VLINE,g,Time[i],mass1[LoopRevers(temp),0]);
       ObjectSet(l,OBJPROP_STYLE,STYLE_DOT);
       ObjectSet(l,OBJPROP_COLOR,Gold);
       while (mass1[LoopRevers(t),1] < StrToTime(TimeToStr(Time[h]))) h = h + 1;}
     temp = LoopRevers(temp);
     if (mass1[temp,0] == 0) i = TikChart + 1;}
   return(0);
  }
int Loop(int a)
  {a++;
   if (a >= ArrayRange(mass1,0)) a = 0;
   return(a);}
int LoopRevers(int a)
  {a--;
   if (a < 0)
    a = ArrayRange(mass1,0)-1;
   return(a);}
int tickk()
   {int a;
    static int b;
    static int c;
    a = GetTickCount();
    if (a<b) c = (4294967296-b) + a;
    else c = a-b;
    if (b == 0) c = 0;
    b = a;
    return(c);}
void FileOpenn()
   {
    int a = 0,b = 0,size = ArraySize(mass1);
    Handle1 = FileOpen("mass.bin",FILE_BIN|FILE_READ);a = GetLastError();
    Handle2 = FileOpen("var.bin",FILE_BIN|FILE_READ);b = GetLastError();
    if (Handle1 < 0 || Handle2 < 0)
     {Print(" отсутствуют файлы архивов!!. ошибка по массиву №  ",a,"  по индексу №  ",b);
      ArrayInitialize(mass1,0);
      tickCounter = 0;}
    else 
     {FileReadArray(Handle1,mass1,0,size);
      tickCounter = FileReadInteger(Handle2,LONG_VALUE);
      FileClose(Handle1);
      FileClose(Handle2);
      if (mass1[LoopRevers(tickCounter),1] < TimeLocal() - 691200)
       {Print("  данные устарели, начинаю ведение архивов заново.");
        FileDelete("mass.bin");
        FileDelete("var.bin");
        ArrayInitialize(mass1,0);
        tickCounter = 0;}}
    return(0);
   }
int deinit()
  {
   int size= ArraySize(mass1);
   Handle1 = FileOpen("mass.bin",FILE_BIN|FILE_WRITE);
   Handle2 = FileOpen("var.bin",FILE_BIN|FILE_WRITE);
   FileWriteArray(Handle1,mass1,0,size);
   FileWriteInteger(Handle2,tickCounter,LONG_VALUE);
   FileClose(Handle1);
   FileClose(Handle2);
   tim = false;
   return(0);
  }