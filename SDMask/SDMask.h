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
 * Dismiss specified or all mask view.(发送此通知以消失蒙层)
 * object = nil : dismiss all mask view.
 * object = Specified mask view or user view.
*/
#define SDMaskDismissNotification \
SDMaskNotificationName.needDismiss
/**
 * Get event object using nofication.(外部可以监听SDMask的事件)
 * userInfo[@"event"] = SDMaskBindingEvent
*/
#define SDMaskUserInteractionNotification \
SDMaskNotificationName.userInteraction

