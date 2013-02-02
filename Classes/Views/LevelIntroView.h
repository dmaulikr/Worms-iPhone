#import <UIKit/UIKit.h>

@class LevelFlowerView;

@interface LevelIntroView : UIView {
	IBOutlet LevelFlowerView *_levelFlower;
	IBOutlet UILabel *_movesText;
	IBOutlet UIImageView *_levelNumber0;
	IBOutlet UIImageView *_levelNumber1;
}

- (void) setMovesText:(unsigned)moves;
- (void) setLevelNumberImages:(unsigned)levelNum;

@property (nonatomic, strong) LevelFlowerView *_levelFlower;

@end
