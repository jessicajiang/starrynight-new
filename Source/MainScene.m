#import "MainScene.h"


@implementation MainScene

- (void)play {
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"one" forKey:@"GameMode"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"]; //Gameplay is supposed to be GameplayStarry
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

/*
 - (void)threecolors {
 [[NSUserDefaults standardUserDefaults] setObject:@"two" forKey:@"GameMode"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 CCScene *threestarScene = [CCBReader loadAsScene:@"HeapOStars"];
 [[CCDirector sharedDirector] replaceScene:threestarScene];
 }
 
 - (void)thirdMode {
 [[NSUserDefaults standardUserDefaults] setObject:@"three" forKey:@"GameMode"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 CCScene *somethingScene = [CCBReader loadAsScene:@"MenageATrois"];
 [[CCDirector sharedDirector] replaceScene:somethingScene];
 }
 
 
 - (void)invisible {
 CCScene *tutorial = [CCBReader loadAsScene:@"Quote"]; //Gameplay is supposed to be GameplayStarry
 [[CCDirector sharedDirector] replaceScene:tutorial];
 }
 */

//brainstorm:
/*
 so
 basically there are going to be two game modes:
 gameplay starry (?) (set number of stars, given one minute, two colors?)
 clear the screen (going to be spawning x number of stars, only y number of stars are going to be on the screen at a time, least amount of time possible, *ensure that x and y are always even numbers at the end of the game? let's make it two colors for now)
 number of moves
 
 powerups?
 
 */

@end
