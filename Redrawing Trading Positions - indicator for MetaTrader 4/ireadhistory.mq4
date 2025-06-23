//+------------------------------------------------------------------+
//|                                                 iReadHistory.mq4 |
//|                                      Copyright 2021, SignalForex |
//|                                           https://SignalForex.id |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, SignalForex"
#property link      "https://SignalForex.id"
#property version   "1.00"
#property description "iReadHistory _________________"
#property description "Information of Developing EA"
#property description "    https://telegram.me/codeMQL"
#property description "    WebSite: https://signalforex.id/"
#property description "    email:support@signalforex.id"

#property strict
#property indicator_chart_window


enum enumFontSize{
   eFS6,   //Size 6
   eFS8,   //Size 8
   eFS9,   //Size 9
   eFS10,   //Size 10
   eFS11,   //Size 11
   eFS12,   //Size 12
   eFS14,   //Size 14
   eFS16,   //Size 16
};


double      P_MyPoint, P_MySpread;
int         P_MyDigit;
input       int         P_MagicNum     = 0; //Magic Number
input       int         P_MaxRecords   = 500;    //Max History Records

input    string   strDisplay = "_________________________________";             //---------- <<< .:: Notification ::. >>> ----------
input    int      IN_PosX        = 10;       //coordinate X
input    int      IN_PosY        = 35;       //coordinate Y
input    enumFontSize   IN_FontSize    = eFS8;       //Font Size
input    color    IN_FontColor         = clrGold;     //Font Color
input    int      IN_DistanceText      = 5;          //Text Distance
input    bool     IN_IsShowTimeLeft    = true;        //Show Candle's Time Left 


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   InitPair(Symbol());

   DrawAllHistoryOrders();
   
   
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   //ObjectsDeleteAll(0);
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
   static int day = DayOfYear();
   if (day != DayOfYear()){
      DrawAllHistoryOrders();
      day   = DayOfYear();
   }
   
   DrawAllOrderOnTrades();
   
   InfoAccount();
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+




void InitPair(string pair){
   string SIMBOL = pair;
   StringToUpper(SIMBOL);
   P_MyDigit = (int) MarketInfo(SIMBOL, MODE_DIGITS);
   double   point = MarketInfo(SIMBOL, MODE_POINT);
   if ( ((P_MyDigit % 2) == 1 ) || (StringFind(SIMBOL, "GOLD",0) >= 0)) P_MyPoint = 10 * point;
   else P_MyPoint = point;
   
   P_MySpread  = MarketInfo(SIMBOL, MODE_SPREAD);
   
   
}

void DrawAllHistoryOrders(){
   ObjectsDeleteAll(0);
   double hargaOP = 0.0, hargaClose = 0.0, lot= 0.0;
   datetime WktOP, WktClose;
   int orderType = -1;
   int tOrder = OrdersHistoryTotal();
   
   for (int i=tOrder-1; i>=0 && i>=tOrder-P_MaxRecords; i--){
      bool hrsSelect = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
      string strMN = IntegerToString(OrderMagicNumber());
      if (StringFind(OrderSymbol(), Symbol(), 0) == 0 && (StringFind(strMN, IntegerToString(P_MagicNum), 0) == 0 )){
         hargaOP  = OrderOpenPrice();
         hargaClose = OrderClosePrice();
         WktOP    = OrderOpenTime();
         WktClose = OrderCloseTime();
         orderType = OrderType();
         lot      = OrderLots();
         
         if (StringLen(strMN) == StringLen(IntegerToString(P_MagicNum))){
            DrawHistoryOrder(IntegerToString(i), orderType, WktOP, hargaOP, WktClose, hargaClose, lot, false);
         }else{
            DrawHistoryOrder(IntegerToString(i), orderType, WktOP, hargaOP, WktClose, hargaClose, lot, true);
         }
      }
      //}
   }
}

void DrawAllOrderOnTrades(){
   double hargaOP = 0.0, lot= 0.0;
   datetime WktOP;
   int orderType = -1;
   int tOrder = 0;
   tOrder = OrdersTotal();
   for (int i=0; i<tOrder; i++){
      bool hrsSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      string strMN = IntegerToString(OrderMagicNumber());
      if (StringFind(OrderSymbol(), Symbol(), 0) == 0 && (StringFind(strMN, IntegerToString(P_MagicNum), 0) == 0 ) ){
         hargaOP  = OrderOpenPrice();
         WktOP    = OrderOpenTime();
         orderType = OrderType();
         lot      = OrderLots();
         
         DrawOrderOnTrades("OnT" + IntegerToString(i), orderType, WktOP, hargaOP, lot);
      }
   }
}

void DrawOrderOnTrades(string idHist, int orderType, datetime WktOP, double hargaOP, double lot){
   int warnaOP = clrRed; //, warnaClose=clrMagenta, warnaTrend=clrDeepPink;
   double profit = (hargaOP - Ask)/P_MyPoint;
   
   if (orderType == OP_BUY){
      warnaOP = clrRoyalBlue;
      //warnaClose = clrAqua;
      //warnaTrend = clrSpringGreen;
      profit = (Bid - hargaOP)/P_MyPoint;
   }
   
   DrawArrow(idHist+"o", WktOP, hargaOP, warnaOP, "OPEN", GetOrderTypeName(orderType) + "\n" + DoubleToStr(hargaOP, 5) +"\nLot :"+DoubleToStr(lot,2) + "\nP/L: " + DoubleToStr(profit,0) + "pips");
   
}

void DrawHistoryOrder(string idHist, int orderType, datetime WktOP, double hargaOP, datetime WktClose, double hargaClose, double lot, bool isHedge){
   int warnaOP = clrRed, warnaClose=clrMagenta, warnaTrend=clrDeepPink;
   double profit = (hargaOP - hargaClose)/P_MyPoint;
   
   if (orderType == OP_BUY){
      warnaOP = clrRoyalBlue;
      warnaClose = clrAqua;
      warnaTrend = clrSpringGreen;
      profit = profit * -1;
   }
   
   DrawArrow(idHist+"o", WktOP, hargaOP, warnaOP, "OPEN", GetOrderTypeName(orderType) + "\n" + DoubleToStr(hargaOP, 5) +"\nLot :"+DoubleToStr(lot,2) + "\nP/L: " + DoubleToStr(profit,0) + "pips", isHedge);
   DrawTLine(idHist, WktOP, hargaOP, WktClose, hargaClose, warnaTrend); 
   DrawArrow(idHist+"c", WktClose, hargaClose, warnaClose, "CLOSE", "Closed " +GetOrderTypeName(orderType)+ "\n"+DoubleToStr(hargaClose, 5) +"\nLot :"+DoubleToStr(lot,2) + "\nP/L: " + DoubleToStr(profit,0) + "pips",isHedge);
   
}

void DrawTLine(string idLine, datetime x1, double y1, datetime x2, double y2, color warna=clrMagenta, int width=1, bool rayRight = false){
   string name="tLn-";
   
   name += idLine;
   if (ObjectFind(0, name) < 0){
      ObjectCreate(0,name,OBJ_TREND,0,x1, y1, x2, y2);
   }
   
   //--- set line color 
   ObjectSetInteger(0,name,OBJPROP_COLOR, warna); 
   //--- set line display style 
   ObjectSetInteger(0,name,OBJPROP_STYLE, STYLE_DOT); 
   //--- set line width 
   ObjectSetInteger(0,name,OBJPROP_WIDTH, width);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT, rayRight);
   
   ObjectMove(0, name, 0, x1, y1);
   ObjectMove(0, name, 1, x2, y2);
   //string   tooltip;
   //tooltip  = "Price : " + DoubleToStr(y, Digits);
   //ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);

   
}

void DrawArrow(string txtID, datetime x, double y, color warna, string arrType="OPEN", string tooltips="", bool isHedge = false){
   long chart_ID=0;
   string name;
   name  = txtID;
   if (ObjectFind(chart_ID, name) < 0){
      ObjectCreate(chart_ID,name,OBJ_ARROW_RIGHT_PRICE,0,x,y);
   }
   
   ObjectMove(chart_ID, name, 0, x, y);
   int   arrowCode = 216;
   if (isHedge){
      if (arrType == "OPEN"){
         arrowCode = 220;
      }else{
         arrowCode = 164;
      }
   }else{
      if (arrType == "OPEN"){
         arrowCode = 216;
      }else{
         arrowCode = 251;
      }
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrowCode);    // Set the arrow code 
   
//--- set a sign color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,warna); 
//--- set the border line style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- set the sign size 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,1); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 
   ObjectSetString (chart_ID, name, OBJPROP_TOOLTIP, tooltips);
   
}

void DrawArrowPrice(string txtID, datetime x, double y, color warna, string tooltip=""){
   long chart_ID=0;
   string name;
   name  = txtID;
   if (ObjectFind(chart_ID, name) < 0){
      ObjectCreate(chart_ID,name,OBJ_ARROW_LEFT_PRICE,0,x,y);
   }
   
   ObjectMove(chart_ID, name, 0, x, y);
//--- set a sign color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,warna); 
//--- set the border line style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- set the sign size 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,1); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 
   ObjectSetString (chart_ID, name, OBJPROP_TOOLTIP, tooltip);
}


string GetOrderTypeName(int orderType){
   string name = "";
   switch (orderType){
      case 0:  name = "OP_BUY"; break;
      case 1:  name = "OP_SELL"; break;
      case 2:  name = "OP_BUYLIMIT"; break;
      case 3:  name = "OP_SELLLIMIT"; break;
      case 4:  name = "OP_BUYSTOP"; break;
      case 5:  name = "OP_SELLSTOP"; break;
      default : name = "No Signal"; break;
   }
   return name;
}



int GetFontSize(){
   int fontSize = 10;
   switch (IN_FontSize){
      case eFS6  : fontSize = 6; break;
      case eFS8  : fontSize = 8; break;
      case eFS9  : fontSize = 9; break;
      case eFS10  : fontSize = 10; break;
      case eFS11  : fontSize = 11; break;
      case eFS12  : fontSize = 12; break;
      case eFS14  : fontSize = 14; break;
      case eFS16  : fontSize = 16; break;
   }
   
   return (fontSize);
}


void InfoAccount(){
   int   x, y;
   int fontSize   = 10;
   
   string   pair  = Symbol();
   
   double   profit=0.0;
   double   tProfitBuy=0, tProfitSell=0;
   double   tVolBuy=0, tVolSell=0;
   int      tOrderBuy=0, tOrderSell=0, tOrderBS = 0, tOrderSS = 0, tOrderBL= 0, tOrderSL=0;
   double   tSwap = 0.0, tCommission = 0.0;
   
   int tOrders;
   tOrders = OrdersTotal();
   for(int i=tOrders-1; i>=0; i--){
      bool result = OrderSelect(i, SELECT_BY_POS);
      if (StringFind(IntegerToString(OrderMagicNumber()), IntegerToString(P_MagicNum)) == 0){
         profit += OrderProfit() + OrderSwap() + OrderCommission();
         if (OrderType() == OP_BUY){
            tProfitBuy += OrderProfit() + OrderSwap() + OrderCommission();
            tVolBuy   += OrderLots();
            tOrderBuy++;
            tSwap += OrderSwap(); tCommission += OrderCommission();
         }
         
         if (OrderType() == OP_SELL){
            tProfitSell += OrderProfit() + OrderSwap() + OrderCommission();
            tVolSell   += OrderLots();
            tOrderSell++;
            tSwap += OrderSwap(); tCommission += OrderCommission();
         }
         
         if (OrderType() == OP_BUYSTOP) tOrderBS++;
         if (OrderType() == OP_SELLSTOP) tOrderSS++;
         if (OrderType() == OP_BUYLIMIT) tOrderBL++;
         if (OrderType() == OP_SELLLIMIT) tOrderSL++;
         

      }
   }
   
   string font = "Arial";
   x  = IN_PosX;
   y  = IN_PosY;
   int   DisY = 0;
   fontSize = GetFontSize(); 
   DisY  = (int) (IN_DistanceText + (fontSize * 1.1));
   
   
   y += DisY; SetLabel("lbrAccNumber", "Account Number : " + IntegerToString(AccountNumber()), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrAccName", "Account Owner : " + AccountName(), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   
   y += DisY; SetLabel("lbrAccBalance", "Account Balance : " + DoubleToStr(AccountBalance(), 2), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrAccEquity", "Account Equity : " + DoubleToStr(AccountEquity(), 2), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrAccPL", "Profit/Loss : " + DoubleToStr((tProfitBuy+tProfitSell), 2), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrAccFreeMargin", "Free Margin : " + DoubleToStr(AccountFreeMargin(), 2), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrAccMarginUsage", "Margin Usage % : " + DoubleToStr(AccountMargin(), 2), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrCurrSpread", "Current Spread : " + DoubleToStr(P_MySpread, 0) + " point", x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrTOrder", "BUY : " + IntegerToString(tOrderBuy) + " SELL : " + IntegerToString(tOrderSell), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrTPOStop", "BuyStop : " + IntegerToString(tOrderBS) + " SellStop : " + IntegerToString(tOrderSS), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrTPOLimit", "BuyLimit : " + IntegerToString(tOrderBL) + " SellLimit : " + IntegerToString(tOrderSL), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrTimeServer", "Server Time : " + TimeToStr(TimeCurrent(), TIME_SECONDS), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrTimeLocal", "Local Time : " + TimeToStr(TimeLocal(), TIME_SECONDS), x, y, IN_FontColor, font, fontSize, CORNER_RIGHT_UPPER);
   y += DisY; SetLabel("lbrCopyRight", "SignalForex", x, y, clrWhite, font, fontSize, CORNER_RIGHT_UPPER);
   
   
   if (IN_IsShowTimeLeft){
      string TimeLeft="  " + StringSubstr(TimeToStr(Time[0]+Period()*60-TimeCurrent(),TIME_MINUTES|TIME_SECONDS), 3, 5);
      long   chartScale = ChartGetInteger(0,CHART_SCALE,0);
      SetText("elpTime", TimeLeft,  Time[0], Bid, clrWhite, "Lucida Sans Typewriter", 6);
   }
   
   
   
}



//+------------------------------------------------------------------+
//| SetLabel                                                         |
//+------------------------------------------------------------------+
void SetLabel(string label, string text, int x, int y, color clr, string FontName = "Arial",int FontSize = 8, int typeCorner = CORNER_LEFT_UPPER)
{
   string labelIndicator = "SFx-" + label;   
   if (ObjectFind(labelIndicator) == -1)
   {
      ObjectCreate(labelIndicator, OBJ_LABEL, 0, 0, 0);
   }
   
   ObjectSet(labelIndicator, OBJPROP_CORNER, typeCorner);
   ObjectSet(labelIndicator, OBJPROP_XDISTANCE, x);
   ObjectSet(labelIndicator, OBJPROP_YDISTANCE, y);
   ObjectSetText(labelIndicator, text, FontSize, FontName, clr);
  
}  


//+------------------------------------------------------------------+
//| SetText                                                         |
//+------------------------------------------------------------------+
void SetText(string txtID, string text, datetime x, double y, color clr=clrWhite, string FontName = "Arial",int FontSize = 8)
{
   string name = "SFx-" + txtID;   
   if (ObjectFind(name) == -1)
   {
      ObjectCreate(name, OBJ_TEXT, 0, 0, 0);
   }
   
   //--- set the text 
   ObjectSetString(0,name,OBJPROP_TEXT,text); 
   
   //--- set text font 
   ObjectSetString(0,name,OBJPROP_FONT,FontName); 
   
   //--- set font size 
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
   
   //Posisi Text
   ObjectMove(0,name,0, x, y);
   
   //--- set color 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(0,name,OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER); 
    
  
}  


