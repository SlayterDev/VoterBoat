//
//  CandidatesController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 9/30/14.
//
//

#import "CandidatesController.h"

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
	
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(260, 0, 0, 0)];
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"USA-White-House.jpg"]];
	iv.frame = CGRectMake(0, -260, self.view.bounds.size.width, 260);
	[self.view addSubview:iv];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, -75, self.view.bounds.size.width - 30, 75)];
	lbl.font = [UIFont fontWithName:@"HelveticaNeue-light" size:45];
	lbl.text = @"Executive";
	[self.view addSubview:lbl];
	lbl.textColor = [UIColor whiteColor];
	
	colors = @[[UIColor colorWithRed:(68/255) green:(96/255) blue:(122/255) alpha:1.0], [UIColor colorWithRed:(231/255) green:(76/255) blue:(60/255) alpha:1.0], [UIColor colorWithRed:(0/255) green:(196/255) blue:(215/255) alpha:1.0], [UIColor colorWithRed:(0/255) green:(195/255) blue:(137/255) alpha:1.0], [UIColor colorWithRed:(0/255) green:(138/255) blue:(132/255) alpha:1.0], [UIColor colorWithRed:(246/255) green:(194/255) blue:(66/255) alpha:1.0], [UIColor colorWithRed:(227/255) green:(108/255) blue:(38/255) alpha:1.0]];
	
	//self.view.backgroundColor = [UIColor lightGrayColor];
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
    return 8;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[colors objectAtIndex:indexPath.row % colors.count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	UIView *back = [[UIView alloc] initWithFrame:CGRectZero];
	cell.contentView.backgroundColor = [colors objectAtIndex:indexPath.row % colors.count];
	//cell.backgroundView = back;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"President";
			cell.detailTextLabel.text = @"7 candidates";
			break;
		case 1:
			cell.textLabel.text = @"Vice President";
			cell.detailTextLabel.text = @"3 candidates";
			break;
		case 2:
			cell.textLabel.text = @"Chief of Staff";
			cell.detailTextLabel.text = @"10 candidates";
			break;
		case 3:
			cell.textLabel.text = @"Chief Officer of Equity and Diversity";
			cell.detailTextLabel.text = @"1 candidates";
			break;
		case 4:
			cell.textLabel.text = @"Director of Marketing";
			cell.detailTextLabel.text = @"4 candidates";
			break;
		case 5:
			cell.textLabel.text = @"Director of Communications";
			cell.detailTextLabel.text = @"5 candidates";
			break;
		case 6:
			cell.textLabel.text = @"Director of Leadership and Development";
			cell.detailTextLabel.text = @"2 candidates";
			break;
		case 7:
			cell.textLabel.text = @"Director of Student Affairs";
			cell.detailTextLabel.text = @"3 candidates";
			break;
		default:
			break;
	}
	
	NSArray *states = @[@"Open", @"Closed", @"Register"];
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - cell.frame.size.height, 0, cell.frame.size.height, cell.frame.size.height)];
	int choice = arc4random() % states.count;
	lbl.text = [states objectAtIndex:choice];
	lbl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
	[cell.contentView addSubview:lbl];
	
    return cell;
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