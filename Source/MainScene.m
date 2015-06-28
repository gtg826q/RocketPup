//
//  MainScene.m
//  RocketMolly
//
//  Created by Brittany Stewart on 3/7/15.
//

#import "MainScene.h"
#import "HighScoreData.h"

@implementation MainScene {
    CCButton *play;
    CCLabelTTF *_highScoreLabel;
}

- (void)didLoadFromCCB {

    [self updateHighscore];
    
}

- (void)play {
    CCScene *Level= [CCBReader loadAsScene:@"Level"];
    [[CCDirector sharedDirector] replaceScene:Level];
}

//Display Current High Score
- (void)updateHighscore {
    _highScoreLabel.string = [NSString stringWithFormat:@"High Score: %i", [HighScoreData sharedGameData].highScore];
}

@end
