//
//  StartupNode.h
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowBlock.h"

@interface ThreadStartBlock : FlowBlock
@property  NSString *labelText;

@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
-(void)run;

@end
