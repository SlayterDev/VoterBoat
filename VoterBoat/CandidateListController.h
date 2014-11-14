//
//  CandidateListController.h
//  VoterBoat
//
//  Created by Bradley Slayter on 10/21/14.
//
//

#import <UIKit/UIKit.h>

@interface CandidateListController : UITableViewController <UIAlertViewDelegate> {
	NSArray *colors;
	NSMutableArray *candidates;
}

@property (nonatomic, assign) int picture;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, assign) int electionID;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, strong) NSString *name;

@end
