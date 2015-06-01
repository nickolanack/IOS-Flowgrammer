//
//  FlowLibraryCell.m
//  Flower
//
//  Created by Nick Blackwell on 2014-03-27.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowLibraryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlowLibraryCell

@synthesize path, flowLibraryViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setCornerRadius:5.0];
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
        
        }
    return self;
}

-(void)handleTap:(UIGestureRecognizer *)gesture{

    [self.flowLibraryViewController selectFile:self.path];
}
@end
