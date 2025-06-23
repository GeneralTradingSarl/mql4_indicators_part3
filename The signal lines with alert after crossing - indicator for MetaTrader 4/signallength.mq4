//+------------------------------------------------------------------+
//|                                                 signallength.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Хлыстов Владимр"
#property link      "сmillion@narod.ru"
extern color ЦВЕТ_сопротивления = Orange;
extern color ЦВЕТ_поддержки     = Aqua;
extern int Уставка=4,
           время_уставки=10;
int X1u,X2u,X3u,X1d,X2d,X3d,bar_1u,bar_2u,bar_3u,bar_1d,bar_2d,bar_3d,время_пер,
    X1g,X2g,per;
double Y1vg,Y2vg,Y1ng,Y2ng,Y1u,Y2u,Y3u,Y1d,Y2d,Y3d;
double ширина_канала;
extern bool удалять_отрезки = true;//удалять_отрезки_при_смене_периода
#property indicator_chart_window
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int init()
{
   per=Period();
   return(0);
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int deinit()
{
   ObjectDelete("Линия сопротивления");
   ObjectDelete("Линия поддержки");
   del("Пересечение ");
   if (удалять_отрезки==true) del("граница");
   return(0);
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int start()
{
   while(true)
   {
      if (время_пер!=Time[0])
      {
         if (bar_3u != поиск_фрактала(0, 1) || (ObjectFind("Линия сопротивления")!=0))
         {
            bar_3u = поиск_фрактала(0,     1);
            bar_2u = поиск_фрактала(bar_3u,-1);
            bar_1u = поиск_фрактала(bar_2u, 1);
            X1u=Time[bar_1u];Y1u=High[bar_1u];X2u=Time[bar_3u];Y2u=High[bar_3u];
            ObjectDelete("Линия сопротивления");
            ObjectCreate("Линия сопротивления", OBJ_TREND, 0,X1u,Y1u,X2u,Y2u);
            ObjectSet   ("Линия сопротивления", OBJPROP_COLOR, ЦВЕТ_сопротивления);
            ObjectSet   ("Линия сопротивления", OBJPROP_STYLE, STYLE_DASH);
            ObjectSet   ("Линия сопротивления", OBJPROP_WIDTH, 0);
            ObjectSet   ("Линия сопротивления", OBJPROP_BACK,  true);
            ObjectSet   ("Линия сопротивления", OBJPROP_RAY,   true);
            рисуем_границы(ЦВЕТ_сопротивления,X1u,Y1u,X2u,Y2u);
         }
         //-----------------------------------------------------------------------
         if (bar_3d != поиск_фрактала(0,-1) || (ObjectFind("Линия поддержки")!=0))
         {
            bar_3d = поиск_фрактала(0,    -1);
            bar_2d = поиск_фрактала(bar_3d, 1);
            bar_1d = поиск_фрактала(bar_2d,-1);
            X1d=Time[bar_1d];Y1d=Low[bar_1d];X2d=Time[bar_3d];Y2d=Low[bar_3d];
            ObjectDelete("Линия поддержки");
            ObjectCreate("Линия поддержки", OBJ_TREND, 0,X1d,Y1d,X2d,Y2d);
            ObjectSet   ("Линия поддержки", OBJPROP_COLOR, ЦВЕТ_поддержки);
            ObjectSet   ("Линия поддержки", OBJPROP_STYLE, STYLE_DASH);
            ObjectSet   ("Линия поддержки", OBJPROP_WIDTH, 0);
            ObjectSet   ("Линия поддержки", OBJPROP_BACK,  true);    
            ObjectSet   ("Линия поддержки", OBJPROP_RAY,   true);
            рисуем_границы(ЦВЕТ_поддержки,X1d,Y1d,X2d,Y2d);
         }
         //-----------------------------------------------------------------------
         int d=0;
         int    X_1,X_2;
         double Y_1,Y_2;
         color ЦВЕТ;
         for(int n=ObjectsTotal()-1; n>=0; n--) 
         {
            string Obj_N=ObjectName(n);
            if (StringFind(Obj_N,"граница",0)!=-1 && ObjectType(Obj_N)==OBJ_TREND)//найден обьект-тренд к которому вычисляется приближение
            {
               X_1 = ObjectGet(Obj_N, OBJPROP_TIME1); 
               X_2 = ObjectGet(Obj_N, OBJPROP_TIME2); 
               if (X_1==X_2) {ObjectDelete(Obj_N);continue;}
               Y_1 = ObjectGet(Obj_N, OBJPROP_PRICE1);
               Y_2 = ObjectGet(Obj_N, OBJPROP_PRICE2);
               ЦВЕТ= ObjectGet(Obj_N, OBJPROP_COLOR);
               //рисуем_зону_контроля(Obj_N,ЦВЕТ, X_1,Y_1,X_2,Y_2);
               if (X_1<=Time[0] && X_2>=Time[0])//попадает во временной диапазон
               {
                  X3d=Time[0];Y3d=Y_1+(Y_2-Y_1)*(X3d-X_1)/(X_2-X_1);//уравнение прямой
                  //Comment((Y3d-Bid)/Point);
                  if (MathAbs(Y3d-Bid)/Point < Уставка)
                  { 
                     if (ЦВЕТ==ЦВЕТ_сопротивления)//нижняя граница
                           {d=-1;break;}
                     else  {d= 1;break;}
                  }
               }
            }
         }
         //-----------------------------------------------------------------------
         if (d!=0)
         {
            ObjectCreate("Пересечение "+Obj_N+" "+Time[0], OBJ_ARROW,0,Time[0],Bid,0,0,0,0);
            ObjectSet   ("Пересечение "+Obj_N+" "+Time[0], OBJPROP_WIDTH, 0);
            if (d==1)
            {
               ObjectSet   ("Пересечение "+Obj_N+" "+Time[0], OBJPROP_ARROWCODE,233);
               ObjectSet   ("Пересечение "+Obj_N+" "+Time[0], OBJPROP_COLOR, ЦВЕТ_поддержки);    // Цвет   
               Alert(Symbol()+"Пересечение границы поддержки "+Obj_N);
            }
            else
            {
               ObjectSet   ("Пересечение "+Obj_N+" "+Time[0], OBJPROP_ARROWCODE,234);
               ObjectSet   ("Пересечение "+Obj_N+" "+Time[0], OBJPROP_COLOR, ЦВЕТ_сопротивления);    // Цвет   
               Alert(Symbol()+"Пересечение границы сопротивления "+Obj_N);
            }
            время_пер=Time[0];
         }
      }
      if ((ObjectFind("Нижняя граница "+string_пер(per))==0)&&(ObjectFind("Верхняя граница "+string_пер(per))==0)) 
         return(0);
      else 
      {
         ObjectDelete("Линия сопротивления");
         ObjectDelete("Линия поддержки");
         время_пер=Time[1];
      }
   }
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//////////////////////////////////////////////////////////////////////
int поиск_фрактала(int bar, int UP_DN)
{
   while(true)//ищем 1 фрактал после bar
   {
      bar++;
      if (UP_DN == 1 && iFractals(NULL, 0, MODE_UPPER, bar) != 0) return(bar);
      if (UP_DN ==-1 && iFractals(NULL, 0, MODE_LOWER, bar) != 0) return(bar);
   } 
   return(0);  
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int del(string Ob)
{
   for(int n=ObjectsTotal()-1; n>=0; n--) 
   {
      string Obj_Name=ObjectName(n);
      if (StringFind(Obj_Name,Ob,0) != -1) ObjectDelete(Obj_Name);
   }
   return;
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
string string_пер(int p)
{  switch(p)
   {  case 1    : return("M_1"); break;  //1 минута
      case 5    : return("M_5"); break;  //5 минут 
      case 15   : return("M15"); break; //15 минут
      case 30   : return("M30"); break; //30 минут
      case 60   : return("H 1"); break;  //1 час
      case 240  : return("H_4"); break;  //4 часа
      case 1440 : return("D_1"); break;  //1 день
      case 10080: return("W_1"); break;  //1 неделя
      case 43200: return("MN1"); break; //1 месяц
   }return("ошибка периода");
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int рисуем_границы(color цвет,int X1,double Y1,int X2,double Y2)
{
   string Name = "граница "+string_пер(per);
   if (цвет==ЦВЕТ_сопротивления) Name = "Верхняя "+Name;
   if (цвет==ЦВЕТ_поддержки)     Name = "Нижняя " +Name;
   if (ObjectFind(Name)==0) return; //Если обьект существует
   X1g=Time[0];X2g=Time[0]+per*60*время_уставки;
   if (цвет==ЦВЕТ_сопротивления) {Y1vg=Y1+(Y2-Y1)*(X1g-X1)/(X2-X1);Y2vg=Y1+(Y2-Y1)*(X2g-X1)/(X2-X1);
                                  ObjectCreate(Name, OBJ_TREND, 0,X1g,Y1vg,X2g,Y2vg);}
   if (цвет==ЦВЕТ_поддержки)     {Y1ng=Y1+(Y2-Y1)*(X1g-X1)/(X2-X1);Y2ng=Y1+(Y2-Y1)*(X2g-X1)/(X2-X1);
                                  ObjectCreate(Name, OBJ_TREND, 0,X1g,Y1ng,X2g,Y2ng);}
   ObjectSet   (Name, OBJPROP_COLOR, цвет);
   ObjectSet   (Name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet   (Name, OBJPROP_WIDTH, 4);
   ObjectSet   (Name, OBJPROP_BACK,  false);
   ObjectSet   (Name, OBJPROP_RAY,   false);
   return;
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж


///////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж

//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж
//*////////////////////////////////////////////////////////////////*//
int рисуем_границы(color цвет,int X1,double Y1,int X2,double Y2)
{
   string Name = "граница "+string_пер(per);
   if (цвет==ЦВЕТ_сопротивления) Name = "Верхняя "+Name;
   if (цвет==ЦВЕТ_поддержки)     Name = "Нижняя " +Name;
   if (ObjectFind(Name)==0) return; //Если обьект существует
   X1g=Time[0];X2g=Time[0]+per*60*время_уставки;
   if (цвет==ЦВЕТ_сопротивления) {Y1vg=Y1+(Y2-Y1)*(X1g-X1)/(X2-X1);Y2vg=Y1+(Y2-Y1)*(X2g-X1)/(X2-X1);
                                  ObjectCreate(Name, OBJ_TREND, 0,X1g,Y1vg,X2g,Y2vg);}
   if (цвет==ЦВЕТ_поддержки)     {Y1ng=Y1+(Y2-Y1)*(X1g-X1)/(X2-X1);Y2ng=Y1+(Y2-Y1)*(X2g-X1)/(X2-X1);
                                  ObjectCreate(Name, OBJ_TREND, 0,X1g,Y1ng,X2g,Y2ng);}
   ObjectSet   (Name, OBJPROP_COLOR, цвет);
   ObjectSet   (Name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet   (Name, OBJPROP_WIDTH, 4);
   ObjectSet   (Name, OBJPROP_BACK,  false);
   ObjectSet   (Name, OBJPROP_RAY,   false);
   return;
}
//*////////////////////////////////////////////////////////////////*//
//жжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжжж


