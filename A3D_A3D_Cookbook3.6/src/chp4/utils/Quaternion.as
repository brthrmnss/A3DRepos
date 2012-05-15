﻿/////////updated to use with Away3D 3.6 +package utils{	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;

    /**    * A Quaternion object.    */    public final class Quaternion     {    	private var w1:Number;        private var w2:Number;        private var x1:Number;        private var x2:Number;        private var y1:Number;        private var y2:Number;        private var z1:Number;        private var z2:Number;	    private var sin_a:Number;	    private var cos_a:Number;	    private var fSinPitch:Number;        private var fCosPitch:Number;        private var fSinYaw:Number;        private var fCosYaw:Number;        private var fSinRoll:Number;        private var fCosRoll:Number;        private var fCosPitchCosYaw:Number;        private var fSinPitchSinYaw:Number;	                	/**    	 * The x value of the quatertion.    	 */        public var x:Number;                /**    	 * The y value of the quatertion.    	 */        public var y:Number;                /**    	 * The z value of the quatertion.    	 */        public var z:Number;                /**    	 * The w value of the quatertion.    	 */        public var w:Number;        	    /**	    * Returns the magnitude of the quaternion object.	    */	    public function get magnitude():Number	    {	        return(Math.sqrt(w*w + x*x + y*y + z*z));	    }	            /**        * Fills the quaternion object with the result from a multipication of two quaternion objects.        *         * @param	qa	The first quaternion in the multipication.        * @param	qb	The second quaternion in the multipication.        */	    public function multiply(qa:Quaternion, qb:Quaternion):void	    {	        w1 = qa.w;  x1 = qa.x;  y1 = qa.y;  z1 = qa.z;	        w2 = qb.w;  x2 = qb.x;  y2 = qb.y;  z2 = qb.z;	   	        w = w1*w2 - x1*x2 - y1*y2 - z1*z2;	        x = w1*x2 + x1*w2 + y1*z2 - z1*y2;	        y = w1*y2 + y1*w2 + z1*x2 - x1*z2;	        z = w1*z2 + z1*w2 + x1*y2 - y1*x2;	    }	        	/**    	 * Fills the quaternion object with values representing the given rotation around a vector.    	 *     	 * @param	x		The x value of the rotation vector.    	 * @param	y		The y value of the rotation vector.    	 * @param	z		The z value of the rotation vector.    	 * @param	angle	The angle in radians of the rotation.    	 */	    public function axis2quaternion(x:Number, y:Number, z:Number, angle:Number):void	    {	        sin_a = Math.sin(angle / 2);	        cos_a = Math.cos(angle / 2);	   	        this.x = x*sin_a;	        this.y = y*sin_a;	        this.z = z*sin_a;	        w = cos_a;			normalize();	    }	        	/**    	 * Fills the quaternion object with values representing the given euler rotation.    	 *     	 * @param	ax		The angle in radians of the rotation around the x axis.    	 * @param	ay		The angle in radians of the rotation around the y axis.    	 * @param	az		The angle in radians of the rotation around the z axis.    	 */        public function euler2quaternion(ax:Number, ay:Number, az:Number):void        {            fSinPitch       = Math.sin(ax * 0.5);            fCosPitch       = Math.cos(ax * 0.5);            fSinYaw         = Math.sin(ay * 0.5);            fCosYaw         = Math.cos(ay * 0.5);            fSinRoll        = Math.sin(az * 0.5);            fCosRoll        = Math.cos(az * 0.5);            fCosPitchCosYaw = fCosPitch * fCosYaw;            fSinPitchSinYaw = fSinPitch * fSinYaw;                x = fSinRoll * fCosPitchCosYaw     - fCosRoll * fSinPitchSinYaw;            y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;            z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;            w = fCosRoll * fCosPitchCosYaw     + fSinRoll * fSinPitchSinYaw;        }                /**        * Normalises the quaternion object.        */	    public function normalize(val:Number = 1):void	    {	        var mag:Number = magnitude*val;	   	        x /= mag;	        y /= mag;	        z /= mag;	        w /= mag;	    }				/**		 * Used to trace the values of a quaternion.		 * 		 * @return A string representation of the quaternion object.		 */	    public function toString(): String        {            return "{x:" + x + " y:" + y + " z:" + z + " w:" + w + "}";        }				public static function slerp( qa:Quaternion, qb:Quaternion, nb:Number ):Quaternion {            var quatSlerp:Quaternion = new Quaternion;			var angle:Number=qa.w*qb.w+qa.x*qb.x+qa.y*qb.y+qa.z*qb.z;			if (angle<0.0) {				qa.x*=-1.0;				qa.y*=-1.0;				qa.z*=-1.0;				qa.w*=-1.0;				angle*=-1.0;			}			var scale:Number;			var invscale:Number;			if ((angle + 1.0) > 0.000001) {				if ((1.0 - angle) >= 0.000001) {					var theta:Number=Math.acos(angle);					var invsintheta:Number=1.0/Math.sin(theta);					scale = Math.sin(theta * (1.0-nb)) * invsintheta;					invscale=Math.sin(theta*nb)*invsintheta;				} else {					scale=1.0-nb;					invscale=nb;				}			} else {				qb.y=- qa.y;				qb.x=qa.x;				qb.w=- qa.w;				qb.z=qa.z;				scale = Math.sin(Math.PI * (0.5 - nb));				invscale=Math.sin(Math.PI*nb);			}			quatSlerp.x = scale * qa.x + invscale * qb.x;			quatSlerp.y = scale * qa.y + invscale * qb.y;			quatSlerp.z = scale * qa.z + invscale * qb.z;			quatSlerp.w = scale * qa.w + invscale * qb.w;			return quatSlerp;		}		static public function createFromMatrix( matrix:Matrix3D ):Quaternion {			var quat:Quaternion = new Quaternion();			var s:Number;			var q:Array=new Array(4);			var i:int,j:int,k:int;			//var tr:Number=matrix.sxx+matrix.syy+matrix.szz;			var tr:Number=matrix.rawData[0]+matrix.rawData[5]+matrix.rawData[10];			// check the diagonal			if (tr>0.0) {				s=Math.sqrt(tr+1.0);				quat.w=s/2.0;				s=0.5/s;				//quat.x = (matrix.szy - matrix.syz) * s;				quat.x = (matrix.rawData[6] - matrix.rawData[9]) * s;								//quat.y = (matrix.sxz - matrix.szx) * s;				quat.y = (matrix.rawData[8] - matrix.rawData[2]) * s;				//quat.z = (matrix.syx - matrix.sxy) * s;								quat.z = (matrix.rawData[1] - matrix.rawData[4]) * s;			} else {				// diagonal is negative				var nxt:Array=[1,2,0];				var m:Array = [				[matrix.rawData[0], matrix.rawData[4],matrix.rawData[8], matrix.rawData[12]],				[matrix.rawData[1], matrix.rawData[5], matrix.rawData[9], matrix.rawData[13]],				[matrix.rawData[2], matrix.rawData[6], matrix.rawData[10], matrix.rawData[14]]				];				i=0;				if (m[1][1]>m[0][0]) {					i=1;				}				if (m[2][2]>m[i][i]) {					i=2;				}				j=nxt[i];				k=nxt[j];				s = Math.sqrt((m[i][i] - (m[j][j] + m[k][k])) + 1.0);				q[i]=s*0.5;				if (s!=0.0) {					s=0.5/s;				}				q[3] = (m[k][j] - m[j][k]) * s;				q[j] = (m[j][i] + m[i][j]) * s;				q[k] = (m[k][i] + m[i][k]) * s;				quat.x=q[0];				quat.y=q[1];				quat.z=q[2];				quat.w=q[3];			}			return quat;		}				public static function quaternion2matrix(quarternion:Quaternion):Matrix3D		{			var x:Number = quarternion.x;			var y:Number = quarternion.y;			var z:Number = quarternion.z;			var w:Number = quarternion.w;						var xx:Number = x * x;			var xy:Number = x * y;			var xz:Number = x * z;			var xw:Number = x * w;						var yy:Number = y * y;			var yz:Number = y * z;			var yw:Number = y * w;						var zz:Number = z * z;			var zw:Number = z * w;						return new Matrix3D(Vector.<Number>([1 - 2 * (yy + zz), 2 * (xy + zw), 2 * (xz - yw), 0, 2 * (xy - zw), 1 - 2 * (xx + zz), 2 * (yz + xw), 0, 2 * (xz + yw), 2 * (yz - xw), 1 - 2 * (xx + yy), 0, 0, 0, 0, 1]));		}		public static function conjugate( quat:Quaternion ):Quaternion		{			var q:Quaternion = new Quaternion();			q.x = -quat.x;			q.y = -quat.y;			q.z = -quat.z;			q.w = quat.w;			return q;		}    }}