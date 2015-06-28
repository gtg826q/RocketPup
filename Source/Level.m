//
//  Level.m
//  RocketMolly
//
//  Created by Brittany Stewart on 3/7/15.
//

#import "Level.h"
#import "Obstacle.h"
#import "Goal.h"
#import "HighScoreData.h"

static const CGFloat firstObstaclePosition = 280.f;
static const CGFloat firstGoalPosition = 180.f;
static const CGFloat distanceBetweenObstacles = 240.f;
static const CGFloat distanceBetweenGoals = 120.f;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrdeHero,
    DrawingOrderGoal
};

@implementation Level {
    
    CCSprite *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCButton *_restartButton;
    BOOL _gameOver;
    CGFloat _scrollSpeed;
    NSArray *_grounds;
    NSTimeInterval _sinceTouch;
    NSMutableArray *_obstacles;
    NSMutableArray *_goals;
    NSInteger _points;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_congratsLabel;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    _grounds = @[_ground1, _ground2];
    _scrollSpeed = 80.f;
    for (CCNode *ground in _grounds) {
        // set collision txpe
        ground.physicsBody.collisionType = @"level";
        ground.zOrder = DrawingOrderGround;
    }
    
    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    // set collision txpe
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;
    _obstacles = [NSMutableArray array];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    _goals = [NSMutableArray array];
    [self spawnNewGoal];
    [self spawnNewGoal];
    [self spawnNewGoal];
}
- (void)update:(CCTime)delta {
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    for (CCNode *ground in _grounds) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    // clamp velocity
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
    
    _sinceTouch += delta;

    NSMutableArray *offScreenObstacles = nil;
    for (CCNode *obstacle in _obstacles) {
        CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
        CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
        if (obstacleScreenPosition.x < -obstacle.contentSize.width) {
            if (!offScreenObstacles) {
                offScreenObstacles = [NSMutableArray array];
            }
            [offScreenObstacles addObject:obstacle];
        }
    }
    for (CCNode *obstacleToRemove in offScreenObstacles) {
        [obstacleToRemove removeFromParent];
        [_obstacles removeObject:obstacleToRemove];
        // for each removed obstacle, add a new one
        [self spawnNewObstacle];
    }
    NSMutableArray *offScreenGoals = nil;
    for (CCNode *goal in _goals) {
        CGPoint goalWorldPosition = [_physicsNode convertToWorldSpace:goal.position];
        CGPoint goalScreenPosition = [self convertToNodeSpace:goalWorldPosition];
        if (goalScreenPosition.x < -goal.contentSize.width) {
            if (!offScreenGoals) {
                offScreenGoals = [NSMutableArray array];
            }
            [offScreenGoals addObject:goal];
        }
    }
    for (CCNode *goalToRemove in offScreenGoals) {
        [goalToRemove removeFromParent];
        [_goals removeObject:goalToRemove];
        // for each removed goal, add a new one
        [self spawnNewGoal];
    }
}
// Move hero on touch when not in game over state
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!_gameOver) {
        [_hero.physicsBody applyImpulse:ccp(0, 1000.f)];
        _sinceTouch = 0.f;
    }
}
// Display new obstacles at random positions
- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleXPosition = firstObstaclePosition;
    }
    Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
    obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
    [obstacle setupRandomPosition];
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    obstacle.zOrder = DrawingOrderPipes;
}
// Display new goals at random positions
- (void)spawnNewGoal {
    CCNode *previousGoal = [_goals lastObject];
    CGFloat previousGoalXPosition = previousGoal.position.x;
    if (!previousGoal) {
        // this is the first obstacle
        previousGoalXPosition = firstGoalPosition;
    }
    Goal *goal = (Goal *)[CCBReader load:@"Goal"];
    goal.position = ccp(previousGoalXPosition + distanceBetweenGoals, 0);
    [goal setupRandomGoalPosition];
    [_physicsNode addChild:goal];
    [_goals addObject:goal];
    goal.zOrder = DrawingOrderGoal;
}
// Collision detected; stop scrolling, display restart button, and run game over method
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    _scrollSpeed = 0;
    _restartButton.visible = TRUE;
    [self gameOver];
    return TRUE;
}
// Restart Game
- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}
// Game Over; display restart button and save high score
- (void)gameOver {
    if (!_gameOver) {
        NSLog(@"Game Over");
        _gameOver = TRUE;
        _restartButton.visible = TRUE;
        [_hero stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
        
        [HighScoreData sharedGameData].highScore = MAX(_points, [HighScoreData sharedGameData].highScore);
        
        [[HighScoreData sharedGameData] save];
    }
}
// Collision detected with goal; point scored, update label, current score, and high score if needed
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    _points++;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)_points];
    if (_points > [HighScoreData sharedGameData].highScore && [HighScoreData sharedGameData].highScore != 0) {
        _congratsLabel.visible = TRUE;
        [self scheduleOnce:@selector(resetLabel) delay:10];
    }
    return TRUE;
}
- (void)resetLabel {
    _congratsLabel.visible = FALSE;
}
@end
