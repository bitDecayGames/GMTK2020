package states;

import haxefmod.FmodEvents.FmodCallback;
import openfl.filters.ShaderFilter;
import dialogbox.DialogManager;
import com.bitdecay.analytics.Common;
import com.bitdecay.analytics.Bitlytics;
import hud.NotebookHUD;
import levels.Level;
import collisions.CollisionManager;
import flixel.math.FlxRect;
import entities.RainMaker;
import openfl.filters.BitmapFilter;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
import hud.HUD;
import flixel.util.FlxColor;
import entities.Car;
import flixel.ui.FlxButton;
import flixel.system.debug.console.Console;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxState;
import levels.Loader;
import entities.Player;
import flixel.math.FlxPoint;
import shaders.LightShader;

class PlayState extends FlxState {
	var rainReference:String;

	var notebookHUD:NotebookHUD;
	var hud:HUD;

	var boiGroup:FlxGroup;
	var triggerGroup:FlxGroup;

	var checkpointManager:CheckpointManager;
	var objectiveManager:ObjectiveManager;
	var isShaderEnabled:Bool = false;
	var shader = new LightShader();
	var filters:Array<BitmapFilter> = [];
	var level:Level;

	var dialogManager:dialogbox.DialogManager;

	override public function switchTo(nextState:FlxState):Bool {
		dialogManager.stopSounds();
		return super.switchTo(nextState);
	}

	override public function create() {
		// Bitlytics.Instance().Queue(Common.GameStarted, 1);
		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterCallbacksForSound(rainReference, ()->{
			FlxG.camera.flash(FlxColor.WHITE, 0.5);
		}, FmodCallback.TIMELINE_MARKER);

		// FlxG.debugger.drawDebug = true;
		level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);

		var player:Player;
		player = level.player;
		player.setState(this);
		add(player);

		hud = new HUD(player);
		add(hud);

		objectiveManager = level.objectiveManager;

		notebookHUD = new NotebookHUD(player);
		for (o in level.objectiveManager.getObjectives()) {
			notebookHUD.addObjective(o);
			add(o);
		}
		add(notebookHUD);

		for (hydrant in level.hydrants)
			add(hydrant);

		for (trashcan in level.trashcans)
			add(trashcan);

		for (spawner in level.carSpawners) {
			add(spawner);
		}

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);

		var rain = new RainMaker(camera, collisions, 500);
		add(rain);

		dialogManager = new DialogManager(this);
		objectiveManager.setDialogManager(dialogManager);

		// The camera. It's real easy. Flixel is nice.
		FlxG.camera.follow(player, TOPDOWN, 0.1);
		FlxG.camera.pixelPerfectRender = true;

		if (isShaderEnabled) {
			filters.push(new ShaderFilter(shader));
			FlxG.camera.setFilters(filters);
		}
		// FlxG.camera.zoom = 0.15;
		var deadzone = new FlxPoint(100, 50);
		FlxG.camera.deadzone = new FlxRect(FlxG.camera.width / 2 - deadzone.x / 2, FlxG.camera.height / 2 - deadzone.y / 2, deadzone.x, deadzone.y);

		super.create();
	}

	override public function update(elapsed:Float) {
		FmodManager.Update();

		if (FlxG.keys.justPressed.N) {
			level.spawnCar();
		}
		dialogManager.update();

		super.update(elapsed);
		level.update(elapsed);

		remove(notebookHUD, true);
		add(notebookHUD);

		if (isShaderEnabled) {
			updateLightShader();
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		// Bitlytics.Instance().Pause();
	}

	override public function onFocus() {
		super.onFocus();
		// Bitlytics.Instance().Resume();
	}

	private function updateLightShader() {
		for (car in level.cars) {
			if (car.alive) {
				shader.addLight(new LightInfo(car, FlxG.camera));
			}
		}
		shader.setLightData();
	}
}
