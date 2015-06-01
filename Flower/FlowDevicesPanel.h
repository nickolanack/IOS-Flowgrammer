//
//  FlowDevicesPanel.h
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flow.h"

@class Flow;
@interface FlowDevicesPanel : UIView

@property Flow *flow;
@property (strong, nonatomic) id delegate;


@end
