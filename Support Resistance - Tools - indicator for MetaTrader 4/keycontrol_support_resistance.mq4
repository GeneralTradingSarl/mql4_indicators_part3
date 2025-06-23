//+------------------------------------------------------------------+
//|                                           wfx_MySR_Levels_V1.mq4 |
//|                                                  Girard Matthieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Girard Matthieu"
#property link      "https://www.mql5.com"
#property version   "1.07"
#property script_show_inputs
#property indicator_chart_window
#property strict

extern string  LineHorizontal="A";              //Key to Create a SR Line (1)
extern color   LineResistcolor=clrDodgerBlue;   //Resistance Line Color (1)
extern color   LineSupportcolor=clrDarkOrange;  //Support Line Color (1)
extern ENUM_LINE_STYLE  LineStyle=STYLE_SOLID;  //Style of SR Lines (1)
extern int     Linewidth=1;                     //Choose the width of the line (1)

extern string  LineHorizontalSecond="Q";              //Key to Create a SR Line (2)
extern color   LineResistcolorSecond=clrDodgerBlue;   //Resistance Line Color (2)
extern color   LineSupportcolorSecond=clrDarkOrange;  //Support Line Color (2)
extern ENUM_LINE_STYLE  LineStyleSecond=STYLE_DOT;    //Style of SR Lines (2)
extern int     LinewidthSecond=1;                     //Choose the width of the line (2)
extern bool    TakecareManualTrendline=true;          //Take care of your Trendline added manually  

extern string  DeleteLastLine="X";              //Key to Delete Last SR Line
extern bool    AlarmCrossWhithAlert=true;       //Send an Alert
extern bool    AlarmCrossWhithPushSmartphone=false;  //Send a Notification

extern bool    MagnetLinePriceOnFullPip = true; //To make a line at 1.1500 even if the mouse is at 1.15002
extern double  DefaultLotSize=0.1;              //Lot Size to Calc Money Values
extern int     history=200;                     //Number of candles to check, could be 200 minutes or 200 weeks depending on your timeframe
extern int     MaxDeviation=10;                 //If the candle stops at less than 10 pips it will appear in the history of support and resistance
extern color   Textcolor=clrRed;                //Color of mouse position and history
extern bool    Commentornot=true;               //You can choose to see mouse and history of support/resistance in the comment or in positionable label
int              xmouse;                        //the x coordinate of the mouse
int              ymouse;                        //the y coordinate of the mouse
string           LineId="";                     //the name line
double           price =0;                      //keep the mouse price

int              minus;
double           pips;
string           linehistory="";
int              x=50;                          // axe x start
int              y=130;                         // axe y start
datetime         labelposition;                 // label position on screen
double           ratioposition=0.80;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   int i;
   string objectline;
   if(Digits==2){minus=0;}
   if(Digits==3){minus=1;}
   if(Digits==4){minus=0;}
   if(Digits==5){minus=1;}

   labelposition=Time[WindowFirstVisibleBar()/3*2];
   pips=Point;
   if(Digits==3 || Digits==5)pips*=10;

   if(!Commentornot)
     {
      RectLabelCreate(0,"KcSRc_RecMov",0,x,y,10,10,clrBlack,BORDER_FLAT,CORNER_LEFT_UPPER,Textcolor,STYLE_SOLID,3,false,true,true,0);
      // Mouse Price Position
      ObjectCreate("KcSRc_Mouse",OBJ_LABEL,0,0,0);
      ObjectSet("KcSRc_Mouse",OBJPROP_CORNER,0);
      ObjectSet("KcSRc_Mouse",OBJPROP_XDISTANCE,50);
      ObjectSet("KcSRc_Mouse",OBJPROP_YDISTANCE,140);
      // Support / Resistantce information
      ObjectCreate("KcSRc_iRSinfo",OBJ_LABEL,0,0,0);
      ObjectSet("KcSRc_iRSinfo",OBJPROP_CORNER,0);
      ObjectSet("KcSRc_iRSinfo",OBJPROP_XDISTANCE,50);
      ObjectSet("KcSRc_iRSinfo",OBJPROP_YDISTANCE,155);
      ObjectSetText("KcSRc_iRSinfo","",10,"Courier New",Textcolor);
      Comment("");
     }
   else
     {
      ObjectDelete(0,"KcSRc_iRSinfo");
      ObjectDelete(0,"KcSRc_Mouse");
      ObjectDelete(0,"KcSRc_RecMov");
     }
   for(i=ObjectsTotal() -1; i>=0; i--)
     {
      if(StringFind(ObjectName(i),"KcSR_")>-1)
        {
         objectline=ObjectName(i);
         StringReplace(objectline,"KcSR_","");
         if(StringSubstr(objectline,0,StringFind(objectline,"_"))==Symbol())
           {
            ObjectSetInteger(0,ObjectName(i),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
            if(StringFind(ObjectName(i),"_RS")>-1)
              {
               ObjectSetInteger(0,ObjectName(i),OBJPROP_SELECTABLE,true);
               ObjectSetInteger(0,ObjectName(i),OBJPROP_SELECTED,true);
              }
           }
         if(StringSubstr(objectline,0,StringFind(objectline,"_"))!=Symbol())
           {
            ObjectSetInteger(0,ObjectName(i),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS,EMPTY);
           }
        }
     }
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1);
   WindowRedraw();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   return;
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
   int i;
   string objectline;
   string result[];
   double PipGap;
   string PipGapValue;

   ObjectSet("KcSRc_Mouse",OBJPROP_XDISTANCE,ObjectGet("KcSRc_RecMov",OBJPROP_XDISTANCE));
   ObjectSet("KcSRc_Mouse",OBJPROP_YDISTANCE,ObjectGet("KcSRc_RecMov",OBJPROP_YDISTANCE)+10);
   ObjectSet("KcSRc_iRSinfo",OBJPROP_XDISTANCE,ObjectGet("KcSRc_RecMov",OBJPROP_XDISTANCE));
   ObjectSet("KcSRc_iRSinfo",OBJPROP_YDISTANCE,ObjectGet("KcSRc_RecMov",OBJPROP_YDISTANCE)+25);
//test trendline
//Print(ObjectGetValueByTime(0,"Trendline 47604",TimeCurrent()));
   for(i=ObjectsTotal() -1; i>=0; i--)
     {
      if(StringFind(ObjectName(i),"KcSR_"+Symbol())>-1)
        {
         if(StringFind(ObjectName(i),"_label")>-1)
           {
            objectline=ObjectName(i);
            StringReplace(objectline,"_label","_RS");
            ObjectMove(0,ObjectName(i),0,labelposition,ObjectGet(objectline,OBJPROP_PRICE1));
            PipGap=MathAbs(MarketInfo(Symbol(),MODE_BID)-ObjectGet(objectline,OBJPROP_PRICE1));
            ObjectSetString(0,ObjectName(i),OBJPROP_TEXT,DoubleToString(ObjectGet(objectline,OBJPROP_PRICE1),Digits)+" / "+DoubleToString(PipGap/pips,1)+" Pips");
            PipGapValue=DoubleToString(PipGap*MarketInfo(Symbol(),MODE_TICKVALUE)/MarketInfo(Symbol(),MODE_TICKSIZE)*DefaultLotSize,2);
            ObjectSetString(0,ObjectName(i),OBJPROP_TOOLTIP,DoubleToString(ObjectGet(objectline,OBJPROP_PRICE1),Digits)+" / "+DoubleToString(PipGap/pips,1)+" Pips / "+PipGapValue+" "+AccountInfoString(ACCOUNT_CURRENCY));
            ObjectSetString(0,objectline,OBJPROP_TOOLTIP,DoubleToString(ObjectGet(objectline,OBJPROP_PRICE1),Digits)+" / "+DoubleToString(PipGap/pips,1)+" Pips / "+PipGapValue+" "+AccountInfoString(ACCOUNT_CURRENCY));
           }
        }
      if(StringFind(ObjectName(i),"_RS")>-1)
        {
         if(ObjectGet(ObjectName(i),OBJPROP_PRICE1)<MarketInfo(Symbol(),MODE_BID))
           { //is support
            if(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineSupportcolor)
              { //is already support
                 }else{ //was resistance
               ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineSupportcolor);
               objectline=ObjectName(i);
               StringReplace(objectline,"_RS","_label");
               ObjectSetInteger(0,objectline,OBJPROP_COLOR,LineSupportcolor);
               if(AlarmCrossWhithAlert)
                 { //send alarm
                  StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                  Alert(result[1]+" Crossed "+DoubleToString(ObjectGet(ObjectName(i),OBJPROP_PRICE1),Digits)+" - Over");
                 }
               if(AlarmCrossWhithPushSmartphone)
                 { //send alarm
                  StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                  SendNotification(result[1]+" Crossed "+DoubleToString(ObjectGet(ObjectName(i),OBJPROP_PRICE1),Digits)+" - Over");
                 }
              }
              }else{
            if(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineResistcolor)
              { //is already resistance
                 }else{ //was support
               ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineResistcolor);
               objectline=ObjectName(i);
               StringReplace(objectline,"_RS","_label");
               ObjectSetInteger(0,objectline,OBJPROP_COLOR,LineResistcolor);
               if(AlarmCrossWhithAlert)
                 { //send alarm
                  StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                  Alert(result[1]+" Crossed "+DoubleToString(ObjectGet(ObjectName(i),OBJPROP_PRICE1),Digits)+" - Under");
                 }
               if(AlarmCrossWhithPushSmartphone)
                 { //send alarm
                  StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                  SendNotification(result[1]+" Crossed "+DoubleToString(ObjectGet(ObjectName(i),OBJPROP_PRICE1),Digits)+" - Under");
                 }
              }
           }
        }
      //Trendline
      if(TakecareManualTrendline)
        {
         if(StringFind(ObjectName(i),"Trendline")>-1)
           {
            //Print(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent()));
            if(!(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineSupportcolor) && !(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineResistcolor))
              {//just added
               if(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent())<MarketInfo(Symbol(),MODE_BID))
                 {
                  ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineSupportcolor);
                    }else{
                  ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineResistcolor);
                 }
              }
            if(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent())<MarketInfo(Symbol(),MODE_BID))
              { //is support
               if(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineSupportcolor)
                 { //is already support

                    }else{ //was resistance
                  ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineSupportcolor);
                  if(AlarmCrossWhithAlert)
                    { //send alarm
                     //StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                     Alert(Symbol()+" Crossed "+DoubleToString(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent()),Digits)+" - Over Trendline");
                    }
                  if(AlarmCrossWhithPushSmartphone)
                    { //send alarm
                     //StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                     SendNotification(Symbol()+" Crossed "+DoubleToString(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent()),Digits)+" - Over Trendline");
                    }
                 }
                 }else{
               if(ObjectGet(ObjectName(i),OBJPROP_COLOR)==LineResistcolor)
                 { //is already resistance

                    }else{ //was support
                  ObjectSetInteger(0,ObjectName(i),OBJPROP_COLOR,LineResistcolor);;
                  if(AlarmCrossWhithAlert)
                    { //send alarm
                     //StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                     Alert(Symbol()+" Crossed "+DoubleToString(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent()),Digits)+" - Under Trendline");
                    }
                  if(AlarmCrossWhithPushSmartphone)
                    { //send alarm
                     //StringSplit(ObjectName(i),StringGetCharacter("_",0),result);
                     SendNotification(Symbol()+" Crossed "+DoubleToString(ObjectGetValueByTime(0,ObjectName(i),TimeCurrent()),Digits)+" - Under Trendline");
                    }
                 }
              }
           }
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Create the horizontal line                                       |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,// chart's ID
                 const string          name="HLine_max",// line name
                 const int             sub_window=0,// subwindow index
                 double                hprice=0,// line price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0,         // priority for mouse click
                 const string          tooltip="")
  {
   ObjectDelete(chart_ID,name);
//--- reset the error value
   ResetLastError();
//--- create a horizontal line
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,hprice))
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);

   ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier  
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
   datetime dt    =0;
   double   value =0;
   int      window=0;
   int      i=1;
   int      k=1;

   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if((StringFind(sparam,"KcSR_"+Symbol())>-1))
        {
         double pricetest=ObjectGet(sparam,OBJPROP_PRICE1);
         linehistory="";
         k=1;
         int NumResist=0;
         int NumSupport=0;
         int NumCrossUp=0;
         int NumCrossDown=0;

         while(k<history)
           {
            //if(MathAbs(High[k]*multiply-pricetest*multiply)<MaxDeviation)
            if(High[k]-pricetest<MaxDeviation*pips)
              {
               NumResist++;
               //linehistory = linehistory + "Resist   at "+TimeToStr(Time[k],TIME_DATE)+" "+TimeToStr(Time[k],TIME_MINUTES)+"\n";
              }
            //if(MathAbs(Low[k]*multiply-pricetest*multiply)<20)
            if(Low[k]-pricetest<MaxDeviation*pips)
              {
               NumSupport++;
               //linehistory =  linehistory +"Support at "+TimeToStr(Time[k],TIME_DATE)+" "+TimeToStr(Time[k],TIME_MINUTES)+"\n";
              }
            if(High[k]>pricetest && Low[k]<pricetest)
              {
               if(Open[k]>Close[k])
                 {
                  NumCrossDown++;
                    }else{
                  NumCrossUp++;
                 }
              }
            k++;
           }
         linehistory="Support : "+IntegerToString(NumSupport)+" | Resist : "+IntegerToString(NumResist)+
                     " | Cross Up/Down: "+IntegerToString(NumCrossUp)+"/"+IntegerToString(NumCrossDown);
         if(!Commentornot)
           {
            ObjectSetText("KcSRc_iRSinfo",linehistory,10,"Courier New",Textcolor);
              }else{
            Comment(linehistory);
           }
        }
     }
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      if(ratioposition==0)
        {
         ratioposition=0.8;
        }
      int newbarpos = int(WindowFirstVisibleBar()*ratioposition);
      labelposition = Time[newbarpos];
     }
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      ChartXYToTimePrice(0,int(lparam),int(dparam),window,dt,price);
      xmouse = int(lparam);
      ymouse = int(dparam);
      if(MagnetLinePriceOnFullPip)
        {
         price=NormalizeDouble(price,Digits-minus);
        }
      if(!Commentornot)
        {
         ObjectSetText("KcSRc_Mouse",DoubleToString(price,Digits),10,"Courier New",Textcolor);
           }else{
         Comment(DoubleToString(price,Digits)+"\n"+linehistory);
        }
     }
   if(id==CHARTEVENT_OBJECT_DRAG)
     {
      if(StringFind(sparam,"KcSR_"+Symbol())>-1)
        {
         if(StringFind(sparam,"_label")>-1)
           {
            labelposition = datetime(ObjectGet(sparam,OBJPROP_TIME1));
            ratioposition = iBarShift(Symbol(),Period(),labelposition,false)/WindowFirstVisibleBar();
           }
        }
     }
   if(id==CHARTEVENT_KEYDOWN)
     {
      LineId=TimeToString(TimeCurrent(),TIME_DATE)+" "+TimeToString(TimeCurrent(),TIME_SECONDS);

      if(lparam==(StringGetChar(LineHorizontal,0)))
        {
         if(price>MarketInfo(Symbol(),MODE_BID))
           {
            HLineCreate(0,"KcSR_"+Symbol()+"_"+LineId+"_RS",0,price,LineResistcolor,LineStyle,Linewidth,false,true,false,0,TimeToString(TimeCurrent(),TIME_DATE));
            ObjectCreate("KcSR_"+Symbol()+"_"+LineId+"_label",OBJ_TEXT,0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectMove(0,"KcSR_"+Symbol()+"_"+LineId+"_label",0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectSetText("KcSR_"+Symbol()+"_"+LineId+"_label",+DoubleToString(price,Digits),10,"Courier New",LineResistcolor);
              }else{
            HLineCreate(0,"KcSR_"+Symbol()+"_"+LineId+"_RS",0,price,LineSupportcolor,LineStyle,Linewidth,false,true,false,0,TimeToString(TimeCurrent(),TIME_DATE));
            ObjectCreate("KcSR_"+Symbol()+"_"+LineId+"_label",OBJ_TEXT,0,Time[WindowFirstVisibleBar()/3*2],ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectMove(0,"KcSR_"+Symbol()+"_"+LineId+"_label",0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectSetText("KcSR_"+Symbol()+"_"+LineId+"_label",+DoubleToString(price,Digits),10,"Courier New",LineSupportcolor);
           }
        }
      if(lparam==(StringGetChar(LineHorizontalSecond,0)))
        {
         if(price>MarketInfo(Symbol(),MODE_BID))
           {
            HLineCreate(0,"KcSR_"+Symbol()+"_"+LineId+"_RS",0,price,LineResistcolorSecond,LineStyleSecond,LinewidthSecond,false,true,false,0,TimeToString(TimeCurrent(),TIME_DATE));
            ObjectCreate("KcSR_"+Symbol()+"_"+LineId+"_label",OBJ_TEXT,0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectMove(0,"KcSR_"+Symbol()+"_"+LineId+"_label",0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectSetText("KcSR_"+Symbol()+"_"+LineId+"_label",+DoubleToString(price,Digits),10,"Courier New",LineResistcolorSecond);
              }else{
            HLineCreate(0,"KcSR_"+Symbol()+"_"+LineId+"_RS",0,price,LineSupportcolorSecond,LineStyleSecond,LinewidthSecond,false,true,false,0,TimeToString(TimeCurrent(),TIME_DATE));
            ObjectCreate("KcSR_"+Symbol()+"_"+LineId+"_label",OBJ_TEXT,0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectMove(0,"KcSR_"+Symbol()+"_"+LineId+"_label",0,labelposition,ObjectGet("KcSR_"+Symbol()+"_"+LineId+"_RS",OBJPROP_PRICE1));
            ObjectSetText("KcSR_"+Symbol()+"_"+LineId+"_label",+DoubleToString(price,Digits),10,"Courier New",LineSupportcolorSecond);
           }
        }
      if(lparam==(StringGetChar(DeleteLastLine,0)))
        {
         bool labelerase=false;
         bool lineerase=false;
         for(i=ObjectsTotal() -1; i>=0; i--)
           {
            if(StringFind(ObjectName(i),"KcSR_"+Symbol())>-1)
              {
               if(StringFind(ObjectName(i),"_label")>-1 && !labelerase)
                 {
                  ObjectDelete(0,ObjectName(i));
                  labelerase=true;
                 }
               if(StringFind(ObjectName(i),"_RS")>-1 && !lineerase)
                 {
                  ObjectDelete(0,ObjectName(i));
                  lineerase=true;
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              xx=0,                      // X coordinate
                     const int              yy=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER cornerr=CORNER_LEFT_UPPER,// chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,cornerr);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move rectangle label                                             |
//+------------------------------------------------------------------+
bool RectLabelMove(const long   chart_ID=0,       // chart's ID
                   const string name="RectLabel", // label name
                   const int    xx=0,              // X coordinate
                   const int    yy=0)              // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the rectangle label
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
