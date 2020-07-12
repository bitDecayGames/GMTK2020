package dialogbox;

import flixel.input.keyboard.FlxKey;
import flixel.FlxState;


class DialogManager {

	var soundId:String = "";
    var typeText:Dialogbox;
    var parentState:FlxState;
    
    public function new(_parentState:FlxState) {
        parentState = _parentState;
		typeText = new Dialogbox(parentState, Dialogs.DialogArray[0], FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
		parentState.add(typeText);
    }

    public function update() {
		if (typeText.getIsTyping() && soundId == ""){
			soundId = FmodManager.PlaySoundWithReference(FmodSFX.Typewriter);
		} 
		if (typeText == null || !typeText.getIsTyping()){
            if (soundId != ""){
                FmodManager.StopSound(soundId);
            }
			soundId = "";
        }
    }

    public function loadDialog(index:Int){
        if (typeText != null) {
            typeText.flxTypeText.kill();
            typeText.kill();
        }
        FmodManager.StopSound(soundId);
        soundId = "";
        
        if (index >= Dialogs.DialogArray.length) {
        trace("index out of bounds for dialogs");
        return;
    }
		typeText = new Dialogbox(parentState, Dialogs.DialogArray[index], FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
		parentState.add(typeText);
    }
}