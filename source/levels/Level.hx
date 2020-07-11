package levels;

import checkpoint.CheckpointManager;
import trigger.Trigger;
import flixel.FlxObject;
import entities.Player;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {
	public var walls:flixel.tile.FlxTilemap;
	public var player:Player;

	public var triggers:FlxTypedGroup<Trigger>;
	var checkpointManager:CheckpointManager;

	public function new(map:FlxOgmo3Loader) {
		walls = map.loadTilemap(AssetPaths.tiles__png, "Ground");
		walls.setTileProperties(1, FlxObject.ANY);
 		walls.setTileProperties(2, FlxObject.ANY);
 		walls.setTileProperties(3, FlxObject.ANY);

		checkpointManager = new CheckpointManager();
		triggers = new FlxTypedGroup<Trigger>();
		
		map.loadEntities(function loadEntity(entity:EntityData)
			{
				switch (entity.name)
				{
					case "PlayerSpawn":
						player = new Player(entity.x, entity.y);
						return;
					case "Checkpoint":
						var checkpoint = checkpointManager.createCheckpoint();
						checkpoint.x = entity.x;
						checkpoint.y = entity.y;
						triggers.add(checkpoint);
						return;
					default:
						throw 'Unrecognized actor type ${entity.name}';
				}
			}, "Entities");
	}
}