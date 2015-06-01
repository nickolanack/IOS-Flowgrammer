//
//  Node.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//



#import "Node.h"
#import "CodeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface Node()


@property bool draggingEnabled;

@property UIColor *borderColor;
@property float shadowOpacity;
@property float shadowRadius;

@property UIColor *activeBorderColor;
@property UIColor *doubleActiveBorderColor; //double selected (double tapped)
@property float activeShadowOpacity;
@property float activeShadowRadius;

@property UIColor *runningBackgroundColor;
@property UIColor *idleBackgroundColor;

@property float msgPosition;
@property bool prep;

@property NSArray *selection;
@property NSArray *selectionOffsets;

@property CGPoint touchOffset;



@end

@implementation Node

@synthesize input, output, delegate, code, flow, selected, doubleSelected, draggable, name, description;


-(id)initWithCoder:(NSCoder *)aDecoder{

    self=[super initWithCoder:aDecoder];
    if(self){
  
        [self configure];
        //[self addGestureRecognizers];
        return self;
    }
    return nil;
    
}

-(void)prepareToExecute{
    _prep=true;
    _msgPosition=-(M_PI_4*1.25);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundColor:self.runningBackgroundColor];
    });
}
-(void)afterExecution{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundColor:[UIColor greenColor]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.flow.delay*1.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self setBackgroundColor:self.idleBackgroundColor];
        [UIView commitAnimations];
    });
    
}

-(void)execute:(JSContext *)context{
    
    
    if(code!=nil){
        
        context[@"message"] = ^(NSString * string) {
            [self message:string];
        };
        
       
       [context evaluateScript: [NSString stringWithFormat:@"output=(function(input){ %@ })(output);",code]];
        JSValue *output=context[@"output"];
        //[context evaluateScript:@"delete(output);"];
        
    }
    
   
}
-(void)addGestureRecognizers{

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPress setMinimumPressDuration:0.5];
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];

}

-(void)setFlow:(Flow *)f{
    flow=f;
    [self addGestureRecognizers];
}
-(void)configure{
    
    self.borderColor=[UIColor colorWithRed:0.0f green:33.0f/255.0f blue:99.0f/255.0f alpha:1.0];
    self.shadowOpacity=0.2f;
    self.shadowRadius=2.0f;
    
    self.activeBorderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    self.activeShadowOpacity=0.4f;
    self.activeShadowRadius=5.0f;
    
    self.runningBackgroundColor=[UIColor greenColor];
    self.doubleActiveBorderColor=[UIColor magentaColor];
    
    
    
    self.idleBackgroundColor=self.backgroundColor;
    
    // (0, 33/255, 99/255, 1.0)
    [self.layer setCornerRadius:3.0f];
    // [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[self.borderColor CGColor]];
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.layer setShadowOpacity:self.shadowOpacity];
    [self.layer setShadowRadius:self.shadowRadius];
    [self setName:@"Node"];
}

/* Notify System (ask for permission - dissable other currently draggable items) that node wants to drag */
-(BOOL)canRequestToDrag{
    return true;
}
-(BOOL)declareAboutToDrag{
    return true;
}
-(BOOL)declareAboutToSelect{
    [self.flow selectNode:self];
    return true;
}
-(BOOL)declareUnselected{
    [self.flow unselectNode:self];
    return true;
}

-(BOOL)declareAboutToDoubleSelect{
    [self.flow groupSelectNode:self];
    return true;
}

-(BOOL)declareFinishedDrag{
    return true;
}
-(void)setSelected:(bool)s{
    
    bool was=selected;
    selected=s;
    
    if(!s&&doubleSelected)[self setDoubleSelected:false];
    
    if(selected&&(was!=selected)&&[self canRequestToDrag]&&[self declareAboutToSelect]&&[self declareAboutToDrag]){
        [self setDraggable:true];
    }
    
    if(!selected&&draggable){
        [self setDraggable:false];
        [self declareFinishedDrag];
    }
    
    if(!selected&&was!=selected){
        [self declareUnselected];
    }
}

-(void)setDoubleSelected:(bool)s{
    if(s)[self setSelected:true];
    doubleSelected=s;
    if([self declareAboutToDoubleSelect]){
        [self.layer setBorderColor:[self.doubleActiveBorderColor CGColor]];
    }
}

-(void)setDraggable:(bool) d{
    bool was=draggable;
    draggable=d;
    
    if(draggable&&was!=draggable){
        [self setSelected:true];
        if(!doubleSelected)[self.layer setBorderColor:[self.activeBorderColor CGColor]];
        [self.layer setShadowOpacity:self.activeShadowOpacity];
        [self.layer setShadowRadius:self.activeShadowRadius];
        
    }else{
        if(was!=draggable){
            [self setSelected:false];
        }
        [self.layer setBorderColor:[self.borderColor CGColor]];
        [self.layer setShadowOpacity:self.shadowOpacity];
        [self.layer setShadowRadius:self.shadowRadius];
        
    }
    
}

-(void)declarePositionChange{
    
    if(input!=nil){
        [input needsUpdate];
    }
    if(output!=nil){
        [output needsUpdate];
    }
}
-(void)handleTap:(UIGestureRecognizer *) gesture{
    [self setSelected:!selected];
}

-(void)handleDoubleTap:(UIGestureRecognizer *) gesture{
    //if(selected){
        [self setDoubleSelected:true];
    //}
}
-(void)handleSliceRequest{

    [self.flow sliceNode:self];
    [self setSelected:true];
    
    NSLog(@"Slice");

}
-(NSString *)nibName{
    return @"IpadNodeView";
}
-(int)indexInBundle{
    return 0;
}
-(Node *)clone{
    
    //NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    //id copy=[NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    //Node *n=(Node *)copy;
    //n.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    return (Node *)[[[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self.delegate options:nil] objectAtIndex:[self indexInBundle]];
    //return n;
}
-(void)handleCloneRequest{
    
    Node *n=[self clone];
    n.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //[self.flow prepareForAutolayout];
    [self.flow addNode:n];
    
    [n setFrame:CGRectMake(self.frame.origin.x+20, self.frame.origin.y+20, self.frame.size.width, self.frame.size.height)];
    [n setSelected:true];
    
    NSLog(@"Clone");
    
}
-(NSArray *)getMenuItems{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    if([self nextNode]!=nil||[self previousNode]!=nil){
        [array addObject:[[UIMenuItem alloc] initWithTitle: @"Slice" action:@selector(handleSliceRequest)]];
    }
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Clone" action:@selector(handleCloneRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)handleLongPress:(UIGestureRecognizer *) gesture{

    
    //CGPoint location=[gesture locationInView:self.superview];
    switch(gesture.state){
        case UIGestureRecognizerStateBegan:
            
            //[self.flow sliceNode:self];
            //[self setSelected:false];
            //if(draggable)[self.flow dragStart:self];
        {
            
       
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems: [self getMenuItems]];
            [menuController setTargetRect:self.frame inView:self.flow];
           // menuController.arrowDirection = UIMenuControllerArrowLeft;
            bool responder=[self becomeFirstResponder];
            [menuController setMenuVisible:true animated:true];
            //[self resignFirstResponder];
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            //[self moveToTouch:location];
            break;
            
        
        case UIGestureRecognizerStateEnded:
            break;
        /*
        //not using the other states, but here to show that they are available.
            
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStatePossible:
            break;
        */
            
        default:break;
    }
    
    
}
-(BOOL)canBecomeFirstResponder{
    return true;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    _touchOffset= CGPointMake(location.x-self.frame.origin.x, location.y-self.frame.origin.y);
    [[UIMenuController sharedMenuController] setMenuVisible:false animated:true];
    if(draggable)[self.flow dragStart:self];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _selection=nil;
    _selectionOffsets=nil;
 
    
    [self.flow dragEnd:self];
    

}
-(CGRect)limit:(CGRect)rect{
    
    // CGRect frame=self.superview.frame;
    CGRect bounds=[self convertRect:self.superview.frame fromView:self.superview.superview];
    
    float pad=10.0;
    CGRect r;
    r.origin.x=MIN(MAX(rect.origin.x, pad),bounds.size.width-pad-rect.size.width);
    r.origin.y=MIN(MAX(rect.origin.y, pad),bounds.size.height-pad-rect.size.height);
    r.size.width=rect.size.width;
    r.size.height=rect.size.height;

    return r;
    
}
-(void)moveToPoint:(CGPoint)location{
    [self setFrame:[self limit:CGRectMake(location.x, location.y, self.frame.size.width, self.frame.size.height)]];
    [self declarePositionChange];
}

-(void)moveRelative:(CGPoint)offset{
    
    [self setFrame:[self limit:CGRectMake(self.frame.origin.x+offset.x, self.frame.origin.y+offset.y, self.frame.size.width, self.frame.size.height)]];
    [self declarePositionChange];
}

-(void)moveToTouch:(CGPoint)location{

    CGPoint point=CGPointMake(location.x-_touchOffset.x, location.y-_touchOffset.y);
    
    [self setFrame:[self limit:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)]];
    [self declarePositionChange];
    
    if(self.flow.groupSelection){
        
        if(_selection==nil||_selectionOffsets==nil){
            
            _selection=[self.flow getSelected];
            _selectionOffsets=[self.flow getSelectedOffsetsFrom:self];
            
        }
    
        for(int i=0;i<_selection.count;i++){
        
            Node *n=[_selection objectAtIndex:i];
            CGPoint p=[[_selectionOffsets objectAtIndex:i] CGPointValue];
            [n moveToPoint:CGPointMake(point.x+p.x, point.y+p.y)];
        }
    }
    
    [self.flow drag:self point:self.center];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(!draggable)return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    //location.x=location.x-self.frame.origin.x;
    //location.y=location.y-self.frame.origin.y;
    [self moveToTouch:location];
    
    
}

- (IBAction)onEditClick:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(respondToEditAction::)]){
        
        [self.delegate performSelector:@selector(respondToEditAction::) withObject:self withObject:[self getEditViewControllerName]];
    }
    
}

-(void)removeMessage:(UILabel *)message{
    [message removeFromSuperview];
}
-(void)hideMessage:(UILabel *)message{
  
    
}
-(void)message:(NSString *)message{
    
   
   
    UIView *container=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-(self.frame.size.height+10), self.frame.size.height+10, 10, 10)];
    container.clipsToBounds=NO;
    [container setTransform:CGAffineTransformMakeRotation(_msgPosition)];
    _msgPosition+=(M_PI_4/8.0);
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height+50, 0, 5, 15)];
    [container addSubview:fromLabel];
    
    
    
    fromLabel.text = message;
    fromLabel.font = [UIFont systemFontOfSize:13];
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters, //or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    
    fromLabel.minimumScaleFactor = 0.05;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor grayColor];
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



-(NSString *)getEditViewControllerName{
    return @"codeView";
}
-(NodeViewController *)getEditViewController:(UIStoryboard *)storyboard :(NSString *)reuseIdentifier{
  
    if(reuseIdentifier==nil)return nil;
    
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:reuseIdentifier];
    if([vc respondsToSelector:@selector(setDelegate:)]){
        [vc performSelector:@selector(setDelegate:) withObject:self];
    }
    [vc setModalPresentationStyle:UIModalPresentationFormSheet];
    if([vc isKindOfClass:[NodeViewController class]]){
        return (NodeViewController *)vc;
    }
    @throw [[NSException alloc] initWithName:@"Incompatible View Controller" reason:@"View Controller Must Extend NodeViewController"userInfo:nil];
}

-(Node *)nextNode{
    if(self.output!=nil)return self.output.next;
        return nil;
}

-(Node *)nextExecutionNode{
    return [self nextNode];
}

-(Node *)previousNode{
    if(self.input!=nil)return self.input.previous;
    return nil;
}

-(void)deleteNodeFromFlow:(Flow *)f{
    //cleanup.
}

-(NSArray *)connectedNodes{
    NSMutableArray *a=[[NSMutableArray alloc] init];
    Node *next=[self nextNode];
    if(next!=nil)[a addObject:next];
    
    Node *prev=[self previousNode];
    if(prev!=nil)[a addObject:prev];
    
    return [[NSArray alloc] initWithArray:a];
}
@end
