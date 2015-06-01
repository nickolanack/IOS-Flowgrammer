//
//  FlowViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NodeViewController.h"
#import "FlowStackItem.h"

@class Flow;
@class Block;
@class Connection;
@class FunctionalBlock;


@interface FlowViewController : UIViewController
@property (strong, nonatomic) IBOutlet Flow *flow;
- (IBAction)runClick:(id)sender;
@property (weak, nonatomic) IBOutlet FunctionalBlock *start;
@property (weak, nonatomic) IBOutlet FunctionalBlock *end;

@property (weak, nonatomic) IBOutlet FlowStackItem *flowStack;
@property (nonatomic) NSString *flowFile;
@property (nonatomic) NSString *flowDir;
@property (weak, nonatomic) IBOutlet UIButton *openClick;

-(void)addBlockToFlow:(Block *)node;
-(void)addBlockToFlow:(FunctionalBlock *)node atConnection:(Connection *)connection;
-(void)displayDetailViewForNode:(Block *)node withViewController:(NodeViewController *)vc;
-(void)displayNodeLibraryWithConnection:(Connection *) c;
-(void)displayNodeLibraryWithPoint:(NSValue *)point;
- (IBAction)saveClick:(id)sender;

-(void)openFlow:(NSString *)file;

-(NSString *)blankFlowFile;
-(NSDictionary *)blankFlow;

-(bool)writeFlow:(NSDictionary *)flow toFile:(NSString *)file;
@end
