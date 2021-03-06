//
//  Variable.h
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Block.h"
@class VariableConnection;
@interface Variable : Block<UIAlertViewDelegate>

@property NSMutableArray *mutatorConnections;
@property NSMutableArray *accessorConnections;

@property (nonatomic) id value;
@property  NSString *labelText;

@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)addAccessorConnection:(VariableConnection *)v;
-(void)addMutatorConnection:(VariableConnection *)v;
-(void)removeAccessorConnection:(VariableConnection *)v;
-(void)removeMutatorConnection:(VariableConnection *)v;


-(NSString *)stringValue;
-(NSString *)type;
-(NSString *)toString;

+(UIColor*)Color;
@end
