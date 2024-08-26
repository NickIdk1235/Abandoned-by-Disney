package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class GameOverSubstate extends MusicBeatSubstate {
	public var boyfriend:GameOverBoyfriend;

	var playingDeathSound:Bool = false;
	var blackCover:FlxSprite;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'danielgGreenBlue';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'danielgGreenBlue';
		endSoundName = 'gameOverEnd';
	}

	override function create() {
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();

		boyfriend = new GameOverBoyfriend(0, 0, characterName);
		boyfriend.scrollFactor.set(0, 0);
		add(boyfriend);
		// trace(boyfriend.animationsArray.map(a -> a.anim));

		// To get the center
		boyfriend.debugMode = true;
		boyfriend.playAnim('deathLoop', true);
		boyfriend.updateHitbox();
		boyfriend.screenCenter(XY);
		boyfriend.debugMode = false;

		boyfriend.playAnim('firstDeath', true);

		blackCover = new FlxSprite(0, 0).makeGraphic(2, 2, FlxColor.BLACK);
		blackCover.setGraphicSize(Math.ceil(FlxG.width / 0.6 + 100), Math.ceil(FlxG.height / 0.6 + 100));
		blackCover.updateHitbox();
		blackCover.alpha = 0.0;
		blackCover.scrollFactor.set();
		blackCover.screenCenter();
		add(blackCover);

		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);
	}

	public function new() {
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		// camFollowPos = new FlxObject(0, 0, 1, 1);
		// camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		// add(camFollowPos);
	}

	var isFollowingAlready:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT) {
			endBullshit();
		}

		if (controls.BACK) {
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			WeekData.loadTheFirstEnabledMod();
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('Hallucinations_By_IronCthulhuApocalypse'));
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name == 'firstDeath') {
			if (boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready) {
				// FlxG.camera.follow(camFollowPos, LOCKON, 1);
				// updateCamera = true;
				isFollowingAlready = true;
			}

			if (boyfriend.animation.curAnim.finished) {
				coolStartDeath();
				boyfriend.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit() {
		super.beatHit();

		// FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void {
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void {
		if (isEnding)
			return;

		isEnding = true;
		boyfriend.playAnim('deathConfirm', true);
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.music(endSoundName));
		new FlxTimer().start(0.7, function(tmr:FlxTimer) {
			FlxTween.tween(blackCover, {alpha: 1}, 2, {
				onComplete: function(twn:FlxTween) {
					MusicBeatState.resetState();
				}
			});
		});
		PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
	}

	override function destroy() {
		instance = null;
		super.destroy();
	}
}

class GameOverBoyfriend extends Boyfriend {
	public var startedDeath:Bool = false;

	override function update(elapsed:Float) {
		if (!debugMode && animation.curAnim != null) {
			if (startedDeath && animation.curAnim.name == 'firstDeath' && animation.curAnim.finished) {
				playAnim('deathLoop');
			}
		}

		updateAnimation(elapsed);
	}

	override function dance() {}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0) {
		animation.play(AnimName, Force, Reversed, Frame);
		// trace("Playing anim " + AnimName);
	}
}
