#property copyright "Copyright @ 2012, File45"
#property indicator_chart_window 
//thanks: mladen-super moderator FOREX-TSD www.forex-tsd.com who's edits on a previous project provided a template for further endevours. 
//http://www.forex-tsd.com/expert-advisors-metatrader-4/20171-please-fix-indicator-ea-34.html#post425056

// SL+TP-CP PIP DIST INDI - v2

// USERS CAN PERMANENTLY CHANGE THE DEFAULT SETTINGS BY MODIFYING THE BELOW CODE - EXAMPLES PROVIDED.
// * * * * * REMEBER TO COMPILE AND CHECK FOR ERRORS AFTER EVERY MODIFICAION * * * * * 

extern string PIPS_or_FRACTIONAL_PIPS = "fractional pips = points / 3 & 5 digit pricing";
extern bool   Fractional_Pips  = true; // Modification examples: = false;
extern string HIDE_OPTIONS;
extern bool   Hide_Order_Text = false;
extern bool   Hide_OrderTicket = false;
extern bool   Hide_SL_TP_Price = false;
extern bool   Hide_Pip_Text = false;
extern bool   Hide_SL = false;
extern bool   Hide_TP = false;
extern bool   Hide_Limit_and_Stop_Orders = false;
extern bool   Hide_OE_Price = false;
extern bool   Hide_OE = false;
extern string COSMETICS;
extern string L_neg_100___to___R_pos_20; // = "- - neg left / pos right + +";
extern int Shift_Text_Left_or_Right = 13; // Modification examples: = 10;  = 20; 
extern color  SL_Color = Magenta; // Modification examples: = Red; = Orange;  
extern color  TP_Color = LimeGreen;
extern bool   Use_OE_Color = false;
extern color  OE_Color = Gold; 
extern int    SL_TP_Font_Size = 10;
extern int    OE_Font_Size = 8;
extern string FontName = "Arial"; // Modification examples: = "Verdana"; 

// * * * * * DO NOT MODIFY BEYOND THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING * * * * * --------------------+

// CHANGE_ORDER_TEXT;
// Set_at_Max_8_Characters;
// BUY_ORDERS; 
string Buy_TP = "Buy-TP"; // Modification examples: = "Buy"; = B-TP"; 
string Buy_SL = "Buy-SL";
string Buy_Limit_TP = "BL-TP";
string Buy_Limit_SL = "BL-ST"; // Modification examples: = "BuyLimit"; = "B-Limit"; = "B/Limit"
string Buy_Stop_TP = "BS-TP";
string Buy_Stop_SL = "BS-SL";
// SELL_ORDERS;
string Sell_SL = "Sell-SL";
string Sell_TP = "Sell-TP";
string Sell_Limit_SL = "SL-SL";
string Sell_Limit_TP = "SL-TP";
string Sell_Stop_SL = "SS-TP";
string Sell_Stop_TP = "SS-TP";
// ORDER EXECUTION
string Buy_Limit_OE = "BL-OE";
string Buy_Stop_OE = "BS-OE";
string Sell_Limit_OE = "SL-OE";
string Sell_Stop_OE = "SS-OE";

string Increase_Max_Characters;
int xx = 8;

// * * * * * NEWBIES SHOULD DEFINETLY NOT BE EDITING BEYOND THIS * * * * * ------------------------------------ --+  

color theColor;

string gapz1 = "  "; // 30 spaces as test
string gapz2 = " "; // 2 spaces

string starz1 = " * ";
string starz2 = " * ";
string starz3 = " * ";

int   Move_Text_L_or_R = 0;

string hashz= "#";

double pmod;

int p2p;
int dig;
int Xpips;

string Npips;
string Fpips;

static string text;

static string Buyz_SLz_Distance="Buyz+SLz_Distance";
static string BLimitz_SLz_Distance="BLimitz+SLz_Distance";
static string BStopz_SLz_Distance="BStopz+SLz_Distance";
static string Sellz_SLz_Distance="Sellz+SLz_Distance";
static string SLimitz_SLz_Distance="SLimitz+SLz_Distance";
static string SStopz_SLz_Distance="SStopz+SLz_Distance";
static string Buyz_TPz_Distance="Buyz+TPz_Distance";
static string BLimitz_TPz_Distance="BLimitz+TPz_Distance";
static string BStopz_TPz_Distance="BStopz+TPz_Distance";
static string Sellz_TPz_Distance="Sellz+TPz_Distance";
static string SLimitz_TPz_Distance="SLimitz+TPz_Distance";
static string SStopz_TPz_Distance="SStopz+TPz_Distance";

static string BLimitz_OE_Dist="BLimitz_OE_Dist";
static string BStopz_OE_Dist="BStopz_OE_Dist";
static string SLimitz_OE_Dist="SLimitz_OE_Dist";
static string SStopz_OE_Dist="SStopz_OE_Dist";

//---------------------------------------------------------------------
int init()
{
   // Hide Order text
   if(Hide_Order_Text==true)
      {
      Buy_TP="";
      Buy_SL="";
      Buy_Limit_TP = ""; 
      Buy_Limit_SL = "";
      Buy_Stop_TP = "";
      Buy_Stop_SL = "";
      Sell_SL = "";
      Sell_TP = "";
      Sell_Limit_SL = "";
      Sell_Limit_TP = "";
      Sell_Stop_SL = "";
      Sell_Stop_TP = "";
      
      Buy_Limit_OE = "";
      Buy_Stop_OE = "";
      Sell_Limit_OE = "";
      Sell_Stop_OE = "";
      }
   // Hide Pips
   if(Hide_Pip_Text==true){
      Npips="";
      Fpips="";}
   else{
      Npips="  pps";
      Fpips="  f-pps";}   
    
   // Pip Logic
   if(Fractional_Pips==true){
      pmod=Point;
      p2p=1;
      dig=0;
   }
   else{
      pmod=Point*10;
      p2p=10;
      dig=1;
      
   }

   if(Digits==0){
      pmod=Point;
      p2p=1;
      dig=0;
      Xpips=1;
   }
   
   // Pip Choice
   if (Fractional_Pips==true)
      if(Xpips==1){
         Npips=Npips;}
      else{  
         Npips=Fpips;}
   // hash hide         
   if(Hide_OrderTicket==true)
   hashz=""; 
   // star1 hide 
   if(Hide_OrderTicket==true||Hide_SL_TP_Price==true)
   starz1="";   
   // star2 hide 
   if(Hide_OrderTicket==true&&Hide_SL_TP_Price==true)
   starz2="";   
   // OE hidden Alert  
   if(Hide_Limit_and_Stop_Orders==true&& Hide_OE==false)
   Alert("When Limit and Stop Orders are hidden, OEs are hidden.");
   PlaySound("Alert.wav");  
   // OE Price choice
   if(Hide_OE_Price==true||Hide_OrderTicket==true)
   starz3="";               
     
   return(0);
}
//---------------------------------------------------------------------
int deinit()
   {
   DeleteLabels(
   Buyz_SLz_Distance,
   BLimitz_SLz_Distance,
   BStopz_SLz_Distance,
   Sellz_SLz_Distance,
   SLimitz_SLz_Distance,
   SStopz_SLz_Distance,
   Buyz_TPz_Distance,
   BLimitz_TPz_Distance,
   BStopz_TPz_Distance,
   Sellz_TPz_Distance,
   SLimitz_TPz_Distance,
   SStopz_TPz_Distance,
   
   BLimitz_OE_Dist,
   BStopz_OE_Dist,
   SLimitz_OE_Dist,
   SStopz_OE_Dist);
 
   return(0);
   }
//---------------------------------------------------------------------
int start()
   { 
   DeleteLabels(
   Buyz_SLz_Distance,
   BLimitz_SLz_Distance,
   BStopz_SLz_Distance,
   Sellz_SLz_Distance,
   SLimitz_SLz_Distance,
   SStopz_SLz_Distance,
   Buyz_TPz_Distance,
   BLimitz_TPz_Distance,
   BStopz_TPz_Distance,
   Sellz_TPz_Distance,
   SLimitz_TPz_Distance,
   SStopz_TPz_Distance,
   
   BLimitz_OE_Dist,
   BStopz_OE_Dist,
   SLimitz_OE_Dist,
   SStopz_OE_Dist);
   
   int orders= OrdersTotal();
   if( orders==0 ) return(0);
   
   for (int n=0; n<orders; n++)
   {
      if (OrderSelect(n,SELECT_BY_POS))
      if (OrderSymbol()==Symbol())
      {
         // Buy - SL
         string name_Buyz_SLz = Buyz_SLz_Distance+OrderTicket()+"stop loss";
            if(OrderType()==OP_BUY&&Hide_SL==false){
            CreateText_Buyz_SLz(name_Buyz_SLz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((Bid-OrderStopLoss())/pmod),dig));}
         // BuyLimit - SL   
         string name_BLimitz_SLz = BLimitz_SLz_Distance+OrderTicket()+"stop loss";   
            if(OrderType()==OP_BUYLIMIT&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BLimitz_SLz(name_BLimitz_SLz,Time[((WindowFirstVisibleBar()-20)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((Bid-OrderStopLoss())/pmod),dig));}
         // BuyStop - SL
         string name_BStopz_SLz = BStopz_SLz_Distance+OrderTicket()+"stop loss"; 
            if(OrderType()==OP_BUYSTOP&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BStopz_SLz(name_Buyz_SLz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((Bid-OrderStopLoss())/pmod),dig));}
       
         // Sell - SL
         string name_Sellz_SLz = Sellz_SLz_Distance+OrderTicket()+"stop loss";
            if(OrderType()==OP_SELL&&Hide_SL==false){
            CreateText_Sellz_SLz(name_Sellz_SLz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-Ask)/pmod),dig));}    
         // SellLimit - SL
         string name_SLimitz_SLz = SLimitz_SLz_Distance+OrderTicket()+"stop loss";  
            if(OrderType()==OP_SELLLIMIT&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SLimitz_SLz(name_SLimitz_SLz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-Ask)/pmod),dig));}                                     
         // SellStop - SL
         string name_SStopz_SLz = SStopz_SLz_Distance+OrderTicket()+"stop loss";  
            if(OrderType()==OP_SELLSTOP&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SStopz_SLz(name_SStopz_SLz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-Ask)/pmod),dig));}            
           
         // Buy - TP
         string name_Buyz_TPz = Buyz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUY&&Hide_TP==false){
            CreateText_Buyz_TPz(name_Buyz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-Bid)/pmod),dig));}
         // BuyLimit - TP
         string name_BLimitz_TPz = BLimitz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUYLIMIT&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BLimitz_TPz(name_BLimitz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-Bid)/pmod),dig));}
         // BuyStop - TP                        
         string name_BStopz_TPz = BStopz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUYSTOP&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BStopz_TPz(name_BStopz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-Bid)/pmod),dig));}
        
         // Sell - TP 
         string name_Sellz_TPz = Sellz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELL&&Hide_TP==false){
            CreateText_Sellz_TPz(name_Sellz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((Ask-OrderTakeProfit())/pmod),dig));}
         // SellLimit - TP
         string name_SLimitz_TPz = SLimitz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELLLIMIT&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SLimitz_TPz(name_SLimitz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((Ask-OrderTakeProfit())/pmod),dig));}      
         // SellStop - TP
         string name_SStopz_TPz = SStopz_TPz_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELLSTOP&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SStopz_TPz(name_SStopz_TPz,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((Ask-OrderTakeProfit())/pmod),dig));}     
         
         // BuyLimit - OE
         string name_BLimitz_OE = BLimitz_OE_Dist+OrderTicket();   
            if(OrderType()==OP_BUYLIMIT&&Hide_Limit_and_Stop_Orders==false&& Hide_OE==false){
            CreateText_BLimitz_OE(name_BLimitz_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),TP_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // BuyStop - OE
         string name_BStopz_OE = BStopz_OE_Dist+OrderTicket();   
            if(OrderType()==OP_BUYSTOP&&Hide_Limit_and_Stop_Orders==false&& Hide_OE==false){
            CreateText_BStopz_OE(name_BStopz_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),TP_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // SellLimit - OE
         string name_SLimitz_OE = SLimitz_OE_Dist+OrderTicket();   
            if(OrderType()==OP_SELLLIMIT&&Hide_Limit_and_Stop_Orders==false&& Hide_OE==false){
            CreateText_SLimitz_OE(name_SLimitz_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),SL_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // SellStop - OE
         string name_SStopz_OE = SStopz_OE_Dist+OrderTicket();   
            if(OrderType()==OP_SELLSTOP&&Hide_Limit_and_Stop_Orders==false&& Hide_OE==false){
            CreateText_SStopz_OE(name_SStopz_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),SL_Color,DoubleToStr(OrderOpenPrice(),Digits));}          
      }
   }
   return(0);
}
//---------------------------------------------------------------------
//
//---------------------------------------------------------------------
// STOP-LOSS
 // Buy - SL
void CreateText_Buyz_SLz(string Buyz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
        
   ObjectCreate(Buyz_SLz, OBJ_TEXT,0, time1, price);
    
   if (Hide_SL==false)
       ObjectSetText(Buyz_SLz, StringSubstr(Buy_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
       ObjectMove(Buyz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price); 
}
// BuyLimit - SL 
void CreateText_BLimitz_SLz(string BLimitz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
  
   ObjectCreate(BLimitz_SLz, OBJ_TEXT,0, time1, price);
    
   if (Hide_SL==false)
      ObjectSetText(BLimitz_SLz, StringSubstr(Buy_Limit_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BLimitz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// BuyStop - SL
void CreateText_BStopz_SLz(string BStopz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
    
   ObjectCreate(BStopz_SLz, OBJ_TEXT,0, time1, price);
    
   if (Hide_SL==false)
      ObjectSetText(BStopz_SLz, StringSubstr(Buy_Stop_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BStopz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// Sell - SL
void CreateText_Sellz_SLz(string Sellz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
     
   ObjectCreate(Sellz_SLz, OBJ_TEXT,0, time1, price);
     
   if (Hide_SL==false)    
      ObjectSetText(Sellz_SLz, StringSubstr(Sell_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);   
      ObjectMove(Sellz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellLimit - SL 
void CreateText_SLimitz_SLz(string SLimitz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
  
   ObjectCreate(SLimitz_SLz, OBJ_TEXT,0, time1, price);  
   
   if (Hide_SL==false)
      ObjectSetText(SLimitz_SLz, StringSubstr(Sell_Limit_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SLimitz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);  
}
// SStop - SL
void CreateText_SStopz_SLz(string SStopz_SLz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OSL_Pz = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Pz = "";
      
   // SStop - SL 
   ObjectCreate(SStopz_SLz, OBJ_TEXT,0, time1, price);
    
   if (Hide_SL==false)
      ObjectSetText(SStopz_SLz, StringSubstr(Sell_Stop_SL,0,xx) + gapz1 + hashz + OTz + starz1 + OSL_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SStopz_SLz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}

// TAKE - PROFIT
// Buy - TP
void CreateText_Buyz_TPz(string Buyz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
   
   ObjectCreate(Buyz_TPz, OBJ_TEXT,0, time1, price);
      
   if (Hide_TP==false)
      ObjectSetText(Buyz_TPz, StringSubstr(Buy_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(Buyz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// BuyLimit - TP
void CreateText_BLimitz_TPz(string BLimitz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
    
   ObjectCreate(BLimitz_TPz, OBJ_TEXT,0, time1, price);
    
   if (Hide_TP==false)
      ObjectSetText(BLimitz_TPz, StringSubstr(Buy_Limit_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BLimitz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price); 
}
// BuyStop - TP
void CreateText_BStopz_TPz(string BStopz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
   
   ObjectCreate(BStopz_TPz, OBJ_TEXT,0, time1, price);
   
   if (Hide_TP==false)
      ObjectSetText(BStopz_TPz, StringSubstr(Buy_Stop_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BStopz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// Sell - TP 
void CreateText_Sellz_TPz(string Sellz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
   
   ObjectCreate(Sellz_TPz, OBJ_TEXT,0, time1, price);
   
   if (Hide_TP==false)
      ObjectSetText(Sellz_TPz, StringSubstr(Sell_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(Sellz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellLimit - TP
void CreateText_SLimitz_TPz(string SLimitz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
   
   ObjectCreate(SLimitz_TPz, OBJ_TEXT,0, time1, price);
   
   if (Hide_TP==false)
      ObjectSetText(SLimitz_TPz, StringSubstr(Sell_Limit_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SLimitz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellStop - TP 
void CreateText_SStopz_TPz(string SStopz_TPz, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";      
   
   string OTP_Pz = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Pz = "";
   
   ObjectCreate(SStopz_TPz, OBJ_TEXT,0, time1, price);
       
   if (Hide_TP==false)
      ObjectSetText(SStopz_TPz, StringSubstr(Sell_Stop_TP,0,xx) + gapz1 + hashz + OTz + starz1 + OTP_Pz + starz2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SStopz_TPz,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// BuyLimit - OE
void CreateText_BLimitz_OE(string BLimitz_OE, datetime time1, double price, color theColor, string text)
   {  
   if (price==0) return; 
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";         
   ObjectCreate(BLimitz_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
      
   if ( Hide_OE==false)
      ObjectSetText(BLimitz_OE, StringSubstr(Buy_Limit_OE,0,xx)+ gapz1 +  hashz + OTz + starz3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(BLimitz_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
   }
// BuyStop - OE
void CreateText_BStopz_OE(string BStopz_OE, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";         
   ObjectCreate(BStopz_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
      
   if ( Hide_OE==false)
      ObjectSetText(BStopz_OE, StringSubstr(Buy_Stop_OE,0,xx)+ gapz1 +  hashz + OTz + starz3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(BStopz_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellLimit - OE
void CreateText_SLimitz_OE(string SLimitz_OE, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";           
   ObjectCreate(SLimitz_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
      
   if ( Hide_OE==false)
      ObjectSetText(SLimitz_OE, StringSubstr(Sell_Limit_OE,0,xx)+ gapz1 +  hashz + OTz + starz3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(SLimitz_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// SellStop - OE
void CreateText_SStopz_OE(string SStopz_OE, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTz = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTz="";         
   ObjectCreate(SStopz_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
      
   if ( Hide_OE==false)
      ObjectSetText(SStopz_OE, StringSubstr(Sell_Stop_OE,0,xx)+ gapz1 +  hashz + OTz + starz3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(SStopz_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}

//-----------------------------------------------------------------------
//
//-----------------------------------------------------------------------

void DeleteLabels(
string Buyz_SLz_Distance, 
string BLimitz_SLz_Distance,
string BStopz_SLz_Distance,
string Sellz_SLz_Distance,
string SLimitz_SLz_Distance,
string SStopz_SLz_Distance,
string Buyz_TPz_Distance,
string BLimitz_TPz_Distance,
string BStopz_TPz_Distance,
string Sellz_TPz_Distance,
string SLimitz_TPz_Distance,
string SStopz_TPz_Distance,

string Blimitz_OE_Dist,
string BStopz_OE_Dist,
string Slimitz_OE_Dist,
string SStopz_OE_Dist)

{
   for( int a=ObjectsTotal(); a>=0; a-- )
   {
      string Buyz_SLz=ObjectName(a); if (StringFind(Buyz_SLz,Buyz_SLz_Distance,0) > -1 ) ObjectDelete(Buyz_SLz);  
      string BLimitz_SLz=ObjectName(a); if (StringFind(BLimitz_SLz,BLimitz_SLz_Distance,0) > -1 ) ObjectDelete(BLimitz_SLz);  
      string BStopz_SLz=ObjectName(a); if (StringFind(BStopz_SLz,BStopz_SLz_Distance,0) > -1 ) ObjectDelete(BStopz_SLz);  
      
      string Sellz_SLz=ObjectName(a); if (StringFind(Sellz_SLz,Sellz_SLz_Distance,0) > -1 ) ObjectDelete(Sellz_SLz);  
      string SLimitz_SLz=ObjectName(a); if (StringFind(SLimitz_SLz,SLimitz_SLz_Distance,0) > -1 ) ObjectDelete(SLimitz_SLz);  
      string SStopz_SLz=ObjectName(a); if (StringFind(SStopz_SLz,SStopz_SLz_Distance,0) > -1 ) ObjectDelete(SStopz_SLz);  
   
      string Buyz_TPz=ObjectName(a); if (StringFind(Buyz_TPz,Buyz_TPz_Distance,0) > -1 ) ObjectDelete(Buyz_TPz);  
      string BLimitz_TPz=ObjectName(a); if (StringFind(BLimitz_TPz,BLimitz_TPz_Distance,0) > -1 ) ObjectDelete(BLimitz_TPz);  
      string BStopz_TPz=ObjectName(a); if (StringFind(BStopz_TPz,BStopz_TPz_Distance,0) > -1 ) ObjectDelete(BStopz_TPz);  
      
      string Sellz_TPz=ObjectName(a); if (StringFind(Sellz_TPz,Sellz_TPz_Distance,0) > -1 ) ObjectDelete(Sellz_TPz);  
      string SLimitz_TPz=ObjectName(a); if (StringFind(SLimitz_TPz,SLimitz_TPz_Distance,0) > -1 ) ObjectDelete(SLimitz_TPz);  
      string SStopz_TPz=ObjectName(a); if (StringFind(SStopz_TPz,SStopz_TPz_Distance,0) > -1 ) ObjectDelete(SStopz_TPz); 
      
      string BLimitz_OE=ObjectName(a); if (StringFind(BLimitz_OE,BLimitz_OE_Dist,0) > -1 ) ObjectDelete(BLimitz_OE);     
      string BStopz_OE=ObjectName(a); if (StringFind(BStopz_OE,BStopz_OE_Dist,0) > -1 ) ObjectDelete(BStopz_OE); 
      string SLimitz_OE=ObjectName(a); if (StringFind(SLimitz_OE,SLimitz_OE_Dist,0) > -1 ) ObjectDelete(SLimitz_OE);     
      string SStopz_OE=ObjectName(a); if (StringFind(SStopz_OE,SStopz_OE_Dist,0) > -1 ) ObjectDelete(SStopz_OE);     
   }
}


