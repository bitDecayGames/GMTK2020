package states;

import flixel.FlxState;
import levels.Loader;

class LoganState extends FlxState
{
	override public function create()
	{
		super.create();
		Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.TestLevel__json);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
