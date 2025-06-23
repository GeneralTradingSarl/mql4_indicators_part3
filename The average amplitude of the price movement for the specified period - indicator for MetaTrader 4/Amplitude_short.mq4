//+------------------------------------------------------------------+
//|                                              		 Amplitude.mq4 |
//|                                                        komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
#property copyright "komposter"
#property link      "mailto:komposterius@mail.ru"

#property indicator_separate_window
#property indicator_minimum 0
#property  indicator_buffers 5
#property  indicator_color1  Red
#property  indicator_color2  Lime
#property  indicator_color3  White
#property  indicator_color4  White
#property  indicator_color5  White

double buf0[]; //High-Low Average
double buf1[]; //Body Average
double buf2[]; //Up_Shadow Average
double buf3[]; //Down_Shadow Average
double buf4[]; //Summ_Shadow Average

extern int AveragePeriod = 21;
extern int DrawBars		 = 100;

int init()
{
	IndicatorShortName( "Amplitude (" + AveragePeriod + " bars average)   -   " );
	IndicatorDigits ( 2 );

	SetIndexBuffer ( 0 , buf0 );
	SetIndexDrawBegin ( 0 , AveragePeriod );
	SetIndexLabel( 0 , "High-Low");

	SetIndexBuffer ( 1 , buf1 );
	SetIndexDrawBegin ( 1 , AveragePeriod );
	SetIndexLabel( 1 , "Open-Close");

	SetIndexBuffer ( 2 , buf2 );
	SetIndexStyle ( 2 , DRAW_LINE, STYLE_DOT );
	SetIndexDrawBegin ( 2 , AveragePeriod );
	SetIndexLabel( 2 , "Up_Shadow");

	SetIndexBuffer ( 3 , buf3 );
	SetIndexStyle ( 3 , DRAW_LINE, STYLE_DOT );
	SetIndexDrawBegin ( 3 , AveragePeriod );
	SetIndexLabel( 3 , "Down_Shadow");

	SetIndexBuffer ( 4 , buf4 );
	SetIndexDrawBegin ( 4 , AveragePeriod );
	SetIndexLabel( 4 , "Summ_Shadow");

return(0);
}

int start()
{
	int counted_bars=IndicatorCounted();
	if ( counted_bars < 0 ) { Print( "Indicator Error (Counted bars < 0)!" ); return(-1); }
	if ( Bars < 100 ) { Print( "Indicator Error (Bars < 100)!" ); return(-1); }
	if ( AveragePeriod > Bars - 1 ) { IndicatorShortName( "Indicator Error (Bars < AveragePeriod)!" ); Print( "Indicator Error (BARS < AveragePeriod)!" ); return(-1); }
	if ( DrawBars > Bars - 1 || DrawBars <= 0 ) { DrawBars = Bars - 1; }
	if ( DrawBars <= AveragePeriod ) { DrawBars = AveragePeriod + 1; }

	for ( int i = DrawBars; i >= 0; i -- )
	{
		double buf_tmp = 0, buf_tmp1 = 0, buf_tmp2 = 0, buf_tmp3 = 0, buf_tmp4 = 0;
		int z = 0, z1 = 0, z2 = 0, z3 = 0, z4 = 0;
		double high, low, close, open, point = Point;

		for ( int u = i + AveragePeriod; u >= i; u -- )
		{
			high = High[u]; low = Low[u]; close = Close[u]; open = Open[u];
			
			buf_tmp += ( high - low ) / point;
			if ( ( high - low ) / point == 0 ) z --;

			buf_tmp1 += MathAbs( ( close - open ) ) / point;
			if ( MathAbs( ( close - open ) ) / point  == 0 ) z1 --;

			if ( close - open >= 0 )
			{
				buf_tmp2 += ( high - close ) / point;
				if ( ( high - close ) / point  == 0 ) z2 --;

				buf_tmp3 += ( open - low ) / point;
				if ( ( open - low ) / point  == 0 ) z3 --;
			}
			else
			{
				buf_tmp2 += ( high - open ) / point;
				if ( ( high - open ) / point  == 0 ) z2 --;

				buf_tmp3 += ( close - low ) / point;
				if ( ( close - low ) / point  == 0 ) z3 --;
			}
		}
		buf0[i] = buf_tmp  / ( AveragePeriod + z  );
		buf1[i] = buf_tmp1 / ( AveragePeriod + z1 );
		buf2[i] = buf_tmp2 / ( AveragePeriod + z2 );
		buf3[i] = buf_tmp3 / ( AveragePeriod + z3 );
		buf4[i] = buf2[i] + buf3[i];
	}

return(0);
}

