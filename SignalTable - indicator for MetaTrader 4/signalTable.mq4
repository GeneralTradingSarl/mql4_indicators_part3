//+------------------------------------------------------------------+
//|                                                  signalTable.mq4 |
//|                                                     Antonuk Oleg |
//|                                            antonukoleg@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Antonuk Oleg"
#property link      "antonukoleg@gmail.com"
//----
#property indicator_chart_window
extern int scaleX=20,
           scaleY=20,
           offsetX=35,
           offsetY=20,
           fontSize=20,
           corner=2,
           symbolCodeBuy=67,
           symbolCodeSell=68,
           symbolCodeNoSignal=73;
extern color signalBuyColor=Gold,
             signalSellColor=MediumPurple,
             noSignalColor=WhiteSmoke,
             textColor=Gold;
int period[]={1,5,15,30,60,240,1440,10080,43200};
string periodString[]={"M1","M5","M15","M30","H1","H4","D1","W1","MN1"},
       // создаем еще один массив с названиями индикаторов
       signalNameString[]={"MA","WPR","SAR"};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   // таблица сигналов
   for(int x=0;x<9;x++)
      for(int y=0;y<3;y++)
        {
         ObjectCreate("signal"+x+y,OBJ_LABEL,0,0,0,0,0);
         // изменяем угол привязки
         ObjectSet("signal"+x+y,OBJPROP_CORNER,corner);
         ObjectSet("signal"+x+y,OBJPROP_XDISTANCE,x*scaleX+offsetX);
         ObjectSet("signal"+x+y,OBJPROP_YDISTANCE,y*scaleY+20);
         ObjectSetText("signal"+x+y,CharToStr(symbolCodeNoSignal),
                       fontSize,"Wingdings",noSignalColor);
        }
   // названия таймфреймов    
   for(x=0;x<9;x++)
     {
      ObjectCreate("textPeriod"+x,OBJ_LABEL,0,0,0,0,0);
      // изменяем угол привязки      
      ObjectSet("textPeriod"+x,OBJPROP_CORNER,corner);
      ObjectSet("textPeriod"+x,OBJPROP_XDISTANCE,x*scaleX+offsetX);
      ObjectSet("textPeriod"+x,OBJPROP_YDISTANCE,offsetY-10);
      ObjectSetText("textPeriod"+x,periodString[x],8,"Tahoma",textColor);
     }
   // названия индикаторов 
   for(y=0;y<3;y++)
     {
      ObjectCreate("textSignal"+y,OBJ_LABEL,0,0,0,0,0);
      // изменяем угол привязки      
      ObjectSet("textSignal"+y,OBJPROP_CORNER,corner);
      ObjectSet("textSignal"+y,OBJPROP_XDISTANCE,offsetX-25);
      ObjectSet("textSignal"+y,OBJPROP_YDISTANCE,y*(scaleY)+offsetY+8);
      ObjectSetText("textSignal"+y,signalNameString[y],8,"Tahoma",textColor);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   for(int x=0;x<9;x++)
     {
      // сигнал на покупку
      if(iMA(Symbol(),period[x],13,0,0,0,0)>iMA(Symbol(),period[x],24,0,0,0,0))
         ObjectSetText("signal"+x+"0",CharToStr(symbolCodeBuy),fontSize,"Wingdings",signalBuyColor);
      // сигнал на продажу   
      else
         ObjectSetText("signal"+x+"0",CharToStr(symbolCodeSell),fontSize,"Wingdings",signalSellColor);
     }
   for(x=0;x<9;x++)
     {
      // сигнал на покупку
      if(MathAbs(iWPR(Symbol(),period[x],13,0))<20.0)
         ObjectSetText("signal"+x+"1",CharToStr(symbolCodeBuy),fontSize,"Wingdings",signalBuyColor);
      // сигнал на продажу   
      else if(MathAbs(iWPR(Symbol(),period[x],13,0))>80.0)
            ObjectSetText("signal"+x+"1",CharToStr(symbolCodeSell),fontSize,"Wingdings",signalSellColor);
      // нет сигнала
         else
            ObjectSetText("signal"+x+"1",CharToStr(symbolCodeNoSignal),fontSize,"Wingdings",noSignalColor);
     }
   for(x=0;x<9;x++)
     {
      // сигнал на покупку
      if(iSAR(Symbol(),period[x],0.02,0.2,0)<Close[0])
         ObjectSetText("signal"+x+"2",CharToStr(symbolCodeBuy),fontSize,"Wingdings",signalBuyColor);
      // сигнал на продажу   
      else
         ObjectSetText("signal"+x+"2",CharToStr(symbolCodeSell),fontSize,"Wingdings",signalSellColor);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   // при удалении нашего индикатора нужно удалить все объекты,
   // которые мы уже создали
   ObjectsDeleteAll();
   return(0);
  }
//+------------------------------------------------------------------+