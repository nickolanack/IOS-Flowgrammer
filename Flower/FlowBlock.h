//
//  Node.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//
#import "ProcessorBlock.h"
#import "VariableConnection.h"
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class FlowView;



@interface FlowBlock : ProcessorBlock

@property Connection *primaryInputConnection;
@property Connection *primaryOutputConnection;





@property NSString *javascript;

@property Connection *selectedNextConnection;


-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FlowBlock *)block;

-(void)message:(NSString *)message;
-(void)error:(NSString *)error;

-(void)willEvaluate;
-(void)didEvaluate;

-(void)notifyOutputConnectionStateDidChange;
-(void)notifyInputConnectionStateDidChange;


-(FlowBlock *)getNextBlock;
-(void)selectNextConnection:(float)delay;
-(FlowBlock *)nextExecutionBlock;
-(FlowBlock *)getPreviousBlock;


-(NSArray *)getBlocksConnectedToOutput;
-(NSArray *)getBlocksConnectedToInput;

-(bool)isSliceable;
-(void)slice;

@end
