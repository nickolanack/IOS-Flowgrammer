//
//  Boolean.m
//  Flower
//
//  Created by Nick Blackwell on 3/10/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "BooleanVariable.h"
//#import <QuartzCore/QuartzCore.h>

@implementation BooleanVariable


-(void)configure{
    [super configure];
    [self.layer setBackgroundColor:[UIColor lightGrayColor].CGColor];
    [self setName:@"Boolean"];
    [self setDescription:@"a boolean variable has two states: on, and off. it can be connected as the input or output of a variable connection"];
    
    
    
}

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Toggle" action:@selector(toggleValue)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)addGestureRecognizers{
    [super addGestureRecognizers];
    UITapGestureRecognizer *trippleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleValueTap:)];
    [trippleTap setNumberOfTapsRequired:3];
    [self addGestureRecognizer:trippleTap];
}

-(NSString *)type{
    return @"boolean";
}

-(NSString *)stringValue{
    return [(NSNumber *)self.value boolValue]?@"true":@"false";
}
-(void)toggleValueTap:(id)gesture{
    [self toggleValue];
}
-(NSValue *)toggleValue{
    
    [self setValue:[NSNumber numberWithBool:![(NSNumber *)self.value boolValue]]];
    return [self value];
    
}
-(void)setValue:(NSValue *)v{
    
    bool bval=[(NSNumber *)v boolValue];
    [super setValue:[NSNumber numberWithBool:bval]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(bval){
            [self.layer setBackgroundColor:[UIColor magentaColor].CGColor];
        }else{
            [self.layer setBackgroundColor:[UIColor lightGrayColor].CGColor];
        }
    });
}
-(NSValue *)value{
    return [NSNumber numberWithBool:[(NSNumber *)super.value boolValue]];
}


@end
