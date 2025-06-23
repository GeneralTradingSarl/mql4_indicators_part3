//+------------------------------------------------------------------+
//|                                           Regression_Channel.mq4 |
//|                                        Converted to MT4 by KimIV |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
//---
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
//--- Внешние параметры индикатора
extern int    NumberName   = 1;
extern int    iPeriod      = 21;
extern double MAShoot      = 50;
extern bool   DrawVertical = True;
extern bool   DrawText     = True;
extern bool   ShowMA       = True;
extern int    LineWeight   = 1;
extern int    BarsCount    = 0;
//--- Буферы индикатора
double MABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
  {
   ObjectCreate("Regression_middle"+(string)NumberName,OBJ_TREND,0,0,0,0,0);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_COLOR,Yellow);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_WIDTH,LineWeight);
   ObjectCreate("Regression_upper"+(string)NumberName,OBJ_TREND,0,0,0,0,0);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_WIDTH,LineWeight);
   ObjectCreate("Regression_lower"+(string)NumberName,OBJ_TREND,0,0,0,0,0);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_WIDTH,LineWeight);
   if(DrawText)
     {
      ObjectCreate("Regression_bars_begin"+(string)NumberName,OBJ_TEXT,0,0,0,0,0,0,0);
      ObjectCreate("Regression_bars_end"+(string)NumberName,OBJ_TEXT,0,0,0,0,0,0,0);
     }
   if(DrawVertical)
     {
      ObjectCreate("Regression_begin"+(string)NumberName,OBJ_VLINE,0,0,0);
      ObjectSet("Regression_begin"+(string)NumberName,OBJPROP_COLOR,Silver);
      ObjectSet("Regression_begin"+(string)NumberName,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("Regression_begin"+(string)NumberName,OBJPROP_WIDTH,1);
      ObjectCreate("Regression_end"+(string)NumberName,OBJ_VLINE,0,0,0);
      ObjectSet("Regression_end"+(string)NumberName,OBJPROP_COLOR,Silver);
      ObjectSet("Regression_end"+(string)NumberName,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("Regression_end"+(string)NumberName,OBJPROP_WIDTH,1);
     }
//---
   SetIndexBuffer(0,MABuffer);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   Comment("Auto Regression channel");
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectDelete("Regression_middle"+(string)NumberName);
   ObjectDelete("Regression_upper"+(string)NumberName);
   ObjectDelete("Regression_lower"+(string)NumberName);
   ObjectDelete("Regression_bars_begin"+(string)NumberName);
   ObjectDelete("Regression_bars_end"+(string)NumberName);
   ObjectDelete("Regressin_begin"+(string)NumberName);
   ObjectDelete("Regressin_end"+(string)NumberName);
   Comment("");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   bool   check_low,check_high;
   bool   check_upper_chanel;
   color  color_1,color_2;
   double save_low,save_high;
   double MA,a1,a2,a3,b1,a_,b_,y1,y2,price;
   double stddiv_low,stddiv_high,tmp_div;
   double x_n_up,x_1_up,x_n_down,x_1_down;
   double ratio_currency;
   int    Bars_,shift;
   int    n,n_begin,n_end;
   int    MAType,MAPrice;
   int    save_shift_low,save_shift_high;
//---
   if(BarsCount<1) Bars_=Bars;
   else Bars_=BarsCount;
//---
   save_low=-1;
   save_high=-1;
   save_shift_low=-1;
   save_shift_high=-1;
//---
   check_low=false;
   check_high=false;
//---
   MAType=MODE_SMA;
   MAPrice=PRICE_CLOSE;
//---
   if(Close[1]>80) ratio_currency=100;
   else ratio_currency=10000;
//--- Поиск точек пересечения с МА
   for(shift=Bars_-1; shift>=0; shift--)
     {
      MA=iMA(NULL,0,iPeriod,0,MAType,MAPrice,shift);
      if(ShowMA) MABuffer[shift]=MA;
      if(MA-MAShoot/ratio_currency>Close[shift])
        {
         if(Close[shift]<save_low || save_low==-1)
           {
            check_low= true;
            save_low = Close[shift];
            save_shift_low=shift;
           }
        }
      //---
      if(MA+MAShoot/ratio_currency<Close[shift])
        {
         if(save_high<Close[shift] || save_high==-1)
           {
            check_high= true;
            save_high = Close[shift];
            save_shift_high=shift;
           }
        }
      //---
      if(check_low)
        {
         if(MA+MAShoot/ratio_currency<Close[shift])
           {
            check_low= false;
            save_low = -1;
           }
        }
      //---
      if(check_high)
        {
         if(MA-MAShoot/ratio_currency>Close[shift])
           {
            check_high= false;
            save_high = -1;
           }
        }
     }
//--- Определение границ построения каналла
   if(save_shift_low>save_shift_high)
     {
      n_begin=save_shift_low;
      n_end=save_shift_high;
        } else {
      n_begin=save_shift_high;
      n_end=save_shift_low;
     }
//---
   if(n_end==0) n_end = 1; // Нулевой бар не использовать
   n = n_begin - n_end+ 1; // длина канала
//---
   a1 = 0;
   a2 = 0;
   a3 = 0;
   b1 = 0;
   a_ = 0;
   b_ = 0;
   y1 = 0;
   y2 = 0;
   tmp_div=0;
//---
   if(Close[n_begin]<Close[n_end]) check_upper_chanel=true;
   else check_upper_chanel=false;
//---
   for(shift=n_begin; shift>=n_end; shift--)
     {
      if(check_upper_chanel) price=Low[shift];
      else price=High[shift];
      //---
      a1 = a1 + shift*price;
      a2 = a2 + shift;
      a3 = a3 + price;
      b1 = b1 + shift*shift;
     }
//---
   b_ = (n*a1 - a2*a3)/(n*b1 - a2*a2);
   a_ = (a3 - b_*a2)/n;
   y1 = a_ + b_*n_begin;
   y2 = a_ + b_*n_end;
//---
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_TIME1,Time[n_begin]);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_TIME2,Time[n_end]);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_PRICE1,y1);
   ObjectSet("Regression_middle"+(string)NumberName,OBJPROP_PRICE2,y2);
//---
   for(shift=n_begin; shift>=n_end; shift--)
     {
      if(check_upper_chanel) price=Low[shift];
      else price=High[shift];

      tmp_div=tmp_div+(price -(a_+b_*shift))*(price -(a_+b_*shift));
     }
//---
   stddiv_low=MathSqrt(tmp_div/n);
   stddiv_high=MathSqrt(tmp_div/n);
//---
   x_n_up = y1 + 3*stddiv_high;
   x_1_up = y2 + 3*stddiv_high;
//---
   x_n_down = y1 - 3*stddiv_low;
   x_1_down = y2 - 3*stddiv_low;
//---
   if(check_upper_chanel)
     {
      color_1 = Blue;
      color_2 = Red;
        } else {
      color_1 = Red;
      color_2 = Blue;
     }
//--- upper
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_TIME1,Time[n_begin]);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_TIME2,Time[n_end]);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_PRICE1,x_n_up);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_PRICE2,x_1_up);
   ObjectSet("Regression_upper"+(string)NumberName,OBJPROP_COLOR,color_1);
//--- lower
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_TIME1,Time[n_begin]);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_TIME2,Time[n_end]);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_PRICE1,x_n_down);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_PRICE2,x_1_down);
   ObjectSet("Regression_lower"+(string)NumberName,OBJPROP_COLOR,color_2);
//---
   if(DrawText)
     {
      ObjectSet("Regression_bars_begin"+(string)NumberName,OBJPROP_TIME1,Time[n_begin]);
      ObjectSet("Regression_bars_begin"+(string)NumberName,OBJPROP_PRICE1,x_n_down);
      ObjectSetText("Regression_bars_begin"+(string)NumberName,DoubleToStr(n_begin,0),10,"System",White);

      ObjectSet("Regression_bars_end"+(string)NumberName,OBJPROP_TIME1,Time[n_end]);
      ObjectSet("Regression_bars_end"+(string)NumberName,OBJPROP_PRICE1,x_1_up);
      ObjectSetText("Regression_bars_end"+(string)NumberName,DoubleToStr(n_end,0),10,"System",White);
        } else {
      ObjectDelete("Regression_bars_begin"+(string)NumberName);
      ObjectDelete("Regression_bars_end"+(string)NumberName);
     }
//---
   if(DrawVertical)
     {
      ObjectSet("Regression_begin"+(string)NumberName,OBJPROP_TIME1,Time[n_begin]);
      ObjectSet("Regression_end"+(string)NumberName,OBJPROP_TIME1,Time[n_end]);
        } else {
      ObjectDelete("Regression_begin"+(string)NumberName);
      ObjectDelete("Regression_end"+(string)NumberName);
     }
  }
//-------------------------------------------------------------------+
