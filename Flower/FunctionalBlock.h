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

@class Flow;



@interface FunctionalBlock : ProcessorBlock

@property Connection *primaryInputConnection;
@property Connection *primaryOutputConnection;





@property NSString *javascript;

@property Connection *selectedNextConnection;


-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block;

-(void)message:(NSString *)message;
-(void)error:(NSString *)error;

-(void)willEvaluate;
-(void)didEvaluate;


-(FunctionalBlock *)getNextBlock;
-(void)selectNextConnection:(float)delay;
-(FunctionalBlock *)nextExecutionBlock;
-(FunctionalBlock *)getPreviousBlock;


-(NSArray *)getBlocksConnectedToOutput;
-(NSArray *)getBlocksConnectedToInput;


@end
