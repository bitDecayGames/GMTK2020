package collisions;

import entities.Player;
import trigger.Trigger;
import flixel.FlxG;
import levels.Level;
import flixel.FlxState;
import flixel.FlxBasic;

class CollisionManager extends FlxBasic {

	var game:FlxState;
	var level:Level;

	public function new(game:FlxState) {
		super();
		this.game = game;
		game.add(this);
	}

	public function setLevel(level:Level) {
		this.level = level;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(level.player, level.walls);

		FlxG.overlap(level.player, level.triggers, handlePlayerTriggerOverlap);
		FlxG.overlap(level.player, level.background);
	}

	private function handlePlayerTriggerOverlap(_player:Player, trigger:Trigger) {
		trigger.activate();
	}
}