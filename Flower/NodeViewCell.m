//
//  NodeViewCell.m
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeViewCell.h"
#import "Block.h"
#import <QuartzCore/QuartzCore.h>

@implementation NodeViewCell

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
        [node deleteBlock];
        node=nil;
    }
    
    node=n;
    self.label.text=node.name;
    
    [self insertSubview:n atIndex:0];
    CGPoint p=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0+15);
    [n moveCenterToPoint:p];
    //double delayInSeconds = 0.1;
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [n declarePositionChange];
    //});
    
    if(!node.userInteractionEnabled){
        [self.layer setOpacity:0.5];
    }else{
        [self.layer setOpacity:1.0];
    }
}
-(void)handleTap:(UIGestureRecognizer *)gesture{
    if(node.userInteractionEnabled){
        if(self.nodeLibraryViewController!=nil)[self.nodeLibraryViewController selectFlowNode:node];
    }
}
@end
