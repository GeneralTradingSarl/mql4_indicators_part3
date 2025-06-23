//+------------------------------------------------------------------+
//|                                                     WaveDash.mq4 |
//|                                                       Pipswanted |
//|                                           contact@pipswanted.com |
//+------------------------------------------------------------------+
#property copyright "Pipswanted"
#property link      "http://wwww.pipswanted.com"
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green
extern int Back=10;
double red[],green[],one,two;
#property indicator_chart_window

int init()
  {
   SetIndexBuffer(0,red);
   SetIndexBuffer(1,green);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);

   return(0);
  }

int deinit()
  {
   return(0);
  }

int start()
  {
  
   ArrayInitialize( red, EMPTY_VALUE);
   ArrayInitialize( green, EMPTY_VALUE);
   for(int i=Bars-Back;i>=0;i--)
     {
      if(Close[i]>iMA(Symbol(),0,Back,0,MODE_SMA,PRICE_HIGH,i))
      {
         one=1;
      }   
      else
      {
         if(Close[i]<iMA(Symbol(),0,Back,0,MODE_SMA,PRICE_LOW,i))
            one=-1;
         else
            one=0;
      }
      
      if(one!=0)
      {
         two=one;
      }   
      if(two==-1)
      {
         double a = iMA(Symbol(),0,Back,0,MODE_EMA,PRICE_HIGH,i+1) - iClose(Symbol(), 0 ,i+2);
         red[i] = (iClose(Symbol(), 0 ,i) - a); 
      }
      else
      {
         double b = iClose(Symbol(), 0 ,i+2) - iMA(Symbol(),0,Back,0,MODE_EMA,PRICE_LOW,i+1);
         green[i] = (iClose(Symbol(), 0 ,i) + b);
      }
     }

   return(0);
  }

