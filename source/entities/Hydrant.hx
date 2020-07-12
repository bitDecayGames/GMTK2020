package entities;

import flixel.FlxSprite;

class Hydrant extends FlxSprite{

    public function new()
    {
        super();
        super.loadGraphic(AssetPaths.Hydrant__png, true);
    }
}