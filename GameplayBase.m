//
//  GameplayBase.m
//  StarryNight
//
//  Created by Jessica Jiang on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameplayBase.h"
#import "StarStarry.h"
#import "Replay.h"
#import "RatchetSparkles.h"

//static int score;
//static int level;
@implementation GameplayBase
{
    int score;
    //CGSize scene;
    
    NSMutableArray *listostars;
    NSMutableArray *touchedStars;
    NSMutableArray *deadStars;
    
    CCDrawNode *_cabinet; //ehehe because it's not a drawer
    CCDrawNode *_finalWardrobe;
    
    float circRad;
    int lineThickness;
    
    CGSize _scene;
    //CCLabelTTF *_scoreLabel;
    //int score;
    
    CCSprite *_background;
    float opacityLevel;
    
    CCScene *replay;
    
    float spawnPeriod;
    
    BOOL touching;
}

/*
 -(void)getLevel{
 level = self.level;
 }
 */

#pragma mark - onEnter

-(void)onEnter {
    [super onEnter];
    self.userInteractionEnabled = TRUE;
    
    CCNode* temp = [CCBReader load:@"BackGroundStar"];
    [self addChild:temp];
    [self twinkle:temp];
    
    self.opacity = 0;
    
    //initializing the dynamic draw node
    _cabinet = [[CCDrawNode alloc]init];
    _cabinet.position = (ccp(0,0));
    [self addChild:_cabinet];
    
    //initializing static draw node
    _finalWardrobe = [[CCDrawNode alloc]init];
    _finalWardrobe.position = (ccp(0,0));
    [self addChild:_finalWardrobe];
    
    _scene = self.boundingBox.size;
    
    listostars = [[NSMutableArray alloc] init];
    touchedStars = [[NSMutableArray alloc] init];
    deadStars = [[NSMutableArray alloc]init];
    
    circRad = 20;
    //self.numStars = 24;
    lineThickness = 5;
    score = 0;
    //spawnPeriod = .7;
    
    //[self randomlyGenerateStars: self.numStars];
    
    
    //_scoreLabel = [[CCLabelTTF alloc]initWithString:[NSString stringWithFormat:@"Score: %d", score] fontName:@"Helvetica" fontSize:5];
    //_scoreLabel.position = ccp(0.7*_scene.width, 0.2*_scene.height);
    //_scoreLabel.visible = true;
    //_scoreLabel.opacity = 0.45;
    //[self addChild:_scoreLabel];
    
    //MASA WAS HERE :D
    
    opacityLevel = 1.0/10;
    
    /*
     CCActionMoveTo *drop = [CCActionMoveTo actionWithDuration: 1 position:ccp(self.boundingBox.size.width*.5, self.boundingBox.size.height *.5)];
     CCActionEaseElasticOut *bounce = [CCActionEaseElasticOut actionWithAction:drop period: .66];
     CCActionDelay *delay = [CCActionEaseBounce actionWithDuration: 2];
     CCActionMoveTo *dropBack = [CCActionMoveTo actionWithDuration: 1 position: ccp(self.boundingBox.size.width*.5, self.boundingBox.size.height*1.5)];
     CCActionEaseElasticOut *bounceOut = [CCActionEaseElasticOut actionWithAction: dropBack period: .66];
     [self addChild: wavePopUp];
     [wavePopUp runAction: [CCActionSequence actions: bounce,delay,bounceOut,nil]];
     */
    
}

-(void)onExit
{
    [super onExit];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
#pragma mark - touchBegan

-(void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event{
    touching = YES;
    
    //reads location of the touch
    CCLOG(@"Received a touch");
    CGPoint touchLoc = [touch locationInNode:self];
    CCLOG(@"Location at x: %f at y: %f", touchLoc.x, touchLoc.y);
    
    for ( StarStarry *star in listostars )
    {
        if ( !star.isAlive )
            continue;
        double distanceToStar = [self distanceBetweenPoint:star.position andPoint:touchLoc];
        CCLOG(@"Distance: %f", distanceToStar);
        
        if ( distanceToStar < circRad && [touchedStars count] == 0 )
        {
            // do something.
            [_finalWardrobe drawDot:star.position radius:circRad color:[star color]];
            CCLOG(@"Hi. You were close. Thanks.");
            [star stopStar];
            [touchedStars addObject:star];
            score += [touchedStars count];
            
            [self sparkleScore: star.position];
            return;
        }
    }
}

#pragma mark - touchMoved

-(void) touchMoved:(CCTouch *)touch withEvent:(UIEvent *)event
{
    if ( [touchedStars count] == 0 )
    {
        return;
    }
    
    CGPoint touchLoc = [touch locationInNode:self];
    
    //draws the lines
    [_cabinet clear];
    [_cabinet drawSegmentFrom:((StarStarry*)[touchedStars objectAtIndex:[touchedStars count] - 1]).position to:touchLoc radius:lineThickness color:[CCColor cyanColor]];
    [_cabinet drawDot:touchLoc radius:circRad color:[CCColor cyanColor]];
    
    
    //checks if you manage to successfully touch a star
    for ( StarStarry *star in listostars )
    {
        if ( !star.isAlive )
            continue;
        double distanceToStar = [self distanceBetweenPoint:star.position andPoint:touchLoc];
        //CCLOG(@"Distance: %f", distanceToStar);
        //prints out and calculates the distance from a touch to the closest star
        
        if ( distanceToStar < circRad && ![touchedStars containsObject:star])
        {
            _background.opacity += opacityLevel;
            //CCLOG(@"Hi. You were close. Thanks.");
            
            if ( ((StarStarry*)[touchedStars objectAtIndex:0]).marker != ((StarStarry*)star).marker )
            {
                [self endAttempt:false];
                return;
            }
            
            [_finalWardrobe drawDot:star.position radius:circRad color:[star color]];
            [star stopStar];
            [touchedStars addObject:star];
            //draw the segment, the start of it being from the first touched star to the second touched star
            [_finalWardrobe drawSegmentFrom:((StarStarry*)[touchedStars objectAtIndex:[touchedStars count] - 2]).position to:((StarStarry*)[touchedStars objectAtIndex:[touchedStars count] - 1]).position radius:lineThickness color:[star color]];
            
            [self sparkleScore: star.position];
            
            score += [touchedStars count];
            return;
        }
    }
}

-(void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event {
    touching = NO;
    [self endAttempt:[touchedStars count] > 1];
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(UIEvent *)event {
    [self endAttempt:[touchedStars count] > 1];
    touching = NO;
}

-(void) sparkleScore: (CGPoint) position
{
    RatchetSparkles *_sparkles = [[RatchetSparkles alloc]initWithInt:[touchedStars count]];
    _sparkles.position = position;
    _sparkles.visible = true;
    _sparkles.opacity = 1;
    [self addChild:_sparkles];
}



-(void) endAttempt:(BOOL) completed {
    if (!completed)
        score -= [touchedStars count] * ([touchedStars count] + 1) / 2;
    [_cabinet clear];
    [_finalWardrobe clear];
    
    
    for ( StarStarry* star in touchedStars )
    {
        [self starsAtTouchEnd:star withCompletion:completed];
    }
    [touchedStars removeAllObjects];
}

-(void) starsAtTouchEnd:(StarStarry*) star withCompletion:(BOOL)completed
{
    // to be implemented by game mode
    // default is to restart stars:
    [star restartStar];
}

-(void) removeStar:(StarStarry*) star
{
    //[self removeChild:star];
    star.isAlive = false;
    [listostars removeObject:star];
    [deadStars addObject:star];
    self.numStars--;
}

//yay distance formula for use in drawing stars
-(double)distanceBetweenPoint: (CGPoint) point1 andPoint: (CGPoint) point2
{
    double dx = (point2.x-point1.x);
    double dy = (point2.y-point1.y);
    double dist = dx*dx + dy*dy;
    return sqrt(dist);
}

//yay for randomly generating stars.
-(void)randomlyGenerateStars:(int) num{
    for(int i = 0; i < num; i++){
        if(i % 2 == 0){
            [self generateRandStar:[CCColor greenColor]];
        }else{
            [self generateRandStar:[CCColor yellowColor]];
        }
        
    }
    
    self.numStars = num;
}

#pragma mark - generateRandStar

// generates a single random star with a given color, of either yellow or green
-(StarStarry *) generateRandStar:(CCColor*) color
{
    CGPoint pointOfStar = ccp(arc4random() %(int)(0.9*[self parent].contentSizeInPoints.width)+0.05*[self parent].contentSizeInPoints.width, arc4random() % (int)(0.9*[self parent].contentSizeInPoints.height)+0.05*[self parent].contentSizeInPoints.height);
    return [self generateStarAt:pointOfStar withColor: color];
}

-(StarStarry *) generateStarAt: (CGPoint) pt withColor: (CCColor*) color
{
    StarStarry *star;
    if ( color == nil )
        star =[[StarStarry alloc] init];
    else
        star = [[StarStarry alloc] initWithColor:color];
    
    star.position = pt;
    [self addChild:star];
    [listostars addObject:star];
    self.numStars++;
    return star;
}

-(int) score
{
    return score;
}


/*
 - (void)showScore
 {
 _scoreLabel.string = [NSString stringWithFormat:@"Score: %d", score];
 _scoreLabel.visible = true;
 
 }
 */



-(void) endGame
{
    [self endAttempt:false];
    for ( StarStarry* star in listostars )
    {
        [self removeChild:star];
    }
    [listostars removeAllObjects];
    self.numStars = 0;
}

-(BOOL) winCondition
{
    // to be decided by game mode.
    return false;
}

-(BOOL) loseCondition
{
    // to be decided by game mode.
    return false;
}


//TODO: change winGame and loseGame to just "end of game"
-(void) winGame
{
    
    [self endGame];
    replay = [CCBReader loadAsScene:@"Replay"];
    [Replay setScore:score];
    [[CCDirector sharedDirector] replaceScene: (CCScene *)replay];
}

-(void) loseGame
{
    [self endGame];
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Replay"]]; // TODO go to losing scene.
}

-(void) update:(CCTime)delta
{
    //[self showScore];
    
    if (!touching && _background.opacity > 0) _background.opacity = MAX(_background.opacity -= delta*3,0);
    
    
    if ( [self winCondition] )
    {
        [self winGame];
    }
    if ( [self loseCondition] )
    {
        [self loseGame];
    }
    [self starGarbage];
}

-(void)starGarbage
{
    for ( int i = 0; i < [deadStars count]; i++ )
    {
        StarStarry *star = [deadStars objectAtIndex:i];
        if (star.opacity <= 0) {
            [self removeChild:star];
            [deadStars removeObjectAtIndex:i];
        }
    }
    
}


-(void)twinkle:(CCNode*) mahStar
{
    // just to make sure twinkling doesn't happen after game ends. or other strange occurences.
    /*
     if ( self.parent.contentSize.width == 0 || self.parent.contentSize.height == 0)
     {
     return;
     }
     */
    
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



//-(int) numStars
//{
//    NSUInteger uisize = listostars.count;
//    int size = uisize;
//
//    return size;
//}


@end
