//
//  StarStarry.h
//  StarryNight
//
//  Created by Jessica Jiang on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"


//const float HITBOX = 15.0;

@interface StarStarry : CCSprite

@property(nonatomic) CGPoint position;
@property(nonatomic, assign)BOOL isAlive;
@property(nonatomic) NSString* marker;


-(id)initWithColor:(CCColor *)color;
-(void) stopStar;
-(void) restartStar;
-(CCColor *) color;

/*
 CCActionMoveTo *drop = [CCActionMoveTo actionWithDuration: 1 position:ccp(self.boundingBox.size.width*.5, self.boundingBox.size.height *.5)];
 
 CCActionEaseElasticOut *bounce = [CCActionEaseElasticOut actionWithAction:drop period: .66];
 
 CCActionDelay *delay = [CCActionEaseBounce actionWithDuration: 2];
 
 CCActionMoveTo *dropBack = [CCActionMoveTo actionWithDuration: 1 position: ccp(self.boundingBox.size.width*.5, self.boundingBox.size.height*1.5)];
 
 CCActionEaseElasticOut *bounceOut = [CCActionEaseElasticOut actionWithAction: dropBack period: .66];
 
 [self addChild: starryStar];
 
 [starryStar runAction: [CCActionSequence actions: bounce,delay,bounceOut,nil]];
 */


@end


//http://clipartist.info/clipart/clipartsy/cool_star-2020px.png
//https://www.makegameswith.us/academy/art/object/yay-candies
