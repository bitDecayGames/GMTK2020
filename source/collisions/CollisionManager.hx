package collisions;

import flixel.FlxG;
import flixel.util.FlxCollision;
import levels.Level;
import flixel.util.FlxSort;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import sorting.ZSorter;

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
	}
}