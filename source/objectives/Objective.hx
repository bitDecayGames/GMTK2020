package objectives;

import flixel.FlxSprite;
import trigger.Trigger;
import flixel.math.FlxPoint;

class Objective extends Trigger{
    var description:String;
    var completed:Bool;

    public function new(desc:String) {
        super();
        // TODO Remove
        super.loadGraphic(AssetPaths.ObjectiveIcon__png, true);
        description = desc;
        completed = false;
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
}