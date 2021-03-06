//
//  XViewController.m
//  Cam Saül
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import <objc/runtime.h>

#import "XViewController.h"
#import "NSDictionary+X.h"
#import "XRuntimeUtilities.h"
#import "XLogging.h"

@implementation XViewController

+ (void)validateParams:(NSDictionary *)params {}; // default implementation does nothing

/// We don't want to accidentally call setup multiple times is various subclasses do/don't implement different versions of init, etc
ASSOC_PROP_STRONG(NSNumber *, hasCalledSetup, setHasCalledSetup);

/// helper to look for nib by classname, since self.class is virtual
- (NSString *)nibNameForClass:(Class)class {
	// base case, return whatever UIViewController would return
	if (class == XViewController.class) {
		return [super nibName];
	}
	
	// check for suffixed name
	NSString *suffixedName = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(class), [NSBundle mainBundle].infoDictionary[@"CFBundleName"]];
	if ([[NSBundle mainBundle] pathForResource:suffixedName ofType:@"nib"]) {
		XLog(self, LogFlagInfo, @"Resolved suffixed nib name: %@", suffixedName);
		return suffixedName;
	}
	
	// check for non-prefixed name
	if ([[NSBundle mainBundle] pathForResource:NSStringFromClass(class) ofType:@"nib"]) {
		return NSStringFromClass(class);
	}
	
	// recurse
	return [self nibNameForClass:class.superclass];
}

- (NSString *)nibName {
	// return name set by UIViewController via initWithNibNamed if it is != NSStringFromClass(self.class)
	if ([super nibName] && ![[super nibName] isEqualToString:NSStringFromClass(self.class)]) return [super nibName];

	return [self nibNameForClass:self.class];
}

- (instancetype)init {
	if (self = [super init]) [self callSetup];
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) [self callSetup];
	return self;
}

- (instancetype)initWithParams:(NSDictionary *)params {
	if (self = [super init]) {
		_params = params;
        if (params[XNavigationServiceDelegateParam]) {
            if ([self respondsToSelector:@selector(setDelegate:)]) {
                [(id)self setDelegate:params[XNavigationServiceDelegateParam]];
                _params = [_params dictionaryBySettingValue:nil forKey:XNavigationServiceDelegateParam];
            }
        }
		[self callSetup];
	}
	return self;
}

- (void)awakeFromNib {
	[self callSetup];
}

/// Helper to check self.hasCalledSetup so we don't do it more than once
- (void)callSetup {
	if (self.hasCalledSetup) return; // already done
	self.hasCalledSetup = @YES;
	[self setup];
}

/// default implementation does nothing
- (void)setup {}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
