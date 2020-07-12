package entities;

import flixel.FlxG;
import fx.Trash;
import flixel.FlxSprite;

class TrashCan extends FlxSprite{

    public function new()
    {
        super();
        super.loadGraphic(AssetPaths.trashCanPaticle__png, true);
        this.immovable = true;
    }

    public function asplode() {
        var trashEmitter = new Trash();
        var trashcanEmitter = new fx.TrashCan();

        var middle = getMidpoint();
        trashEmitter.setPosition(middle.x, middle.y);
        trashcanEmitter.setPosition(middle.x, middle.y);
        FlxG.state.add(trashEmitter);
        FlxG.state.add(trashcanEmitter);

        trashEmitter.blast(angle);
        trashcanEmitter.blast(angle - 90);
        kill();
    }
}