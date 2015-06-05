//
//  ObjectVariable.m
//  Flower
//
//  Created by Nick Blackwell on 3/16/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ObjectVariable.h"

@implementation ObjectVariable

-(void)configure{
    [super configure];
    [self setValue:@{}];
    [self.layer setBackgroundColor:[ObjectVariable Color].CGColor];
    [self setName:@"Object"];
    [self setDescription:@"represents text"];
}
-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Set Value" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}


-(NSString *)type{
    return @"object";
}

-(NSString *)stringValue{
    NSError *error;
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.value options:0 error:&error] encoding:NSUTF8StringEncoding];
  
}
-(void)handleSetValue{
    
}
-(void)setValue:(NSDictionary *)v{
    
    [super setValue:v];
    
    
}
-(NSDictionary *)value{
    return (NSDictionary *)super.value;
}


-(NSString *)getDetailNibName{
    return nil;
    return @"variableviews.viewcontrollers";
}
-(int)getDetailNibIndex{
    return 0;
}


+(UIColor*)Color{
    return [UIColor greenColor];
}

@end
