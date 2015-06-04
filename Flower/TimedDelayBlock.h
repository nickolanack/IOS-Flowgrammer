//
//  DelayNode.h
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowBlock.h"

@interface TimedDelayBlock : FlowBlock
@property (weak, nonatomic) IBOutlet UILabel *countdown;
@property (nonatomic) float delay;

-(NSString *)getTimeString:(float)interval;

@end
