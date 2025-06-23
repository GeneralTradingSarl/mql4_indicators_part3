#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_type1 DRAW_ARROW
#property indicator_type2 DRAW_ARROW
#property indicator_color1 clrDeepSkyBlue
#property indicator_color2 clrTomato
#property indicator_width1 2
#property indicator_width2 2

input int      inp_size       = 2;     // size

double ext_arrow_up[];
double ext_arrow_dn[];
double ext_trend[];
double ext_fractal_up[];
double ext_fractal_dn[];

//+------------------------------------------------------------------+
int OnInit() {
   IndicatorBuffers(5);

   SetIndexBuffer(0,ext_arrow_up);
   SetIndexBuffer(1,ext_arrow_dn);
   SetIndexBuffer(2,ext_trend);
   SetIndexBuffer(3,ext_fractal_up);
   SetIndexBuffer(4,ext_fractal_dn);
   SetIndexArrow(0,217);
   SetIndexArrow(1,218);

   return(INIT_SUCCEEDED);
}
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
                const int &spread[]) {

   int limit = prev_calculated > 0 ? 
               rates_total - prev_calculated - inp_size :
               rates_total - inp_size - 1;

   for(int i=limit; i>=inp_size; i--) {
      // find new fractals
      bool is_new_up = i == iHighest(NULL, PERIOD_CURRENT, MODE_HIGH, inp_size*2+1, i-inp_size);
      bool is_new_dn = i == iLowest(NULL, PERIOD_CURRENT, MODE_LOW, inp_size*2+1, i-inp_size);
   
      // update fractals data
      ext_fractal_up[i] = ext_fractal_up[i+1];
      if(is_new_up) 
         ext_fractal_up[i] = high[i];
      ext_fractal_dn[i] = ext_fractal_dn[i+1];
      if(is_new_dn) 
         ext_fractal_dn[i] = low[i];
         
      // check trend
      bool trend_changed = false;
      ext_trend[i] = ext_trend[i+1];
      if(ext_trend[i] != 1 && low[i] <= ext_fractal_dn[i+1]) {
         ext_trend[i]   = 1;
         trend_changed  = true;
      }
      if(ext_trend[i] != 0 && high[i] >= ext_fractal_up[i+1]) {
         ext_trend[i]   = 0;
         trend_changed  = true;
      }
      
      // draw fractal
      if(ext_trend[i] == 0 && (trend_changed || ( is_new_dn && ext_fractal_dn[i] > ext_fractal_dn[i+1] )) ) 
         ext_arrow_dn[i] = ext_fractal_dn[i] - iATR(NULL, PERIOD_CURRENT, 14, i) / 3.0;
      if(ext_trend[i] == 1 && (trend_changed || ( is_new_up && ext_fractal_up[i] < ext_fractal_up[i+1] )) ) 
         ext_arrow_up[i] = ext_fractal_up[i] + iATR(NULL, PERIOD_CURRENT, 14, i) / 3.0;
      
         
   }
   


   return(rates_total);
}
//+------------------------------------------------------------------+
