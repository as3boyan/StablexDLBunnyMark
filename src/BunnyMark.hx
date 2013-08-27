package ;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import openfl.Assets;
import ru.stablex.sxdl.SxStage;

/**
 * @author Joshua Granick
 * @author Philippe Elsass
 * @author AS3Boyan
 */
class BunnyMark extends Sprite
{
	var bg:Background;
	var fps:FPS;
	static public var sxStage : SxStage;

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		
		#if flash
		stage.quality = StageQuality.LOW;
		#end
		
		sxStage = new SxStage();
		sxStage.addSprite("img/pirate.png");
		sxStage.addSprite("img/wabbit_alpha.png");
		sxStage.lockSprites();
		
		Env.setup();
		stage.addEventListener(Event.RESIZE, resize);
		
		//bg = new Background();
		//bg.texture = Assets.getBitmapData("img/grass.png");
		//bg.cols = 8;
		//bg.rows = 12;
		//bg.x = -50;
		//bg.y = -50;
		//bg.setSize(Env.width + 100, Env.height + 100);
		//addChild(bg);

		sxStage.addChild (new TileTest ());

		fps = new FPS();
		addChild(fps);
		fps.addEventListener(MouseEvent.CLICK, toggleFPS);
		
		Lib.current.addEventListener(Event.ENTER_FRAME, function(e:Event){
            sxStage.render(Lib.current.graphics);
        });
		
	}
	
	function toggleFPS(e)
	{
		stage.frameRate = 90 - stage.frameRate;
	}
	
	private function resize(e:Event):Void 
	{
		if (bg == null) return;

		//if (Env.width > Env.height)
		//{
			//bg.cols = 12;
			//bg.rows = 8;
		//}
		//else
		//{
			//bg.cols = 8;
			//bg.rows = 12;
		//}
		//bg.setSize(Env.width + 100, Env.height + 100);
	}
	
	public static function main()
	{
		#if iphone
		haxe.Timer.delay(create, 10);
		#else
		create();
		#end
	}

	private static function create()
	{
		Lib.current.addChild (new BunnyMark());
	}
	
}