#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString *const kPrefsDomain = @"com.yourname.lockposition";
static CFStringRef const kPrefsChanged = CFSTR("com.yourname.lockposition/prefschanged");

static BOOL tweakEnabled = YES;
static CGFloat offsetY = 0;   // positif = turun, negatif = naik
static CGFloat offsetX = 0;   // positif = kanan, negatif = kiri

// Simpan referensi lemah ke view jam supaya bisa di-refresh langsung saat slider digeser
static NSHashTable *dateViews;

@interface SBFLockScreenDateView : UIView
@end

static void loadPrefs(void) {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefsDomain];
    id enabledValue = [prefs objectForKey:@"enabled"];
    tweakEnabled = enabledValue ? [enabledValue boolValue] : YES;
    offsetY = [prefs floatForKey:@"offsetY"];
    offsetX = [prefs floatForKey:@"offsetX"];
}

static void applyToView(UIView *view) {
    if (tweakEnabled) {
        view.transform = CGAffineTransformMakeTranslation(offsetX, offsetY);
    } else {
        view.transform = CGAffineTransformIdentity;
    }
}

static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in [dateViews allObjects]) {
            applyToView(view);
        }
    });
}

%hook SBFLockScreenDateView

- (void)didMoveToWindow {
    %orig;
    [dateViews addObject:self];
    applyToView(self);
}

- (void)layoutSubviews {
    %orig;
    applyToView(self);
}

%end

%ctor {
    dateViews = [NSHashTable weakObjectsHashTable];
    loadPrefs();
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        prefsChanged,
        kPrefsChanged,
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );
}
