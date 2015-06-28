//
//  HighScoreData.m
//  RocketMolly
//
//  Created by Brittany Stewart on 3/17/15.
//
//  Class for high score with methods to save and load the high score to disk

#import <Foundation/Foundation.h>
#import "HighScoreData.h"

@implementation HighScoreData : NSObject {


}

static NSString* const SSGameDataHighScoreKey = @"highScore";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.highScore forKey: SSGameDataHighScoreKey];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeIntegerForKey: SSGameDataHighScoreKey];
    }
    return self;
}

+ (instancetype)sharedGameData; {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"highscoredata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [HighScoreData filePath]];
    if (decodedData) {
        HighScoreData* HighScoreData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return HighScoreData;
    }
    
    return [[HighScoreData alloc] init];
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[HighScoreData filePath] atomically:YES];
}

@end