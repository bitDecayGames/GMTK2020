package sorting;

import flixel.util.FlxSort;
import flixel.FlxSprite;

class ZSorter {
	static var ARIBITRARY_LARGE_VALUE = 9999999;

	// sort will sort things based on the CENTER-Y of their hitboxes
	public static inline function sort(order:Int, s1:FlxSprite, s2:FlxSprite):Int {
		return FlxSort.byValues(
			order,
			s1.y + (s1.height / 2),
			s2.y + (s2.height / 2)
		);
	}

	public static inline function sortNested(order:Int, s1:FlxSprite, s2:FlxSprite):Int {
		return FlxSort.byValues(order, s1.y + s1.height / 2, s2.y + s2.height / 2);
	}
}