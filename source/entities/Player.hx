package entities;

import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import actions.Actions;
import flixel.math.FlxPoint;

class Player extends FlxSprite {
    // TODO(JF): Potentially add based on brawnfire
	// public var playerGroup:PlayerGroup;
	// public var hitboxMgr:HitboxManager;

	var inControl = false;
	var control = new Actions();

	var speed = 80;
	var waitForFinish = false;
	var invincible = 0.0;
	var _invincibleMaxTime = 1.0;

    // TODO(JF) Hurt box crap
	var hurtboxSize = new FlxPoint(20, 4);
	// var hitboxes:AttackHitboxes;

    // TODO(JF): Potentially add based on brawnfire
	// public function new(playerGroup:PlayerGroup, hitboxMgr:HitboxManager) {
    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);
        // TODO(JF): Potentially add based on brawnfire
		// this.playerGroup = playerGroup;
		// this.hitboxMgr = hitboxMgr;

		loadGraphic(AssetPaths.PlayerImage__JPG, true, 256, 256);

        // an extra -2 on the y to help account for empty space at the bottom of the sprites
        // TODO(JF): hurtbox offsets
		// offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
		// setSize(hurtboxSize.x, hurtboxSize.y);

		setFacingFlip(FlxObject.UP | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		setFacingFlip(FlxObject.UP | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.DOWN | FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.LEFT, true, false);

        // TODO(JF): add animations har
		// animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 5);

        // TODO(JF): Add hitbox stuff here
		// hitboxes = new AttackHitboxes(this);
		// hitboxes.register(hitboxMgr.addPlayerHitbox, "punch", 2, [new HitboxLocation(13, 15, 13, 0)]);

		// animation.callback = hitboxes.animCallback;
		// animation.finishCallback = tagFinish;
	}

    // TODO(JF): finish callback animation thing
	// function tagFinish(name:String) {
	// 	waitForFinish = false;
	// 	hitboxes.finishAnimation();
	// }

	override public function update(delta:Float):Void {
        super.update(delta);
        // TODO(JF): Potentially add based on brawnfire
		// playerGroup.update(delta);
		// hitboxes.update(delta);

		if (waitForFinish) {
			return;
		}
		if (invincible > 0) {
			invincible -= delta;
		}

		// determine our velocity based on angle and speed
		velocity.set(speed, 0);

        // TODO(JF): Adjust facing based on actual sprites and animations
		var newFacing = 0;
		var newAngle:Float = 0;
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
		} else if (control.left.check()) {
			newAngle = 180;
			newFacing = newFacing | FlxObject.LEFT;
		} else if (control.right.check()) {
			newAngle = 0;
			newFacing = newFacing | FlxObject.RIGHT;
		} else {
			// no keys pressed, don't move
			velocity.set(0, 0);
		}

        // TODO(JF): Fill with dive information
		// if (control.attack.check()) {
		// 	// Filler punch controls
		// 	if (playerGroup.activelyCarrying) {
		// 		velocity.set(0, 0);
		// 		playerGroup.throwThing();
		// 	} else {
		// 		animation.play("punch");
		// 		waitForFinish = true;
		// 		velocity.set(0, 0);
		// 	}
		// 	return;
		// }

		facing = newFacing;

		velocity.rotate(FlxPoint.weak(0, 0), newAngle);
	}

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
	// public function getThrowDir():FlxPoint {
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
}
