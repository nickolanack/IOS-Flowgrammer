//
//  FlowViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flow.h"
#import "Node.h"

@interface FlowViewController : UIViewController
@property (strong, nonatomic) IBOutlet Flow *flow;
- (IBAction)runClick:(id)sender;
@property (weak, nonatomic) IBOutlet Node *start;
@property (weak, nonatomic) IBOutlet Node *end;
@end
