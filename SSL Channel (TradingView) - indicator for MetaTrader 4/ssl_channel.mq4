//https://www.tradingview.com/script/6y9SkpnV-SSL-Channel/
#property copyright "Bugscoder Studio"
#property link      "https://www.bugscoder.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 5
#property indicator_type1   DRAW_NONE
#property indicator_type2   DRAW_LINE
#property indicator_width2  1
#property indicator_color2  clrDarkSeaGreen
#property indicator_type3   DRAW_LINE
#property indicator_width3  1
#property indicator_color3  clrTomato
#property indicator_type4   DRAW_ARROW
#property indicator_width4  1
#property indicator_color4  clrDarkSeaGreen
#property indicator_type5   DRAW_ARROW
#property indicator_width5  1
#property indicator_color5  clrTomato

input bool wicks = false;
input ENUM_MA_METHOD ma1_type = MODE_SMA;
input ENUM_APPLIED_PRICE ma1_source = PRICE_HIGH;
input int ma1_length = 200;
input ENUM_MA_METHOD ma2_type = MODE_SMA;
input ENUM_APPLIED_PRICE ma2_source = PRICE_LOW;
input int ma2_length = 200;

double Hlv1[], sslUp1[], sslDown1[];
double Buy[], Sell[];
string obj_prefix = "RSIMACDOBOS_";

int OnInit() {
   IndicatorDigits(Digits);
   SetIndexLabel(0, "Hlv1");
   SetIndexBuffer(0, Hlv1);
   SetIndexLabel(1, "sslUp1 (1)");
   SetIndexBuffer(1, sslUp1);
   SetIndexLabel(2, "sslDown1 (2)");
   SetIndexBuffer(2, sslDown1);
   SetIndexLabel(3, "Buy (3)");
   SetIndexBuffer(3, Buy);
   SetIndexArrow(3, 233);
   SetIndexLabel(4, "Sell (4)");
   SetIndexBuffer(4, Sell);
   SetIndexArrow(4, 234);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {

   int startPos = rates_total-prev_calculated-2;
   if (startPos <= 1) { startPos = 1; }
   
   for(int pos=startPos; pos>=0; pos--) {
      double ma1 = iMA(NULL, 0, ma1_length, 0, ma1_type, ma1_source, pos);
      double ma2 = iMA(NULL, 0, ma2_length, 0, ma2_type, ma2_source, pos);
      
      Hlv1[pos]     = (wicks ? High[pos] : Close[pos]) > ma1 ? 1 : (wicks ? Low[pos] : Close[pos]) < ma2 ? -1 : Hlv1[pos+1];
      sslUp1[pos]   = Hlv1[pos] < 0 ? ma2 : ma1;
      sslDown1[pos] = Hlv1[pos] < 0 ? ma1 : ma2;
      
      if (Hlv1[pos] ==  1 && Hlv1[pos+1] == -1) { Buy[pos]  = sslDown1[pos]; }
      if (Hlv1[pos] == -1 && Hlv1[pos+1] ==  1) { Sell[pos] = sslDown1[pos]; }
   }

   return(rates_total);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, obj_prefix);
}

string TimeCleanStr(int pos) {
   string _time = TimeToStr(Time[pos], TIME_DATE|TIME_MINUTES);
   
   StringReplace(_time, ":", "");
   StringReplace(_time, ".", "");
   StringReplace(_time, " ", "");
   
   return _time;
}

double nz(double check, double val = 0) {
   if (check == EMPTY_VALUE || check == 0) {
      return val;
   }
   else {
      return check;
   }
}

template<typename T>
void array_push(T &array[], T txt) {
   int size = ArraySize(array);
   ArrayResize(array, ArraySize(array)+1);
   array[size] = txt;
}

template<typename T>
int array_search(T search, T &haystack[]) {
	int n = -1;
	for(int x=0; x<ArraySize(haystack); x++) {
		if (haystack[x] == search) {
			n = x;
			break;
		}
	}
	return n;
}