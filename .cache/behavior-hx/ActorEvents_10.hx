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



class ActorEvents_10 extends ActorScript
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
		
		/* ======================== When Creating ========================= */
		actor.growTo(10/100, 10/100, 0.01, Easing.linear);
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.0000000000000001, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(!(((_body.getAnimation() == "duckRight") || (_body.getAnimation() == "duckLeft"))))
				{
					actor.setScreenX((_body.getScreenX() + 15));
					actor.setScreenY((_body.getScreenY() - 25));
				}
				else
				{
					actor.setScreenX((_body.getScreenX() + 15));
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
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(5), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "pistol");
						actor.setAnimation("pistol");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(38), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "assaultRifle");
						actor.setAnimation("assaultRifle");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(40), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "assaultCarbine");
						actor.setAnimation("assaultCarbine");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(42), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "heavyRifle");
						actor.setAnimation("heavyRifle");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(55), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "revolver");
						actor.setAnimation("revolver");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(59), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "silencedPistol");
						actor.setAnimation("silencedPistol");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(57), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "magicPistol");
						actor.setAnimation("magicPistol");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(61), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "uzi");
						actor.setAnimation("uzi");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(53), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "shotgun");
						actor.setAnimation("shotgun");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(51), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "bullpup");
						actor.setAnimation("bullpup");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(69), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "none")))
				{
					if(isKeyDown("grab throw"))
					{
						event.otherActor.shout("_customEvent_" + "setCurrentAmmo");
						Engine.engine.setGameAttribute("currentWeapon", "minigun");
						actor.setAnimation("minigun");
						recycleActor(event.otherActor);
						_HoldThrowState = 0;
					}
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("grab throw", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && released)
			{
				if((_HoldThrowState == 0))
				{
					_HoldThrowState = 1;
				}
				else
				{
					if(!(((Engine.engine.getGameAttribute("currentWeapon") : String) == "none")))
					{
						actor.setAnimation("none");
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "pistol")))
						{
							createRecycledActor(getActorType(5), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "assaultRifle")))
						{
							createRecycledActor(getActorType(38), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "assaultCarbine")))
						{
							createRecycledActor(getActorType(40), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "heavyRifle")))
						{
							createRecycledActor(getActorType(42), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "revolver")))
						{
							createRecycledActor(getActorType(55), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "silencedPistol")))
						{
							createRecycledActor(getActorType(59), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "magicPistol")))
						{
							createRecycledActor(getActorType(57), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "uzi")))
						{
							createRecycledActor(getActorType(61), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "shotgun")))
						{
							createRecycledActor(getActorType(53), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "bullpup")))
						{
							createRecycledActor(getActorType(51), actor.getX(), actor.getY(), Script.FRONT);
						}
						if(((Engine.engine.getGameAttribute("currentWeapon") : String) == ("" + "minigun")))
						{
							createRecycledActor(getActorType(69), actor.getX(), actor.getY(), Script.FRONT);
						}
						getLastCreatedActor().setAngularVelocity(Utils.RAD * (500));
						getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 75);
						getLastCreatedActor().shout("_customEvent_" + "setAmmo");
						Engine.engine.setGameAttribute("currentWeaponAmmo", 0);
						Engine.engine.setGameAttribute("currentWeapon", "none");
					}
				}
			}
		});
		
		/* ============================ Click ============================= */
		addMouseReleasedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((((Engine.engine.getGameAttribute("currentWeapon") : String) == "pistol") || (((Engine.engine.getGameAttribute("currentWeapon") : String) == "pistol") || (((Engine.engine.getGameAttribute("currentWeapon") : String) == "magicPistol") || ((Engine.engine.getGameAttribute("currentWeapon") : String) == "revolver")))))
				{
					if(((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) > 0))
					{
						Engine.engine.setGameAttribute("isPlayerShooting", "yes");
						startShakingScreen(0.5 / 100, 0.1);
						Engine.engine.setGameAttribute("currentWeaponAmmo", ((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) - 1));
						createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 20), Script.FRONT);
						getLastCreatedActor().setAnimation("player");
						getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 500);
						_DistanceX = ((getScreenX() + getMouseX()) - getLastCreatedActor().getXCenter());
						_DistanceY = ((getScreenY() + getMouseY()) - getLastCreatedActor().getYCenter());
						getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
						runLater(1000 * 0.1, function(timeTask:TimedTask):Void
						{
							Engine.engine.setGameAttribute("isPlayerShooting", "no");
						}, actor);
					}
				}
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == "shotgun"))
				{
					if(((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) > 0))
					{
						Engine.engine.setGameAttribute("isPlayerShooting", "yes");
						Engine.engine.setGameAttribute("currentWeaponAmmo", ((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) - 1));
						for(index0 in 0...5)
						{
							startShakingScreen(0.5 / 100, 0.1);
							createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 20), Script.FRONT);
							getLastCreatedActor().setAnimation("shotgunPlayer");
							getLastCreatedActor().applyImpulseInDirection(((Utils.DEG * actor.getAngle()) + randomInt(-5, 5)), 300);
							_DistanceX = ((getScreenX() + getMouseX()) - getLastCreatedActor().getXCenter());
							_DistanceY = ((getScreenY() + getMouseY()) - getLastCreatedActor().getYCenter());
							getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
						}
						runLater(1000 * 0.45, function(timeTask:TimedTask):Void
						{
							Engine.engine.setGameAttribute("isPlayerShooting", "no");
						}, actor);
					}
				}
			}
		});
		
		/* ============================ Click ============================= */
		addMouseReleasedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == "silencedPistol"))
				{
					if(((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) > 0))
					{
						Engine.engine.setGameAttribute("isPlayerShooting", "yes");
						startShakingScreen(0.1 / 100, 0.1);
						Engine.engine.setGameAttribute("currentWeaponAmmo", ((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) - 1));
						createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 20), Script.FRONT);
						getLastCreatedActor().setAnimation("player");
						getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 500);
						_DistanceX = ((getScreenX() + getMouseX()) - getLastCreatedActor().getXCenter());
						_DistanceY = ((getScreenY() + getMouseY()) - getLastCreatedActor().getYCenter());
						runLater(1000 * 0.1, function(timeTask:TimedTask):Void
						{
							Engine.engine.setGameAttribute("isPlayerShooting", "no");
						}, actor);
						getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
					}
				}
			}
		});
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.2, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if((((Engine.engine.getGameAttribute("currentWeapon") : String) == "assaultRifle") || (((Engine.engine.getGameAttribute("currentWeapon") : String) == "heavyRifle") || (((Engine.engine.getGameAttribute("currentWeapon") : String) == "uzi") || (((Engine.engine.getGameAttribute("currentWeapon") : String) == "minigun") || ((Engine.engine.getGameAttribute("currentWeapon") : String) == "bullpup"))))))
				{
					if(isMouseDown())
					{
						if(((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) > 0))
						{
							Engine.engine.setGameAttribute("isPlayerShooting", "yes");
							startShakingScreen(0.5 / 100, 0.1);
							Engine.engine.setGameAttribute("currentWeaponAmmo", ((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) - 1));
							createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 20), Script.FRONT);
							getLastCreatedActor().setAnimation("player");
							getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 500);
							_DistanceX = ((getScreenX() + getMouseX()) - getLastCreatedActor().getXCenter());
							_DistanceY = ((getScreenY() + getMouseY()) - getLastCreatedActor().getYCenter());
							getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
						}
					}
					else
					{
						Engine.engine.setGameAttribute("isPlayerShooting", "no");
					}
				}
			}
		}, actor);
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 0.2, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				if(((Engine.engine.getGameAttribute("currentWeapon") : String) == "assaultCarbine"))
				{
					if(isMouseDown())
					{
						if(((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) > 0))
						{
							Engine.engine.setGameAttribute("isPlayerShooting", "yes");
							startShakingScreen(0.1 / 100, 0.1);
							Engine.engine.setGameAttribute("currentWeaponAmmo", ((Engine.engine.getGameAttribute("currentWeaponAmmo") : Float) - 1));
							createRecycledActor(getActorType(7), actor.getX(), (actor.getY() + 20), Script.FRONT);
							getLastCreatedActor().setAnimation("player");
							getLastCreatedActor().applyImpulseInDirection((Utils.DEG * actor.getAngle()), 500);
							_DistanceX = ((getScreenX() + getMouseX()) - getLastCreatedActor().getXCenter());
							_DistanceY = ((getScreenY() + getMouseY()) - getLastCreatedActor().getYCenter());
							getLastCreatedActor().setAngle(Utils.RAD * ((Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)) - 0)));
						}
					}
					else
					{
						Engine.engine.setGameAttribute("isPlayerShooting", "no");
					}
				}
			}
		}, actor);
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}