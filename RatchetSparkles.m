//
//  RatchetSparkles.m
//  StarryNight
//
//  Created by Jessica Jiang on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RatchetSparkles.h"

@implementation RatchetSparkles
{
    int life;
    CGFloat opacityChange;
    CGFloat heightChange;
}

-(id) initWithString:(NSString *)string
{
    return [super initWithString:string fontName:@"Gill Sans" fontSize:20];
}

-(id) initWithInt:(int) number
{
    return [self initWithString:[NSString stringWithFormat: @"+%d", number]];
}

-(id) initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size
{
    return [super initWithString:string fontName:name fontSize:size];
}

-(void) onEnter
{
    [super onEnter];
    life = 60;
    self.opacity = 1;
    opacityChange = self.opacity/life;
    heightChange = 60.0/life;
}

-(void) setLife: (int) newLife
{
    life = newLife;
    opacityChange = self.opacity/life;
    heightChange = 60.0/life;
}

-(void) update:(CCTime)delta
{
    if ( life <= 0 )
    {
        [self.parent removeChild: self];
        return;
    }
    CGPoint pos = self.position;
    self.position = ccp( pos.x, pos.y + heightChange);
    self.opacity -= opacityChange;
    life--;
}

@end
