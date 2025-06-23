//+------------------------------------------------------------------+
//|                                                      Triniti.mq4 |
//|                                                            Extra |
//|                                            chart.extra@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Extra"
#property link      "chart.extra@gmail.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 DarkTurquoise
#property indicator_color2 DarkTurquoise
#property indicator_color3 Crimson
#property indicator_color4 DarkTurquoise
#property indicator_color5 Red
extern int History=500;// elõzmények korlátozása
extern int Previous=100;// összehasonlitás bárok száma
extern int Bwidth=1;// összehasonlítás tûrés
extern int Delay=3;
extern int Equal=5;
extern bool Opti=true;
extern int Atr=25; //megemelt kitöréspont atr szerint
//--- buffers
double Buffer3[],Buffer4[],Buffer2[],Buffer1[],Buffer5[];
//     ellenálás/ támasz  / cél sh  /  cél Lo / stopp
double win,win1=0,ck=0,cel=0,stp=0,ol,ol1,ok,ok1,ok2;//opti  változók
int cc=0,oeq,eq1,drw=1;
string wc,wii,wii1,wii2;
color col;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,3);
   SetIndexArrow(0,80);
   SetIndexBuffer(0,Buffer1);

   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,3);
   SetIndexArrow(1,80);
   SetIndexBuffer(1,Buffer2);
   SetIndexBuffer(2,Buffer3);
   SetIndexStyle(2,DRAW_ARROW,STYLE_SOLID,0);
   SetIndexArrow(2,249);
   SetIndexBuffer(3,Buffer4);
   SetIndexStyle(3,DRAW_ARROW,STYLE_SOLID,0);
   SetIndexArrow(3,249);
   SetIndexStyle(4,DRAW_ARROW,STYLE_SOLID,2);
   SetIndexArrow(4,253);
   SetIndexBuffer(4,Buffer5);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll(0,OBJ_TEXT); //------------törlések---------------
   ObjectsDeleteAll(0,OBJ_ARROW);
   ObjectsDeleteAll(0,OBJ_LABEL);
   return(0);
  }
//----

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Opti==true)
     {
      drw=0;
      ObjectCreate("OP",OBJ_LABEL,0,0,0);
      ObjectSet("OP",OBJPROP_CORNER,1);
      ObjectSet("OP",OBJPROP_XDISTANCE,15);
      ObjectSet("OP",OBJPROP_YDISTANCE,5);
      ObjectSetText("OP","Estimated data!",12,"Arial",White);
      ObjectCreate("OP1",OBJ_LABEL,0,0,0);
      ObjectSet("OP1",OBJPROP_CORNER,1);
      ObjectSet("OP1",OBJPROP_XDISTANCE,10);
      ObjectSet("OP1",OBJPROP_YDISTANCE,21);
      ObjectSetText("OP1","Equal / winrate / pip / win%",8,"Arial",White);
      logo();
      eq1=1;
      while(eq1<=13)
        {
         opti();
         wii1=DoubleToStr(win1,0);
         wii=DoubleToStr(win,0);
         if(MathAbs(ok1)>1000)wii2="hi ! ";
         else wii2=DoubleToStr(ok1,0)+" p";
         double wwc=0;
         if(win!=0) wwc=(win1/win)*100;
         if(ok1>=ok2){ok2=ok1;ok=eq1;}
         col=Yellow;
         if(wwc==0)wc="0";else wc=DoubleToStr(wwc,0);
         if(ok1>0)col=LimeGreen;
         if(ok1<-50)col=Red;
         string Opt="eq "+eq1,Opt1=eq1,Opt2="Q"+eq1;
         ObjectCreate(Opt,OBJ_LABEL,0,0,0);
         ObjectSet(Opt,OBJPROP_CORNER,1);
         ObjectSet(Opt,OBJPROP_XDISTANCE,110);
         ObjectSet(Opt,OBJPROP_YDISTANCE,20+eq1*12);
         ObjectSetText(Opt,Opt,8,"Arial",col);
         ObjectCreate(Opt1,OBJ_LABEL,0,0,0);
         ObjectSet(Opt1,OBJPROP_CORNER,1);
         ObjectSet(Opt1,OBJPROP_XDISTANCE,45);
         ObjectSet(Opt1,OBJPROP_YDISTANCE,20+eq1*12);
         ObjectSetText(Opt1,"~"+wii+"/"+wii1+"   "+wii2,8,"Arial",col);
         ObjectCreate(Opt2,OBJ_LABEL,0,0,0);
         ObjectSet(Opt2,OBJPROP_CORNER,1);
         ObjectSet(Opt2,OBJPROP_XDISTANCE,10);
         ObjectSet(Opt2,OBJPROP_YDISTANCE,20+eq1*12);
         ObjectSetText(Opt2,wc+"%",8,"Arial",col);
         win=0;win1=0;wc="na";wii="0";wii1="0";ok1=0;
         eq1++;
        }
     }
   eq1=Equal;
   drw=1;
   opti();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int opti()
  {
   int i,k,s=10;
   double x,x1,y,y1,z,z1,s1,s2,h1,h2,j1,j2,j3,j4,v,a,a1,b,b1,Now1;
   datetime tim1;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+3;
   i=limit;
   if(i>History-1) i=History-1;
   while(i>=0)
     {
      k=i+Previous;                                  // összehasonlitás bárok száma
      x=High[i];    //Aktuális bár legmagasabb

      x1=Low[i];    //Aktuális bár legalacsonyabb
      while(k>=0)
        {
         y=High[k];    //Régebbi bárok legmagasabb
         y1=Low[k];    //Régebbi bárok legalacsonyabb
         if(x>=(y-Bwidth*Point) && x<y)z++;               //long, ha található régebbi báron azonosság akkor z+1
         if(x1<=y1+Bwidth*Point && x1>y1)z1++;            //short, ha található régebbi báron azonosság akkor z1+1
         k--;
        }//---------------------------------------------------------1 vizsgálat vége---------
      double atr=iATR(NULL,0,Atr,i);                    // kitörés feltétel Atr szerint
      if(z>eq1)s1=High[i]+atr;                    // összehasonlítás átlagos-tényleges
      if(z1>eq1)s2=Low[i]-atr;                    // -II-
      if(s1==h1)j1++; else j1=0;                      //ha nincs új vonal akkor tartja a régit
      if(s2==h2)j2++; else j2=0;                   // -II-
      if(j1>Delay)Buffer3[i]=s1; else j3=0;        //késleltetett megjelenítés
      if(j2>Delay)Buffer4[i]=s2;else  j4=0;       //csak akkor jelenik meg a vonal ha hosszabb 
      //------------------------------------------------zászlók stb névgenerálás----------------------------------
      string text=DoubleToStr(s1,4),text1=DoubleToStr(s2,4),TP,SL,TP1,SL1,Now;
      TP="TP "+DoubleToStr(b,3);
      TP1="TP "+DoubleToStr(a,3);
      SL=DoubleToStr(a1,3);
      SL1=DoubleToStr(a,3);
      //------------------------------------------------rajzolási kordináták meghatározása------------------------
      tim1=iTime(NULL,0,i+2);
      //Comment(lk);
      Now=DoubleToStr(iMA(NULL,0,Bwidth,0,MODE_SMA,PRICE_MEDIAN,i),4);//kitörési pont
      //----------------------------------------------------------------------------------------------------------
      v=MathAbs(s1-s2);                                 // cél/stop különbözet
      a=Low[i]-v+Bwidth*Point;                       // short cél 
      a1=Low[i]+v;                                      // shotr stopp
      b=High[i]+v-Bwidth*Point;                      // long cél
      b1=High[i]-v;                                     // long stopp
      //-------------------------------------------------------------kitörés feltétel  vizsgálat 
      if(Low[i+1]>s1 && Low[i+2]>s1 && j3==0 && s1>Open[i+3] && atr<Volume[i])
         //------------------------------------------------------------------Rajzolások------------------------------
        {
         Now1=(a+b)/2;win++;//kitörési ár meghatározása
         if(drw==1)
           {
            Buffer1[i]=b;Buffer5[i]=b1;
            ObjectCreate(Now,OBJ_ARROW,0,tim1,Now1,0,0);
            ObjectSet(Now,OBJPROP_ARROWCODE,236);
            ObjectSet(Now,OBJPROP_COLOR,White);
            ObjectCreate(text,OBJ_ARROW,0,tim1,b1,0,0);
            ObjectSet(text,OBJPROP_ARROWCODE,5);
            ObjectSet(text,OBJPROP_COLOR,Crimson);
            ObjectCreate(SL1,OBJ_ARROW,0,tim1,b,0,0,0,0);
            ObjectSet(SL1,OBJPROP_ARROWCODE,5);
            ObjectSet(SL1,OBJPROP_COLOR,DarkTurquoise);
           }
         j3=1;cel=b;cc=1;stp=b1;
        }
      //-----------------------------------------------szakadási feltétel  vizsgála-------------------------------
      if(j2>2)
        {
         if(High[i+1]<s2 && High[i+2]<s2 && j4==0 && s2<Open[i+3] && atr<Volume[i])
            //--------------------------------------------------------------------------------------------------------
           {
            j4=1;win++;Now1=(a+b)/2;//szakadási ár meghatározása
            if(drw==1)
              {
               Buffer2[i]=a;Buffer5[i]=a1;
               ObjectCreate(Now,OBJ_ARROW,0,tim1,Now1,0,0);
               ObjectSet(Now,OBJPROP_ARROWCODE,238);
               ObjectSet(Now,OBJPROP_COLOR,White);
               ObjectCreate(text1,OBJ_ARROW,0,tim1,a1,0,0);
               ObjectSet(text1,OBJPROP_ARROWCODE,5);
               ObjectSet(text1,OBJPROP_COLOR,Crimson);
               ObjectCreate(SL,OBJ_ARROW,0,tim1,a,0,0);
               ObjectSet(SL,OBJPROP_ARROWCODE,5);
               ObjectSet(SL,OBJPROP_COLOR,DarkTurquoise);
              }
            cel=a;cc=1;stp=a1;
           }
        }//---------------------------------------------------------------------rajzolások vége----------------------------------
      z=0;z1=0;h1=s1;h2=s2; // feltétel számoló változók: ismétlõdés stb nullázása

      if(High[i]>cel && Low[i]<cel && cc==1){win1++;cc=0;ok1=ok1+(MathAbs(cel-Now1)/Point);}
      //if(High[i]>stp&&Low[i]<stp&&cc==1){cc=0;ok1=ok1-(MathAbs(stp-Now1)/Point);}
      i--;
     }                            // ciklus újra
     return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int logo()
  {
   ObjectCreate("Logo",OBJ_LABEL,0,0,0);
   ObjectSet("Logo",OBJPROP_CORNER,3);
   ObjectSet("Logo",OBJPROP_XDISTANCE,5);
   ObjectSet("Logo",OBJPROP_YDISTANCE,8);
   ObjectSetText("Logo","gg",48,"Webdings",Crimson);
   ObjectCreate("Logo2",OBJ_LABEL,0,0,0);
   ObjectSet("Logo2",OBJPROP_CORNER,3);
   ObjectSet("Logo2",OBJPROP_XDISTANCE,11);
   ObjectSet("Logo2",OBJPROP_YDISTANCE,24);
   ObjectSetText("Logo2","Triniti",36,"Times New Roman",DarkTurquoise);
   ObjectCreate("Logo1",OBJ_LABEL,0,0,0);
   ObjectSet("Logo1",OBJPROP_CORNER,3);
   ObjectSet("Logo1",OBJPROP_XDISTANCE,12);
   ObjectSet("Logo1",OBJPROP_YDISTANCE,14);
   ObjectSetText("Logo1","chart.extra@gmail.com",8,"Arial",White);
   return(0);
  }
//+------------------------------------------------------------------+
