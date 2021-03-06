//
//  CandidateListController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 10/21/14.
//
//

#import "CandidateListController.h"
#import "AFNetworking.h"
#import "DejalActivityView.h"
#import "SBJsonParser.h"
#import "CandidateProfileController.h"

@interface CandidateListController ()

@end

@implementation CandidateListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSString *path;
	switch (self.picture) {
		case 0:
			path = @"USA-White-House.jpg";
			break;
		case 1:
			path = @"735561B2-EA29-4D18-9B75-F15714D7C7D0_mw1024_s_n.jpg";
			break;
		case 2:
			path = @"o-SUPREME-COURT-facebook.jpg";
			break;
		default:
			break;
	}
	
	[self.tableView setContentInset:UIEdgeInsetsMake(260, 0, 0, 0)];
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
	iv.frame = CGRectMake(0, -260, self.view.bounds.size.width, 260);
	iv.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:iv];
    
    self.title = @"Candidates";
	
	UIView *view = [[UIView alloc] initWithFrame:iv.frame];
	view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.19];
	[self.view addSubview:view];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, -75, self.view.bounds.size.width - 30, 75)];
	lbl.font = [UIFont fontWithName:@"HelveticaNeue-light" size:45];
	lbl.text = self.branch;
	[self.view addSubview:lbl];
	lbl.textColor = [UIColor whiteColor];
	
	colors = @[[UIColor colorWithRed:68.0/255.0 green:96.0/255.0 blue:122.0/255.0 alpha:1.0], [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:196.0/255.0 blue:215.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:195.0/255.0 blue:137.0/255.0 alpha:1.0], [UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:132.0/255.0 alpha:1.0], [UIColor colorWithRed:246.0/255.0 green:194.0/255.0 blue:66.0/255.0 alpha:1.0], [UIColor colorWithRed:227.0/255.0 green:108.0/255.0 blue:38.0/255.0 alpha:1.0]];
	
	self.tableView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:223.0/255.0 blue:225.0/255.0 alpha:1.0];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self loadCandidates];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)loadCandidates
{
	[DejalBezelActivityView activityViewForView:self.view withLabel:@""];
	[DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
	
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	NSLog(@"USER ID: %@", [defaults objectForKey:@"user_id"]);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"elections", @"controller", @"get_candidates", @"method", [defaults objectForKey:@"user_id"], @"user_id", [NSString stringWithFormat:@"%d", self.electionID], @"election_id", nil];
	[httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[DejalActivityView removeView];
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *response = [parser objectWithString:responseStr];
		NSLog(@"%@", responseStr);
		if ([response objectForKey:@"did_succeed"])
		{
			candidates = [response objectForKey:@"data"];
			NSLog(@"%@", candidates);
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
    return candidates.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[colors objectAtIndex:(indexPath.row % colors.count)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	cell.textLabel.text = [[candidates objectAtIndex:indexPath.row] objectForKey:@"user_name"];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - cell.frame.size.height-30, 0, cell.frame.size.height+30, 60.0f)];
    lbl.text = @"Info";
	/*if ([[[candidates objectAtIndex:indexPath.row] objectForKey:@"open"] isEqualToString:@"T"])
		lbl.text = @"Open";
	else
		lbl.text = @"Closed";*/
	lbl.textAlignment = NSTextAlignmentCenter;
	lbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
	[cell.contentView addSubview:lbl];
	
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
	lbl.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	
	return cell;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CandidateProfileController *newView = [[CandidateProfileController alloc] initWithNibName:nil bundle:nil];
	newView.election_id = [[[candidates objectAtIndex:indexPath.row] objectForKey:@"election_id"] intValue];
    newView.user_id = [[[candidates objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    newView.user_name = [[candidates objectAtIndex:indexPath.row] objectForKey:@"user_name"];
	newView.open = self.open;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newView];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:nil];
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
