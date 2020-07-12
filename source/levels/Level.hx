package levels;

import entities.Car;
import flixel.math.FlxPoint;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
import trigger.Trigger;
import flixel.FlxObject;
import entities.Player;
import entities.Car;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class Level {
	public var walls:flixel.tile.FlxTilemap;
	public var background:flixel.tile.FlxTilemap;
	public var groundType:flixel.tile.FlxTilemap;
	public var player:Player;
	public var cars:Array<Car>;
	public var carSpawners:Array<CarSpawner>;

	public var triggers:FlxTypedGroup<Trigger>;

	var checkpointManager:CheckpointManager;

	public var objectiveManager:ObjectiveManager;

	public function new(map:FlxOgmo3Loader) {
		background = map.loadTilemap(AssetPaths.cityTiles__png, "Ground");
		walls = map.loadTilemap(AssetPaths.collisions__png, "Walls");
		groundType = map.loadTilemap(AssetPaths.groundTypes__png, "GroundType");
		groundType.setTileProperties(1, FlxObject.ANY, setPlayerGroundType("concrete"));
		groundType.setTileProperties(2, FlxObject.ANY, setPlayerGroundType("grass"));
		groundType.setTileProperties(3, FlxObject.ANY, setPlayerGroundType("metal"));

		checkpointManager = new CheckpointManager();
		objectiveManager = new ObjectiveManager();
		triggers = new FlxTypedGroup<Trigger>();
		cars = new Array<Car>();
		carSpawners = [];

		map.loadEntities(function loadEntity(entity:EntityData) {
			switch (entity.name) {
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
				case "Hydrant":
					return;
					throw 'Unrecognized actor type ${entity.name}';
			}
		}, "Entities");

		map.loadEntities((entity : EntityData) -> {
			if (entity.name == "CarSpawn") {
				var carPath:Array<FlxPoint> = entity.nodes.map((n) -> FlxPoint.get(n.x, n.y));
				var carSpawn = new CarSpawner(entity.x, entity.y, carPath);
				carSpawners.push(carSpawn);
			}
		}, "CarPaths");
	}

	public function spawnCar() {
		if (carSpawners != null && carSpawners.length > 0) {
			var car = carSpawners[0].spawn();
			if (player != null) {
				car.setTarget(player);
			}
		}
	}

	private function setPlayerGroundType(type:String):(FlxObject, FlxObject) -> Void {
		return (a, b) -> {
			player.groundType = type;
		};
	}
}
