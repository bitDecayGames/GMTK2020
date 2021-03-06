package checkpoint;

import com.bitdecay.textpop.TextPop;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import trigger.Trigger;

class CheckpointManager {
    var lastCheckpoint:FlxPoint;

    public function new() {
        lastCheckpoint = new FlxPoint();
    }

    public function getLastCheckpoint():FlxPoint {
        return lastCheckpoint;
    }

    public function createCheckpoint():Trigger  {
        var checkpoint = new Trigger();
        checkpoint.register(handleCheckpointActivated);
        return checkpoint;
    }

    private function handleCheckpointActivated(spr: FlxSprite) {    
        lastCheckpoint.x = spr.x;
        lastCheckpoint.y = spr.y;

        TextPop.pop(cast(spr.x, Int), cast(spr.y, Int), "Checkpoint Reached");
    }
}