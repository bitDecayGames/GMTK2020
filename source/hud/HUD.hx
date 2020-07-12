package hud;

import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
    var healthCounter:FlxText;
    var healthIcon:FlxSprite;
    var player:Player;
    var health:Float;

    public function new(player:Player)
    {
        super();
        this.player = player;
        healthCounter = new FlxText(16, 2, 0, "3 / 3", 8);
        healthCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        healthIcon = new FlxSprite(4, healthCounter.y + (healthCounter.height/2)  - 4, AssetPaths.heart__png);
        add(healthIcon);
        add(healthCounter);
        forEach(function(sprite) sprite.scrollFactor.set(0, 0));
    }

    public function updateHUD(health:Int, money:Int)
    {
        health = player.health;
        healthCounter.text = health + " / 3";
    }
}