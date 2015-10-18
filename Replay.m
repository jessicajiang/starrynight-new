//
//  Replay.m
//  StarryNight
//
//  Created by Jessica Jiang on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Replay.h"
#import "GameplayBase.h"

static int score;
static int level;

@implementation Replay {
    CCLabelTTF *_highscore;
    CCLabelTTF *_scoreLabel;
}

- (void) onEnter {
    [super onEnter];
    self.userInteractionEnabled = TRUE;
    
    
    if(level == 1 || level == 2){
        _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
        [self updateHighScores:score];
    }else if (level == 3){
        _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
        [self updateHighScores:score];
    }
    
    
    NSLog(@"%d",[self highscore]);
    _highscore.string = [NSString stringWithFormat:@"%d", [self highscore]];
    
    CCNode* temp = [CCBReader load:@"BackGroundStar"];
    [self addChild:temp];
    [self twinkle:temp];
    
}


-(int)highscore
{
    NSString* directory = [NSString stringWithFormat:@"HighScore%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"GameMode"]];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:directory]!=nil)
    {
        return [[NSUserDefaults standardUserDefaults] integerForKey:directory];
    }
    else
    {
        return 0;
    }
}

-(void)updateHighScores:(int) i
{
    
    NSString* directory = [NSString stringWithFormat:@"HighScore%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"GameMode"]];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:directory]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:directory];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if(score>[[NSUserDefaults standardUserDefaults] integerForKey:directory])
    {
        
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:directory];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


-(void)updateTimeScores:(int) i
{
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Time"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if(score>[[NSUserDefaults standardUserDefaults] integerForKey:@"Time"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"Time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)replay{
    if (level == 1) {
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    } else if (level == 2) {
        CCScene *susScene = [CCBReader loadAsScene:@"HeapOStars"];
        [[CCDirector sharedDirector] replaceScene:susScene];
    } else if (level == 3) {
        CCScene *getShafted = [CCBReader loadAsScene:@"MenageATrois"];
        [[CCDirector sharedDirector] replaceScene:getShafted];
    }
    
    
}

-(void)mainmenu {
    CCScene *mainmenuScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainmenuScene];
}

+ (void)setScore:(int)s {
    score = s;
}

+ (void)level:(int) l {
    level = l;
}


//here on out it's just twinkle
-(void)twinkle:(CCNode*) mahStar
{
    if ( self.parent.contentSize.width == 0 || self.parent.contentSize.height == 0)
    {
        return;
    }
    
    int randomX = arc4random()%((int)self.parent.contentSize.width);
    int randomY = arc4random()%((int)self.parent.contentSize.height);
    mahStar.position = ccp(randomX,randomY);
    
    [self fadeIn:mahStar];
}

-(void)fadeIn:(CCNode*) mahStar
{
    if(mahStar.opacity<=1)
    {
        mahStar.opacity+=.1;
        [self performSelector:@selector(fadeIn:) withObject:mahStar afterDelay:0.05f];
    }
    else
    {
        
        [self fadeOut:mahStar];
    }
}

-(void)fadeOut:(CCNode*) mahStar
{
    if(mahStar.opacity>=0)
    {
        
        mahStar.opacity-=.1;
        [self performSelector:@selector(fadeOut:) withObject:mahStar afterDelay:0.05f];
    }
    else
    {
        
        [self twinkle:mahStar];
    }
}



@end
