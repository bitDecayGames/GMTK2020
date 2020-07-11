package trigger;

import flixel.FlxSprite;

class Trigger extends FlxSprite
{
    var callbacks:Array<Void->Void>;

	public function new()
	{
		super();

        callbacks = [];

		super.loadGraphic("assets/images/car/0.png", true, 60, 130);
    }
    
    public function register(callback: Void->Void) {
        callbacks.push(callback);
    }

    public function activate() {
        for (c in callbacks) {
            c();
        }
        kill();
    }
}