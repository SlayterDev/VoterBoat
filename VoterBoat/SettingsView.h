//
//  SettingsView.h
//  VoterBoat
//
//  Created by Bradley Slayter on 10/23/14.
//
//

#import <UIKit/UIKit.h>

@interface SettingsView : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {
	UITextView *tv;
	UIImageView *iv;
	
	UIBarButtonItem *cancelBtn;
	
	BOOL pickingImage;
}

@end
