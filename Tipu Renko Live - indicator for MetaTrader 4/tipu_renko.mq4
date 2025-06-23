//+------------------------------------------------------------------+
//|                                                   Tipu Renko.mq4 |
//|                                    Copyright 2016, Kaleem Haider |
//|                      https://www.mql5.com/en/users/kaleem.haider |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Kaleem Haider"
#property link      "https://www.mql5.com/en/users/kaleem.haider"
#property version   "1.10"
#property strict
#property indicator_chart_window

#define PipsPoint Get_PipsPoint()
//Enumerations for Renko Mode
enum ENUM_RenkoMode
  {
   rClose = 0,       //Close
   rHighLow = 1,     //High/Low
  };
//Enumeration for type of marks
enum ENUM_RenkoMark
  {
   None=0,
   Brick=1,
   Arrows=2,
  };

input ENUM_RenkoMode eRenkoMode        =  0;              //Box Mode
input ENUM_RenkoMark eRenkoMark        =  1;              //Renko Mark
input int            iRenkoSize        =  10;             //Reko Size
input ENUM_LINE_STYLE eRenkoStyle      =  0;              //Line Style
input int            iRenkoWidth       =  1;              //Line Width
input color          cUpCandle         =  C'31,159,192';  //Up Color
input color          cDwnCandle        =  C'230,77,69';   //Down Color
input bool           bFill             =  true;           //Fill Candles
input bool           bAlertM=true;          //Alert Mobile
input bool           bAlertS=true;           //Alert Onscreen
input bool           bAlertE=true;          //Alert Email

string short_name="tp_Renko";
string indicator_name="Tipu Renko";
int iLastTrend;
double dLowR=0,dHighR=0,dOpenR=0,dCloseR=0;
datetime dtPrevTime=0;
static datetime prevTime;
double dBuyCounter=0.0,dSellCounter=0.0;

double dTrendBuffer[],dSignalBuffer[],dBuyCountBuffer[],dSellCountBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//Delete for templates
   DeleteBricks();

   int n=0;
//--- indicator buffers mapping
   IndicatorSetString(INDICATOR_SHORTNAME,indicator_name);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   IndicatorBuffers(4);

//---Holder for the signals, and trend
   SetIndexBuffer(n,dSignalBuffer,INDICATOR_CALCULATIONS); n++;
   SetIndexBuffer(n,dTrendBuffer,INDICATOR_CALCULATIONS);  n++;
   SetIndexBuffer(n,dBuyCountBuffer,INDICATOR_CALCULATIONS); n++;
   SetIndexBuffer(n,dSellCountBuffer,INDICATOR_CALCULATIONS); n++;

//---Create Label for Renko Brick Size
   if(ObjectFind(0,short_name+"lRenkoSize")>=0) ObjectDelete(0,short_name+"lRenkoSize");
   else  EditCreate(0,short_name+"lRenkoSize",0,90,10,67,18,"Renko Size: ","Calibri",10,ALIGN_LEFT,true,CORNER_RIGHT_UPPER,clrWhite,clrOrangeRed,clrOrangeRed,false,false,false);

   if(ObjectFind(0,short_name+"iRenkoSize")>=0) ObjectDelete(0,short_name+"iRenkoSize");
   else EditCreate(0,short_name+"iRenkoSize",0,21,10,20,18,(string)iRenkoSize,"Calibri",10,ALIGN_CENTER,true,CORNER_RIGHT_UPPER,clrWhite,clrOrangeRed,clrOrangeRed,false,false,false);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//Delete the Bricks
   DeleteBricks();
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
   int limit;
   string sMsg,sSubject;
   bool bBuy=false,bSell=false;

   ArraySetAsSeries(dTrendBuffer,true);
   ArraySetAsSeries(dSignalBuffer,true);
   ArraySetAsSeries(dBuyCountBuffer,true);
   ArraySetAsSeries(dSellCountBuffer,true);

   if(prev_calculated < 0)  return(0);

   if(prev_calculated>0) limit=rates_total-prev_calculated+1; //non-repainting should give -2 if prev_cal is 0, meaning two candles ahead
   else
     {
      limit=rates_total-1;
      dLowR  = low[limit];
      dOpenR = open[limit];
      dtPrevTime=time[limit];
     }

   for(int i=limit-1; i>=0; i--)
     {
      double dcheck=iRenkoSize*PipsPoint;
      switch(eRenkoMode)
        {
         case 0:
            bBuy=close[i]>=dOpenR+dcheck;
            bSell=close[i]<=dOpenR-dcheck;
            break;

         case 1:
            bBuy=high[i]>=dOpenR+dcheck;
            bSell=low[i]<=dOpenR-dcheck;
            break;
        }

      if(bBuy)
        {
         dCloseR=NormalizeDouble(dOpenR,_Digits)+dcheck;
         if(ObjectFind(0,short_name+(string)time[i])<0 && eRenkoMark==1)
            RectangleCreate(0,short_name+(string)time[i],0,dtPrevTime,dOpenR,time[i],dCloseR,cUpCandle,eRenkoStyle,iRenkoWidth,bFill,false,false,false,0);
         dOpenR=dCloseR;
         dtPrevTime=time[i];
         dSellCounter=0; dSellCountBuffer[i]=dSellCounter;
         if(dTrendBuffer[i+1]!=OP_BUY)
           {
            dSignalBuffer[i]=OP_BUY;
            dTrendBuffer[i]=dSignalBuffer[i];
            dBuyCounter=1;  dBuyCountBuffer[i]=dBuyCounter;
            if(ObjectFind(0,short_name+(string)time[i])<0 && eRenkoMark==2)
               ArrowCreate(0,short_name+(string)time[i],0,time[i],low[i],233,ANCHOR_TOP,cUpCandle,eRenkoStyle,iRenkoWidth,false,false,false);
           }
         else
           {dBuyCounter++;     dBuyCountBuffer[i]=dBuyCounter;}
        }
      if(bSell)
        {
         dCloseR=NormalizeDouble(dOpenR,_Digits)-dcheck;
         if(ObjectFind(0,short_name+(string)time[i])<0 && eRenkoMark==1)
            RectangleCreate(0,short_name+(string)time[i],0,dtPrevTime,dOpenR,time[i],dCloseR,cDwnCandle,eRenkoStyle,iRenkoWidth,bFill,false,false,false,0);
         dOpenR=dCloseR;
         dtPrevTime=time[i];
         dBuyCounter=0;  dBuyCountBuffer[i]=dBuyCounter;
         if(dTrendBuffer[i+1]!=OP_SELL)
           {
            dSignalBuffer[i]=OP_SELL;
            dTrendBuffer[i]=dSignalBuffer[i];
            dSellCounter=1; dSellCountBuffer[i]=dSellCounter;
            if(ObjectFind(0,short_name+(string)time[i])<0 && eRenkoMark==2)
               ArrowCreate(0,short_name+(string)time[i],0,time[i],high[i],234,ANCHOR_BOTTOM,cDwnCandle,eRenkoStyle,iRenkoWidth,false,false,false);
           }
         else
           {dSellCounter++;   dSellCountBuffer[i]=dSellCounter;}
        }

      if(dTrendBuffer[i]!=OP_BUY && dTrendBuffer[i]!=OP_SELL)
         dTrendBuffer[i]=dTrendBuffer[i+1];
      if(dBuyCountBuffer[i] == EMPTY_VALUE)
         dBuyCountBuffer[i] = dBuyCountBuffer[i+1];
      if(dSellCountBuffer[i] == EMPTY_VALUE)
         dSellCountBuffer[i] = dSellCountBuffer[i+1];
     }
//Alerts
   if(dSignalBuffer[0]==OP_BUY)
     {
      sMsg=indicator_name+" "+_Symbol+"\n "+"Buy Alert: "+
           "\n Time: "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES)+
           "\n Current Chart Period: "+StringTime(_Period);
      sSubject=indicator_name+" "+_Symbol+" "+"Buy Alert - Current Chart Period: "+StringTime(_Period);
      SendAlert(bAlertM,bAlertS,bAlertE,sMsg,sSubject);
      dTrendBuffer[0]=OP_BUY;
     }
   if(dSignalBuffer[0]==OP_SELL)
     {
      sMsg=indicator_name+" "+_Symbol+"\n "+"Sell Alert: "
           "\n Time: "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES)+
           "\n Current Chart Period: "+StringTime(_Period);
      sSubject=indicator_name+" "+_Symbol+" "+"Sell Alert - Current Chart Period: "+StringTime(_Period);
      SendAlert(bAlertM,bAlertS,bAlertE,sMsg,sSubject);
      dTrendBuffer[0]=OP_SELL;
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

double Get_PipsPoint()
  {
   double PP=(_Digits==5 || _Digits==3)?_Point*10:_Point;
   return (PP);
  }
//+------------------------------------------------------------------------------+
//| The following code is taken from:                                            |
//| https://docs.mql4.com/constants/objectconstants/enum_object/obj_rectangle    |
//+------------------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID=0,        // chart's ID
                     const string          name="Rectangle",  // rectangle name
                     const int             sub_window=0,      // subwindow index 
                     datetime              time1=0,           // first point time
                     double                price1=0,          // first point price
                     datetime              time2=0,           // second point time
                     double                price2=0,          // second point price
                     const color           clr=clrRed,        // rectangle color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                     const int             width=1,           // width of rectangle lines
                     const bool            fill=false,        // filling rectangle with color
                     const bool            back=false,        // in the background
                     const bool            selection=true,    // highlight to move
                     const bool            hidden=true,       // hidden in the object list
                     const long            z_order=0,         // priority for mouse click
                     const string          tooltip="Rectangle",// tooltip
                     const int             timeframes=OBJ_ALL_PERIODS) //show on timeframes)
  {

   ResetLastError();
//--- create a rectangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Name: "+name+" Error code = ",GetLastError());
      return(false);
     }

   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
   ObjectSetInteger(chart_ID,name,OBJPROP_TIMEFRAMES,timeframes);

//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------------------+
//| The following code is taken from:                                            |
//| https://docs.mql4.com/constants/objectconstants/enum_object/obj_arrow        |
//+------------------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // chart's ID
                 const string            name="Arrow",         // arrow name
                 const int               sub_window=0,         // subwindow index
                 datetime                time=0,               // anchor point time
                 double                  price=0,              // anchor point price
                 const uchar             arrow_code=252,       // arrow code
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position
                 const color             clr=clrRed,           // arrow color
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style
                 const int               width=3,              // arrow size
                 const bool              back=false,           // in the background
                 const bool              selection=true,       // highlight to move
                 const bool              hidden=true,          // hidden in the object list
                 const long              z_order=0,            // priority for mouse click
                 const string            tooltip="Arrow",      // tooltip
                 const int               timeframes=OBJ_ALL_PERIODS) //show on timeframes)                 
  {

//--- reset the error value
   ResetLastError();
//--- create an arrow
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
   ObjectSetInteger(chart_ID,name,OBJPROP_TIMEFRAMES,timeframes);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0,                // priority for mouse click
                const string           tooltip="Edit",// tooltip
                const int              timeframes=OBJ_ALL_PERIODS) //show on timeframes                
  {
//--- reset the error value
   ResetLastError();
//--- create edit field
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create \"Edit\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set object coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
   ObjectSetInteger(chart_ID,name,OBJPROP_TIMEFRAMES,timeframes);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|Delete Bricks                                                     |
//+------------------------------------------------------------------+
void DeleteBricks()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string name=ObjectName(i);
      if(StringFind(name,short_name,0)>=0) ObjectDelete(0,name);
     }

   return;
  }
//+------------------------------------------------------------------+
//| Send Alerts                                                      |
//+------------------------------------------------------------------+
void SendAlert(bool bMobile,bool bScreen,bool bEmail,string sMsg,string sSub)
  {
   if(bMobile || bScreen || bEmail)
     {
      if(sMsg!="")
        {
         if(prevTime<iTime(_Symbol,_Period,0))
           {
            prevTime=iTime(_Symbol,_Period,0);
            if(bMobile) SendNotification(sSub);
            if(bScreen) Alert(sSub);
            if(bEmail) SendMail(sSub,sMsg);
           }
        }
     }
  }
//+------------------------------------------------------------------+
string StringTime(int iTimeSeek)
  {
   string sTime="";

   switch(iTimeSeek)
     {
      case 1: sTime = "PERIOD_M1"; break;
      case 2: sTime = "PERIOD_M2"; break;
      case 3: sTime = "PERIOD_M3"; break;
      case 4: sTime = "PERIOD_M4"; break;
      case 5: sTime = "PERIOD_M5"; break;
      case 6: sTime = "PERIOD_M6"; break;
      case 10: sTime = "PERIOD_M10"; break;
      case 12: sTime = "PERIOD_M12"; break;
      case 15: sTime = "PERIOD_M15"; break;
      case 20: sTime = "PERIOD_M20"; break;
      case 30: sTime = "PERIOD_M30"; break;
      case 60: sTime = "PERIOD_H1"; break;
      case 120: sTime = "PERIOD_H2"; break;
      case 180: sTime = "PERIOD_H3"; break;
      case 240: sTime = "PERIOD_H4"; break;
      case 360: sTime = "PERIOD_H6"; break;
      case 480: sTime = "PERIOD_H8"; break;
      case 720: sTime = "PERIOD_H12"; break;
      case 1440: sTime= "PERIOD_D1"; break;
      case 10080: sTime = "PERIOD_W1"; break;
      case 43200: sTime = "PERIOD_MN1"; break;
     }
   return(sTime);
  }
//+------------------------------------------------------------------+
