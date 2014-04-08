//
//  PhotoViewController.m
//  JoinUp
//
//  Created by solid on 24.03.14.
//  Copyright (c) 2014 Bros Universe. All rights reserved.
//

#import "PhotoViewController.h"
#import "XMPPWrapper.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePhoto:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [[self navigationController] presentViewController:picker animated:YES completion:nil];
    }
    
}

- (IBAction)takePhoto:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker= [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [[self navigationController] presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    NSData* transformImageData = [image transformation];
    UIImage *avatar = [[UIImage alloc] initWithData:transformImageData];
    
    if ([self uploadPhoto:transformImageData]) {
        [[Profile sharedInstance] setImgAvatar:avatar];
        [_photoView setImage:[[Profile sharedInstance] imgAvatar]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatar" object:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        // TODO: [avatar maskImage:[UIImage imageNamed:@"maska"]]
        XMPPvCardTemp *xmppvCardTemp = [[[XMPPWrapper sharedInstance] xmppvCardTempModule] myvCardTemp];
        [xmppvCardTemp setPhoto:transformImageData];
        [[[XMPPWrapper sharedInstance] xmppvCardTempModule] updateMyvCardTemp:xmppvCardTemp];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Set Photo"
                                  message:[NSString stringWithFormat:@"Photo not upload"]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (void)showPhoto:(id)data {
    
    _photoView = [[UIImageView alloc] initWithImage:data];
    [_photoView setFrame:CGRectMake(0, self.view.bounds.size.height / 4,
                            self.view.bounds.size.width,
                            self.view.bounds.size.height / 2)];
    [_photoView setImage:data];
    [self.view addSubview:_photoView];
    
}

- (BOOL)uploadPhoto: (NSData *)imageData {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    // RP: Empaquetando datos
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[NSString stringWithFormat:@"%@", [[Profile sharedInstance] jabberID]] forKey:@"login"];
    [_params setObject:[NSString stringWithFormat:@"%@", [[Profile sharedInstance] passwd]] forKey:@"password"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'
    NSString *FileParamConstant = @"avatar";
    
    //RP: Configurando la dirección
    NSURL *requestURL = [[NSURL alloc] initWithString:@"http://192.168.1.100/profile/change_photo.php"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    
    if (imageData) {
        printf("appending image data\n");
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\'%@\'; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",str);
    
    if ([str isEqualToString:@"18"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
