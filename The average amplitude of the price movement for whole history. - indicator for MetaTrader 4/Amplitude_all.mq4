//+------------------------------------------------------------------+
//|                                              	Amplitude_All.mq4 |
//|                                      Copyright © 2005, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, komposter"
#property link      "mailto:komposterius@mail.ru"

#property indicator_separate_window
#property indicator_minimum 0
#property  indicator_buffers 5
#property  indicator_color1  Red
#property  indicator_color2  Lime
#property  indicator_color3  Blue
#property  indicator_color4  Blue
#property  indicator_color5  Blue

double buf0[]; //High-Low Average
double buf1[]; //Body Average
double buf2[]; //Up_Shadow Average
double buf3[]; //Down_Shadow Average
double buf4[]; //Summ_Shadow Average

int init()
{
	IndicatorShortName( "Amplitude (All history average)   -   " );
	IndicatorDigits ( 2 );

	SetIndexBuffer ( 0 , buf0 );
	SetIndexStyle ( 0 , DRAW_LINE );
	SetIndexDrawBegin ( 0 , 0 );
	SetIndexLabel( 0 , "High-Low");

	SetIndexBuffer ( 1 , buf1 );
	SetIndexStyle ( 1 , DRAW_LINE );
	SetIndexDrawBegin ( 1 , 0 );
	SetIndexLabel( 1 , "Open-Close");

	SetIndexBuffer ( 2 , buf2 );
	SetIndexStyle ( 2 , DRAW_LINE, STYLE_DOT );
	SetIndexDrawBegin ( 2 , 0 );
	SetIndexLabel( 2 , "Up_Shadow");

	SetIndexBuffer ( 3 , buf3 );
	SetIndexStyle ( 3 , DRAW_LINE, STYLE_DOT );
	SetIndexDrawBegin ( 3 , 0 );
	SetIndexLabel( 3 , "Down_Shadow");

	SetIndexBuffer ( 4 , buf4 );
	SetIndexStyle ( 4 , DRAW_LINE );
	SetIndexDrawBegin ( 4 , 0 );
	SetIndexLabel( 4 , "Summ_Shadow");

return(0);
}

int start()
{
	int counted_bars=IndicatorCounted();
	if ( counted_bars < 0 ) { Print( "Indicator Error (Counted bars < 0)!" ); return(-1); }
	if ( Bars < 100 ) { Print( "Indicator Error (bars < 100)!" ); return(-1); }
	int limit = Bars - 1;

	double buf_tmp = 0.0, buf_tmp1 = 0.0, buf_tmp2 = 0.0, buf_tmp3 = 0.0, buf_tmp4 = 0.0;
	int bars = Bars, z, z1, z2, z3, z4;
	double high, low, close, open, point = Point;

	for ( int i = limit; i >= 0; i -- )
	{
		high = High[i]; low = Low[i]; close = Close[i]; open = Open[i];

		buf_tmp += ( high - low ) / point;
		buf0[i] = buf_tmp / ( bars - i + z );
		if ( ( high - low ) / point == 0 ) z --;

		buf_tmp1 += MathAbs( ( close - open ) ) / point;
		buf1[i] = buf_tmp1 / ( bars - i + z1 );
		if ( MathAbs( ( close - open ) ) / point  == 0 ) z1 --;

		if ( close - open >= 0 )
		{
			buf_tmp2 += ( high - close ) / point;
			buf2[i] = buf_tmp2 / ( bars - i + z2 );
			if ( ( high - close ) / point  == 0 ) z2 --;

			buf_tmp3 += ( open - low ) / point;
			buf3[i] = buf_tmp3 / ( bars - i + z3 );
			if ( ( open - low ) / point  == 0 ) z3 --;
		}
		else
		{
			buf_tmp2 += ( high - open ) / point;
			buf2[i] = buf_tmp2 / ( bars - i + z2 );
			if ( ( high - open ) / point  == 0 ) z2 --;

			buf_tmp3 += ( close - low ) / point;
			buf3[i] = buf_tmp3 / ( bars - i + z3 );
			if ( ( close - low ) / point  == 0 ) z3 --;
		}
		buf4[i] = buf2[i] + buf3[i];
	}

return(0);
}

