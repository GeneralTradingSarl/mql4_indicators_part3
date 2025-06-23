//+------------------------------------------------------------------+
//|                                            Currency Strenght.mq4 |
//|                                              Copyright 2020, SAF |
//|                                       https://www.suo-tempore.ch |
//|                                                       09.04.2020 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SAF"
#property link      "https://www.suo-tempore.ch"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrMagenta;
input string Currency =  "USD";

string   Suffix;
string   Sym[28];
string   ComparativePairs[7];
string   Antagonists[7];
double   sum[][7];
int      cnt;
double   Cust[];
string   Name = "Currency_Strenght ";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   Suffix = StringSubstr(Symbol(),6,0);
   Symbols();
   for(int c=0; c<=27; c++)
   {
      if(StringSubstr(Sym[c],0,3)==Currency || StringSubstr(Sym[c],3,3)==Currency)
      {
         ComparativePairs[cnt]=Sym[c];
         cnt+=1;
      }      
   }
   
   for(int x=0; x<=6; x++)
   {
      if(StringSubstr(ComparativePairs[x],0,3)==Currency)
      {
         Antagonists[x] = StringSubstr(ComparativePairs[x],3,3);
      }
      if(StringSubstr(ComparativePairs[x],3,3)==Currency)
      {
         Antagonists[x] = StringSubstr(ComparativePairs[x],0,3);
      }
   }
   
   IndicatorBuffers(1);
   SetIndexBuffer(0,Cust);
   SetIndexStyle(0,DRAW_LINE);   
   IndicatorShortName(Name+Currency+" vs "+Antagonists[0]+" "+Antagonists[1]+" "+Antagonists[2]+" "+Antagonists[3]+" "+Antagonists[4]+" "+Antagonists[5]+" "+Antagonists[6]);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
   
   int brs = 0;
   for(int x=0; x<6; x++)
   {
      brs = MathMin(iBars(ComparativePairs[x],0),iBars(ComparativePairs[x+1],0));
   }
   int bars = (brs-1);
   ArrayResize(sum,bars);
   for(int t=bars-2; t>0; t--)
   {
      for(int ct=0;ct<=6;ct++)
      {
        RefreshRates();
        double c1 = iClose(ComparativePairs[ct],0,t);
        double c2 = iClose(ComparativePairs[ct],0,t+1);
        double calc = (c1-c2)/c2*100;
        if(StringSubstr(ComparativePairs[ct],0,3)==Currency)
        {
         sum[t][ct] = sum[t+1][ct]+calc;
        }
        if(StringSubstr(ComparativePairs[ct],3,3)==Currency)
        {
         sum[t][ct] = sum[t+1][ct]+(calc*-1);
        }
        //Cust[t] += sum[t][ct];
      }
      
   }
   
   for (int i=1; i<bars; i++)
   {
      Cust[i] = (sum[i][0] + sum[i][1] + sum[i][2] + sum[i][3] + sum[i][4] + sum[i][5] + sum[i][6])/7;
   }
   
   return(rates_total);
}
void Symbols()
{   
   Sym[0] = "AUDUSD"+Suffix;
   Sym[1] = "AUDNZD"+Suffix;
   Sym[2] = "AUDJPY"+Suffix;
   Sym[3] = "AUDCAD"+Suffix;
   Sym[4] = "AUDCHF"+Suffix;
   Sym[5] = "EURAUD"+Suffix;
   Sym[6] = "GBPAUD"+Suffix;
   Sym[7] = "USDCAD"+Suffix;
   Sym[8] = "NZDCAD"+Suffix;
   Sym[9] = "GBPCAD"+Suffix;
   Sym[10]= "EURCAD"+Suffix;
   Sym[11]= "CADCHF"+Suffix;
   Sym[12]= "CADJPY"+Suffix;
   Sym[13]= "CHFJPY"+Suffix;
   Sym[14]= "USDCHF"+Suffix;
   Sym[15]= "GBPCHF"+Suffix;
   Sym[16]= "EURCHF"+Suffix;
   Sym[17]= "NZDCHF"+Suffix;
   Sym[18]= "EURUSD"+Suffix;
   Sym[19]= "EURJPY"+Suffix;
   Sym[20]= "EURGBP"+Suffix;
   Sym[21]= "EURNZD"+Suffix;
   Sym[22]= "GBPJPY"+Suffix;
   Sym[23]= "GBPNZD"+Suffix;
   Sym[24]= "GBPUSD"+Suffix;
   Sym[25]= "NZDJPY"+Suffix;
   Sym[26]= "USDJPY"+Suffix;
   Sym[27]= "NZDUSD"+Suffix;
   
   
}
//+------------------------------------------------------------------+