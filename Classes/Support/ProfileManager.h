//
//  ProfileManager.h
//  LateWorm
//
//  Created by Susan Surapruik on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProfileManager : NSObject <NSXMLParserDelegate> {
	unsigned _currentLevelParse;
	unsigned _currentLeastMoves;
	NSMutableArray *_currentLayout;
	NSMutableString *_currentParsedCharacterData;
	BOOL _accumulatingParsedCharacterData;
	
	int _levelNum;
	int _nextLevelNum;
	NSMutableArray *_levels;
	NSMutableArray *_savedLayout;
	BOOL _savedLevel;
	unsigned _savedMoves;
	BOOL _gameInProgress;
	
	BOOL _paused;
}

+ (ProfileManager*) sharedProfileManager;

- (void) applicationWillResignActive;
- (void) applicationDidBecomeActive;
- (void) applicationWillTerminate;

- (NSMutableDictionary*) getProfile;
- (BOOL) setProfile:(NSDictionary*)newProfile;

- (void) initializeLayout;
- (void) initializeLayoutForLevel;
- (void) parseLevelXML:(NSString*)levelIdentifier;
- (void) levelXMLParsed;

- (NSDictionary*) getLevelDataForLevel:(int)levelNum;
- (NSDictionary*) getCurrentLevelData;
- (void) setLevelDataForLevel:(int)levelNum levelData:(NSDictionary *)levelData;

- (void) updateLevels:(NSMutableArray*)newLevels;
- (void) saveLevels;

- (void) updateSavedLayout:(NSMutableArray*)newSavedLayout;
- (void) saveSavedLayout;

@property int _levelNum;
@property int _nextLevelNum;
@property (nonatomic, retain, readonly) NSMutableArray *_levels;
@property (nonatomic, retain, readonly) NSMutableArray *_savedLayout;
@property BOOL _savedLevel;
@property int _savedMoves;
@property BOOL _gameInProgress;

@end
