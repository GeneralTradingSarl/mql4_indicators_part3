//+------------------------------------------------------------------+
//|                                                    wajdi avg.mq4 |
//|                                           Copyright 2007 Wajdyss |
//|                                              wajdyss@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2007 Wajdyss"
#property link      "wajdyss@hotmail.com"

#property indicator_chart_window
extern int days=360;
extern int TextSize=14;
 extern color TextColor1=Black;
 extern color TextColor2=Red;
 extern color TextColor3=Blue;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
Comment("");
 ObjectDelete("a label");
 ObjectDelete("b label");
 ObjectDelete("c label");
 ObjectDelete("d label");
 ObjectDelete("e label");
//----
   
//----
 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  // a
          if(ObjectFind("a label") != 0)
   {
      ObjectCreate("a label", OBJ_LABEL, 0,0,0);
      ObjectSetText("a label","ÈÓã Çááå ÇáÑÍãä ÇáÑÍíã" , TextSize, "Arial", TextColor1);
      ObjectSet("a label", OBJPROP_XDISTANCE,350);
     ObjectSet("a label", OBJPROP_YDISTANCE,0);
   }
   else
   {
   ObjectMove("a label", 0,  0,0);
   }
   
   //b
      if(ObjectFind("b label") != 0)
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label","wajdyss information indicator"  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,305);
     ObjectSet("b label", OBJPROP_YDISTANCE,25);
   }
   else
   {
   ObjectMove("b label", 0,  0,0);
   }
   
   // c

   
      if(ObjectFind("c label") != 0)
   {
      ObjectCreate("c label", OBJ_LABEL, 0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com"  , TextSize, "Arial", TextColor3);
      ObjectSet("c label", OBJPROP_XDISTANCE,335);
     ObjectSet("c label", OBJPROP_YDISTANCE,50);
   }
   else
   {
   ObjectMove("c label", 0,  0,0);
   }
  
//----
   
//----
//int    counted_bars=IndicatorCounted();
   double up , down , sigmaup=0 , sigmadown=0 ,sigmaup2=0 , sigmadown2=0 , moreup , moredown , lessup , lessdown , upclose , downclose , upp , downp,upp2 ;
   int daysup=0 , daysdown=0 , daysup2=0 , daysdown2=0 ;
   int avgup,avgdown , avg , avgupclose , avgdownclose , same=0 , notsame=0;
   string trend;
   moreup=0;
   moredown=0;
   lessup=9999999999;
   lessdown=9999999999;
   for (int i=days;i>=1;i--) 
   {
   up=(iHigh(Symbol(),NULL, i)-iOpen(Symbol(),NULL, i))/Point;
   down=(iOpen(Symbol(),NULL, i)-iLow(Symbol(),NULL, i))/Point;
   upclose=(iClose(Symbol(),NULL,i)-iOpen(Symbol(),NULL, i))/Point;
   downclose=(iOpen(Symbol(),NULL, i)-iClose(Symbol(),NULL,i))/Point;
   if (up >0) 
   {
   //daysup++;
   if (up > moreup) {moreup=up;}
   if (up < lessup) lessup=up;
   }

   if (down>0)
    {
   //daysdown++;
   if (down > moredown) moredown=down;
   if (down < lessdown) lessdown=down; 
   }

    if (upclose >0) 
   {
   daysup2++;
   sigmaup=sigmaup+up; 
   sigmaup2=sigmaup2+upclose;
    // if (up > moreup) {moreup=up;}
   //if (up < lessup) lessup=up;
   }

   if (downclose>0)
    {
   daysdown2++;
   sigmadown=sigmadown+down;   
   sigmadown2=sigmadown2+downclose;   
   //if (down > moredown) moredown=down;
   //if (down < lessdown) lessdown=down; 
   }
   if ((iClose(Symbol(),NULL,i+1)>iOpen(Symbol(),NULL,i+1) && iClose(Symbol(),NULL,i)>iOpen(Symbol(),NULL,i)) || (iClose(Symbol(),NULL,i+1)<iOpen(Symbol(),NULL,i+1) && iClose(Symbol(),NULL,i)<iOpen(Symbol(),NULL,i)) )
   
         same++;
    else notsame++;
    
   }
   avgup= sigmaup/daysup2;
   avgdown= sigmadown/daysdown2;
   avg=avgup+avgdown;
   avgupclose=sigmaup2/daysup2;
   avgdownclose=sigmadown2/daysdown2;
   upp2=same+notsame;
   upp=same/upp2;
   downp=notsame/upp2;
   if (Open[daysup2+daysdown2]<Close[0]) trend="ÊÑäÏ ÕÇÚÏ"; else trend="ÊÑäÏ åÇÈØ";
   Comment ("\n" , "ÈÓã Çááå Ç áÑÍãä ÇáÑÍíã" , "\n" , "wajdyss ÇÍÕÇÆíÉ" ,"\n","\n" ,
  "ÚÏÏ ÇáÔãÚÇÊ ÇáÕÇÚÏÉ =" , daysup2 ,"\n","ãÊæÓØ ÇáåÇí ááÔãÚÇÊ ÇáÕÇÚÏÉ =" ,avgup,"\n", "ãÊæÓØ äÞÇØ ÇáÔãÚÇÊ ÇáÕÇÚÏÉ =",avgupclose,
   "\n"  , "ÃßËÑ ÚÏÏ äÞÇØ ÕÚæÏÇð =" , moreup ,
   "\n" ,"\n","ÚÏÏ ÇáÔãÚÇÊ ÇáåÇÈØÉ =",daysdown2,"\n","ãÊæÓØ Çááæ ááÔãÚÇÊ ÇáåÇÈØÉ =",avgdown,"\n","ãÊæÓØ äÞÇØ ÇáÔãÚÇÊ ÇáåÇÈØÉ =",
   avgdownclose,"\n","ÃßËÑ ÚÏÏ äÞÇØ åÈæØÇð =" , moredown,"\n","\n", "ãÚÏá ÍÑßÉ ÇáÒæÌ =" ,
    avg,"\n","\n","ÇáÓÚÑ ÇáÓÇÈÞ =",Open[daysup2+daysdown2],"\n","ÇáÓÚÑ ÇáÍÇáí =",Close[0],"\n",trend,"\n","\n","ÚÏÏ ÇáÔãÚÇÊ ÇáãÊÔÇÈåÉ =",
    same,"\n","ÇáäÓÈÉ =",upp,"\n","ÚÏÏ ÇáÔãÚÇÊ ÇáãÎÊáÝÉ =",notsame,"\n","ÇáäÓÈÉ =",downp,"\n","\n","spread = ", MarketInfo(Symbol(),MODE_SPREAD) )  ;
  // ObjectSetText( "gmtl", avgup , 40, "Arial", Green );
   return(0);
  }
//+------------------------------------------------------------------+