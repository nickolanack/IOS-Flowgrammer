//
//  Variable.m
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Variable.h"
#import "VariableConnection.h"
#import "FunctionalBlock.h"

@implementation Variable

@synthesize value, labelText;

-(void)configure{
    [super configure];
    value=[NSNumber numberWithBool:false];
    
    [self.layer setCornerRadius:self.frame.size.height/2.0];
    self.accessorConnections=[[NSMutableArray alloc] init];
    self.mutatorConnections=[[NSMutableArray alloc] init];
    
   
    [self setName:@"Variable"];
}



-(bool)isAvailableForInsertion{
    return true;
}
-(void)handleRenameRequest{
    UIAlertView *rename = [[UIAlertView alloc] initWithTitle:@"Variable Name"
                                                    message:@"set the label for this variable"
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:@"Ok", nil];
    rename.alertViewStyle = UIAlertViewStylePlainTextInput;
    [rename show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSString *label = [[alertView textFieldAtIndex:0] text];
        [self setLabelText:label];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text=[self toString];
        });
    }
}

-(void)handleDeleteRequest{
    for (VariableConnection *v in self.accessorConnections) {
        [v disconnectUnlockedEnd];
    }
    for (VariableConnection *v in self.mutatorConnections) {
        [v disconnectUnlockedEnd];
    }
    [self deleteBlock];
}

-(void)positionLabel{
    [self.label setAlpha:0];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.label setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+15)];
        self.label.text=[self toString];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        [self.label setAlpha:1];
        [UIView commitAnimations];
        
    });
}


-(void)addAccessorConnection:(VariableConnection *)v{
    
    if([self.accessorConnections indexOfObject:v]==NSNotFound)[self.accessorConnections addObject:v];
    
}
-(void)addMutatorConnection:(VariableConnection *)v{
    
    if([self.mutatorConnections indexOfObject:v]==NSNotFound)[self.mutatorConnections addObject:v];
    
}

-(void)removeAccessorConnection:(VariableConnection *)v{
    if([self.accessorConnections indexOfObject:v]!=NSNotFound)[self.accessorConnections removeObject:v];
    
}

-(void)removeMutatorConnection:(VariableConnection *)v{
    if([self.mutatorConnections indexOfObject:v]!=NSNotFound)[self.mutatorConnections removeObject:v];
    
}


-(NSArray *)getConnections{
    
    NSMutableArray *a=[[NSMutableArray alloc] init];
    
    if(self.accessorConnections!=nil)[a addObjectsFromArray:self.accessorConnections];
    if(self.mutatorConnections!=nil)[a addObjectsFromArray:self.mutatorConnections];
    
    return [[NSArray alloc] initWithArray:a];
}
-(NSString *)type{
    return @"undefined";
}

-(NSArray *)instanceNames{
    NSMutableArray *names=[[NSMutableArray alloc] init];
    
    for (VariableConnection *vc in self.mutatorConnections) {
        if(vc.namesVariable){
            [names addObject:vc.name];
        }
    }
    return [[NSArray alloc] initWithArray:names];
}


-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    if(![self isNamedByMutator]){
        [array addObject:[[UIMenuItem alloc] initWithTitle: @"Rename" action:@selector(handleRenameRequest)]];
    }

    return [[NSArray alloc] initWithArray:array];
}

-(NSString *)instanceName{
    NSArray *names=[self instanceNames];
    if(names.count)return [names componentsJoinedByString:@":"];
    return nil;
}

-(bool)isNamedByMutator{
    return [self instanceNames].count>0;
}

-(NSString *)toString{
    if(self.flow==nil)return [self type];
    NSString *name=[self instanceName];
    
    if(self.labelText!=nil&&(![self.labelText isEqualToString:@""])){
        name=self.labelText;
    }
    
    if(name==nil)name=[self type];
    return [NSString stringWithFormat:@"%@:%@", name, [self stringValue]];
}
-(NSString *)stringValue{
    return @"nil";
}


-(void)setValue:(NSValue *)v{
    
    value=v;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text=[self toString];
    });

    [self notifyConnections];
    
}



-(void)notifyConnections{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for (VariableConnection *v in self.mutatorConnections) {
            if([v.source isKindOfClass:[ProcessorBlock class]]){
                [((ProcessorBlock *)v.source) notifyOutputVariableDidChangeValueForConnection:v];
            }
        }
        
        for (VariableConnection *v in self.accessorConnections) {
            if([v.destination isKindOfClass:[ProcessorBlock class]]){
                [((ProcessorBlock *)v.destination) notifyInputVariableDidChangeValueForConnection:v];
            }
        }
        
    });
}

-(bool)restore:(NSDictionary *)state{
    id v=[state objectForKey:@"value"];
    if(value !=nil){
        [self setValue:v];
    }
    return [super restore:state];
}

-(NSDictionary *)save{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] initWithDictionary:[super save]];
    
    [d addEntriesFromDictionary:@{
                                  @"value":[self value]
                                  }];
    return d;

}



@end
