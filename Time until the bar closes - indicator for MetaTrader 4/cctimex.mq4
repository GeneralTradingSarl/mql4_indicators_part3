//+------------------------------------------------------------------+
//|                                                      CCTimeX.mq4 |
//|                                       Copyright © 2015, Barmaley |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//---
#property indicator_chart_window
//---
int ts=12;
int PP;
int X0;
int Y0;
//---
string PPS;
int TFCount=0;
int TFSX[50];
//---
int ServerTimeOffset=0;// Смещение времени сервера относительно локального времени компьютера
extern string TFS="  1 5 15 20 30 60 240 480 1440 ";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   string s="ServerTime";
//---
   ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetText(s,"");
   X0=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2;
   Y0=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/9;
   ObjectSet(s,OBJPROP_XDISTANCE,X0);
   ObjectSet(s,OBJPROP_YDISTANCE,Y0);
//---
   s="";
   int i=0;
   int n=StringLen(TFS);
//--- Удаление лишних символов из списка таймфреймов, остаются только цифры и пробелы
   for(i=0;i<=n-1;i++)
     {
      int k=StringGetCharacter(TFS,i);
      string ss=StringSubstr(TFS,i,1);
      if(ss==" " || (k>=48 && k<=57)) s=s+ss;
     }
//---
   TFS=s+" "; s="";
//--- Обработка списка таймфреймов		  
   while(true)
     {
      i=StringFind(TFS," ");
      if(i<0) break;
      //---
      n=StringLen(TFS);
      if(i==0) TFS=StringSubstr(TFS,1,n-1);
      else
        {
         ss=StringSubstr(TFS,0,i+1);
         k=(int)ss;
         if(k<=1440)
            if((k<=60 && MathMod(60,k)==0) || (k>60 && MathMod(1440,k)==0))// Проверка ТФ на корректность
              {
               TFSX[TFCount]=(int)ss;
               TFCount++;
              }
         //---
         TFS=StringSubstr(TFS,i,1000);
        }
     }
//---
   if(TFCount==0) {TFCount++; TFSX[0]=_Period;} // Пустой список = текущий таймфрейм
//---
   for(i=0;i<=TFCount-1;i++)
     {
      s="ServerTime"+(string)i;
      ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSetText(s,"");
      s="ServerTime"+(string)i+(string)i;
      ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSetText(s,"");
     }
//---
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   string s="ServerTime";
//---
   if( reason==REASON_CHARTCHANGE || reason==REASON_PARAMETERS) return;
//---
   ObjectDelete(s);
//---
   for(int i=0;i<=TFCount-1;i++)
     {
      s="ServerTime"+(string)i+(string)i;
      ObjectDelete(s);
      //---
      s="ServerTime"+(string)i;
      ObjectDelete(s);
     }
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
//--- Смещение времени сервера относительно локального времени компьютера   
   if(MarketInfo(_Symbol,MODE_TRADEALLOWED)>0) ServerTimeOffset=TimeCurrent()-TimeLocal();
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
//--- Положение синих часов
   int x=ObjectGet("ServerTime",OBJPROP_XDISTANCE);
   int y=ObjectGet("ServerTime",OBJPROP_YDISTANCE);
   ts=ObjectGet("ServerTime",OBJPROP_FONTSIZE);
//---
   datetime tt=TimeLocal()+ServerTimeOffset;
//--- Серверное время
   ObjectSetText("ServerTime",TimeToStr(tt,TIME_SECONDS),ts,"Courier New",clrRoyalBlue);
//--- Таймеры баров
   for(int i=0;i<=TFCount-1;i++)
     {
      PP=TFSX[i];
      //---
      PPS="M"+(string)PP;
      if(PP==1440) PPS="D1";
      else if(PP>=60) PPS="H"+(string)(PP/60);
      //---
      int n=tt/PP/60;
      datetime it=n*PP*60;
      datetime t=PP*60-tt+it;
      //---
      string s="ServerTime"+(string)i+(string)i;
      ObjectSetText(s,TimeToStr(t,TIME_SECONDS),ts,"Courier New",clrRed);
      ObjectSet(s,OBJPROP_XDISTANCE,x);
      ObjectSet(s,OBJPROP_YDISTANCE,y+(ts+5)*(i+1));
      //---
      s="ServerTime"+(string)i;
      ObjectSetText(s,PPS,ts,"Courier New",clrRed);
      ObjectSet(s,OBJPROP_XDISTANCE,x-ts*5);
      ObjectSet(s,OBJPROP_YDISTANCE,y+(ts+5)*(i+1));
     }
  }
//+------------------------------------------------------------------+
