//
//  LoginSignupController.h
//  VoterBoat
//
//  Created by Bradley Slayter on 9/25/14.
//
//

#import <UIKit/UIKit.h>
#import "CandidatesController.h"
#import "LegislationController.h"
#import "ExecutiveController.h"

@interface LoginSignupController : UITableViewController {
	NSMutableArray *fields;
}

@property (assign, nonatomic) BOOL signup;

@end
