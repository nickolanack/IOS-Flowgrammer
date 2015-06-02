//
//  FlowNameViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2014-03-27.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowView.h"

@interface FlowNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

@property FlowView *flow;

@end
