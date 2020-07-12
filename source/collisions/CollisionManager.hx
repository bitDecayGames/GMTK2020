package collisions;

import entities.Hydrant;
import entities.Car;
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

		for(hydrant in level.hydrants){
			FlxG.collide(hydrant, level.player);
		}

		for(car in level.cars){
			FlxG.collide(car, level.walls);
		}

		for(hydrant in level.hydrants){
			FlxG.collide(hydrant, level.player);
			for(car in level.cars)
				FlxG.overlap(hydrant, car, handleCarHydrantOverlap);
		}
		
		FlxG.overlap(level.player, level.triggers, handlePlayerTriggerOverlap);
		FlxG.overlap(level.player, level.background);

	}

	private function handlePlayerTriggerOverlap(_player:Player, trigger:Trigger) {
		trigger.activate();
	}

	private function handleCarHydrantOverlap(_car:Car, _hydrant:Hydrant){
		trace("car hit hydrant");
	}
}