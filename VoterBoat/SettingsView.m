//
//  SettingsView.m
//  VoterBoat
//
//  Created by Bradley Slayter on 10/23/14.
//
//

#import "SettingsView.h"

@interface SettingsView ()

@end

@implementation SettingsView

-(id) initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:2];
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
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	if ([userPrefs objectForKey:@"user_bio"] && [userPrefs objectForKey:@"user_pic"] && !pickingImage) {
		tv.text = [userPrefs objectForKey:@"user_bio"];
		
		NSLog(@"FILE TO LOAD: %@", [userPrefs objectForKey:@"user_pic"]);
		if (![NSData dataWithContentsOfFile:[userPrefs objectForKey:@"user_pic"]])
			NSLog(@"Something went wrong");
		iv.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[userPrefs objectForKey:@"user_pic"]]];
	}
}

-(void) saveData:(id)sender {
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	[userPrefs setObject:tv.text forKey:@"user_bio"];
	
	NSData *imageData = UIImagePNGRepresentation(iv.image);
	NSString *path = [self documentsPathForFileName:@"profilePic.png"];
	NSLog(@"Path: %@", path);
	[imageData writeToFile:path atomically:YES];
	[userPrefs setObject:path forKey:@"user_pic"];
	
	[userPrefs synchronize];
	
	[[[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Your Bio has been saved succesfully. You may now register as a candidate for elections." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
		return 44.0f;
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		return 65.0f;
	} else {
		return 130.0f;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	if (indexPath.section == 0) {
		cell.textLabel.text = @"Logout";
	} else {
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
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 25)];
			lbl.text = @"Bio";
			[cell.contentView addSubview:lbl];
			
			tv = [[UITextView alloc] initWithFrame:CGRectMake(5, 25, cell.bounds.size.width, 100)];
			tv.delegate = self;
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
	UIImage *image = info[UIImagePickerControllerEditedImage];
	iv.image = image;
	[self dismissViewControllerAnimated:YES completion:^{
		pickingImage = NO;
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
	if (indexPath.section == 1 && indexPath.row == 0) {
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
