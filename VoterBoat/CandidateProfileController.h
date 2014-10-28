//
//  CandidateProfileController.h
//  VoterBoat
//
//  Created by Stauffer on 10/27/14.
//
//

#import <UIKit/UIKit.h>

@interface CandidateProfileController : UIViewController
{
    UITextView *bio;
}

@property (nonatomic, assign) int user_id;
@property (strong, nonatomic) NSString *user_name;

@end
