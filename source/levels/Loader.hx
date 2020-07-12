package levels;

import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxG;

class Loader {
	public static function loadLevel(ogmoFile:String, levelFile:String):Level {

		//needed to correctly create collision data for things off camera
		// the rectagle defined by these two points should contain the whole world
		FlxG.worldBounds.set(0,0,2000,2000);
		var map = new FlxOgmo3Loader(ogmoFile, levelFile);
		return new Level(map);
	}
}
