package states;

import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.LightShader;
import flixel.FlxState;
import levels.Loader;

class LukeState extends FlxState
{
	
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];

	
	override public function create()
	{
		super.create();
		
		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.setFilters(filters);
		
		Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.TestLevel__json);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
