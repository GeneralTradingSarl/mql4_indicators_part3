
//=================================================================================================
//===Universal=Ranger============================================================================
//=============================================================================================

#property copyright "Copyright © 2010, Thomas Stutz."
#property link      "t.s@my-sc.eu"

//=============================================================================================

#property indicator_chart_window

//===Extern=Variables==========================================================================

extern      int         LineStyle   =        0,
                        LineWidth   =        0,
                        BackBar     =        0;

extern      string      TimeFrame   =        "M15";

extern      color       ResLine     =        Lime,
                        SupLine     =        OrangeRed;

//===Variables=================================================================================

            int         i           =        0,
                        limit       =        0,
                        tframe      =        0,
                        counter     =        0;

            double      supi        =        0,
                        resi        =        0;

//===Init======================================================================================

int init()

   {

      if(TimeFrame == "M1")      {tframe = 1;}
      if(TimeFrame == "M5")      {tframe = 5;}
      if(TimeFrame == "M15")     {tframe = 15;}
      if(TimeFrame == "M30")     {tframe = 30;}
      if(TimeFrame == "H1")      {tframe = 60;}
      if(TimeFrame == "H4")      {tframe = 240;}
      if(TimeFrame == "D1")      {tframe = 1440;}
      if(TimeFrame == "W1")      {tframe = 10080;}
      if(TimeFrame == "MN1")     {tframe = 43200;}

      return(0);

   }

//===Deinit====================================================================================

int deinit()

   {

      ObjectDelete("15_Ranger_Support");
      ObjectDelete("15_Ranger_Resistance");

      return(0);

   }

//===Start=====================================================================================

int start()

   {

      if(TimeFrame == "M1")      {tframe = 1;}
      if(TimeFrame == "M5")      {tframe = 5;}
      if(TimeFrame == "M15")     {tframe = 15;}
      if(TimeFrame == "M30")     {tframe = 30;}
      if(TimeFrame == "H1")      {tframe = 60;}
      if(TimeFrame == "H4")      {tframe = 240;}
      if(TimeFrame == "D1")      {tframe = 1440;}
      if(TimeFrame == "W1")      {tframe = 10080;}
      if(TimeFrame == "MN1")     {tframe = 43200;}

      counter = IndicatorCounted();
      if    (counter < 0) return(-1);
      if    (counter > 0) counter--;
      limit = Bars - counter;

      for(i = BackBar; i < limit; i++)

         {

            resi = iHigh(Symbol(), tframe, i);
            supi = iLow(Symbol(), tframe, i);

            if (ObjectFind("15_Ranger_Resistance")!=0)

               {

                  ObjectCreate("15_Ranger_Resistance",OBJ_HLINE,0,0,resi);
                  ObjectSet("15_Ranger_Resistance",OBJPROP_COLOR,ResLine);
                  ObjectSet("15_Ranger_Resistance",OBJPROP_STYLE,LineStyle);
                  ObjectSet("15_Ranger_Resistance",OBJPROP_WIDTH,LineWidth);

               }

            else {ObjectMove("Da15_Ranger_ResistanceyR3",0,Time[0],resi);}

            if (ObjectFind("15_Ranger_Support")!=0)

               {

                  ObjectCreate("15_Ranger_Support",OBJ_HLINE,0,0,supi);
                  ObjectSet("15_Ranger_Support",OBJPROP_COLOR,SupLine);
                  ObjectSet("15_Ranger_Support",OBJPROP_STYLE,LineStyle);
                  ObjectSet("15_Ranger_Support",OBJPROP_WIDTH,LineWidth);

               }

            else {ObjectMove("15_Ranger_Support",0,Time[0],supi);}

         }

      return(0);

   }

//===End=======================================================================================