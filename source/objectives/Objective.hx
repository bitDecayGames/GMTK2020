package objectives;

import flixel.FlxSprite;
import trigger.Trigger;
import flixel.math.FlxPoint;

class Objective extends Trigger{
    var description:String;
    var completed:Bool;

    public function new(desc:String) {
        super();
        description = desc;
        completed = false;
        register(completeObjective);
    }

    private function completeObjective(spr:FlxSprite){
        completed = true;
    }
}