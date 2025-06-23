//+------------------------------------------------------------------+
//|                                                   StepUpDown.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 28/03/2014 |
//|       Create: 28/03/2014   http://www.gol2you.com ~ Forex Videos |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property description "Price Direction movement Step Up and Down Forex Indicator"
//---
//--- indicator parameters
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 clrRed
#property indicator_width1 1
//--
extern string PriceDirection="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
//-- indicator buffer
double ma20c[];
//--
void EventSetTimer();
string symbol;
string CR;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit(void)
  {
   //--
   symbol=_Symbol;
   CR="Copyright © 2014 3RJ ~ Roy Philips-Jacobs"; 
//----
   IndicatorBuffers(1);
   //--- 1 indicator buffers mapping
   SetIndexBuffer(0,ma20c);
   //--- indicator line drawing
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,EMPTY,clrRed);
   //--- name for DataWindow and indicator subwindow label   
   SetIndexLabel(0,"BuySellLimit");
   //--
   IndicatorShortName("StepUpDown");
   IndicatorDigits(Digits);
   //--   
//--- initialization done
   return;
  }   
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
    EventKillTimer();
    GlobalVariablesDeleteAll();
    //--
    ObjectDelete("DirBUY");
    ObjectDelete("DirSELL");
    ObjectDelete("DirBUYArr");
    ObjectDelete("DirSELLArr");    
//----
   return;
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//---
int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
    {
//------
    if (PriceDirection!=CR) return(0);
    //--
    ResetLastError();    
    int i;
    int per=7;
    WindowRedraw();
    Sleep(500);
    RefreshRates(); 
    int pos=WindowFirstVisibleBar();
    //--
    double His[],Los[];
    bool dirBuy,dirSell;
    //--
    ArraySetAsSeries(His,true);
    ArraySetAsSeries(Los,true);
    //----
    RefreshRates();
    //--
    for(i=0; i<pos; i++)
      {
        //--
        ma20c[i]=iMA(symbol,0,20,0,MODE_SMMA,PRICE_MEDIAN,i);
        //--
        int posH=iHighest(symbol,0,MODE_HIGH,per,i);
        int posL=iLowest(symbol,0,MODE_LOW,per,i);
        if((posH>posL)&&(iLow(symbol,0,i)>=iLow(symbol,0,posL))) {dirBuy=TRUE; dirSell=FALSE;}
        if((posH>posL)&&(iLow(symbol,0,i)<=iLow(symbol,0,posL))) {dirSell=TRUE; dirBuy=FALSE;}
        if((posH<posL)&&(iHigh(symbol,0,i)<=iHigh(symbol,0,posH))) {dirSell=TRUE; dirBuy=FALSE;}
        if((posH<posL)&&(iHigh(symbol,0,i)>=iHigh(symbol,0,posH))) {dirBuy=TRUE; dirSell=FALSE;}        
        //--
        //--
        if(i==0)
          {
           //---
           ObjectDelete("DirBUY");
           ObjectDelete("DirSELL");
           ObjectDelete("DirBUYArr");
           ObjectDelete("DirSELLArr");
           //--
           if(dirBuy) // Buy direction
             {
              if(ObjectFind(0,"DirBUY")<0)
                {
                  ObjectCreate(0,"DirBUY",OBJ_TEXT,0,Time[posL],Low[posL]);
                  ObjectSetString(0,"DirBUY",OBJPROP_TEXT,StringConcatenate("  BUY"));
                  ObjectSetInteger(0,"DirBUY",OBJPROP_COLOR,clrAquamarine);
                  ObjectSetString(0,"DirBUY",OBJPROP_FONT,"Bodoni MT Black");
                  ObjectSetInteger(0,"DirBUY",OBJPROP_FONTSIZE,9);
                  ObjectSetInteger(0,"DirBUY",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
                  //--
                  ObjectCreate(0,"DirBUYArr",OBJ_TEXT,0,Time[posL-1],Low[posL]);
                  ObjectSetString(0,"DirBUYArr",OBJPROP_TEXT,CharToStr(217));
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_COLOR,clrAquamarine);
                  ObjectSetString(0,"DirBUYArr",OBJPROP_FONT,"Wingdings");
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_FONTSIZE,15);
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
                }
              else
                {
                  ObjectSetString(0,"DirBUY",OBJPROP_TEXT,StringConcatenate("  BUY"));
                  ObjectSetInteger(0,"DirBUY",OBJPROP_COLOR,clrAquamarine);
                  ObjectSetString(0,"DirBUY",OBJPROP_FONT,"Bodoni MT Black");
                  ObjectSetInteger(0,"DirBUY",OBJPROP_FONTSIZE,9);
                  ObjectSetInteger(0,"DirBUY",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
                  //--
                  ObjectSetString(0,"DirBUYArr",OBJPROP_TEXT,CharToStr(217));
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_COLOR,clrAquamarine);
                  ObjectSetString(0,"DirBUYArr",OBJPROP_FONT,"Wingdings");
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_FONTSIZE,15);
                  ObjectSetInteger(0,"DirBUYArr",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
                }
              //--
              ChartRedraw(0);
              WindowRedraw();
              Sleep(1000);
              RefreshRates();
              //--            
             }
           //---
           if(dirSell) // Sell direction
             {
              if(ObjectFind(0,"DirSELL")<0)
                {            
                  ObjectCreate(0,"DirSELL",OBJ_TEXT,0,Time[posH],High[posH]);
                  ObjectSetString(0,"DirSELL",OBJPROP_TEXT,StringConcatenate("  SELL"));
                  ObjectSetInteger(0,"DirSELL",OBJPROP_COLOR,clrSnow);
                  ObjectSetString(0,"DirSELL",OBJPROP_FONT,"Bodoni MT Black");
                  ObjectSetInteger(0,"DirSELL",OBJPROP_FONTSIZE,9);
                  ObjectSetInteger(0,"DirSELL",OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
                  //--
                  ObjectCreate(0,"DirSELLArr",OBJ_TEXT,0,Time[posH-1],High[posH]);
                  ObjectSetString(0,"DirSELLArr",OBJPROP_TEXT,CharToStr(218));
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_COLOR,clrSnow);
                  ObjectSetString(0,"DirSELLArr",OBJPROP_FONT,"Wingdings");
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_FONTSIZE,15);
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
                }
              else
                {
                  ObjectSetString(0,"DirSELL",OBJPROP_TEXT,StringConcatenate("  SELL"));
                  ObjectSetInteger(0,"DirSELL",OBJPROP_COLOR,clrSnow);
                  ObjectSetString(0,"DirSELL",OBJPROP_FONT,"Bodoni MT Black");
                  ObjectSetInteger(0,"DirSELL",OBJPROP_FONTSIZE,9);
                  ObjectSetInteger(0,"DirSELL",OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
                  //--
                  ObjectSetString(0,"DirSELLArr",OBJPROP_TEXT,CharToStr(218));
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_COLOR,clrSnow);
                  ObjectSetString(0,"DirSELLArr",OBJPROP_FONT,"Wingdings");
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_FONTSIZE,15);
                  ObjectSetInteger(0,"DirSELLArr",OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
                }
              //--
              ChartRedraw(0);
              WindowRedraw();
              Sleep(1000);
              RefreshRates();
              //--                         
             }
          //--- end if(i)
          } 
      //-- end for(i)
      }
//----- done
   return(rates_total);
  }
//-----
//+------------------------------------------------------------------+
