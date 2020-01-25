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



class ActorEvents_71 extends ActorScript
{
	public var _myBody:Actor;
	public var _hasBody:Bool;
	public var _player:Actor;
	public var _DistanceX:Float;
	public var _DistanceY:Float;
	public var _currentWeapon:String;
	public var _mode:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_updateModePatrol():Void
	{
		_mode = "patrol";
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_updateModeAttack():Void
	{
		_mode = "attack";
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("myBody", "_myBody");
		nameMap.set("hasBody", "_hasBody");
		_hasBody = false;
		nameMap.set("player", "_player");
		nameMap.set("Distance X", "_DistanceX");
		_DistanceX = 0.0;
		nameMap.set("Distance Y", "_DistanceY");
		_DistanceY = 0.0;
		nameMap.set("currentWeapon", "_currentWeapon");
		_currentWeapon = "";
		nameMap.set("mode", "_mode");
		_mode = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.makeAlwaysSimulate();
		
		/* ======================== When Creating ========================= */
		_hasBody = false;
		for(actorOfType in getActorsOfType(getActorType(1)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_player = actorOfType;
			}
		}
		
		/* ======================== When Creating ========================= */
		_mode = "patrol";
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(12), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_myBody = event.otherActor;
				_hasBody = true;
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addWhenKilledListener(actor, function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				createRecycledActor(getActorType(69), actor.getX(), actor.getY(), Script.FRONT);
			}
		});
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.000000000000001, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(_hasBody)
				{
					if((_mode == "attack"))
					{
						if((_player.getScreenX() < actor.getScreenX()))
						{
							actor.growTo(-100/100, -100/100, 0.01, Easing.linear);
						}
						else
						{
							actor.growTo(-100/100, 100/100, 0.01, Easing.linear);
						}
						_DistanceX = ((getScreenX() + _player.getScreenX()) - actor.getXCenter());
						_DistanceY = ((getScreenY() + _player.getScreenY()) - actor.getYCenter());
						actor.setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
						actor.setScreenX((_myBody.getScreenX() + -60));
						actor.setScreenY((_myBody.getScreenY() - 25));
					}
					if((_mode == "patrol"))
					{
						actor.setAngle(Utils.RAD * (0));
						actor.setScreenX((_myBody.getScreenX() + -60));
						actor.setScreenY((_myBody.getScreenY() - 25));
					}
				}
			}
		}, actor);
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.2, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(((Engine.engine.getGameAttribute("timeFlow") : Float) == 10))
				{
					if((_mode == "attack"))
					{
						createRecycledActor(getActorType(7), (actor.getX() + 60), (actor.getY() + 30), Script.FRONT);
						actor.setAnimation("enemy");
						getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 100);
						_DistanceX = ((getScreenX() + _player.getX()) - getLastCreatedActor().getXCenter());
						_DistanceY = ((getScreenY() + _player.getY()) - getLastCreatedActor().getYCenter());
						getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
					}
				}
			}
		}, actor);
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 1, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(((Engine.engine.getGameAttribute("timeFlow") : Float) == 50))
				{
					if((_mode == "attack"))
					{
						createRecycledActor(getActorType(7), (actor.getX() + 60), (actor.getY() + 30), Script.FRONT);
						actor.setAnimation("enemy");
						getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 100);
						_DistanceX = ((getScreenX() + _player.getX()) - getLastCreatedActor().getXCenter());
						_DistanceY = ((getScreenY() + _player.getY()) - getLastCreatedActor().getYCenter());
						getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
					}
				}
			}
		}, actor);
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}