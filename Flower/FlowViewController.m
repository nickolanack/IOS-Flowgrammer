//
//  FlowViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowViewController.h"
#import "CodeViewController.h"
#import "FlowOptionsViewController.h"
#import "NodeLibraryViewController.h"
#import "FlowLibraryViewController.h"
#import "FlowNameViewController.h"
#import "FunctionalBlock.h"



@interface FlowViewController ()

@property Block *viewControllerSource;


@property UIPopoverController *pvc;

@end

@implementation FlowViewController


@synthesize flowFile, flowDir;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{

    [self.flow setDelegate:self];
    [self.flow addRootBlock:self.start];
    [self.flow insertBlock:self.end afterBlock:self.start];
    [self.flowStack setFlow:self.flow];
    
    NSError *error;
    
    NSString *config=[NSString stringWithContentsOfFile:[self.flowDir stringByAppendingPathComponent:@"config.txt"] encoding:NSUTF8StringEncoding error:&error];
    if(config!=nil){
        NSDictionary* configuration = [NSJSONSerialization JSONObjectWithData:[config dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        NSString *file;
        if((file=[configuration objectForKey:@"flowgram"])!=nil){
            [self setFlowFile:file];
        }
        
    }
    bool restored=false;
    NSString *flowgram=[NSString stringWithContentsOfFile:[self.flowDir stringByAppendingPathComponent:self.flowFile] encoding:NSUTF8StringEncoding error:&error];
    
    if(flowgram!=nil){
        
        NSDictionary* state = [NSJSONSerialization JSONObjectWithData:[flowgram dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        if(state!=nil){
            
            [self.flow restore:state];
            restored=true;
            
        }
        
    }

    if(!restored){
        
        [self.start moveCenterToPoint:CGPointMake(200, 200)];
        [self.end moveCenterToPoint:CGPointMake(self.flow.frame.size.width-200, self.flow.frame.size.height-200)];
    }

}

-(void)addBlockToFlow:(FunctionalBlock *)node{
    [self.flow addBlock:node];
    
}

-(void)addBlockToFlow:(FunctionalBlock *)node atConnection:(Connection *)connection{
    [self.flow insertBlock:node at:connection];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillLayoutSubviews{
    //[self.flow prepareForAutolayout];
    
}
-(void)viewDidLayoutSubviews{
   
    //NSLog(@"%s autolayout",__PRETTY_FUNCTION__);
    [self.flow reactToAutolayout];

}

-(void)displayDetailViewForNode:(Block *)node withViewController:(NodeViewController *)vc{

    _viewControllerSource=node;

        if(vc!=nil){
            [vc setBlock:node];
            if([_viewControllerSource displaysDetailViewInPopover]){
                
                if(_pvc!=nil){
                    _pvc=nil;
                }
                
                _pvc = [[UIPopoverController alloc] initWithContentViewController:vc];
                [vc setPvc:_pvc];
                [_pvc setPopoverContentSize:[_viewControllerSource detailViewPopoverSize] animated:false];
                [_pvc presentPopoverFromRect:_viewControllerSource.frame inView:self.flow permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
            }else{
                [self presentViewController:vc animated:TRUE completion:^{
                    
                }];
            }
        }
}

-(void)displayNodeLibraryWithConnection:(Connection *) c{

    NodeLibraryViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"nodelib"];
    [vc setModalPresentationStyle:UIModalPresentationFormSheet];
    [vc setConnection:c];
    [vc setFlow:self.flow];
    [self presentViewController:vc animated:TRUE completion:^{
        
    }];
    
}
-(void)displayNodeLibraryWithPoint:(NSValue *)point{
    
    CGPoint p=[point CGPointValue];
    
    NodeLibraryViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"nodelib"];
    [vc setModalPresentationStyle:UIModalPresentationFormSheet];
    [vc setPoint:[NSValue valueWithCGPoint:p]];
    [vc setFlow:self.flow];
    [self presentViewController:vc animated:TRUE completion:^{
        
    }];
    
    
}

- (IBAction)saveClick:(id)sender {
    
    NSError *error;
    
    [self write:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self.flow save] options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding] toFile:[self.flowDir stringByAppendingPathComponent:self.flowFile]];
    
    [self write:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"flowgram":self.flowFile} options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding] toFile:[self.flowDir stringByAppendingPathComponent:@"config.txt"]];
    
    
    
}

-(bool)writeFlow:(NSDictionary *)flow toFile:(NSString *)file{
    NSError *error;
    [self write:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:flow options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding] toFile:[self.flowDir stringByAppendingPathComponent:file]];
    return true;
    
}
-(bool)write:(NSString *)data toFile:(NSString *) file{
    NSError *error;
    
    
    
    NSFileManager *f=[NSFileManager defaultManager];
    NSString *dir=[file stringByDeletingLastPathComponent];
    if(![f fileExistsAtPath:dir]){
        NSError *dError;
        [f createDirectoryAtPath:dir withIntermediateDirectories:true attributes:nil error:&dError];
    }
    
    
    
    if([data writeToFile:file atomically:true encoding:NSUTF8StringEncoding error:&error]){
        return true;
    }
    
    //do something with the error
    
    return false;
}

-(NSString *)flowDir{
    if(flowDir==nil||[flowDir isEqualToString:@""]){
        NSString *directory = [NSHomeDirectory()
                              stringByAppendingPathComponent:@"Documents"];
        flowDir=directory;

    }
    return flowDir;
}
- (NSString *)flowFile{
    if(flowFile==nil||[flowFile isEqualToString:@""]){
        flowFile=[self blankFlowFile];
    }
    return flowFile;
}

- (NSString *)blankFlowFile{
        
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    int i=1;

    NSFileManager *f=[NSFileManager defaultManager];
    NSString *file;
    NSString *pad=@"000000";
    do{
        
        NSString *number=[NSString stringWithFormat:@"%d", i];
        number=[NSString stringWithFormat:@"%@%@", [pad substringToIndex:pad.length-number.length], number];
        file = [NSString stringWithFormat:@"%@ %@.flow", [formatter stringFromDate:[NSDate date]], number];
        i++;
        
    }while([f fileExistsAtPath:[self.flowDir stringByAppendingPathComponent:file]]);
    
    
    
    return file;
}

-(NSDictionary *)blankFlow{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eeee MMMM d, yyyy - hh:mm a"];
    
    return @{
             
             @"name":@"My New Flow",
             @"description":[formatter stringFromDate:[NSDate date]]
             
            };

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.destinationViewController isKindOfClass:[FlowOptionsViewController class]]){
        
        //lets the set the options for running the current flow
    
        FlowOptionsViewController *foc=segue.destinationViewController;
        [foc setFlow:self.flow];
    }
    
    if([segue.destinationViewController isKindOfClass:[NodeLibraryViewController class]]){
        
        //lets the user add new blocks
        
        NodeLibraryViewController *libc=segue.destinationViewController;
        [libc setFlow:self.flow];
    }

    
    if([segue.destinationViewController isKindOfClass:[FlowNameViewController class]]){
        
        //lets the user rename the current flowgram

        FlowNameViewController *fnvc=(FlowNameViewController *)segue.destinationViewController;
        [fnvc setFlow:self.flow];
        
    }
    
    if([segue.destinationViewController isKindOfClass:[FlowLibraryViewController class]]){
        
        //lets the user pic a new flowgram file
        
        FlowLibraryViewController *flvc=(FlowLibraryViewController *)segue.destinationViewController;
        [flvc setFlow:self.flow];
        [flvc setFlowViewController:self];
        
    }
}

- (IBAction)runClick:(id)sender {
    [self.flow run];
}

-(void)openFlow:(NSString *)file{
    
    NSError *error;
    [self write:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"flowgram":file} options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding] toFile:[self.flowDir stringByAppendingPathComponent:@"config.txt"]];
    
    
    
    FlowViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"Flow"];
   
    [self presentViewController:vc animated:true completion:^{
        //[self dismissViewControllerAnimated:false completion:^{
            
       // }];
    }];

}
@end
