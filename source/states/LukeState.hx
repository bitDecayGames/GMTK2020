package states;

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
	var shader = new LightShader(); 
	var filters:Array<BitmapFilter> = [];

	
	override public function create()
	{
		super.create();
		
		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.setFilters(filters);

		FlxG.debugger.drawDebug = true;

		checkpointManager = new CheckpointManager();

		boiGroup = new FlxGroup();
		add(boiGroup);
		triggerGroup = new FlxGroup();
		add(triggerGroup);

		var boi = new Boi();
		boi.x = 100;
		boi.y = 100;
		boiGroup.add(boi);

		var trigger = checkpointManager.createCheckpoint();
		trigger.register(handleCheckpointActivation);
		trigger.x = 200;
		trigger.y = 200;
		triggerGroup.add(trigger);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.overlap(boiGroup, triggerGroup, handleBoiTriggerOverlap);
	}

	private function handleBoiTriggerOverlap(_boi:Boi, trigger:Trigger) {
		trigger.activate();
	}

	private function handleCheckpointActivation(spr: FlxSprite) {
		TextPop.pop(cast(spr.x, Int), cast(spr.y, Int), "Checkpoint Reached");
	}
	
}
