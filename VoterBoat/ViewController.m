//
//  ViewController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 9/18/14.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//[self.signInBtn.layer setBorderColor:[[UIColor blackColor] CGColor]];
	//[self.signInBtn.layer setBorderWidth:1.0f];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)goToLogin:(id)sender {
	UIButton *btn = (UIButton *)sender;
	LoginSignupController *controller = [[LoginSignupController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.signup = btn.tag;
	
	[self presentViewController:controller animated:YES completion:nil];
}
@end
