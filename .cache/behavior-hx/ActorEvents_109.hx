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



class ActorEvents_109 extends ActorScript
{
	public var _myBody:Actor;
	public var _hasBody:Bool;
	public var _myArm:Actor;
	public var _myHead:Actor;
	public var _mode:String;
	public var _DistanceX:Float;
	public var _DistanceY:Float;
	public var _player:Actor;
	public var _facing:String;
	public var _deathYtype:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_playerSpotted():Void
	{
		_mode = "attack";
		_myHead.shout("_customEvent_" + "updateModeAttack");
		_myArm.shout("_customEvent_" + "updateModeAttack");
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("myBody", "_myBody");
		nameMap.set("hasBody", "_hasBody");
		_hasBody = false;
		nameMap.set("myArm", "_myArm");
		nameMap.set("myHead", "_myHead");
		nameMap.set("mode", "_mode");
		_mode = "";
		nameMap.set("Distance X", "_DistanceX");
		_DistanceX = 0.0;
		nameMap.set("Distance Y", "_DistanceY");
		_DistanceY = 0.0;
		nameMap.set("player", "_player");
		nameMap.set("facing", "_facing");
		_facing = "";
		nameMap.set("deathYtype", "_deathYtype");
		_deathYtype = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.growTo(175/100, 175/100, 0.01, Easing.linear);
		
		/* ======================== When Creating ========================= */
		actor.setXVelocity(0);
		_facing = "right";
		
		/* ======================== When Creating ========================= */
		actor.makeAlwaysSimulate();
		
		/* ======================== When Creating ========================= */
		_mode = "patrol";
		
		/* ======================== When Creating ========================= */
		_hasBody = false;
		for(actorOfType in getActorsOfType(getActorType(1)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_player = actorOfType;
			}
		}
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(7), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.otherActor.getAnimation() == "player"))
				{
					if((actor.getYCenter() >= event.otherActor.getYCenter()))
					{
						_deathYtype = 1;
					}
					if((event.otherActor.getYCenter() >= actor.getYCenter()))
					{
						_deathYtype = 2;
					}
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
				if((event.otherActor.getAnimation() == "shotgunPlayer"))
				{
					_deathYtype = 3;
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(32), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setXVelocity(10);
				actor.growTo(-150/100, 150/100, 0.01, Easing.linear);
				_facing = "right";
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(1), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!(((event.otherActor.getAnimation() == "rollRight") || (event.otherActor.getAnimation() == "rollLeft"))))
				{
					if(((actor.getX() + -5) > _player.getX()))
					{
						recycleActor(_myArm);
						recycleActor(_myHead);
						recycleActor(actor);
					}
					else
					{
						runLater(1000 * 1, function(timeTask:TimedTask):Void
						{
							if(actor.isAlive())
							{
								_mode = "attack";
								_myHead.shout("_customEvent_" + "updateModeAttack");
								_myArm.shout("_customEvent_" + "updateModeAttack");
							}
						}, actor);
					}
				}
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addWhenKilledListener(actor, function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				createRecycledActor(getActorType(44), actor.getX(), (actor.getY() - 30), Script.FRONT);
				if((_deathYtype == 1))
				{
					getLastCreatedActor().setAnimation("1");
				}
				if((_deathYtype == 2))
				{
					getLastCreatedActor().setAnimation("2");
				}
				if((_deathYtype == 3))
				{
					getLastCreatedActor().setAnimation("3");
				}
				getLastCreatedActor().growTo(125/100, 125/100, 0.01, Easing.linear);
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(34), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				actor.setXVelocity(-10);
				actor.growTo(150/100, 150/100, 0.01, Easing.linear);
				_facing = "left";
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(5), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(40), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(38), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(42), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(51), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(57), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(55), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(53), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(59), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(61), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((event.otherActor.getXVelocity() >= 6) || (event.otherActor.getXVelocity() <= -6)))
				{
					recycleActor(_myArm);
					recycleActor(_myHead);
					recycleActor(actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(14), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_myHead = event.otherActor;
				_myHead.shout("_customEvent_" + "updateModePatrol");
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(16), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((hasValue(_myArm))))
				{
					_myArm = event.otherActor;
					_myArm.shout("_customEvent_" + "updateModePatrol");
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(63), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((hasValue(_myArm))))
				{
					_myArm = event.otherActor;
					_myArm.shout("_customEvent_" + "updateModePatrol");
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(65), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((hasValue(_myArm))))
				{
					_myArm = event.otherActor;
					_myArm.shout("_customEvent_" + "updateModePatrol");
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(67), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((hasValue(_myArm))))
				{
					_myArm = event.otherActor;
					_myArm.shout("_customEvent_" + "updateModePatrol");
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(71), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(!((hasValue(_myArm))))
				{
					_myArm = event.otherActor;
					_myArm.shout("_customEvent_" + "updateModePatrol");
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((actor.getXVelocity() > 5) || (actor.getXVelocity() < -5)))
				{
					if(!((actor.getAnimation() == "walk")))
					{
						actor.setAnimation("walk");
					}
				}
				else
				{
					if(!((actor.getAnimation() == "stand")))
					{
						actor.setAnimation("stand");
					}
				}
			}
		});
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.5, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if((((_facing == "left") && (actor.getX() > _player.getX())) || ((_facing == "right") && (_player.getX() > actor.getX()))))
				{
					if((_mode == "patrol"))
					{
						createRecycledActor(getActorType(36), actor.getX(), (actor.getY() + 0), Script.FRONT);
						getLastCreatedActor().setAnimation("enemy");
						_DistanceX = ((getScreenX() + _player.getScreenX()) - getLastCreatedActor().getXCenter());
						_DistanceY = ((getScreenY() + _player.getScreenY()) - getLastCreatedActor().getYCenter());
						getLastCreatedActor().applyImpulseInDirection(Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)), 50);
					}
				}
			}
		}, actor);
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}