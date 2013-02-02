//
//  MainMenuViewController.h
//  LateWorm
//
//  Created by Susan Surapruik on 12/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainMenuViewController : UITableViewController {
	BOOL _viewGarden;
	
	NSMutableArray *_contentList;
}

- (void) initializeViewAnimation;
- (void) fadeView;

- (IBAction) viewGarden;

@property (nonatomic, retain) NSMutableArray *_contentList;

@end
