//
//  UserInfoVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "UserInfoVController.h"


@interface UserInfoVController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtCellPhone;
@property (copy, nonatomic) NSString *imgHeadPos;
@end

@implementation UserInfoVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(btnSaveData)];
    
//    self.imgHeadPos = @"";
//    self.txtCellPhone.text = [Login sharedInstance].user.ContactPhone;
//    self.txtCellPhone.enabled = NO;
//    self.txtUserName.text = [Login sharedInstance].user.UserName;
//    
//    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[Login sharedInstance].user.UserPhotoUrl] placeholderImage:[UIImage imageNamed:@"none_login"]];
//    [self setCircleHeadImage:self.imgHead];
//    self.imgHead.userInteractionEnabled = YES;
    WeakSelfType _blockSelf = self;
    [self.imgHead bk_whenTapped:^{
        [_blockSelf.txtUserName resignFirstResponder];
        [_blockSelf getImageByDevice];
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 保存数据
- (void)btnSaveData
{
    NSDictionary *dictParam = @{@"UserId":[Login sharedInstance].userID,@"UserName":self.txtUserName.text.trimString};
    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttUpLoadImgWithAPI:KUpdateUserInfo andWordDictParam:dictParam andImage:[UIImage imageWithContentsOfFile:self.imgHeadPos] requestSuccessed:^(id responseObject) {
        [self hideHUDLoading];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
}

- (void)keyboardExit
{
    [self.txtUserName resignFirstResponder];
}

#pragma mark - 图片选择
- (void)getImageByDevice
{
    UIActionSheet *imgActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地相册获取", nil];
    [imgActionSheet showInView:self.view];
}

// 选择图片来源
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    switch (buttonIndex) {
            // 打开相机
        case 0:
            [self takePhoto];
            break;
            // 从本地相册获取
        case 1:
            [self GetLocalPhoto];
            break;
        default:
            break;
    }
}
// 打开相机
-(void)takePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
        
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        [self presentViewController:imgPicker animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView* alert= [[UIAlertView alloc]
                             initWithTitle:@"操作相机失败"
                             message:[NSString stringWithFormat:@"你的设备不支持相机或者相机不被访问"]
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil, nil];
        [alert show];
    }
}
// 从本地相册获取
-(void)GetLocalPhoto
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSData *imgData;
        //        if (UIImagePNGRepresentation(image) == nil)
        //        {
        imgData = UIImageJPEGRepresentation(image, 0.7);
        //        }
        //        else
        //        {
        //            imgData = UIImagePNGRepresentation(image);
        //        }
        // 关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIImage *img = [UIImage imageWithData:imgData];
   
        self.imgHead.image = img;
        [self setCircleHeadImage:self.imgHead];
        NSString *imgPath = [self SaveImageToDocument:@"/imgHead.png" withImageData:imgData];
        NSLog(@"imgPath: %@",imgPath);
        self.imgHeadPos = imgPath;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

// 保存图片路径
-(NSString *)SaveImageToDocument:(NSString *)imgName withImageData:(NSData *)data
{
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgName] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgName];
    return filePath;
}
@end
