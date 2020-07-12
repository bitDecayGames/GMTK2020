package entities;

import flixel.FlxG;
import fx.Water;
import flixel.FlxSprite;

class Hydrant extends FlxSprite{

    public function new()
    {
        super();
        super.loadGraphic(AssetPaths.Hydrant__png, true);
        this.immovable = true;
    }

    public function asplode() {
        var waterEmitter = new Water();
        var hydrantEmitter = new fx.Hydrant();

        var middle = getMidpoint();
        waterEmitter.setPosition(middle.x, middle.y);
        hydrantEmitter.setPosition(middle.x, middle.y);
        FlxG.state.add(waterEmitter);
        FlxG.state.add(hydrantEmitter);

        waterEmitter.blast(angle);
        hydrantEmitter.blast(angle - 90);
        kill();
    }
}