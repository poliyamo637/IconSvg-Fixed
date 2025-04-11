#import <UIKit/UIKit.h>

__attribute__((constructor)) static void Inject() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] 
            initWithTarget:nil 
            action:@selector(showAllViews)];
        tripleTap.numberOfTapsRequired = 2;
        tripleTap.numberOfTouchesRequired = 3;
        [[[UIApplication sharedApplication] windows].firstObject addGestureRecognizer:tripleTap];
    });
}

void showAllViews() {
    NSMutableString *result = [NSMutableString stringWithString:@"=== 界面元素 ===\n"];
    UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
    
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [result appendFormat:@"🖼️ 图标: %@\n", ((UIImageView *)view).image.accessibilityIdentifier ?: @"未命名"];
        }
        else if ([view isKindOfClass:[UILabel class]]) {
            [result appendFormat:@"📛 文字: %@\n", ((UILabel *)view).text ?: @"无内容"];
        }
    }
    
    UIAlertController *alert = [UIAlertController 
        alertControllerWithTitle:@"扫描结果" 
        message:result 
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
