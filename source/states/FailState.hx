package states;

import objectives.ObjectiveManager;
import analytics.Measurements;
import com.bitdecay.analytics.Bitlytics;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;

class FailState extends FlxUIState {
    var _btnDone:FlxButton;
    var _btnSpanish:FlxButton;
    var inSpanish:Bool = true;

    var _txtTitle:FlxText;
    var _txtQuote:FlxText;
    var _txtQuoteAuthor:FlxText;

    var spanishTitle:String = "Fin Del Juego";
    var spanishQuote:String = "La lluvia cayó como balas muertas";

    var englishTitle:String = "Game Over";
    var englishQuote:String = "The rain fell like dead bullets";

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
        _txtTitle.text = spanishTitle;
        
        add(_txtTitle);

        _txtQuote = new FlxText();
        _txtQuote.setPosition(FlxG.width/8, _txtTitle.y + 125);
        _txtQuote.size = 24;
        _txtQuote.alignment = FlxTextAlign.CENTER;
        _txtQuote.text = spanishQuote;

        add(_txtQuote);

        _txtQuoteAuthor = new FlxText();
        _txtQuoteAuthor.setPosition(FlxG.width/3, _txtTitle.y + 175);
        _txtQuoteAuthor.size = 18;
        _txtQuoteAuthor.alignment = FlxTextAlign.CENTER;
        _txtQuoteAuthor.text = "Scott Nicholson";

        add(_txtQuoteAuthor);

        _btnDone = UiHelpers.CreateMenuButton("Main Menu", clickMainMenu);
        _btnDone.setPosition(FlxG.width/2 - _btnDone.width/2, FlxG.height - _btnDone.height - 40);
        _btnDone.updateHitbox();
        add(_btnDone);

        Bitlytics.Instance().Queue(Measurements.GameFailed, ObjectiveManager.hackObjectivesComplete);
        Bitlytics.Instance().ForceFlush();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FmodManager.Update();

        _txtTitle.x = FlxG.width/2 - _txtTitle.width/2;
        _txtQuote.x = FlxG.width/2 - _txtQuote.width/2;
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
            _txtTitle.text = spanishTitle;
            _txtQuote.text = spanishQuote;
            measurement = Measurements.GameFailedSpanishClick;
        } else {
            _btnSpanish.text = "Español";
            _txtTitle.text = englishTitle;
            _txtQuote.text = englishQuote;
            measurement = Measurements.GameFailedEnglishClick;
        }
        Bitlytics.Instance().Queue(measurement, 1);
        Bitlytics.Instance().ForceFlush();
    }
}
