//+------------------------------------------------------------------+
//|                                                    YZCHMC_V1.mq4 |
//|                                           YURAZ Copyright © 2008 |
//|                                          www.mail.ru yzh@mail.ru |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                        Multi.mq4 |
//|                                Copyright © 2008, Сергеев Алексей |
//|                                         mailto: urgunt@gmail.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                        Multi.mq4 |
//|  В составе индикатора  <inifiles.mqh>  Автор ИГОРЬ КИМ  KimIV    |
//|  www.kimiv.ru      admin@kimiv.ru                                |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2008, Сергеев Алексей & YURAZ Copyright © 2008, KimIV © 2008"
#property link      "mailto: urgunt@gmail.com , yzh@mail.ru, admin@kimiv.ru  "


//
// Индикатор группового движения
//




#property indicator_separate_window
#property indicator_buffers 2

#property indicator_color1 LimeGreen
#property indicator_color2 Crimson
#property indicator_level1 0.0


// API
// Очень быстро определить наличие файла/файлов  по маске
#import "kernel32.dll"
int  FindFirstFileA(string path,int  &answer[]);
bool FindClose(int handle);
#import

int win32_DATA[80]; // буфер куда вернет параметры FindFirstFileA

extern string sFileINI="YZCHMC_V1.INI";

string sNameIndicator="YZCHMC_V1";
string sPathApp;
string sPathFileINI;

//
string sVERSION;
int  giCountSymbol;

string sSymbol[][2];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitializeINIFile() // string &sSymbol[] )
  {
   int i;

   sPathApp=TerminalPath(); // Пусть где работает наш терминал
   sPathFileINI=StringConcatenate(sPathApp,"\\",sFileINI);

// Нам достаточно получить реакцию на наличие файла - поэтому буфер только получаем но не анализируем  
   int handle=FindFirstFileA(sPathFileINI,win32_DATA);

   if(handle>=1) // Нашли файл 
     {
      // Читаем параметры

      FindClose(handle); // закроем его
      sVERSION=ReadIniString(sPathFileINI,"DATEVERSION","DATE","");
      giCountSymbol=ReadIniInteger(sPathFileINI,"COUNTSYMBOL","COUNTSYMBOL",0);

      ArrayResize(sSymbol,giCountSymbol*2);

      for(i=0; i<giCountSymbol; i++)
        {
         sSymbol[i][0]=StringSubstr(ReadIniString(sPathFileINI,"SYMBOL",StringTrimRight(StringTrimLeft(DoubleToStr(i,0))),""),0);
        }
     }
   else
     {
      giCountSymbol=52;

      // Нет файла данных - создаем под брокера с большим набором MRC - MoneyRain

      WriteIniString(sPathFileINI,"DATEVERSION","DATE","2008.10.21");
      WriteIniString(sPathFileINI,"VERSION","VERSION","V1.S000001");
      WriteIniInteger(sPathFileINI,"COUNTSYMBOL","COUNTSYMBOL",giCountSymbol);
      ArrayResize(sSymbol,giCountSymbol+2);

      sSymbol[ 0][0]="EURUSD";
      sSymbol[ 1][0]="GBPUSD";
      sSymbol[ 2][0]="AUDUSD";
      sSymbol[ 3][0]="NZDUSD";
      sSymbol[ 4][0]="USDCAD";
      sSymbol[ 5][0]="USDCHF";
      sSymbol[ 6][0]="USDALL";
      sSymbol[ 7][0]="USDARS";
      sSymbol[ 8][0]="USDBRL";
      sSymbol[ 9][0]="USDBWP";
      sSymbol[10][0]="USDCLP";
      sSymbol[11][0]="USDCNY";
      sSymbol[12][0]="USDCOP";
      sSymbol[13][0]="USDCVE";
      sSymbol[14][0]="USDCZK";
      sSymbol[15][0]="USDDKK";
      sSymbol[16][0]="USDDOP";
      sSymbol[17][0]="USDDZD";
      sSymbol[18][0]="USDEGP";
      sSymbol[19][0]="USDGEL";
      sSymbol[20][0]="USDGIP";
      sSymbol[21][0]="USDHKD";
      sSymbol[22][0]="USDHRK";
      sSymbol[23][0]="USDHUF";
      sSymbol[24][0]="USDIDR";
      sSymbol[25][0]="USDILS";
      sSymbol[26][0]="USDINR";
      sSymbol[27][0]="USDIRR";
      sSymbol[28][0]="USDISK";
      sSymbol[29][0]="USDJPY";
      sSymbol[30][0]="USDKRW";
      sSymbol[31][0]="USDLBP";
      sSymbol[32][0]="USDLSL";
      sSymbol[33][0]="USDMAD";
      sSymbol[34][0]="USDMXN";
      sSymbol[35][0]="USDMYR";
      sSymbol[36][0]="USDNOK";
      sSymbol[37][0]="USDNPR";
      sSymbol[38][0]="USDPHP";
      sSymbol[39][0]="USDPKR";
      sSymbol[40][0]="USDPLN";

      sSymbol[41][0]="USDRUB";
      sSymbol[42][0]="USDSAR";
      sSymbol[43][0]="USDSEK";
      sSymbol[44][0]="USDSGD";
      sSymbol[45][0]="USDTND";
      sSymbol[46][0]="USDTRY";
      sSymbol[47][0]="USDTWD";
      sSymbol[48][0]="USDUAH";
      sSymbol[49][0]="USDXOF";
      sSymbol[50][0]="USDZAR";
      sSymbol[51][0]="USDZMK";
      sSymbol[52][0]="";
      for(i=0; i<giCountSymbol;i++)
        {

         string sIw=DoubleToStr(i,0);
         WriteIniString(sPathFileINI,"SYMBOL",StringTrimRight(StringTrimLeft(sIw)),sSymbol[i][0]);
         Print(" w> "+(string)i+" "+sSymbol[i][0]+" "+(string)giCountSymbol);
        }

     }

//     Print(" > "+0+" "+sSymbol[0]+" "+giCountSymbol  );
//     Print(" > "+1+" "+sSymbol[1]+" "+giCountSymbol  );
//     Print(" > "+2+" "+sSymbol[2]+" "+giCountSymbol  );
//    Print(" > "+3+" "+sSymbol[3]+" "+giCountSymbol  );
//     Print(" > "+4+" "+sSymbol[4]+" "+giCountSymbol  );
//    Print(" > "+5+" "+sSymbol[5]+" "+giCountSymbol  );
//     Print(" > "+6+" "+sSymbol[6]+" "+giCountSymbol  );

  }
/////////////////////




double BufHi[];
double BufLo[];
//+------------------------------------------------------------------+
int init()
  {
// Print( " INIT ");
   SetIndexBuffer(0,BufHi); SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(1,BufLo); SetIndexStyle(1,DRAW_HISTOGRAM);
   IndicatorShortName(sNameIndicator);
//DrawSymbol();

   InitializeINIFile();  // (sSymbol  );

   return(0);
  }
//
int deinit()
  {

   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string label=ObjectName(i);

      if(StringSubstr(label,0,3)=="oYZ")
         ObjectDelete(label);

     }

   return(0);
  }
//
int start()
  {
   int counted_bars=IndicatorCounted();

   Comment(" [ "+sSymbol[1][0]+" "+(string)((iClose(Symbol(),PERIOD_D1,0)*100)/iClose(Symbol(),PERIOD_D1,1)-100));
   DrawSymbol();
   DrawIND();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawIND()
  {
   int counted_bars=IndicatorCounted();
   int bar0; string str; datetime time0;
   int i;
   double pc,a;
   for(i=0; i<Bars; i++)
     {
      // получаем полуночный бар
      str=(string)TimeYear(Time[i])+"."+(string)TimeMonth(Time[i])+"."+(string)TimeDay(Time[i]);
      time0=StrToTime(str);
      bar0=iBarShift(Symbol(),0,time0);
      // берем цену закрытия предыдущего дня
      pc=iClose(Symbol(),0,bar0+1); a=0;
      if(pc!=0) a=(iClose(Symbol(),0,i) *100)/pc-100;
      if(a>=0) BufHi[i]=a;
      if(a<=0) BufLo[i]=a;
     }
  }
//
// Рисуем объекты на графике
//
void DrawSymbol()
  {
   int i=0;
   int XD=0;
   int YD=10;
   color lColor=Aqua;
   int FindFirstUSDXXX = 0; // если пару нашли первый раз
   int FindFirstXXXUSD = 0; // если пару нашли первый раз
   int indicatorWindow=0; // работаем в главном окне

   for(i=0;  i<giCountSymbol; i++)
     {

      if(ObjectFind("oYZ"+sSymbol[i][0])==-1)
        {

         ObjectCreate("oYZ"+sSymbol[i][0],OBJ_LABEL,indicatorWindow,0,0);
         if(StringSubstr(sSymbol[i][0],0,3)=="USD")
           {
            XD=5+30;
            if(FindFirstUSDXXX==0)
              {
               FindFirstUSDXXX=1;
               YD=10;
              }
           }
         if(StringSubstr(sSymbol[i][0],3,3)=="USD")
           {
            XD=110+30;
            if(FindFirstXXXUSD==0)
              {
               FindFirstXXXUSD=1;
               YD=10;
              }

           }
         ObjectSet("oYZ"+sSymbol[i][0],OBJPROP_XDISTANCE,XD);
         ObjectSet("oYZ"+sSymbol[i][0],OBJPROP_YDISTANCE,YD);
         ObjectSet("oYZ"+sSymbol[i][0],OBJPROP_CORNER,1);

         ObjectSetText("oYZ"+sSymbol[i][0],sSymbol[i][0],7,"Arial",Aqua);

        }

      if(ObjectFind("oYZ_"+sSymbol[i][0])==-1)
        {
         ObjectCreate("oYZ_"+sSymbol[i][0],OBJ_LABEL,indicatorWindow,0,0);
         if(StringSubstr(sSymbol[i][0],0,3)=="USD")
           {
            XD=5;
           }
         if(StringSubstr(sSymbol[i][0],3,3)=="USD")
           {
            XD=110;
           }
         ObjectSet("oYZ_"+sSymbol[i][0],OBJPROP_XDISTANCE,XD);
         ObjectSet("oYZ_"+sSymbol[i][0],OBJPROP_YDISTANCE,YD);
         ObjectSet("oYZ_"+sSymbol[i][0],OBJPROP_CORNER,1);

        }
      YD=YD+14;

      lColor=White;
      double prcCH=GetPrcCH(sSymbol[i][0]);
      if(prcCH>0)
         lColor=LimeGreen;
      if(prcCH<0)
         lColor=Red;
      ObjectSetText("oYZ_"+sSymbol[i][0],DoubleToStr(prcCH,3),7,"Arial",lColor);
     }
  }
// упрощенный вариант - будет переделываться
// а именно совмещаться с барным индикатором от Алексея Сергеева , SERGEEV
//
double   GetPrcCH(string _sSymbol)
  {
   double pc=iClose(_sSymbol,PERIOD_D1,1);
   double a=0;
   if(pc!=0)
      a=(iClose(_sSymbol,PERIOD_D1,0)*100)/pc-100;
   return(a);
  }
//////////

//+------------------------------------------------------------------+
//|                                                     IniFiles.mqh |
//|                                           Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//|   25.04.2006  Библиотека функций для работы с INI-файлами.       |
//+------------------------------------------------------------------+
#import "kernel32.dll"
int GetPrivateProfileStringA
(string SectionName,// Наименование секции
 string KeyName,        // Наименование параметра
 string Default,        // Значение по умолчанию
 string ReturnedString, // Возвращаемое значение параметра
 int    nSize,          // Размер буфера под значение параметра
 string FileName);      // Полное имя файла
int WritePrivateProfileStringA
(string SectionName,// Наименование секции
 string KeyName,        // Наименование параметра
 string sString,        // Записываемое значение параметра
 string FileName);      // Полное имя файла
#import
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   aiParam     - массив значений считываемого параметра           |
//+------------------------------------------------------------------+
void ReadIniArrayInt(string FileName,string SectionName,string KeyName,
                     int &aiParam[])
  {
   int    i=0,np;
   string Default="",st,ReturnedString="                      "+
   "                                                         "+
   "                                                         "+
   "                                                         "+
   "                                                              ";
   int nValue=GetPrivateProfileStringA(SectionName,KeyName,Default,
                                       ReturnedString,255,FileName);
   if(nValue>0)
     {
      while(StringLen(ReturnedString)>0)
        {
         np=StringFind(ReturnedString,",");
         if(np<0)
           {
            st=ReturnedString;
            ReturnedString="";
           }
         else
           {
            st=StringSubstr(ReturnedString,0,np);
            ReturnedString=StringSubstr(ReturnedString,np+1);
           }
         i++;
         ArrayResize(aiParam,i);
         aiParam[i-1]=StrToInteger(st);
        }
     }
   else
      ArrayResize(aiParam,0);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   bDefault    - значение параметра по умолчанию                  |
//+------------------------------------------------------------------+
bool ReadIniBool(string FileName,string SectionName,string KeyName,
                 bool bDefault=False)
  {
   string Default,ReturnedString="";
   if(bDefault)
      Default="1";
   else
      Default= "0";
   int nValue= GetPrivateProfileStringA(SectionName,KeyName,Default,
                                        ReturnedString,255,FileName);
   if(nValue>0)
     {
      if(StringGetChar(ReturnedString,0)==49)
         return(True);
      else
         return(False);
     }
   else
      return(bDefault);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   dDefault    - значение параметра по умолчанию                  |
//+------------------------------------------------------------------+
double ReadIniDouble(string FileName,string SectionName,string KeyName,
                     double dDefault=0.0)
  {
   string Default,ReturnedString="";
   Default=DoubleToStr(dDefault,8);
   int nValue=GetPrivateProfileStringA(SectionName,KeyName,Default,
                                       ReturnedString,255,FileName);
   if(nValue>0)
      return(StrToDouble(ReturnedString));
   else
      return(dDefault);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   iDefault    - значение параметра по умолчанию                  |
//+------------------------------------------------------------------+
int ReadIniInteger(string FileName,string SectionName,string KeyName,
                   int iDefault=0)
  {
   string Default,ReturnedString="";
   Default=DoubleToStr(iDefault,0);
   int nValue=GetPrivateProfileStringA(SectionName,KeyName,Default,
                                       ReturnedString,255,FileName);
   if(nValue>0)
      return(StrToInteger(ReturnedString));
   else
      return(iDefault);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   Default     - значение параметра по умолчанию                  |
//+------------------------------------------------------------------+
string ReadIniString(string FileName,string SectionName,string KeyName,
                     string Default="")
  {
   string ReturnedString="";
   int nValue=GetPrivateProfileStringA(SectionName,KeyName,Default,
                                       ReturnedString,255,FileName);

//Print(">>>>>>>"+ReturnedString+" def="+Default+ " SectionName="+SectionName+ " KeyName="+ KeyName); 
   if(nValue>0)
      return(ReturnedString);
   else
      return(Default);


  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   aiParam     - массив значений записываемого параметра          |
//+------------------------------------------------------------------+
void WriteIniArrayInt(string FileName,string SectionName,string KeyName,
                      int &aiParam[])
  {
   int    as=ArraySize(aiParam);
   string sString="";
   for(int i=0; i<as; i++)
     {
      sString=sString+DoubleToStr(aiParam[i],0);
      if(i<as-1)
         sString=sString+",";
     }
   int nValue=WritePrivateProfileStringA(SectionName,KeyName,sString,
                                         FileName);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   bParam      - записываемое значение параметра                  |
//+------------------------------------------------------------------+
void WriteIniBool(string FileName,string SectionName,string KeyName,
                  bool bParam)
  {
   string sString;
   if(bParam)
      sString="1";
   else
      sString= "0";
   int nValue= WritePrivateProfileStringA(SectionName,KeyName,sString,
                                          FileName);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   dParam      - записываемое значение параметра                  |
//+------------------------------------------------------------------+
void WriteIniDouble(string FileName,string SectionName,string KeyName,
                    double dParam)
  {
   string sString=DoubleToStr(dParam,8);
   int nValue=WritePrivateProfileStringA(SectionName,KeyName,sString,
                                         FileName);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   iParam      - записываемое значение параметра                  |
//+------------------------------------------------------------------+
void WriteIniInteger(string FileName,string SectionName,string KeyName,
                     int iParam)
  {
   string sString=DoubleToStr(iParam,0);
   int nValue=WritePrivateProfileStringA(SectionName,KeyName,sString,
                                         FileName);
  }
//+------------------------------------------------------------------+
//| Параметры:                                                       |
//|   FileName    - полное имя файла                                 |
//|   SectionName - наименование секции                              |
//|   KeyName     - наименование параметра                           |
//|   sParam      - записываемое значение параметра                  |
//+------------------------------------------------------------------+
void WriteIniString(string FileName,string SectionName,string KeyName,
                    string sParam)
  {
   int nValue=WritePrivateProfileStringA(SectionName,KeyName,sParam,
                                         FileName);
  }
//+------------------------------------------------------------------+
