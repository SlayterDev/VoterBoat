//
//  CandidatesController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 9/30/14.
//
//

#import "CandidatesController.h"
#import "AFNetworking.h"
#import "SBJsonParser.h"
#import "DejalActivityView.h"

@interface CandidatesController ()

@end

@implementation CandidatesController

-(id) initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Executive" image:[UIImage imageNamed:@"business-32.png"] tag:0];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Executive" image:[UIImage imageNamed:@"business-32.png"] tag:0];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(260, 0, self.bottomLayoutGuide.length, 0)];
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"USA-White-House.jpg"]];
	iv.frame = CGRectMake(0, -260, self.view.bounds.size.width, 260);
	[self.view addSubview:iv];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, -75, self.view.bounds.size.width - 30, 75)];
	lbl.font = [UIFont fontWithName:@"HelveticaNeue-light" size:45];
	lbl.text = @"Executive";
	[self.view addSubview:lbl];
	lbl.textColor = [UIColor whiteColor];
	
	colors = @[[UIColor colorWithRed:68.0/255.0 green:96.0/255.0 blue:122.0/255.0 alpha:1.0], [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:196.0/255.0 blue:215.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:195.0/255.0 blue:137.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:132.0/255.0 alpha:1.0], [UIColor colorWithRed:246.0/255.0 green:194.0/255.0 blue:66.0/255.0 alpha:1.0], [UIColor colorWithRed:227.0/255.0 green:108.0/255.0 blue:38.0/255.0 alpha:1.0]];
	
	self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	//self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[elections removeAllObjects];
    [self loadElections];
	[self.navigationController setNavigationBarHidden:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

- (void)loadElections
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSLog(@"USER ID: %@", [defaults objectForKey:@"user_id"]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"elections", @"controller", @"get_elections", @"method", @"Executive", @"type", [defaults objectForKey:@"user_id"], @"user_id", nil];
    [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [DejalActivityView removeView];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *response = [parser objectWithString:responseStr];
        NSLog(@"%@", responseStr);
        if ([response objectForKey:@"did_succeed"])
        {
            elections = [response objectForKey:@"data"];
            NSLog(@"%@", elections);
            [self.tableView reloadData];
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

-(void) viewDidLayoutSubviews {
	[self.tableView setContentInset:UIEdgeInsetsMake(260, 0, self.bottomLayoutGuide.length, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [elections count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[colors objectAtIndex:(indexPath.row % colors.count)]];
	//cell.backgroundColor = [UIColor greenColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	//UIView *back = [[UIView alloc] initWithFrame:CGRectZero];
	//cell.contentView.backgroundColor = [colors objectAtIndex:indexPath.row % colors.count];
	//cell.backgroundView = back;
	//cell.textLabel.backgroundColor = [UIColor clearColor];
	
    cell.textLabel.text = [[elections objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"open"] isEqualToString:@"T"])
    {
        // Handle Time
        long remainingTime = (([[[elections objectAtIndex:indexPath.row] objectForKey:@"delete_time"] longLongValue]) - (long)[[NSDate date] timeIntervalSince1970]);
        int secondsInAMinute = 60;
        int secondsInAnHour  = 60 * secondsInAMinute;
        int secondsInADay    = 24 * secondsInAnHour;
        int secondsInAWeek   = 7 * secondsInADay;
        int secondsInAMonth  = 30 * secondsInADay;
        
        // Extract months
        int months = floor(remainingTime / secondsInAMonth);
        // Extract weeks
        int weeks = floor(remainingTime / secondsInAWeek);
        // Extract days
        int days = floor(remainingTime / secondsInADay);
        // Extract hours
        int hours = floor(remainingTime / secondsInAnHour);
        // Extract minutes
        int minutes = floor(remainingTime / secondsInAMinute);
        // Extract the remaining seconds
        int mySeconds = floor(remainingTime);
        
        if (months > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%iM Remaining", months];
        }
        else if (weeks > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%iw Remaining", weeks];
        }
        else if (days > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%id Remaining", days];
        }
        else if (hours > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ih Remaining", hours];
        }
        else if (minutes > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%im Remaining", minutes];
        }
        else if (mySeconds > 0)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%is Remaining", mySeconds];
        }
    }
    else
        cell.detailTextLabel.text = @"";

	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - cell.frame.size.height-50, 0, cell.frame.size.height+50, 60.0f)];
	if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"open"] isEqualToString:@"T"] && [[[elections objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"T"])
        lbl.text = @"Vote";
    else if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"P"])
        lbl.text = @"Pending";
    else if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"F"])
        lbl.text = @"Register";
    else if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"open"] isEqualToString:@"U"])
        lbl.text = @"Upcoming";
        
	lbl.textAlignment = NSTextAlignmentCenter;
	lbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
	[cell.contentView addSubview:lbl];
	
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
	lbl.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"F"]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Register" message:@"Would you like to register as a candidate or a voter?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *voter = [UIAlertAction actionWithTitle:@"Voter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			/*CandidateListController *controller = [[CandidateListController alloc] initWithStyle:UITableViewStylePlain];
			controller.picture = 0;
			controller.branch = self.tabBarItem.title;
			controller.electionID = [[[elections objectAtIndex:indexPath.row] objectForKey:@"election_id"] intValue];
			[self.navigationController pushViewController:controller animated:YES];*/
			
			NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
			NSLog(@"USER ID: %@", [defaults objectForKey:@"user_id"]);
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
			AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
			NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"elections", @"controller", @"register_election", @"method", [defaults objectForKey:@"user_id"], @"user_id", [[elections objectAtIndex:indexPath.row] objectForKey:@"election_id"], @"election_id", nil];
			[httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
				[DejalActivityView removeView];
				NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
				SBJsonParser *parser = [[SBJsonParser alloc] init];
				NSDictionary *response = [parser objectWithString:responseStr];
				NSLog(@"%@", responseStr);
				if ([response objectForKey:@"did_succeed"])
				{
					[[[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered as a voter. You must be verified by an admin before voting in this election." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
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
		}];
		[alert addAction:voter];
		
		UIAlertAction *candidate = [UIAlertAction actionWithTitle:@"Candidate" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
            if ([[defaults objectForKey:@"bio_setup"] isEqualToString:@"YES"])
            {
                NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
                NSLog(@"USER ID: %@", [defaults objectForKey:@"user_id"]);
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
                AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"elections", @"controller", @"register_candidate", @"method", [defaults objectForKey:@"user_id"], @"user_id", [[elections objectAtIndex:indexPath.row] objectForKey:@"election_id"], @"election_id", nil];
                [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [DejalActivityView removeView];
                    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    SBJsonParser *parser = [[SBJsonParser alloc] init];
                    NSDictionary *response = [parser objectWithString:responseStr];
                    NSLog(@"%@", responseStr);
                    if ([response objectForKey:@"did_succeed"])
                    {
                        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered as a candidate. You must be verified by an admin before running in this election." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
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
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must complete your bio in Settings prior to registering as a candidate." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
            }
        }];
		[alert addAction:candidate];
		
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			//[self dismissViewControllerAnimated:YES completion:nil];
		}];
		[alert addAction:cancel];
		[self presentViewController:alert animated:YES completion:nil];
	}
    else if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"is_registered"] isEqualToString:@"P"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You have already registered for this election. Please wait until your request has been approved by an admin." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
    else
    {
        NSLog(@"true");
        CandidateListController *controller = [[CandidateListController alloc] initWithStyle:UITableViewStylePlain];
        controller.picture = 0;
        controller.branch = self.tabBarItem.title;
        controller.electionID = [[[elections objectAtIndex:indexPath.row] objectForKey:@"election_id"] intValue];
		controller.name = [[elections objectAtIndex:indexPath.row] objectForKey:@"name"];
		
		if ([[[elections objectAtIndex:indexPath.row] objectForKey:@"open"] isEqualToString:@"T"])
			controller.open = YES;
		else
			controller.open = NO;
		
		NSLog(@"%@, %@", controller, self.navigationController);
        [self.navigationController pushViewController:controller animated:YES];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
