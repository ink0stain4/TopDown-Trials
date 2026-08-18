init_airborne_properties(0.15, 0.1)
iFrame_dur = 10

DamageDebuff = EnemyDef.DamageDebuff
EnemyDamage = EnemyDef.EnemyDamage
AttackRange = EnemyDef.AttackRange
AttackRate = EnemyDef.AttackRate
AggroRange = EnemyDef.AggroRange
TrackingRange = (AggroRange * 1.3)
MaxHealth = EnemyDef.MaxHealth
ExpAmount = EnemyDef.ExpAmount
Weight = EnemyDef.Weight
MoveSpeed = EnemyDef.MoveSpeed

sprite_index = EnemyDef.EnemySprite

Health = MaxHealth
previousHealth = Health
invulnerable = false
hurt = false

facing = -1 // -1 left, 1 right

enemy_id = EnemyDef.EnemyID
state = EnemyState.ROAMING
action = EnemyAction.NONE

attackTimer = 0

punchDirection = 0
punchLanded = false
punchRecoverFrames = 30 // however many frames are left in the punch anim after the hit frame 

LostAggroPause = 90; // frames to stand still after losing the player, tune to taste

StuckCheckInterval = 30;	// frames between "did we actually move?" checks
StuckMinDistance = 2;		// minimum px expected to travel in that window
ArriveThreshold = 4;		// how close counts as "arrived"
RoamRadius = 48;			// how far a roam destination can be picked

hasPath = false;
currentPath = [];
pathNodeIndex = 0;
repathTimer = 0;
RepathInterval = 30;

moveGoalX = x;
moveGoalY = y;

moveStuckTimer = StuckCheckInterval;
moveStuckCheckX = x;
moveStuckCheckY = y;

roamTargetX = x;
roamTargetY = y;
speed = 0
direction = 0

healthBar = healthbar_create(MaxHealth)



