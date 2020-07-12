package levels;

import flixel.math.FlxPoint;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
import trigger.Trigger;
import flixel.FlxObject;
import entities.Player;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {
	public var walls:flixel.tile.FlxTilemap;
	public var background:flixel.tile.FlxTilemap;
	public var groundType:Map<String, Array<FlxPoint>>;
	public var player:Player;

	public var triggers:FlxTypedGroup<Trigger>;
	var checkpointManager:CheckpointManager;
	public var objectiveManager:ObjectiveManager; 

	public function new(map:FlxOgmo3Loader) {
		background = map.loadTilemap(AssetPaths.cityTiles__png, "Ground");
		walls = map.loadTilemap(AssetPaths.cityTiles__png, "Walls");
		walls.setTileProperties(1, FlxObject.ANY);
 		// walls.setTileProperties(2, FlxObject.ANY);
 		// walls.setTileProperties(3, FlxObject.ANY);

		checkpointManager = new CheckpointManager();
		objectiveManager = new ObjectiveManager();
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
					case "Objective":
						var objective = objectiveManager.createObjective(entity.values.description);
						objective.x = entity.x;
						objective.y = entity.y;
						triggers.add(objective);
						return;
					default:
						throw 'Unrecognized actor type ${entity.name}';
				}
			}, "Entities");
	}
}