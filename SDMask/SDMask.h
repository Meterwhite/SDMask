#import "SDMaskProtocol.h"
#import "SDMaskInterface.h"
#import "SDMaskController.h"
#import "SDMaskView.h"
#import "SDMaskBindingEvent.h"
#import "SDMaskModel.h"
#import "UIResponder+SDMask.h"
#import "SDMaskNotificationName.h"
#import "SDMaskGuidController.h"

#pragma mark - Notification name for user
/**
 * Dismiss specified or all mask view.(发送此通知以使蒙层消失)
 * object = nil : Dismiss all mask view.
 * object = userView : Specified mask object or user's view.
*/
#define SDMaskDismissNotification \
SDMaskNotificationName.needDismiss
/**
 * Get event object using nofication.(此通知可以监听SDMask的事件)
 * userInfo[@"event"] = SDMaskBindingEvent
*/
#define SDMaskUserInteractionNotification \
SDMaskNotificationName.userInteraction

