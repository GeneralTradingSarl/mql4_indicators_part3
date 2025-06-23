//+------------------------------------------------------------------+
//|                                 The computer time resolution.mq4 |
//|                                                     Nauris Zukas |
//|                             https://www.mql5.com/ru/users/abeiks |
//+------------------------------------------------------------------+
#property copyright "Nauris Zukas"
#property link      "https://www.mql5.com/ru/users/abeiks"
#property version   "1.00"
#property strict
#property indicator_chart_window


// Name
input string TimeResolution="TimeResolution";
// true - the computer time resolution, false - time between last ticks
input bool TimeResolutionOn=true;
// Label show ON/OFF
input bool LabelShowOn=true;
// 0 - upper left, 1 - upper right, 2 - bottom left, 3 - bottom right.
input int LabelCorner=3;
bool flag=false;
uint _LastTickCount,_LastTickCountTick,tickTime;
uint Time_LastTickCount,Time_LastTickCountTick,TimetickTime;

#import "user32.dll"
int  RegisterWindowMessageA(string lpString);
int  PostMessageA(int hWnd,int Msg,int wParam,int lParam);
#define WM_COMMAND                     0x0111
#import
int MT4InternalMsg;
int hwnd;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   int res=INIT_SUCCEEDED;
//--- indicator buffers mapping

   if(ChartGetInteger(ChartID(),CHART_IS_OFFLINE))
     {
      flag=false;
      Print("Init= ",flag);
     }
   else
     {
      flag=true;
      Print("Init= ",flag);
     }

   if(!flag) res=INIT_FAILED;

   EventSetMillisecondTimer(1);
   _LastTickCount=0;
   _LastTickCountTick=0;
//---
   return(res);
  }
//+------------------------------------------------------------------+ 
//| Обработчик события Deinit                                        | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason)
  {

   if(reason==REASON_INITFAILED)
     {
      bool res=ChartIndicatorDelete(0,ChartWindowFind(),"The computer time resolution");
      Print(" Please add The computer time resolution to online chart");
     }
   EventKillTimer();

   ObjectDelete("Label1");
   ObjectDelete("Label2");
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

   if(!TimeResolutionOn)Tick_Resolution();

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   if(TimeResolutionOn)Timer_Resolution();

  }
//+------------------------------------------------------------------+
//|    Tick resolution.                                              |
//+------------------------------------------------------------------+
void Tick_Resolution()
  {

   if(MT4InternalMsg==0)
     {
      MT4InternalMsg=RegisterWindowMessageA("MetaTrader4_Internal_Message");
     }

   hwnd=WindowHandle(TimeResolution,1);
   if(PostMessageA(hwnd,WM_COMMAND,0x822c,0)==false)
     {
      hwnd=0;
      return;
     }
   PostMessageA(hwnd,MT4InternalMsg,2,1);

   uint TickCount;
   TickCount=GetTickCount();

   if(_LastTickCount==0){_LastTickCount=TickCount;return;}

   tickTime=TickCount-_LastTickCount; _LastTickCount=TickCount;

   if(!TimeResolutionOn && LabelShowOn)
     {
      SetLabel("Label1","Time_Resolution",Yellow,50,35,LabelCorner,10);
      SetLabel("Label2",DoubleToStr(tickTime,0),Yellow,5,35,LabelCorner,10);

     }
  }
//+------------------------------------------------------------------+
//|    Time resolution.                                              |
//+------------------------------------------------------------------+
void Timer_Resolution()
  {
   uint TimeCount;
   TimeCount=GetTickCount();

   if(Time_LastTickCount==0){Time_LastTickCount=TimeCount;return;}

   TimetickTime=TimeCount-Time_LastTickCount; Time_LastTickCount=TimeCount;

   if(TimeResolutionOn && LabelShowOn)
     {
      SetLabel("Label1","Time_Resolution",Yellow,50,35,LabelCorner,10);
      SetLabel("Label2",DoubleToStr(TimetickTime,0),Yellow,5,35,LabelCorner,10);

     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|    Label module                                                  |
//+------------------------------------------------------------------+
void SetLabel(string nm,string tx,color cl,int xd,int yd,int cr=0,int fs=9)
  {
   if(ObjectFind(nm)<0) ObjectCreate(nm,OBJ_LABEL,0,0,0);
   ObjectSetText(nm,tx,fs);
   ObjectSet(nm,OBJPROP_COLOR,cl);
   ObjectSet(nm,OBJPROP_XDISTANCE,xd);
   ObjectSet(nm,OBJPROP_YDISTANCE,yd);
   ObjectSet(nm,OBJPROP_CORNER,cr);
   ObjectSet(nm,OBJPROP_FONTSIZE,fs);
  }
//+------------------------------------------------------------------+
