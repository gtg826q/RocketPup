//
//  Goal.m
//  RocketMolly
//
//  Created by Brittany Stewart on 2/28/15.
//
// Setup random positions for goals and collision detection for point scoring
#import "Goal.h"


@implementation Goal {
CCNode *_goalPoint;
}

- (void)setupRandomGoalPosition {
    // value between 0.f and 1.f
    int smallest = 1;
    int largest = 13;

    CGFloat random = smallest + arc4random() % (largest+1-smallest);
    _goalPoint.position = ccp(_goalPoint.position.x, -random);
    NSLog(@"Value of x = %f", _goalPoint.position.x);
    NSLog(@"Value of y = %f", _goalPoint.position.y);
    

    
    //return random;
}
- (void)didLoadFromCCB {
    _goalPoint.physicsBody.collisionType = @"goal";
    _goalPoint.physicsBody.sensor = TRUE;
}
@end
