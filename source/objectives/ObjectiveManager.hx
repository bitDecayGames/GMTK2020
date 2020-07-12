package objectives;

import dialogbox.DialogManager;
import flixel.FlxSprite;
import trigger.Trigger;
import flixel.math.FlxPoint;

class ObjectiveManager{
    var objectives:Array<Objective>;
    var dialogManager:DialogManager;

    public function new() {
        objectives = new Array<Objective>();
    }

    public function getObjectives():Array<Objective>{
        return objectives;
    }

    public function createObjective(desc:String, index:Int):Trigger  {
        var objective = new Objective(this, desc, index);
        objectives.push(objective);
        return objective;
    }

    public function setDialogManager(_dialogManager:DialogManager) {
        dialogManager = _dialogManager;
    }

    public static function compare(a:Objective, b:Objective):Int {
        return a.index - b.index;
    }

    public function setupObjectives(){
        for(o in objectives)
            if(o.index != 1)
                o.kill();
    }

    public function moveOn(){
        for(o in objectives){
            if(!o.completed){
                FmodManager.PlaySoundOneShot(FmodSFX.NewMission);
                o.revive();
                dialogManager.loadDialog(o.index-1);
                return;
            }
        }
    }
}