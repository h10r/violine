//
//  MusicologyView.m
//  MusicologyView
//
//  Created by Hendrik Heuer on 4/2/12.
//  Copyright (c) 2012 Hendrik Heuer. All rights reserved.
//

#import "MusicologyView.h"

@implementation MusicologyView

@synthesize noteLbl, noteCurrent, noteColor, helpButton, notes, intervals, intervalColors;

// former - (id)initWithFrame:(CGRect)frame {
- (void)awakeFromNib {

    //CGRect frame = [self frame];
    
    intervals = [[NSArray alloc] 
                     initWithObjects:@"Unison", @"Minor second", @"Major second", @"Minor third", @"Major third", 
                     @"Perfect fourth", @"Tritone", @"Perfect fifth", @"Minor sixth",
                     @"Major sixth", @"Minor seventh", @"Major seventh", @"Octave", @"Minor ninth", @"Major ninth", nil];
         
    intervalColors = [[NSArray alloc] 
                      initWithObjects: 
                      [[[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] autorelease], 
                      [[[UIColor alloc] initWithRed:0.0f green:204.0f / 255.0f blue:1.0f alpha:1.0f] autorelease], 
                      [[[UIColor alloc] initWithRed: 8.0f / 255.0f green:3.0f / 255.0f blue: 137.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 186.0f / 255.0f green:255.0f / 255.0f blue: 0.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 255.0f / 255.0f green:156.0f / 255.0f blue: 0.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 255.0f / 255.0f green:255.0f / 255.0f blue: 0.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 255.0f / 255.0f green:0.0f / 255.0f blue: 0.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 78.0f / 255.0f green:255.0f / 255.0f blue: 0.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 204.0f / 255.0f green:204.0f / 255.0f blue: 204.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 128.0f / 255.0f green:128.0f / 255.0f blue: 128.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 0.0f / 255.0f green:18.0f / 255.0f blue: 255.0f / 255.0f alpha:1.0f] autorelease],
                      [[[UIColor alloc] initWithRed: 255.0f / 255.0f green:255.0f / 255.0f blue: 255.0f / 255.0f alpha:1.0f] autorelease], nil];
    
    notes = [[NSArray alloc] 
             initWithObjects:@"C", @"C#", @"D", @"D#", @"E", 
             @"F", @"F#", @"G", @"G#",
             @"A", @"Bb", @"B", nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/30.0f)
                     target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    player = [[SoundBankPlayer alloc] init];
    [player setSoundBank:@"Violin"];
    
    currentNote = 48;
    
    touchStartX = touchEndX = -1.0f;
    touchStartY = touchEndY = -1.0f;
    
    [helpButton addTarget:self action:@selector(helpDialog:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(sendToBackground:) 
                                                 name: @"didEnterBackground" 
                                               object: nil];
}

-(void) tick {   
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    touchStartX = touchEndX = location.x;
    touchStartY = touchEndY = location.y;
    
    [player noteOff:currentNote];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {	
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    touchEndX = location.x;
    touchEndY = location.y;
    
    double dx = (touchEndX-touchStartX);
    double dy = (touchEndY-touchStartY);
    
    int dist = floor( sqrt((dx*dx) + (dy*dy)) / 50.0f );
    
    if ( touchStartX > touchEndX ) {
        NSMutableString *newLabelText = [NSMutableString stringWithString:[intervals objectAtIndex:dist] ]; 
        [noteLbl setText:newLabelText];
        
        NSMutableString *newLabelNoteText = [NSMutableString stringWithString:[notes objectAtIndex:( (currentNote - dist) % 12) ]];
        [noteCurrent setText:newLabelNoteText];
        
        [noteColor setBackgroundColor:[intervalColors objectAtIndex:dist]];
        
    } else {
        NSMutableString *newLabelText = [NSMutableString stringWithString:[intervals objectAtIndex:dist] ];         
        [noteLbl setText:newLabelText];
        
        NSMutableString *newLabelNoteText = [NSMutableString stringWithString:[notes objectAtIndex:( (currentNote + dist) % 12) ]];
        [noteCurrent setText:newLabelNoteText];
        
        [noteColor setBackgroundColor:[intervalColors objectAtIndex:dist]];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    touchEndX = location.x;
    touchEndY = location.y;
    
    double dx = (touchEndX-touchStartX);
    double dy = (touchEndY-touchStartY);
    
    int dist = abs(floor( sqrt((dx*dx) + (dy*dy)) / 50.0f ));
    
    if ( touchStartX > touchEndX ) {
        NSMutableString *newLabelText = [NSMutableString stringWithString:[notes objectAtIndex:( (currentNote - dist) % 12) ]];
        [noteCurrent setText:newLabelText];
        
        currentNote -= dist;
    } else {
        NSMutableString *newLabelText = [NSMutableString stringWithString:[notes objectAtIndex:( (currentNote + dist) % 12) ]];
        [noteCurrent setText:newLabelText];
        
        currentNote += dist;
    }
    
    [noteLbl setText:@""];
    [noteColor setBackgroundColor:[UIColor whiteColor]];
    
    [player queueNote:currentNote gain:0.8f];
	[player playQueuedNotes];
}

-(void) sendToBackground: (NSNotification*) notification {
    [player noteOff:currentNote];
    currentNote = 48;
    
    NSMutableString *newLabelText = [NSMutableString stringWithString:[notes objectAtIndex:( (currentNote) % 12) ]];
    [noteCurrent setText:newLabelText];
    
    [noteLbl setText:@""];
    [noteColor setBackgroundColor:[UIColor whiteColor]];
    
    [self setNeedsDisplay];
}

-(void) helpDialog:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"How to use VioLine"
                                                      message:@"Touch the screen and draw a line to change the pitch. A line from the left to the right will make the pitch higher - a line from the right to the left lower will make it lower. Visit VioLineMusic on Facebook or select 'View Songs' to learn how to play songs." 
                                                     delegate:self
                                            cancelButtonTitle:@"Close"
                                            otherButtonTitles:@"View songs", nil];
    // [message addButtonWithTitle:@"Reset"];
    [message show];
    [message release];
}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) index {
    if(index == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/VioLineMusic"]];
    }
}

- (void)didReceiveMemoryWarning
{
}

-(void) dealloc {    
	[player release];
    
    [intervals release];
    [intervalColors release];
    
    [super dealloc]; 
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end
