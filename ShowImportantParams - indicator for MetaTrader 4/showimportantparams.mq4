//+------------------------------------------------------------------+
//|                                          ShowImportantParams.mq4 |
//|                               Copyright 2016, Alexey Volchanskiy |
//|                                          https://mql.gnomio.com/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2016 June 30, Alexey Volchanskiy"
#property link      "https://mql.gnomio.com/"
#property version   "1.03"
#property strict
#property description "Indicator shows important params for current symbol and account"
#property indicator_chart_window
#property indicator_buffers 0

input int       FontSize            = 10;
input color     FontColor           = clrYellow;
input string    FontName            = "Tahoma";
input int       XOffset             = 10;
input int       YOffset             = 15;
input int       SpreadSmoothTicks   = 20;

string lNames[]={"Margin4lot=","Leverage=1:","SpreadSmooth=","SpreadPrice=","StopLevel=","StopOut=","MarginCall="};

double  SpreadBuf[];
int     SpreadBufIdx=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,"SIP");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
   ArrayResize(SpreadBuf,SpreadSmoothTicks);
   for(int n=0; n<SpreadSmoothTicks; n++)
      SpreadBuf[n]=0;
   SpreadBufIdx=0;
   ObjectsDeleteAll(0,"SIP");
   Sleep(200);
   ChartRedraw();
   Sleep(200);
   for(int n=ArraySize(lNames)-1; n>=0; n--)
     {
      if(!CreateLabel("SIP_"+lNames[ArraySize(lNames)-1-n],XOffset,YOffset*n+YOffset))
         Print("CreateLabel returns false, n = ",IntegerToString(n));
     }
   Sleep(200);
   ChartRedraw();
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
   int size=ArraySize(SpreadBuf);
   SpreadBuf[SpreadBufIdx++]=Ask-Bid;
   if(SpreadBufIdx >= SpreadSmoothTicks)
      SpreadBufIdx = 0;
   double sprd=0;
   for(int n = 0; n < SpreadSmoothTicks; n++)
      sprd += SpreadBuf[n];
   sprd/=(double)SpreadSmoothTicks;
   ResetLastError();

   double price4lot;
   Quote2Price(sprd,price4lot,Symbol());

   ObjectSetString(0,"SIP_"+lNames[0],OBJPROP_TEXT,lNames[0]+DoubleToString(MarketInfo(Symbol(),MODE_MARGINREQUIRED),2));
   ObjectSetString(0,"SIP_"+lNames[1],OBJPROP_TEXT,lNames[1]+IntegerToString(AccountLeverage()));
   ObjectSetString(0,"SIP_"+lNames[2],OBJPROP_TEXT,lNames[2]+DoubleToString(sprd,_Digits) + ",  RealSpread=" + DoubleToString(Ask - Bid,_Digits));
   ObjectSetString(0,"SIP_"+lNames[3],OBJPROP_TEXT,lNames[3]+DoubleToString(price4lot,2));
   ObjectSetString(0,"SIP_"+lNames[4],OBJPROP_TEXT,lNames[4]+DoubleToString(MarketInfo(Symbol(),MODE_STOPLEVEL),0));

   ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode=(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
   string s=(stop_out_mode==ACCOUNT_STOPOUT_MODE_PERCENT)?" %":"";
   ObjectSetString(0,"SIP_"+lNames[5],OBJPROP_TEXT,lNames[5]+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO),0)+s);
   ObjectSetString(0,"SIP_"+lNames[6],OBJPROP_TEXT,lNames[6]+DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL),0)+s);
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Quote2Price(double diff,double &price4lot,string symbol="EURUSD")
  {
   int dig=(int)MarketInfo(symbol,MODE_DIGITS);
   if(dig == 0)
      return(false); // symbol is none
   double tickSize = MarketInfo(symbol, MODE_TICKSIZE);   // пункт в валюте котировки (0,00001 для EURUSD на 5-знаке) 
   double tickValue = MarketInfo(symbol, MODE_TICKVALUE); // пункт в валюте депозита ($1 для EURUSD на 5-знаке)
   double price=diff/(tickSize/tickValue);
   price4lot=NormalizeDouble(price,2);
   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CreateLabel(string name,int x,int y=10)
  {
   if(!ObjectCreate(0,name,OBJ_LABEL,0,0,0))
      return false;;
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
   ObjectSetInteger(0,name,OBJPROP_COLOR,FontColor);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);
   ObjectSetString(0,name,OBJPROP_FONT,FontName);
   ChartRedraw();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {

  }
//+------------------------------------------------------------------+
