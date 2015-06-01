//
//  EmptyContainer.m
//  Flower
//
//  Created by Nick Blackwell on 2/26/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "EmptyContainer.h"
#import <QuartzCore/QuartzCore.h>


@implementation EmptyContainer

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    if(self){
        

        [self.layer setBorderWidth:0.5f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setCornerRadius:3.0f];
    
        return self;
    }
    return nil;
    
}


@end
