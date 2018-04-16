//
//  ViewController.m
//  iosOpenCV-TheCamera
//
//  Created by Sri Raghu Malireddi on 23/07/16.
//  Copyright © 2016 Sri Raghu Malireddi. All rights reserved.
//

#import "ViewController.h"

// The following lines will help to mix C++ code
#include <stdlib.h>
using namespace std;
using namespace cv;

@interface ViewController () {
    // Initialise some parameters:
    // Live output from the camera
    UIImageView *liveView;
    // OpenCV wrapper class to get camera access through AVFoundation
    CvVideoCamera *videoCamera;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup the OpenCV view
    int viewWidth = self.view.frame.size.width;
    int viewHeight = (640 * viewWidth) / 480; //Assuming 640x480 input
    int viewOffset = (self.view.frame.size.height - viewHeight) / 2;
    liveView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, viewOffset,
                                                             viewWidth, viewHeight)];
    // Add liveView as subview
    [self.view addSubview:liveView];
    
    // Initialise the Camera Parameters
    videoCamera = [[CvVideoCamera alloc] initWithParentView:liveView];
    videoCamera.delegate = self;
    
    // Choose the Front or Rear facing Camera
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    // Set the image resolution
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    // Set the device orientation
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    
    self->videoCamera.rotateVideo = YES;
    
    // Start the camera capture
    [videoCamera start];
}

- (void)processImage:(cv::Mat &)image;
{
    // Convert the image to grayscale
    Mat gray; cvtColor(image, gray, CV_BGRA2RGB);
    
    rectangle(gray, cv::Point(0.2*image.cols,0.2*image.rows), cv::Point(0.8*image.cols,0.8*image.rows), cv::Scalar(255,0,0),5);
    
    //Copy it back to image
    cvtColor(gray, image, CV_RGB2BGRA);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
