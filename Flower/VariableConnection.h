//
//  VariableConnection.h
//  Flower
//
//  Created by Nick Blackwell on 3/9/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Connection.h"
#import "Variable.h"

@interface VariableConnection : Connection

@property NSString *variableName;
@property Class *strictTypeSource;

@property bool locksToFirstConnected;
@property bool sourceLocked;
@property bool destinationLocked;

@property bool namesVariable;
@property bool displaysName;

@property NSArray *variableTypes;

-(bool)isMutator;
-(bool)isAccessor;
-(void)disconnectUnlockedEnd;

-(void)setVariableType:(Class)variableType;

@end
