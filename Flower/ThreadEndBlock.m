//
//  CompletionNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ThreadEndBlock.h"

@implementation ThreadEndBlock

-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FlowBlock *)block{
    
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    [self message:@"finished!"];
    return output;
}

-(void)configure{
    [super configure];
    [self.layer setCornerRadius:self.frame.size.height/2.0];
    [self setName:@"End"];
}

-(NSArray *)getMenuItemsArray{
    return nil;
}
@end
