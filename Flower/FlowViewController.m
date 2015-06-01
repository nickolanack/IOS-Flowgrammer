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
#import "FlowDevicesPanel.h"
#import "Node.h"

@interface FlowViewController ()

@property Node *viewControllerSource;
@end

@implementation FlowViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.flow setDelegate:self];
    
    [self.flow addRootNode:self.start];
    [self.flow insertNode:self.end afterNode:self.start];
    
}

-(void)addNodeToFlow:(Node *)node{
    [self.flow addNode:node];
}

-(void)addNodeToFlow:(Node *)node atConnection:(Connection *)connection{
    [self.flow insertNode:node at:connection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews{
    //[self.flow prepareForAutolayout];
    

}
-(void)viewDidLayoutSubviews{
   
    NSLog(@"%s autolayout",__PRETTY_FUNCTION__);
    [self.flow reactToAutolayout];

}

-(void)respondToEditAction:(id)sender :(NSString *)reuseIdentifier{
    
    if([sender isKindOfClass:[Node class]]){
        self.viewControllerSource=(Node *)sender;
        Node *n=sender;
        NodeViewController *vc=[n getEditViewController:self.storyboard :reuseIdentifier];
        [vc setNode:n];
        if(vc!=nil){
            [self presentViewController:vc animated:TRUE completion:^{
                
            }];
        }
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.destinationViewController isKindOfClass:[FlowOptionsViewController class]]){
    
        FlowOptionsViewController *foc=segue.destinationViewController;
        [foc setDelegate:self.flow];
    }
    
    if([segue.destinationViewController isKindOfClass:[NodeLibraryViewController class]]){
        
        NodeLibraryViewController *libc=segue.destinationViewController;
        [libc setDelegate:self];
    }
    
    else if([segue.destinationViewController isKindOfClass:[NodeViewController class]]){
        if(self.viewControllerSource)[((NodeViewController *)segue.destinationViewController) setNode:self.viewControllerSource];
    }
    
    

}

- (IBAction)runClick:(id)sender {
    [self.flow run];
}
@end
