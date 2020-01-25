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



class ActorEvents_3 extends ActorScript
{
	public var _body:Actor;
	public var _HoldThrowState:Float;
	public var _DistanceX:Float;
	public var _DistanceY:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("body", "_body");
		nameMap.set("HoldThrowState", "_HoldThrowState");
		_HoldThrowState = 0.0;
		nameMap.set("Distance X", "_DistanceX");
		_DistanceX = 0.0;
		nameMap.set("Distance Y", "_DistanceY");
		_DistanceY = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		for(actorOfType in getActorsOfType(getActorType(1)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_body = actorOfType;
			}
		}
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.0000000000000001, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(!(((_body.getAnimation() == "duckRight") || (_body.getAnimation() == "duckLeft"))))
				{
					actor.setScreenX((_body.getScreenX() + 5));
					actor.setScreenY((_body.getScreenY() - 22));
				}
				else
				{
					actor.setScreenX((_body.getScreenX() + 5));
					actor.setScreenY((_body.getScreenY() - -10));
				}
				if((getMouseX() < actor.getScreenX()))
				{
					actor.growTo(100/100, -100/100, 0.01, Easing.linear);
				}
				else
				{
					actor.growTo(100/100, 100/100, 0.01, Easing.linear);
				}
			}
		}, actor);
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}