//===========================================================================================================================//
// Author VOLDEMAR227 site WWW.TRADING-GO.RU      SKYPE: TRADING-GO          e-mail: TRADING-GO@List.ru
// Our group http:http://vk.com/club43661961
// News, questions and answers, help, and a lot of interesting)))
//===========================================================================================================================//
#property copyright "Copyright © 2012, WWW.TRADING-GO.RU ."
#property link      "http://WWW.TRADING-GO.RU"
//===========================================================================================================================//
#property indicator_chart_window
extern color ProfitLine = Green ;  // input parameters
extern color StopLine = Red ;
extern int   FontSize =8;
color OpenLine;

string text = "";
int start()
  {
//--------------------------------------------------------------------------------------------------------------
   ObjectCreate("R",OBJ_LABEL,0,0,0);
   ObjectSet("R",OBJPROP_CORNER,2);
   ObjectSet("R",OBJPROP_XDISTANCE,10);
   ObjectSet("R",OBJPROP_YDISTANCE,10);
   ObjectSetText("R","WWW.TRADING-GO.RU ",10,"Arial",Red);
//--------------------------------------------------------------------------------------------------------------
   double cen=MarketInfo(Symbol(),MODE_TICKVALUE); // Request of one point in the currency of the deposit for 1 lot
   int total=OrdersTotal();                        
   for (int oi=total-1; oi>=0; oi--)               // bust warrants 
   {
    if(OrderSelect(oi,SELECT_BY_POS))              // analysis warrants            
    {
    if(OrderSymbol()==Symbol())                    // Only on our symbol
    {
     if (OrderType() == OP_BUY      ){text = "Buy"      ; OpenLine=Blue;}  //determine the type of order
     if (OrderType() == OP_SELL     ){text = "Sell"     ; OpenLine=Red ;}
     if (OrderType() == OP_BUYSTOP  ){text = "BuyStop"  ; OpenLine=Blue;}
     if (OrderType() == OP_SELLSTOP ){text = "SellStop" ; OpenLine=Red ;}
     if (OrderType() == OP_BUYLIMIT ){text = "BuyLimit" ; OpenLine=Blue;}
     if (OrderType() == OP_SELLLIMIT){text = "SellLimit"; OpenLine=Red ;}  
    double RB;
    if ((OrderType()==OP_BUY ||OrderType  ()==OP_BUYLIMIT ||OrderType  ()==OP_BUYSTOP ))
    {
    RB = (OrderTakeProfit()-OrderOpenPrice())/(OrderOpenPrice()-OrderStopLoss()); // Calculation of ratio (ratio) for purchases
    }
    if ((OrderType()==OP_SELL ||OrderType  ()==OP_SELLSTOP ||OrderType  ()==OP_SELLLIMIT ))
    {
    RB = (OrderOpenPrice()-OrderTakeProfit())/(OrderStopLoss()-OrderOpenPrice()); // Calculation of ratio (ratio) for sales
    }    
//--------------------------------------------------------------------------------------------------------------
    ObjectCreate ("Line"+OrderTicket(), OBJ_HLINE, 0, 0,0);
    ObjectSet    ("Line"+OrderTicket(),OBJPROP_PRICE1,OrderOpenPrice()); // Draw a line on the opening price
    ObjectSet    ("Line"+OrderTicket(),OBJPROP_COLOR,OpenLine); 
    
    ObjectCreate ("text_object"+OrderTicket(), OBJ_TEXT, 0, OrderOpenTime(),OrderOpenPrice());// write text on the opening price
    ObjectSetText("text_object"+OrderTicket(),text+" = "+DoubleToStr(OrderLots(),2)+" Profit  "+DoubleToStr(OrderProfit(),2)+"   Ratio  1 : "+DoubleToStr(RB,2)+ "  Magic "+DoubleToStr(OrderMagicNumber(),0),FontSize,"Arial", OpenLine);
    ObjectSet    ("text_object"+OrderTicket(),OBJPROP_PRICE1,OrderOpenPrice());   
//--------------------------------------------------------------------------------------------------------------
    if (OrderTakeProfit()>0)   // Draw a line if there is a take profit
    {
    ObjectCreate ("Linet"+OrderTicket(), OBJ_HLINE, 0, 0,0);
    ObjectSet    ("Linet"+OrderTicket(),OBJPROP_PRICE1,OrderTakeProfit());
    ObjectSet    ("Linet"+OrderTicket(),OBJPROP_COLOR,ProfitLine); 
    }
    if (OrderStopLoss()>0)    // Draw a line if there is a stop loss
    {
    ObjectCreate ("Lines"+OrderTicket(), OBJ_HLINE, 0, 0,0);
    ObjectSet    ("Lines"+OrderTicket(),OBJPROP_PRICE1,OrderStopLoss());
    ObjectSet    ("Lines"+OrderTicket(),OBJPROP_COLOR,StopLine);    
    } 
//--------------------------------------------------------------------------------------------------------------      
    if (OrderTakeProfit()>0 && (OrderType()==OP_BUY ||OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT))
    {     
    double razt = (OrderTakeProfit()-OrderOpenPrice())*cen*OrderLots()/Point; // Counting the amount of profit for purchases
    
    ObjectCreate ("text_object1"+OrderTicket(), OBJ_TEXT, 0, OrderOpenTime(),OrderTakeProfit());// Write the text on the line
    ObjectSetText("text_object1"+OrderTicket(),"Punkt "+DoubleToStr((OrderTakeProfit()-OrderOpenPrice())/Point,0)+" Summ +"+DoubleToStr(razt,2)+" "+AccountCurrency(),FontSize,"Arial", ProfitLine);
    ObjectSet    ("text_object1"+OrderTicket(),OBJPROP_PRICE1,OrderTakeProfit());      
    } 
    if (OrderTakeProfit()>0 && (OrderType()==OP_SELL|| OrderType()==OP_SELLSTOP||OrderType()==OP_SELLLIMIT ))
    {     
    double razs = (OrderOpenPrice()-OrderTakeProfit())*cen*OrderLots()/Point; // Counting the amount of profit to sales
    
    ObjectCreate ("text_object2"+OrderTicket(), OBJ_TEXT, 0, OrderOpenTime(),OrderTakeProfit());//Write the text on the line
    ObjectSetText("text_object2"+OrderTicket(),"Punkt "+DoubleToStr((OrderOpenPrice()-OrderTakeProfit())/Point,0)+" Summ +"+DoubleToStr(razs,2)+" "+AccountCurrency(),FontSize,"Arial", ProfitLine);
    ObjectSet    ("text_object2"+OrderTicket(),OBJPROP_PRICE1,OrderTakeProfit());      
    }   
//--------------------------------------------------------------------------------------------------------------
    if (OrderStopLoss()>0 && (OrderType()==OP_BUY ||OrderType()==OP_BUYSTOP ||OrderType()==OP_BUYLIMIT))
    {     
    double razts = (OrderOpenPrice()-OrderStopLoss())*cen*OrderLots()/Point; //Consider the amount of loss for shopping
    
    ObjectCreate ("text_object3"+OrderTicket(), OBJ_TEXT, 0, OrderOpenTime(),OrderStopLoss());//Write the text on the line
    ObjectSetText("text_object3"+OrderTicket(),"Punkt "+DoubleToStr((OrderOpenPrice()-OrderStopLoss())/Point,0)+" Summ -"+DoubleToStr(razts,2)+" "+AccountCurrency(),FontSize,"Arial", StopLine);
    ObjectSet    ("text_object3"+OrderTicket(),OBJPROP_PRICE1,OrderStopLoss());      
    } 
    if (OrderStopLoss()>0 && (OrderType()==OP_SELL|| OrderType()==OP_SELLSTOP||OrderType()==OP_SELLLIMIT ))
    {     
    double razsm = (OrderStopLoss()-OrderOpenPrice())*cen*OrderLots()/Point; //Consider the amount of loss for shopping
    
    ObjectCreate ("text_object4"+OrderTicket(), OBJ_TEXT, 0, OrderOpenTime(),OrderStopLoss());// Write the text on the line
    ObjectSetText("text_object4"+OrderTicket(),"Punkt "+DoubleToStr((OrderStopLoss()-OrderOpenPrice())/Point,0)+" Summ -"+DoubleToStr(razsm,2)+" "+AccountCurrency(),FontSize,"Arial", StopLine);
    ObjectSet    ("text_object4"+OrderTicket(),OBJPROP_PRICE1,OrderStopLoss());      
    } 
//--------------------------------------------------------------------------------------------------------------    
    if (OrderStopLoss()==0) // If you do not remove the stop loss line and text
    {
    ObjectDelete("Lines"+OrderTicket());
    ObjectDelete("text_object3"+OrderTicket());    
    ObjectDelete("text_object4"+OrderTicket());    
    } 
    if (OrderTakeProfit()==0)// If you do not take profit line and delete text
    {
    ObjectDelete("Linet"+OrderTicket());
    ObjectDelete("text_object1"+OrderTicket());    
    ObjectDelete("text_object2"+OrderTicket());    
    }}}}
//--------------------------------------------------------------------------------------------------------------    
int      totalh=OrdersHistoryTotal();
  for (int d=totalh-1; d>=0; d--)            //Removing objects fulfilled orders
   {
    if(OrderSelect(d, SELECT_BY_POS,MODE_HISTORY))
     {
          ObjectDelete("text_object"+OrderTicket()); 
          ObjectDelete("Line"+OrderTicket());
          ObjectDelete("Lines"+OrderTicket());  
          ObjectDelete("Linet"+OrderTicket());         
          ObjectDelete("text_object1"+OrderTicket());
          ObjectDelete("text_object2"+OrderTicket());
          ObjectDelete("text_object3"+OrderTicket());
          ObjectDelete("text_object4"+OrderTicket());          
       }
     }    
   return(0);
  }
//--------------------------------------------------------------------------------------------------------------