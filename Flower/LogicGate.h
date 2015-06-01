//
//  LogicGate.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-09.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ProcessorBlock.h"
#import "BooleanVariable.h"

@interface LogicGate : ProcessorBlock
@property (weak, nonatomic) IBOutlet UILabel *label;
@property float inset;

@property CGPathRef path;

@property CGPoint pa, pb, pc;

-(void)drawConnections:(CGContextRef)c;
-(CGPathRef)getPath;
-(bool)evaluate;
@end
