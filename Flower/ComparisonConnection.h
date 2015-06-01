//
//  ComparisonConnection.h
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Connection.h"
#import "ComparisonBlock.h"

@interface ComparisonConnection : Connection

@property ComparisonBlock *comparisonBlock;
@property (nonatomic) bool isPrimaryLoop;

@end
