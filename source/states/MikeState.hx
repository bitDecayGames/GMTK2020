package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import entities.Car;
import flixel.FlxState;
import flixel.group.FlxGroup;
import shaders.LightShader;
import entities.Car;
import hud.HUD;
import objectives.ObjectiveManager;
import entities.Player;
import collisions.CollisionManager;
import flixel.FlxSprite;
import trigger.Trigger;
import com.bitdecay.textpop.TextPop;
import trigger.Boi;
import checkpoint.CheckpointManager;
import flixel.group.FlxGroup;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.LightShader;
import flixel.FlxState;
import levels.Loader;
import levels.Level;
import flixel.math.FlxPoint;

class MikeState extends FlxState {
	var boiGroup:FlxGroup;
	var triggerGroup:FlxGroup;

	var checkpointManager:CheckpointManager;
	var objectiveManager:ObjectiveManager;
	var shader = new LightShader();
	var filters:Array<BitmapFilter> = [];
	var hud:HUD;
	var level:Level;
	var center:FlxPoint;

	override public function create() {
		super.create();

		FlxG.debugger.drawDebug = true;
		level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
		for (spawner in level.carSpawners) {
			add(spawner);
		}

		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		objectiveManager = level.objectiveManager;

		hud = new HUD(player);
		add(hud);

		for (o in objectiveManager.getObjectives()) {
			add(o);
		}

		FlxG.camera.follow(player, TOPDOWN, 1);
		// FlxG.camera.zoom = 0.15;
		filters.push(new ShaderFilter(shader));
		center = new FlxPoint(FlxG.width / 2.0, FlxG.height / 2.0);
		shader.setLightOrigin(0.0, 1.0);
		camera.setFilters(filters);

		FlxG.worldBounds.set(0, 0, 2000, 2000);
		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE) {
			level.spawnCar();
		}
		if (FlxG.keys.justPressed.ONE) {
			shader.setLightOrigin(0.0, 0.0);
		}
		if (FlxG.keys.justPressed.TWO) {
			shader.setLightOrigin(1.0, 0.0);
		}
		if (FlxG.keys.justPressed.THREE) {
			shader.setLightOrigin(0.0, 1.0);
		}
		if (FlxG.keys.justPressed.FOUR) {
			shader.setLightOrigin(1.0, 1.0);
		}
		if (FlxG.keys.justPressed.FIVE) {
			shader.setLightOrigin(.5, .5);
		}

		var mouse = FlxG.mouse.getScreenPosition();
		shader.setLightDirection((mouse.x - center.x) / FlxG.width, (mouse.y - center.y) / FlxG.height);
	}
}
