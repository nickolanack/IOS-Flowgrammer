//
//  LoopNode.h
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowBlock.h"
#import "VariableConnection.h"

@interface LoopBlock : FlowBlock

@property Connection *loopin;
@property Connection *loopout;

@property VariableConnection *shouldloopBoolean;

@property (weak, nonatomic) IBOutlet UIButton *loopImage;

-(FlowBlock *) getLoopNextNode;
-(FlowBlock *) getLoopPrevNode;

@end
