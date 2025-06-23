//+------------------------------------------------------------------+
//|                                                Rj_HSlice 1.1.mq4 |
//|                           Copyright © 2011, RJ Rjabkov Aleksandr |
//|                                                     rj-a@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, RJ Rjabkov Aleksandr"
#property link      "rj-a@mail.ru"

#property indicator_chart_window

extern int    DepthCalcDay      = 30;
extern double UpdateTime        = 1;
extern int    CalcPeriod        = 1;
extern double PercentDiscrep    = 0.2;
extern bool   ShowLevelsOn      = true;
extern bool   ShowTurningOn     = true;
extern bool   ShowContractOn    = true;
extern bool   BackgroundLevelOn = true;
extern color  ColorLine         = Aqua;

double lBuy[];
double lSell[];
double ValueCall[][2],ValuePut[][2];
static datetime LastTime=0;
static datetime StartTime=1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i=0; i<4000; i++)
     {
      ObjectDelete("vhb "+i);
      ObjectDelete("V "+i);
      ObjectDelete("H "+i);
     }
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(LastTime<StartTime)
     {
      int i,j,MaxVolume,EndTime;
      color ColLine;
      int TimeVisiblBar=WindowBarsPerChart()-WindowFirstVisibleBar();
      double MaxPrice = iHigh(NULL, PERIOD_D1, 0);
      double MinPrice = iLow(NULL, PERIOD_D1, 0);
      for(j=DepthCalcDay; j>=0; j--)
        {
         MaxPrice = MathMax(MaxPrice, iHigh(NULL, PERIOD_D1, j));
         MinPrice = MathMin(MinPrice, iLow(NULL, PERIOD_D1, j));
        }
      int Range=MathRound((MaxPrice-MinPrice)/Point);

      ArrayResize(lBuy,Range+1);
      ArrayInitialize(lBuy,0.0);
      ArrayResize(lSell,Range+1);
      ArrayInitialize(lSell,0.0);
      string DataComment="";
      switch(CalcPeriod)
        {
         case 1: DataComment="минутный"; break;
         case 5: DataComment="пять минут"; break;
         case 15: DataComment="пятнадцать минут"; break;
         case 30: DataComment="тридцать минут"; break;
         case 60: DataComment="часовой"; break;
         case 240: DataComment="четыре часа"; break;
         case 1440: DataComment="дневной"; break;
         case 10080: DataComment="недельный"; break;
         case 43200: DataComment="месячный"; break;
         default : DataComment="текущий"; break;
        }
      Comment("\n Период расчёта данных: "+DataComment);

      if(CalcPeriod>1 && CalcPeriod<5) {CalcPeriod=5; DataComment="пять минут";}
      if(CalcPeriod>5 && CalcPeriod<15) {CalcPeriod=15; DataComment="пятнадцать минут";}
      if(CalcPeriod>15 && CalcPeriod<30) {CalcPeriod=30; DataComment="тридцать минут";}
      if(CalcPeriod>30 && CalcPeriod<60) {CalcPeriod=60; DataComment="часовой";}
      if(CalcPeriod>60  &&  CalcPeriod<240) {CalcPeriod=240; DataComment="четыре часа";}
      if(CalcPeriod>240 && CalcPeriod<1440) {CalcPeriod=1440; DataComment="дневной";}
      if(CalcPeriod>1440 && CalcPeriod<10080) {CalcPeriod=10080; DataComment="недельный";}
      if(CalcPeriod>10080 && CalcPeriod<43200) {CalcPeriod=43200; DataComment="месячный";}
      if(CalcPeriod>43200) {CalcPeriod=43200; DataComment="месячный";}

      for(i=0; i<=Range; i++)
        {
         lBuy[i]  = iCustom(NULL, CalcPeriod, "Rj_Volume", DepthCalcDay, 0, i);
         lSell[i] = iCustom(NULL, CalcPeriod, "Rj_Volume", DepthCalcDay, 1, i);
        }

      if(MathRound(lBuy[ArrayMaximum(lBuy)])>=MathRound(lSell[ArrayMaximum(lSell)])) MaxVolume=MathRound(lBuy[ArrayMaximum(lBuy)]);
      else MaxVolume=MathRound(lSell[ArrayMaximum(lSell)]);

      if(TimeVisiblBar<=2) TimeVisiblBar=50;

      for(i=0; i<=4000; i++)
        {
         ObjectDelete("vhb "+i);
         ObjectDelete("V "+i);
         ObjectDelete("H "+i);
        }

      if(ShowLevelsOn)
        {
         for(i=0; i<=Range; i++)
           {
            if(BackgroundLevelOn)
              {
               if(lBuy[i]>lSell[i]) ColLine=C'64,136,50';
               if(lBuy[i]<lSell[i]) ColLine=C'218,118,125';
               if(lBuy[i]==lSell[i]) ColLine=Aqua;
               ObjectCreate("vhb "+i,OBJ_RECTANGLE,0,TimeStart(),MinPrice+i*Point,iTime(NULL,PERIOD_D1,DepthCalcDay),MinPrice+(i+1)*Point);
               ObjectSet("vhb "+i,OBJPROP_STYLE,DRAW_HISTOGRAM);
               ObjectSet("vhb "+i,OBJPROP_COLOR,ColLine);
               ObjectSet("vhb "+i,OBJPROP_BACK,true);
              }
            if(!BackgroundLevelOn)
              {
               if(lBuy[i]>lSell[i])
                 {
                  EndTime= TimeStart()-(TimeVisiblBar-1)*Period()*60;
                  ColLine=C'64,136,50';
                 }
               if(lBuy[i]<lSell[i])
                 {
                  EndTime= TimeStart()-(TimeVisiblBar-1)*Period()*60;
                  ColLine=C'218,118,125';
                 }
               if(lBuy[i]==lSell[i])
                 {
                  EndTime= TimeStart()-(TimeVisiblBar-1)*Period()*60;
                  ColLine=Aqua;
                 }
               ObjectCreate("vhb "+i,OBJ_RECTANGLE,0,TimeStart(),MinPrice+i*Point,EndTime,MinPrice+(i+1)*Point);
               ObjectSet("vhb "+i,OBJPROP_STYLE,DRAW_HISTOGRAM);
               ObjectSet("vhb "+i,OBJPROP_COLOR,ColLine);
               ObjectSet("vhb "+i,OBJPROP_BACK,true);
              }
           }
        }
      InstallVolume(lBuy,lSell,MinPrice,TimeVisiblBar,ValueCall,ValuePut);
      CalcTurning(ValueCall,ValuePut);
      StartTime=MathRound(TimeCurrent()+UpdateTime*60);
     }
   LastTime=TimeCurrent();
   return(0);
  }
//+------------------------------------------------------------------+
datetime TimeStart()
  {
   int Indention=Time[0]+(WindowBarsPerChart()-WindowFirstVisibleBar())*Period()*60;
   return(Indention);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InstallVolume(double &ArrBuy[],double &ArrSell[],double pos,int TimePos,double &ArrCall[][],double &ArrPut[][])
  {
   int shift,j,indexCall=0,indexPut=0,inc;
   double DifBuy[],DifSell[],exit;

   ArrayResize(DifBuy,ArraySize(ArrBuy)+1);
   ArrayInitialize(DifBuy,0.0);
   ArrayResize(DifSell,ArraySize(ArrBuy)+1);
   ArrayInitialize(DifSell,0.0);
   ArrayResize(ArrCall,ArraySize(ArrBuy)+1);
   ArrayInitialize(ArrCall,0.0);
   ArrayResize(ArrPut,ArraySize(ArrBuy)+1);
   ArrayInitialize(ArrPut,0.0);
   if(Digits==5) inc=10; else inc=100;
   for(shift=0; shift<ArraySize(ArrBuy); shift++)
     {
      if(ArrBuy[shift]>ArrSell[shift]) DifBuy[shift]=MathRound((ArrBuy[shift]-ArrSell[shift])*inc);
      if(ArrBuy[shift]<ArrSell[shift]) DifSell[shift]=MathRound((ArrSell[shift]-ArrBuy[shift])*inc);
     }

   for(shift=1; shift<ArraySize(ArrBuy); shift++)
     {
      double Value=0.0;
      if(DifBuy[shift-1]!=0.0 && DifBuy[shift]==0.0)
        {
         j=shift-1;
         while(DifBuy[j]!=0.0)
           {
            Value+=DifBuy[j];
            j--;
           }
         if(ShowTurningOn)
           {
            ArrCall[indexCall][0]=Value;
            ArrCall[indexCall][1]=pos+(shift+j)*Point/2;
           }
         if(ShowContractOn)
           {
            exit=pos+(shift+j+4)*Point/2;
            ObjectCreate("V "+shift,OBJ_TEXT,0,TimeStart()-((TimePos-6)*Period()*60),exit);
            ObjectSetText("V "+shift,DoubleToStr(Value,0),8,"Tahoma",GreenYellow);
           }
         indexCall++;
        }
      if(DifSell[shift-1]!=0.0 && DifSell[shift]==0.0)
        {
         j=shift-1;
         while(DifSell[j]!=0.0)
           {
            Value+=DifSell[j];
            j--;
           }
         if(ShowTurningOn)
           {
            ArrPut[indexPut][0]=Value;
            ArrPut[indexPut][1]=pos+(shift+j)*Point/2;
           }
         if(ShowContractOn)
           {
            exit=pos+(shift+j+4)*Point/2;
            ObjectCreate("V "+shift,OBJ_TEXT,0,TimeStart()-((TimePos-15)*Period()*60),exit);
            ObjectSetText("V "+shift,DoubleToStr(Value,0),8,"Tahoma",Maroon);
           }
         indexPut++;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CalcTurning(double &ArrCall[][],double &ArrPut[][])
  {
   int index;
   int count=ArraySize(ArrPut);
   double ratio,max,min,coordinat;
   for(index=1; index<count; index++)
     {
      if(ArrCall[index+1][0]==0.0 && ArrPut[index+1][0]==0.0)
        {
         return;
           } else {
         if(ArrCall[index][1]<ArrPut[index][1])
           {
            max=MathMax(ArrCall[index][0], ArrPut[index][0]);
            min=MathMin(ArrCall[index][0], ArrPut[index][0]);
            ratio=max*PercentDiscrep;
            if(max-min<ratio)
              {
               coordinat=MathRound((ArrCall[index][1]+ArrPut[index][1])/Point/2)*Point;
               InstallTurning(coordinat,index);
              }
            max=MathMax(ArrCall[index][0], ArrPut[index-1][0]);
            min=MathMin(ArrCall[index][0], ArrPut[index-1][0]);
            ratio=max*PercentDiscrep;
            if(max-min<ratio)
              {
               coordinat=MathRound((ArrCall[index][1]+ArrPut[index-1][1])/Point/2)*Point;
               InstallTurning(coordinat,index);
              }
           }
         if(ArrCall[index][1]>ArrPut[index][1])
           {
            max=MathMax(ArrCall[index][0], ArrPut[index][0]);
            min=MathMin(ArrCall[index][0], ArrPut[index][0]);
            ratio=max*PercentDiscrep;
            if(max-min<ratio)
              {
               coordinat=MathRound((ArrCall[index][1]+ArrPut[index][1])/Point/2)*Point;
               InstallTurning(coordinat,index);
              }
            max=MathMax(ArrCall[index][0], ArrPut[index+1][0]);
            min=MathMin(ArrCall[index][0], ArrPut[index+1][0]);
            ratio=max*PercentDiscrep;
            if(max-min<ratio)
              {
               coordinat=MathRound((ArrCall[index][1]+ArrPut[index+1][1])/Point/2)*Point;
               InstallTurning(coordinat,index);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InstallTurning(double coord,int index)
  {
   if(ShowTurningOn)
     {
      ObjectCreate("H "+index,OBJ_HLINE,0,0,0,0,0);
      ObjectSet("H "+index,OBJPROP_PRICE1,coord);
      ObjectSet("H "+index,OBJPROP_COLOR,ColorLine);
      ObjectSet("H "+index,OBJPROP_WIDTH,2);
      ObjectSet("H "+index,OBJPROP_BACK,false);
     }
  }
//+------------------------------------------------------------------+
