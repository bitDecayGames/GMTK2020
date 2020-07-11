package objectives;

import flixel.FlxSprite;
import trigger.Trigger;
import flixel.math.FlxPoint;

class ObjectiveManager{
    var objectives:Array<Objective>;

    public function new() {
        objectives = new Array<Objective>();
    }

    public function getObjectives():Array<Objective>{
        return objectives;
    }

    private function createObjective(desc:String):Trigger  {
        var objective = new Objective(desc);
        objectives.push(objective);
        return objective;
    }

}