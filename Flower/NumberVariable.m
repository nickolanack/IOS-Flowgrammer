//
//  NumberVariable.m
//  Flower
//
//  Created by Nick Blackwell on 3/11/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NumberVariable.h"
#import "NodeViewController.h"

@implementation NumberVariable

-(void)configure{
    [super configure];
    [self setValue:[NSNumber numberWithInteger:0]];
    [self.layer setBackgroundColor:[NumberVariable Color].CGColor];
    [self setName:@"Number"];
    [self setDescription:@"represents integer, or floating point numbers"];
}

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Set Value" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}

-(NSString *)type{
    return @"number";
}

-(NSString *)stringValue{
    return [(NSNumber *)self.value stringValue];
}
-(void)handleSetValue{

}
-(void)setValue:(NSNumber *)v{
    
    int i=[(NSNumber *)v integerValue];
    float f=[(NSNumber *)v floatValue];
    
    if (strcmp([v objCType], @encode(int)) == 0) {
        [super setValue:[NSNumber numberWithInteger:i]];
    }else{
        [super setValue:[NSNumber numberWithFloat:f]];
    }
    
}
-(NSValue *)value{
    
    if (strcmp([super.value objCType], @encode(int)) == 0) {
        return [NSNumber numberWithInteger:[(NSNumber *)super.value integerValue]];
    }else{
        return [NSNumber numberWithFloat:[(NSNumber *)super.value floatValue]];
    }
    
}


-(bool)displaysDetailViewInPopover{
    return true;
}
-(CGSize)detailViewPopoverSize{
    return CGSizeMake(250, 150);
}

-(NSString *)getDetailNibName{
    return @"variableviews.viewcontrollers";
}
-(int)getDetailNibIndex{
    return 1;
}

+(UIColor*)Color{
    return [UIColor cyanColor];
}

@end
