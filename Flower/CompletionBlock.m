//
//  CompletionNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "CompletionBlock.h"

@implementation CompletionBlock

-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    [self message:@"finished!"];
    return output;
}

-(void)configure{
    [super configure];
    [self setName:@"End"];
}

-(NSArray *)getMenuItemsArray{
    return nil;
}
@end
