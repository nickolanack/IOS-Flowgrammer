//
//  NodeViewCell.m
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NodeViewCell

@synthesize node, delegate;
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

-(void)setNode:(Node *)n{
    
    if(node!=nil){
        [node removeFromSuperview];
        node=nil;
    }
    
    node=n;
    self.label.text=node.name;
    
    [self insertSubview:n atIndex:0];
    CGPoint p=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    p.y+=20;
    [n setCenter:p];
    
}
-(void)handleTap:(UIGestureRecognizer *)gesture{
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(selectFlowNode:)]){
        [self.delegate performSelector:@selector(selectFlowNode:) withObject:node];
    }
    

}
@end
