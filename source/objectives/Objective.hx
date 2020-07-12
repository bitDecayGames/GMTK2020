package objectives;

import flixel.FlxSprite;
import trigger.Trigger;
import flixel.math.FlxPoint;

class Objective extends Trigger{
    var description:String;
    public var completed:Bool;
    public var index:Int;
    var objectiveManager:ObjectiveManager;

    public function new(_objManager:ObjectiveManager, desc:String, _index:Int) {
        super();
        // TODO Remove
        super.loadGraphic(AssetPaths.ObjectiveIcon__png, true);
        objectiveManager = _objManager;
        description = desc;
        completed = false;
        index = _index;
        register(completeObjective);
    }

    public function getStatus():Bool{
        return completed;
    }

    public function getDescription():String{
        return description;
    }

    private function completeObjective(spr:FlxSprite){
        completed = true;
    }

    override function activate() {
        super.activate();
        completed = true;
        objectiveManager.moveOn();
    }
}