//+------------------------------------------------------------------+
//|                                                      3CLineX.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
//---
double DnBars[],UpBars[],DnValues[],UpValues[];
int m1,m2,m3,n1,n2,n3;
int d;
//input int _Period=0;
int BBar=0;
bool Help=false;
input bool BreakOnly=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,DnBars);
   SetIndexBuffer(1,UpBars);
   SetIndexBuffer(2,DnValues);
   SetIndexBuffer(3,UpValues);

   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
//---
   d=(int)MarketInfo(_Symbol,MODE_DIGITS);
//---
   return(INIT_SUCCEEDED);
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
//---
   ArrayInitialize(UpBars,EMPTY_VALUE);
   ArrayInitialize(DnBars,EMPTY_VALUE);
   ArrayInitialize(UpValues,EMPTY_VALUE);
   ArrayInitialize(DnValues,EMPTY_VALUE);
//---
   int i=0,ii=0,iii=0;
   int j1=0,j2=0,j3=0;
   int mm=-1,nn=-1,k2=-1;
   double hm=0,lm=999999;
   string sss="";
//--- Уровень разворота вверх      
   i=BBar; j1=-1;k2=-1;
   while(j1<0 && i<Bars-2)
     {
      double h=iHigh(_Symbol,_Period,i); double l=iLow(_Symbol,_Period,i);
      if(h>hm) hm=h; if(l<lm) lm=l;
      //---
      if(iLow(_Symbol,_Period,i)<iLow(_Symbol,_Period,i+1))
        {
         j1=i; j2=-1; ii=i+1;
         while(j2<0 && ii<Bars-2)
           {
            if(iLow(_Symbol,_Period,ii)<l || j1<0) {j1=-1;break;}
            if
            (
             iHigh(_Symbol,_Period,ii)<iHigh(_Symbol,_Period,ii+1) && 
             iLow(_Symbol,_Period,ii)>iLow(_Symbol,_Period,ii+1)
             )
              {ii++; continue;}
            if(iHigh(_Symbol,_Period,ii)>h)
              {
               j2=ii; j3=-1; iii=ii+1; double hh=iHigh(_Symbol,_Period,ii); double ll=iLow(_Symbol,_Period,ii);
               if(k2<1) k2=j2;
               while(j3<0 && iii<Bars-2)
                 {
                  if(iLow(_Symbol,_Period,iii)<l) {j1=-1;break;}
                  if(BreakOnly && iHigh(_Symbol,_Period,iii)>hm) {j1=-1;break;}
                  if
                  (
                   iHigh(_Symbol,_Period,iii)<iHigh(_Symbol,_Period,iii+1) && 
                   iLow(_Symbol,_Period,iii)>iLow(_Symbol,_Period,iii+1)
                   )
                    {iii++; continue;}

                  if(iHigh(_Symbol,_Period,iii)>hh) j3=iii;
                  iii++;
                 }
              }
            ii++;
           }
        }
      i++;
     }
   m1=j1;m2=j2;m3=j3;mm=k2;
//---
   hm=0;lm=999999;
//--- Уровень разворота вниз      
   i=BBar; j1=-1;k2=-1;
   while(j1<0 && i<Bars-2)
     {
      double h=iHigh(_Symbol,_Period,i); double l=iLow(_Symbol,_Period,i);
      if(h>hm) hm=h; if(l<lm) lm=l;
      if(iHigh(_Symbol,_Period,i)>iHigh(_Symbol,_Period,i+1))
        {
         j1=i; j2=-1; ii=i+1;
         while(j2<0 && ii<Bars-2)
           {
            if(iHigh(_Symbol,_Period,ii)>h || j1<0) {j1=-1;break;}
            if
            (
             iHigh(_Symbol,_Period,ii)<iHigh(_Symbol,_Period,ii+1) && 
             iLow(_Symbol,_Period,ii)>iLow(_Symbol,_Period,ii+1)
             )
              {ii++; continue;}
            //---
            if(iLow(_Symbol,_Period,ii)<l)
              {
               j2=ii; j3=-1; iii=ii+1; double hh=iHigh(_Symbol,_Period,ii); double ll=iLow(_Symbol,_Period,ii);
               if(k2<1) k2=j2;
               while(j3<0 && iii<Bars-2)
                 {
                  if(iHigh(_Symbol,_Period,iii)>h) {j1=-1;break;}
                  if(BreakOnly && iLow(_Symbol,_Period,iii)<lm) {j1=-1;break;}
                  if
                  (
                   iHigh(_Symbol,_Period,iii)<iHigh(_Symbol,_Period,iii+1) && 
                   iLow(_Symbol,_Period,iii)>iLow(_Symbol,_Period,iii+1)
                   )
                    {iii++; continue;}
                  //---
                  if(iLow(_Symbol,_Period,iii)<ll) j3=iii;
                  iii++;
                 }
              }
            ii++;
           }
        }
      i++;
     }
   n1=j1;n2=j2;n3=j3;nn=k2;
//---
   DnBars[1]=m1;                           // Номер 1-го бара, паттерн вниз
   DnBars[2]=m2;                           // Номер 2-го бара, паттерн вниз
   DnBars[3]=m3;                           // Номер 3-го бара, паттерн вниз
//---
   UpBars[1]=n1;                           // Номер 1-го бара, паттерн вверх
   UpBars[2]=n2;                           // Номер 2-го бара, паттерн вверх
   UpBars[3]=n3;                           // Номер 3-го бара, паттерн вверх
//---
   DnValues[1]=iLow(_Symbol,_Period,m1);   // Low 1-го бара, паттерн вниз, стоп для Buy
   DnValues[2]=iHigh(_Symbol,_Period,m2);  // High 2-го бара, паттерн вниз
   DnValues[3]=iHigh(_Symbol,_Period,m3);  // High 3-го бара, паттерн вниз, вход на Buy, стоп для Sell
//---
   UpValues[1]=iHigh(_Symbol,_Period,n1);   // High 1-го бара, паттерн вверх, стоп для Sell
   UpValues[2]=iLow(_Symbol,_Period,n2);    // Low 2-го бара, паттерн вверх
   UpValues[3]=iLow(_Symbol,_Period,n3);    // Low 3-го бара, паттерн вверх, вход на Sell, стоп для Buy
//---
   int BH=iHighest(_Symbol,_Period,MODE_HIGH,m3,0);
   int BL=iLowest(_Symbol,_Period,MODE_LOW,n3,0);
//--- Индикация пробоя линии
   double h=iHigh(_Symbol,_Period,BH);
   double l=iLow(_Symbol,_Period,BL);
//---
   if(h>DnValues[3]) {DnBars[0]=BH; DnValues[0]=h;} // Паттерн вниз пробит
   if(l<UpValues[3]) {UpBars[0]=BL; UpValues[0]=l;} // Паттерн вверх пробит
                                                    //      Help=true;
//---
   if(Help)
     {
      string s="\n"+(string)_Period+" - Таймфрейм";
      s=s+"\n"+(string)BBar+" - Начальный бар для поиска паттернов"+"\n";
//---
      s=s+"\n"+DoubleToStr(DnBars[1],0)+" - Номер 1-го бара, паттерн вниз"+
        "\n"+DoubleToStr(DnBars[2],0)+" - Номер 2-го бара, паттерн вниз"+
        "\n"+DoubleToStr(DnBars[3],0)+" - Номер 3-го бара, паттерн вниз"+
        "\n"+DoubleToStr(DnValues[1],d)+" - Low 1-го бара, паттерн вниз, стоп для Buy"+
        "\n"+DoubleToStr(DnValues[2],d)+" - High 2-го бара, паттерн вниз"+
        "\n"+DoubleToStr(DnValues[3],d)+" - High 3-го бара, паттерн вниз, вход на Buy, стоп для Sell";
      if(DnBars[0]!=EMPTY_VALUE) s=s+"\n"+"Паттерн вниз отменен";
//---
      s=s+"\n";
      s=s+     "\n"+DoubleToStr(UpBars[1],0) +" - Номер 1-го бара, паттерн вверх"+
        "\n"+DoubleToStr(UpBars[2],0)+" - Номер 2-го бара, паттерн вверх"+
        "\n"+DoubleToStr(UpBars[3],0)+" - Номер 3-го бара, паттерн вверх"+
        "\n"+DoubleToStr(UpValues[1],d)+" - High 1-го бара, паттерн вверх, стоп для Sell"+
        "\n"+DoubleToStr(UpValues[2],d)+" - Low 2-го бара, паттерн вверх"+
        "\n"+DoubleToStr(UpValues[3],d)+" - Low 3-го бара, паттерн вверх, вход на Sell, стоп для Buy";
      if(UpBars[0]!=EMPTY_VALUE) s=s+"\n"+"Паттерн вверх отменен";
//---
      Comment(s);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
