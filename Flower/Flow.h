//
//  Flow.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Node.h"
#import "FlowDevicesPanel.h"


@class Junction;

@interface Flow : UIView

@property float delay;

@property (nonatomic, readonly) bool groupSelection;
@property (strong, nonatomic) id delegate;




-(void)run;
-(void)setNSNumberDelay:(NSNumber *)n;


-(bool)sliceNode:(Node *)n;


-(bool)insertNode:(Node *)next afterNode:(Node *)prev;
-(bool)insertNode:(Node *)n at:(Connection *)c;
-(bool)addNode:(Node *)n;
-(bool)deleteNode:(Node *)n;
-(bool)addRootNode:(Node *)n;

-(bool)addConnection:(Connection *)c;
-(bool)deleteConnection:(Connection *)c;

-(void)selectNode:(Node *)n;
-(void)unselectNode:(Node *)n;
-(void)groupSelectNode:(Node *)n;


-(NSArray *) getSelected;
-(NSArray *) getSelectedOffsetsFrom:(Node *)n;


-(void)dragStart:(Node *)n;
-(void)drag:(Node *)n point:(CGPoint)p;
-(void)dragEnd:(Node *)n;


-(void)prepareForAutolayout;
-(void)reactToAutolayout;

@end
