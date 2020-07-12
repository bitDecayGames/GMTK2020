package hud;

import flixel.util.FlxCollision;
import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
    var background:FlxSprite;
    var healthCounter:FlxText;
    var healthIcon:FlxSprite;
    var player:Player;
    var health:Float;

    public function new(player:Player)
    {
        super();
        this.player = player;
        background = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
        background.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
        healthCounter = new FlxText(30, 2, 0, "3 / 3", 8);
        healthCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        healthIcon = new FlxSprite(0, -8, AssetPaths.heart__png);
        healthIcon.scale.x = 0.4;
        healthIcon.scale.y = 0.4;
        add(background);
        add(healthIcon);
        add(healthCounter);
        forEach(function(sprite) sprite.scrollFactor.set(0, 0));
    }

    public function updateHUD(health:Int, money:Int)
    {
        this.health = player.health;
        healthCounter.text = health + " / 3";
    }
}