//
//  MusicologyView.h
//  MusicologyView
//
//  Created by Hendrik Heuer on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundBankPlayer.h"

@interface MusicologyView : UIView <UIAlertViewDelegate> {
    NSTimer* timer;
    SoundBankPlayer* player;
    
    NSArray *notes, *intervals, *intervalColors;
    
    IBOutlet UILabel *noteLbl, *noteCurrent, *noteColor;    
    IBOutlet UIButton *helpButton;
        
    int currentNote;
    float touchStartX, touchStartY, touchEndX, touchEndY;
}

@property (nonatomic, retain) IBOutlet UILabel *noteLbl, *noteCurrent, *noteColor;
@property (nonatomic, retain) UIButton *helpButton;

@property (nonatomic, retain) NSArray *notes, *intervals, *intervalColors;

- (void)tick;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void) sendToBackground: (NSNotification*) notification;

@end
