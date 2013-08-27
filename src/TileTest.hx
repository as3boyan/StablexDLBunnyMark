package ;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import ru.stablex.sxdl.SxObject;

/**
 * @author Joshua Granick
 * @author Philippe Elsass
 * @author AS3Boyan
 */
class TileTest extends SxObject
{
	var tf:TextField;	
	var numBunnies:Int;
	var incBunnies:Int;
	var maxX:Int;
	var minX:Int;
	var maxY:Int;
	var minY:Int;
	var gravity:Float;
	var pirate:SxObject;
	var bunnies:Array<Bunny>;
	var mouse_down:Bool;

	public function new() 
	{
		super();
		
		gravity = 0.5;
		incBunnies = 10;
		numBunnies = 500;
		
		pirate = new SxObject();
		pirate.tile = BunnyMark.sxStage.getTile("img/pirate.png");
		pirate.scaleX = pirate.scaleY = Env.height / 768;
		addChild(pirate);
		
		bunnies = new Array();
		
		var bunny:Bunny;
		for (i in 0...numBunnies)
		{
			bunny = new Bunny();
			bunny.tile = BunnyMark.sxStage.getTile("img/wabbit_alpha.png");
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scaleX = bunny.scaleY = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			addChild(bunny);
			
			bunnies.push(bunny);
		}
		
		createCounter();
		
		Lib.current.addEventListener(Event.ENTER_FRAME, enterFrame);
		Lib.current.stage.addEventListener(Event.RESIZE, stage_resize);
		stage_resize(null);
		
		mouse_down = false;
	}
	
	private function enterFrame(e:Event):Void 
	{
		if (mouse_down)
		{
			counter_click();
		}
		
		var t = Lib.getTimer();
		pirate.x = Std.int((Env.width - pirate.width) * (0.5 + 0.5 * Math.sin(t / 3000)));
		pirate.y = Std.int(Env.height - pirate.height + 70 - 30 * Math.sin(t / 100));
		
		var bunny:Bunny = null;
		
		 for (i in 0...numBunnies)
		{
			bunny = bunnies[i];
			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;
			bunny.alpha = 0.3 + 0.7 * bunny.y / maxY;
			
			if (bunny.x > maxX)
			{
				bunny.speedX *= -1;
				bunny.x = maxX;
			}
			else if (bunny.x < minX)
			{
				bunny.speedX *= -1;
				bunny.x = minX;
			}
			if (bunny.y > maxY)
			{
				bunny.speedY *= -0.8;
				bunny.y = maxY;
				if (Math.random() > 0.5) bunny.speedY -= 3 + Math.random() * 4;
			} 
			else if (bunny.y < minY)
			{
				bunny.speedY = 0;
				bunny.y = minY;
			}
		}
	}
	
	function createCounter()
	{
		var format = new TextFormat("_sans", 20, 0, true);
		format.align = TextFormatAlign.RIGHT;
		
		tf = new TextField();
		tf.selectable = false;
		tf.defaultTextFormat = format;
		tf.width = 200;
		tf.height = 60;
		tf.x = maxX - tf.width - 10;
		tf.y = 10;
		Lib.current.addChild(tf);

		tf.addEventListener(MouseEvent.MOUSE_DOWN, function (e):Void { mouse_down = true; } );
		Lib.current.addEventListener(MouseEvent.MOUSE_UP, function (e):Void { mouse_down = false; } );
	}
	
	function counter_click()
	{
		if (numBunnies >= 1500) incBunnies = 250;
		var more = numBunnies + incBunnies;

		var bunny; 
		for (i in numBunnies...more)
		{
			bunny = new Bunny();
			bunny.tile = BunnyMark.sxStage.getTile("img/wabbit_alpha.png");
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scaleX = bunny.scaleY = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			bunnies.push (bunny);
			
			addChild(bunny);
		}
		numBunnies = more;

		stage_resize(null);
	}
	
	function stage_resize(e) 
	{
		maxX = Env.width;
		maxY = Env.height;
		tf.text = "Bunnies:\n" + numBunnies;
		tf.x = maxX - tf.width - 10;
	}
	
}