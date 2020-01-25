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



class Design_3_3_playerBodyAnimationMAnager extends ActorScript
{
	public var _body:Actor;
	public var _body2:Actor;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("body", "_body");
		nameMap.set("body2", "_body2");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		for(actorOfType in getActorsOfType(getActorType(3)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_body = actorOfType;
			}
		}
		for(actorOfType in getActorsOfType(getActorType(10)))
		{
			if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
				_body2 = actorOfType;
			}
		}
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((actor.getXVelocity() <= 5) && (actor.getXVelocity() >= -5)))
				{
					if(((Engine.engine.getGameAttribute("currentAnimation") : String) == "duck"))
					{
						actor.setAnimation("duckRight");
						if(((actor.getAnimation() == "rollRight") || (getMouseX() > actor.getScreenX())))
						{
							actor.setAnimation("duckRight");
						}
						if(((actor.getAnimation() == "rollLeft") || (actor.getScreenX() > getMouseX())))
						{
							actor.setAnimation("duckLeft");
						}
					}
					if(((Engine.engine.getGameAttribute("currentAnimation") : String) == "stand"))
					{
						actor.setAnimation("idleRight");
						if(((actor.getAnimation() == "walkRight") || (getMouseX() > actor.getScreenX())))
						{
							actor.setAnimation("idleRight");
							if(!(((actor.getYVelocity() > -3) && (actor.getYVelocity() < 3))))
							{
								actor.setAnimation("jumpRight");
							}
						}
						if(((actor.getAnimation() == "walkLeft") || (actor.getScreenX() > getMouseX())))
						{
							actor.setAnimation("idleLeft");
							if(!(((actor.getYVelocity() > -3) && (actor.getYVelocity() < 3))))
							{
								actor.setAnimation("jumpLeft");
							}
						}
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(((actor.getXVelocity() <= 5) && (actor.getXVelocity() >= -5))))
				{
					if(((Engine.engine.getGameAttribute("currentAnimation") : String) == "duck"))
					{
						if((actor.getXVelocity() <= 0))
						{
							actor.setAnimation("rollLeft");
						}
						if((actor.getXVelocity() >= 1))
						{
							actor.setAnimation("rollRight");
						}
					}
					if(((Engine.engine.getGameAttribute("currentAnimation") : String) == "stand"))
					{
						if((actor.getXVelocity() <= 0))
						{
							actor.setAnimation("walkLeft");
							if(!(((actor.getYVelocity() > -3) && (actor.getYVelocity() < 3))))
							{
								actor.setAnimation("jumpLeft");
							}
						}
						if((actor.getXVelocity() >= 1))
						{
							actor.setAnimation("walkRight");
							if(!(((actor.getYVelocity() > -3) && (actor.getYVelocity() < 3))))
							{
								actor.setAnimation("jumpRight");
							}
						}
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((((Engine.engine.getGameAttribute("currentAnimation") : String) == "duck") && !(((actor.getXVelocity() >= -5) && (actor.getXVelocity() <= 5)))))
				{
					_body.setAnimation("roll");
					_body2.setAnimation("roll");
				}
				else
				{
					_body.setAnimation("none");
					if(((Engine.engine.getGameAttribute("isPlayerShooting") : String) == "no"))
					{
						_body2.setAnimation((Engine.engine.getGameAttribute("currentWeapon") : String));
					}
					else
					{
						_body2.setAnimation((((Engine.engine.getGameAttribute("currentWeapon") : String)) + ("shoot")));
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}