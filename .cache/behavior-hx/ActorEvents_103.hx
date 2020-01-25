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



class ActorEvents_103 extends ActorScript
{
	public var _DistanceX:Float;
	public var _DistanceY:Float;
	public var _mode:String;
	public var _facing:String;
	public var _hasBody:Bool;
	public var _player:Actor;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Distance X", "_DistanceX");
		_DistanceX = 0.0;
		nameMap.set("Distance Y", "_DistanceY");
		_DistanceY = 0.0;
		nameMap.set("mode", "_mode");
		_mode = "";
		nameMap.set("facing", "_facing");
		_facing = "";
		nameMap.set("hasBody", "_hasBody");
		_hasBody = false;
		nameMap.set("player", "_player");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_hasBody = false;
		for(actorOfType in getActorsOfType(getActorType(1)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_player = actorOfType;
			}
		}
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.5, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getAnimation() == "alive"))
				{
					createRecycledActor(getActorType(36), actor.getX(), (actor.getY() + 0), Script.FRONT);
					getLastCreatedActor().setAnimation("enemy");
					_DistanceX = ((getScreenX() + _player.getScreenX()) - getLastCreatedActor().getXCenter());
					_DistanceY = ((getScreenY() + _player.getScreenY()) - getLastCreatedActor().getYCenter());
					getLastCreatedActor().applyImpulseInDirection(Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)), 50);
				}
			}
		}, actor);
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(7), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((event.otherActor.getAnimation() == "enemy")))
				{
					actor.setAnimation("dead");
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}