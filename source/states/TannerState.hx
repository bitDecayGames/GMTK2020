package states;

import dialogbox.DialogManager;
import hud.NotebookHUD;
import dialogbox.Dialogs;
import flixel.input.keyboard.FlxKey;
import dialogbox.Dialogbox;
import entities.RainMaker;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import collisions.CollisionManager;
import openfl.filters.BitmapFilter;
import objectives.ObjectiveManager;
import checkpoint.CheckpointManager;
import flixel.group.FlxGroup;
import levels.Loader;
import flixel.FlxG;
import flixel.FlxState;
import entities.Player;
import flixel.util.FlxColor;
import shaders.LightShader;

class TannerState extends FlxState
{
	var rainReference:String;
	
	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;
	var objectiveManager: ObjectiveManager;
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];

	var dialogManager:dialogbox.DialogManager;

	// var soundId:String = "";
	// var typeText:Dialogbox;

	override public function create()
	{

		FmodManager.PlaySong(FmodSongs.MainGame);
		rainReference = FmodManager.PlaySoundWithReference(FmodSFX.Rain);
		FmodManager.RegisterLightning(rainReference);

		// FlxG.debugger.drawDebug = true;
		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.CityTest__json);
		add(level.walls);
		add(level.background);
		
		var player:Player;
		player = level.player;
		add(player);
		player.screenCenter();

		objectiveManager = level.objectiveManager;

		for(o in objectiveManager.getObjectives())
			add(o);

		for(hydrant in level.hydrants)
			add(hydrant);

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);

		var rain = new RainMaker(camera, collisions, 250);
		add(rain);

		// var x = 500.0;
		// var y = 200.0;
		// var carA = new Car(x, y, new FlxPoint(0, 0), 1500, 50, 1000);
		// add(carA);
		// carA.setTarget(player);
		// var carB = new Car(0, 0, new FlxPoint(1000, 1000), 1500, 50, 1000);
		// add(carB);
		// carB.setTarget(player);

		FlxG.camera.follow(player, TOPDOWN, 0.1);
		var deadzone = new FlxPoint(100, 50);
		FlxG.camera.deadzone = new FlxRect(FlxG.camera.width/2 - deadzone.x/2, FlxG.camera.height/2 - deadzone.y/2, deadzone.x, deadzone.y);
		//needed to correctly create collision data for things off camera
		FlxG.worldBounds.set(0,0,2000,2000);

		FlxG.camera.pixelPerfectRender = true;
		
		var notebookHUD = new NotebookHUD(player);
		for (o in level.objectiveManager.getObjectives()) {
			notebookHUD.addObjective(o);
		}
		add(notebookHUD);

		// typeText = new Dialogbox(this, Dialogs.DialogArray[0], FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
		// add(typeText);

		dialogManager = new DialogManager(this);
		objectiveManager.setDialogManager(dialogManager);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		FmodManager.Update();
		dialogManager.update();

        if (FmodManager.HasLightningStruck(rainReference)) {
            FlxG.camera.flash(FlxColor.WHITE, 0.5);
		}

		// if (typeText.getIsTyping() && soundId == ""){
		// 	soundId = FmodManager.PlaySoundWithReference(FmodSFX.Typewriter);
		// } 
		// if (!typeText.getIsTyping() && soundId != ""){
		// 	FmodManager.StopSound(soundId);
		// 	soundId = "";
		// }
		
		super.update(elapsed);
	}
}