//
//  SettingsView.m
//  VoterBoat
//
//  Created by Bradley Slayter on 10/23/14.
//
//

#import "SettingsView.h"
#import "AFNetworking.h"
#import "SBJsonParser.h"
#import "DejalActivityView.h"

@interface SettingsView ()

@end

@implementation SettingsView

-(id) initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"settings-32.png"] tag:3];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveData:)];
	self.navigationItem.rightBarButtonItem = saveBtn;
	
	cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)];
	
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.title = @"Settings";
	
	if (!pickingImage) {
		[self getBio];
		NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
		[iv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.usesweetspot.com/images/users/%@voterboat.jpeg", [userPrefs objectForKey:@"user_id"]]] placeholderImage:nil];
	}
	/*NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	 
	if ([userPrefs objectForKey:@"user_bio"] && [userPrefs objectForKey:@"user_pic"] && !pickingImage) {
		tv.text = [userPrefs objectForKey:@"user_bio"];
		
		NSLog(@"FILE TO LOAD: %@", [userPrefs objectForKey:@"user_pic"]);
		if (![NSData dataWithContentsOfFile:[userPrefs objectForKey:@"user_pic"]])
			NSLog(@"Something went wrong");
		iv.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[userPrefs objectForKey:@"user_pic"]]];
	}*/
}


- (void)getBio
{
	[DejalBezelActivityView activityViewForView:self.view withLabel:@""];
	[DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
	
	NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"controller", @"get_user_bio", @"method", [defaults objectForKey:@"user_id"], @"user_id", nil];
	[httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[DejalActivityView removeView];
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *response = [parser objectWithString:responseStr];
		NSLog(@"%@", responseStr);
		if ([response objectForKey:@"did_succeed"])
		{
			tv.text = [response objectForKey:@"bio"];
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

-(void) saveData:(id)sender {
	
	if ([tv.text isEqualToString:@""]) {
		[[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must fill out your bio before saving." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
		return;
	}
	
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"controller", @"update_bio", @"method", [defaults objectForKey:@"user_id"], @"user_id", tv.text, @"bio", nil];
    [httpClient postPath:[defaults objectForKey:@"apiFile"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [DejalActivityView removeView];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *response = [parser objectWithString:responseStr];
        NSLog(@"%@", responseStr);
        if ([response objectForKey:@"did_succeed"])
        {
            [defaults setObject:@"YES" forKey:@"bio_setup"];
            [defaults setObject:tv.text forKey:@"user_bio"];
            [[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Your Bio has been saved successfully. You may now register as a candidate for elections." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            [tv resignFirstResponder];
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

-(void) cancelEdit:(id)sender {
	[tv resignFirstResponder];
	self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return (section == 0) ? 1 : 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 54.0f;
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		return 65.0f;
	} else {
		return 140.0f;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	if (indexPath.section == 0) {
		cell.textLabel.text = @"Logout";
	} else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Profile Picture";
			// TODO: get picture
			iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-65, 0, 65, 65)];
			iv.contentMode = UIViewContentModeScaleAspectFill;
			iv.backgroundColor = [UIColor blackColor];
			iv.image = [UIImage imageNamed:@"cameraSquared.png"];
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePicture:)];
			[iv addGestureRecognizer:tap];
			[cell.contentView addSubview:iv];
			
		} else {
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 16, 100, 25)];
			lbl.text = @"Bio";
            lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
			[cell.contentView addSubview:lbl];
			
			tv = [[UITextView alloc] initWithFrame:CGRectMake(12, 40, cell.bounds.size.width, 100)];
			tv.delegate = self;
            tv.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
			[cell.contentView addSubview:tv];
		}
	}
	
    return cell;
}

-(void) choosePicture:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture", @"Choose from library", nil];
	[actionSheet showInView:self.view];
}

-(void) showPicker:(int)library {
	UIImagePickerController *controller = [[UIImagePickerController alloc] init];
	controller.sourceType = (library) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
	controller.allowsEditing = YES;
	controller.delegate = self;
	
	pickingImage = YES;
	[self presentViewController:controller animated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"Finished picking");
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
	UIImage *image = info[UIImagePickerControllerEditedImage];
	iv.image = image;
	[self dismissViewControllerAnimated:YES completion:^{
		pickingImage = NO;
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"users", @"controller", @"update_profile_photo", @"method",
                                [defaults objectForKey:@"user_id"], @"user_id", nil];
        NSData *imageToUpload = UIImageJPEGRepresentation(iv.image, 100);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/API.php", [defaults objectForKey:@"api_url"]]];
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:url];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:[defaults objectForKey:@"apiFile"] parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            if (iv.image != nil)
            {
                [formData appendPartWithFileData: imageToUpload name:@"file" fileName:@".jpeg" mimeType:@"image/jpeg"];
            }
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(responseStr);
            NSData *imageData = UIImagePNGRepresentation(iv.image);
            NSString *path = [self documentsPathForFileName:@"profilePic.png"];
            NSLog(@"Path: %@", path);
            [imageData writeToFile:path atomically:YES];
            [userPrefs setObject:path forKey:@"user_pic"];
            [userPrefs synchronize];
            [DejalActivityView removeView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if([operation.response statusCode] == 403){
                NSLog(@"Upload Failed");
                return;
            }
            NSLog(@"error: %@", [operation error]);
            
        }];
        
        [operation start];
	}];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self showPicker:0];
			break;
		case 1:
			[self showPicker:1];
		default:
			break;
	}
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView {
	self.navigationItem.leftBarButtonItem = cancelBtn;
	
	return YES;
}

-(NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	
	return [documentsPath stringByAppendingPathComponent:name];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
        [defaults removeObjectForKey:@"user_id"];
        [defaults removeObjectForKey:@"user_bio"];
        [defaults removeObjectForKey:@"setup_bio"];
        [defaults removeObjectForKey:@"user_pic"];
        [defaults removeObjectForKey:@"is_logged_in"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
	else if (indexPath.section == 1 && indexPath.row == 0) {
		[self choosePicture:iv];
	}
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
