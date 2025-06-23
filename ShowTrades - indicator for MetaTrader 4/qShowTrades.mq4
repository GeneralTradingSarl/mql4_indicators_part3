//+------------------------------------------------------------------+
//|                                                   ShowTrades.mq4 |
//|                                 Copyright © 2011, Thomas Quester |
//|                                                 www.mt4expert.de |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Thomas Quester"
#property link      "www.mt4expert.de"
#property indicator_chart_window

bool   gTimeDemo=false;
int    gDemoDate=1;
int    gDemoMonth=1;
int    gDemoYear=2018;
int    gOldCnt=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   gOldCnt=0;
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int cnt;
   int i,typ;
   /*if(gTimeDemo)
     {
      int t,m,y;
      t = TimeDay(Time[0]);
      m = TimeMonth(Time[0]);
      y = TimeYear(Time[0]);
      if(y>=gDemoYear && 
         m >= gDemoMonth &&
         t >= gDemoDate)
         return(0);
     }*/

   cnt=OrdersHistoryTotal();
   if(cnt!=gOldCnt)
     {
      gOldCnt=cnt;
      Print("ShowTraces start");

      string name;
      datetime ostart,oend;
      double   open,close;

      Print("cnt = "+cnt);
      for(i=0;i<15000;i++)
        {

         ObjectDelete("trades_"+i);
        }

      for(i=0;i<cnt;i++)
        {
         Print("Order 1 = "+OrderSymbol());
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) break;
         if(OrderSymbol()==Symbol())
           {
            typ=OrderType();
            if(typ==OP_BUY || typ==OP_SELL)
              {
               ostart = OrderOpenTime();
               oend   = OrderCloseTime();
               open   = OrderOpenPrice();
               close  = OrderClosePrice();
               Print("o=",ostart," ",open," ",oend," ",close);
               ObjectCreate("trades_"+i,OBJ_TREND,0,ostart,open,oend,close);
               ObjectSet("trades_"+i,OBJPROP_RAY,false);
               if(OrderProfit()>0)
                  ObjectSet("trades_"+i,OBJPROP_COLOR,Green);
               else
                  ObjectSet("trades_"+i,OBJPROP_COLOR,Red);

               name="";

               switch(typ)
                 {
                  case OP_BUY: name="buy"; break;
                  case OP_SELL: name="sell"; break;
                  case OP_BUYSTOP: name="buystop"; break;
                  case OP_SELLSTOP: name="sellstop"; break;
                 }
               name=name+" "+open;
               ObjectSetText("trades_"+i,name,10,"Times New Roman",Green);
               if(typ==OP_SELL)
                  ObjectSet("trades_"+i,OBJPROP_STYLE,STYLE_DASH);
               ObjectSet("trades_"+i,OBJPROP_WIDTH,2);
              }
           }
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
