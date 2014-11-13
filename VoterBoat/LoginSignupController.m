//
//  LoginSignupController.m
//  VoterBoat
//
//  Created by Bradley Slayter on 9/25/14.
//
//

#import "LoginSignupController.h"
#import "AFNetworking.h"
#import "DejalActivityView.h"
#import "SBJsonParser.h"
#import "SettingsView.h"

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
	
	colleges = @[@"College of Arts and Science", @"College of Business", @"Collge of Education", @"College of Engineering", @"College of Information", @"College of Merchandising", @"College of Music", @"College of Public Affaris", @"College of Visual Arts", @"School of Journalism", @"Honors College", @"TAMS", @"Toulouse Graduate School"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
	UITextField *tf;
	UIPickerView *picker;
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
			picker = [self createPickerView];
			tf.inputView = picker;
			collegeField = tf;
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
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 13, [[UIScreen mainScreen] bounds].size.width - 10, 35)];
    [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
	tf.placeholder = placeholder;
	
	if ([placeholder rangeOfString:@"Password"].location != NSNotFound)
		tf.secureTextEntry = YES;
	
	if ([placeholder isEqualToString:@"Student ID"])
		tf.keyboardType = UIKeyboardTypeNumberPad;
	
	
	return tf;
}

-(UIPickerView *) createPickerView {
	UIPickerView *picker = [[UIPickerView alloc] init];
	
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	
	return picker;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	collegeField.text = [colleges objectAtIndex:row];
	[self goToNextField:collegeField];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return colleges.count;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [colleges objectAtIndex:row];
}

-(void) goToNextField:(id)sender {
	NSLog(@"Go to next");
	UITextField *tf = (UITextField *)sender;
	int newTag = (int)tf.tag + 1;
	
	if (newTag < fields.count) {
		UITextField *newTf = [fields objectAtIndex:newTag];
		[newTf becomeFirstResponder];
	} else {
        [self checkPasswords];
	}
}

-(void) checkPasswords {
	
    if (!_signup) {
        // sign up
        NSLog(@"sign up");
		UITextField *user_name = [fields objectAtIndex:0];
		UITextField *student_id = [fields objectAtIndex:1];
        UITextField *college = [fields objectAtIndex:2];
        UITextField *password = [fields objectAtIndex:3];
        UITextField *password2 = [fields objectAtIndex:4];
        
        if ([password.text isEqualToString:password2.text])
        {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
            [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
            
            NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"controller", @"create_account", @"method", user_name.text, @"user_name", student_id.text, @"student_id", password.text, @"password", college.text, @"college", nil];
            [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [DejalActivityView removeView];
                NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                SBJsonParser *parser = [[SBJsonParser alloc] init];
                NSDictionary *response = [parser objectWithString:responseStr];
                NSLog(@"%@", responseStr);
                if ([response objectForKey:@"did_succeed"])
                {
                    //[defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
                    //[defaults setObject:@"YES" forKey:@"is_logged_in"];
                    /*UITabBarController *tabbar = [[UITabBarController alloc] init];
                    [tabbar setViewControllers:@[[[CandidatesController alloc] initWithStyle:UITableViewStylePlain], [[LegislationController alloc] initWithStyle:UITableViewStylePlain], [[ExecutiveController alloc] initWithStyle:UITableViewStylePlain], [[UINavigationController alloc] initWithRootViewController:[[SettingsView alloc] initWithStyle:UITableViewStyleGrouped]]]];
                    [self presentViewController:tabbar animated:YES completion:nil];*/
					
					[[[UIAlertView alloc] initWithTitle:@"Registered" message:@"You have been registered, you must be approved before logging in." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
					[self dismissViewControllerAnimated:YES completion:nil];
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
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your passwords do not match." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        }
	}
    else
    {
        // sign in
        NSLog(@"Sign in");
        
        UITextField *user_name = [fields objectAtIndex:0];
        UITextField *password = [fields objectAtIndex:1];
        NSLog(@"%@", user_name.text);
        NSLog(@"%@", password.text);

        [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
        [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"controller", @"sign_in", @"method", user_name.text, @"user_name", password.text, @"password", nil];
        [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [DejalActivityView removeView];
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *response = [parser objectWithString:responseStr];
            NSLog(@"%@", responseStr);
            if ([response objectForKey:@"did_succeed"])
            {
                [defaults setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
                [defaults setObject:@"YES" forKey:@"is_logged_in"];
                UITabBarController *tabbar = [[UITabBarController alloc] init];
                [tabbar setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:[[CandidatesController alloc] initWithStyle:UITableViewStylePlain]], [[UINavigationController alloc] initWithRootViewController:[[LegislationController alloc] initWithStyle:UITableViewStylePlain]], [[UINavigationController alloc] initWithRootViewController:[[ExecutiveController alloc] initWithStyle:UITableViewStylePlain]], [[UINavigationController alloc] initWithRootViewController:[[SettingsView alloc] initWithStyle:UITableViewStyleGrouped]]]];
                [self presentViewController:tabbar animated:YES completion:nil];
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
