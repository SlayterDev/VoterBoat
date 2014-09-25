//
//  LoginSignupController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 9/25/14.
//
//

#import "LoginSignupController.h"

@interface LoginSignupController ()

@end

@implementation LoginSignupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItemx
	
	fields = [NSMutableArray array];
	
	[self.tableView setContentInset:UIEdgeInsetsMake(125, 0, 0, 0)];
	[self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1289493_21101753.jpg"]]];
	
	CGSize scrSize = [[UIScreen mainScreen] bounds].size;
	
	UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(scrSize.width/2 - 150, -120, 300, 150)];
	titleLbl.text = (_signup) ? @"Log In" : @"Sign Up";
	titleLbl.textAlignment = NSTextAlignmentCenter;
	
	titleLbl.font = [UIFont fontWithName:@"Pacifico" size:70];
	titleLbl.textColor = [UIColor whiteColor];
	[self.view addSubview:titleLbl];
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
    if (!_signup)
		return 5;
	else
		return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
    // Configure the cell...
	UITextField *tf;
	switch (indexPath.row) {
		case 0:
			tf = [self createTextFieldWithPlaceholder:@"Username"];
			break;
		case 1:
			if (_signup)
				tf = [self createTextFieldWithPlaceholder:@"Password"];
			else
				tf = [self createTextFieldWithPlaceholder:@"Student ID"];
			break;
		case 2:
			// College selction
			tf = [self createTextFieldWithPlaceholder:@"College"];
			break;
		case 3:
			tf = [self createTextFieldWithPlaceholder:@"Password"];
			break;
		case 4:
			tf = [self createTextFieldWithPlaceholder:@"Confirm Password"];
			break;
		default:
			break;
	}
	tf.tag = indexPath.row;
	[fields insertObject:tf atIndex:indexPath.row];
	[tf addTarget:self action:@selector(goToNextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	if ((_signup && indexPath.row == 1) || (!_signup && indexPath.row == 4))
		tf.returnKeyType = UIReturnKeyGo;
	else
		tf.returnKeyType = UIReturnKeyNext;
	
	[cell addSubview:tf];
	
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];
	
    return cell;
}

-(UITextField *) createTextFieldWithPlaceholder:(NSString *)placeholder {
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, [[UIScreen mainScreen] bounds].size.width - 10, 35)];
	tf.placeholder = placeholder;
	
	if ([placeholder rangeOfString:@"Password"].location != NSNotFound)
		tf.secureTextEntry = YES;
	
	if ([placeholder isEqualToString:@"Student ID"])
		tf.keyboardType = UIKeyboardTypeNumberPad;
	
	
	return tf;
}

-(void) goToNextField:(id)sender {
	NSLog(@"Go to next");
	UITextField *tf = (UITextField *)sender;
	int newTag = (int)tf.tag ***REMOVED*** 1;
	
	if (newTag < fields.count) {
		UITextField *newTf = [fields objectAtIndex:newTag];
		[newTf becomeFirstResponder];
	} else {
		if ([self checkPasswords]) {
			[[[UIAlertView alloc] initWithTitle:@"Welcome" message:@"You have \"signed up\"" delegate:nil cancelButtonTitle:@"Yay?" otherButtonTitles:nil] show];
		} else {
			[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your password does not match the confirm field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
			UITextField *pass = [fields objectAtIndex:3];
			[pass becomeFirstResponder];
		}
	}
}

-(BOOL) checkPasswords {
	if (!_signup) {
		UITextField *pass1 = [fields objectAtIndex:3];
		UITextField *pass2 = [fields objectAtIndex:4];
		
		if ([pass1.text isEqualToString:pass2.text])
			return YES;
		else
			return NO;
	}
	
	return YES;
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
