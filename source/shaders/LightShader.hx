package shaders;

import flixel.system.FlxAssets.FlxShader;

class LightShader extends FlxShader {
	@:glFragmentSource('
		#pragma header

		uniform bool debugLoc;

		uniform vec2 lightOrigin;
		uniform vec2 lightDirection;
		uniform float minDistance;
		uniform float maxDistance;
		uniform float spreadAngle;


		void main()
		{
			bool lessThenMax = false;
			bool greaterThenMin = false;
			bool inCorrectDirection = false;
			bool insideAngle = false;
			
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);


			//is pixel less then max distance
			float distanceFromLightToPoint = distance(openfl_TextureCoordv,lightOrigin);
			if(distanceFromLightToPoint < maxDistance)
				lessThenMax = true;

			//is pixel greater then min
			if(distanceFromLightToPoint > minDistance)
				greaterThenMin = true;

			
			//get info to determine if the pixel is inside the spread angle
			vec2 lightOriginToPoint = openfl_TextureCoordv - lightOrigin;
			vec2 normalLightOriginToPoint = normalize(lightOriginToPoint);
			vec2 normalDirectionvec = normalize(lightDirection);
			float dotOfNormalVecs = dot(normalLightOriginToPoint,normalDirectionvec);

			if(dotOfNormalVecs > 0.0)
				inCorrectDirection = true;

			if(acos(dotOfNormalVecs) < spreadAngle)
				insideAngle = true;

			if(lessThenMax && greaterThenMin){
				// float lightInfluence = (distanceFromLightToPoint - minDistance) / (maxDistance - minDistance);
				// vec3 light = vec3(1.0 , 1.0 , 0.0);
				// vec3 averageLight = (light + gl_FragColor.rgb) / (1.0 + lightInfluence);
				// averageLight = mix(light, gl_FragColor.rgb, lightInfluence);
				gl_FragColor.rgb = vec3(1.0 , 1.0 , 1.0);
			}
			

			if (debugLoc) {
			}
		}')
	public function new() {
		super();
		this.lightOrigin.value = [0.21, 0.81];
		this.lightDirection.value = [1.0, 1.0];
		this.minDistance.value = [0.05];
		this.maxDistance.value = [0.20];
		this.spreadAngle.value = [0.610865];
		this.debugLoc.value = [false];
	}

	public function setLightOrigin(x:Float, y:Float):LightShader {
		this.lightOrigin.value = [x, y];
		return this;
	}

	public function setLightDirection(x:Float, y:Float):LightShader {
		this.lightDirection.value = [x, y];
		return this;
	}
}
