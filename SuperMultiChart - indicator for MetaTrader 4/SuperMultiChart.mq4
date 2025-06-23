//+------------------------------------------------------------------+
//|                                                                  |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
/*
Универсальный мульти-график валют, с настройкой списка валют, 
диапазона отображения, периода и положения в окне.
http://codebase.mql4.com/ru/6324

The universal multi-chart of the currencies, with the changed list of currencies, 
a range of display, the period and position in a window.
http://codebase.mql4.com/6325
*/

//+------------------------------------------------------------------+
#property copyright "Denis Orlov"
#property link      "http://denis-or-love.narod.ru"

#define Pref "Denis Orlov: "

#property indicator_chart_window

#property indicator_buffers 4

#property indicator_color1 DarkTurquoise
#property indicator_color2 DarkBlue
#property indicator_color3 DarkTurquoise
#property indicator_color4 DarkBlue


double LineBma[],Line1[],Line2[],Line3[],Line4[];
//#property indicator_maximum 100

string SymbolsArray[];
int Bars0[];//array of 0 bar
int BarsTx[];//array of bar for price label

extern string Instruments=
                          "EURUSD GBPUSD AUDUSD USDCHF USDCAD USDJPY EURGBP EURCHF GBPCHF EURAUD EURJPY GBPJPY";
//"EURUSD240 EURUSD60 EURUSD30 EURUSD15 EURUSD5 EURUSD1";
//"GBPUSD EURUSD AUDUSD USDCHF USDCAD USDJPY";


//"USDJPY EURJPY GBPJPY";

extern int Bars_=25;
extern int ChartsGap =1;
extern bool GoldColor=False;
extern string note1="Vertical lines:";
extern color VertLineColor=Blue;
extern int VertLineWidth=1;
extern int VertLineStyle=2;
extern string note2="Text:";
extern int TextY=60;
extern int TextYStep=20;
extern int FontSize=10;
extern color TextColor=Blue;
extern color UpColor=Green;
extern color DnColor=Red;


double CountLevel;
//extern int History=0; 

/*extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;

#define MacdArrSize 5
double MACD[MacdArrSize];
double MACD_S[MacdArrSize];*/

datetime per;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----   
   FillSymbolsArray();
   if(ArraySize(SymbolsArray)<1) return(0);
   ArrayResize(Bars0,ArraySize(SymbolsArray));
   ArrayResize(BarsTx,ArraySize(SymbolsArray));

   Comment("*MultiChart* "+(string)ArraySize(SymbolsArray)+" symbols *http://denis-or-love.narod.ru*");

   SetIndexStyle(0,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(0,Line1);

   SetIndexStyle(1,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(1,Line2);

   SetIndexStyle(2,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(2,Line3);

   SetIndexStyle(3,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(3,Line4);

   if(GoldColor)
     {
      SetIndexStyle(0,DRAW_HISTOGRAM,0,3,Yellow);
      SetIndexStyle(1,DRAW_HISTOGRAM,0,3,Orange);
      SetIndexStyle(2,DRAW_HISTOGRAM,0,1,Yellow);
      SetIndexStyle(3,DRAW_HISTOGRAM,0,1,Orange);
     }

   DrawLabels(Pref+"Warning!",0,250,1,
              "Remember NOT to trade here! Помните, НЕ торговать здесь!",0,DnColor,0,FontSize);

   CountLevel=Close[0]-10*Point;
   DrawText(Pref+"CountLevel",Time[0],CountLevel,"",69,TextColor,FontSize,0);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pref);
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   if(ArraySize(SymbolsArray)<1) return(0);

   if(per!=Time[0]) // один раз в бар
     {
      per=Time[0];
      MainDraw();
     }

   if(CountLevel!=ObjectGet(Pref+"CountLevel",OBJPROP_PRICE1)+10*Point) MainDraw();  //правим положение   

                                                                                     //на каждом тике только нулевые бары обновляем, Bars0
   for(int i=0; i<ArraySize(SymbolsArray);i++)//по каждому символу
     {
      if(StringLen(SymbolsArray[i])>6)
         per=StrToPeriod(StringSubstr(SymbolsArray[i],6,0));
      else per=Period();

      int B=Bars0[i];

      string perStr=PeriodToStr(per);     // our Period, наш таймфрейм
      string Symb=StringSubstr(SymbolsArray[i],0,6);// our symbol, наш инструмент
      double po=MarketInfo(SymbolsArray[i],MODE_POINT);

      double razn=CountLevel-iClose(Symb,per,Bars_-1);//разница цен 

      double
      H=iHigh(Symb, per, 0),
      L=iLow(Symb, per, 0),
      O=iOpen(Symb, per, 0),
      C=iClose(Symb, per, 0);

      if(StringSubstr(Symb,3,0)=="JPY")//адаптируем йену ПОД ГРАФИК
        {
         H=H/100; L=L/100; O=O/100; C=C/100;
         razn=CountLevel-iClose(Symb,per,Bars_-1)/100;
        }

      // Comment("*"+iClose(Symb, per, j)+"*");

      if(C>O)
        {
         Line1[B]=C+razn; Line2[B]=O+razn;
         Line3[B]=H+razn; Line4[B]=L+razn;
        }
      else
      if(C<O)
        {
         Line1[B]=C+razn; Line2[B]=O+razn;
         Line3[B]=L+razn; Line4[B]=H+razn;
        }
      else
      if(C==O)
        {
         Line1[B]=O+razn; Line2[B]=C+0.01*po+razn;
         Line3[B]=L+razn; Line4[B]=H+razn;
        }

      string LName=Pref+"Tx "+Symb+" "+perStr;
      double c=iClose(Symb,per,0),o=iOpen(Symb,per,0);
      if(c>o) color pColor=UpColor; else pColor=DnColor;//цвет ценовых меток

                                                        /// LABEL
      string Text=DoubleToStr(c,Digits);
      DrawText(LName+"_3",Time[BarsTx[i]],WindowPriceMin()+(TextY-2*TextYStep)*Point,Text,0,pColor,FontSize,0);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MainDraw()
  {
//----
   if(ArraySize(SymbolsArray)<1) return(0);

   int B=ArraySize(SymbolsArray)*(Bars_+1+ChartsGap)-1;

   if(B>=ArraySize(Line1)) return(0);
   if(B<0) return(0);

   CountLevel=ObjectGet(Pref+"CountLevel",OBJPROP_PRICE1)+10*Point;

   ArrayInitialize(Line1,EMPTY_VALUE);// стираем график
   ArrayInitialize(Line2,EMPTY_VALUE);
   ArrayInitialize(Line3,EMPTY_VALUE);
   ArrayInitialize(Line4,EMPTY_VALUE);

   for(int i=0; i<ArraySize(SymbolsArray);i++)//по каждому символу
     {
      // сперва извлекаем инструмент и период из строчки
      if(StringLen(SymbolsArray[i])>6)
         per=StrToPeriod(StringSubstr(SymbolsArray[i],6,0));
      else per=Period();

      string perStr=PeriodToStr(per);     // our Period, наш таймфрейм
      string Symb=StringSubstr(SymbolsArray[i],0,6);// our symbol, наш инструмент
      double po=MarketInfo(SymbolsArray[i],MODE_POINT);

      //if(Symb!=Symbol())
      double razn=CountLevel-iClose(Symb,per,Bars_-1);//разница цен для выравнивания в окне
                                                      // else razn=0;

      string LName=Pref+"VL "+Symb+" "+perStr; //создаем либо передвигаем полоски
      if(ObjectFind(LName)<0) ObjectCreate(LName,OBJ_VLINE,0,Time[B],0);
      ObjectSet(LName,OBJPROP_TIME1,Time[B]);
      ObjectSet(LName,OBJPROP_COLOR,VertLineColor);
      ObjectSet(LName,OBJPROP_WIDTH,VertLineWidth);
      ObjectSet(LName,OBJPROP_BACK,True);
      if(VertLineWidth<2)
         ObjectSet(LName,OBJPROP_STYLE,VertLineStyle);
      // ObjectSetText( LName, DoubleToStr(TM,0));

      //создаем, передвигаем текст
      LName=Pref+"Tx "+Symb+" "+perStr;
      double c=iClose(Symb,per,0),o=iOpen(Symb,per,0);
      if(c>o) color pColor=UpColor; else pColor=DnColor;//цвет ценовых меток

                                                        /// LABELS
      string Text=DoubleToStr(c,Digits);
      DrawText(LName+"_1",Time[B-6],WindowPriceMin()+TextY*Point,Symb,0,TextColor,FontSize,0);
      DrawText(LName+"_2",Time[B-4],WindowPriceMin()+(TextY-TextYStep)*Point,perStr,0,TextColor,FontSize,0);
      DrawText(LName+"_3",Time[B-5],WindowPriceMin()+(TextY-2*TextYStep)*Point,Text,0,pColor,FontSize,0);
      BarsTx[i]=B-5;
      //DrawText( LName+"_4", Time[B-5], WindowPriceMin()+(TextY-3*TextYStep)*Point, NewText, 0, pColor, FontSize,0) ;
      //DrawText( LName+"_5", Time[B-5], WindowPriceMin()+(TextY-4*TextYStep)*Point, NewText, 0, pColor, FontSize,0) ;

      B--; // следующий после линии бар...

      for(int j=Bars_-1; j>=0;j--)//по каждому бару
        {
         if(j==0)Bars0[i]=B;//запомнили "нулевой бар" для этого символа

         double // значения свечки
         H=iHigh(Symb, per, j),
         L=iLow(Symb, per, j),
         O=iOpen(Symb, per, j),
         C=iClose(Symb, per, j);

         if(StringSubstr(Symb,3,0)=="JPY")//если иена, адаптируем йену ПОД ГРАФИК
           {
            H=H/100; L=L/100; O=O/100; C=C/100;
            razn=CountLevel-iClose(Symb,per,Bars_-1)/100;
           }

         /// АЛИЛУЯ!рисуем график...

         if(C>O)
           {
            Line1[B]=C+razn; Line2[B]=O+razn;
            Line3[B]=H+razn; Line4[B]=L+razn;
           }
         else
         if(C<O)
           {
            Line1[B]=C+razn; Line2[B]=O+razn;
            Line3[B]=L+razn; Line4[B]=H+razn;
           }
         else
         if(C==O)
           {
            Line1[B]=O+razn; Line2[B]=C+0.01*po+razn;
            Line3[B]=L+razn; Line4[B]=H+razn;
           }

         B--;  ///   следующий бар...     
        }//по каждому бару

      B=B-ChartsGap; //отступ между чартами

     }//по каждому символу

//----
   return(0);
  }
//+------------------------------------------------------------------+

//заполняем массив инструментов
int FillSymbolsArray()
  {
   string str=Instruments,delim=" ";

   str=StringTrimRight(str);
   str=StringTrimLeft(str);

   while(StringFind(str,"  ")>-1 && StringLen(str)>0)
      str=_StringReplace(str,"  "," ");
   while(StringFind(str,"\t")>-1 && StringLen(str)>0)
      str=_StringReplace(str,"\t"," ");

   str=str+" ";
   ArrayResize(SymbolsArray,0);

   while(StringLen(str)>0)
     {
      int pos=StringFind(str,delim);
      string sy=StringSubstr(str,0,pos);
      str=StringSubstr(str,pos+1);/// отсекли 

      if(StringSubstr(sy,0,1)=="-") continue;

      int Size=ArraySize(SymbolsArray);
      ArrayResize(SymbolsArray,Size+1);
      SymbolsArray[Size]=sy;
     }

   return(ArraySize(SymbolsArray));
  }
//-------
string _StringReplace(string text,string oldstr,string newstr)
  {
   int pos=StringFind(text,oldstr);
   if(pos>-1)
     {
      string str=StringSubstr(text,0,pos)+newstr+StringSubstr(text,pos+StringLen(oldstr));
      return(str);
     }
   return(text);
  }
//----------------
int StrToPeriod(string str)
  {
   if(str=="M1" || str=="1" )return(1);
   if(str=="M5" || str=="5")return(5);
   if(str=="M15" || str=="15")return(15);
   if(str=="M30" || str=="30")return(30);
   if(str=="H1" || str=="60")return(60);
   if(str=="H4" || str=="240")return(240);
   if(str=="D1" || str=="1440")return(1440);
   if(str=="W1" || str=="10080")return(10080);
   if(str=="МN" || str=="43200")return(43200);

   return(Period());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string PeriodToStr(int Per)
  {
   switch(Per) // Расчёт коэффициентов для..     
     {                              // .. различных ТФ      
      case     1: return("M1");  // Таймфрейм М1      
      case     5: return("M5");  // Таймфрейм М5      
      case    15: return("M15");  // Таймфрейм М15      
      case    30: return("M30");  // Таймфрейм М30      
      case    60: return("H1");  // Таймфрейм H1      
      case   240: return("H4");  // Таймфрейм H4      
      case  1440: return("D1");  // Таймфрейм D1      
      case 10080: return("W1");  // Таймфрейм W1      
      case 43200: return("МN");  // Таймфрейм МN     
     }
   return("");
  }
///=======================
void Delete_My_Obj(string Prefix)
  {
   for(int k=ObjectsTotal()-1; k>=0; k--) // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if(Head==Prefix)// Найден объект, ..
        {
         ObjectDelete(Obj_Name);
        }

     }
  }
//----------------------------------
int DrawText(string name,datetime T,double P,string Text,int code=0,color Clr=Green,int Fsize=10,int Win=0)
  {
   if(name=="") name="Text_"+T;

   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_TEXT,Win,T,P);
     }

   ObjectSet(name,OBJPROP_TIME1,T);
   ObjectSet(name,OBJPROP_PRICE1,P);
   if(code==0)
      ObjectSetText(name,Text,Fsize,"Arial",Clr);
   else
      ObjectSetText(name,CharToStr(code),Fsize,"Wingdings",Clr);
   return(0);
  }
///================================
int DrawLabels(string name,int corn,int X,int Y,string Text,int code=0,color Clr=Green,int Win=0,int FSize=10)
  {
   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_LABEL,Win,0,0); // Создание объекта
     }

   ObjectSet(name,OBJPROP_CORNER,corn);     // Привязка к углу   
   ObjectSet(name,OBJPROP_XDISTANCE,X);  // Координата Х   
   ObjectSet(name,OBJPROP_YDISTANCE,Y);// Координата Y   
   ObjectSetText(name,Text,FSize,"Arial",Clr);
   if(code==0)
      ObjectSetText(name,Text,FSize,"Arial",Clr);
   else
      ObjectSetText(name,CharToStr(code),FSize,"Wingdings",Clr);
   return(0);
  }
///================================
