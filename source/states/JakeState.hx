package states;

import flixel.FlxG;
import flixel.FlxState;
import collisions.CollisionManager;
import entities.Player;
import levels.Loader;

class JakeState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.debugger.drawDebug = true;

		var level = Loader.loadLevel(AssetPaths.city__ogmo, AssetPaths.JakeLevel__json);
		add(level.walls);
		add(level.triggers);
		
		var player:Player;
		player = level.player;
		add(player);

		var collisions = new CollisionManager(this);
		collisions.setLevel(level);
	}
}
