//
//  CandidateListController.h
//  VoterBoat
//
//  Created by Bradley Slayter on 10/21/14.
//
//

#import <UIKit/UIKit.h>

@interface CandidateListController : UITableViewController {
	NSArray *colors;
	NSMutableArray *candidates;
}

@property (nonatomic, assign) int picture;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, assign) int electionID;
@property (nonatomic, assign) BOOL open;

@end
