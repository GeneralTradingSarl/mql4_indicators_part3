//+------------------------------------------------------------------+
//|                                        VininI ConstTickPrice.mq4 |
//|                      Copyright © 2008, Victor Nicolaev aka Vinin |
//|                                            e-mail: vinin@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Victor Nicolaev aka Vinin"
#property link      "e-mail: vinin@mail.ru"


#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_color2 White

extern int Price_Mode=0;
extern int CountTick=100;
extern bool DrawAll=false;

//---- buffers
double Price[];
double _CountBar[];
double _Volume[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
  {
//---- drawing settings
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   if(!SetIndexBuffer(0,Price)) Print("Невозможно инициализировать массив Price");
   if(!SetIndexBuffer(1,_CountBar)) Print("Невозможно инициализировать массив CountBar");
   if(!SetIndexBuffer(2,_Volume)) Print("Невозможно инициализировать массив Volume");

   SetIndexLabel(0,"Price");
   Price_Mode=MathMax(Price_Mode,0);
   Price_Mode=MathMin(Price_Mode,6);
   return(0); 
  }//int init() 
//+------------------------------------------------------------------+
int start() 
  {
   int limit;
   int counted_bars=IndicatorCounted();
   int i;
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0)
     {
      limit-=3;
      ArrayInitialize(_CountBar,0);
     }
   for(i=limit;i>=0;i--)
     {
      _Volume[i]=_Volume[i+1]+Volume[i];
      _CountBar[i]=_CountBar[i+1]+1;
      CheckWeek(i);
      CheckBar(i);
      CheckTick(i);
      RedRaw(i);

     }
   return(0);
  }// int start()
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RedRaw(int pos)
  {
   int i;
   if(!DrawAll) 
     {
      for(i=1;i<=_CountBar[pos];i++) 
        {
         Price[pos+i]=EMPTY_VALUE;
        }
     }
   Price[pos]=fPrice(Price_Mode,pos,_CountBar[pos]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckWeek(int pos)
  {
   if(TimeDayOfWeek(Time[pos+1])>TimeDayOfWeek(Time[pos+0])) 
     {
      _Volume[pos]=Volume[pos];
      _CountBar[pos]=0;
      RedRaw(pos+1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckBar(int pos)
  {
   int tmp0=Ostatok(_Volume[pos+0],CountTick);
   int tmp1=Ostatok(_Volume[pos+1],CountTick);
   if(tmp0<tmp1) 
     {
      if(tmp0>CountTick-tmp1) 
        {
         _CountBar[pos]=0;
         RedRaw(pos+1);
        }
      else 
        {
         _CountBar[pos+1] = 0;
         _CountBar[pos]   = 1;
         RedRaw(pos+2);
         RedRaw(pos+1);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTick(int pos) 
  {
   if(Volume[pos]>CountTick) 
     {
      _CountBar[pos]=0;
      RedRaw(pos+1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Ostatok(double Value1,double Value2)
  {
   double tmp=NormalizeDouble(Value1/Value2,0);
   if(tmp*Value2>Value1) tmp--;
   return(Value1-tmp*Value2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double fPrice(int _Price_Mode,int pos,int shift) 
  {
   double   _CLOSE,_OPEN,_HIGH,_LOW,_MEDIAN,_TYPICAL,_WEIGHTED;
   _OPEN=Open[pos+shift];
   if(shift>0) 
     {
      _HIGH=High[iHighest(NULL,0,MODE_HIGH,shift,pos)];
      _LOW=Low[iLowest(NULL,0,MODE_LOW,shift,pos)];
     }
   else 
     {
      _HIGH=High[pos];
      _LOW=Low[pos];
     }
   _CLOSE=Close[pos];

   _MEDIAN=(_HIGH+_LOW)/2.0;
   _TYPICAL=(_HIGH+_LOW+_CLOSE)/3.0;
   _WEIGHTED=(_HIGH+_LOW+2.0*_CLOSE)/4.0;
   switch(_Price_Mode) 
     {
      case PRICE_CLOSE:    return(_CLOSE);
      case PRICE_OPEN:     return(_OPEN);
      case PRICE_HIGH:     return(_HIGH);
      case PRICE_LOW:      return(_LOW);
      case PRICE_MEDIAN:   return(_MEDIAN);
      case PRICE_TYPICAL:  return(_TYPICAL);
      case PRICE_WEIGHTED: return(_WEIGHTED);
     }
   return(0);
  }
//+------------------------------------------------------------------+
