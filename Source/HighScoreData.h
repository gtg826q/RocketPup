//
//  HighScoreData.h
//  RocketMolly
//
//  Created by Brittany Stewart on 3/17/15.
//

#import <Foundation/Foundation.h>

@interface HighScoreData : NSObject <NSCoding>

@property (assign, nonatomic) int highScore;

+(instancetype)sharedGameData;
-(void)save;
@end

