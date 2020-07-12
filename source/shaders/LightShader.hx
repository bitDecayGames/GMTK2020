package shaders;

import openfl.display.ShaderParameter;
import flixel.FlxG;
import cameras.CameraUtils;
import flixel.FlxCamera;
import entities.Car;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxShader;

class LightShader extends FlxShader {
	@:glFragmentSource('
		#pragma header

		uniform bool debugLoc;

		uniform vec4 light_01;
		uniform vec4 light_02;
		uniform vec4 light_03;
		uniform vec4 light_04;
		uniform vec4 light_05;
		uniform float minDistance;
		uniform float maxDistance;
		uniform float spreadAngle;
		uniform float screenRatio;


		void calcLight(vec2 lightOrigin, vec2 lightDirection) {
			bool lessThenMax = false;
			bool greaterThenMin = false;
			bool inCorrectDirection = false;
			bool insideAngle = false;

			//is pixel less then max distance
			vec2 diff = openfl_TextureCoordv - lightOrigin;
			float distanceFromLightToPoint = sqrt((diff.x * diff.x * screenRatio) + (diff.y * diff.y));
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

			if(lessThenMax && greaterThenMin && inCorrectDirection && insideAngle){
				float lightInfluence = (distanceFromLightToPoint - minDistance) / (maxDistance - minDistance);
				vec3 light = vec3(1.0 , 1.0 , 0.0);
				vec3 averageLight = (light + gl_FragColor.rgb) / (1.0 + lightInfluence);
				averageLight = mix(light, gl_FragColor.rgb, lightInfluence);
				gl_FragColor.rgb = averageLight;
			}
		}


		void main()
		{
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);

			// light origin
			vec2 lo = vec2(0.0, 0.0);
			// light direction
			vec2 ld = vec2(0.0, 0.0);


			if (light_01.x != -1.0){
				lo.x = light_01.x;
				lo.y = light_01.y;
				ld.x = light_01.z;
				ld.y = light_01.w;
				calcLight(lo, ld);
			}
			if (light_02.x != -1.0){
				lo.x = light_02.x;
				lo.y = light_02.y;
				ld.x = light_02.z;
				ld.y = light_02.w;
				calcLight(lo, ld);
			}
			if (light_03.x != -1.0){
				lo.x = light_03.x;
				lo.y = light_03.y;
				ld.x = light_03.z;
				ld.y = light_03.w;
				calcLight(lo, ld);
			}
			if (light_04.x != -1.0){
				lo.x = light_04.x;
				lo.y = light_04.y;
				ld.x = light_04.z;
				ld.y = light_04.w;
				calcLight(lo, ld);
			}
			if (light_05.x != -1.0){
				lo.x = light_05.x;
				lo.y = light_05.y;
				ld.x = light_05.z;
				ld.y = light_05.w;
				calcLight(lo, ld);
			}
		}
		')
	public function new() {
		super();
		this.setLightData();
		this.minDistance.value = [0.05];
		this.maxDistance.value = [0.25];
		this.spreadAngle.value = [0.785398];
		this.debugLoc.value = [false];
		this.screenRatio.value = [(FlxG.width * 1.0) / FlxG.height];
		this.shaderLights = [this.light_01, this.light_02, this.light_03, this.light_04, this.light_05];
	}

	private var shaderLights:Array<ShaderParameter<Float>> = [];

	public var lights:Array<LightInfo> = [];

	public function addLight(light:LightInfo) {
		if (lights.length < shaderLights.length) {
			lights.push(light);
		}
	}

	public function setLightData() {
		for (i in 0...shaderLights.length) {
			if (i < lights.length) {
				var data:Array<Float> = [];
				lights[i].appendTo(data);
				this.shaderLights[i].value = data;
			} else {
				this.shaderLights[i].value = [-1.0, -1.0, -1.0, -1.0];
			}
		}
		this.lights = [];
	}
}

class LightInfo {
	public var origin:FlxPoint;
	public var angle:Float;
	public var isMad:Bool;

	private static var zero = new FlxPoint(0, 0);

	public function new(car:Car, camera:FlxCamera) {
		origin = CameraUtils.project(FlxPoint.get(car.x, car.y), camera);
		origin.x /= FlxG.width;
		origin.y /= FlxG.height;
		angle = car.angle;
		isMad = car.foundTarget;
	}

	public function appendTo(data:Array<Float>) {
		data.push(origin.x);
		data.push(origin.y);
		var dir = angleToDirection();
		data.push(dir.x);
		data.push(dir.y);
		// data.push(isMad ? 1 : 0);
	}

	private function angleToDirection():FlxPoint {
		return FlxPoint.get(0, -1).rotate(zero, angle);
	}
}
