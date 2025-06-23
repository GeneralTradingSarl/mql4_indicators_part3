//=======================================================================================================================
// Relax_GoToSleep.mq4
// (c) 2008 DolSergon
//
//        :)
//
//=======================================================================================================================
#property copyright "(c) 2008 DolSergon"
#property link      ""
//-------------------------------------------------------------------------------------------------------------------
#property indicator_chart_window      
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Magenta
#property indicator_width2 6
#property indicator_color3 White
#property indicator_width3 20
#property indicator_color4 Blue
#property indicator_width4 10

double BufMA[];     
double BufFace[];     
double BufAir[];     
double BufHand[];     
               
double BufMA1[1000];
double BufMA1Rnd[1000];

int		Face1 = 74, Face1Pos = 0, FaceDirect = 1;
int		AirPos = 0;
double 	AirPrice;

//=======================================================================================================================
int init() {
	IndicatorBuffers(4);
	
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, BufMA);

   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 74);
   SetIndexBuffer(1, BufFace);
   SetIndexEmptyValue(1, 0.0);
   
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 81);
   SetIndexBuffer(2, BufAir);
   SetIndexEmptyValue(2, 0.0);
   SetIndexShift(2, 100);
   
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 71);
   SetIndexBuffer(3, BufHand);
   SetIndexEmptyValue(3, 0.0);
   SetIndexShift(3, 2);

   return(0);
}


  
//=======================================================================================================================
int start() {
  	int b;
  	int n;
	double   val1;

	ArraySetAsSeries(BufMA1, true);
	ArraySetAsSeries(BufMA1Rnd, true);


	// MA1 ----------------------------------------------------------------------------------------
	for (b=999; b>=1; b--) {
    	BufMA1Rnd[b] = BufMA1Rnd[b-1];  
	}
	// Функция возвращает псевдослучайное целое число в дипазоне от 0 до 32767. 
	BufMA1Rnd[0] = (MathRand() / 1000) * Point - 15 * Point;
   
   for (b=0; b<1000; b++) {
      BufMA1[b] = Close[b] + BufMA1Rnd[b];  
   }
   
   for (b=0; b<1000; b++) {
      val1 = iMAOnArray(BufMA1, 1000, 7, 0, MODE_LWMA, b);
      BufMA[b] = val1;  
   }




	// FACE1 --------------------------------------------------------------------------------------
   	SetIndexArrow(1, Face1);
   	Face1++;
	if (Face1 > 76) {
   		Face1 = 74;
   		Face1Pos = Face1Pos + FaceDirect;
   		if (Face1Pos > 50) {
   			FaceDirect = -1;
   		}
   		if (Face1Pos < 0) {
   			FaceDirect = 1;
   		}
   	}
   for (b=0; b<1000; b++) {
      BufFace[b] = 0;  
   }
   	//SetIndexArrow(1, Face1);
	BufFace[Face1Pos] = High[Face1Pos] + 10*Point;






	// AIR ----------------------------------------------------------------------------------------
	AirPos--;
	if (AirPos < 0) {
		AirPos = 200;
		AirPrice = Low[1];
	}
	
   	for (b=0; b<1000; b++) {
    	BufAir[b] = 0;  
   	}
    BufAir[AirPos] = AirPrice;  
	
	
	
	
	
	// Hand ---------------------------------------------------------------------------------------
	if (MathRand() > 16383) {
   		SetIndexArrow(3, 71);
		BufHand[0] = Close[0] + 0*Point;
	} else {
   		SetIndexArrow(3, 72);
		BufHand[0] = Close[0] - 0*Point;
	}
	BufHand[1] = 0;
	
	
   return(0);
}

 

