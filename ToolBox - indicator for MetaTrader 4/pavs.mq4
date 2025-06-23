//+---------------------------------------------------------------------------------+
//|                                                                        PAVS.mq4 |
//|  Pip Value                                                                      |
//|  Pip Average in the last 20 10 and 5 period                                     |
//|  How much you can win in the period                                             |
//|  Spread & Poucentage of spread in Pip average of a the period & Price of spread |
//|                                                                                 |
//|  Use Change as you like...                                                      |
//+---------------------------------------------------------------------------------+
#property copyright "Girard Matthieu"
#property link      "https://www.mql5.com"
#property version   "1.02"
#property script_show_inputs
#property indicator_chart_window
#property strict

extern double LotSize=0.1;             //Your Lot Size
extern color labelcolor=clrWhite;      //Text Color
bool ExcludeSundayData=true;

extern bool ActiveRangeLine=true;      //Active range line
extern color LineColor=clrWhite;       //Color of line range

extern bool ActiveTakeProfitETA=false; //Estimate the ETA of your trade

double     PipValue=0.0001;
static int adr0,adr1,adr5,adr10,adr20;
double pricelineH,pricelineL,PipValues;
int corner=0;
int orderarray[20]; // limit too 20 simultanious order :)
int toucharray[20]; // limit too 20 simultanious order :)
color            InpBackColor=Black;     // Background color
ENUM_BORDER_TYPE InpBorder=BORDER_FLAT;       // Border type
ENUM_BASE_CORNER InpCorner=CORNER_LEFT_UPPER; // Chart corner for anchoring

ENUM_LINE_STYLE  InpStyle=STYLE_SOLID;        // Flat border style (Flat)
int              InpLineWidth=3;              // Flat border width (Flat)
bool             InpBack=false;               // Background object
bool             InpSelection=true;           // Highlight to move
bool             InpHidden=true;              // Hidden in the object list
long             InpZOrder=0;                 // Priority for mouse click
int              minus;
int              divide;
double           MousePrice;
string           countdown;
double point;
string inside;
int x=50;                       // axe x start
int y=130;                      // axe y start
int PeriodChoose;
bool autoperiod=true;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   point=Point;
   if((Digits==3) || (Digits==5))
     {
      point*=10;
     }
   if(Digits==2 || Digits==3) PipValue=PipValue*100;
   if(Digits== 4 || Digits == 5) PipValue = PipValue;

   if(Digits==2){minus=0;divide=1;}
   if(Digits==3){minus=1;divide=10;}
   if(Digits==4){minus=0;divide=1;}
   if(Digits==5){minus=1;divide=10;}
//---
   RectLabelCreate(0,"RecMov",0,x,y,10,10,InpBackColor,InpBorder,InpCorner,
                   labelcolor,InpStyle,InpLineWidth,InpBack,InpSelection,InpHidden,InpZOrder);

   if(GlobalVariableCheck("Period_G1"))
      PeriodChoose=int(GlobalVariableGet("Period_G1"));

   if(GlobalVariableCheck("Lot_G1"))
      LotSize=GlobalVariableGet("Lot_G1");

   if(GlobalVariableCheck("LotAuto_G1"))
      autoperiod=GlobalVariableGet("LotAuto_G1");
   if(autoperiod)
     {
      PeriodChoose=Period();
     }
// Default lot & Default leverage 
   ObjectCreate("Label_Lot_Lev",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Lot_Lev",OBJPROP_CORNER,corner);
   ObjectSet("Label_Lot_Lev",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Lot_Lev",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+10);
   ObjectSetString(0,"Label_Lot_Lev",OBJPROP_TOOLTIP,"Default Lot Size / Period Countdown / Position of the mouse (price)");
// Lot button + 
   ButtonCreate(0,"LotSizeButtonPlus",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)+110),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+12),10,10,0,"+","Arial",10,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"LotSizeButtonPlus",OBJPROP_TOOLTIP,"Use can use 'P' key instead");
// Lot button - 
   ButtonCreate(0,"LotSizeButtonMinus",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)+120),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+12),10,10,0,"-","Arial",10,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"LotSizeButtonMinus",OBJPROP_TOOLTIP,"Use can use 'M' key instead");
// M1 button
   ButtonCreate(0,"M1Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+10),25,15,0,"M1","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"M1Button",OBJPROP_TOOLTIP,"Choose 1 Minute period");
// M5 button
   ButtonCreate(0,"M5Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+25),25,15,0,"M5","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"M5Button",OBJPROP_TOOLTIP,"Choose 5 Minutes period");
// M15 button
   ButtonCreate(0,"M15Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+40),25,15,0,"M15","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"M15Button",OBJPROP_TOOLTIP,"Choose 15 Minutes period");
// M30 button
   ButtonCreate(0,"M30Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+55),25,15,0,"M30","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"M30Button",OBJPROP_TOOLTIP,"Choose 30 Minutes period");
// H1 button
   ButtonCreate(0,"H1Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+70),25,15,0,"H1","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"H1Button",OBJPROP_TOOLTIP,"Choose 1 Hour period");
// H4 button
   ButtonCreate(0,"H4Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+85),25,15,0,"H4","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"H4Button",OBJPROP_TOOLTIP,"Choose 4 Hours period");
// D1 button
   ButtonCreate(0,"D1Button",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+100),25,15,0,"D1","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"D1Button",OBJPROP_TOOLTIP,"Choose 1 Day period");
// W1 button
//ButtonCreate(0,"W1Button",0,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25,ObjectGet("RecMov",OBJPROP_YDISTANCE)+115,25,15,0,"W1","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
//ObjectSetString(0,"W1Button",OBJPROP_TOOLTIP,"Choose 1 Week period");
// MN button
   ButtonCreate(0,"MNButton",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+130),25,15,0,"MN","Arial",8,clrBlack,C'236,233,216',clrNONE,false,false,false,false,0);
   ObjectSetString(0,"MNButton",OBJPROP_TOOLTIP,"Choose 1 Month period");
// Auto button
   ButtonCreate(0,"AutoButton",0,int(ObjectGet("RecMov",OBJPROP_XDISTANCE)-25),int(ObjectGet("RecMov",OBJPROP_YDISTANCE)+145),25,15,0,"A","Arial",8,clrGreen,C'236,233,216',clrNONE,True,false,false,false,0);
   ObjectSetString(0,"AutoButton",OBJPROP_TOOLTIP,"Choose use the actual period");
// PipValue
   ObjectCreate("Label_PipVal",OBJ_LABEL,0,0,0);
   ObjectSet("Label_PipVal",OBJPROP_CORNER,corner);
   ObjectSet("Label_PipVal",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_PipVal",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+25);
   ObjectSetString(0,"Label_PipVal",OBJPROP_TOOLTIP,"Pip Value / ATR / Swap Buy / Swap Sell");
// average pips for 1 day for the last 20 days
   ObjectCreate("Label_Av20",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Av20",OBJPROP_CORNER,corner);
   ObjectSet("Label_Av20",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av20",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+40);
   ObjectSetString(0,"Label_Av20",OBJPROP_TOOLTIP,"Average Pip in the last 20 candles / Value of this average");
// average pips for 1 day for the last 10 days
   ObjectCreate("Label_Av10",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Av10",OBJPROP_CORNER,corner);
   ObjectSet("Label_Av10",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av10",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+55);
   ObjectSetString(0,"Label_Av10",OBJPROP_TOOLTIP,"Average Pip in the last 10 candles / Value of this average");
// average pips for 1 day for the last 5 days
   ObjectCreate("Label_Av5",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Av5",OBJPROP_CORNER,corner);
   ObjectSet("Label_Av5",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av5",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+70);
   ObjectSetString(0,"Label_Av5",OBJPROP_TOOLTIP,"Average Pip in the last 5 candles / Value of this average");
// average pips for 1 day for the day
   ObjectCreate("Label_Av1",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Av1",OBJPROP_CORNER,corner);
   ObjectSet("Label_Av1",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av1",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+85);
   ObjectSetString(0,"Label_Av1",OBJPROP_TOOLTIP,"Average Pip in this candles / Value of this average");
// Spread & % of Av5 & amount
   ObjectCreate("Label_Spr_pour",OBJ_LABEL,0,0,0);
   ObjectSet("Label_Spr_pour",OBJPROP_CORNER,corner);
   ObjectSet("Label_Spr_pour",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Spr_pour",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+100);
   ObjectSetString(0,"Label_Spr_pour",OBJPROP_TOOLTIP,"Spread in Pips / % of the average / Value of the spread");
// What i can win
   ObjectCreate("Label_win",OBJ_LABEL,0,0,0);
   ObjectSet("Label_win",OBJPROP_CORNER,corner);
   ObjectSet("Label_win",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_win",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+115);
   ObjectSetString(0,"Label_win",OBJPROP_TOOLTIP,"Value between the click mouse position and the actual price / the same in Pips / the price clicked");
// What i can win
   ObjectCreate("Label_inf",OBJ_LABEL,0,0,0);
   ObjectSet("Label_inf",OBJPROP_CORNER,corner);
   ObjectSet("Label_inf",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_inf",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+130);
   ObjectSetText("Label_inf","",10,"Courier New",labelcolor);
   ObjectSetString(0,"Label_inf",OBJPROP_TOOLTIP,"Pips between Open and Close / Pips between High and Low / Date and time");
//---
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1);
   ArrayInitialize(orderarray,0);
   ArrayInitialize(toucharray,0);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   GlobalVariableSet("Period_G1",PeriodChoose);
   GlobalVariableSet("Lot_G1",LotSize);
   GlobalVariableSet("LotAuto_G1",autoperiod);
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
   int        Periodvalue=PeriodChoose;
   double    swaplong,swapshort;
   string DepositCurrency=AccountInfoString(ACCOUNT_CURRENCY);
   PipValues=(((MarketInfo(Symbol(),MODE_TICKVALUE)*point)/MarketInfo(Symbol(),MODE_TICKSIZE))*LotSize);
   double PerATR=iATR(NULL,Periodvalue,20,0);
//swap
   swaplong=NormalizeDouble(MarketInfo(Symbol(),18),2);
   swapshort=NormalizeDouble(MarketInfo(Symbol(),19),2);
//timer next candle
   int timenow,second,minute,hour;

   timenow=(int) time[0]+PeriodSeconds() -(int) TimeCurrent();

   second=timenow%60;
   minute=(timenow-second);
   if(minute!=0)
     {
      minute=minute/60;
     }
   minute=minute -(minute-minute%60);

   hour=(timenow-second-minute*60);
   if(hour!=0)
     {
      hour=hour/60;
     }
   if(hour!=0)
     {
      hour=hour/60;
     }
   countdown=IntegerToString(hour,2,'0')+":"+IntegerToString(minute,2,'0')+":"+IntegerToString(second,2,'0');

   ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
   ObjectSetText("Label_PipVal","Pip/Atr/swp : "+DoubleToStr(PipValues,3)+" "+DepositCurrency+" / "+DoubleToString(PerATR,Digits-minus)+" / SwB "+DoubleToString(swaplong,2)+" / SwS "+DoubleToString(swapshort,2),10,"Courier New",labelcolor);
   int        n=1;

//move object on rectangle coordonate
   if(!ObjectGet("RecMov",OBJPROP_XDISTANCE))
     {
      RectLabelCreate(0,"RecMov",0,x,y,10,10,InpBackColor,InpBorder,InpCorner,
                      labelcolor,InpStyle,InpLineWidth,InpBack,InpSelection,InpHidden,InpZOrder);
     }
   ObjectSet("Label_Lot_Lev",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Lot_Lev",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+10);
   ObjectSet("LotSizeButtonPlus",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)+110);
   ObjectSet("LotSizeButtonPlus",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+12);
   ObjectSet("LotSizeButtonMinus",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)+120);
   ObjectSet("LotSizeButtonMinus",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+12);
   ObjectSet("M1Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("M1Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+10);
   ObjectSet("M5Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("M5Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+25);
   ObjectSet("M15Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("M15Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+40);
   ObjectSet("M30Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("M30Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+55);
   ObjectSet("H1Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("H1Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+70);
   ObjectSet("H4Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("H4Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+85);
   ObjectSet("D1Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("D1Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+100);
   ObjectSet("W1Button",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("W1Button",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+115);
   ObjectSet("MNButton",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("MNButton",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+130);
   ObjectSet("AutoButton",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE)-25);
   ObjectSet("AutoButton",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+145);
   ObjectSet("Label_PipVal",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_PipVal",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+25);
   ObjectSet("Label_Av20",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av20",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+40);
   ObjectSet("Label_Av10",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av10",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+55);
   ObjectSet("Label_Av5",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av5",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+70);
   ObjectSet("Label_Av1",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Av1",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+85);
   ObjectSet("Label_Spr_pour",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_Spr_pour",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+100);
   ObjectSet("Label_win",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_win",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+115);
   ObjectSet("Label_inf",OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
   ObjectSet("Label_inf",OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+130);

   int        LastBars0=0;
   double     Daily_Range=0.0;

   int        Bars0=Bars;
   double     ADR5_High=0;
   double     ADR5_Low=0;
   double     ADR10_High=0;
   double     ADR10_Low=0;
   double     ADR20_High=0;
   double     ADR20_Low=0;
   double     TakeADay=0;
   string     periodtext="";
   string     nowtext="";
   if(Periodvalue==1)
     {
      periodtext=" M1";
      nowtext=" This M1";
     }
   if(Periodvalue==5)
     {
      periodtext=" M5";
      nowtext=" This M5";
     }
   if(Periodvalue==15)
     {
      periodtext="M15";
      nowtext="This M15";
     }
   if(Periodvalue==30)
     {
      periodtext="M30";
      nowtext="This M30";
     }
   if(Periodvalue==60)
     {
      periodtext=" H1";
      nowtext=" This H1";
     }
   if(Periodvalue==240)
     {
      periodtext=" H4";
      nowtext=" This H4";
     }
   if(Periodvalue==1440)
     {
      periodtext=" D1";
      nowtext="   Today";
     }
   if(Periodvalue==10080)
     {
      periodtext=" W1";
      nowtext=" This W1";
     }
   if(Periodvalue==43200)
     {
      periodtext="MN1";
      nowtext="This MN1";
     }

   if(Bars0>LastBars0)
     {
      //loop periods
      for(int i=1;i<=20;i++)
        {
         while(ExcludeSundayData && TimeDayOfWeek(iTime(Symbol(),Periodvalue,n))==0) n++;
         Daily_Range=Daily_Range+(iHigh(Symbol(),Periodvalue,n)-iLow(Symbol(),Periodvalue,n))/PipValue;
         if(i==1)  adr1 =int(MathRound(Daily_Range));
         if(i==5)  adr5 =int(MathRound(Daily_Range/5));
         if(i==10) adr10=int(MathRound(Daily_Range/10));
         if(i==20) adr20=int(MathRound(Daily_Range/20));
         n++;
        }
      adr0=int((iHigh(Symbol(),Periodvalue,0)-iLow(Symbol(),Periodvalue,0))/PipValue);
      ObjectSetText("Label_Av20","     20 "+periodtext+" : "+string(adr20)+" Pips / "+DoubleToString(adr20*PipValues,2)+" "+DepositCurrency,10,"Courier New",labelcolor);
      ObjectSetText("Label_Av10","     10 "+periodtext+" : "+string(adr10)+" Pips / "+DoubleToString(adr10*PipValues,2)+" "+DepositCurrency,10,"Courier New",labelcolor);
      ObjectSetText("Label_Av5","      5 "+periodtext+" : "+string(adr5)+" Pips / "+DoubleToString(adr5*PipValues,2)+" "+DepositCurrency,10,"Courier New",labelcolor);
      ObjectSetText("Label_Av1","   "+nowtext+" : "+string(adr0)+" Pips / "+DoubleToString(adr0*PipValues,2)+" "+DepositCurrency,10,"Courier New",labelcolor);
      LastBars0=Bars0;
     }
   string SpreadPipValue=DoubleToString((MarketInfo(Symbol(),MODE_SPREAD)/divide)*PipValues,2);
   ObjectSetText("Label_Spr_pour","     Spread : "+DoubleToString(MarketInfo(Symbol(),MODE_SPREAD)/divide,1)+" Pips / "+DoubleToStr(((MarketInfo(Symbol(),MODE_SPREAD)/divide)/(MathRound(Daily_Range/20)))*100,2)+"% / "+SpreadPipValue+" "+DepositCurrency,10,"Courier New",labelcolor);
//line
   if(ActiveRangeLine)
     {
      pricelineH=iLow(Symbol(),Periodvalue,0) + (adr5 * PipValue);
      pricelineL=iHigh(Symbol(),Periodvalue,0) - (adr5 * PipValue);
      if((pricelineH-pricelineL)<(adr5*PipValue))
        {
         pricelineL = (pricelineL + ((pricelineH-pricelineL)/2)) - (adr5 * PipValue/2);
         pricelineH = pricelineL + (adr5 * PipValue);
        }
      PerATR=iATR(NULL,Periodvalue,5,0)*1.7;
      double DOWNSL=MarketInfo(Symbol(),MODE_BID)-PerATR;
      double UPSL=MarketInfo(Symbol(),MODE_ASK)+PerATR;
      HLineCreate(ChartID(),"HLine_max",0,pricelineH,LineColor,STYLE_DASH,1,false,false,false,0,"top of the range");
      HLineCreate(ChartID(),"HLine_min",0,pricelineL,LineColor,STYLE_DASH,1,false,false,false,0,"bottom of the range");
      //HLineCreate(ChartID(),"SULine_min",0,UPSL,clrOrange,STYLE_DOT,1,false,false,true,0,"Stop Loss");
      //HLineCreate(ChartID(),"SDLine_min",0,DOWNSL,clrOrange,STYLE_DOT,1,false,false,true,0,"Stop Loss");
     }

   if(ActiveTakeProfitETA)
     {
      int total;
      total=OrdersTotal();
      string information="";
      double Pipgap;
      double atm;
      string stratm,timeleft;
      double dadr5;
      //int second;
      int days,hours,minutes;
      int orderset=0;
      int possibleindex=-1;
      int orderindex=200;

      for(int pos=0;pos<total;pos++)
        {
         if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY)
              {
               if(OrderTakeProfit()>0)
                 {
                  Pipgap=(OrderTakeProfit()-MarketInfo(Symbol(),MODE_BID))/PipValue;
                    }else{
                  Pipgap=0;
                 }
               dadr5=adr5; //(iClose(Symbol(),Periodvalue,0)-iOpen(Symbol(),Periodvalue,5))/PipValue;//
               atm=Pipgap/(dadr5/PeriodChoose)*60; //give the atm in seconds to get to the takeprofit
               stratm=TimeToStr(TimeLocal()+int(MathRound(atm)),TIME_DATE|TIME_SECONDS);

               second=int(MathRound(atm));
               days=second/(1440*60);
               second= second -(days*(1440*60));
               hours = second/(60*60);
               second= second -(hours*(60*60));
               minutes= second/60;
               second = second -(minutes*60);
               timeleft=string(days)+"d ";
               if(hours<10)
                 {
                  timeleft=timeleft+"0"+string(hours);
                    }else{
                  timeleft=timeleft+string(hours);
                 }
               if(minutes<10)
                 {
                  timeleft=timeleft+":0"+string(minutes);
                    }else{
                  timeleft=timeleft+":"+string(minutes);
                 }
               if(second<10)
                 {
                  timeleft=timeleft+":0"+string(second);
                    }else{
                  timeleft=timeleft+":"+string(second);
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(OrderTakeProfit()>0)
                 {
                  Pipgap=(MarketInfo(Symbol(),MODE_ASK)-OrderTakeProfit())/PipValue;
                    }else{
                  Pipgap=0;
                 }
               dadr5=adr5;
               atm=Pipgap/(dadr5/PeriodChoose)*60; //give the eta in seconds to get to the takeprofit
               stratm=TimeToStr(TimeLocal()+int(MathRound(atm)),TIME_DATE|TIME_SECONDS);

               second=int(atm);
               days=second/(1440*60);
               second= second -(days*(1440*60));
               hours = second/(60*60);
               second= second -(hours*(60*60));
               minutes= second/60;
               second = second -(minutes*60);
               timeleft=string(days)+"d ";
               if(hours<10)
                 {
                  timeleft=timeleft+"0"+string(hours);
                    }else{
                  timeleft=timeleft+string(hours);
                 }
               if(minutes<10)
                 {
                  timeleft=timeleft+":0"+string(minutes);
                    }else{
                  timeleft=timeleft+":"+string(minutes);
                 }
               if(second<10)
                 {
                  timeleft=timeleft+":0"+string(second);
                    }else{
                  timeleft=timeleft+":"+string(second);
                 }
              }
            if(OrderTakeProfit()>0)
              {
               // ETA 
               ObjectCreate("Label_eta"+string(pos),OBJ_LABEL,0,0,0);
               ObjectSet("Label_eta"+string(pos),OBJPROP_CORNER,corner);
               ObjectSet("Label_eta"+string(pos),OBJPROP_XDISTANCE,ObjectGet("RecMov",OBJPROP_XDISTANCE));
               ObjectSet("Label_eta"+string(pos),OBJPROP_YDISTANCE,ObjectGet("RecMov",OBJPROP_YDISTANCE)+((pos*15)+145));
               ObjectSetText("Label_eta"+string(pos),"   Ticket:"+string(OrderTicket())+" TP ETA "+stratm+" Pip left "+string(Pipgap),10,"Courier New",labelcolor);
              }
           }
        }
     }
   for(int posi=OrdersTotal(); posi<15; posi++)
     {
      ObjectDelete(0,"Label_eta"+string(posi));
     }
   WindowRedraw();
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Create the horizontal line                                       |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,// chart's ID
                 const string          name="HLine_max",// line name
                 const int             sub_window=0,      // subwindow index
                 double                price=0,           // line price
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
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
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
   double   price =0;
   double   value =0;
   int      window=0;
   int      pipclick;
   int      shift;

   if(id==CHARTEVENT_CLICK)
     {
      ChartXYToTimePrice(0,int(lparam),int(dparam),window,dt,price);
      if(price>MarketInfo(Symbol(),MODE_ASK))
        {
         value=PipValues*((price/PipValue) -(MarketInfo(Symbol(),MODE_ASK)/PipValue));
         pipclick=int((price/PipValue) -(MarketInfo(Symbol(),MODE_ASK)/PipValue));
           }else{
         value=PipValues*((MarketInfo(Symbol(),MODE_BID)/PipValue) -(price/PipValue));
         pipclick=int((MarketInfo(Symbol(),MODE_BID)/PipValue) -(price/PipValue));
        }
      ObjectSetText("Label_win","      Click : "+DoubleToString(value,2)+" "+AccountInfoString(ACCOUNT_CURRENCY)+" / "+string(pipclick)+" Pips / "+DoubleToString(price,Digits),10,"Courier New",labelcolor);
     }

   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam=="LotSizeButtonPlus")
        {
         LotSize=LotSize+0.01;
         ObjectSetInteger(0,sparam,OBJPROP_STATE,False);
         ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
        }
      if(sparam=="LotSizeButtonMinus")
        {
         LotSize=LotSize-0.01;
         ObjectSetInteger(0,sparam,OBJPROP_STATE,False);
         ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
        }
      if(sparam=="M1Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_M1;
         autoperiod=false;
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="M5Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_M5;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="M15Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_M15;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="M30Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_M30;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="H1Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_H1;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="H4Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_H4;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="D1Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_D1;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="W1Button")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_W1;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="MNButton")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=PERIOD_MN1;
         autoperiod=false;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"AutoButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"AutoButton",OBJPROP_STATE,false);
        }
      if(sparam=="AutoButton")
        {
         ObjectSetInteger(0,sparam,OBJPROP_COLOR,clrGreen);
         PeriodChoose=Period();
         autoperiod=true;
         ObjectSetInteger(0,"M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M5Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M15Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"M30Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"H4Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"D1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"W1Button",OBJPROP_STATE,false);
         ObjectSetInteger(0,"MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"MNButton",OBJPROP_STATE,false);
        }
     }

   if(id==CHARTEVENT_KEYDOWN)
     {
      if(lparam==(StringGetChar("P",0)))
        {
         LotSize=LotSize+0.01;
         ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
        }
      if(lparam==(StringGetChar("M",0)))
        {
         LotSize=LotSize-0.01;
         ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
        }
     }

   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      ChartXYToTimePrice(0,int(lparam),int(dparam),window,dt,price);
      shift=iBarShift(Symbol(),Period(),dt);
      ObjectSetText("Label_inf","    OC / HL : "+DoubleToString(MathAbs((iOpen(Symbol(),Period(),shift)-iClose(Symbol(),Period(),shift))/PipValue),1)+"Pips / "+DoubleToString(MathAbs((iHigh(Symbol(),Period(),shift)-iLow(Symbol(),Period(),shift))/PipValue),1)+" Pips / "+TimeToStr(dt,TIME_DATE|TIME_SECONDS),10,"Courier New",labelcolor);
      MousePrice=NormalizeDouble(price,Digits);
      ObjectSetText("Label_Lot_Lev","   Lot/Time :     "+DoubleToStr(LotSize,2)+" /  "+countdown+" / "+string(MousePrice),10,"Courier New",labelcolor);
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
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               xx=0,                      // X coordinate
                  const int               yy=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  cornerr=CORNER_LEFT_UPPER,// chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,cornerr);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
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
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,// chart's ID
                const string name="Button",// button name
                const int    xx=0,           // X coordinate
                const int    yy=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the button
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
