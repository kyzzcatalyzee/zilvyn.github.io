#import "LPRootListController.h"

@implementation LPRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)resetPosition {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.yourname.lockposition"];
    [prefs setFloat:0 forKey:@"offsetY"];
    [prefs setFloat:0 forKey:@"offsetX"];
    [prefs synchronize];
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.yourname.lockposition/prefschanged"),
        NULL, NULL, YES);
    [self reloadSpecifiers];
}

@end
