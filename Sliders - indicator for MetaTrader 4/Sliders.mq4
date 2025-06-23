//+------------------------------------------------------------------+
//|                                                Sliders Indicator |
//|                                                  Created by mimp | 
//|                                  Updated version posted Nov 2012 |
//+------------------------------------------------------------------+

//*---------------------------------------------------------------------------------------------------------------------------------*
//| DISCLAIMER: Use this indicator at your own risk. Intended for optimization and backtesting only. Not intended for live trading. |
//|                                                                                                                                 |
//| This indicator allows you to alter up to 4 values of an indicator (displayed in a separate window) by adjusting the location    |
//| of markers in relation to a scale of boxes in the chart window, to be used like "sliders". Each box is labelled with the        |   
//| value which will be applied to the indicator in the separate window if a marker is placed within the relevant slider box on the |   
//| chart. If you wish to change the way that the 4 values are applied to the buffers of the indicator simply add buffers as you    |
//| would do normally, and then insert the relevant SliderValueArray[#] in the correct place in lines 440 to 460.                   |                                                                                                                               
//|                                                                                                                                 |                                                              
//| The period will only respond to movements in a marker every tick. The code considers a marker to "be" in the corner of the      |
//| marker selection box (where the little tiny square dot is). If you lose a marker, you will need to reload the indicator. Do     |
//| not move the boxes once they have been drawn, because the markers respond to their original X and Y co-ordinates. If you wish to|
//| draw the chart objects in a different place then adjust these settings (in the Internal Variables section) and then re-compile  |
//| and re-load. If you wish to use the indicator while offline or during non-trading hours (when there are no ticks), then simply  |                        
//| refresh the chart every time you move the marker to a new period. You can do this by pressing Alt+C+R. Alternatively you can    |
//| run a separate script which posts "fake" ticks to the chart window every few seconds, which can be found here posted by 7Bit    |
//| and copyright "© Bernd Kreuss" http://forum.mql4.com/35406/page2#373533.                                                        |
//|                                                                                                                                 |
//| NOTE: The buffer values for the visible window, and ONLY the visible window, are re-calculated when a slider value is changed.  |
//|                                                                                                                                 |
//| Permission granted to alter, copy, distribute, improve or otherwise use my code here (for personal use, not for use in sale).   |
//| Thanks to phy (mql4.com) for the idea of only redrawing visible bars. (Code copied from http://forum.mql4.com/9594/page2).      |
//| Thanks to mladen (forex-tsd) for helping to tackle updates per tick.                                                            |
//| Thanks to Drey (forex factory) for pointing out how to refresh by hotkey (when no ticks are available),                         |    
//| (see http://www.forexfactory.com/showthread.php?t=267385).                                                                      |
//*---------------------------------------------------------------------------------------------------------------------------------*

#property indicator_separate_window

#property indicator_buffers 8

#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 Silver
#property indicator_color4 Silver
#property indicator_color5 White
#property indicator_color6 White
#property indicator_color7 White
#property indicator_color8 White

#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1

#property indicator_maximum 100
#property indicator_minimum 0

//#property indicator_level1 50
//#property indicator_level2 30
//#property indicator_level3 70
//#property indicator_levelstyle STYLE_DOT
//#property indicator_levelcolor Red

// External variables ----

extern bool UseSlider1=TRUE;
extern string Slider1_name = "Period%K";           // Values for slider line 1.
extern double Slider1_from = 2;                    // Lowest value to be tested. 
extern double Slider1_to = 50;                     // Highest value to be tested. Must be <= 50 values. 
extern double Slider1_step = 1;                    // Increase slider value in increments.

extern bool UseSlider2=TRUE;
extern string Slider2_name = "Period%D";           // Values for slider line 2.
extern double Slider2_from = 2;                    // Lowest value to be tested. 
extern double Slider2_to = 50;                     // Highest value to be tested. Must be <= 50 values. 
extern double Slider2_step = 1;                    // Increase slider value in increments.

extern bool UseSlider3=TRUE;
extern string Slider3_name = "Slowing";            // Values for slider line 3.
extern double Slider3_from = 2;                    // Lowest value to be tested. 
extern double Slider3_to = 50;                     // Highest value to be tested. Must be <= 50 values.
extern double Slider3_step = 1;                    // Increase slider value in increments.

extern bool UseSlider4=TRUE;
extern string Slider4_name = "Level";              // Values for slider line 4.
extern double Slider4_from = 2;                    // Lowest value to be tested. 
extern double Slider4_to = 50;                     // Highest value to be tested. Must be <= 50 values. 
extern double Slider4_step = 1;                    // Increase slider value in increments.

extern color Slider1Colour = Red;
extern color Slider2Colour = Gold;
extern color Slider3Colour = Lime;
extern color Slider4Colour = Aqua;

extern int BarsToCount = 5000;                  // Number of bars back to be used in the indicator.
extern bool ShowCoordinatesOfMarker1 = FALSE;   // Update the Comment() with the X and Y coordinates of Marker1

                                                // Internal variables ----                      // WARNING: The chart spacings may not automatically adjust if you change these.

int Corner = 2;                                 // Selects which corner of the chart the X and Y co-ordinates of objects relate to.
                                                // 0 = TopLeft, 2 = BottomLeft. 
int StartValue_X = 50;                          // Default initial X co-ordinate for chart objects.
int StartValue_Y = 50;                          // Default initial Y co-ordinate for chart objects.
int Marker_StartValue_X = 50;                   // Adjust these following values up and down to move the objects in the chart window.
int Marker_StartValue_Y = 420;                  // WARNING: the marker will not update the period correctly if you
int Box_StartValue_X = 50;                      //          move objects around the chart once they have been drawn.
int Box_StartValue_Y = 420;                     //          If you wish to draw the chart objects in a different place
int Number_StartValue_X = 55;                   //          then adjust these settings before loading the indicator.
int Number_StartValue_Y = 420;
int PeriodLabel_StartValue_X = 3;
int PeriodLabel_StartValue_Y = 24;
int NumberVerticalOffset = 20;                  // Distance of numbers above boxes.
int HorizontalOffset = 20;                      // Distance between boxes.
int MultipleLineVerticalOffset = 60;            // The vertical offset for each new row of boxes.
int MarkerType = 115;                           // Windings number.
int MarkerSize = 20;
int BoxType=111;                              // Windings number.
int BoxSize= 20;
string NumberFont="Arial";
int NumberFontSize = 10;
color NumberColour = White;
string PeriodLabelFont="Arial";
int PeriodLabelFontSize=14;

// Program variables ----

int onceonlytoggle;
int marker1_currentvalue_X;
int marker1_currentvalue_Y;
double boxperiod;
int boxcounter;
int counter;
string name;
int counted;

// Arrays ----

int UseSliderArray[5];
string SliderNameArray[5];
double SliderFromArray[5];
double SliderToArray[5];
double SliderStepArray[5];
color SliderColourArray[5];
int SliderDigitsArray[5];
double SliderValueArray[5];
double BoxArray[201][5];

// Buffers ----

double Buffer0[];
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];
double Buffer5[];
double Buffer6[];
double Buffer7[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Buffer0);
   SetIndexLabel(0,"Buffer0");
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Buffer1);
   SetIndexLabel(1,"Buffer1");
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Buffer2);
   SetIndexLabel(2,"Buffer2");
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,Buffer3);
   SetIndexLabel(3,"Buffer3");
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,Buffer4);
   SetIndexLabel(4,"Buffer4");
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,Buffer5);
   SetIndexLabel(5,"Buffer5");
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,Buffer6);
   SetIndexLabel(6,"Buffer6");
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,Buffer7);
   SetIndexLabel(7,"Buffer7");

   IndicatorShortName("Sliders");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   counter=0;
   while(counter<=201)
     {
      ObjectDelete("Box"+counter);
      ObjectDelete("Number"+counter);
      if(counter<=4){ObjectDelete("Marker"+counter); ObjectDelete("ValueLabel"+counter);}
      counter++;
     }

   Comment("");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

//MathMax(WindowFirstVisibleBar(), BarsToCount-IndicatorCounted());
// Redraw indicator buffers only within the visible window ----
   for(int i=limit; i>=0; i--)
     {
      //----
      // ************************************************************************************************************************
      // Code in this section only runs the first time the indicator is loaded ----
      if(onceonlytoggle==0)
        {
         // Warn if more than 50 values chosen for any given Slider#, or if Slider#_step is set to zero ----
         if(
            ( Slider1_step != 0 )
            && ( Slider2_step != 0 )
            && ( Slider3_step != 0 )
            && ( Slider4_step != 0 )
            )
           {
            if(
               (((Slider1_to-Slider1_from)/Slider1_step)>50)
               || (((Slider2_to-Slider2_from)/Slider2_step)>50)
               || (((Slider4_to-Slider4_from)/Slider3_step)>50)
               || (((Slider4_to-Slider4_from)/Slider4_step)>50)
               )
              {
               Comment("!WARNING! Each Slider may only be tested for up to 50 possibilities. Reduce the relevant Slider#_to value, Slider#_from value or Slider#_step external variable.");
               Alert("!WARNING! Each Slider may only be tested for up to 50 possibilities. Reduce the relevant Slider#_to value, Slider#_from value or Slider#_step external variable.");
               Print("!WARNING! Each Slider may only be tested for up to 50 possibilities. Reduce the relevant Slider#_to value, Slider#_from value or Slider#_step external variable.");
              }
           }
         else
           {
            Comment("!WARNING! A Slider#_step external variable is set to 0.");
            Alert("!WARNING! A Slider#_step external variable is set to 0.");
            Print("!WARNING! A Slider#_step external variable is set to 0.");
           }

         // Warn if Slider#_to is less than Slider#_from ----
         if(
            (Slider1_to<Slider1_from)
            || (Slider3_to<Slider3_from)
            || (Slider3_to<Slider3_from)
            || (Slider4_to<Slider4_from)
            )
           {
            Comment("!WARNING! A Slider#_to external variable has been set to less than a related Slider#_from external variable.");
            Alert("!WARNING! A Slider#_to external variable has been set to less than a related Slider#_from external variable.");
            Print("!WARNING! A Slider#_to external variable has been set to less than a related Slider#_from external variable.");
           }

         // Set start co-ordinates ----
         Marker_StartValue_X = StartValue_X;
         Marker_StartValue_Y = StartValue_Y;
         Box_StartValue_X = StartValue_X;
         Box_StartValue_Y = StartValue_Y;
         Number_StartValue_X = StartValue_X + 5;
         Number_StartValue_Y = StartValue_Y;

         // Set Digits array ----
         if(MathMod(Slider1_step,1) == 0){SliderDigitsArray[1] = 0;} else{SliderDigitsArray[1] = Digits;}
         if(MathMod(Slider3_step,1) == 0){SliderDigitsArray[2] = 0;} else{SliderDigitsArray[2] = Digits;}
         if(MathMod(Slider3_step,1) == 0){SliderDigitsArray[3] = 0;} else{SliderDigitsArray[3] = Digits;}
         if(MathMod(Slider4_step,1) == 0){SliderDigitsArray[4] = 0;} else{SliderDigitsArray[4] = Digits;}

         // Set UseSliderArray ----
         UseSliderArray[1] = UseSlider1;
         UseSliderArray[2] = UseSlider2;
         UseSliderArray[3] = UseSlider3;
         UseSliderArray[4] = UseSlider4;

         // Set SliderNameArray ----
         SliderNameArray[1] = Slider1_name;
         SliderNameArray[2] = Slider2_name;
         SliderNameArray[3] = Slider3_name;
         SliderNameArray[4] = Slider4_name;

         // Set SliderFromArray ----
         SliderFromArray[1] = Slider1_from;
         SliderFromArray[2] = Slider2_from;
         SliderFromArray[3] = Slider3_from;
         SliderFromArray[4] = Slider4_from;

         // Set SliderToArray ----
         SliderToArray[1] = Slider1_to;
         SliderToArray[2] = Slider2_to;
         SliderToArray[3] = Slider3_to;
         SliderToArray[4] = Slider4_to;

         // Set SliderStepArray ----
         SliderStepArray[1] = Slider1_step;
         SliderStepArray[2] = Slider2_step;
         SliderStepArray[3] = Slider3_step;
         SliderStepArray[4] = Slider4_step;

         // Set SliderColourArray ----
         SliderColourArray[1] = Slider1Colour;
         SliderColourArray[2] = Slider2Colour;
         SliderColourArray[3] = Slider3Colour;
         SliderColourArray[4] = Slider4Colour;

         // Set SliderValueArray ----
         SliderValueArray[1] = SliderFromArray[1];
         SliderValueArray[2] = SliderFromArray[2];
         SliderValueArray[3] = SliderFromArray[3];
         SliderValueArray[4] = SliderFromArray[4];

         // Marker creation cycle ----
         counter = 1;
         counted = 0;
         while(counter<=4)
           {
            if(UseSliderArray[counter]==1)
              {
               counted++;
               name=StringConcatenate("Marker",counter);
               ObjectCreate(name,OBJ_LABEL,0,0,0);
               ObjectSet(name,OBJPROP_CORNER,Corner);
               ObjectSet(name,OBJPROP_XDISTANCE,Marker_StartValue_X);
               ObjectSet(name,OBJPROP_YDISTANCE,Marker_StartValue_Y+(MultipleLineVerticalOffset*(counted-1)));
               ObjectSetText(name,CharToStr(MarkerType),MarkerSize,"Wingdings",SliderColourArray[counter]);
              } // UseSliderArray[counter] == 1 conditional end
            counter++;
           } // while counter <= 4 end

         // Box creation cycle  ----
         counter = 1;
         counted = 0;
         boxcounter=0;
         while(counter<=4)
           {
            if(UseSliderArray[counter]==1)
              {
               counted++;
               boxcounter=(counter-1)*50;
               boxperiod = SliderFromArray[counter];
               while((boxperiod<=SliderToArray[counter]) && (boxcounter<(counter*50)))
                 {
                  name=StringConcatenate("Box",boxcounter);
                  ObjectCreate(name,OBJ_LABEL,0,0,0);
                  ObjectSet(name,OBJPROP_CORNER,Corner);
                  ObjectSet(name,OBJPROP_XDISTANCE,Box_StartValue_X+(HorizontalOffset*(1+boxcounter-((counter-1)*50))));
                  ObjectSet(name,OBJPROP_YDISTANCE,Box_StartValue_Y+(MultipleLineVerticalOffset*(counted-1)));
                  ObjectSetText(name,CharToStr(BoxType),BoxSize,"Wingdings",SliderColourArray[counter]);
                  name=StringConcatenate("Number",boxcounter);
                  ObjectCreate(name,OBJ_LABEL,0,0,0);
                  ObjectSet(name,OBJPROP_CORNER,Corner);
                  ObjectSet(name,OBJPROP_XDISTANCE,Number_StartValue_X+(HorizontalOffset*(1+boxcounter-((counter-1)*50))));
                  ObjectSet(name,OBJPROP_YDISTANCE,Number_StartValue_Y-NumberVerticalOffset+(MultipleLineVerticalOffset*(counted-1)));
                  ObjectSetText(name,DoubleToStr(boxperiod,SliderDigitsArray[counter]),NumberFontSize,NumberFont,NumberColour);
                  if(SliderDigitsArray[counter]==Digits)
                    {ObjectSetText(name,DoubleToStr(boxperiod,SliderDigitsArray[counter]),5,NumberFont,NumberColour);}

                  BoxArray[boxcounter][0] = boxperiod;
                  BoxArray[boxcounter][1] = Box_StartValue_X + 3 + (HorizontalOffset*(1+boxcounter-((counter-1)*50)));
                  BoxArray[boxcounter][2] = Box_StartValue_X + 19 + (HorizontalOffset*(1+boxcounter-((counter-1)*50)));
                  BoxArray[boxcounter][3] = Number_StartValue_Y + 7 + (MultipleLineVerticalOffset*(counted-1));
                  BoxArray[boxcounter][4] = Number_StartValue_Y + 20 + (MultipleLineVerticalOffset*(counted-1));

                  boxcounter++;
                  boxperiod=boxperiod+SliderStepArray[counter];
                 } // while (boxperiod <= SliderToArray[counter]) && (boxcounter<(counter*50)) end
              } // UseSliderArray[counter] == 1 conditional end  
            counter++;
           } // while counter <= 4 end

        } // onceonlytoggle == 0 conditional end 
      onceonlytoggle=1;
      // ****************************************************************************************************************************
      // Code runs every tick from here onwards ----

      // Markers location check cycle. Checks the location of each marker and returns the value of whichever box it is in ----
      counter=1;
      boxcounter=0;
      while(counter<=4)
        {
         if(UseSliderArray[counter]==1)
           {
            if( counter == 1 ){ boxcounter = 0; }
            if( counter == 2 ){ boxcounter = 50; }
            if( counter == 3 ){ boxcounter = 100; }
            if( counter == 4 ){ boxcounter = 150; }
            while(boxcounter<=((counter-1)*50)+50)
              {
               name=StringConcatenate("Marker",counter);
               if(
                  ( ObjectGet(name, OBJPROP_XDISTANCE) >= BoxArray[boxcounter][1])
                  && ( ObjectGet(name, OBJPROP_XDISTANCE) <= BoxArray[boxcounter][2])
                  && ( ObjectGet(name, OBJPROP_YDISTANCE) >= BoxArray[boxcounter][3])
                  && ( ObjectGet(name, OBJPROP_YDISTANCE) <= BoxArray[boxcounter][4])
                  )
                 {SliderValueArray[counter]=BoxArray[boxcounter][0];}
               boxcounter=boxcounter+1;
              } // while end
           } // UseSliderArray conditional end 
         counter++;
        }

      // Comment X and Y coordinates of Marker1 ---- 
      if(ShowCoordinatesOfMarker1==TRUE)
        {
         marker1_currentvalue_X = ObjectGet("Marker1", OBJPROP_XDISTANCE);
         marker1_currentvalue_Y = ObjectGet("Marker1", OBJPROP_YDISTANCE);
         Comment(marker1_currentvalue_Y+" "+marker1_currentvalue_Y);
        }

      // Cycle to draw labels to show selected values ----
      counter=1;
      while(counter<=4)
        {
         if(UseSliderArray[counter]==1)
           {
            ObjectCreate("ValueLabel"+counter,OBJ_LABEL,0,0,0);
            ObjectSet("ValueLabel"+counter,OBJPROP_XDISTANCE,PeriodLabel_StartValue_X);
            ObjectSet("ValueLabel"+counter,OBJPROP_YDISTANCE,PeriodLabel_StartValue_Y+(30*(counter-1)));
            ObjectSetText("ValueLabel"+counter,SliderNameArray[counter]+" = "+DoubleToStr(SliderValueArray[counter],SliderDigitsArray[counter]),PeriodLabelFontSize,PeriodLabelFont,SliderColourArray[counter]);
           } // UseSliderArray conditional end  
         counter++;
        }

      // ******************************************************************************************************************************
      // Update and redraw buffers with values selected by the sliders. 
      // Insert SliderValueArray[1], SliderValueArray[2], SliderValueArray[3] or SliderValueArray[4] in the places you require ----

      // ** Insert your desired buffers here ** 
      Buffer0[i] = iStochastic(Symbol(), Period(), SliderValueArray[1], SliderValueArray[2], SliderValueArray[3], MODE_SMA, 0, MODE_MAIN, i);
      Buffer1[i] = iStochastic(Symbol(), Period(), SliderValueArray[1], SliderValueArray[2], SliderValueArray[3], MODE_SMA, 0, MODE_SIGNAL, i);
      Buffer2[i] = SliderValueArray[4];
      Buffer3[i] = 100 - SliderValueArray[4];
      WindowRedraw();
      //----
     }
   return(0);
  }
//+------------------------------------------------------------------+
