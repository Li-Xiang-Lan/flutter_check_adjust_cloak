import 'package:adjust_sdk/adjust_event_success.dart';

abstract class CheckListener{
  beforeRequestAdjust();
  startRequestAdjust();
  adjustChangeToBuyUser();
  adjustResultCall(String network);
  adjustEventCall(AdjustEventSuccess eventSuccessData);
  firstRequestCloak();
  firstRequestCloakSuccess();
  initFirebaseSuccess();
}