package states;

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

class LukeState extends FlxState
{
	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;
	var objectiveManager: ObjectiveManager;
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];

	
	override public function create()
	{
		super.create();

		FlxG.debugger.drawDebug = true;
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

		// The camera. It's real easy. Flixel is nice.
		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.zoom = 0.5;
		
		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
	}

	override function update(elapsed:Float){
		super.update(elapsed);
		for(o in objectiveManager.getObjectives()){
			trace('time elapsed: ${elapsed} Objective:  ${o.getDescription()} has a status of: ${o.getStatus()}' );
		}
	}
	
}
