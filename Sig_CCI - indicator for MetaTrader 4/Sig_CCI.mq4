//+------------------------------------------------------------------+
//|                                                     Sig_Soch.mq4 |
//|                      Copyright © 2009, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

extern int PerCCI=24;
extern bool Al=true;
double CCI;
double CCIold;
double ArrShift;
double BufUp[];
double BufDn[];
int s,b;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   
   SetIndexBuffer(0, BufUp);
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 233);
   
   SetIndexBuffer(1, BufDn);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 234);
   switch (Period()) {
   	case PERIOD_M1:	ArrShift = Point * 5;	break;
   	case PERIOD_M5:	ArrShift = Point * 10;	break;
   	case PERIOD_M15:	ArrShift = Point * 20;	break;
   	case PERIOD_M30:	ArrShift = Point * 20;	break;
   	case PERIOD_H1:	ArrShift = Point * 40;	break;
   	case PERIOD_H4:	ArrShift = Point * 80;	break;
   	case PERIOD_D1:	ArrShift = Point * 100;	break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, 
       Counted_bars=IndicatorCounted();
   i=Bars-Counted_bars-1;
//----
      while(i>=1)                      // Цикл по непосчитанным барам     
      {      
        
         CCI=iCCI(NULL,0,PerCCI,PRICE_TYPICAL,i);
         CCIold=iCCI(NULL,0,PerCCI,PRICE_TYPICAL,i+1);
         if (CCI>-100 && CCIold<-100) {BufUp[i]=Low[i] - ArrShift;if (b<2 && Al==true) {Alert(Symbol()+" CCI Говорит покупай по "+Close[i]);b=b+1;s=0;}}
         if (CCI<100 && CCIold>100) {BufDn[i]=High[i] + ArrShift;if (s<2 && Al==true) {Alert(Symbol()+" CCI Говорит продавай по "+Close[i]);s=s+1;b=0;}}         
         i--;                          // Расчёт индекса следующего бара
              
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+

ение к ф-ии
      if (New_Bar==false)                          // Если бар не новый..
      return;	
      if (b>0 && Al==true) {Alert(Symbol()+" CCI Говорит покупай по "+Close[pos]);}
      if (s>0 && Al==true) {Alert(Symbol()+" CCI Говорит продавай по "+Close[pos]);}
//----
   return(0);
  }
//+------------------------------------------------------------------+
void Fun_New_Bar()                              // Ф-ия обнаружения ..
  {                                             // .. нового бара
   static datetime New_Time=0;                  // Время текущего бара
   New_Bar=false;                               // Нового бара нет
   if(New_Time!=Time[0])                        // Сравниваем время
     {
      New_Time=Time[0];                         // Теперь время такое
      New_Bar=true;                             // Поймался новый бар
     }
  }