//+------------------------------------------------------------------+
//|                                                StochPosition.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "https://www.mql5.com/en/users/3rjfx. ~ By 3rjfx ~ Created: 14/05/2016"
#property link      "http://www.mql5.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "1.00"
#property strict
//---
#property description "StochPosition indicator is an indicator for MT4 base on Stochastic Indicator,"
#property description "which shows the position and direction of Stochastic in M5 timeframe up to W1 timeframe."
#property description "In addition, StochPosition indicator also provide direction and advice to BUY or SELL,"
#property description "and every change of direction and advice is also provided alerts."
//---
#property indicator_separate_window
//--
extern int               K_Period = 5; // K Line Period
extern int               D_Period = 3; // D Line Period
extern int                Slowing = 3; // Slowing 
extern ENUM_MA_METHOD   MA_Method = MODE_SMA; // MA Method
extern ENUM_STO_PRICE Price_Field = 0; // Price Field 0 = Low/High or 1 = Close/Close)
extern double            Distance = 5.2; // Distance between Main / Signal
extern color            Arrow_Up  = clrBlue; // Arrow Up Color
extern color           Arrow_Down = clrRed; // Arrow Down Color
extern color        Arrow_SideWay = clrYellow; // Arrow Side Way Color
extern color            TextColor = clrSnow; // Field Text Color
extern color    TimeZoneTextColor = clrGreenYellow; // Time Zone Text Color
extern color     TextBUYSELLColor = clrYellow; // Suggest Buy or Sell Text Color
extern bool           SoundAlerts = true;
extern bool           MsgAlerts   = true;
extern bool           eMailAlerts = false;
extern string      SoundAlertFile = "alert.wav";
//---
//--
//--- spacing
int scaleX=60,scaleY=25,scaleYt=18,offsetX=260,offsetY=5; // coordinate
//--- timeframes arrays
int TF[]={PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1};
int avg=6;
int tfx=7;
int tfa=8;
int stocup;
int stocdn;
//--
//--
string TimeFrames[] = {"  M5  "," M15   "," M30   ","  H1  ","  H4  ","  D1  ","  W1  "," AVG "}; // Header Text Timeframes
string FieldLabel[] = {"TIMEFRAMES","DIRECTION","MAIN","SIGNAL"}; // Indicator labels
int lbl=4;
int cal;
int pal;
int cmnt;
int pmnt;
int corner=0;
//--
long chart_id;
string sname;
string avmt,avst;
string alBase,alSubj,alMsg;
//--
//-------//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
//---- indicators
   //--
   chart_id=ChartID();
   pal=10;
   //--
   string param="Sto("+IntegerToString(K_Period)+","+IntegerToString(D_Period)+","+IntegerToString(Slowing)+")";
   sname="StochPosition("+_Symbol+","+param+","+strTF(_Period)+")";
   IndicatorShortName(sname);
   //--
//----
   return(INIT_SUCCEEDED);
  }
//-------//
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
//----
void OnDeinit(const int reason)
  {
//----
    //--
    ObjectsDeleteAll();
    GlobalVariablesDeleteAll(); 
//----
   return;
  }
//-------//
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//----
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
//----
    ResetLastError();
    RefreshRates();
    //--
    cal=0;
    int x=0;
    int y=0;
    int v=0;
    int av=0;
    int ms=0;
    int stup=0;
    int stdn=0;
    //---
    string hr=StringSubstr(TimeToStr(TimeCurrent(),TIME_MINUTES),0,2);
    string mi=StringSubstr(TimeToStr(TimeCurrent(),TIME_MINUTES),3,2);
    string sc=StringSubstr(TimeToStr(TimeCurrent(),TIME_SECONDS),6,2);
    string tztxt;
    int tcurr=TimeHour(TimeCurrent()); // Server Time == GMT+2 == (05:00 AM WIB-Jakarta Time)
    if(tcurr==23) {tztxt="NYC/NZD";} // 04 WIB -> (23+5-24= 04:00 AM WIB -> Server Time + 5 Hours = WIB or Jakarta Time)
    if(tcurr==0) {tztxt="NZD";}  // 05 WIB
    if(tcurr==1) {tztxt="NZD/AUS";} // 06 WIB
    if(tcurr>=2 && tcurr<=4) {tztxt="NZD/AUS/TOK";} // 07 -> <= 09 WIB
    if(tcurr>=5 && tcurr<=8) {tztxt="AUS/TOK";} // 10 -> <= 13 WIB
    if(tcurr>=9 && tcurr<=10) {tztxt="AUS/TOK/LON";} // 14 -> <= 15 WIB
    if(tcurr>=11 && tcurr<=13) {tztxt="LON";}  // 16 -> <= 18 WIB
    if(tcurr>=14 && tcurr<=18) {tztxt="LON/NYC";} // 19 -> <= 23 WIB
    if(tcurr>=19 && tcurr<=22) {tztxt="NYC";} // 24(00) -> <= 03 WIB
    //---
    //--- create timeframe text labels 
    for(x=0; x<tfa; x++)
       {
         ObjectCreate(chart_id,"stcTF"+string(x),OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"stcTF"+string(x),OBJPROP_TEXT,TimeFrames[x]);
         ObjectSetString(chart_id,"stcTF"+string(x),OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"stcTF"+string(x),OBJPROP_FONTSIZE,10);
         ObjectSetInteger(chart_id,"stcTF"+string(x),OBJPROP_COLOR,TextColor);
         ObjectSetInteger(chart_id,"stcTF"+string(x),OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"stcTF"+string(x),OBJPROP_XDISTANCE,x*scaleX+offsetX); 
         ObjectSetInteger(chart_id,"stcTF"+string(x),OBJPROP_YDISTANCE,y*scaleY+offsetY+12);
       }
    //--- create indicator labels time zone
    ObjectCreate(chart_id,"txTime"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
    ObjectSetString(chart_id,"txTime"+"y"+"0",OBJPROP_TEXT,"H:"+hr);
    ObjectSetString(chart_id,"txTime"+"y"+"0",OBJPROP_FONT,"Arial Bold");
    ObjectSetInteger(chart_id,"txTime"+"y"+"0",OBJPROP_FONTSIZE,11);
    ObjectSetInteger(chart_id,"txTime"+"y"+"0",OBJPROP_COLOR,TimeZoneTextColor);
    ObjectSetInteger(chart_id,"txTime"+"y"+"0",OBJPROP_CORNER,corner);
    ObjectSetInteger(chart_id,"txTime"+"y"+"0",OBJPROP_XDISTANCE,offsetX-235); 
    ObjectSetInteger(chart_id,"txTime"+"y"+"0",OBJPROP_YDISTANCE,offsetY+29); //0*scaleYt+offsetY+29
    //--
    ObjectCreate(chart_id,"txTime"+"y"+"1",OBJ_LABEL,WindowFind(sname),0,0);
    ObjectSetString(chart_id,"txTime"+"y"+"1",OBJPROP_TEXT,"M:"+mi);
    ObjectSetString(chart_id,"txTime"+"y"+"1",OBJPROP_FONT,"Arial Bold");
    ObjectSetInteger(chart_id,"txTime"+"y"+"1",OBJPROP_FONTSIZE,11);
    ObjectSetInteger(chart_id,"txTime"+"y"+"1",OBJPROP_COLOR,TimeZoneTextColor);
    ObjectSetInteger(chart_id,"txTime"+"y"+"1",OBJPROP_CORNER,corner);
    ObjectSetInteger(chart_id,"txTime"+"y"+"1",OBJPROP_XDISTANCE,offsetX-237); 
    ObjectSetInteger(chart_id,"txTime"+"y"+"1",OBJPROP_YDISTANCE,scaleYt+offsetY+29);
    //--
    ObjectCreate(chart_id,"txTime"+"y"+"2",OBJ_LABEL,WindowFind(sname),0,0);
    ObjectSetString(chart_id,"txTime"+"y"+"2",OBJPROP_TEXT,"S:"+sc);
    ObjectSetString(chart_id,"txTime"+"y"+"2",OBJPROP_FONT,"Arial Bold");
    ObjectSetInteger(chart_id,"txTime"+"y"+"2",OBJPROP_FONTSIZE,11);
    ObjectSetInteger(chart_id,"txTime"+"y"+"2",OBJPROP_COLOR,TimeZoneTextColor);
    ObjectSetInteger(chart_id,"txTime"+"y"+"2",OBJPROP_CORNER,corner);
    ObjectSetInteger(chart_id,"txTime"+"y"+"2",OBJPROP_XDISTANCE,offsetX-234); 
    ObjectSetInteger(chart_id,"txTime"+"y"+"2",OBJPROP_YDISTANCE,2*scaleYt+offsetY+29);
    //--
    ObjectCreate(chart_id,"txTime"+"y"+"3",OBJ_LABEL,WindowFind(sname),0,0);
    ObjectSetString(chart_id,"txTime"+"y"+"3",OBJPROP_TEXT,"TIMEZONE: "+tztxt);
    ObjectSetString(chart_id,"txTime"+"y"+"3",OBJPROP_FONT,"Arial Bold");
    ObjectSetInteger(chart_id,"txTime"+"y"+"3",OBJPROP_FONTSIZE,8);
    ObjectSetInteger(chart_id,"txTime"+"y"+"3",OBJPROP_COLOR,TimeZoneTextColor);
    ObjectSetInteger(chart_id,"txTime"+"y"+"3",OBJPROP_CORNER,corner);
    ObjectSetInteger(chart_id,"txTime"+"y"+"3",OBJPROP_XDISTANCE,offsetX-248); 
    ObjectSetInteger(chart_id,"txTime"+"y"+"3",OBJPROP_YDISTANCE,3*scaleYt+offsetY+33);
    //--
    //--- create indicator text field
    for(y=0; y<lbl; y++)
       {
         ObjectCreate(chart_id,"stcFld"+string(y),OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"stcFld"+string(y),OBJPROP_TEXT,FieldLabel[y]);
         ObjectSetString(chart_id,"stcFld"+string(y),OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"stcFld"+string(y),OBJPROP_FONTSIZE,8);
         ObjectSetInteger(chart_id,"stcFld"+string(y),OBJPROP_COLOR,TextColor);
         ObjectSetInteger(chart_id,"stcFld"+string(y),OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"stcFld"+string(y),OBJPROP_XDISTANCE,20+offsetX-120); 
         ObjectSetInteger(chart_id,"stcFld"+string(y),OBJPROP_YDISTANCE,y*scaleY+offsetY+13);
       }
    //--
    //--- create Stoch arrows direction
    for(x=0; x<tfx; x++)
       {
         ObjectDelete("arrStoch"+string(x)+string(1));
         //--
         if((iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0)>
            iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,1))&&
            (iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0)>
            iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_SIGNAL,0)))
           {
             ObjectCreate(chart_id,"arrStoch"+string(x)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_TEXT,CharToStr(236));
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONT,"Wingdings");
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONTSIZE,15);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_COLOR,Arrow_Up);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_CORNER,corner);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_XDISTANCE,x*scaleX+offsetX+10); 
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
             stup++;
           }
         else if((iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0)<
                 iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,1))&&
                 (iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0)<
                 iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_SIGNAL,0)))
           {
             ObjectCreate(chart_id,"arrStoch"+string(x)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_TEXT,CharToStr(238));
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONT,"Wingdings");
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONTSIZE,15);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_COLOR,Arrow_Down);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_CORNER,corner);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_XDISTANCE,x*scaleX+offsetX+10); 
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
             stdn++;
           }
         else
           {
             ObjectCreate(chart_id,"arrStoch"+string(x)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_TEXT,CharToStr(232));
             ObjectSetString(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONT,"Wingdings");
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_FONTSIZE,15);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_COLOR,Arrow_SideWay);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_CORNER,corner);
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_XDISTANCE,x*scaleX+offsetX+10); 
             ObjectSetInteger(chart_id,"arrStoch"+string(x)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
           }
       }
    //-- 
    double avgm=0.0;
    double agm1=0.0;
    double avgs=0.0;
    double avm=0.0;
    double am1=0.0;
    double avs=0.0;
    int am=0;
    int as=0;
    //---> create Stoch Main Level Position
    for(x=0,am=1; x<tfx; x++,am++)
       {
         ObjectDelete("arrStochM"+string(x)+string(1));
         double mpos=iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0);
         avm +=iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0);
         am1 +=iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,1);
         agm1=NormalizeDouble(am1/tfx,0);
         avgm=NormalizeDouble(avm/tfx,0);
         avmt=DoubleToStr(avgm,0);
         string mtxt=DoubleToStr(mpos,0);
         //--
         ObjectCreate(chart_id,"arrStochM"+string(x)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_TEXT,mtxt);
         ObjectSetString(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_FONTSIZE,9);
         ObjectSetInteger(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_COLOR,TextColor);
         ObjectSetInteger(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_XDISTANCE,x*scaleX+offsetX+10); 
         ObjectSetInteger(chart_id,"arrStochM"+string(x)+string(1),OBJPROP_YDISTANCE,2*scaleY+offsetY+13);
         //--
         if(am==tfx)
           {
             ObjectCreate(chart_id,"arrStochM"+string(am)+string(1+am),OBJ_LABEL,WindowFind(sname),0,0);
             ObjectSetString(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_TEXT,avmt);
             ObjectSetString(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_FONT,"Bodoni MT Black");
             ObjectSetInteger(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_FONTSIZE,9);
             ObjectSetInteger(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_COLOR,TextColor);
             ObjectSetInteger(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_CORNER,corner);
             ObjectSetInteger(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_XDISTANCE,am*scaleX+offsetX+10); 
             ObjectSetInteger(chart_id,"arrStochM"+string(am)+string(1+am),OBJPROP_YDISTANCE,2*scaleY+offsetY+13);
           }
         //--
       }
    //--
    //---> create Stoch Signal Level Position
    for(x=0,as=1; x<tfx; x++,as++)
       {
         ObjectDelete("arrStochS"+string(x)+string(1));
         double spos=iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_SIGNAL,0);
         avs +=iStochastic(_Symbol,TF[x],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_SIGNAL,0);
         avgs=NormalizeDouble(avs/tfx,0);
         avst=DoubleToStr(avgs,0);
         string stxt=DoubleToStr(spos,0);
         //--
         ObjectCreate(chart_id,"arrStochS"+string(x)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_TEXT,stxt);
         ObjectSetString(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_FONTSIZE,9);
         ObjectSetInteger(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_COLOR,TextColor);
         ObjectSetInteger(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_XDISTANCE,x*scaleX+offsetX+10); 
         ObjectSetInteger(chart_id,"arrStochS"+string(x)+string(1),OBJPROP_YDISTANCE,3*scaleY+offsetY+13);
         //--
         if(as==tfx)
           {
             ObjectCreate(chart_id,"arrStochS"+string(as)+string(1+as),OBJ_LABEL,WindowFind(sname),0,0);
             ObjectSetString(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_TEXT,avst);
             ObjectSetString(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_FONT,"Bodoni MT Black");
             ObjectSetInteger(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_FONTSIZE,9);
             ObjectSetInteger(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_COLOR,TextColor);
             ObjectSetInteger(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_CORNER,corner);
             ObjectSetInteger(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_XDISTANCE,as*scaleX+offsetX+10); 
             ObjectSetInteger(chart_id,"arrStochS"+string(as)+string(1+as),OBJPROP_YDISTANCE,3*scaleY+offsetY+13);
           }
         //--
       }
    //--
    ObjectDelete("arrStoch"+string(am)+string(1));
    if((avgm>agm1)&&(avgm>avgs))
      {
        ObjectCreate(chart_id,"arrStoch"+string(am)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_TEXT,CharToStr(236));
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONT,"Wingdings");
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONTSIZE,15);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_COLOR,Arrow_Up);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_CORNER,corner);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_XDISTANCE,tfx*scaleX+offsetX+10); 
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
      }
    else if((avgm<agm1)&&(avgm<avgs))
      {
        ObjectCreate(chart_id,"arrStoch"+string(am)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_TEXT,CharToStr(238));
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONT,"Wingdings");
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONTSIZE,15);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_COLOR,Arrow_Down);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_CORNER,corner);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_XDISTANCE,tfx*scaleX+offsetX+10); 
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
      }
    else
      {
        ObjectCreate(chart_id,"arrStoch"+string(am)+string(1),OBJ_LABEL,WindowFind(sname),0,0);
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_TEXT,CharToStr(232));
        ObjectSetString(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONT,"Wingdings");
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_FONTSIZE,15);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_COLOR,Arrow_SideWay);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_CORNER,corner);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_XDISTANCE,tfx*scaleX+offsetX+10);
        ObjectSetInteger(chart_id,"arrStoch"+string(am)+string(1),OBJPROP_YDISTANCE,1*scaleY+offsetY+10);
      }
    //--
    //--- create indicator arrow trend consideration
    RefreshRates();
    ObjectDelete("arrDir"+"y"+"0");
    ObjectDelete("arrDir"+"y"+"0"+"a");
    ObjectDelete("arrDir"+"y"+"0"+"a"+"1");
    //--
    double sm0=0.0;
    double sm1=0.0;
    double ss0=0.0;
    //--
    for(v=0,av=0; v<avg; v++,av++)
      {
        sm0 +=iStochastic(_Symbol,TF[v],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,0);
        sm1 +=iStochastic(_Symbol,TF[v],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_MAIN,1);
        ss0 +=iStochastic(_Symbol,TF[v],K_Period,D_Period,Slowing,MA_Method,Price_Field,MODE_SIGNAL,0);
      }
    //--
    double avm0=NormalizeDouble(sm0/av,_Digits);
    double avm1=NormalizeDouble(sm1/av,_Digits);
    double avs0=NormalizeDouble(ss0/av,_Digits);
    //---
    if((avm0>avm1)&&(avm0>avs0)&&(avm0>avs0+Distance))
       {
         //--
         stocup=1;
         stocdn=0;
         cal=1;
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_TEXT,CharToStr(164));
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_FONTSIZE,27);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_COLOR,Arrow_Up);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_XDISTANCE,offsetX-172);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_YDISTANCE,1*scaleYt+offsetY+19);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_TEXT,CharToStr(217));
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONTSIZE,18);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_COLOR,Arrow_Up);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_XDISTANCE,offsetX-166); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_YDISTANCE,1*scaleYt+offsetY+7);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_TEXT,"BUY");
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONTSIZE,8);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_COLOR,TextBUYSELLColor);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_XDISTANCE,offsetX-168); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_YDISTANCE,1*scaleYt+offsetY+51);
       }
    //---
    else if((avm0<avm1)&&(avm0<avs0)&&(avm0<avs0-Distance))
       {
         //--
         stocdn=1;
         stocup=0;
         cal=-1;
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_TEXT,CharToStr(164));
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_FONTSIZE,27);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_COLOR,Arrow_Down);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_XDISTANCE,offsetX-172); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_YDISTANCE,1*scaleYt+offsetY+19);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_TEXT,CharToStr(218));
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONTSIZE,18);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_COLOR,Arrow_Down);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_XDISTANCE,offsetX-167); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_YDISTANCE,1*scaleYt+offsetY+41);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_TEXT,"SELL");
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONTSIZE,8);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_COLOR,TextBUYSELLColor);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_XDISTANCE,offsetX-170); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_YDISTANCE,1*scaleYt+offsetY+9);
       }
    //---
    else if((stocup==1)&&(stup>=4))
       {
         //--
         stocup=1;
         stocdn=0;
         cal=1;
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_TEXT,CharToStr(164));
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_FONTSIZE,27);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_COLOR,Arrow_Up);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_XDISTANCE,offsetX-172);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_YDISTANCE,1*scaleYt+offsetY+19);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_TEXT,CharToStr(217));
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONTSIZE,18);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_COLOR,Arrow_Up);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_XDISTANCE,offsetX-166); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_YDISTANCE,1*scaleYt+offsetY+7);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_TEXT,"BUY");
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONTSIZE,8);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_COLOR,TextBUYSELLColor);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_XDISTANCE,offsetX-168); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_YDISTANCE,1*scaleYt+offsetY+51);
       }
    //---
    else if((stocdn==1)&&(stdn>=4))
       {
         //--
         stocdn=1;
         stocup=0;
         cal=-1;
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_TEXT,CharToStr(164));
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_FONTSIZE,27);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_COLOR,Arrow_Down);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_XDISTANCE,offsetX-172); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_YDISTANCE,1*scaleYt+offsetY+19);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_TEXT,CharToStr(218));
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_FONTSIZE,18);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_COLOR,Arrow_Down);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_XDISTANCE,offsetX-167); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a",OBJPROP_YDISTANCE,1*scaleYt+offsetY+41);
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_TEXT,"SELL");
         ObjectSetString(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONT,"Bodoni MT Black");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_FONTSIZE,8);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_COLOR,TextBUYSELLColor);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_XDISTANCE,offsetX-170); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0"+"a"+"1",OBJPROP_YDISTANCE,1*scaleYt+offsetY+9);
       }
    //---
    else
       {
         //--
         stocdn=0;
         stocup=0;
         cal=0;
         //--
         ObjectCreate(chart_id,"arrDir"+"y"+"0",OBJ_LABEL,WindowFind(sname),0,0);
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_TEXT,CharToStr(164));
         ObjectSetString(chart_id,"arrDir"+"y"+"0",OBJPROP_FONT,"Wingdings");
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_FONTSIZE,27);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_COLOR,TextBUYSELLColor);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_CORNER,corner);
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_XDISTANCE,offsetX-172); 
         ObjectSetInteger(chart_id,"arrDir"+"y"+"0",OBJPROP_YDISTANCE,1*scaleYt+offsetY+19);
       }
    //---
    ChartRedraw(0);
    Sleep(500);
    RefreshRates();
    st_alerts(cal);
    //----
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//-------//

string strTF(int period)
  {
   string periodcur;
   switch(period)
     {
       //--
       case PERIOD_M1: periodcur="M1"; break;
       case PERIOD_M5: periodcur="M5"; break;
       case PERIOD_M15: periodcur="M15"; break;
       case PERIOD_M30: periodcur="M30"; break;
       case PERIOD_H1: periodcur="H1"; break;
       case PERIOD_H4: periodcur="H4"; break;
       case PERIOD_D1: periodcur="D1"; break;
       case PERIOD_W1: periodcur="W1"; break;
       case PERIOD_MN1: periodcur="MN"; break;
       //--
     }
   //--
   return(periodcur);
  }  
//-------//

void Do_Alerts(string msgText,string eMailSub)
  {
    //--
    if(MsgAlerts) Alert(msgText);
    if(SoundAlerts) PlaySound(SoundAlertFile);
    if(eMailAlerts) SendMail(eMailSub,msgText);
    //--
  }
//-------//

void st_alerts(int alert)
   {
     //--
     cmnt=(int)Minute();
     if(cmnt!=pmnt)
       {
         //---
         //--
         if((cal!=pal)&&(alert==1))
            {     
              alBase="*"+WindowExpertName()+": "+_Symbol+", TF: "+strTF(_Period)+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
              alSubj=alBase+". The Price Goes Up,";
              alMsg=alSubj+" Action: BUY.!!";
              pmnt=cmnt;
              pal=cal;
              Do_Alerts(alMsg,alSubj);
            }
         //--
         if((cal!=pal)&&(alert==-1))
            {     
              alBase="*"+WindowExpertName()+": "+_Symbol+", TF: "+strTF(_Period)+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
              alSubj=alBase+". The Price Goes Down,";
              alMsg=alSubj+" Action: SELL.!!";
              pmnt=cmnt;
              pal=cal;
              Do_Alerts(alMsg,alSubj);
            }
         //--
         if((cal!=pal)&&(alert==0))
            {     
              alBase="*"+WindowExpertName()+": "+_Symbol+", TF: "+strTF(_Period)+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
              alSubj=alBase+". Find Direction,";
              alMsg=alSubj+" Action: WAIT.!!";
              pmnt=cmnt;
              pal=cal;
              Do_Alerts(alMsg,alSubj);
            }
         //---
       }
     //--
     return;
     //--
   //----
   } //-end st_alerts()
//-------//
//+------------------------------------------------------------------+