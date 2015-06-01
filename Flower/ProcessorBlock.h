//
//  ProcessorBlock.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Block.h"
#import "VariableConnection.h"

@interface ProcessorBlock : Block


@property NSMutableArray *inputVariableConnections;
@property NSMutableArray *outputVariableConnections;

-(void)notifyOutputVariableDidChangeValueForConnection:(VariableConnection *)vc;
-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)vc;

-(void)notifyOutputVariableConnectionStateDidChange:(VariableConnection *)vc;
-(void)notifyInputVariableConnectionStateDidChange:(VariableConnection *)vc;


-(void)addInputVariableConnection:(VariableConnection *)v;
-(void)addOutputVariableConnection:(VariableConnection *)v;

-(void)removeInputVariableConnection:(VariableConnection *)v;
-(void)removeOutputVariableConnection:(VariableConnection *)v;




@end
