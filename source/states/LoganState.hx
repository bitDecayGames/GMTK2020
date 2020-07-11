package states;

import collisions.CollisionManager;
import entities.Player;
import flixel.FlxState;
import levels.Loader;

class LoganState extends FlxState
{
	override public function create() {
		super.create();
		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.TestLevel__json);
		add(level.walls);
		
		var player:Player;
		player = level.player;
		add(player);
		
		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
