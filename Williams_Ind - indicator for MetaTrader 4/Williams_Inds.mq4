//+------------------------------------------------------------------+
//|                                                 Williams_Inds.mq4 |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
/*
Перемещаемая панель с индикаторами Б.Вильямса, для стратегии Торговый хаос. 
Показывает направление индикаторов AO, AC, и MACD.
http://codebase.mql4.com/ru/6318

The moved panel with the indicators of B.Williams, for strategy Trading chaos. 
It shows a direction of indicators AO, AC, and MACD.
http://codebase.mql4.com/6319

Денис Орлов
http://denis-or-love.narod.ru

***
Все мои индикаторы:
http://codebase.mql4.com/ru/author/denis_orlov
***
ПОЛЬЗУЙТЕСЬ И ПРОЦВЕТАЙТЕ!

*/
//+------------------------------------------------------------------+
#property copyright "Denis Orlov"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window
#define Pref "B.Williams Panel: "


extern string note1="Parameters of MACD:";
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
extern string note2="Coordinates:";
extern int X=30;
extern int Y=0; 
extern int H=0;
extern string note3="Colors, two themes:";
extern color RectClr=Gray;
extern color TxtClr=White;
extern color UpClr=Lime;
extern color DnClr=Red;
extern bool White_Chart_Theme=True;
extern color RectClr1=Gray;
extern color TxtClr1=Maroon;
extern color UpClr1=Green;
extern color DnClr1=Red;

//extern
   int W=9;

   
int nS=3;// количество строк 
int StepS;//шаг строки

int TimeX;
double PriceY;
int TimeW;
double PriceH;
int codeAO, codeAC, codeMACD;
color ClrAO , ClrAC, ClrMACD ;
bool Allow_Hand_Moving=True;
color HandClr=Green;
bool Alert_=False;
color Alert_Clr=Red;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      //TimeX=Time[0]-X*Period()*60; 
     // PriceY=WindowPriceMax()-Y*Point;
     if(H==0)H=CalculeH();
     
      TimeW=W*Period()*60;
      PriceH=H*Point;
      
      StepS=MathRound(H/nS);
      
      if(White_Chart_Theme)
            {
                RectClr=RectClr1;
                TxtClr=TxtClr1;
                UpClr=UpClr1;
                DnClr=DnClr1;
            }
       
       DrawPanel();
      
      
//----

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pref);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----

      if ( iAO( NULL , Period(), 1)< iAO( NULL , Period(), 0) ) 
         {codeAO=217; ClrAO=UpClr; } else
         {codeAO=218; ClrAO=DnClr;}
         
      if (iAC( NULL , Period(), 1)<iAC( NULL , Period(), 0)) 
         {codeAC=217; ClrAC=UpClr;} else
         {codeAC=218; ClrAC=DnClr;} /* */
       
      if( iMACD( NULL , Period(),  
            FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 1)< iMACD( NULL , Period(),  
            FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 0) ) 
          {codeMACD=217; ClrMACD=UpClr;} else
         {codeMACD=218; ClrMACD=DnClr;} 
         
          
      if(Alert_)
            {
               
               if(codeAO==217 && codeAC==217 && codeMACD==217)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are UP at "+TimeToStr(TimeCurrent(),TIME_MINUTES)); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
               if(codeAO==218 && codeAC==218 && codeMACD==218)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are DOWN at "+TimeToStr(TimeCurrent(),TIME_MINUTES) ); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
            }
          
      if(ObjectFind(Pref+"Unidirection Alert")<0)
            Alert_=!Alert_;
      if(Alert_)Alert_Clr=UpClr; else Alert_Clr=DnClr;
      
      if(ObjectFind(Pref+"Allow Hand Moving")<0)
            Allow_Hand_Moving=!Allow_Hand_Moving;
            
      if(Allow_Hand_Moving)
            {
               
               HandClr=UpClr; 
               int TimeX_=ObjectGet(Pref+"Rect",OBJPROP_TIME1);
                    if(TimeX_>Time[WindowFirstVisibleBar()]+X*Period()*60) 
                    X=(TimeX_-Time[WindowFirstVisibleBar()])/Period()/60;
            
              double PriceY_=ObjectGet(Pref+"Rect",OBJPROP_PRICE1);
                    if(PriceY_<WindowPriceMax()-Y*Point) 
                    Y=(WindowPriceMax()-PriceY_)/Point; /**/
                    
             if(ObjectFind(Pref+"Rect")<0)
                  {X=0;Y=0;}            
            }
            else HandClr=DnClr;  
            
      DrawPanel();
//----
   return(0);
  }
//+------------------------------------------------------------------+
int DrawText( string name, datetime T, double P, string Text, int code=0, color Clr=Green,  int Fsize=10, int Win=0)
   { 
      if (name=="") name="Text_"+T;
      
      int Error=ObjectFind(name);// Запрос 
   if (Error!=Win)// Если объекта в ук. окне нет :(
    { 
      ObjectCreate(name, OBJ_TEXT, Win, T, P);
      }
      
      ObjectSet(name, OBJPROP_TIME1, T);
      ObjectSet(name, OBJPROP_PRICE1, P);
      if(code==0)
      ObjectSetText(name, Text ,Fsize,"Arial",Clr);
      else
      ObjectSetText(name, CharToStr(code), Fsize,"Wingdings",Clr);
   }
   
//--------------------------------------
void DrawPanel()
{     if(Y<0) Y=0;
      if(Y>(WindowPriceMax()-WindowPriceMin())/Point-H)
       Y=(WindowPriceMax()-WindowPriceMin())/Point-H;
      
      TimeX=Time[WindowFirstVisibleBar()]+X*Period()*60; 
      PriceY=WindowPriceMax()-Y*Point;
      
      DrawRect( Pref+"Rect", TimeX, PriceY, TimeX+TimeW ,PriceY-PriceH, RectClr, 1, "");
      
      DrawText( Pref+"Allow Hand Moving", TimeX+1*Period()*60, PriceY-1*Point, "", 73, HandClr );
      DrawText( Pref+"Unidirection Alert", TimeX+1*Period()*60, PriceY-(1+StepS)*Point, "", 37, Alert_Clr );
      
      DrawText( Pref+"AO", TimeX+4*Period()*60, PriceY-1*Point, "AO", 0,TxtClr );//0, 10, 0
      DrawText( Pref+"AC", TimeX+4*Period()*60, PriceY-(1+StepS)*Point, "AC", 0,TxtClr );
      DrawText( Pref+"MACD", TimeX+3*Period()*60, PriceY-(1+2*StepS)*Point, "MACD", 0,TxtClr );
      
      DrawText( Pref+"AO direction", TimeX+8*Period()*60, PriceY-1*Point, "", codeAO, ClrAO );
      DrawText( Pref+"AC direction", TimeX+8*Period()*60, PriceY-(1+StepS)*Point, "", codeAC, ClrAC );
      DrawText( Pref+"MACD direction", TimeX+8*Period()*60, PriceY-(1+2*StepS)*Point, "", codeMACD, ClrMACD );
}

//---------------------------------
int DrawRect( string name, datetime T1, double P1,datetime T2, double P2,
                    color Clr=Green, int Width=1, string Text="", int Win=0)
   { 
      if (name=="") name="Text_"+T1;
      
      int Error=ObjectFind(name);// Запрос 
    if (Error!=Win)// Если объекта в ук. окне нет :(
    {  
      ObjectCreate(name, OBJ_RECTANGLE, Win,T1,P1,T2,P2);//создание трендовой линии
    }
     
    ObjectSet(name, OBJPROP_TIME1 ,T1);
    ObjectSet(name, OBJPROP_PRICE1,P1);
    ObjectSet(name, OBJPROP_TIME2 ,T2);
    ObjectSet(name, OBJPROP_PRICE2,P2);
    ObjectSet(name,OBJPROP_BACK, false);
    ObjectSet(name,OBJPROP_STYLE,0);
    ObjectSet(name, OBJPROP_COLOR , Clr);
    ObjectSet(name, OBJPROP_WIDTH , Width);
    ObjectSetText(name,Text);
    
    }
///-----------------------
void Delete_My_Obj(string Prefix)
   {//Alert(ObjectsTotal());
   for(int k=ObjectsTotal()-1; k>=0; k--)  // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if (Head==Prefix)// Найден объект, ..
         {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
         }                
        
     }
   }
///=====================
string PeriodToStr(int Per)
   {
      switch(Per)                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return("M1"); break;// Таймфрейм М1      
      case     5: return("M5"); break;// Таймфрейм М5      
      case    15: return("M15"); break;// Таймфрейм М15      
      case    30: return("M30"); break;// Таймфрейм М30      
      case    60: return("H1"); break;// Таймфрейм H1      
      case   240: return("H4"); break;// Таймфрейм H4      
      case  1440: return("D1"); break;// Таймфрейм D1      
      case 10080: return("W1"); break;// Таймфрейм W1      
      case 43200: return("МN"); break;// Таймфрейм МN     
      }
 }
//==================================
int CalculeH()
   {
      switch(Period())                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return(15); break;// Таймфрейм М1      
      case     5: return(15); break;// Таймфрейм М5      
      case    15: return(30); break;// Таймфрейм М15      
      case    30: return(45); break;// Таймфрейм М30      
      case    60: return(60); break;// Таймфрейм H1      
      case   240: return(180); break;// Таймфрейм H4      
      case  1440: return(270); break;// Таймфрейм D1      
      case 10080: return(450); break;// Таймфрейм W1      
      case 43200: return(900); break;// Таймфрейм МN     
      }   
    } }