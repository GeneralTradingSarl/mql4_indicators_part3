//+------------------------------------------------------------------+
//|                                                          SSL.mq4 |
//|ssl bar fast mtf                                          Kalenzo |
//|                                      bartlomiej.gorski@gmail.com |
//+------------------------------------------------------------------+
//mod2008fxtsd   ml ki   
#property copyright "Kalenzo"
#property link      "bartlomiej.gorski@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1  DodgerBlue
#property indicator_color2  OrangeRed
#property indicator_width1  2
#property indicator_width2  2
#property indicator_minimum 10
#property indicator_maximum 90
//----
extern int     Lb          =10;
extern int     SSL_BarLevel=15;    //BarLevel 10-90
extern int     TimeFrame=0;
extern string  TimeFrames="M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF";
//----
double sslHup[];
double sslHdn[];
double hlv[];
string IndicatorFileName;
datetime TimeArray[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string TimeFrameStr;
   if(TimeFrame<Period()) TimeFrame=Period();
   switch(TimeFrame)
     {
      case PERIOD_M1:  TimeFrameStr="M1";break;
      case PERIOD_M5:  TimeFrameStr="M5";break;
      case PERIOD_M15: TimeFrameStr="M15";break;
      case PERIOD_M30: TimeFrameStr="M30";break;
      case PERIOD_H1:  TimeFrameStr="H1";break;
      case PERIOD_H4:  TimeFrameStr="H4";break;
      case PERIOD_D1:  TimeFrameStr="D1";break;
      case PERIOD_W1:  TimeFrameStr="W1";break;
      case PERIOD_MN1: TimeFrameStr="MN1";break;
      default :        TimeFrameStr="TF0";
     }
//----
   IndicatorBuffers(3);
   SetIndexBuffer(0,sslHup); SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,167); SetIndexLabel(0,"SSLup "+Lb+" ["+TimeFrame+"]");
   SetIndexBuffer(1,sslHdn); SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,167); SetIndexLabel(1,"SSLdn "+Lb+" ["+TimeFrame+"]");
   SetIndexBuffer(2,hlv);
//----
   IndicatorShortName("SSL "+Lb+"["+TimeFrameStr+"]");
   IndicatorFileName=WindowExpertName();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int  i,y=0,limit;
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1+TimeFrame/Period();
//----
   if(TimeFrame!=Period())
     {
      //limit=MathMax(limit,TimeFrame/Period());
      ArrayCopySeries(TimeArray,MODE_TIME,NULL,TimeFrame);
      //----
      for(i=0,y=0; i<limit; i++)
        {
         if(y<ArraySize(TimeArray)){ if(Time[i]<TimeArray[y]) y++;}
         sslHup[i]=iCustom(NULL,TimeFrame,IndicatorFileName,Lb,SSL_BarLevel,0,y);
         sslHdn[i]=iCustom(NULL,TimeFrame,IndicatorFileName,Lb,SSL_BarLevel,1,y);
        }
      return(0);
     }
//----
   for(i=limit-1;i>=0;i--)
     {
      hlv[i]=hlv[i+1];
      if(Close[i]>iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1)) hlv[i]= 1;
      if(Close[i]<iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW,i+1))  hlv[i]=-1;
      if(hlv[i]==-1) { sslHdn[i]=SSL_BarLevel; sslHup[i]=EMPTY_VALUE;  }
      else
        { sslHdn[i]=EMPTY_VALUE;  sslHup[i]=SSL_BarLevel; }
     }
   return(0);
  }
//+------------------------------------------------------------------+
