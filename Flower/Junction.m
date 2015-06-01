//
//  Junction.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Junction.h"
#import <QuartzCore/QuartzCore.h>

@implementation Junction


- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setCornerRadius:self.frame.size.height/2.0];
    }
    return self;
}


@end
