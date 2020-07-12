package hud;

import flixel.ui.FlxSpriteButton;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class NotebookHUD extends FlxTypedSpriteGroup<FlxSprite> {
	private var notebook:FlxSprite;
	private var button:FlxSpriteButton;

	public var hudVisible:Bool = false;

	public var showTime = 0.2;
	public var hideTime = 0.2;

	private var objectives:Array<ObjectiveHUDElement> = [];

	public function new() {
		super();
		scrollFactor.set(0, 0);
		button = new FlxSpriteButton(showBook);
		button.loadGraphic(AssetPaths.noteButton__png);
		button.scrollFactor.set(0, 0);
		button.setPosition(FlxG.width - button.width, FlxG.height - button.height);
		add(button);

		notebook = new FlxSprite(AssetPaths.notebookHUD__png);
		notebook.scrollFactor.set(0, 0);
		notebook.setPosition(100, FlxG.height);
		add(notebook);
	}

	private function onClick() {
		if (hudVisible) {
			return;
		}
		showBook();
	}

	private function showBook() {
		var hideSmallBook = FlxTween.linearMotion(button, button.x, button.y, FlxG.width - button.width, FlxG.height, showTime);
		var showBigBook = FlxTween.linearMotion(notebook, 0, FlxG.height, 0, 0, showTime);
		
		showBigBook.onComplete = (t) -> hudVisible = true;

		hideSmallBook.then(showBigBook);
	}

	private function hideBook(time:Float) {
		var hideBigBook = FlxTween.linearMotion(notebook, notebook.x, notebook.y, 0, FlxG.height, time);
		var showSmallBook = FlxTween.linearMotion(button, FlxG.width - button.width, FlxG.height, FlxG.width - button.width,  FlxG.height - button.height, time);
		
		showSmallBook.onComplete = (t) -> hudVisible = false;

		hideBigBook.then(showSmallBook);
	}

	override public function update(delta:Float) {
		notebook.update(delta);
		button.update(delta);

		if (FlxG.mouse.justPressed && hudVisible) {
			hideBook(hideTime);
		}

		for (i in 0...objectives.length) {
			objectives[i].x = 300;
			objectives[i].y = notebook.y + 100 + 50*i;
		}
	}

	public function addObjective(obj:ObjectiveHUDElement) {
		objectives.push(obj);
		add(obj);
	}
}