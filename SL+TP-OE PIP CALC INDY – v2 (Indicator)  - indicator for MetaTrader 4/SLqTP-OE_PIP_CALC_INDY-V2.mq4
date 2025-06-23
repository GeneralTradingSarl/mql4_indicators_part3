#property copyright "Copyright @ 2012, File45"
#property indicator_chart_window 
//thanks: mladen-super moderator FOREX-TSD www.forex-tsd.com who's edits on a previous project provided a template for further endevours. 
//http://www.forex-tsd.com/expert-advisors-metatrader-4/20171-please-fix-indicator-ea-34.html#post425056

// SL+TP-OE PIP CALC INDI - v2

// USERS CAN PERMANENTLY CHANGE THE DEFAULT SETTINGS BY MODIFYING THE BELOW CODE - EXAMPLES PROVIDED.
// * * * * * REMEBER TO COMPILE AND CHECK FOR ERRORS AFTER EVERY MODIFICATION * * * * * 

extern string PIPS_or_FRACTIONAL_PIPS = "fractional pips = points / 3 & 5 digit pricing";
extern bool   Fractional_Pips  = true; // modification examples: = false; 
extern string HIDE_OPTIONS;
extern bool   Hide_Order_Type_Text = false; // modification examples: = true;
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
extern int    Shift_Text_Left_or_Right = 14; // Modification examples: = 10; ; 
extern color  SL_Color = Magenta;  // modification examples: = DarkOrange; 
extern color  TP_Color = LimeGreen;
extern bool   Use_OE_Color = false;
extern color  OE_Color = Gold;
extern int    SL_TP_Font_Size = 10;
extern int    OE_Font_Size = 8;
extern string FontName = "Arial";  // modification examples: = "Verdana"; 

// * * * * * DO NOT MODIFY BEYOND THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING * * * * *

// CHANGE_ORDER_TEXT;
// Set_at_Max_8_Characters;
// BUY_ORDERS;  
string Buy_TP = "Buy-TP";  // Modification examples: = "B-TP"; "BUY";
string Buy_SL = "Buy-SL";   
string Buy_Limit_TP = "BL-TP";   // Modification examples: = "BuyLimit";  = "B-Limit"; 
string Buy_Limit_SL = "BL-SL";
string Buy_Stop_TP = "BS-TP";
string Buy_Stop_SL = "BS-SL";
// SELL_ORDERS;
string Sell_SL = "Sell-SL";
string Sell_TP = "Sell-TP";
string Sell_Limit_SL = "SL-SL";
string Sell_Limit_TP = "SL-TP";
string Sell_Stop_SL = "SS-SL";
string Sell_Stop_TP = "SS-TP";
// ORDER EXECUTION 
string Buy_Limit_OE = "BL-OE";
string Buy_Stop_OE = "BS-OE";
string Sell_Limit_OE = "SL-OE";
string Sell_Stop_OE = "SS-OE";

string Increase_Max_Characters;
int xx = 8; // change this number regulate maximum order text input

// * * * * NEWBIES SHOULD DEFINETLY NOT BE EDITING BEYOND THIS * * * *  --------------------------------------  

color theColor;

string gapx1 = "  "; // 30 spaces as test
string gapx2 = " "; // 2 spaces

string starx1 = " * ";
string starx2 = " * ";
string starx3 = " * ";

int   Move_Text_L_or_R = 0; 

string hashx= "#";

double pmod;

int p2p;
int dig;
int Xpips;

string Npips;
string Fpips;

static string text;

static string Buyx_SLx_Distance="Buyx+SLx_Distance";
static string BLimitx_SLx_Distance="BLimitx+SLx_Distance";
static string BStopx_SLx_Distance="BStopx+SLx_Distance";
static string Sellx_SLx_Distance="Sellx+SLx_Distance";
static string SLimitx_SLx_Distance="SLimitx+SLx_Distance";
static string SStopx_SLx_Distance="SStopx+SLx_Distance";
static string Buyx_TPx_Distance="Buyx+TPx_Distance";
static string BLimitx_TPx_Distance="BLimitx+TPx_Distance";
static string BStopx_TPx_Distance="BStopx+TPx_Distance";
static string Sellx_TPx_Distance="Sellx+TPx_Distance";
static string SLimitx_TPx_Distance="SLimitx+TPx_Distance";
static string SStopx_TPx_Distance="SStopx+TPx_Distance";

static string BLimitx_OE_Dist="BLimitx_OE_Dist";
static string BStopx_OE_Dist="BStopx_OE_Dist";
static string SLimitx_OE_Dist="SLimitx_OE_Dist";
static string SStopx_OE_Dist="SStopx_OE_Dist";

//---------------------------------------------------------------------

int init(){
   // Hide Order Text 
   if(Hide_Order_Type_Text==true){
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
      Sell_Stop_OE = "";}
    
   // Hide Pip Text
   if(Hide_Pip_Text==true){
      Npips="";
      Fpips="";}
   else{
      Npips="  pps";
      Fpips="  f-pps";}   
   
   // Pip logic
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
   //         
   if(Hide_OrderTicket==true)
   hashx=""; 
   //  
   if(Hide_OrderTicket==true||Hide_SL_TP_Price==true)
   starx1="";   
   //  
   if(Hide_OrderTicket==true&&Hide_SL_TP_Price==true)
   starx2="";   
   //    
   if(Hide_Limit_and_Stop_Orders==true&&Hide_OE==false)
   Alert("When Limit and Stop Orders are hidden, OEs are hidden.");
   PlaySound("Alert.wav");
   
   if (Hide_OE_Price==true||Hide_OrderTicket==true)
   starx3="";   
      
   return(0);
}
//---------------------------------------------------------------------
int deinit(){
   DeleteLabels(
   Buyx_SLx_Distance,
   BLimitx_SLx_Distance,
   BStopx_SLx_Distance,
   Sellx_SLx_Distance,
   SLimitx_SLx_Distance,
   SStopx_SLx_Distance,
   Buyx_TPx_Distance,
   BLimitx_TPx_Distance,
   BStopx_TPx_Distance,
   Sellx_TPx_Distance,
   SLimitx_TPx_Distance,
   SStopx_TPx_Distance,
   
   BLimitx_OE_Dist,
   BStopx_OE_Dist,
   SLimitx_OE_Dist,
   SStopx_OE_Dist);
   
   return(0);
}

//---------------------------------------------------------------------

int start()
{ 
 
   DeleteLabels(
   Buyx_SLx_Distance,
   BLimitx_SLx_Distance,
   BStopx_SLx_Distance,
   Sellx_SLx_Distance,
   SLimitx_SLx_Distance,
   SStopx_SLx_Distance,
   Buyx_TPx_Distance,
   BLimitx_TPx_Distance,
   BStopx_TPx_Distance,
   Sellx_TPx_Distance,
   SLimitx_TPx_Distance,
   SStopx_TPx_Distance,
   
   BLimitx_OE_Dist,
   BStopx_OE_Dist,
   SLimitx_OE_Dist,
   SStopx_OE_Dist);
   
   int orders= OrdersTotal();
   if( orders==0 ) return(0);
   
   for (int n=0; n<orders; n++)
   {
      if (OrderSelect(n,SELECT_BY_POS))
      if (OrderSymbol()==Symbol())
      {
         // Buy - SL
         string name_Buyx_SLx = Buyx_SLx_Distance+OrderTicket()+"stop loss"+OrderStopLoss();
            if(OrderType()==OP_BUY&&Hide_SL==false){
            CreateText_Buyx_SLx(name_Buyx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}                            
         // Blimit - SL
         string name_BLimitx_SLx = BLimitx_SLx_Distance+OrderTicket()+"stop loss";   
            if(OrderType()==OP_BUYLIMIT&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BLimitx_SLx(name_BLimitx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}
         // BuyStop - SL
         string name_BStopx_SLx = BStopx_SLx_Distance+OrderTicket()+"stop loss"; 
            if(OrderType()==OP_BUYSTOP&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BStopx_SLx(name_Buyx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}
         
         // Sell - SL
         string name_Sellx_SLx = Sellx_SLx_Distance+OrderTicket()+"stop loss";
            if(OrderType()==OP_SELL&&Hide_SL==false){
            CreateText_Sellx_SLx(name_Sellx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}    
         // SellLimit - SL
         string name_SLimitx_SLx = SLimitx_SLx_Distance+OrderTicket()+"stop loss";  
            if(OrderType()==OP_SELLLIMIT&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SLimitx_SLx(name_SLimitx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}                                     
         // SellStop - SL
         string name_SStopx_SLx = SStopx_SLx_Distance+OrderTicket()+"stop loss";  
            if(OrderType()==OP_SELLSTOP&&Hide_SL==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SStopx_SLx(name_SStopx_SLx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));}            
           
         // Buy - TP
         string name_Buyx_TPx = Buyx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUY&&Hide_TP==false){
            CreateText_Buyx_TPx(name_Buyx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}
         // BuyLimit - TP
         string name_BLimitx_TPx = BLimitx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUYLIMIT&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BLimitx_TPx(name_BLimitx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}
         // BuyStop - TP                        
         string name_BStopx_TPx = BStopx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_BUYSTOP&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_BStopx_TPx(name_BStopx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}
        
         // Sell - TP 
         string name_Sellx_TPx = Sellx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELL&&Hide_TP==false){
            CreateText_Sellx_TPx(name_Sellx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}
         // SellLimit - TP
         string name_SLimitx_TPx = SLimitx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELLLIMIT&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SLimitx_TPx(name_SLimitx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}      
         // SellStop - TP
         string name_SStopx_TPx = SStopx_TPx_Distance+OrderTicket()+"take profit";   
            if(OrderType()==OP_SELLSTOP&&Hide_TP==false&&Hide_Limit_and_Stop_Orders==false){
            CreateText_SStopx_TPx(name_SStopx_TPx,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));}     
         

         // BuyLimit - OE
         string name_BLimitx_OE = BLimitx_OE_Dist+OrderTicket();   
            if(OrderType()==OP_BUYLIMIT&&Hide_Limit_and_Stop_Orders==false&&Hide_OE==false){
            CreateText_BLimitx_OE(name_BLimitx_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),TP_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // BuyStop - OE
         string name_BStopx_OE = BStopx_OE_Dist+OrderTicket();   
            if(OrderType()==OP_BUYSTOP&&Hide_Limit_and_Stop_Orders==false&&Hide_OE==false){
            CreateText_BStopx_OE(name_BStopx_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),TP_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // SellLimit - OE
         string name_SLimitx_OE = SLimitx_OE_Dist+OrderTicket();   
            if(OrderType()==OP_SELLLIMIT&&Hide_Limit_and_Stop_Orders==false&&Hide_OE==false){
            CreateText_SLimitx_OE(name_SLimitx_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),SL_Color,DoubleToStr(OrderOpenPrice(),Digits));}
         // SellStop - OE
         string name_SStopx_OE = SStopx_OE_Dist+OrderTicket();   
            if(OrderType()==OP_SELLSTOP&&Hide_Limit_and_Stop_Orders==false&&Hide_OE==false){
            CreateText_SStopx_OE(name_SStopx_OE,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderOpenPrice(),SL_Color,DoubleToStr(OrderOpenPrice(),Digits));}                     
      }
   }
     
   return(0);
}

//---------------------------------------------------------------------
//
//---------------------------------------------------------------------

// STOP-LOSS
// Buy - SL 
void CreateText_Buyx_SLx(string Buyx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
       
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
     
   ObjectCreate(Buyx_SLx, OBJ_TEXT, 0, Time[0], price);
    
   if (Hide_SL==false)
      ObjectSetText(Buyx_SLx, StringSubstr(Buy_SL,0,xx) + gapx1 + hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(Buyx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50, price);   
}
// BuyLimit - SL 
void CreateText_BLimitx_SLx(string BLimitx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
 
   ObjectCreate(BLimitx_SLx, OBJ_TEXT, 0, TimeCurrent(), price);
   
   if (Hide_SL==false)
      ObjectSetText(BLimitx_SLx, StringSubstr(Buy_Limit_SL,0,xx) + gapx1 +  hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BLimitx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// BuyStop - SL 
void CreateText_BStopx_SLx(string BStopx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
   
   ObjectCreate(BStopx_SLx, OBJ_TEXT, 0, TimeCurrent(), price);
    
   if (Hide_SL==false)
      ObjectSetText(BStopx_SLx, gapx1 + StringSubstr(Buy_Stop_SL,0,xx) + gapx1 +  hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BStopx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// Sell - SL 
void CreateText_Sellx_SLx(string Sellx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
      
   ObjectCreate(Sellx_SLx, OBJ_TEXT, 0, TimeCurrent(), price);
     
   if (Hide_SL==false)    
      ObjectSetText(Sellx_SLx, gapx1 + StringSubstr(Sell_SL,0,xx) + gapx1 +  hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);   
      ObjectMove(Sellx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellLimit - SL 
void CreateText_SLimitx_SLx(string SLimitx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
   
   ObjectCreate(SLimitx_SLx, OBJ_TEXT, 0, TimeCurrent(), price);
   
   if (Hide_SL==false)
         ObjectSetText(SLimitx_SLx, gapx1 + StringSubstr(Sell_Limit_SL,0,xx) + gapx1 +  hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);   
      ObjectMove(SLimitx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// SStop - SL 
void CreateText_SStopx_SLx(string SStopx_SLx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OSL_Px = DoubleToStr(OrderStopLoss(),Digits);
   if (Hide_SL_TP_Price==true)
   OSL_Px = "";
   
   ObjectCreate(SStopx_SLx, OBJ_TEXT, 0, TimeCurrent(), price);
    
   if (Hide_SL==false)
      ObjectSetText(SStopx_SLx, gapx1 + StringSubstr(Sell_Stop_SL,0,xx) + gapx1 +  hashx + OTx + starx1 + OSL_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);   
      ObjectMove(SStopx_SLx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// TAKE - PROFIT
// Buy - TP
void CreateText_Buyx_TPx(string Buyx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
   
   ObjectCreate(Buyx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
      
   if (Hide_TP==false)
      ObjectSetText(Buyx_TPx, gapx1 + StringSubstr(Buy_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);  
      ObjectMove(Buyx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// BuyLimit - TP
void CreateText_BLimitx_TPx(string BLimitx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
    
   ObjectCreate(BLimitx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
    
   if (Hide_TP==false)
      ObjectSetText(BLimitx_TPx, gapx1 + StringSubstr(Buy_Limit_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BLimitx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);    
}
// BuyStop - TP
void CreateText_BStopx_TPx(string BStopx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
   
   ObjectCreate(BStopx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
   
   if (Hide_TP==false)
      ObjectSetText(BStopx_TPx, gapx1 + StringSubstr(Buy_Stop_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(BStopx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);  
}
// Sell - TP 
void CreateText_Sellx_TPx(string Sellx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
   
   ObjectCreate(Sellx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
   
   if (Hide_TP==false)
      ObjectSetText(Sellx_TPx, gapx1 + StringSubstr(Sell_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(Sellx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);      
}
// SellLimit - TP
void CreateText_SLimitx_TPx(string SLimitx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
   
   ObjectCreate(SLimitx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
   
   if (Hide_TP==false)
      ObjectSetText(SLimitx_TPx, gapx1 + StringSubstr(Sell_Limit_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SLimitx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);  
}
// SellStop - TP
void CreateText_SStopx_TPx(string SStopx_TPx, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";      
   
   string OTP_Px = DoubleToStr(OrderTakeProfit(),Digits);
   if (Hide_SL_TP_Price==true)
   OTP_Px = "";
    
   ObjectCreate(SStopx_TPx, OBJ_TEXT, 0, TimeCurrent(), price);
       
   if (Hide_TP==false)
      ObjectSetText(SStopx_TPx, gapx1 + StringSubstr(Sell_Stop_TP,0,xx) + gapx1 +  hashx + OTx + starx1 + OTP_Px + starx2 + text + Npips, SL_TP_Font_Size,FontName, theColor);
      ObjectMove(SStopx_TPx,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);   
}
// BuyLimit - OE
void CreateText_BLimitx_OE(string BLimitx_OE, datetime time1, double price, color theColor, string text)
{     
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx=""; 
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
   
   ObjectCreate(BLimitx_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
      
   if (Hide_OE==false)
      ObjectSetText(BLimitx_OE, StringSubstr(Buy_Limit_OE,0,xx)+ gapx1 +  hashx + OTx + starx3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(BLimitx_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// BuyStop - OE
void CreateText_BStopx_OE(string BStopx_OE, datetime time1, double price, color theColor, string text)
{  
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx="";
   
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color; 
    
   ObjectCreate(BStopx_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
      
   if (Hide_OE==false)
      ObjectSetText(BStopx_OE, StringSubstr(Buy_Stop_OE,0,xx)+ gapx1 +  hashx + OTx + starx3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(BStopx_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
 }
// SellLimit - OE
void CreateText_SLimitx_OE(string SLimitx_OE, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx=""; 
         
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
   
   ObjectCreate(SLimitx_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
      
   if (Hide_OE==false)
      ObjectSetText(SLimitx_OE, StringSubstr(Sell_Limit_OE,0,xx)+ gapx1 +  hashx + OTx + starx3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(SLimitx_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}
// SellStop - OE
void CreateText_SStopx_OE(string SStopx_OE, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   
   string OTx = DoubleToStr(OrderTicket(),0);
   if (Hide_OrderTicket==true)
   OTx=""; 
       
   if (Hide_OE_Price==true)
   text="";
   
   if(Use_OE_Color==true)
     theColor=OE_Color;
   
   ObjectCreate(SStopx_OE, OBJ_TEXT, 0, TimeCurrent(), OrderOpenPrice());
      
   if (Hide_OE==false)
      ObjectSetText(SStopx_OE, StringSubstr(Sell_Stop_OE,0,xx)+ gapx1 +  hashx + OTx + starx3 + text,OE_Font_Size, FontName, theColor);
      ObjectMove(SStopx_OE,0,Time[0]+Period()*Shift_Text_Left_or_Right*50,price);
}

//-----------------------------------------------------------------------
//
//-----------------------------------------------------------------------

void DeleteLabels(
string Buyx_SLx_Distance, 
string BLimitx_SLx_Distance,
string BStopx_SLx_Distance,
string Sellx_SLx_Distance,
string SLimitx_SLx_Distance,
string SStopx_SLx_Distance,
string Buyx_TPx_Distance,
string BLimitx_TPx_Distance,
string BStopx_TPx_Distance,
string Sellx_TPx_Distance,
string SLimitx_TPx_Distance,
string SStopx_TPx_Distance,

string Blimitx_OE_Dist,
string BStopx_OE_Dist,
string Slimitx_OE_Dist,
string SStopx_OE_Dist)

{
   for( int a=ObjectsTotal(); a>=0; a-- )
   {
      string Buyx_SLx=ObjectName(a); if (StringFind(Buyx_SLx,Buyx_SLx_Distance,0) > -1 ) ObjectDelete(Buyx_SLx);
      string BLimitx_SLx=ObjectName(a); if (StringFind(BLimitx_SLx,BLimitx_SLx_Distance,0) > -1 ) ObjectDelete(BLimitx_SLx);  
      string BStopx_SLx=ObjectName(a); if (StringFind(BStopx_SLx,BStopx_SLx_Distance,0) > -1 ) ObjectDelete(BStopx_SLx);  
      
      string Sellx_SLx=ObjectName(a); if (StringFind(Sellx_SLx,Sellx_SLx_Distance,0) > -1 ) ObjectDelete(Sellx_SLx);  
      string SLimitx_SLx=ObjectName(a); if (StringFind(SLimitx_SLx,SLimitx_SLx_Distance,0) > -1 ) ObjectDelete(SLimitx_SLx);  
      string SStopx_SLx=ObjectName(a); if (StringFind(SStopx_SLx,SStopx_SLx_Distance,0) > -1 ) ObjectDelete(SStopx_SLx);  
   
      string Buyx_TPx=ObjectName(a); if (StringFind(Buyx_TPx,Buyx_TPx_Distance,0) > -1 ) ObjectDelete(Buyx_TPx);  
      string BLimitx_TPx=ObjectName(a); if (StringFind(BLimitx_TPx,BLimitx_TPx_Distance,0) > -1 ) ObjectDelete(BLimitx_TPx);  
      string BStopx_TPx=ObjectName(a); if (StringFind(BStopx_TPx,BStopx_TPx_Distance,0) > -1 ) ObjectDelete(BStopx_TPx);  
      
      string Sellx_TPx=ObjectName(a); if (StringFind(Sellx_TPx,Sellx_TPx_Distance,0) > -1 ) ObjectDelete(Sellx_TPx);  
      string SLimitx_TPx=ObjectName(a); if (StringFind(SLimitx_TPx,SLimitx_TPx_Distance,0) > -1 ) ObjectDelete(SLimitx_TPx);  
      string SStopx_TPx=ObjectName(a); if (StringFind(SStopx_TPx,SStopx_TPx_Distance,0) > -1 ) ObjectDelete(SStopx_TPx);     
   
      string BLimitx_OE=ObjectName(a); if (StringFind(BLimitx_OE,BLimitx_OE_Dist,0) > -1 ) ObjectDelete(BLimitx_OE);     
      string BStopx_OE=ObjectName(a); if (StringFind(BStopx_OE,BStopx_OE_Dist,0) > -1 ) ObjectDelete(BStopx_OE); 
      string SLimitx_OE=ObjectName(a); if (StringFind(SLimitx_OE,SLimitx_OE_Dist,0) > -1 ) ObjectDelete(SLimitx_OE);     
      string SStopx_OE=ObjectName(a); if (StringFind(SStopx_OE,SStopx_OE_Dist,0) > -1 ) ObjectDelete(SStopx_OE); 
   }
}


