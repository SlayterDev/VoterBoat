//
//  CandidateProfileController.m
//  VoterBoat
//
//  Created by Stauffer on 10/27/14.
//
//

#import "CandidateProfileController.h"
#import "AFNetworking.h"
#import "SBJsonParser.h"
#import "DejalActivityView.h"

@interface CandidateProfileController ()

@end

@implementation CandidateProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.user_name;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *pane = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)];
    [pane setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:96.0/255.0 blue:122.0/255.0 alpha:1.0]];
    [self.view addSubview:pane];
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-45, 117, 90, 90)];
    [photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.usesweetspot.com/images/users/%dvoterboat.jpeg", self.user_id]] placeholderImage:nil];
    [[photo layer] setMasksToBounds:YES];
    [[photo layer] setCornerRadius:45.0];
    [[photo layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[photo layer] setBorderWidth:2.0];
    [self.view addSubview:photo];
    
    bio = [[UITextView alloc] initWithFrame:CGRectMake(10, 270, self.view.frame.size.width-20, 400)];
    [bio setText:@"THIS IS MY BIO BRO! ITS A PLACE WHERE I CAN EXPRESS MYSELF AND STUFF."];
    [bio setTextColor:[UIColor darkGrayColor]];
    [bio setUserInteractionEnabled:NO];
    [bio setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [self.view addSubview:bio];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem *voteBtn = [[UIBarButtonItem alloc] initWithTitle:@"Vote" style:UIBarButtonItemStylePlain target:self action:@selector(vote)];
    self.navigationItem.rightBarButtonItem = voteBtn;
    
    [self getBio];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)vote
{
    
}

- (void)getBio
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"controller", @"get_user_bio", @"method", [NSString stringWithFormat:@"%d", self.user_id], @"user_id", nil];
    [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [DejalActivityView removeView];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *response = [parser objectWithString:responseStr];
        NSLog(@"%@", responseStr);
        if ([response objectForKey:@"did_succeed"])
        {
            bio.text = [response objectForKey:@"bio"];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %@", [response objectForKey:@"err_code"]] message:[response objectForKey:@"err_msg"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /* dispatch_async(dispatch_get_main_queue(), ^{
         [errors addObject:@"94"];
         [self checkStatus];
         });*/
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
