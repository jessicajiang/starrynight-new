//
//  GameplayBase.h
//  twinkle
//
//  Created by Jessica Jiang on 10/9/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "StarStarry.h"

@interface GameplayBase : CCSprite

@property (nonatomic) int numStars;
@property (nonatomic, assign) NSInteger highscore;
@property (nonatomic, strong) NSString *type;
@property float time;
@property float count;
//@property (nonatomic, assign) int level;

-(void) endAttempt:(BOOL)completed;
-(BOOL) winCondition;
-(BOOL) loseCondition;
-(void) endGame;
-(void) update:(CCTime)delta;
-(void) randomlyGenerateStars:(int) num;
-(StarStarry *) generateRandStar:(CCColor*)color;
-(StarStarry *) generateStarAt: (CGPoint) pt withColor: (CCColor*) color;
-(void) starsAtTouchEnd:(StarStarry*)star withCompletion:(BOOL)completed;
-(void) removeStar:(StarStarry*)star;

-(int) score;
-(int) numStars;

@end
