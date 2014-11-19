//
//  CandidateProfileController.h
//  VoterBoat
//
//  Created by Stauffer on 10/27/14.
//
//

#import <UIKit/UIKit.h>

@interface CandidateProfileController : UIViewController <UIActionSheetDelegate>
{
    UITextView *bio;
}

@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int candidate_id;
@property (nonatomic, assign) int election_id;
@property (strong, nonatomic) NSString *user_name;
@property (nonatomic, assign) BOOL open;
@property (strong, nonatomic) NSString *name;

@end
