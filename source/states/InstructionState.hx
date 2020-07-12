package states;

import analytics.Measurements;
import com.bitdecay.analytics.Bitlytics;
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
    var _runText:FlxText;
    var _objectiveText:FlxText;

    override public function create():Void {
        super.create();
        Bitlytics.Instance().Queue(Measurements.InstructionsViewed, 1);
        
        bgColor = FlxColor.TRANSPARENT;

        _movementText = new FlxText();
        _movementText.setPosition(FlxG.width/2, FlxG.height/4);
        _movementText.size = 20;
        _movementText.alignment = FlxTextAlign.CENTER;
        _movementText.text = "Move with WASD or Arrow keys";
        _movementText.x = FlxG.width/2 - _movementText.width/2;

        add(_movementText);

        _runText = new FlxText();
        _runText.setPosition(FlxG.width/2, FlxG.height/4);
        _runText.size = 20;
        _runText.alignment = FlxTextAlign.CENTER;
        _runText.y = _movementText.y + 30;
        _runText.text = "Dodge using the space key";
        _runText.x = FlxG.width/2 - _runText.width/2;
        add(_runText);

        _dodgeText = new FlxText();
        _dodgeText.setPosition(FlxG.width/2, FlxG.height/4);
        _dodgeText.size = 20;
        _dodgeText.alignment = FlxTextAlign.CENTER;
        _dodgeText.y = _runText.y + 30;
        _dodgeText.text = "Run using the shift key";
        _dodgeText.x = FlxG.width/2 - _dodgeText.width/2;
        
        add(_dodgeText);

        _objectiveText = new FlxText();
        _objectiveText.setPosition(FlxG.width/2, FlxG.height/4);
        _objectiveText.size = 20;
        _objectiveText.alignment = FlxTextAlign.CENTER;
        _objectiveText.y = _dodgeText.y + 30;
        _objectiveText.text = "Complete objectives by running into them";
        _objectiveText.x = FlxG.width/2 - _objectiveText.width/2;
        
        add(_objectiveText);

        _backDone = UiHelpers.CreateMenuButton("Back", clickBack);
        _backDone.setPosition(FlxG.width/2 - _backDone.width/2, FlxG.height - _backDone.height - 40);
        _backDone.updateHitbox();
        add(_backDone);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

    }

    function clickBack():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
    }
}