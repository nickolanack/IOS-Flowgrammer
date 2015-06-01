//
//  FlowBlock.m
//  Flower
//
//  Created by Nick Blackwell on 3/14/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowBlock.h"

@implementation FlowBlock

-(void)configure{
    
    [super configure];
    
    [self.layer setCornerRadius:self.frame.size.width/2.0];    
    [self setName:@"Flow"];
    
}


@end
