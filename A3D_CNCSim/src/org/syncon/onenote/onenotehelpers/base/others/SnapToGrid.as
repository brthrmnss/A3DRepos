package   org.syncon.onenote.onenotehelpers.base.others  
{
	import sss.Shelpers.Shelpers.Shelpers;
	
	
	public class SnapToGrid   {
		
		
		/**
		 * 
		 * @param value
		 * @param offset
		 * @param snapToRadius
		 * @param linesEvery
		 * @param allowNegative
		 * @param minValue - overrides allowNegative, and fixes value at this point, if not -1
		 * @return 
		 * 
		 */
		static public function snapToGridHelper( value : Number, offset : Number, snapToRadius : Number,
												 linesEvery : Number, allowNegative : Boolean = false,
												 minValue : Number = NaN , maxValue : Number = NaN,  enable : Boolean = true)  : Number
		{
			
			if ( enable == false  ) 
				return value; 
			//var offset : Number =  204
			//var snapToRadius : Number  = 20
			//var linesEvery : Number = 160
			value += offset
			var remainder : Number = value%linesEvery
			var init : Number = value
			
			if ( remainder < snapToRadius )
			{
				value = value - remainder
			}
			if ( remainder > linesEvery-snapToRadius )
			{
				value = value + (linesEvery-remainder)
			}
			//Shelpers.traceS('value', value,'init', init, 'final', value ) 
			
			value += -offset
			if ( allowNegative == false && value < 0 ) 
				value = 0 	 	
			
			
			if ( allowNegative && init < 0  )
			{
				value = init
				//for upper bound 0,-10
				if ( Math.abs( remainder ) < snapToRadius )
				{
					value = value - remainder
				}
				//for lower bound -10,-20
				if ( Math.abs( remainder )  > linesEvery-snapToRadius )
				{
					value = value - ( linesEvery - Math.abs( remainder ) )
				}
				//Shelpers.traceS('value', value,'init', init, 'final', value ) 
				
				value += offset	 			
			}
			
			if (  isNaN(minValue) == false  && value < minValue )
				value = minValue 
			if (  isNaN(maxValue) == false && value > maxValue )
				value = maxValue 			
			
			
			return value			
		}
		
		static public function snapToValueHelper( value : Number, offset : Number, target : Number, snapToRadius : Number, allowNegative : Boolean = false, minValue : int = -1 )  : Number
		{
			//var offset : Number =  204
			//var snapToRadius : Number  = 20
			//var linesEvery : Number = 160
			value += offset
			var init : Number = value
			if ( value > 0 ) 
			{
				if ( value   < (target + snapToRadius) &&  value  >  (target - snapToRadius) )
				{
					value = target
				}	 	 
			}
			else
			{
				if ( value   < (target + snapToRadius) &&  value  >  (target - snapToRadius) )
				{
					value = target
				}	 	 
			}	 		
			return value			
		}		
		
		
		/**
		 * quick test of snapping functions 
		 * 
		 */
		static public function snapToGridHelperTest() : void
		{
			for ( var i : Number = -9 ; i > -200 ; i = i - 1 )
			{
				var output  : Number = snapToGridHelper( i, 0, 10,  50, true )
				if ( i != output ) 
					Shelpers.traceS('adjusted', i,'to',  output ) 
			}  		
		}
		
		
		static public function limitToRange( value :  Number,   minValue : Number = NaN , maxValue : Number = NaN ) : Number
		{
			if (  isNaN(minValue) == false  && value < minValue )
				value = minValue 
			if (  isNaN(maxValue) == false && value > maxValue )
				value = maxValue 		
			
			return value; 
		}
		
	}
}