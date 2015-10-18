//
//  RatchetSparkles.h
//  twinkle
//
//  Created by Jessica Jiang on 10/10/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "CCLabelTTF.h"

@interface RatchetSparkles : CCLabelTTF

-(id) initWithString:(NSString *) string;
-(id) initWithInt:(int) number;
-(id) initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size;

-(void) setLife: (int) newLife;


@end

