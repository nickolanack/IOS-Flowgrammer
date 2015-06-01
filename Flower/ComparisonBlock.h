//
//  ComparisonBlock.h
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LoopBlock.h"
#import "LoopConnection.h"

@interface ComparisonBlock : FunctionalBlock

@property Connection *primaryLoopOutputConnection;
@property Connection *primaryLoopInputConnection;

@property Connection *secondaryLoopOutputConnection;
@property Connection *secondaryLoopInputConnection;





@end
