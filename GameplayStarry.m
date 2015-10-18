////
////  GameplayStarry.m
////  Constellations
////
////  Created by Jessica Jiang on 7/8/14.
////  Copyright (c) 2014 Apportable. All rights reserved.
////
//

//TODO: IMPLEMENT WINNING METHOD (timer, lives, stroke count, what?)

#import "GameplayStarry.h"
#import "StarStarry.h"
#import "RatchetSparkles.h"
#import "Replay.h"


@implementation GameplayStarry{
    CGSize scene;
    CCLabelTTF *_timer;
    CCLabelTTF *_scoreLabel;
    RatchetSparkles *_explain;
    int strokes;
    float time;
    int count;
    
}

#pragma mark - onEnter

-(void)onEnter {
    [super onEnter];
    
    time = 30;
    
    scene = [self boundingBox].size;
    
    //initializes the stroke count
    _timer = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"Time:"] fontName:@"GillSans" fontSize:20];
    _timer.position = ccp(0.85*scene.width, 0.9*scene.height);
    _timer.visible = true;
    _timer.opacity = 1;
    [self addChild:_timer];
    
    //initializes the score label
    _scoreLabel = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"Score:"] fontName:@"GillSans" fontSize:20];
    _scoreLabel.position = ccp(0.5*scene.width, 0.90*scene.height);
    _scoreLabel.visible = true;
    _scoreLabel.opacity = 1;
    [self addChild:_scoreLabel];
    
    //initializes explanation
    _explain = [[RatchetSparkles alloc]initWithString:[NSString stringWithFormat:@"The clock is ticking!"] fontName:@"GillSans" fontSize:20];
    _explain.position = ccp(0.5*scene.width, 0.5*scene.height);
    _explain.visible = true;
    _explain.opacity = 1;
    [self addChild:_explain];
}

-(void) endAttempt:(BOOL) completed
{
    [super endAttempt: completed];
    //strokes++;
}

-(void)randomlyGenerateStars:(int) num{
    for(int i = 0; i < num; i++){
        if(i % 3 == 0){
            [self generateRandStar:[CCColor greenColor]];
        } else if (i %3 == 1) {
            [self generateRandStar:[CCColor yellowColor]];
        } else {
            [self generateRandStar:[CCColor orangeColor]];
        }
        
    }
    self.numStars = num;
}

-(void) starsAtTouchEnd:(StarStarry *)star withCompletion:(BOOL)completed
{
    if(completed)
    {
        [self generateRandStar:star.color];
        [self removeStar:star];
    }
    else
    {
        [super starsAtTouchEnd:star withCompletion:completed];
    }
}

- (void)showTime
{
    int timeInt = (int) time;
    _timer.string = [NSString stringWithFormat:@"Time: %d", timeInt];
    _timer.visible = true;
}

- (void)showScore
{
    
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", [self score]];
    _scoreLabel.visible = true;
}

-(void)endGame
{
    [super endGame];
    [Replay level:1];
}

-(void)mainmenu {
    CCScene *mainmenuScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainmenuScene];
}

-(BOOL)winCondition
{
    // write winning condition.
    return time <= 0;
}

#pragma mark - update
// do all the collision checking
- (void)update:(CCTime)delta
{
    //TODO: Detect when stars touch lines.
    
    [super update:delta];
    [self showTime];
    [self showScore];
    
    
    if (count <60) {
        count += 1;
    }
    else if (count == 60){
        [self randomlyGenerateStars:30];
        count += 1;
    }
    else
    {
        time -= delta;
    }
    
}
@end
