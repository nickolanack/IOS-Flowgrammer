//
//  StartupNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "StartupNode.h"

@implementation StartupNode

-(void)execute:(JSContext *)context{
    
    [self message:@"starting!"];
    [self message:@"initializing environment"];
    [context evaluateScript:@"var output;"];
    
    context[@"console"] = ^(NSString * string) {
        NSLog(@"%@",string);
    };
    
    
    context[@"alert"] = ^(NSString * string) {
        UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"Alert" message:string delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [a show];
        });
        
    };
    
    context[@"confirm"] = ^(NSString * string) {
        UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"Confirm" message:string delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok",nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [a show];
        });
    };
    
    
    
    [self message:@"running startup scripts"];
    [super execute:context];
    //[self message:@"finished"];

}


-(NSArray *)getMenuItems{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Run" action:@selector(handleRunRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)handleRunRequest{
    [self.flow run];
}


-(void)configure{
    [super configure];
    [self setName:@"Start"];
}
@end
