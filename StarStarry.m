//
//  StarStarry.m
//  StarryNight
//
//  Created by Jessica Jiang on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StarStarry.h"


@implementation StarStarry{
    float angle;
    float defaultSpeed;
    float speed;
    float angSpeed;
    float sideTolerance;
    
    CCColor *_color;
    float scale;
    
    BOOL starting;
    float opacityDec;
    float scaleInc;
    
    int vertFrames;
    int horiFrames;
    
}

-(id)init
{
    self = [super initWithImageNamed:@"Assets/whitestar.png"];
    self.isAlive = false;
    starting = true;
    self.opacity = 0;
    
    angle = arc4random() % 360;
    defaultSpeed = 0.8;
    speed = defaultSpeed;
    //angSpeed = 5;
    angSpeed = arc4random() % 10;
    //while (angSpeed < 0) angSpeed += 360;
    
    //default color
    self.marker = @"white";
    _color = [CCColor whiteColor];
    //size of star
    scale = 25;
    
    [self resizetoWidth:scale toHeight:scale];
    
    self.visible = true;
    
    // add something later.
    
    opacityDec = 1.0/30;
    scaleInc = 1.02;
    
    vertFrames = 0;
    horiFrames = 0;
    
    sideTolerance = 15;
    
    
    
    return self;
}

-(id)initWithColor:(CCColor *)color {
    
    self = [self init];
    
    if(self){
        [self setColor:color];
    }
    
    _color = color;
    
    //takes care of nil color star case
    if (color == nil || color == [CCColor whiteColor]) {
        return self;
    }
    
    //this dis ktinguishes the non-white colors from each other
    if(color == [CCColor greenColor]) {
        self.marker = @"green";
    }
    else if (color == [CCColor yellowColor]) {
        self.marker = @"yellow";
    }
    else if (color == [CCColor redColor]) {
        self.marker = @"red";
    }
    else {
        self.marker = @"other";
    }
    
    return self;
    
    
}



- (void)didLoadFromCCB
{
    // generate a random number between 0.0 and 2.0
    float delay = (arc4random() % 2000) / 1000.f;
    // call method to start animation after random delay
    [self performSelector:@selector(movingStars) withObject:nil afterDelay:delay];
    //[self setColor:[[UIColor colorWithRed:0.521569 green:0.768627 blue:0.254902 alpha:1] CGColor]];
}

-(void)movingStars {
    
    //addresses the edge case of the star getting stuck along the sides of the walls
    CGSize gameSize = [[self.parent parent] boundingBox].size;
    
    if ( vertFrames > 10 && (self.position.x <= sideTolerance||  self.position.x + sideTolerance >= gameSize.width))
    {
        angle = -angle + 540;
        self.rotation = angle;
        
        vertFrames = 0;
    }
    else if (horiFrames > 10 && (self.position.y <= sideTolerance || self.position.y + sideTolerance >= gameSize.height ))
    {
        angle = -angle + 360;
        self.rotation = angle;
        
        horiFrames = 0;
    }
    
    
    float vx = cos(angle * M_PI / 180) * speed;
    float vy = sin(angle * M_PI / 180) * speed;
    
    CGPoint direction = ccp(vx,vy);
    
    self.position = ccpAdd(self.position, direction);
    self.rotation += angSpeed;
    
    while ( self.rotation >= 360 )
    {
        self.rotation -= 360;
    }
    
    vertFrames++;
    horiFrames++;
}

//resize the star image to be something else
-(void)resizetoWidth:(float)width toHeight:(float)height {
    self.scaleX = width / self.contentSize.width;
    self.scaleY = height / self.contentSize.height;
}

//returns the color of the star
-(CCColor *) color {
    return _color;
}

//code referenced when star is stopped
-(void) stopStar {
    speed = 0;
    
    //load particle effect
    CCParticleSystem *circle = (CCParticleSystem *)[CCBReader load:@"FirstTouch"];
    // make the particle effect clean itself up, once it is completed
    circle.autoRemoveOnFinish = TRUE;
    //    place the particle effect on the stars position
    circle.position = self.position;
    //    add the particle effect to the same node the star is on
    [self.parent addChild:circle];
    
}

//code referenced when star is restarted
-(void) restartStar
{
    speed = defaultSpeed;
    //load particle effect
    CCParticleSystem *rawr = (CCParticleSystem *)[CCBReader load:@"Cancel"];
    // make the particle effect clean itself up, once it is completed
    rawr.autoRemoveOnFinish = TRUE;
    //    place the particle effect on the stars position
    rawr.position = self.position;
    //    add the particle effect to the same node the star is on
    [self.parent addChild:rawr];
}

-(void) starIntro {
    if (self.opacity >= 1) {
        starting = false;
        self.isAlive = true;
        return;
    }
    self.opacity += opacityDec;
    
    //TODO: FINISH THIS
    //CCActionFadeIn *fading = [CCActionFadeIn actionwithDuration: 1.f position:ccp(x,y)]
    
}

-(void) removeStar
{
    
    if ( self.opacity <= 0 )
        // TELL GAMEPLAY BASE TO DELETE THE STAR.
        return;
    
    self.opacity -= opacityDec;
    //self.opacity = 0.5;
    scale *= scaleInc;
    [self resizetoWidth:scale toHeight:scale];
    
    //set the color of the disappearing stars
    [self setColor:[CCColor cyanColor]];
    
    //load particle effect
    CCParticleSystem *shiny = (CCParticleSystem *)[CCBReader load:@"Shiny"];
    //make the particle effect clean itself up, once it is completed
    shiny.autoRemoveOnFinish = TRUE;
    //place the particle effect on the stars position
    shiny.position = self.position;
    //    add the particle effect to the same node the star is on
    [self.parent addChild:shiny];
}


- (void)update:(CCTime)delta
{
    if (starting)
        [self starIntro];
    [self movingStars];
    if ( !starting && !self.isAlive )
        [self removeStar];
}

@end
