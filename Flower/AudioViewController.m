//
//  AudioViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/19/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "AudioViewController.h"
#import "AudioBlock.h"

@interface AudioViewController ()

@property NSArray *sounds;

@end

@implementation AudioViewController

- (void)viewWillAppear:(BOOL)animated{
    _sounds=@[@"Basso", @"Blow", @"Bottle", @"Frog", @"Funk", @"Glass", @"Hero", @"Morse", @"Ping", @"Pop", @"Purr", @"Sosumi", @"Submarine", @"Tink"];
    [self.picker selectRow:[_sounds indexOfObject:((AudioBlock *)self.block).sound] inComponent:0 animated:true];
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _sounds.count;
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *v;
    if(view){
        v=(UILabel *)view;
    }else{
        v=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 20)];
        //v.backgroundColor=[UIColor lightGrayColor];
    }
    v.text=[_sounds objectAtIndex:row];
    [v setTextAlignment:NSTextAlignmentCenter];
    [v setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    return v;
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return(component==1||component==2)?40:70;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [((AudioBlock *)self.block) setSound:[_sounds objectAtIndex:row]];
}


@end
