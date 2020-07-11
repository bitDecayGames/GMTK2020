package states;

import flixel.ui.FlxButton;
import js.html.AbortController;
import flixel.system.debug.console.Console;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxState;
import levels.Loader;
import entities.Player;

class JakeFState extends FlxState
{
	override public function create()
	{
		super.create();

		var player:Player;

		player = new Player();
		add(player);
		player.screenCenter();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}