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



class Design_2_2_JumpandRunMovement extends ActorScript
{
	public var _LeftControl:String;
	public var _RightControl:String;
	public var _Move:Float;
	public var _UseControls:Bool;
	public var _JumpControl:String;
	public var _Jump:Bool;
	public var _OnGround:Bool;
	public var _MaximumRunningSpeed:Float;
	public var _JumpingForce:Float;
	public var _RunRightAnimation:String;
	public var _RunLeftAnimation:String;
	public var _IdleRightAnimation:String;
	public var _IdleLeftAnimation:String;
	public var _Jumping:Bool;
	public var _JumpRightAnimation:String;
	public var _JumpLeftAnimation:String;
	public var _FacingLeft:Bool;
	public var _JumpAnimationWhenFalling:Bool;
	public var _JumpHigher:Bool;
	public var _WasJump:Bool;
	public var _VariableJump:Bool;
	public var _VariableJumpDuration:Float;
	public var _RunningForce:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveLeft():Void
	{
		_Move = -1;
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveRight():Void
	{
		_Move = 1;
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Jump():Void
	{
		_Jump = true;
		_JumpHigher = true;
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Left Control", "_LeftControl");
		nameMap.set("Right Control", "_RightControl");
		nameMap.set("Move", "_Move");
		_Move = 0.0;
		nameMap.set("Use Controls", "_UseControls");
		_UseControls = true;
		nameMap.set("Jump Control", "_JumpControl");
		nameMap.set("Jump", "_Jump");
		_Jump = false;
		nameMap.set("On Ground", "_OnGround");
		_OnGround = false;
		nameMap.set("Maximum Running Speed", "_MaximumRunningSpeed");
		_MaximumRunningSpeed = 15.0;
		nameMap.set("Jumping Force", "_JumpingForce");
		_JumpingForce = 25.0;
		nameMap.set("Run Right Animation", "_RunRightAnimation");
		nameMap.set("Run Left Animation", "_RunLeftAnimation");
		nameMap.set("Idle Right Animation", "_IdleRightAnimation");
		nameMap.set("Idle Left Animation", "_IdleLeftAnimation");
		nameMap.set("Jumping", "_Jumping");
		_Jumping = false;
		nameMap.set("Jump Right Animation", "_JumpRightAnimation");
		nameMap.set("Jump Left Animation", "_JumpLeftAnimation");
		nameMap.set("Facing Left", "_FacingLeft");
		_FacingLeft = false;
		nameMap.set("Jump Animation When Falling", "_JumpAnimationWhenFalling");
		_JumpAnimationWhenFalling = false;
		nameMap.set("Jump Higher", "_JumpHigher");
		_JumpHigher = false;
		nameMap.set("Was Jump", "_WasJump");
		_WasJump = false;
		nameMap.set("Variable Jump", "_VariableJump");
		_VariableJump = false;
		nameMap.set("Variable Jump Duration", "_VariableJumpDuration");
		_VariableJumpDuration = 0.2;
		nameMap.set("Running Force", "_RunningForce");
		_RunningForce = 50.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_UseControls)
				{
					_Move = (asNumber(isKeyDown(_RightControl)) - asNumber(isKeyDown(_LeftControl)));
					_Jump = isKeyPressed(_JumpControl);
				}
				if(!(_Move == 0))
				{
					actor.push(_Move, 0, _RunningForce);
				}
				if((Math.abs(actor.getXVelocity()) > _MaximumRunningSpeed))
				{
					actor.setXVelocity(((Math.abs(actor.getXVelocity()) / actor.getXVelocity()) * _MaximumRunningSpeed));
				}
				if((_Jump && _OnGround))
				{
					_Jumping = true;
					if(_VariableJump)
					{
						_JumpHigher = true;
						runLater(1000 * _VariableJumpDuration, function(timeTask:TimedTask):Void
						{
							_JumpHigher = false;
							if(!(_Jumping))
							{
								_JumpHigher = false;
								timeTask.repeats = false;
								return;
							}
						}, actor);
					}
					else
					{
						actor.applyImpulse(0, -1, _JumpingForce);
					}
				}
				if((_JumpHigher && isKeyDown(_JumpControl)))
				{
					actor.applyImpulse(0, -1, (_JumpingForce / getStepSize()));
				}
				if((_Move == -1))
				{
					_FacingLeft = true;
				}
				else if((_Move == 1))
				{
					_FacingLeft = false;
				}
				if(((_Jumping && (actor.getYVelocity() < 0)) || (_JumpAnimationWhenFalling && !(_OnGround))))
				{
					if(_FacingLeft)
					{
						actor.setAnimation(_JumpLeftAnimation);
					}
					else
					{
						actor.setAnimation(_JumpRightAnimation);
					}
				}
				else if((!(_Move == 0) && _OnGround))
				{
					if(_FacingLeft)
					{
						actor.setAnimation(_RunLeftAnimation);
					}
					else
					{
						actor.setAnimation(_RunRightAnimation);
					}
				}
				else
				{
					if(_FacingLeft)
					{
						actor.setAnimation(_IdleLeftAnimation);
					}
					else
					{
						actor.setAnimation(_IdleRightAnimation);
					}
				}
				_Move = 0;
				_WasJump = _Jump;
				_Jump = false;
				_OnGround = false;
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("down", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && released)
			{
				Engine.engine.setGameAttribute("currentAnimation", ("" + "stand"));
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("down", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				Engine.engine.setGameAttribute("currentAnimation", ("" + "duck"));
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((event.thisFromBottom && !(event.thisCollidedWithSensor)))
				{
					_OnGround = true;
				}
				if((_OnGround && !(_WasJump)))
				{
					_Jumping = false;
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}