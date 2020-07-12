package levels;

import flixel.FlxG;
import entities.Hydrant;
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
import flixel.math.FlxRandom;

class Level {
	public var walls:flixel.tile.FlxTilemap;
	public var background:flixel.tile.FlxTilemap;
	public var groundType:flixel.tile.FlxTilemap;
	public var player:Player;
	public var cars:Array<Car>;
	public var hydrants:Array<Hydrant>;
	public var carSpawners:Array<CarSpawner>;
	public var carSpawnTime:Float = 5.0;
	public var carSpawnTimer:Float;

	private var rnd:FlxRandom = new FlxRandom();

	public var triggers:FlxTypedGroup<Trigger>;

	var checkpointManager:CheckpointManager;

	public var objectiveManager:ObjectiveManager;

	public function new(map:FlxOgmo3Loader) {
		background = map.loadTilemap(AssetPaths.cityTiles__png, "Ground");
		walls = map.loadTilemap(AssetPaths.collisions__png, "Walls");
		FlxG.worldBounds.set(0,0,walls.width,walls.height);
		groundType = map.loadTilemap(AssetPaths.groundTypes__png, "GroundType");
		groundType.setTileProperties(1, FlxObject.ANY, setPlayerGroundType("concrete"));
		groundType.setTileProperties(2, FlxObject.ANY, setPlayerGroundType("grass"));
		groundType.setTileProperties(3, FlxObject.ANY, setPlayerGroundType("metal"));

		checkpointManager = new CheckpointManager();
		objectiveManager = new ObjectiveManager();
		triggers = new FlxTypedGroup<Trigger>();
		cars = new Array<Car>();
		carSpawners = [];

		hydrants = new Array<Hydrant>();

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
					var objective = objectiveManager.createObjective(entity.values.description, entity.values.index);
					objective.x = entity.x;
					objective.y = entity.y;
					triggers.add(objective);
					return;
				default:
					throw 'Unrecognized actor type ${entity.name}';
			}
		}, "Entities");

		var objectives = objectiveManager.getObjectives();
		objectives.sort(ObjectiveManager.compare);
		objectiveManager.setupObjectives();

		map.loadEntities(function loadEntity(entity:EntityData) {
			switch (entity.name) {
				case "Hydrant":
					var hydrant = new Hydrant();
					hydrant.x = entity.x;
					hydrant.y = entity.y;
					hydrants.push(hydrant);
					return;
				default:
					throw 'Unrecognized actor type ${entity.name}';
			}
		}, "Objects");

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
			var car = carSpawners[rnd.int(0, carSpawners.length - 1)].spawn();
			cars.push(car);
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

	public function update(elapsed:Float) {
		carSpawnTimer -= elapsed;
		if(carSpawnTimer <= 0.0){
			spawnCar();
			carSpawnTimer = carSpawnTime;
		}
	}
}
