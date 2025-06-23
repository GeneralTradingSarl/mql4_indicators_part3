//+------------------------------------------------------------------+
//|                                                 rsi extreme zone |
//+------------------------------------------------------------------+
//#property icon "logo2022.ico"
#property copyright "ChertAutoTrading"
#property link "https://www.mql5.com/en/users/alexchert/seller#products"
#property version   "1.0"
#property strict
#property indicator_separate_window

#property indicator_buffers 5
#property indicator_color1 clrLightSteelBlue
#property indicator_width1 1
#property indicator_color2 clrRed
#property indicator_width2 2
#property indicator_color3 clrBlue
#property indicator_width3 2
#property indicator_color4 clrGreen
#property indicator_width4 0
#property indicator_color5 clrDarkOrange
#property indicator_width5 0


extern string note1; //[] ||||||||||||||||||||||||||||||||||
extern int countBack=200;
extern bool useAlert=false;
extern string alert="RSI Alert";
extern string note2; //[] Indicator Settings
extern int rsiPeriod=14;
extern int levelUp=70;
extern int levelDown=30;
extern string note3; //[] ||||||||||||||||||||||||||||||||||
extern int upArrowCode=233;
extern int downArrowCode=234;
extern int arrowDistance=10;

int prevCalculated;

double drawRsi[];
double drawUpLevel[];
double drawDownLevel[];
double drawRsiUpLevel[];
double drawRsiDownLevel[];
double arrowUp[];
double arrowDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,drawRsi);
   SetIndexStyle(0,DRAW_LINE);
   
   SetIndexBuffer(1,drawRsiUpLevel);
   SetIndexStyle(1,DRAW_LINE);
   
   SetIndexBuffer(2,drawRsiDownLevel);
   SetIndexStyle(2,DRAW_LINE);
   
   SetIndexBuffer(3,arrowUp);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,upArrowCode);
   
   SetIndexBuffer(4,arrowDown);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,downArrowCode);

   
   IndicatorSetDouble(INDICATOR_MINIMUM,0);
   IndicatorSetDouble(INDICATOR_MAXIMUM,100);
   
   IndicatorSetInteger(INDICATOR_LEVELS,2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,levelDown);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,levelUp);

  
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                           deinit                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll();   
  }
//+------------------------------------------------------------------+
//+-------------------------on calculate-----------------------------+
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
   prevCalculated=prev_calculated;
   
   rsiCalculations();
  
   return rates_total-1;
  }
//+------------------------------------------------------------------+
void rsiCalculations()
  {
   for(int i = Bars-1-MathMax(countBack, prevCalculated); i >= 0; --i)
   {
    double rsi=iRSI(NULL,0,rsiPeriod,PRICE_CLOSE,i);
    double rsi2=iRSI(NULL,0,rsiPeriod,PRICE_CLOSE,i+1);
        
    if(rsi<levelUp)
    if(rsi>levelDown)
    drawRsi[i]=rsi;
    
    if(rsi>levelUp)
    drawRsiUpLevel[i]=rsi;
    
    if(rsi<levelDown)
    drawRsiDownLevel[i]=rsi;
    
    if(rsi>levelUp)
    if(rsi2<levelUp)
    drawRsiUpLevel[i+1]=rsi2;

    if(rsi<levelDown)
    if(rsi2>levelDown)
     drawRsiDownLevel[i+1]=rsi2;
    
    if(rsi<levelUp)
    if(rsi2>levelUp)
    {
     drawRsi[i+1]=rsi2;
     arrowDown[i]=rsi2+arrowDistance;
     if(useAlert==true)Alert(alert);
    }

    if(rsi>levelDown)
    if(rsi2<levelDown)
    {
     drawRsi[i+1]=rsi2;
     arrowUp[i]=rsi2-arrowDistance;
     if(useAlert==true)Alert(alert);
    }

   }
   
  }
//+------------------------------------------------------------------+
