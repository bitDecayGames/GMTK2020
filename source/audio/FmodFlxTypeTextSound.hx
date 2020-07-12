package audio;

import FmodConstants.FmodSFX;
import flixel.FlxG;
import flixel.system.FlxSound;
import haxefmod.FmodManager;

class FmodFlxTypeTextSound extends FlxSound {

    var timesPlayed:Int = 0;
    var fmodSoundPath:String;

    public function new(fmodSoundPath:String) {
        super();
        this.fmodSoundPath = fmodSoundPath;
    }

    override function play(ForceRestart:Bool = false, StartTime:Float = 0.0, ?EndTime:Float):FlxSound {
        FmodManager.PlaySoundOneShot(fmodSoundPath);
        return this;
    }
}
