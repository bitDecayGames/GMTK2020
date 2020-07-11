package trigger;

import flixel.FlxSprite;

class Trigger extends FlxSprite
{
    var callbacks:Array<FlxSprite->Void>;

	public function new()
	{
        super();
        callbacks = [];

        // TODO Remove
        super.loadGraphic("assets/images/car/0.png", true, 60, 130);
    }
    
    public function register(callback: FlxSprite->Void) {
        callbacks.push(callback);
    }

    public function activate() {
        for (c in callbacks) {
            c(this);
        }
        kill();
    }
}