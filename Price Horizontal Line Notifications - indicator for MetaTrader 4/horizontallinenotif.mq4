//+------------------------------------------------------------------+
//|                                          HorizontalLineNotif.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property description "Agianto Simanullang"
#property strict
#property indicator_chart_window

input ENUM_LINE_STYLE LineStyle = STYLE_DOT;
input int Width = 1;
input color ObjectColor = clrDarkOrange;
input string FontType = "Arial";
input int FontSize = 6;
//+------------------------------------------------------------------+
input string ByMT4 = "By MT4";
input bool AlertMessage = true;
input bool AlertSound = true;
input bool AlertNotify = true;
input bool AlertEmail = false;
input string SoundFile = "alert.wav";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string hl_text, vsymbol = Symbol();
int vdigits, vperiod = Period();
double pips2dbl, vpoint, price_signal;
double vopen, vclose, curr_close_price, last_close_price;
datetime created_time = TimeCurrent();

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   vdigits = (int)MarketInfo(vsymbol, MODE_DIGITS);
   vpoint = MarketInfo(vsymbol, MODE_POINT);
   if(vdigits % 2 == 1)
     {
      pips2dbl = vpoint * 10;
     }
   else
     {
      pips2dbl = vpoint;
     }
   price_signal = iClose(vsymbol, vperiod, 1);
   price_signal = NormalizeDouble(price_signal + 30.00 * pips2dbl, vdigits);
   HorizontalLine("1", created_time, price_signal);
   HorizontalText("1", created_time, price_signal, "Alert at " + DoubleToString(price_signal, vdigits));

   Comment("[N] New signal \n[D] Deleted all signal");

   return (INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
  {
   created_time = TimeCurrent();
   vopen = NormalizeDouble(iOpen(vsymbol, vperiod, 0), vdigits);
   curr_close_price = NormalizeDouble(iClose(vsymbol, vperiod, 0), vdigits);
   if(last_close_price == 0)
     {
      last_close_price = curr_close_price;
     }
   for(int obj_total = ObjectsTotal() - 1; obj_total >= 0; obj_total--)
     {
      string on = ObjectName(obj_total);
      if(StringFind(on, "hl_") >= 0)
        {
         price_signal = NormalizeDouble(ObjectGetDouble(0, on, OBJPROP_PRICE, 0), vdigits);
         string index_signal = StringSubstr(on, 3, StringLen(on) - 3);
         hl_text = ObjectGetString(0, "txt_" + index_signal, OBJPROP_TEXT, 0);
         HorizontalLine(index_signal, created_time, price_signal);
         HorizontalText(index_signal, created_time, price_signal, hl_text);
         if((vopen < price_signal && last_close_price < price_signal && curr_close_price > price_signal) || (vopen > price_signal && last_close_price > price_signal && curr_close_price < price_signal))
           {
            if(StringFind(hl_text, "done") < 0)
              {
               SendNotifications(hl_text);
               HorizontalText(index_signal, created_time, price_signal, hl_text + ", done!!!");
              }
           }
        }
     }
   last_close_price = curr_close_price;

   return (rates_total);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   int obj_total;
   string on;
   int index_signal;
   if(id == CHARTEVENT_OBJECT_DRAG)
     {
      if(StringFind(sparam, "hl_") >= 0 || StringFind(sparam, "txt_") >= 0)
        {
         price_signal = NormalizeDouble(ObjectGetDouble(0, sparam, OBJPROP_PRICE, 0), vdigits);
         index_signal = (int)StringSubstr(sparam, 3, StringLen(sparam) - 3);
         hl_text = ObjectGetString(0, "txt_" + (string)index_signal, OBJPROP_TEXT, 0);
         HorizontalText((string)index_signal, created_time, price_signal, "Alert at " + DoubleToString(price_signal, vdigits));
        }
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      short sym = TranslateKey((int)lparam);
      if(sym > 0)
        {
         if(ShortToString(sym) == "N" || ShortToString(sym) == "n")
           {
            index_signal = 1;
            price_signal = 0;
            double price_signal_temp;
            for(obj_total = ObjectsTotal() - 1; obj_total >= 0; obj_total--)
              {
               on = ObjectName(obj_total);
               if(StringFind(on, "hl_") >= 0)
                 {
                  int index_signal_temp = (int)StringSubstr(on, 3, StringLen(on) - 3);
                  if(index_signal_temp >= index_signal)
                    {
                     index_signal = index_signal_temp + 1;
                    }
                  price_signal_temp = NormalizeDouble(ObjectGetDouble(0, on, OBJPROP_PRICE, 0), vdigits);
                  if(price_signal_temp > price_signal)
                    {
                     price_signal = price_signal_temp;
                    }
                 }
              }
            if(price_signal == 0)
              {
               price_signal = iClose(vsymbol, vperiod, 1);
              }
            price_signal = NormalizeDouble(price_signal + 30.00 * pips2dbl, vdigits);
            HorizontalLine((string)index_signal, created_time, price_signal);
            HorizontalText((string)index_signal, created_time, price_signal, "Alert at " + DoubleToString(price_signal, vdigits));
           }
         if(ShortToString(sym) == "D" || ShortToString(sym) == "d")
           {
            DeleteAllObjects();
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void HorizontalLine(string name, datetime time, double price)
  {
   name = "hl_" + name;
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_HLINE, 0, time, price))
        {
         Print("Draw the line failed with error #", GetLastError());
        }
      ObjectSetInteger(0, name, OBJPROP_WIDTH, Width);
      ObjectSetInteger(0, name, OBJPROP_STYLE, LineStyle);
      ObjectSetInteger(0, name, OBJPROP_COLOR, ObjectColor);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTED, true);
     }
   else
     {
      ObjectSetInteger(0, name, OBJPROP_TIME, time);
      ObjectSetDouble(0, name, OBJPROP_PRICE, price);
     }
  }

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void HorizontalText(string _name, datetime _time, double _price, string _text)
  {
   string name = "txt_" + _name;
   _time = _time + (PeriodSeconds() * 2);
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_TEXT, 0, _time, _price))
        {
         Print("Fail to draw the text ERROR CODE : ", GetLastError());
        }
      ObjectSetText(name, _text, FontSize, FontType);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_COLOR, ObjectColor);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
     }
   else
     {
      ObjectSetText(name, _text, FontSize, FontType);
      ObjectSetInteger(0, name, OBJPROP_TIME, _time);
      ObjectSetDouble(0, name, OBJPROP_PRICE, _price);
     }
  }

//+------------------------------------------------------------------+
//| Handler of the Deinit event                                      |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DeleteAllObjects();
   Comment("");
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void DeleteAllObjects()
  {
   for(int iObj = ObjectsTotal() - 1; iObj >= 0; iObj--)
     {
      string on = ObjectName(iObj);
      if(StringFind(on, "hl_") == 0 || StringFind(on, "txt_") == 0)
         ObjectDelete(on);
     }
  }

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
string sTfTable[] = { "M1", "M5", "M10", "M15", "M30", "H1", "H4", "D1", "W1", "MN" };
int iTfTable[] = { 1, 5, 10, 15, 30, 60, 240, 1440, 10080, 43200 };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string timeFrameToString(int tf)
  {
   for(int i = ArraySize(iTfTable) - 1; i >= 0; i--)
      if(tf == iTfTable[i])
         return (sTfTable[i]);
   return ("");
  }

//+------------------------------------------------------------------+
//| Send notification                                                |
//+------------------------------------------------------------------+
void SendNotifications(string message)
  {
   message = vsymbol +"."+ timeFrameToString(vperiod) +"."+ message;
   if(AlertMessage)
     {
      Alert(message);
     }
   if(AlertEmail)
     {
      SendMail("Notification price hits", message);
     }
   if(AlertNotify)
     {
      SendNotification(StringSubstr(message, 0, 255));
     }  // fn SendNotification is max char 255
   if(AlertSound)
     {
      PlaySound(SoundFile);
     }
  }
//+------------------------------------------------------------------+
