package dialogbox;

import haxefmod.FmodEvents.FmodCallback;
import haxefmod.FmodEvents.FmodEvent;
import flixel.input.keyboard.FlxKey;
import flixel.FlxState;


class DialogManager {

    var typewriterSoundId:String = "typewriterSoundId";
    var typeText:Dialogbox;
    var parentState:FlxState;
    
    public function new(_parentState:FlxState) {
        parentState = _parentState;
        typeText = new Dialogbox(parentState, Dialogs.DialogArray[0], FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
        parentState.add(typeText);
    }

    public function update() {
        if (typeText.getIsTyping()){
            if (!FmodManager.IsSoundPlaying(typewriterSoundId)){
                FmodManager.PlaySoundAndAssignId(FmodSFX.Typewriter, typewriterSoundId);
            }
        } 
        if (typeText == null || !typeText.getIsTyping()) {
            if (FmodManager.IsSoundPlaying(typewriterSoundId)){
                FmodManager.StopSound(typewriterSoundId);
            }
        }
    }

    public function loadDialog(index:Int){
        if (typeText != null) {
            typeText.flxTypeText.kill();
            typeText.kill();
        }
        if (index >= Dialogs.DialogArray.length) {
        trace("index out of bounds for dialogs");
        return;
    }
    typeText = new Dialogbox(parentState, Dialogs.DialogArray[index], FlxKey.SPACE, AssetPaths.joystix_monospace__ttf);
    parentState.add(typeText);
    }

    public function stopSounds() {
        FmodManager.StopSoundImmediately(typewriterSoundId);
    }

}