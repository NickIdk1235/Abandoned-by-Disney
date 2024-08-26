package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import haxe.Timer;

class StoryMenuSubState extends MusicBeatSubstate {
	var options:Array<Dynamic> = [
		{option: "NewGame", image: "menuNewGame"},
		{option: "BackToMenu", image: "menuLeave"},
	];
	var curOption:Int = -1;

	var grpMenuShit:FlxTypedGroup<FlxSprite>;
	var backFade:FlxSprite;

	public function new() {
		super();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		backFade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		backFade.alpha = 0;
		add(backFade);

		grpMenuShit = new FlxTypedGroup<FlxSprite>();
		for (i in 0...options.length) {
			var new_opt:FlxSprite = new FlxSprite(20, (FlxG.height / 4) + (i * 80)).loadGraphic(Paths.image('story_menu/${options[i].image}'));
			new_opt.alpha = 0;
			grpMenuShit.add(new_opt);
		}
		add(grpMenuShit);

		FlxTween.tween(backFade, {alpha: 0.5}, 1, {
			ease: FlxEase.quadInOut,
			onComplete: (twn) -> {
				canControlle = true;
			}});
		for (i in 0...grpMenuShit.length) {
			FlxTween.tween(grpMenuShit.members[i], {alpha: 1}, 0.5 + (i * 0.2), {ease: FlxEase.quadInOut});
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!canControlle) {
			return;
		}

		var isOverlap:Bool = false;
		for (i in 0...grpMenuShit.length) {
			var _opt = grpMenuShit.members[i];
			if (!FlxG.mouse.overlaps(_opt)) {
				continue;
			}
			changeOption(i);
			isOverlap = true;
			if (FlxG.mouse.justPressed) {
				chooseOption();
			}
		}
		if (!isOverlap) {
			changeOption(-1);
		}
	}

	public function changeOption(_value:Int = 0):Void {
		if (curOption == _value) {
			return;
		}
		curOption = _value;

		if (_value != -1) {
			FlxG.sound.play(Paths.sound('Generic_Scroll_1'), 0.5);
		}

		for (i in 0...grpMenuShit.length) {
			var _opt = grpMenuShit.members[i];
			FlxTween.cancelTweensOf(_opt);
			FlxTween.tween(_opt, {x: i == _value ? 50 : 20}, 0.3, {ease: FlxEase.quadInOut});
		}
	}

	public function chooseOption():Void {
		FlxFlicker.flicker(grpMenuShit.members[curOption], 1, 0.04);
		FlxG.sound.play(Paths.sound('Generic_Select_2'));
		canControlle = false;

		Timer.delay(() -> {
			switch (options[curOption].option) {
				case "NewGame": {MusicBeatState.switchState(new FreeplayState());}
				case "BackToMenu": {doClose();}
			}
		}, 1000);
	}

	function doClose():Void {
		canControlle = false;
		FlxTween.tween(backFade, {alpha: 0}, 1, {
			ease: FlxEase.quadInOut,
			onComplete: (twn) -> {
				close();
			}
		});
		for (i in 0...grpMenuShit.length) {
			FlxTween.tween(grpMenuShit.members[i], {alpha: 0}, 0.5 + (i * 0.2), {ease: FlxEase.quadInOut});
		}
	}
}
