//+------------------------------------------------------------------+
//|                                            ShowOrdersOnChart.mq4 |
//|                                                       Rukuki_Ake |
//|                                                http://firefun.ru |
//+------------------------------------------------------------------+


#property copyright "Rukuki_Ake"
#property link      "http://firefun.ru"
#property indicator_chart_window

     int iOrdersTotal = 0;
     int iOpenedOrders = 0;        // количество открытых ордеров по данному инструменту
     int aOpenedOrderTypes[];
  string aOpenedOrderSymbols[];
datetime aOpenedOrderOpenTimes[];
  double aOpenedOrderOpenPrices[];
     int aOpenedOrderTickets[];
  double aOpenedOrderProfits[];
  double aOpenedOrderSwaps[];  
  double aOpenedOrderLots[];    
  
     int iOrdersHistoryTotal = 0;
     int iClosedOrders = 0;
     int aClosedOrderTypes[];
  string aClosedOrderSymbols[];
datetime aClosedOrderOpenTimes[];
datetime aClosedOrderCloseTimes[];
  double aClosedOrderOpenPrices[];
  double aClosedOrderClosePrices[];
     int aClosedOrderTickets[];
  double aClosedOrderProfits[];     
  double aClosedOrderSwaps[];
  double aClosedOrderLots[];  

  string sSymbol;


int init()  {  sSymbol = Symbol();  }
int deinit()  {  fDeleteOrderObjects ();  }



void fInitOrders(bool bAll=true)  {
    int iOrderType;
    int iCounter = 0;
    string sOrderSymbol;


    /* ќткрытые ордера */

    iOrdersTotal=OrdersTotal();
    if  (iOpenedOrders>0)  {
        ArrayResize(aOpenedOrderTypes,0);
        ArrayResize(aOpenedOrderSymbols,0);
        ArrayResize(aOpenedOrderOpenTimes,0);
        ArrayResize(aOpenedOrderOpenPrices,0);
        ArrayResize(aOpenedOrderTickets,0);
        ArrayResize(aOpenedOrderProfits,0);        
        ArrayResize(aOpenedOrderSwaps,0);                
        ArrayResize(aOpenedOrderLots,0);
        iOpenedOrders=0;
    }
    for(int i=0;i<iOrdersTotal;i++)
        if (OrderSelect(i,SELECT_BY_POS)==true)  {
            iOrderType=OrderType();
            sOrderSymbol=OrderSymbol();
            if (sOrderSymbol==sSymbol && (iOrderType == OP_BUY || iOrderType == OP_SELL))  {
                iOpenedOrders++;
                ArrayResize(aOpenedOrderTypes,iOpenedOrders);
                ArrayResize(aOpenedOrderSymbols,iOpenedOrders);
                ArrayResize(aOpenedOrderOpenTimes,iOpenedOrders);
                ArrayResize(aOpenedOrderOpenPrices,iOpenedOrders);
                ArrayResize(aOpenedOrderTickets,iOpenedOrders);            
                ArrayResize(aOpenedOrderProfits,iOpenedOrders);
                ArrayResize(aOpenedOrderSwaps,iOpenedOrders);                
                ArrayResize(aOpenedOrderLots,iOpenedOrders);                                
                aOpenedOrderTypes[iOpenedOrders-1]=iOrderType;
                aOpenedOrderSymbols[iOpenedOrders-1]=sOrderSymbol;
                aOpenedOrderOpenTimes[iOpenedOrders-1]=OrderOpenTime();
                aOpenedOrderOpenPrices[iOpenedOrders-1]=OrderOpenPrice();
                aOpenedOrderTickets[iOpenedOrders-1]=OrderTicket();                
                aOpenedOrderProfits[iOpenedOrders-1]=OrderProfit();
                aOpenedOrderSwaps[iOpenedOrders-1]=OrderSwap();                
                aOpenedOrderLots[iOpenedOrders-1]=OrderLots();                                
            }

        }



    /* «акрытые ордера */
    if (bAll)  {
        iOrdersHistoryTotal=OrdersHistoryTotal();
        if  (iClosedOrders>0)  {
            ArrayResize(aClosedOrderTypes,0);
            ArrayResize(aClosedOrderSymbols,0);
            ArrayResize(aClosedOrderOpenTimes,0);
            ArrayResize(aClosedOrderCloseTimes,0);        
            ArrayResize(aClosedOrderOpenPrices,0);
            ArrayResize(aClosedOrderClosePrices,0);        
            ArrayResize(aClosedOrderTickets,0);
            ArrayResize(aClosedOrderProfits,0);        
            ArrayResize(aClosedOrderSwaps,0);
            ArrayResize(aClosedOrderLots,0);        
            iClosedOrders=0;
        }
        for(int j=0;j<iOrdersHistoryTotal;j++)
            if (OrderSelect(j,SELECT_BY_POS,MODE_HISTORY)==true)  {
                iOrderType=OrderType();
                sOrderSymbol=OrderSymbol();
                if (sOrderSymbol==sSymbol && (iOrderType == OP_BUY || iOrderType == OP_SELL))  {
                    iClosedOrders++;
                    ArrayResize(aClosedOrderTypes,iClosedOrders);
                    ArrayResize(aClosedOrderSymbols,iClosedOrders);
                    ArrayResize(aClosedOrderOpenTimes,iClosedOrders);
                    ArrayResize(aClosedOrderCloseTimes,iClosedOrders);                
                    ArrayResize(aClosedOrderOpenPrices,iClosedOrders);
                    ArrayResize(aClosedOrderClosePrices,iClosedOrders);                
                    ArrayResize(aClosedOrderTickets,iClosedOrders);            
                    ArrayResize(aClosedOrderProfits,iClosedOrders);                            
                    ArrayResize(aClosedOrderSwaps,iClosedOrders);
                    ArrayResize(aClosedOrderLots,iClosedOrders);                
                    aClosedOrderTypes[iClosedOrders-1]=iOrderType;
                    aClosedOrderSymbols[iClosedOrders-1]=sOrderSymbol;
                    aClosedOrderOpenTimes[iClosedOrders-1]=OrderOpenTime();
                    aClosedOrderCloseTimes[iClosedOrders-1]=OrderCloseTime();                
                    aClosedOrderOpenPrices[iClosedOrders-1]=OrderOpenPrice();
                    aClosedOrderClosePrices[iClosedOrders-1]=OrderClosePrice();                
                    aClosedOrderTickets[iClosedOrders-1]=OrderTicket();                
                    aClosedOrderProfits[iClosedOrders-1]=OrderProfit();                                
                    aClosedOrderSwaps[iClosedOrders-1]=OrderSwap();
                    aClosedOrderLots[iClosedOrders-1]=OrderLots();
                
                }

            }
    }     
}



void fDrawOrders(bool bAll=true)  {
    for(int i=0;i<iOpenedOrders;i++)  {               
        ObjectCreate("rukukiLine"+(string)aOpenedOrderTickets[i],OBJ_VLINE,0,aOpenedOrderOpenTimes[i],0,0,0,0,0);
        ObjectSet("rukukiLine"+(string)aOpenedOrderTickets[i],OBJPROP_BACK,true);
        ObjectSet("rukukiLine"+(string)aOpenedOrderTickets[i],OBJPROP_STYLE,STYLE_DASHDOTDOT);               

        ObjectCreate("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJ_ARROW,0,aOpenedOrderOpenTimes[i],aOpenedOrderOpenPrices[i]);
        if (aOpenedOrderTypes[i] == OP_BUY)  {
            ObjectSet("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJPROP_ARROWCODE,1);
            ObjectSetText("rukukiLine"+(string)aOpenedOrderTickets[i],
                           StringConcatenate("\nBuy ",aOpenedOrderOpenPrices[i]," ", TimeToStr(aOpenedOrderOpenTimes[i],TIME_SECONDS),"\nEquity: ",
                           (MarketInfo(aOpenedOrderSymbols[i],MODE_BID)-aOpenedOrderOpenPrices[i])/
                           MarketInfo(aOpenedOrderSymbols[i],MODE_POINT)*
                           MarketInfo(aOpenedOrderSymbols[i],MODE_TICKVALUE)*aOpenedOrderLots[i]+
                           aOpenedOrderSwaps[i],"\n"));
        }  else  {
            ObjectSet("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJPROP_ARROWCODE,2);
            ObjectSetText("rukukiLine"+(string)aOpenedOrderTickets[i],
                           StringConcatenate("\nSell ",aOpenedOrderOpenPrices[i]," ", TimeToStr(aOpenedOrderOpenTimes[i],TIME_SECONDS),"\nEquity: ",
                           (aOpenedOrderOpenPrices[i]-MarketInfo(aOpenedOrderSymbols[i],MODE_ASK))/
                           MarketInfo(aOpenedOrderSymbols[i],MODE_POINT)*
                           MarketInfo(aOpenedOrderSymbols[i],MODE_TICKVALUE)*aOpenedOrderLots[i]+
                           aOpenedOrderSwaps[i],"\n"));              

        }    
        ObjectSet("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJPROP_BACK,false);

        if ((aOpenedOrderProfits[i]+aOpenedOrderSwaps[i])>=0)  {
            ObjectSet("rukukiLine"+(string)aOpenedOrderTickets[i],OBJPROP_COLOR,Green);        
            ObjectSet("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJPROP_COLOR,Green);
        }  else  {
            ObjectSet("rukukiLine"+(string)aOpenedOrderTickets[i],OBJPROP_COLOR,Maroon);        
            ObjectSet("rukukiArrow"+(string)aOpenedOrderTickets[i],OBJPROP_COLOR,Maroon);
        }
    }
    
    if (bAll)  {
        for(int j=0;j<iClosedOrders;j++)  {               
            ObjectCreate("rukukiLine"+(string)aClosedOrderTickets[j],OBJ_VLINE,0,aClosedOrderOpenTimes[j],0,0,0,0,0);
            ObjectSet("rukukiLine"+(string)aClosedOrderTickets[j],OBJPROP_BACK,true);
            ObjectSet("rukukiLine"+(string)aClosedOrderTickets[j],OBJPROP_STYLE,STYLE_DASHDOTDOT);               
    
            ObjectCreate("rukukiArrow"+(string)aClosedOrderTickets[j],OBJ_ARROW,0,aClosedOrderOpenTimes[j],aClosedOrderOpenPrices[j]);
            if (aClosedOrderTypes[j] == OP_BUY)  {
                ObjectSet("rukukiArrow"+(string)aClosedOrderTickets[j],OBJPROP_ARROWCODE,1);
                ObjectSetText("rukukiLine"+(string)aClosedOrderTickets[j],
                               StringConcatenate("\nBuy ",aClosedOrderOpenPrices[j]," ", TimeToStr(aClosedOrderOpenTimes[j],TIME_SECONDS),
                               "\nClose ", aClosedOrderClosePrices[j]," ", TimeToStr(aClosedOrderCloseTimes[j],TIME_SECONDS) ,"\nBalance: ",
                               (aClosedOrderClosePrices[j]-aClosedOrderOpenPrices[j])/
                               MarketInfo(aClosedOrderSymbols[j],MODE_POINT)*
                               MarketInfo(aClosedOrderSymbols[j],MODE_TICKVALUE)*aClosedOrderLots[j]+
                               aClosedOrderSwaps[j],"\n"));            
            }  else  {
                ObjectSet("rukukiArrow"+(string)aClosedOrderTickets[j],OBJPROP_ARROWCODE,2);
                ObjectSetText("rukukiLine"+(string)aClosedOrderTickets[j],
                               StringConcatenate("\nSell ",aClosedOrderOpenPrices[j]," ", TimeToStr(aClosedOrderOpenTimes[j],TIME_SECONDS),
                               "\nClose ", aClosedOrderClosePrices[j]," ", TimeToStr(aClosedOrderCloseTimes[j],TIME_SECONDS) ,"\nBalance: ",
                               (aClosedOrderOpenPrices[j]-aClosedOrderClosePrices[j])/
                               MarketInfo(aClosedOrderSymbols[j],MODE_POINT)*
                               MarketInfo(aClosedOrderSymbols[j],MODE_TICKVALUE)*aClosedOrderLots[j]+
                               aClosedOrderSwaps[j],"\n"));              
            }    
            ObjectSet("rukukiArrow"+(string)aClosedOrderTickets[j],OBJPROP_BACK,false);
        
            ObjectCreate("rukukiX"+(string)aClosedOrderTickets[j],OBJ_ARROW,0,aClosedOrderOpenTimes[j],aClosedOrderClosePrices[j]);
            ObjectSet("rukukiX"+(string)aClosedOrderTickets[j],OBJPROP_ARROWCODE,3);
            ObjectSet("rukukiX"+(string)aClosedOrderTickets[j],OBJPROP_BACK,false);

            if ((aClosedOrderProfits[j]+aClosedOrderSwaps[j])>=0)  {
                ObjectSet("rukukiLine"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Green);        
                ObjectSet("rukukiArrow"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Green);
                ObjectSet("rukukiX"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Lime);            
            }  else  {
                ObjectSet("rukukiLine"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Maroon);        
                ObjectSet("rukukiArrow"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Maroon);
                ObjectSet("rukukiX"+(string)aClosedOrderTickets[j],OBJPROP_COLOR,Red);
            }        

        }
    }
}


void fDeleteOrderObjects (bool bAll = true)  {
    for(int i=0;i<iOpenedOrders;i++)  {
        ObjectDelete("rukukiLine"+(string)aOpenedOrderTickets[i]);
        ObjectDelete("rukukiArrow"+(string)aOpenedOrderTickets[i]);
    }
    
    
    if (bAll)  {
        for(int j=0;j<iClosedOrders;j++)  {
            ObjectDelete("rukukiLine"+(string)aClosedOrderTickets[j]);
            ObjectDelete("rukukiArrow"+(string)aClosedOrderTickets[j]);
            ObjectDelete("rukukiX"+(string)aClosedOrderTickets[j]);        
        }
    }    
   
}



int start()  {
        
    if(iOrdersTotal != OrdersTotal() || iOrdersHistoryTotal != OrdersHistoryTotal())  {
        fDeleteOrderObjects(true);
        fInitOrders(true);
        fDrawOrders(true);
    }  else  {
        fDeleteOrderObjects(false);
        fInitOrders(false);
        fDrawOrders(false);
    }
    
    
    return(0);
}
//+------------------------------------------------------------------+