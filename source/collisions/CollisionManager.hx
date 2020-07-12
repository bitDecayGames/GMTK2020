package collisions;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import entities.Player;
import entities.Car;
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
		for (car in level.cars) {
			FlxG.collide(car, level.walls, handleCarCollideWithWall);
		}

		FlxG.collide(level.player, level.walls, handlerPlayerBonk);

		level.groundType.overlaps(level.player);
		FlxG.overlap(level.player, level.triggers, handlePlayerTriggerOverlap);
		FlxG.overlap(level.player, level.background);
	}

	public function isRoof(p:FlxPoint):Bool {
		return level.walls.overlapsPoint(p);
	}

	private function handlePlayerTriggerOverlap(_player:Player, trigger:Trigger) {
		trigger.activate();
	}

	private function handlerPlayerBonk(_player:Player, _wall:FlxTilemap){
		_player.bonk();
	}
}
	private function handleCarCollideWithWall(_car:Car, _wall:Dynamic) {
		trace("Car collided with wall");
		_car.kill();
	}
}
