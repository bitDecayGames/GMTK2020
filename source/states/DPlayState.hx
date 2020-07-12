package states;

import FmodConstants.FmodSFX;
import dialogbox.Dialogbox;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import haxefmod.FmodManager;

class DPlayState extends FlxState {
	var soundId:String = "";
	var typeText:Dialogbox;
	// var typeText:FlxTypeText;

	var textList = ["(Prace Spacebar)", "Hello Luke.", "I hear you want to make an RPG.", "That is great to hear, but you will need many tools to accomplish such a task.", "Maybe...", "A dialog system is one of those tools?", "Features:", "Letter-by-letter typing", "Sound effects","Automatic word wrapping when a sentance extends past the screen width","Automatic page breaks when a section of text extends past the maximum configured characters per page", "Skip commands make dialog go faster", "...", "more to come!"];

	override public function create() {
		super.create();

		typeText = new Dialogbox(this, textList, FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
		add(typeText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FmodManager.Update();

		if (typeText.getIsTyping() && soundId == ""){
			soundId = FmodManager.PlaySoundWithReference(FmodSFX.Typewriter);
		} 
		if (!typeText.getIsTyping() && soundId != ""){
			FmodManager.StopSound(soundId);
			soundId = "";
		}

		if (FlxG.keys.justPressed.R){
            FlxG.switchState(new PlayState());
		}
	}
}
