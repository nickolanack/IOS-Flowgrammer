//
//  DelayViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "DelayViewController.h"
#import "TimedDelayBlock.h"


@interface DelayViewController ()

@end

@implementation DelayViewController

- (void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    
    TimedDelayBlock *t=(TimedDelayBlock *)self.block;
    float interval=t.delay;
    int hours=((int)(interval/3600)) ;
    int mins=((int)(interval/60))%60 ;
    int secs=((int) interval)%60;
    int dec=((int)round((interval-(int) interval))*10);
    
    [self.picker selectRow:hours inComponent:0 animated:true];
    [self.picker selectRow:mins inComponent:1 animated:true];
    [self.picker selectRow:secs inComponent:2 animated:true];
    [self.picker selectRow:dec inComponent:0 animated:true];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    switch (component) {
        case 0:
            return 24;
            break;
        
        case 3:
            
            return 10;
            break;
            
        default: return 60;
            break;
    }

}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *v;
    if(view){
        v=(UILabel *)view;
    }else{
        v=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        //v.backgroundColor=[UIColor lightGrayColor];
    }
    
    [v setFrame:CGRectMake(0, 0, (component==1||component==2)?30:60, 20)];
    if(component==3){
        [v setText:[NSString stringWithFormat:@".%d",row]];
    }else{
        [v setText:[NSString stringWithFormat:@"%@%d",(row<10?@"0":@""),row]];
    }
    [v setTextAlignment:(component==0?NSTextAlignmentRight:(component==3?NSTextAlignmentLeft:NSTextAlignmentCenter))];
    [v setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    return v;

}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return(component==1||component==2)?40:70;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    TimedDelayBlock *t=(TimedDelayBlock *)self.block;
    
    int hours=[self.picker selectedRowInComponent:0];
    int mins=[self.picker selectedRowInComponent:1];
    int seconds=[self.picker selectedRowInComponent:2];
    int dec=[self.picker selectedRowInComponent:3];
    
    float time=dec/10.0+seconds+mins*60.0+hours*60.0*60.0;
    
    [t setDelay:time];
 

}

@end
