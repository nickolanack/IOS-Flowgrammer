//
//  WaitBlock.m
//  Flower
//
//  Created by Nick Blackwell on 2015-06-04.
//  Copyright (c) 2015 Nick Blackwell. All rights reserved.
//

#import "WaitBlock.h"
#import "VariableConnection.h"
#import "BooleanVariable.h"


@interface WaitBlock()

@property NSCondition *lock;
@property bool unlocked;

@end


@implementation WaitBlock

-(void)configure{
    
    [super configure];
    
    VariableConnection *signal=[[VariableConnection alloc] init];
    [signal setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [signal setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [signal setCenterAlignOffsetDestination:CGPointMake(-15, 0)];
    [signal connectNode:nil toNode:self];
    
    [signal setVariableType:[BooleanVariable class]];
    [signal setMidPointColor:[UIColor blueColor]];
    
    
    [self setName:@"Wait For Signal"];
    
}


-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FlowBlock *)block{
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    _unlocked=false;
    _lock=[NSCondition new];
    
    bool wait=true;
    
    Block *signal=((VariableConnection *)[self.inputVariableConnections objectAtIndex:0]).source;
    if(signal!=nil&&[signal isKindOfClass:[BooleanVariable class]]){
        wait =![[((BooleanVariable *)signal) value] boolValue];
    }
    
    
    
    
    if(wait){
        [_lock lock];
    }
    while (!_unlocked)[_lock wait];
    [_lock unlock];
    return output;
}

-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)vc{
    bool wait=true;
    Block *signal=((VariableConnection *)[self.inputVariableConnections objectAtIndex:0]).source;
    if(signal!=nil&&[signal isKindOfClass:[BooleanVariable class]]){
        wait =![[((BooleanVariable *)signal) value] boolValue];
    }
    
    if(!wait){
        [_lock lock];
        _unlocked=true;
        [_lock signal];
        [_lock unlock];
    }
    
}

@end
