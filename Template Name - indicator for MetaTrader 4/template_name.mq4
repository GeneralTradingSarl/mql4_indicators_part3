//+--------------------------------------------------------------------+
//|                                                 Template Names.mq4 |
//|                          Copyright 2014, MetaQuotes Software Corp. |
//|                                               http://www.mql5.com  |
//|                                                                    |
//| Author: file45 - https://www.mql5.com/en/users/file45/publications |
//+--------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

input string Template_Name = "Template Name"; // Template Name
input color  Text_Color    = LightSlateGray; // Font Color
input int    Text_Size     = 20; // Font Size
input bool   Font_Bold     = false; // Font Bold
input int    Left_Right    = 250; // Left - Right
input int    Up_Down       = 20; // Up - Down
input int    Corner_       = 0; // Corner

string Text_Font;

int OnInit()
{
   switch(Font_Bold)
   {
      case 0: Text_Font = "Arial"; break;
      case 1: Text_Font = "Arial Bold";break;
   }   

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   string Templ_Name = Template_Name;
       
   RefreshRates();
   ObjectCreate("TemplName", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("TemplName", Templ_Name, Text_Size, Text_Font,  Text_Color);
   ObjectSet("TemplName", OBJPROP_CORNER, Corner_);
   ObjectSet("TemplName", OBJPROP_XDISTANCE, Left_Right);
   ObjectSet("TemplName", OBJPROP_YDISTANCE, Up_Down);  
   
   return(rates_total);
}


int deinit()
{
    ObjectDelete("TemplName");
    
    return(0);
}
