//+------------------------------------------------------------------+
//|                                                   Profitstat.mq4 |
//|                            Copyright © 2012, www.FxAutomated.com |
//|                                       http://www.FxAutomated.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, www.FxAutomated.com"
#property link      "http://www.FxAutomated.com"

#property indicator_chart_window
extern color DayIdColor=DodgerBlue;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
   ObjectCreate("Label_eaname", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_eaname", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_eaname", OBJPROP_XDISTANCE, 10);// X coordinate   
   ObjectSet("Label_eaname", OBJPROP_YDISTANCE, 20);// Y coordinate


   ObjectCreate("Label_yt", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_yt", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_yt", OBJPROP_XDISTANCE, 10);// X coordinate   
   ObjectSet("Label_yt", OBJPROP_YDISTANCE, 45);// Y coordinate
   
   ObjectCreate("Label_yp", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_yp", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_yp", OBJPROP_XDISTANCE, 10);// X coordinate   
   ObjectSet("Label_yp", OBJPROP_YDISTANCE, 60);// Y coordinate
   
   ObjectCreate("Label_tt", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_tt", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_tt", OBJPROP_XDISTANCE, 10);// X coordinate   
   ObjectSet("Label_tt", OBJPROP_YDISTANCE, 75);// Y coordinate
  
   ObjectCreate("Label_tp", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_tp", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_tp", OBJPROP_XDISTANCE, 10);// X coordinate   
   ObjectSet("Label_tp", OBJPROP_YDISTANCE, 90);// Y coordinate


   return(0);
  }
 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//------------------------Time calculations----------------------------

int TodaySeconds=(Hour()*3600)+(Minute()*60)+Seconds();
int YesterdayEnd=TimeCurrent()-TodaySeconds;
int YesterdayStart=YesterdayEnd-86400;

//--------------------Analyze trade history------------------------------------

double ProfitToday=0,ProfitYesterday=0;
int YesterdayTrades=0,TodayTrades=0,FirstOnly=0;

for(int h=OrdersHistoryTotal()-1;h>=0;h--) // cycle
  {
    if(OrderSelect(h,SELECT_BY_POS,MODE_HISTORY)==true) // select next
      {
         
        // operations
           if(OrderCloseTime()>YesterdayStart){ // trade is young       
        
           if(OrderCloseTime()>YesterdayEnd){ ProfitToday=ProfitToday+OrderProfit(); TodayTrades++; }
           if(OrderCloseTime()<YesterdayEnd&&OrderCloseTime()>YesterdayStart){ ProfitYesterday=ProfitYesterday+OrderProfit(); YesterdayTrades++; }
           
          } // trade is young
           

        
        
      }// select
  }// cycle
  
//----------------------------------Set values-----------------------
color CpColor,CpColor2;

   string eanameParameters="Profitstat v1 data";
   ObjectSetText("Label_eaname",eanameParameters,15,"Arial",DodgerBlue);

   string ytParameters=StringConcatenate("Trades closed yesterday: ",YesterdayTrades);
   ObjectSetText("Label_yt",ytParameters,10,"Arial",DayIdColor);
   
   if(ProfitYesterday>0)CpColor=Lime; else CpColor=Red;
   string ypParameters=StringConcatenate("Profit yesterday: ",ProfitYesterday," ",AccountCurrency());
   ObjectSetText("Label_yp",ypParameters,8,"Arial",CpColor);
   
   string ttParameters=StringConcatenate("Trades closed today: ",TodayTrades);
   ObjectSetText("Label_tt",ttParameters,10,"Arial",DayIdColor);
   
   if(ProfitToday>=0)CpColor2=Lime; else CpColor2=Red;
   string tpParameters=StringConcatenate("Profit today: ",ProfitToday," ",AccountCurrency());
   ObjectSetText("Label_tp",tpParameters,8,"Arial",CpColor2);
//-------------------------------------------------------------------
   return(0);
  }
//+------------------------------END------------------------------------+









































































//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
  ObjectDelete("Label_eaname");     // Object deletion
  ObjectDelete("Label_yt");
  ObjectDelete("Label_yp");
  ObjectDelete("Label_tt");
  ObjectDelete("Label_tp");
  Alert("Visit www.fxautomated.com for more forex stuff!");
//----
   return(0);
  }