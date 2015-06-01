//
//  VariableViewCell.m
//  Flower
//
//  Created by Nick Blackwell on 3/11/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "VariableViewCell.h"
#import "Block.h"
#import <QuartzCore/QuartzCore.h>

@implementation VariableViewCell

@synthesize node, nodeLibraryViewController;
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self.layer setCornerRadius:10.0];
        //[self.layer setBorderColor:[UIColor magentaColor].CGColor];
        //[self.layer setBorderWidth:1];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
    
}



-(void)setNode:(Block *)n{
    
    if(node!=nil){
        [node removeFromSuperview];
        node=nil;
    }
    
    node=n;

    
    [self insertSubview:n atIndex:0];
    CGPoint p=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [n setFlow:nil];
    [n moveCenterToPoint:p];
    
}
-(void)handleTap:(UIGestureRecognizer *)gesture{
    
    if(self.nodeLibraryViewController!=nil)[self.nodeLibraryViewController selectFlowNode:node];
    
    
}
@end
