package hud;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import objectives.Objective;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

class ObjectiveHUDElement extends FlxTypedSpriteGroup<FlxSprite> {
	public var obj:Objective;
	private var text:FlxText;
	private var strikethrough:FlxSprite;

	public function new(obj:Objective) {
		super();
		this.obj = obj;
		text = new FlxText(obj.getDescription());
		text.color = FlxColor.BLACK;
		add(text);

		strikethrough = new FlxText("-----------");
		strikethrough.color = FlxColor.GRAY;
		strikethrough.visible = false;
		add(strikethrough);
	}

	public function setElementPosition(x:Float, y:Float) {
		text.setPosition(x, y);
		strikethrough.setPosition(x, y);
	}

	override public function update(delta:Float) {
		if (obj.completed) {
			text.color = FlxColor.GRAY;
			strikethrough.visible = true;
		}
	}
}