//+------------------------------------------------------------------+
//| SymInfo.mq4                      ver1.0            by A.Voronin  |
//+------------------------------------------------------------------+
#property copyright   "2015, A.Voronin"
#property link        "giskoats@gmail.com"
#property description "SymbolInfo v1.0"
#property indicator_chart_window
//---
extern string note3="Индикатор тренда";
extern int ShiftMA1=9; //19
extern int ShiftMA2 = 26; //55
extern int ShiftMA3 = 55; //89
extern string MAMode= "MODE_EMA";
extern string PriceMode="PRICE_CLOSE";
//---
extern string note5 = "Угол отображения индикатора";
extern string note6 = "Верх левый=0; Верх правый=1";
extern string note7 = "Нижний левый=2; Нижний правый=3";
extern int    ThisCorner=0;
double MA1,MA2,MA3;
int scaleX=20,
scaleY=20,
offsetX=35,
offsetY=20,
fontSize=20,
symbolCodeBuy=241,
symbolCodeSell=242,
symbolCodeNoSignal=240;
//---
color signalBuyColor=Gold,
signalSellColor=MediumPurple,
noSignalColor=WhiteSmoke,
textColor=Gold;
//---
string SymbolName[]={"USD","GBP","NZD","AUD","EUR"},
//--- создаем еще один массив с названиями индикаторов
CrossSymbol[]={"RUB","CHF","CAD","USD","JPY"};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Info()
  {
   for(int x=0;x<5;x++)
      for(int y=0;y<5;y++)
        {
         //--- сигнал на покупку
         if(SymbolTrend(x,y)>0)
            ObjectSetText("symsignal"+x+y,CharToStr(symbolCodeBuy),fontSize,"Wingdings",signalBuyColor);
         //--- сигнал на продажу   
         if(SymbolTrend(x,y)<0)
            ObjectSetText("symsignal"+x+y,CharToStr(symbolCodeSell),fontSize,"Wingdings",signalSellColor);
         //--- нет сигнала
         if(SymbolTrend(x,y)==0)
            ObjectSetText("symsignal"+x+y,CharToStr(symbolCodeNoSignal),fontSize,"Wingdings",noSignalColor);
        }
//---
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   for(int x=0;x<5;x++)
      for(int y=0;y<5;y++)
        {
         ObjectCreate("symsignal"+x+y,OBJ_LABEL,0,0,0,0,0);
         //--- изменяем угол привязки
         ObjectSet("symsignal"+x+y,OBJPROP_CORNER,ThisCorner);
         ObjectSet("symsignal"+x+y,OBJPROP_XDISTANCE,x*scaleX+offsetX);
         ObjectSet("symsignal"+x+y,OBJPROP_YDISTANCE,y*scaleY+20);
         ObjectSetText("symsignal"+x+y,CharToStr(symbolCodeNoSignal),
                       fontSize,"Wingdings",noSignalColor);
        }
//--- названия таймфреймов    
   for(x=0;x<5;x++)
     {
      ObjectCreate("sn"+x,OBJ_LABEL,0,0,0,0,0);
      //--- изменяем угол привязки      
      ObjectSet("sn"+x,OBJPROP_CORNER,ThisCorner);
      ObjectSet("sn"+x,OBJPROP_XDISTANCE,x*scaleX+offsetX);
      ObjectSet("sn"+x,OBJPROP_YDISTANCE,offsetY-10);
      ObjectSetText("sn"+x,SymbolName[x],8,"Tahoma",textColor);
     }
//--- названия индикаторов 
   for(y=0;y<5;y++)
     {
      ObjectCreate("cs"+y,OBJ_LABEL,0,0,0,0,0);
      //--- изменяем угол привязки      
      ObjectSet("cs"+y,OBJPROP_CORNER,ThisCorner);
      ObjectSet("cs"+y,OBJPROP_XDISTANCE,offsetX-25);
      ObjectSet("cs"+y,OBJPROP_YDISTANCE,y*(scaleY)+offsetY+8);
      ObjectSetText("cs"+y,CrossSymbol[y],8,"Tahoma",textColor);
     }
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void IndClear()
  {
   for(int x=0;x<5;x++)
      for(int y=0;y<5;y++)
        {
         ObjectDelete("symsignal"+x+y);

        }
//--- названия таймфреймов    
   for(x=0;x<5;x++)
     {
      ObjectDelete("sn"+x);
     }
//--- названия индикаторов 
   for(y=0;y<5;y++)
     {
      ObjectDelete("cs"+y);
     }
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
//---
   IndClear();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SymbolTrend(int &x,int &y)
  {
   RefreshRates();
   string sym=SymbolName[x]+CrossSymbol[y];
   MA1=iMA(sym,0,ShiftMA1,8,MAMode,PriceMode,0);
   MA2=iMA(sym,0,ShiftMA2,8,MAMode,PriceMode,0);
   MA3=iMA(sym,0,ShiftMA3,8,MAMode,PriceMode,0);
//---
   if((MA1>MA2)&&(MA2>MA3)) return(1);
   if((MA1<=MA2)&&(MA2>=MA3)) return(0);
   if((MA1>=MA2)&&(MA2<=MA3)) return(0);
   if((MA1<MA2)&&(MA2<MA3)) return(-1);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//---
   Info();
//---
   return(0);
  }
//+------------------------------------------------------------------+
