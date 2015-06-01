//
//  AudioViewController.h
//  Flower
//
//  Created by Nick Blackwell on 3/19/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeViewController.h"

@interface AudioViewController : NodeViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
