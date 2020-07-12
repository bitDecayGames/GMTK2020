package entities;

import flixel.FlxBasic;
import haxe.macro.Expr.Case;
import openfl.Assets;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import actions.Actions;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import fx.Blood;

using extensions.FlxObjectExt;

class Player extends FlxSprite {
	// WALK
	var WALK_MAX_SPEED:Float = 150.0;
	var WALK_ACCELERATION:Float = 400.0;
	var WALK_DECELERATION:Float = 600.0;
	// RUN
	var RUN_MAX_SPEED:Float = 300.0;
	var RUN_ACCELERATION:Float = 600.0;
	// DIVE
	var DIVE_MAX_SPEED:Float = 800.0;
	var DIVE_ACCELERATION:Float = 2000.0;
	var DIVE_DECELERATION:Float = 2000.0;
	var DIVE_RECOVERY_TIME:Float = 0.5;
	// BONK
	var BONK_MAX_SPEED = 75.0;
	var BONK_DECELERATION = 150.0;
	var BONK_MAX_TIME:Float = 1;

	var control = new Actions();

	var divingState = NotDiving;
	var diveRecoveringTime = 0.0;

	var bonked = false;
	var bonkTime = 0.0;

	var currentSpeed = 0.0;

	var facingAngle:Int = 0;

	// ########## FROM BRAWNFIRE ##########
    // TODO(JF): Potentially add based on brawnfire
	// public var playerGroup:PlayerGroup;
	// public var hitboxMgr:HitboxManager;

	var inControl = false;

	var waitForFinish = false;
	var invincible = 0.0;
	var _invincibleMaxTime = 1.0;

    // TODO(JF) Hurt box crap
	var hurtboxSize = new FlxPoint(24, 24);
	// var hitboxes:AttackHitboxes;

	public var groundType = "grass";

	public var blood = new Blood();

	// ########## FROM BRAWNFIRE ##########

    // TODO(JF): Potentially add based on brawnfire
	// public function new(playerGroup:PlayerGroup, hitboxMgr:HitboxManager) {
    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);
        // TODO(JF): Potentially add based on brawnfire
		// this.playerGroup = playerGroup;
		// this.hitboxMgr = hitboxMgr;

		loadGraphic(AssetPaths.WalkRun__png, true, 42, 84);

        // an extra -2 on the y to help account for empty space at the bottom of the sprites
        // TODO(JF): hurtbox offsets
		offset.set(width / 2 - hurtboxSize.x / 2, height / 2 - hurtboxSize.y / 2);
		setSize(hurtboxSize.x, hurtboxSize.y);

		animation.add("idle", [0], 5);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 12);
		animation.add("run", [8, 9, 10, 11], 10);
		animation.add("divingAccel", [16, 17], 20, false);
		animation.add("divingDecel", [18, 19, 20, 21, 22], 10, false);
		animation.add("bonked", [24, 25, 26], 6, false);

		animation.callback = (name, frameNumber, frameIndex) -> {
			switch name {
				case "idle":
				case "walk":
					if (frameNumber == 2 || frameNumber == 6) {
						switch groundType {
							case "grass":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepGrass);
							case "concrete":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepConcrete);
							case "metal":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepMetal);
							default:
								throw "No ground type. SOMETHING HAS GONE WRONG!! : " + groundType;
						}
					}
				case "run":
					if (frameNumber == 0 || frameNumber == 2) {
						switch groundType {
							case "grass":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepGrass);
							case "concrete":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepConcreteRun);
							case "metal":
								FmodManager.PlaySoundOneShot(FmodSFX.FootstepMetalRun);
							default:
								throw "No ground type. SOMETHING HAS GONE WRONG!! : " + groundType;
						}
					}
				case "divingAccel":
					if (frameNumber == 0) {
						FmodManager.PlaySoundOneShot(FmodSFX.Dive);
					}
				case "divingDecel":
					if (frameNumber == 0) {
						FmodManager.PlaySoundOneShot(FmodSFX.DiveLand);
						FlxG.camera.shake(0.01, 0.1);
					}
				case "bonked":
					if (frameNumber == 0) {
						FmodManager.PlaySoundOneShot(FmodSFX.DiveBonk);
						FlxG.camera.shake(0.0075, 0.25);
					}
				default:
					throw "No animation case found. SOMETHING HAS GONE WRONG!! : " + name;
			}
		};

		// TODO(JF): This may need to be added to the two load methods above.
        // TODO(JF): Add hitbox stuff here
		// hitboxes = new AttackHitboxes(this);
		// hitboxes.register(hitboxMgr.addPlayerHitbox, "punch", 2, [new HitboxLocation(13, 15, 13, 0)]);

		// animation.callback = hitboxes.animCallback;
		// animation.finishCallback = tagFinish;

		health = 3;
	}

    // TODO(JF): finish callback animation thing
	// function tagFinish(name:String) {
	// 	waitForFinish = false;
	// 	hitboxes.finishAnimation();
	// }

	public function extras():Array<FlxBasic> {
		return [blood];
	}

	override public function update(delta:Float):Void {
        super.update(delta);
        // TODO(JF): Potentially add based on brawnfire
		// playerGroup.update(delta);
		// hitboxes.update(delta);

		// ########## FROM BRAWNFIRE ##########
		if (waitForFinish) return;

		if (invincible > 0) invincible -= delta;
		// ########## FROM BRAWNFIRE ##########

		updateMovement(delta);
		// trace('Player (x,y): (${this.x},${this.y}');

		blood.setPosition(this.x, this.y);

		if (FlxG.keys.justPressed.T) {
			var middle = getMidpoint();
			blood.setPosition(middle.x, middle.y);
			blood.blast(90);
		}
	}

	private function updateMovement(delta:Float) {
		if (diveRecoveringTime > 0) divingRest(delta); 

		if (bonked)
		{
			bonking(delta);

			return;
		}

		if (divingState == NotDiving) {
			// whether to accelerate or decelerate;
			var accelerate = false;
			
			// TODO(JF): Adjust facing based on actual sprites and animations
			var newFacing = 0;
			var newAngle:Int = 0;
			if (control.up.check()) {
				newFacing = newFacing | FlxObject.UP;
				newAngle = -90;

				if (control.left.check()) {
					newAngle -= 45;
					newFacing = newFacing | FlxObject.LEFT;
				} else if (control.right.check()) {
					newAngle += 45;
					newFacing = newFacing | FlxObject.RIGHT;
				}

				accelerate = true;

			} else if (control.down.check()) {
				newFacing = FlxObject.DOWN;
				newAngle = 90;

				if (control.left.check()) {
					newAngle += 45;
					newFacing = newFacing | FlxObject.LEFT;
				} else if (control.right.check()) {
					newAngle -= 45;
					newFacing = newFacing | FlxObject.RIGHT;
				}

				accelerate = true;

			} else if (control.left.check()) {
				newAngle = 180;
				newFacing = newFacing | FlxObject.LEFT;

				accelerate = true;

			} else if (control.right.check()) {
				newAngle = 0;
				newFacing = newFacing | FlxObject.RIGHT;

				accelerate = true;
			}

			if (accelerate) {
				facingAngle = newAngle;
				facing = newFacing;

				// If direction pushed (accelerate) and dive pushed then dive and stop other movement
				if (control.dive.check() && diveRecoveringTime == 0.0) {
					if (divingState == NotDiving) {
						animation.play("divingAccel");
					}
					divingState = DivingAccel;

				} else if (control.run.check()) {
					// adjust current speed based on RUN_ACCELERATION of time
					currentSpeed += delta * RUN_ACCELERATION;

					if (currentSpeed > RUN_MAX_SPEED) currentSpeed = RUN_MAX_SPEED;

					animation.play("run");
				} else {
					// adjust current speed based on WALK_ACCELERATION of time
					currentSpeed += delta * WALK_ACCELERATION;

					if (currentSpeed > WALK_MAX_SPEED) currentSpeed = WALK_MAX_SPEED;

					animation.play("walk");
				}
			} else {
				currentSpeed -= delta * WALK_DECELERATION;

				if (currentSpeed < 0) {
					currentSpeed = 0;

					animation.play("idle");
				}
				else {
					animation.play("walk");
				}
			}
		} else {
			switch divingState {
				case DivingAccel:
					divingAccel(delta);

				case DivingDecel:
					divingDecel(delta);

				default:
					throw "Diving state not handled. SOMETHING HAS GONE WRONG!! : " + divingState;
			}
		}

		velocity.set(currentSpeed, 0);

		velocity.rotate(FlxPoint.weak(0, 0), facingAngle);

		// Sprite angle is pointing up which is 90 degrees off
		angle = facingAngle + 90;
	}


	private function divingAccel(delta:Float) {
		currentSpeed += delta * DIVE_ACCELERATION;

		if (currentSpeed > DIVE_MAX_SPEED) {
			currentSpeed = DIVE_MAX_SPEED;
			animation.play("divingDecel");
			animation.finishCallback = (name) -> {
				if (name == "divingDecel") {
					divingState = NotDiving;
					divingRest(delta);
					}
				};
			divingState = DivingDecel;
		}
	}

	private function divingDecel(delta:Float) {
		currentSpeed -= delta * DIVE_DECELERATION;

		if (currentSpeed < RUN_MAX_SPEED) {
			currentSpeed = RUN_MAX_SPEED;
		}
	}

	private function divingRest(delta:Float) {
		diveRecoveringTime += delta;

		if (diveRecoveringTime > DIVE_RECOVERY_TIME) {
			diveRecoveringTime = 0.0;
		}
	}

	public function attemptBonk() {
		if (divingState != NotDiving) {
			divingState = NotDiving;
			bonked = true;
		}
	}

	private function bonking(delta:Float){
		if (bonkTime == 0.0) {
			bonkTime += delta;

			currentSpeed = BONK_MAX_SPEED;

			animation.play("bonked");
		}
		else {
			bonkTime += delta;
			currentSpeed -= delta * BONK_DECELERATION;

			if (currentSpeed < 0) {
				currentSpeed = 0;
			}
		}

		velocity.set(currentSpeed, 0);
		var bonkAngle = (facingAngle + 180) % 360;
		velocity.rotate(FlxPoint.weak(0, 0), bonkAngle);

		if (bonkTime > BONK_MAX_TIME) {
			animation.play("idle");
			currentSpeed = 0;
			bonkTime = 0.0;
			bonked = false;
		}
	}

	// ########## FROM BRAWNFIRE ##########

    // TODO(JF): Add logic for getting hit by cars
	// public function getHit(direction:FlxVector, force:Float = 1) {
	// 	if (invincible <= 0) {
	// 		SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieHit);
	// 		SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MachoManDamage);
	// 		velocity.add(direction.x * force, direction.y * force);
	// 		animation.play("fall_" + animationDirection(direction.x));
	// 		velocity.set(0, 0);
	// 		waitForFinish = true;
	// 		invincible = _invincibleMaxTime;
	// 		FlxSpriteUtil.flicker(this, _invincibleMaxTime, 0.1);
	// 	}
	// }

    // TODO(JF): Potentially use for dive / get hit direction
	// public function getDiveDir():FlxPoint {
	// 	var throwDirX = 0;
	// 	var throwDirY = 0;
	// 	// If facing not set, use flipX
	// 	if (facing == FlxObject.NONE) {
	// 		if (flipX) {
	// 			throwDirX = -1;
	// 		} else {
	// 			throwDirX = 1;
	// 		}
	// 		// Otherwise rely on facing
	// 	} else {
	// 		if (facing & FlxObject.LEFT != 0) {
	// 			throwDirX = -1;
	// 		}
	// 		if (facing & FlxObject.RIGHT != 0) {
	// 			throwDirX = 1;
	// 		}
	// 	}
	// }

	// 	// Always check up/down
	// 	if (facing & FlxObject.UP != 0) {
	// 		throwDirY = -1;
	// 	}
	// 	if (facing & FlxObject.DOWN != 0) {
	// 		throwDirY = 1;
	// 	}

	// 	return new FlxVector(throwDirX, throwDirY).normalize();
	// }

    // TODO(JF): Possibly used when getting hit
	// private function animationDirection(hitDirX:Float):String {
	// 	var toTheLeft = hitDirX > 0;
	// 	var facingLeft = flipX;
	// 	return (toTheLeft && facingLeft) || (!toTheLeft && !facingLeft) ? "left" : "right";
	// }

	// ########## FROM BRAWNFIRE ##########
}

enum DiveState {
	NotDiving;
	DivingAccel;
	DivingDecel;
}
