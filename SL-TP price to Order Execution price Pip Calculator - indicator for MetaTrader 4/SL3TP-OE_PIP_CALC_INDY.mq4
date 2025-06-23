#property copyright "Copyright @ 20011, File45 and anyone who want to add their 2 pence/cents/rupees worth"
#property indicator_chart_window 

//thanks: miaden-super moderator FOREX-TSD www.forex-tsd.com for major edit after which it workedas as intended.
//http://www.forex-tsd.com/expert-advisors-metatrader-4/20171-please-fix-indicator-ea-34.html#post425056
//thanks: dabbler - MQL4/Forum http://forum.mql4.com/45267   
//thanks: WHRoeder - ?      as above

extern bool Show_SL = true;
extern color SL_Color = Yellow;
extern bool Show_TP = true;
extern color TP_Color = DodgerBlue;
extern int   Text_Size =10;
extern int   Move_Text_L_or_R =0;
extern bool Fractional_Pips  = true;
extern bool Show_OrderTicket = true;

string Npips= " pips";
string Fpips= " fpips";

static string Pip_Distance="Pip+Distance";
static string text;
double pmod;

int p2p;
int dig;
int Xpips;

//---------------------------------------------------------------------
int init(){
   
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
   
   return(0);
}
//---------------------------------------------------------------------
int deinit(){
   DeleteLabels(Pip_Distance);
   return(0);
}
//---------------------------------------------------------------------
int start()
{
   DeleteLabels(Pip_Distance);

   int orders= OrdersTotal();
   if( orders==0 ) return(0);
   
   for (int n=0; n<orders; n++)
   {
      if (OrderSelect(n,SELECT_BY_POS))
      if (OrderSymbol()==Symbol())
      {
         string name = Pip_Distance+OrderTicket()+"stop loss";
            if(Show_SL==true)
            CreateText(name,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderStopLoss(),SL_Color,DoubleToStr(MathAbs((OrderStopLoss()-OrderOpenPrice())/pmod),dig));
                name = Pip_Distance+OrderTicket()+"take profit";
            if(Show_TP==true)
            CreateText(name,Time[((WindowFirstVisibleBar()-0)*Move_Text_L_or_R/100)],OrderTakeProfit(),TP_Color,DoubleToStr(MathAbs((OrderTakeProfit()-OrderOpenPrice())/pmod),dig));
      }
   }
   return(0);
}

//---------------------------------------------------------------------
//
//---------------------------------------------------------------------

void CreateText(string SL, datetime time1, double price, color theColor, string text)
{
   if (price==0) return;
   if (Fractional_Pips==true)
      {
         if(Xpips==1)
               Npips=Npips;
         else  Npips=Fpips;
      }
   
   ObjectCreate(SL, OBJ_TEXT,0, time1, price);
   if (Show_OrderTicket == true)
   // this long gap takes the text to the right side of the screen
         ObjectSetText(SL, "                                        " + "#" + OrderTicket() + " * " + text + Npips, Text_Size, "Verdana", theColor);
   else  ObjectSetText(SL, "                                        " + " " + text + Npips, Text_Size, "Verdana", theColor);
}

//---------------------------------------------------------------------
//
//---------------------------------------------------------------------

void DeleteLabels(string Pip_Distance)
{
   for( int i=ObjectsTotal(); i>=0; i-- )
   {
      string SL=ObjectName(i); if (StringFind(SL,Pip_Distance,0) > -1 ) ObjectDelete(SL);
   }
}