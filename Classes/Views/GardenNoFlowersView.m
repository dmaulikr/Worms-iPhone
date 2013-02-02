//
//  GardenNoFlowersView.m
//  LateWorm
//
//  Created by Susan Surapruik on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GardenNoFlowersView.h"


@implementation GardenNoFlowersView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _flowerText.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Bd" size:18.0];
		_roundText.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Bd" size:16.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
