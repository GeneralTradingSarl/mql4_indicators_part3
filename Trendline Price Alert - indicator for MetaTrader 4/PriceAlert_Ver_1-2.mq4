//+------------------------------------------------------------------+
//|                                                   PriceAlert.mq4 |
//|                                          Copyright © M00SE  2011 |
//|                                                                  |
//|                   P R I C E    A L E R T                         |
//|                                                                  |
//| This indicator will draw two trendlines on the chart upon which  |
//| it is placed. The trendlines, which may be moved around, act as  |
//| upper and lower alert levels. When the mid-price crosses either  |
//| level the warning alert will be triggered.                       |
//|                                                                  |
//| Version 1.2 - 25 Jul 2011                                        |
//| Added mode flag to get only a single alert per time bar          |
//| Added email flag to send email as well as audio/visual alert     |
//| Added flag to select line type (trendline or horizontal)         |
//| Added setting to specify line width                              |
//| Added TidyOnExit flag to remove trendlines from chart upon exit  |
//|                                                                  |
//| Version 1 - 16 Jun 2011                                          |
//|                                                                  |
//|                                                                  |
//| Instructions                                                     |
//|                                                                  |
//| Choose the symbol you're interested in and display it in a chart |
//| window at the appropriate timeframe. Load PriceAlert Indicator   |
//| and optionally choose desired colour for each trendline.         |
//| Optionally set flag to receive single or multiple alerts per     |
//| time bar and flag to send email with each alert. (You must have  |
//| previously configured your email details.)                       |
//| Reposition the trendlines to the level at which you wish to be   |
//| notified should the mid-price get there.                         |
//| Remember to have your speakers on!                               |
//|                                                                  |
//| That's it!                                                       |
//| Hope you like it, MOOSE.                                         |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright © M00SE  2011"

#property indicator_chart_window

//---- input parameters
extern color  UpperColour = Blue;
extern color  LowerColour = Red;
extern int LineWidth = 2;
extern string NoteDrawTrendline = "true=trendline; false=horizontal line";
extern bool DrawTrendline = true;
extern bool SendEmail = false;
extern string NoteSingleAlert = "true ==> only one hi/lo alert per bar";
extern bool SingleAlertMode = true;
extern bool TidyOnExit = false;

//---- data
static int prevTime = 0;
static double prevPrice;
string upperName = "Upper Alert";
string lowerName = "Lower Alert";
double hiAlert;
double loAlert;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   prevTime = Time[0];
   prevPrice = ((Ask + Bid) / 2.0);

   double   topPrice =     WindowPriceMax() - (WindowPriceMax() - WindowPriceMin())*0.2;
   double   bottomPrice =  WindowPriceMax() - (WindowPriceMax() - WindowPriceMin())*0.8;

   if(DrawTrendline)
   {
      SetTrendlineObject(upperName, Time[30], topPrice, Time[0], topPrice, UpperColour);
      SetTrendlineObject(lowerName, Time[30], bottomPrice, Time[0], bottomPrice, LowerColour);
   }
   else
   {
      SetHorizlineObject(upperName, topPrice, UpperColour);
      SetHorizlineObject(lowerName, bottomPrice, LowerColour);
   }
//----

return(0);
  }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
   //---- Avoid deleting these upper and lower alert trendlines so they are not lost if chart is reloaded (unless flag is set)
   if(TidyOnExit)
   {
      ObjectDelete(upperName);
      ObjectDelete(lowerName);
   }
   
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   string alertMsg = "";
   double midPrice = ((Ask + Bid) / 2.0);
   static bool lowerAlertLatch = false;
   static bool upperAlertLatch = false;

   if(prevTime != Time[0])
   {
      //Print("NewTimeFrame=", TimeToStr(Time[0]));
      lowerAlertLatch = false;
      upperAlertLatch = false;

      prevTime = Time[0];
   }
   
   hiAlert = 0.0;
   if(ObjectFind(upperName) == 0)
   {
      if(DrawTrendline) 
         hiAlert = NormalizeDouble(ObjectGetValueByShift(upperName,0),Digits);
      else
         hiAlert = NormalizeDouble(ObjectGet(upperName, OBJPROP_PRICE1),Digits);
   }
 
   loAlert = 0.0;
   if(ObjectFind(lowerName) == 0)
   {
      if(DrawTrendline) 
         loAlert = NormalizeDouble(ObjectGetValueByShift(lowerName,0),Digits);
      else
         loAlert = NormalizeDouble(ObjectGet(lowerName, OBJPROP_PRICE1),Digits);
   }
    
   if(hiAlert > 0.0 && prevPrice < hiAlert && midPrice > hiAlert)
   {
      //Print("hi alert cond");
      if(!upperAlertLatch || !SingleAlertMode)
      {   
         alertMsg = "Upper Level " + Symbol() + " " + DoubleToStr(midPrice, Digits);
         Alert(alertMsg);
    	   if (SendEmail) SendMail("Upper Alert on " + Symbol(), alertMsg);
    	   upperAlertLatch = true;
    	}
   }
      
   if(loAlert > 0.0 && prevPrice > loAlert && midPrice < loAlert)
   {
      //Print("lo alert cond");
      if(!lowerAlertLatch || !SingleAlertMode)
      {
         alertMsg = "Lower Level " + Symbol() + " " + DoubleToStr(midPrice, Digits);
         Alert(alertMsg);
    	   if (SendEmail) SendMail("Lower Alert on " + Symbol(), alertMsg);
    	   lowerAlertLatch = true;
    	}
   }
               
/*   
 * Print("mid=" + DoubleToStr( midPrice, Digits)  
 *             + " prev=" + prevPrice 
 *             + " hi=" + hiAlert 
 *             + " lo=" + loAlert);   
*/                         
   prevPrice = midPrice;  
   return(0);
}

//+------------------------------------------------------------------+
//| SetTrendlineObject                                               |
//+------------------------------------------------------------------+
void SetTrendlineObject(string name, datetime T1, double P1, datetime T2, double P2, color colour)
{
   if(ObjectFind(name) == -1)
   {
     ObjectCreate(name, OBJ_TREND, 0, T1, P1, T2, P2);
     ObjectSet(name, OBJPROP_COLOR, colour);
     ObjectSet(name, OBJPROP_BACK, false);
     ObjectSet(name, OBJPROP_WIDTH, LineWidth);  
   }
}

//+------------------------------------------------------------------+
//| SetHorizlineObject                                               |
//+------------------------------------------------------------------+
void SetHorizlineObject(string name, double P1, color colour)
{
   if(ObjectFind(name) == -1)
   {
     ObjectCreate(name, OBJ_HLINE, 0, 0, P1);
     ObjectSet(name, OBJPROP_COLOR, colour);
     ObjectSet(name, OBJPROP_BACK, false);
     ObjectSet(name, OBJPROP_WIDTH, LineWidth);
   }
}
  
//+------------------------------------------------------------------+

