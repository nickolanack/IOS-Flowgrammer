//
//  FlowStackItem.h
//  Flower
//
//  Created by Nick Blackwell on 3/13/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowView.h"
@interface FlowStackItem : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) FlowView *flow;
@end
