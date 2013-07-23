/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#include "Decoder.h"
#include "parsedResults/ParsedResult.h"
#include "ScanOverlayView.h"
//#include "UCFieldEditor.h"
#include "BaseViewController.h"

@protocol ScanProtocol;

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif

@interface ScanWidgetController : BaseViewController <DecoderDelegate,
ScanOverlayProtocol/*, UCFieldEditorDelegate*/, UINavigationControllerDelegate
#if HAS_AVFF
, AVCaptureVideoDataOutputSampleBufferDelegate
#endif
> {
	NSSet *readers;
	ParsedResult *result;
	ScanOverlayView *overlayView;
	SystemSoundID beepSound;
	BOOL showCancel;
	NSURL *soundToPlay;
	id<ScanProtocol> delegate;
	BOOL wasCancelled;
	BOOL oneDMode;
#if HAS_AVFF
	AVCaptureSession *captureSession;
	AVCaptureVideoPreviewLayer *prevLayer;
#endif
	BOOL decoding;
	BOOL isStatusBarHidden;
	IBOutlet UIBarButtonItem *countButton;
	NSTimer* closeTimer;
	UIBarButtonItem *batteryButton;
	
	int readingTimeOut;
}

#if HAS_AVFF
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
#endif
@property (nonatomic, strong ) NSSet *readers;
@property (nonatomic, strong) id<ScanProtocol> delegate;
@property (nonatomic, strong) NSURL *soundToPlay;
@property (nonatomic, strong) ParsedResult *result;
@property (nonatomic, strong) ScanOverlayView *overlayView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *countButton;

- (id)initWithDelegate:(id<ScanProtocol>)delegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode;
- (void)setupWithDelegate:(id<ScanProtocol>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode;

- (BOOL)fixedFocus;
- (void)setTorch:(BOOL)status;
- (BOOL)torchIsOn;
- (void)restartCapture;
- (void)startCloseTimer;
- (void)handleCloseTimer:(NSTimer*)theTimer;

@end

@protocol ScanProtocol
- (void)zxingController:(ScanWidgetController *)controller didScanResult:(NSString *)result manualMode:(BOOL)manual;
- (void)zxingControllerDidCancel:(ScanWidgetController*)controller;
@end
