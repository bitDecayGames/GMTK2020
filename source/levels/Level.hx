package levels;

import flixel.FlxObject;
import entities.Player;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {
	public var walls:flixel.tile.FlxTilemap;
	public var player:Player;

	public function new(map:FlxOgmo3Loader) {
		walls = map.loadTilemap(AssetPaths.tiles__png, "Ground");
		walls.setTileProperties(1, FlxObject.ANY);
 		walls.setTileProperties(2, FlxObject.ANY);
 		walls.setTileProperties(3, FlxObject.ANY);
	
		map.loadEntities(function loadEntity(entity:EntityData)
			{
				switch (entity.name)
				{
					case "PlayerSpawn":
						trace("I found a player spawn");
						player = new Player(entity.x, entity.y);
					default:
						throw 'Unrecognized actor type ${entity.name}';
				}
			}, "Entities");
	}
}