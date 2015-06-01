//
//  Node.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Connection.h"
#import "Flow.h"

@class Connection;
@class NodeViewController;
@class Flow;


@interface Node : UIView

@property Connection *input;
@property Connection *output;
@property (nonatomic) bool selected;
@property (nonatomic) bool doubleSelected;
@property (nonatomic) bool draggable;




@property NSString *code;
@property (nonatomic) Flow *flow;

@property (strong, nonatomic) id delegate;

- (IBAction)onEditClick:(id)sender;

-(void)execute:(JSContext *)context;
-(void)message:(NSString *)message;
-(void)configure;

-(void)prepareToExecute;
-(void)afterExecution;


-(Node *)nextNode;
-(Node *)nextExecutionNode;
-(Node *)previousNode;

-(NSString *)getEditViewControllerName;
-(NodeViewController *)getEditViewController:(UIStoryboard *)storyboard :(NSString *)reuseIdentifier;

-(void)moveToPoint:(CGPoint)location;
-(void)moveRelative:(CGPoint)offset;


-(void)deleteNodeFromFlow:(Flow *)f;


//protected methods

-(NSArray *)connectedNodes;

-(void)declarePositionChange;

-(NSArray *)getMenuItems;

@property NSString *name;
@property NSString *description;

@end
