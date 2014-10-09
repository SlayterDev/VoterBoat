//
//  LegislationController.h
//  VoterBoat
//
//  Created by Bradley Slayter on 9/30/14.
//
//

#import <UIKit/UIKit.h>

@interface LegislationController : UITableViewController {
	NSArray *colors;
    NSMutableArray *elections;
    UIRefreshControl *refreshControl;
}

@end
