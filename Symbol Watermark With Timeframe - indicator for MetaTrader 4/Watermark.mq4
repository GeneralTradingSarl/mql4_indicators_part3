//+------------------------------------------------------------------+
//|                                                    Watermark.mq4 |
//|                                          Copyright © M00SE  2011 |
//|                                                                  |
//|                      W A T E R M A R K                           |
//|                                                                  |
//| This indicator will display a symbol watermark on the chart      |
//| background, showing the timeframe and symbol name in large font. |
//|                                                                  |
//| Version 1 - 16 Jun 2011                                          |
//|                                                                  |
//|                                                                  |
//| Instructions                                                     |
//|                                                                  |
//| Choose the symbol you're interested in and display it in a chart |
//| window at the appropriate timeframe. Load the Watermark          |
//| indicator and optionally choose font, size, colour, position etc.|
//| Additionally you may choose to add some custom text of your own, |
//| eg. web link, email address etc. in a tag field.                 |
//|                                                                  |
//| That's it!                                                       |
//| Hope you like it, MOOSE.                                         |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright © M00SE  2011"

#property indicator_chart_window

//---- input parameters
extern int sidFontSize = 140;
extern string sidFontName = "Ariel";
extern string NoteRedGreenBlue = "Red/Green/Blue each 0..255";
extern int sidRed = 30;
extern int sidGreen = 30;
extern int sidBlue = 30;
extern int sidXPos = 30;
extern int sidYPos = 150;

extern bool tagDisplayText = true;
extern string tagText = "[Your Name Here]";
extern int tagFontSize = 20;
extern string tagFontName = "Tahoma";
extern int tagRed = 60;
extern int tagGreen = 30;
extern int tagBlue = 60;
extern int tagXPos = 600;
extern int tagYPos = 550;

//---- data
string SID = "Symbol";
int sidRGB = 0;
string TAG = "Tag";
int tagRGB = 0;
string tf;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----

   switch(Period())
     {  
      case PERIOD_D1:
         tf="d1";
         break;
      case PERIOD_H1:
         tf="h1";
         break;
      case PERIOD_H4:
         tf="h4";
         break;
      case PERIOD_M1:
         tf="m1";
         break;
      case PERIOD_M15:
         tf="m15";
         break;
      case PERIOD_M30:
         tf="m30";
         break;
      case PERIOD_M5:
         tf="m5";
         break;
      case PERIOD_MN1:
         tf="mn1";
         break;
      case PERIOD_W1:
         tf="w1";
         break;
      default:
         tf="Unknown";
         break;
     }

     if(tagRed > 255 || tagGreen > 255  || tagBlue > 255 || sidRed > 255 || sidGreen > 255 || sidBlue > 255)
     {
       Alert("Watermark Red/Green/Blue components must each be in range 0..255");
     }   

     tagRGB = (tagBlue << 16); 
     tagRGB |= (tagGreen << 8);
     tagRGB |= tagRed;

     sidRGB = (sidBlue << 16); 
     sidRGB |= (sidGreen << 8);
     sidRGB |= sidRed;
      
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   ObjectDelete(SID);
   ObjectDelete(TAG);
   
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   double chartHi, chartLo;
   double range;
   static double prevRange;
   
   chartHi = WindowPriceMax(0);
   chartLo = WindowPriceMin(0);
   range = chartHi - chartLo;

   // need only draw the watermark if the chart range has changed
   if(prevRange != range)
   {
      deinit();
      prevRange = range;
   
      watermark(SID, tf + Symbol(), sidFontSize, sidFontName, sidRGB, sidXPos, sidYPos);
      if(tagDisplayText && StringLen(tagText) > 0)
      {
         watermark(TAG, tagText, tagFontSize, tagFontName, tagRGB, tagXPos, tagYPos); 
      }
   }   
   return(0);
}

void watermark(string obj, string text, int fontSize, string fontName, color colour, int xPos, int yPos)
{
      ObjectCreate(obj, OBJ_LABEL, 0, 0, 0); 
      ObjectSetText(obj, text, fontSize, fontName, colour);
      ObjectSet(obj, OBJPROP_CORNER, 0); 
      ObjectSet(obj, OBJPROP_XDISTANCE, xPos); 
      ObjectSet(obj, OBJPROP_YDISTANCE, yPos);
      ObjectSet(obj, OBJPROP_BACK, true);
}

