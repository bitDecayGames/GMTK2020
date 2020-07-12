package states;

import flixel.input.keyboard.FlxKey;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
import lime.system.System;

class MainMenuState extends FlxUIState {
    var _btnPlay:FlxButton;
    var _btnCredits:FlxButton;
    var _btnInstructions:FlxButton;
    var _btnExit:FlxButton;

    var _txtTitle:FlxText;

    var rainReference:String = FmodSFX.Rain + "-0";

    override public function create():Void {
        super.create();
        if (!FmodManager.IsSongPlaying()) {
            // I know the reference string, so I don't grab it here.
            // Remove the rain from the title screen before releasing the game. It is buggy
            // FmodManager.PlaySoundWithReference(FmodSFX.Rain);
        }
        // FmodManager.RegisterLightning(rainReference);
        FmodManager.PlaySong(FmodSongs.SomethingIsAmiss);

        FlxG.log.notice("loaded scene");
        bgColor = FlxColor.TRANSPARENT;

        _txtTitle = new FlxText();
        _txtTitle.setPosition(FlxG.width/2, FlxG.height/4);
        _txtTitle.size = 40;
        _txtTitle.alignment = FlxTextAlign.CENTER;
        _txtTitle.text = "Game Title";
        
        add(_txtTitle);

        _btnPlay = UiHelpers.CreateMenuButton("Play", clickPlay);
        _btnPlay.setPosition(FlxG.width/2 - _btnPlay.width/2, FlxG.height - _btnPlay.height - 100);
        _btnPlay.updateHitbox();
        add(_btnPlay);

        _btnInstructions = UiHelpers.CreateMenuButton("Instructions", clickInstructions);
        _btnInstructions.setPosition(FlxG.width/2 - _btnInstructions.width/2, FlxG.height - _btnInstructions.height - 70);
        _btnInstructions.updateHitbox();
        add(_btnInstructions);

        _btnCredits = UiHelpers.CreateMenuButton("Credits", clickCredits);
        _btnCredits.setPosition(FlxG.width/2 - _btnCredits.width/2, FlxG.height - _btnCredits.height - 40);
        _btnCredits.updateHitbox();
        add(_btnCredits);

        #if windows
        _btnExit = UiHelpers.CreateMenuButton("Exit", clickExit);
        _btnExit.setPosition(FlxG.width/2 - _btnExit.width/2, FlxG.height - _btnExit.height - 40);
        _btnExit.updateHitbox();
        add(_btnExit);
        #end
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        // if (FmodManager.HasLightningStruck(rainReference) || FlxG.keys.pressed.P) {
        //     FlxG.camera.flash(FlxColor.WHITE, 0.5);
        // }

        _txtTitle.x = FlxG.width/2 - _txtTitle.width/2;
    }

    function clickPlay():Void {
        FmodFlxUtilities.TransitionToStateAndStopMusic(new TannerState());
    }

    function clickCredits():Void {
        FmodFlxUtilities.TransitionToState(new CreditsState());
    }

    function clickInstructions():Void{
        FmodFlxUtilities.TransitionToState(new InstructionState());
    }

    #if windows
    function clickExit():Void {
        System.exit(0);
    }
    #end
}