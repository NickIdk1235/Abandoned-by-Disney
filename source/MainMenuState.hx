package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.app.Application;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.Timer;
#if desktop
import Discord.DiscordClient;
#end
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState {
	public static var psychEngineVersion:String = '0.0.1'; // This is also used for Discord RPC
	private static var onTitle:Bool = true;
	public static var _first:Bool = true;

	private var glitch2_shader:FlxRuntimeShader;
	private var glitch_shader:FlxRuntimeShader;
	private var screen_shader:FlxRuntimeShader;
	private var opt_shader:FlxRuntimeShader;

	public var background:FlxSprite;
	public var titleLogo:FlxSprite;

	public var verPsych:FlxText;
	public var verMod:FlxText;

	private var optionShit:Array<Dynamic> = [
		{
			x: 400,
			y: 125,
			option: 'story_mode',
			image: 'Mainstory'
		},
		{
			x: 920,
			y: 513,
			option: 'freeplay',
			image: 'Freeplay_Plank'
		},
		{
			x: 0,
			y: 480,
			option: 'credits',
			image: 'Devteam'
		},
		{
			x: 475,
			y: 513,
			option: 'options',
			image: 'Settings_Plank'
		},
		{
			x: 842,
			y: 50,
			option: 'coming_soon',
			image: 'TI'
		},
	];

	public var menuItems:FlxTypedGroup<FlxSprite>;

	private var camFollow:FlxObject;

	override function create():Void {
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end

		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxTransitionableState.skipNextTransOut = true;
		FlxTransitionableState.skipNextTransIn = true;
		persistentUpdate = persistentDraw = true;

		glitch_shader = CoolUtil.getShader("glitch");
		glitch_shader.setFloat("GLITCH", 0.08);

		glitch2_shader = CoolUtil.getShader("glitch2");
		glitch2_shader.setBool("isActive", false);

		screen_shader = CoolUtil.getShader("tv_screen2");
		screen_shader.setBool("isActive", false);
		screen_shader.setBool("GLITCH", false);

		opt_shader = CoolUtil.getShader("glitch");

		background = new FlxSprite(-80).loadGraphic(Paths.image('main_menu/background'));
		background.antialiasing = ClientPrefs.globalAntialiasing;
		background.setGraphicSize(FlxG.width, FlxG.height);
		background.shader = glitch_shader;
		background.screenCenter();
		add(background);

		// background.scrollFactor.set(0, yScroll);
		// background.setPosition(-20,-320);
		// background.setPosition(0 + Math.acos(i),-55 + Math.asin(i));

		// FlxTween.circularMotion(background, 0, 0, 20, 0, true, 10, true, { type: LOOPING });

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuItems = new FlxTypedGroup<FlxSprite>();
		for (cur_option in optionShit) {
			var newOption:FlxSprite = new FlxSprite(cur_option.x, cur_option.y).loadGraphic(Paths.image('main_menu/${cur_option.image}'));
			newOption.scale.set(0.3, 0.3);
			newOption.updateHitbox();
			menuItems.add(newOption);
		}
		add(menuItems);

		// FlxG.camera.follow(camFollowPos, null, 1);

		titleLogo = new FlxSprite(50, 50).loadGraphic(Paths.image('abd_logo'));
		titleLogo.setGraphicSize(Std.int(FlxG.width / 4));
		titleLogo.shader = glitch2_shader;
		titleLogo.updateHitbox();
		add(titleLogo);

		// NG.core.calls.event.logEvent('swag').send();

		// changeItem();

		verMod = new FlxText(12, FlxG.height - 44, 0, "Abandoned By Disney v" + psychEngineVersion, 12);
		verMod.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		verMod.scrollFactor.set();
		verMod.visible = false;
		add(verMod);

		verPsych = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		verPsych.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		verPsych.scrollFactor.set();
		verPsych.visible = false;
		add(verPsych);

		FlxG.camera.setFilters([CoolUtil.convShaderFilter(screen_shader)]);

		super.create();

		FlxG.camera.fade(FlxColor.BLACK, 3, true);
		checkFirst();
	}

	override function update(elapsed:Float):Void {
		if (super.getLastMenu() == 'warning' || FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('Hallucinations_By_IronCthulhuApocalypse'), 0);
		}
		if (super.getLastMenu() == 'freeplay' || FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('Hallucinations_By_IronCthulhuApocalypse'), 0);
			Lib.application.window.title = "FNF: Abandoned by Disney - Main Menu";
		}
		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		super.setLastMenu('main');
		super.update(elapsed);

		if (FlxG.random.bool(50 * elapsed)) {
			glitch2_shader.setBool("isActive", !glitch2_shader.getBool("isActive"));
		}
		if (FlxG.random.bool((screen_shader.getBool("isActive") ? 90 : 20) * elapsed)) {
			screen_shader.setBool("isActive", !screen_shader.getBool("isActive"));
		}

		if (!canControlle) {
			return;
		}

		if (onTitle) {
			if (FlxG.mouse.justPressed) {
				goToMenu();
				return;
			}
		} else {
			for (i in 0...menuItems.length) {
				var _opt = menuItems.members[i];
				if (!FlxG.mouse.overlaps(_opt)) {
					_opt.shader = null;
					continue;
				}
				_opt.shader = opt_shader;
				if (FlxG.mouse.justPressed) {
					chooseOption(i);
					return;
				}
				break;
			}
		}
	}

	public function checkFirst():Void {
		if (!_first) {
			canControlle = true;
			Lib.application.window.title = "FNF: Abandoned by Disney - Main Menu";
			background.setGraphicSize(Std.int(background.width * 1.2));
			background.updateHitbox();
			FlxTween.circularMotion(background, -50, -320, 50, 0, true, 10, true, {type: LOOPING});
			FlxG.mouse.visible = true;
			return;
		}
		_first = false;

		for (_opt in menuItems) {
			_opt.alpha = 0;
		}

		titleLogo.setGraphicSize(0, FlxG.height - 100);
		titleLogo.updateHitbox();
		titleLogo.screenCenter();
		titleLogo.visible = false;

		glitch_shader.setFloat("GLITCH", 0);

		Timer.delay(() -> {
			startTitle();
		}, 5000);
	}

	public function startTitle():Void {
		FlxG.camera.flash(FlxColor.WHITE, 1);

		Lib.application.window.title = "FNF: Abandoned by Disney";

		FlxG.mouse.visible = true;
		canControlle = true;

		verMod.visible = true;
		verPsych.visible = true;
		titleLogo.visible = true;

		glitch_shader.setFloat("GLITCH", 0.08);

		background.setGraphicSize(Std.int(background.width * 1.2));
		background.updateHitbox();
		FlxTween.circularMotion(background, -50, -320, 50, 0, true, 10, true, {type: LOOPING});
	}

	public function goToMenu():Void {
		FlxG.sound.play(Paths.sound('Generic_Select'));

		Lib.application.window.title = "FNF: Abandoned by Disney - Main Menu";

		onTitle = false;
		canControlle = false;

		screen_shader.setBool("force", true);
		screen_shader.setBool("GLITCH", true);

		Timer.delay(() -> {
			screen_shader.setBool("force", false);
			screen_shader.setBool("GLITCH", false);
		}, 300);

		FlxFlicker.flicker(titleLogo, 0.5, 0.04, true, true, (flk) -> {
			FlxTween.tween(titleLogo, {x: 50, y: 50}, 2, {ease: FlxEase.quadInOut});
			for (i in 0...menuItems.length) {
				FlxTween.tween(menuItems.members[i], {alpha: 1}, 0.5 + (i * 0.5), {ease: FlxEase.quadInOut});
			}
			FlxTween.num(titleLogo.scale.x, titleLogo.scale.x * 0.45, 2, {
				ease: FlxEase.quadInOut,
				onComplete: (twn) -> {
					canControlle = true;
				}
			}, (_value) -> {
				titleLogo.scale.set(_value, _value);
				titleLogo.updateHitbox();
			});
		});
	}

	public function chooseOption(_index:Int):Void {
		FlxFlicker.flicker(menuItems.members[_index], 1, 0.04);
		FlxG.sound.play(Paths.sound('Generic_Select_2'));
		canControlle = false;
		Timer.delay(() -> {
			if (optionShit[_index].option != 'story_mode' && optionShit[_index].option != 'coming_soon') {
				FlxG.mouse.visible = false;
			}
			switch (optionShit[_index].option) {
				case 'story_mode': {openSubState(new StoryMenuSubState());}
				case 'freeplay': {MusicBeatState.switchState(new FreeplayState());}
				case 'credits': {MusicBeatState.switchState(new CreditsState());}
				case 'options': {LoadingState.loadAndSwitchState(new options.OptionsState());}
				case 'coming_soon': {
						FlxG.sound.play(Paths.sound('menu_Credit_noticesound'), 5);
						canControlle = true;
					}
			}
		}, 1000);
	}

	public override function closeSubState():Void {
		super.closeSubState();
		canControlle = true;
	}
}
