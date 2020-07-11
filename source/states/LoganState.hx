package states;

import flixel.FlxG;
import collisions.CollisionManager;
import entities.Player;
import flixel.FlxState;
import levels.Loader;
import entities.RainMaker;

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

		var rain = new RainMaker(camera, 250);
		add(rain);

		camera.follow(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
