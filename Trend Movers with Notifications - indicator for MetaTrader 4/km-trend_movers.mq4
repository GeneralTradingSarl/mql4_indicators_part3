//+------------------------------------------------------------------+
//|                                              KM-TREND MOVERS.mq4 |
//|                                                  Khurram Mustafa |
//|                             https://www.mql5.com/en/users/kc1981 |
//+------------------------------------------------------------------+
#property copyright "KM"
#property link      "https://www.mql5.com/en/users/kc1981/seller"
#property version   "1.0"
#property description "TREND MOVERS"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

input color Colour = Black;
input string Setting1 = "Moving Average";
input int MA_fast = 6; 
input int MA_slow = 25;
input int MA_shift_fast = 0;
input int MA_shift_slow = 0;

input string Setting2 = "RSI";
input int Period2 = 14;

input string Setting3 = "ATR";
input int Period3 = 14;

input string Setting4 = "STOCHISTIC";
input int Period4K = 9;
input int Period4D = 3;
input int Period4S = 3;

input string Setting5 = "MACD";
input int EFast = 12;
input int ESlow = 26;
input int EPeriod = 9;

input string Setting6 = "CCI";
input int Period5 = 14;

input bool Alert_Allow = False;
input bool Email_Allow = False;
input bool Notification_Allow = False;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll();

   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double rsilevel=iRSI(Symbol(),0,Period2,0,0);

   ObjectCreate("textrsi",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("textrsi",OBJPROP_CORNER,1);
   ObjectSet("textrsi",OBJPROP_XDISTANCE,50);
   ObjectSet("textrsi",OBJPROP_YDISTANCE,80);
   ObjectSetText("textrsi","RSI LEVEL "+IntegerToString(Period2,0)+" : "+DoubleToStr(rsilevel,2),10,"Times New Roman",Colour);

   double atrlevel=iATR(Symbol(),0,Period3,0);

   ObjectCreate("textatr",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("textatr",OBJPROP_CORNER,1);
   ObjectSet("textatr",OBJPROP_XDISTANCE,50);
   ObjectSet("textatr",OBJPROP_YDISTANCE,100);
   ObjectSetText("textatr","ATR LEVEL "+IntegerToString(Period3,0)+" : "+DoubleToString(atrlevel,5),10,"Times New Roman",Colour);

   double stolevel=iStochastic(Symbol(),0,Period4K,Period4D,Period4S,0,0,MODE_EMA,0);

   ObjectCreate("textsto",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("textsto",OBJPROP_CORNER,1);
   ObjectSet("textsto",OBJPROP_XDISTANCE,50);
   ObjectSet("textsto",OBJPROP_YDISTANCE,120);
   ObjectSetText("textsto","STOCHISTIC LEVEL "+IntegerToString(Period4K,0)+" : "+DoubleToString(stolevel,2),10,"Times New Roman",Colour);

   double macdlevel=iMACD(Symbol(),0,EFast,ESlow,EPeriod,0,MODE_EMA,0);

   ObjectCreate("textmacd",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("textmacd",OBJPROP_CORNER,1);
   ObjectSet("textmacd",OBJPROP_XDISTANCE,50);
   ObjectSet("textmacd",OBJPROP_YDISTANCE,140);
   ObjectSetText("textmacd","MACD LEVEL "+IntegerToString(EPeriod,0)+" : "+DoubleToString(macdlevel,5),10,"Times New Roman",Colour);

   double ccilevel=iCCI(Symbol(),0,Period5,0,0);

   ObjectCreate("textcci",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("textcci",OBJPROP_CORNER,1);
   ObjectSet("textcci",OBJPROP_XDISTANCE,50);
   ObjectSet("textcci",OBJPROP_YDISTANCE,160);
   ObjectSetText("textcci","CCI LEVEL "+IntegerToString(Period5,0)+" : "+DoubleToStr(ccilevel,2),10,"Times New Roman",Colour);

   double h15 =iMA( Symbol(),0,MA_fast, MA_shift_fast,MODE_EMA,PRICE_CLOSE,0);
   double h120=iMA( Symbol(),0,MA_slow, MA_shift_slow,MODE_SMA,PRICE_CLOSE,0);
   static datetime tmp;

   ObjectCreate("texti",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("texti",OBJPROP_CORNER,1);
   ObjectSet("texti",OBJPROP_XDISTANCE,50);
   ObjectSet("texti",OBJPROP_YDISTANCE,60);
   ObjectSetText("texti","TEST",10,"Times New Roman",Colour);

   if(iClose(Symbol(),0,1)>h15 && iClose(Symbol(),0,1)>h120)
     {
      ObjectSetText("texti","STRONG BUY",10,"Times New Roman",DarkGreen);
      if(tmp<Time[0])
        {
         tmp=Time[0];

         if(Alert_Allow)
           {
            string AlertMsgSB="TREND MOVERS (ALERT)"+"\n"+AccountName()+"\n"+"STRONG BUY FOR PAIR - "+Symbol();
            Alert(AlertMsgSB);
           }
         if(Email_Allow)
           {
            SendMail(AccountName()+Symbol()+" - "+AccountCompany(),
                     //"New Bar :  " + "Alert  \n" +
                     "STRONG BUY FOR PAIR"+"\n"+
                     "--------------------"+"\n"+
                     "Symbol : "+" "+Symbol()+" \n"+
                     "Period : "+" "+"Trend Movers"+" \n"+
                     "Time and Date : "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+" \n"+
                     "Broker : "+" "+AccountCompany()+"\n"+
                     "Account # : "+" "+IntegerToString(AccountNumber(),0,0));
           }

         if(Notification_Allow)
           {
            SendNotification(Symbol()+" "+"Trend Movers"+"\n"+
                             "New Signal: STRONG BUY FOR PAIR "+Symbol()+"  "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+"  "+AccountCompany());
           }
        }
     }
   else if(iClose(Symbol(),0,1)>h15 && iClose(Symbol(),0,1)<h120)
     {
      ObjectSetText("texti","WEAK BUY SIGNAL,WAIT OR BUY!",10,"Times New Roman",Green);
      if(tmp<Time[0])
        {
         tmp=Time[0];

         if(Alert_Allow)
           {
            string AlertMsgSB="TREND MOVERS (ALERT)"+"\n"+AccountName()+"\n"+"WEAK BUY SIGNAL FOR PAIR,WAIT OR BUY! - "+Symbol();
            Alert(AlertMsgSB);
           }
         if(Email_Allow)
           {
            SendMail(AccountName()+Symbol()+" - "+AccountCompany(),
                     //"New Bar :  " + "Alert  \n" +
                     "WEAK BUY SIGNAL FOR PAIR,WAIT OR BUY!"+"\n"+
                     "--------------------"+"\n"+
                     "Symbol : "+" "+Symbol()+" \n"+
                     "Period : "+" "+"Trend Movers"+" \n"+
                     "Time and Date : "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+" \n"+
                     "Broker : "+" "+AccountCompany()+"\n"+
                     "Account # : "+" "+IntegerToString(AccountNumber(),0,0));
           }

         if(Notification_Allow)
           {
            SendNotification(Symbol()+" "+"Trend Movers"+"\n"+
                             "New Signal: WEAK BUY SIGNAL FOR PAIR,WAIT OR BUY! "+Symbol()+"  "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+"  "+AccountCompany());
           }
        }
     }
   else if(iClose(Symbol(),0,0)<h15 && iClose(Symbol(),0,0)<h120)
     {
      ObjectSetText("texti","STRONG SELL",10,"Times New Roman",Red);
      if(tmp<Time[0])
        {
         tmp=Time[0];

         if(Alert_Allow)
           {
            string AlertMsgSB="TREND MOVERS (ALERT)"+"\n"+AccountName()+"\n"+"STRONG SELL FOR PAIR - "+Symbol();
            Alert(AlertMsgSB);
           }
         if(Email_Allow)
           {
            SendMail(AccountName()+Symbol()+" - "+AccountCompany(),
                     //"New Bar :  " + "Alert  \n" +
                     "STRONG SELL FOR PAIR"+"\n"+
                     "--------------------"+"\n"+
                     "Symbol : "+" "+Symbol()+" \n"+
                     "Period : "+" "+"Trend Movers"+" \n"+
                     "Time and Date : "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+" \n"+
                     "Broker : "+" "+AccountCompany()+"\n"+
                     "Account # : "+" "+IntegerToString(AccountNumber(),0,0));
           }

         if(Notification_Allow)
           {
            SendNotification(Symbol()+" "+"Trend Movers"+"\n"+
                             "New Signal: STRONG SELL FOR PAIR "+Symbol()+"  "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+"  "+AccountCompany());
           }
        }
     }
   else if(iClose(Symbol(),0,0)<h15 && iClose(Symbol(),0,0)>h120)
     {
      ObjectSetText("texti","WEAK SELL SIGNAL FOR PAIR,WAIT OR SELL!",10,"Times New Roman",Red);
      if(tmp<Time[0])
        {
         tmp=Time[0];

         if(Alert_Allow)
           {
            string AlertMsgSB="TREND MOVERS (ALERT)"+"\n"+AccountName()+"\n"+"WEAK SELL SIGNAL FOR PAIR,WAIT OR SELL! - "+Symbol();
            Alert(AlertMsgSB);
           }
         if(Email_Allow)
           {
            SendMail(AccountName()+Symbol()+" - "+AccountCompany(),
                     //"New Bar :  " + "Alert  \n" +
                     "WEAK SELL SIGNAL FOR PAIR,WAIT OR SELL!"+"\n"+
                     "--------------------"+"\n"+
                     "Symbol : "+" "+Symbol()+" \n"+
                     "Period : "+" "+"Trend Movers"+" \n"+
                     "Time and Date : "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+" \n"+
                     "Broker : "+" "+AccountCompany()+"\n"+
                     "Account # : "+" "+IntegerToString(AccountNumber(),0,0));
           }

         if(Notification_Allow)
           {
            SendNotification(Symbol()+" "+"Trend Movers"+"\n"+
                             "New Signal: WEAK SELL SIGNAL FOR PAIR,WAIT OR SELL! "+Symbol()+"  "+TimeToStr(TimeCurrent(),TIME_SECONDS)+"  "+TimeToStr(TimeCurrent(),TIME_DATE)+"  "+AccountCompany());
           }
        }
     }
   else
     {
      ObjectSetText("texti","PLEASE WAIT FOR RIGHT DECISION",10,"Times New Roman",Black);
     }
   return(0);
  }
//+---------------------------------------------------------------+
