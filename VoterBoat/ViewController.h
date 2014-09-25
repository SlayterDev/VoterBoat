//
//  ViewController.h
//  VoterBoat
//
//  Created by Bradley Slayter on 9/18/14.
//
//

#import <UIKit/UIKit.h>
#import "LoginSignupController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *signInBtn;


- (IBAction)goToLogin:(id)sender;

@end

