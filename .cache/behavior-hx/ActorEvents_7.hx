package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.graphics.ScaleMode;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Config;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.motion.*;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_7 extends ActorScript
{
	public var _outOfCannon:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("outOfCannon", "_outOfCannon");
		_outOfCannon = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_outOfCannon = false;
		actor.growTo(200/100, 150/100, 0, Easing.linear);
		
		/* ======================= After N seconds ======================== */
		runLater(1000 * 0.1, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getAnimation() == "shotgunPlayer"))
				{
					actor.setAnimation("player");
				}
			}
		}, actor);
		
		/* ======================= After N seconds ======================== */
		runLater(1000 * 0.00000001, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				_outOfCannon = true;
			}
		}, actor);
		
		/* ======================= After N seconds ======================== */
		runLater(1000 * 20, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				recycleActor(actor);
			}
		}, actor);
		
		/* ======================= After N seconds ======================== */
		runLater(1000 * 1, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getXVelocity() == 0))
				{
					recycleActor(actor);
				}
			}
		}, actor);
		
		/* ======================== Specific Actor ======================== */
		addActorPositionListener(actor, function(enteredScreen:Bool, exitedScreen:Bool, enteredScene:Bool, exitedScene:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && exitedScreen)
			{
				recycleActor(actor);
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(_outOfCannon)
				{
					recycleActor(actor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}