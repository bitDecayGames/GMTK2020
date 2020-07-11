package levels;

import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxG;

class Loader {
	public static function loadLevel(ogmoFile:String, levelFile:String):Level {
		var map = new FlxOgmo3Loader(ogmoFile, levelFile);
		return new Level(map);
	}
}
