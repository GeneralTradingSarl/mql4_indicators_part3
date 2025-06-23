//+==================================================================+
//|                                                  Spread_Read.mq4 |
//|                                 Copyright © 2011, Yevgeny Getman |
//+==================================================================+
#property copyright "Yevgeny Getman"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red 

extern string  csv_filename="my_spread_data";
//---------------------------------------------+
double MapBuffer[];
int TimeArray[];
double SpreadArray[];
bool have_error;
static datetime data_start;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("Spread");
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,MapBuffer);
   SetLevelStyle(STYLE_DASHDOT,1);
   SetLevelValue(0,1);
   SetLevelValue(1,2);
   SetLevelValue(2,3);
//-------------------------------------+
   data_start= Time[0];
   int handle=FileOpen(csv_filename+".csv",FILE_CSV|FILE_READ|FILE_SHARE_READ,';');
   if(handle>0)
     {
      int n=0;
      DrawFxLbl("msg","Reading file...",0,4,25,10,"Times New Roman",White,false);
      DrawFxLbl("file","terminal/experts/files/",0,3,40,8,"Courier",White,false);
      DrawFxLbl("file2",csv_filename+".csv",0,187,40,8,"Courier",DeepSkyBlue,false);
      while(!FileIsEnding(handle))
        {
         double val=FileReadNumber(handle);
         if(val>100) //--- Time value
           {
            ArrayResize(TimeArray,ArraySize(TimeArray)+1);
            TimeArray[ArraySize(TimeArray)-1]=val;
           }
         else           //--- Spread value
           {
            ArrayResize(SpreadArray,ArraySize(SpreadArray)+1);
            SpreadArray[ArraySize(SpreadArray)-1]=val;
           }
         n++;
        }
      FileClose(handle);
      DrawFxLbl("msg","File Read Successfully!! ",0,4,26,10,"Times New Roman",White,false);
     }
   else if(handle<1) //--- Error Handling
     {
      int code=GetLastError();
      DrawFxLbl("error","error: "+DoubleToStr(code,0),0,4,25,10,"Times New Roman",Red,false);
      Alert("error",code);
      if(code==4103)
         DrawFxLbl("nofile","cannot open "+csv_filename+".csv",0,4,35,10,"Times New Roman",White,false);
      Print("cannot open "+csv_filename+".csv ; make sure csv_filename is correct and file is placed in terminal/experts/files directory");
      have_error=true;
      return(0);
     }
//-------------------------------------+
   int m;
   double sec_tested=TimeArray[ArraySize(TimeArray)-1]-TimeArray[0],
   timedisplayed=FormatTime(sec_tested);
   double SpreadVals[][2];
   string units=FormatUnits(sec_tested);
//-------------------------------------+
   double sum=0;
   ArrayResize(SpreadVals,ArrayRange(SpreadVals,0)+1);
   SpreadVals[ArrayRange(SpreadVals,0)-1][1]=SpreadArray[0];
   SpreadVals[ArrayRange(SpreadVals,0)-1][0]=1;
   for(m=0;m<ArraySize(SpreadArray);m++)
     {
      sum=sum+SpreadArray[m];
      bool have_val=false;
      for(n=0;n<ArraySize(SpreadVals);n++)
         if(SpreadVals[n][1]==SpreadArray[m])
           {
            have_val=true;
            SpreadVals[n][0]=SpreadVals[n][0]+1;
            break;
           }
      if(!have_val && SpreadArray[m]!=0)
        {
         ArrayResize(SpreadVals,ArrayRange(SpreadVals,0)+1);
         SpreadVals[ArrayRange(SpreadVals,0)-1][1]=SpreadArray[m];
        }
     }
   double MeanSpread=sum/ArraySize(SpreadArray);
   int index=0;
   double max_num=SpreadVals[index][0];
   for(n=0;n<ArrayRange(SpreadVals,0);n++)
         if(SpreadVals[n][0]>max_num) {max_num=SpreadVals[n][0]; index=n;}
   double Mode=SpreadVals[index][1];
//---------------------------------+
   DrawFxLbl("TTested","Time Tested: "+DoubleToStr(timedisplayed,1)+" "+units+" ("+ArraySize(SpreadArray)+" bars)",0,4,55,9,"Times New Roman",White,false);
   DrawFxLbl("MeanSpread","Mean Spread: "+DoubleToStr(MeanSpread,1),0,4,70,9,"Times New Roman",White,false);
   DrawFxLbl("Mode","Mode: "+DoubleToStr(Mode,1)+" ("+DoubleToStr(max_num,1)+"%)",0,4,85,9,"Times New Roman",White,false);
//--------------------------------------------------+(max_num/ArraySize(SpreadArray))*100
   return(0);
  }
//===============================================================================================================|

//===============================================================================================================|
int start()
  {
   if(have_error) return(-1);
   int m,i=Bars-IndicatorCounted()-1;
//--------------------------------------------------+
   double Spread=MarketInfo(Symbol(),MODE_SPREAD);
   double AdjSpread=Spread/(0.0001/MathPow(10,-Digits));
   DrawFxLbl("spread","Current Spread: "+DoubleToStr(AdjSpread,1)+" pip",0,4,12,10,"Times New Roman",White,false);
//--------------------------------------------------+
   while(i>=0)
     {
      if(Time[i]==Time[0])
         MapBuffer[i]=AdjSpread;
      else
      for(m=0;m<ArraySize(TimeArray);m++)
            if(Time[i]==TimeArray[m])
            MapBuffer[i]=SpreadArray[m];
      i--;
     }
//--------------------------------------------------+
   return(0);
  }
//===============================================================================================================|

//+------------------------------------------------------------------+
double FormatTime(double sec)
  {
   if(sec<60)
      return(sec);
   else if(sec>=60 && sec<3600)
                return(sec/60);
   else if(sec>=3600 && sec<86400)
                return(sec/3660);
   else if(sec>=86400 && sec<604800)
                return(sec/86400);
   else if(sec>=604800 && sec<2419200)
                return(sec/604800);
   else if(sec>=2419200)
                return(sec/31536000);
   return(0);
  }
//+------------------------------------------------------------------+
string FormatUnits(double sec)
  {
   if(sec<60)
      return("sec");
   else if(sec>=60 && sec<3600)
                return("min");
   else if(sec>=3600 && sec<86400)
                return("hrs");
   else if(sec>=86400 && sec<604800)
                return("days");
   else if(sec>=604800 && sec<2419200)
                return("wks");
   else if(sec>=2419200)
                return("mo");
   return("");
  }
//+------------------------------------------------------------------+

//------------------- Draw Fixed Label Function ------------------------|
void DrawFxLbl(string OName,string TEXT,int Corner,int DX,int DY,int FSize,string Font,color FColor,bool BG)
  {
   if(ObjectFind(OName)<0)
      ObjectCreate(OName,OBJ_LABEL,0,0,0);
   ObjectSet(OName,OBJPROP_CORNER,Corner);
   ObjectSet(OName,OBJPROP_XDISTANCE,DX);
   ObjectSet(OName,OBJPROP_YDISTANCE,DY);
   ObjectSet(OName,OBJPROP_BACK,BG);
   ObjectSetText(OName,TEXT,FSize,Font,FColor);
  }
//----------------------------------------------------------------------|

//+------------------+
int deinit()
  {
   ObjectsDeleteAll();
   return(0);
  }
//+------------------+
