//
//  BackLoopConnection.h
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Connection.h"
@class LoopBlock;

@interface LoopConnection : Connection

@property LoopBlock *loopBlock;

@end
