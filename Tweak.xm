#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/vm_map.h>

uintptr_t unityBase;
uintptr_t getRealOffset(uintptr_t offset) { return unityBase + offset; }

void patchMemory(uintptr_t address, const void *bytes, size_t size) {
    if (!address) return;
    vm_protect(mach_task_self(), address, size, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    memcpy((void *)address, bytes, size);
}

@interface MysizPanel : UIWindow
@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UISwitch *aimbotSwitch;
@property (nonatomic, strong) UISwitch *espSwitch;
@end

@implementation MysizPanel

+ (instancetype)shared {
    static MysizPanel *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MysizPanel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return shared;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.backgroundColor = [UIColor clearColor];
        self.rootViewController = [UIViewController new];
        self.hidden = NO;

        self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.floatButton.frame = CGRectMake(20, 100, 50, 50);
        self.floatButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:0.8];
        self.floatButton.layer.cornerRadius = 25;
        [self.floatButton setTitle:@"M" forState:UIControlStateNormal];
        self.floatButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [self.floatButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.floatButton addGestureRecognizer:pan];
        [self.rootViewController.view addSubview:self.floatButton];

        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
        self.menuView.center = self.center;
        self.menuView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        self.menuView.layer.cornerRadius = 15;
        self.menuView.hidden = YES;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300, 30)];
        title.text = @"MYSIZ IOS PANEL";
        title.textColor = [UIColor redColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:20];
        [self.menuView addSubview:title];
        
        self.espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 60, 50, 30)];
        [self.espSwitch addTarget:self action:@selector(toggleESP:) forControlEvents:UIControlEventValueChanged];
        UILabel *espLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 150, 30)];
        espLabel.text = @"ESP (Wallhack)";
        espLabel.textColor = [UIColor whiteColor];
        [self.menuView addSubview:espLabel];
        [self.menuView addSubview:self.espSwitch];
        
        self.aimbotSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(220, 110, 50, 30)];
        [self.aimbotSwitch addTarget:self action:@selector(toggleAimbot:) forControlEvents:UIControlEventValueChanged];
        UILabel *aimLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 150, 30)];
        aimLabel.text = @"Aimbot (Cabeca)";
        aimLabel.textColor = [UIColor whiteColor];
        [self.menuView addSubview:aimLabel];
        [self.menuView addSubview:self.aimbotSwitch];
        [self.rootViewController.view addSubview:self.menuView];
    }
    return self;
}

- (void)toggleMenu { self.menuView.hidden = !self.menuView.hidden; }

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    self.floatButton.center = CGPointMake(self.floatButton.center.x + translation.x, self.floatButton.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self];
}

- (void)toggleESP:(UISwitch *)sender {
    uint32_t val = sender.isOn ? 1 : 0;
    patchMemory(getRealOffset(0x1A2B3C4D), &val, sizeof(val)); 
}

- (void)toggleAimbot:(UISwitch *)sender {
    uint32_t val = sender.isOn ? 1 : 0;
    patchMemory(getRealOffset(0x5E6F7G8H), &val, sizeof(val));  
}
@end

%ctor {
    unityBase = _dyld_get_image_vmaddr_slide(0); 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MysizPanel shared];
    });
}
