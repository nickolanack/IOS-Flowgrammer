//
//  StringVariable.m
//  Flower
//
//  Created by Nick Blackwell on 3/12/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "StringVariable.h"

@implementation StringVariable

-(void)configure{
    [super configure];
    [self setValue:@""];
    [self.layer setBackgroundColor:[StringVariable Color].CGColor];
    [self setName:@"String"];
    [self setDescription:@"represents text"];
}
-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Set Value" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}


-(NSString *)type{
    return @"string";
}

-(NSString *)stringValue{
    return self.value;
}
-(void)handleSetValue{
    
}
-(void)setValue:(NSString *)v{
 
        [super setValue:v];

    
}
-(NSString *)value{
    return (NSString *)super.value;
}


-(NSString *)getDetailNibName{
    return @"variableviews.viewcontrollers";
}
-(int)getDetailNibIndex{
    return 0;
}

+(UIColor*)Color{
    return [UIColor blueColor];
}

@end
