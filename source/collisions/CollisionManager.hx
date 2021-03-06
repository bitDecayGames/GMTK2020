package collisions;

import entities.TrashCan;
import flixel.tile.FlxTilemap;
import entities.Hydrant;
import entities.Car;
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

		FlxG.collide(level.player, level.walls, handlerPlayerBonk);

		for (hydrant in level.hydrants) {
			FlxG.collide(hydrant, level.player);
		}

		for (trashcan in level.trashcans) {
			FlxG.collide(trashcan, level.player);
			for (car in level.cars) {
				FlxG.overlap(car, trashcan, handleCarTrashCanOverlap);
			}
		}

		for (car in level.cars) {
			FlxG.collide(car, level.walls, handleCarCollideWithWall);
			if (!level.player.isBonked() && !level.player.isDiving())
			{
				FlxG.collide(car, level.player, handlePlayerCarOverlap);
			}
		}

		for (hydrant in level.hydrants) {
			FlxG.collide(hydrant, level.player);
			for (car in level.cars) {
				FlxG.overlap(car, hydrant, handleCarHydrantOverlap);
			}
		}

		level.groundType.overlaps(level.player);
		FlxG.overlap(level.player, level.triggers, handlePlayerTriggerOverlap);
		FlxG.overlap(level.player, level.background);
	}

	public function isRoof(p:FlxPoint):Bool {
		return level.walls.overlapsPoint(p);
	}

	private function handleCarTrashCanOverlap(_car:Car, _trashcan:TrashCan) {
		_trashcan.asplode();
	}

	private function handlePlayerCarOverlap(_car:Car, _player:Player) {
		_player.hitByCar();
	}

	private function handlePlayerTriggerOverlap(_player:Player, trigger:Trigger) {
		trigger.activate();
	}

	private function handlerPlayerBonk(_player:Player, _wall:FlxTilemap) {
		_player.attemptBonk();
	}
	
	private function handleCarHydrantOverlap(_car:Car, _hydrant:Hydrant){
		_hydrant.asplode();
	}

	private function handleCarCollideWithWall(_car:Car, _wall:Dynamic) {
		_car.kill();
	}
}
