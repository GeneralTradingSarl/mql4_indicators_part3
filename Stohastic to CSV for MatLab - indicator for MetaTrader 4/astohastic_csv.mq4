//+------------------------------------------------------------------+
//|                                                     Indi2csv.mq4 |
//|                                                  Heaton Research |
//|                              http://www.heatonresearch.com/encog |
//|                                      simplified by Reza rahmad|
//+------------------------------------------------------------------+


#property copyright "Heaton Research"
#property link      "http://www.heatonresearch.com/encog"
#property strict
#property indicator_separate_window

extern string file_name = "Stohastic_CSV.csv";
extern int Kperiod=14;
extern int Dperiod = 3;
extern int Slowing = 3;
int fileh =-1;
int lasterror;
extern
//+------------------------------------------------------------------+

int init()
  {

   IndicatorShortName("Indicators2CSV");

   fileh = FileOpen(file_name,FILE_CSV|FILE_WRITE|FILE_SHARE_READ,',');;
   if(fileh<1)
   {
      lasterror = GetLastError();
      Print("Error updating file: ",lasterror);
      return(false);
   }
  
   // file header - need to be the identifiers of the indicators to be exported  
   FileWrite(fileh,"stoch_main","stoch_Signal");

   return(0);
  
  }

//+------------------------------------------------------------------+

int deinit()
  {
      if(fileh>0)
      {
         FileClose(fileh);
      }
  
   return(0);
  
  }
  
//+------------------------------------------------------------------+
  
int start()
  {
   int barcount = IndicatorCounted();
   if (barcount<0) return(-1);
   if (barcount>0) barcount--;
  
   int barind=Bars-barcount-1;
  
      while(barind>1)
      {
         ExportIndiData(barind);
         barind--;
      }
      
   return(0);
  
  }
//+------------------------------------------------------------------+

void ExportIndiData(int barind)
{
   datetime t = Time[barind];
   string inditime =  
      StringConcatenate(TimeYear(t)+"_"+
                        TimeMonth(t)+"_"+
                        TimeDay(t)+"_"+
                        TimeHour(t)+"_"+
                        TimeMinute(t)+"_"+
                        TimeSeconds(t));
                        
   // add indicators at will (do not forget to update line 31!
   FileWrite(fileh,
         inditime,
iStochastic(Symbol(),0,Kperiod,Dperiod,Slowing,MODE_SMMA,0,MODE_MAIN,barind),iStochastic(Symbol(),0,Kperiod,Dperiod,Slowing,MODE_SMMA,0,MODE_SIGNAL,barind)
);

}

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
