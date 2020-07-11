package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import trigger.Boi;
import trigger.Trigger;
import checkpoint.CheckpointManager;

class JakeState extends FlxState
{
	var boiGroup: FlxGroup;
	var triggerGroup: FlxGroup;

	var checkpointManager: CheckpointManager;

	override public function create()
	{
		super.create();

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
		trace("Checkpoint Hit", checkpointManager.getLastCheckpoint());
	}
}
