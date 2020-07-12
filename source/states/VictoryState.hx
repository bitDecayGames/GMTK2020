package states;

import analytics.Measurements;
import objectives.ObjectiveManager;
import com.bitdecay.analytics.Common;
import com.bitdecay.analytics.Bitlytics;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;

class VictoryState extends FlxUIState {
    var _btnDone:FlxButton;
    var _btnSpanish:FlxButton;
    var inSpanish:Bool = true;

    var _txtTitle:FlxText;
    var _txtQuote1:FlxText;
    var _txtQuote2:FlxText;
    var _txtQuoteAuthor:FlxText;

    var spanishQuote1:String = "No has terminado con Bielorrusia hasta";
    var spanishQuote2:String = "que Bielorrusia haya terminado contigo";

    var englishQuote1:String = "You're not done with Belaruse";
    var englishQuote2:String = "until Belaruse is done with you";

    override public function create():Void {
        super.create();
        bgColor = FlxColor.TRANSPARENT;

        _btnSpanish = UiHelpers.CreateMenuButton("English", clickSpanish);
        _btnSpanish.setPosition(FlxG.width - _btnSpanish.width, 0);
        _btnSpanish.updateHitbox();
        add(_btnSpanish);

        _txtTitle = new FlxText();
        _txtTitle.setPosition(FlxG.width/2, FlxG.height/4);
        _txtTitle.size = 40;
        _txtTitle.alignment = FlxTextAlign.CENTER;
        _txtTitle.text = "Fin";
        
        add(_txtTitle);

        _txtQuote1 = new FlxText();
        _txtQuote1.setPosition(FlxG.width/8, _txtTitle.y + 125);
        _txtQuote1.size = 24;
        _txtQuote1.alignment = FlxTextAlign.CENTER;
        _txtQuote1.text = spanishQuote1;

        add(_txtQuote1);

        _txtQuote2 = new FlxText();
        _txtQuote2.setPosition(FlxG.width/8, _txtTitle.y + 160);
        _txtQuote2.size = 24;
        _txtQuote2.alignment = FlxTextAlign.CENTER;
        _txtQuote2.text = spanishQuote2;

        add(_txtQuote2);

        _txtQuoteAuthor = new FlxText();
        _txtQuoteAuthor.setPosition(FlxG.width/3, _txtTitle.y + 210);
        _txtQuoteAuthor.size = 18;
        _txtQuoteAuthor.alignment = FlxTextAlign.CENTER;
        _txtQuoteAuthor.text = "Philip Elliott";

        add(_txtQuoteAuthor);

        _btnDone = UiHelpers.CreateMenuButton("Main Menu", clickMainMenu);
        _btnDone.setPosition(FlxG.width/2 - _btnDone.width/2, FlxG.height - _btnDone.height - 40);
        _btnDone.updateHitbox();
        add(_btnDone);

        Bitlytics.Instance().Queue(Common.GameCompleted, ObjectiveManager.hackObjectivesComplete);
        Bitlytics.Instance().ForceFlush();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        _txtTitle.x = FlxG.width/2 - _txtTitle.width/2;
        _txtQuote1.x = FlxG.width/2 - _txtQuote1.width/2;
        _txtQuote2.x = FlxG.width/2 - _txtQuote2.width/2;
        _txtQuoteAuthor.x = FlxG.width/2 - _txtQuoteAuthor.width/2;
    }

    function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
    }

    function clickSpanish():Void {
        inSpanish = !inSpanish;
        var measurement:String = "missing";
        if (inSpanish) {
            _btnSpanish.text = "English";
            _txtQuote1.text = spanishQuote1;
            _txtQuote2.text = spanishQuote2;
            measurement = Measurements.GameCompletedSpanishClick;
        } else {
            _btnSpanish.text = "Español";
            _txtQuote1.text = englishQuote1;
            _txtQuote2.text = englishQuote2;
            measurement = Measurements.GameCompletedEnglishClick;
        }
        Bitlytics.Instance().Queue(measurement, 1);
        Bitlytics.Instance().ForceFlush();
    }
}