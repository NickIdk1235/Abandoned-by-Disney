package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;
#if desktop
import Discord.DiscordClient;
import lime.app.Application;
#end
import openfl.Lib;

class WarningState extends MusicBeatState {
	private var glitch_shader_enter:FlxRuntimeShader;
	private var glitch_shader:FlxRuntimeShader;

	private var enter:FlxSprite;

	private var vinSound:FlxSound;

	override function create() {
		super.create();

		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = false;
		FlxG.mouse.load(Paths.getPath('images/Cursor.png', IMAGE), 0.1, -8, -8);
		Lib.application.window.title = "FNF: Abandoned by Disney - WARNING";
		super.setLastMenu('warning');

		FlxG.sound.playMusic(Paths.music('Warning_ambience'), 0);

		FlxG.save.bind('funkin', 'ninjamuffin99');

		Highscore.load();

		#if desktop
		if (!DiscordClient.isInitialized) {
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode) {
				DiscordClient.shutdown();
			});
		}
		#end

		PlayerSettings.init();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = ClientPrefs.muteKeys;
		FlxG.sound.volumeDownKeys = ClientPrefs.volumeDownKeys;
		FlxG.sound.volumeUpKeys = ClientPrefs.volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		ClientPrefs.loadPrefs();

		glitch_shader_enter = CoolUtil.getShader("glitch");
		glitch_shader_enter.setFloat("GLITCH", 0);

		glitch_shader = CoolUtil.getShader("glitch");
		glitch_shader.setFloat("GLITCH", 0.08);

		var background:FlxSprite = new FlxSprite().loadGraphic(Paths.image("warning_menu/warningbg"));
		background.setGraphicSize(0, FlxG.height);
		background.updateHitbox();
		background.antialiasing = ClientPrefs.globalAntialiasing;
		background.shader = glitch_shader;
		background.screenCenter();
		background.alpha = 0;
		add(background);

		var title:FlxSprite = new FlxSprite(0, 50).loadGraphic(Paths.image("warning_menu/Warning"));
		title.scale.set(background.scale.x, background.scale.y);
		title.updateHitbox();
		title.antialiasing = ClientPrefs.globalAntialiasing;
		title.screenCenter(X);
		title.alpha = 0;
		add(title);

		var description:FlxSprite = new FlxSprite().loadGraphic(Paths.image("warning_menu/warnningtext"));
		description.scale.set(background.scale.x, background.scale.y);
		description.updateHitbox();
		description.antialiasing = ClientPrefs.globalAntialiasing;
		description.screenCenter();
		description.alpha = 0;
		description.y += 10;
		add(description);

		enter = new FlxSprite(0, 20).loadGraphic(Paths.image("warning_menu/warningpressenter"));
		enter.scale.set(background.scale.x, background.scale.y);
		enter.updateHitbox();
		enter.antialiasing = ClientPrefs.globalAntialiasing;
		enter.y = FlxG.height + enter.height + 25;
		enter.shader = glitch_shader_enter;
		enter.screenCenter(X);
		add(enter);

		vinSound = new FlxSound();
		vinSound.loadEmbedded(Paths.music('vinyl'), true);
		vinSound.volume = 0;
		vinSound.play();
		FlxG.sound.list.add(vinSound);

		FlxG.camera.setFilters([
			CoolUtil.getShaderFilter("tv_screen"),
			CoolUtil.convShaderFilter(glitch_shader_enter)
		]);

		FlxTween.tween(title, {alpha: 1}, 1, {startDelay: 1.3});
		FlxTween.tween(background, {alpha: 1}, 1, {startDelay: 1});
		FlxTween.tween(description, {alpha: 1}, 1, {startDelay: 1.6});
		FlxTween.tween(enter, {y: FlxG.height - enter.height - 25}, 1, {
			ease: FlxEase.quadInOut,
			startDelay: 2,
			onComplete: (twn) -> {
				canControlle = true;
			}});
	}

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.6) {
			FlxG.sound.music.volume += 0.2 * FlxG.elapsed;
		}

		super.update(elapsed);

		if (!canControlle) {
			return;
		}

		if (controls.ACCEPT) {
			doContinue();
		}

		if (FlxG.keys.justPressed.T) {
			MusicBeatState.switchState(new FreeplayState());
			FlxG.sound.playMusic(Paths.music('NEW_freeplay_Theme'), 0);
		} // skip intro for Lel
	}

	public function doContinue() {
		canControlle = false;

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		WeekData.loadTheFirstEnabledMod();

		FlxG.sound.play(Paths.sound('Generic_Select_2'));

		FlxFlicker.flicker(enter, 1);
		FlxTween.tween(vinSound, {volume: 2}, 1, {ease: FlxEase.quadIn, startDelay: 0.5});
		FlxTween.num(0, 1, 1, {
			ease: FlxEase.quadInOut,
			startDelay: 0.5,
			onComplete: (twn) -> {
				FlxG.camera.setFilters([]);
				persistentDraw = false;

				vinSound.stop();
				FlxG.sound.music.stop();

				Paths.clearStoredMemory();
				Paths.clearUnusedMemory();

				MusicBeatState.switchState(new MainMenuState());
			}
		}, (_value) -> {
			glitch_shader_enter.setFloat("GLITCH", _value);
		});
	}
}
