//
//  Node.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//



#import "FunctionalBlock.h"
#import "CodeViewController.h"
#import "Connection.h"
#import "FlowView.h"
#import <QuartzCore/QuartzCore.h>

@interface FunctionalBlock()






@property UIColor *runningBackgroundColor;


@property float msgPosition;
@property bool prep;





@end

@implementation FunctionalBlock




@synthesize primaryInputConnection, primaryOutputConnection, javascript, selectedNextConnection;

-(void)configure{
    [super configure];
    self.runningBackgroundColor=[UIColor greenColor];
    [self setDescription:@"a logic block performs some function possibly interacting with variables and special connections"];

}

-(void)willEvaluate{
    _prep=true;
    _msgPosition=-(M_PI_4*1.25); //reset message printing location.
    
    dispatch_async(dispatch_get_main_queue(), ^{
     //[self setBackgroundColor:self.runningBackgroundColor];
      [self.layer setBackgroundColor:self.runningBackgroundColor.CGColor];
    });
 
}



-(void)didEvaluate{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*
        [self setBackgroundColor:[UIColor greenColor]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.flow.delay*1.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self setBackgroundColor:self.idleBackgroundColor];
        [UIView commitAnimations];
         */
        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        fadeAnim.fromValue=(id)self.runningBackgroundColor.CGColor;
        fadeAnim.toValue = (id)self.idleBackgroundColor.CGColor;
        fadeAnim.duration = 0.5;
        fadeAnim.removedOnCompletion=true;
        [self.layer addAnimation:fadeAnim forKey:@"backgroundColor"];
        self.layer.backgroundColor=self.idleBackgroundColor.CGColor;
    });

}

-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    
    if(javascript!=nil){
        
        context[@"message"] = ^(NSString * string) {
            [self message:string];
        };
        
        
       
       [context evaluateScript: [NSString stringWithFormat:@"output=(function(input){ %@ })(output);",javascript]];
        JSValue *output=context[@"output"];
        //[context evaluateScript:@"delete(output);"];
      
        return output;
        
    }
    
    return nil;
}
-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    if(![self isAvailableForInsertion]){
        [array addObject:[[UIMenuItem alloc] initWithTitle: @"Slice" action:@selector(handleSliceRequest)]];
    }
    return [[NSArray alloc] initWithArray:array];
}








-(void)deleteBlockFromFlow:(FlowView *)f{
    //cleanup.
    primaryInputConnection=nil;
    primaryOutputConnection=nil;
    [super deleteBlockFromFlow:f];
}


-(NSArray *)getConnections{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getConnections]];
    
    if(self.primaryInputConnection!=nil)[a addObject:self.primaryInputConnection];
    if(self.primaryOutputConnection!=nil)[a addObject:self.primaryOutputConnection];
    
    

    return [[NSArray alloc] initWithArray:a];
}


-(void)handleSliceRequest{

    [self.flow sliceBlock:self];
    [self setIsSelected:true];
    
    NSLog(@"Slice");

}


-(void)handleDeleteRequest{
    
    [self.flow sliceBlock:self];
    for (VariableConnection *v in self.outputVariableConnections) {
        [v disconnectUnlockedEnd];
    }
    for (VariableConnection *v in self.inputVariableConnections) {
        [v disconnectUnlockedEnd];
    }
    [super handleDeleteRequest];
    
}

-(void)removeMessage:(UILabel *)message{
    [message removeFromSuperview];
}
-(void)hideMessage:(UILabel *)message{
  
    
}

-(void)message:(NSString *)message{
    [self print:message withColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
}
-(void)error:(NSString *)error{
    [self print:[NSString stringWithFormat:@"Exception: %@",error] withColor:[UIColor redColor]];
}
-(void)print:(NSString *)message withColor:(UIColor *)c{
    
   
   
    UIView *container=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-(self.frame.size.height+10), self.frame.size.height+10, 10, 10)];
    container.clipsToBounds=NO;
    [container setTransform:CGAffineTransformMakeRotation(_msgPosition)];
    _msgPosition+=(M_PI_4/8.0);
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height+50, 0, 5, 15)];
    [container addSubview:fromLabel];
    
    
    
    fromLabel.text = message;
    fromLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters, //or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    
    fromLabel.minimumScaleFactor = 0.05;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = c;
    fromLabel.shadowColor = [UIColor clearColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
    
   
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [fromLabel setFrame:CGRectMake(fromLabel.frame.origin.x, fromLabel.frame.origin.y, 400, 15)];
    
    [UIView commitAnimations];
    
   //[self performSelector:@selector(hideMessage:) withObject:fromLabel afterDelay:2.0];
    [self performSelector:@selector(removeMessage:) withObject:container afterDelay:1.0];
    
    [self addSubview:container];
        
    });
}




-(FunctionalBlock *)getNextBlock{
    if(self.primaryOutputConnection!=nil)return (FunctionalBlock *)self.primaryOutputConnection.destination;
        return nil;
}
-(void)selectNextConnection:(float)delay{
    if(self.primaryOutputConnection!=nil){
        self.selectedNextConnection=self.primaryOutputConnection;
        [self.selectedNextConnection activate:delay];
    }
}
-(FunctionalBlock *)nextExecutionBlock{
    FunctionalBlock *block=self.selectedNextConnection!=nil?(FunctionalBlock *)self.selectedNextConnection.destination:nil;
    self.selectedNextConnection=nil;
    return block;
}

-(FunctionalBlock *)getPreviousBlock{
    if(self.primaryInputConnection!=nil)return (FunctionalBlock *)self.primaryInputConnection.source;
    return nil;
}

-(NSArray *)getBlocksConnectedToInput{
    
    ProcessorBlock *prev=[self getPreviousBlock];
    if(prev!=nil)return @[prev];
    return @[];
    
}

-(NSArray *)getBlocksConnectedToOutput{
    
    ProcessorBlock *next=[self getNextBlock];
    if(next!=nil)return @[next];
    return @[];
    
}

-(bool) isAvailableForInsertion{
    if([self getNextBlock]==nil&&[self getPreviousBlock]==nil)return true;
    return false;
}


@end