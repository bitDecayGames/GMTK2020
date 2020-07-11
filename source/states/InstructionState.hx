package states;

import haxefmod.flixel.FmodFlxUtilities;
import helpers.UiHelpers;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIState;

class InstructionState extends FlxUIState {
    var _backDone:FlxButton;

    var _movementText:FlxText;
    var _dodgeText:FlxText;
    var _objectiveText:FlxText;

    override public function create():Void {
        super.create();
        bgColor = FlxColor.TRANSPARENT;

        _movementText = new FlxText();
        _movementText.setPosition(FlxG.width/2, FlxG.height/4);
        _movementText.size = 20;
        _movementText.alignment = FlxTextAlign.CENTER;
        _movementText.text = "Move with WASD or Arrow keys.";
        
        add(_movementText);

        _dodgeText = new FlxText();
        _dodgeText.setPosition(FlxG.width/2, FlxG.height/4);
        _dodgeText.size = 20;
        _dodgeText.alignment = FlxTextAlign.CENTER;
        _dodgeText.y = _dodgeText.y + 30;
        _dodgeText.text = "Dodge using the space key.";
        
        add(_dodgeText);

        _objectiveText = new FlxText();
        _objectiveText.setPosition(FlxG.width/2, FlxG.height/4);
        _objectiveText.size = 20;
        _objectiveText.alignment = FlxTextAlign.CENTER;
        _objectiveText.y = _objectiveText.y + 60;
        _objectiveText.text = "Complete objectives by running into them.";
        
        add(_objectiveText);

        _backDone = UiHelpers.CreateMenuButton("Back", clickBack);
        _backDone.setPosition(FlxG.width/2 - _backDone.width/2, FlxG.height - _backDone.height - 40);
        _backDone.updateHitbox();
        add(_backDone);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        _movementText.x = FlxG.width/2 - _movementText.width/2;
        _dodgeText.x = FlxG.width/2 - _dodgeText.width/2;
        _objectiveText.x = FlxG.width/2 - _objectiveText.width/2;
    }

    function clickBack():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
    }
}