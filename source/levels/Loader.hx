package levels;

import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxG;

class Loader {
	public static function loadLevel(ogmoFile:String, levelFile:String) {
		var map = new FlxOgmo3Loader(ogmoFile, levelFile);
			var walls = map.loadTilemap(AssetPaths.tiles__png, "Ground");
			walls.follow();
			FlxG.state.add(walls);
	
			map.loadEntities(function loadEntity(entity:EntityData)
				{
					switch (entity.name)
					{
						case "PlayerSpawn":
							trace("I found a player spawn");
							FlxG.state.add(new FlxSprite(entity.x, entity.y));
						default:
							throw 'Unrecognized actor type ${entity.name}';
					}
				}, "Entities");
	}
}
