package dialogbox;

import haxe.Timer;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.input.keyboard.FlxKey;
import hx.concurrent.executor.Executor;

class Dialogbox extends FlxBasic {
    // constants
    static inline final CharactersPerTextBox = 91;

    var nextPageTimer:Timer;

    // caller's state so we can add our FlxTypeText to the game loop
    var parentState:FlxState;

    var isTyping:Bool;
    var canContinueToNextPage:Bool;
    var pages:Array<String>;
    var currentPage:Int = 0;

    public var flxTypeText:FlxTypeText;
    var progressionKey:FlxKey;

    public function new(parentState:FlxState, textList:Array<String>, progressionKey:FlxKey, monospacedFontAssetPath:Null<String>) {
        super();
        this.progressionKey = progressionKey;
        pages = new Array<String>();
        
        var currentPageBuffer:StringBuf;
        for(text in textList){
            currentPageBuffer = new StringBuf();
            for (i in 0...text.length) {
                if (i % CharactersPerTextBox == 0 && i != 0){ 
                    pages.push(currentPageBuffer.toString());
                    currentPageBuffer = new StringBuf();
                }
                currentPageBuffer.add(text.charAt(i));
    
                if (i == text.length-1){
                    pages.push(currentPageBuffer.toString());
                }
            }
        }

        flxTypeText = new FlxTypeText(20, 20, FlxG.width-20, pages[0], 1);
        flxTypeText.setFormat(monospacedFontAssetPath, 20);
        parentState.add(flxTypeText);
		flxTypeText.scrollFactor.set(0, 0);
        startTyping();
    }

	override public function update(elapsed:Float) {
        super.update(elapsed);

        if (canContinueToNextPage && FlxG.keys.justPressed.SPACE) {
            continueToNextPage();
        }
    }

    public function startTyping():Void {
        
        isTyping = true;

        // Callbacks cannot be set outside of the start() function...
        var callback = function() {
            allowNextPage();
            isTyping = false;
        }
        flxTypeText.start(.05, false, false, [progressionKey], callback);
    }

    public function continueToNextPage():Void {
        nextPageTimer.stop();
        canContinueToNextPage = false;
        
        currentPage++;
        if (currentPage >= pages.length){
            flxTypeText.destroy();
            destroy();
        } else {
            flxTypeText.resetText(pages[currentPage]);
            startTyping();
        }
    }

    public function allowNextPage():Void {
        // The text-skip button and next-page button are the same, so we add a slight delay here to separate the two commands
        var executor = Executor.create(1);
        var allowNextPage=function():Void {
            canContinueToNextPage = true;
            
            nextPageTimer = new Timer(3000);
            nextPageTimer.run = continueToNextPage;
        }
        executor.submit(allowNextPage, ONCE(10));
    }

    public function getIsTyping():Bool {
		return isTyping;
    }

    public function getFlxTypeText():FlxTypeText {
		return flxTypeText;
    }
}