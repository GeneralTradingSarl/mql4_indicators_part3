//+------------------------------------------------------------------+
//|                                                        Sidus.mq4 |
//|                                  Copyright © 2006, GwadaTradeBoy |
//|                                            racooni_1975@yahoo.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, GwadaTradeBoy"
#property link      "racooni_1975@yahoo.fr"
//----
#property indicator_chart_window
//----Section #property
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Aqua
#property indicator_color4 Yellow
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Red
//---- Indicateurs
double EMA18, EMA28, WMA5, WMA8, tuncross;
double EMA18Current, EMA18Previous, EMA28Current, EMA28Previous;
double WMA5Current, WMA5Previous, WMA8Current, WMA8Previous;
extern double digit=0;
int    nShift;
//---- buffers
double ExtMapBuffer1[];    //EMA18
double ExtMapBuffer2[];    //EMA28
double ExtMapBuffer3[];    //WMA5
double ExtMapBuffer4[];    //WMA8
double ExtMapBuffer5[];    //Fleche Haut
double ExtMapBuffer6[];    //Fleche Bas
double ExtMapBuffer7[];    //Croix
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//---- Styles et couleur des Lignes
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(3,DRAW_LINE);
//---- Styles et couleur des Fleches      
   SetIndexStyle(4, DRAW_ARROW, 0, 1);    // Fleche vers le haut
   SetIndexArrow(4, 233);
   SetIndexBuffer(4, ExtMapBuffer5);
   SetIndexStyle(5, DRAW_ARROW, 0, 1);    // Fleche vers le bas
   SetIndexArrow(5, 234);
   SetIndexBuffer(5, ExtMapBuffer6);
   SetIndexStyle(6, DRAW_ARROW, 0, 1);    // Croix rouge fin de trade
   SetIndexArrow(6, 251);
   SetIndexBuffer(6, ExtMapBuffer7);
//----       
   switch(Period())
     {
      case     1: nShift=1;   break;
      case     5: nShift=3;   break;
      case    15: nShift=5;   break;
      case    30: nShift=10;  break;
      case    60: nShift=15;  break;
      case   240: nShift=20;  break;
      case  1440: nShift=80;  break;
      case 10080: nShift=100; break;
      case 43200: nShift=200; break;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,j,limit,counted_bars=IndicatorCounted();
//----
   if(counted_bars<0)
      return(-1);
   if(counted_bars>0)
      counted_bars--;
//----      
   limit=Bars-counted_bars;
//----
   for(i=0; i<limit; i++)
     {
      EMA18Current=iMA(NULL,0,18,0,MODE_EMA,PRICE_CLOSE,i);
      EMA18Previous=iMA(NULL,0,18,0,MODE_EMA,PRICE_CLOSE,i+1);
      ExtMapBuffer1[i]=EMA18Current;
      EMA28Current=iMA(NULL,0,28,0,MODE_EMA,PRICE_CLOSE,i);
      EMA28Previous=iMA(NULL,0,28,0,MODE_EMA,PRICE_CLOSE,i+1);
      ExtMapBuffer2[i]=EMA28Current;
      WMA5Current=iMA(NULL,0,5,0,MODE_LWMA,PRICE_CLOSE,i);
      WMA5Previous=iMA(NULL,0,5,0,MODE_LWMA,PRICE_CLOSE,i+1);
      ExtMapBuffer3[i]=WMA5Current;
      WMA8Current=iMA(NULL,0,8,0,MODE_LWMA,PRICE_CLOSE,i);
      WMA8Previous=iMA(NULL,0,8,0,MODE_LWMA,PRICE_CLOSE,i+1);
      ExtMapBuffer4[i]=WMA8Current;
      //---- Dessin des fleches, future entré en trade
/*            if ((EMA18Current > EMA28Current + digit*Point) &&( EMA18Previous <= EMA28Previous)) // Croisement Tunnel
               {
                  tuncross = EMA18*/
      //---- Buy
      //if (WMA5Current > WMA8Current && WMA5Previous <= WMA8Previous)
                  /*-if (
                  //((EMA18Current > EMA28Current + digit*Point) &&( EMA18Previous <= EMA28Previous)) &&   // Croisement Tunnel
                  //((WMA5Current > WMA8Current + digit*Point) &&( WMA5Previous <= WMA8Previous)) &&       // Croisement WMA
                  //((WMA5Current > EMA18Current+ digit*Point) && ( WMA5Previous <= EMA18Current)) &&       // Croisement Bord1Tunnel WMA5
                  //((WMA5Current > EMA28Current+ digit*Point) && ( WMA5Previous <= EMA28Current)) &&       // Croisement Bord2 Tunnel WMA5
                  ((WMA8Current > EMA18Current+ digit*Point) && ( WMA8Previous <= EMA18Current)) //&&       // Croisement Bord1 Tunnel WMA8
                  //((WMA8Current > EMA28Current+ digit*Point) && ( WMA8Previous <= EMA28Current))        // Croisement Bord2 Tunnel WMA8
                  )*/
      if((WMA5Current > WMA8Current+  digit*Point )&&(WMA5Previous<=WMA8Previous))  // Croisement WMA5 et WMA8, Lot = 10% de LotsOptimized()
        {
         ExtMapBuffer5[i]=Low[i] - nShift*Point;
        }
      if((WMA8Current > EMA28Current+ digit*Point) &&(WMA8Previous<=EMA28Current))  // Croisement WMA8  up bord supérieur du tunnel
        {
         ExtMapBuffer5[i]=Low[i] - nShift*Point;
        }
      //---- Sell
      //if(WMA8Current > WMA5Current && WMA8Previous <= WMA5Previous)
                  /*if (
                  //((EMA18Current < EMA28Current + digit*Point) &&( EMA18Previous >= EMA28Previous)) &&   // Croisement Tunnel
                  //((WMA5Current < WMA8Current + digit*Point) &&( WMA5Previous >= WMA8Previous)) &&       // Croisement WMA
                  //((WMA5Current < EMA18Current+ digit*Point) && ( WMA5Previous <= EMA18Current)) &&       // Croisement Bord1Tunnel WMA5
                  //((WMA5Current < EMA28Current+ digit*Point) && ( WMA5Previous <= EMA28Current)) &&       // Croisement Bord2 Tunnel WMA5
                  //((WMA8Current < EMA18Current+ digit*Point) && ( WMA8Previous <= EMA18Current)) &&       // Croisement Bord1 Tunnel WMA8
                  ((WMA8Current < EMA28Current+ digit*Point) && ( WMA8Previous <= EMA28Current))          // Croisement Bord2 Tunnel WMA8
                  )*/
      if((WMA8Current > WMA5Current+  digit*Point )&&(WMA8Previous<=WMA5Previous))  // Croisement WMA5 et WMA8, Lot = 10% de LotsOptimized()
        {
         ExtMapBuffer6[i]=High[i] + nShift*Point;
        }
      if((EMA28Current > WMA8Current+ digit*Point) &&(WMA8Previous>=EMA28Current))  // Croisement WMA8  down bord inférieur du tunnel
        {
         ExtMapBuffer6[i]=High[i] + nShift*Point;
        }         /*}*/
     }
//---- Dessin des croix, future sortie en trade
   return(0);
  }
//+------------------------------------------------------------------+