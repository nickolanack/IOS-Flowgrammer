//
//  ArrayVariable.m
//  Flower
//
//  Created by Nick Blackwell on 3/16/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ArrayVariable.h"

@implementation ArrayVariable

-(void)configure{
    [super configure];
    [self setValue:@[]];
    [self.layer setBackgroundColor:[ArrayVariable Color].CGColor];
    [self setName:@"Array"];
    [self setDescription:@"represents an array of variables"];
}

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Set Value" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}

-(NSString *)type{
    return @"array";
}

-(NSString *)stringValue{
    NSError *error;
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.value options:0 error:&error] encoding:NSUTF8StringEncoding];
    
}

-(void)handleSetValue{
    
}

-(void)setValue:(NSArray *)v{
    [super setValue:v];
}

-(NSArray *)value{
    return (NSArray *) super.value;
}


-(NSString *)getDetailNibName{
    return nil;
    //return @"variableviews.viewcontrollers";
}

-(int)getDetailNibIndex{
    return 0;
}

+(UIColor*)Color{
    return [UIColor orangeColor];
}

@end
