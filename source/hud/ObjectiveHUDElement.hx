package hud;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

class ObjectiveHUDElement extends FlxText {
	public var id:String;
	public var description:String;
	public var done:Bool;

	public function new(id:String, description:String) {
		super(description);
		color = FlxColor.BLACK;
		this.id = id;
		this.description = description;
		scale.set(2, 2);
	}
}