package flixel.tweens.misc;

import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * Shake effect for a FlxSprite
 */
class ShakeTween extends FlxTween
{
	/**
	 * Percentage representing the maximum distance that the object can move while shaking.
	 */
	var intensity:Float;

	/**
	 * Defines on what axes to `shake()`. Default value is `XY` / both.
	 */
	var axes:FlxAxes;

	/**
	 * The sprite to shake.
	 */
	var sprite:FlxSprite;

	/**
	 * Defines the initial offset of the sprite at the beginning of the shake effect.
	 */
	var initialOffset:FlxPoint;

	/**
	 * A simple shake effect for FlxSprite.
	 *
	 * @param	Sprite       Sprite to shake.
	 * @param   Intensity    Percentage representing the maximum distance
	 *                       that the sprite can move while shaking.
	 * @param   Duration     The length in seconds that the shaking effect should last.
	 * @param   Axes         On what axes to shake. Default value is `FlxAxes.XY` / both.
	 */
	public function tween(Sprite:FlxSprite, Intensity:Float, Duration:Float, Axes:FlxAxes):ShakeTween
	{
		intensity = Intensity;
		sprite = Sprite;
		duration = Duration;
		axes = Axes;
		initialOffset = new FlxPoint(Sprite.offset.x, Sprite.offset.y);
		start();
		trace("made the tween for " + sprite);
		return this;
	}

	override function destroy():Void
	{
		super.destroy();
		// Return the sprite to its initial offset.
		if (sprite != null && !sprite.offset.equals(initialOffset))
			sprite.offset.set(initialOffset.x, initialOffset.y);

		sprite = null;
		initialOffset = null;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (axes.match(X | XY))
			sprite.offset.x = initialOffset.x + FlxG.random.float(-intensity * sprite.width, intensity * sprite.width);
		if (axes.match(Y | XY))
			sprite.offset.y = initialOffset.y + FlxG.random.float(-intensity * sprite.height, intensity * sprite.height);
		if (elapsed == 1) trace("Running the tween");
	}

	override function isTweenOf(Object:Dynamic, ?Field:String):Bool
	{
		return sprite == Object && (Field == null || Field == "shake");
	}
	
}
