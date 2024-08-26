import 'package:get/get.dart';
import 'package:starter/app/data/repository/user_repository.dart';
import 'package:starter/app/theme/app_colors.dart';
import 'package:starter/base/base_controller.dart';
import 'package:starter/utils/confetti/confetti.dart';
import 'package:starter/utils/helper/text_field_wrapper.dart';

class AuthLoginController extends BaseController<UserRepository> {
  final mobileWrapper = TextFieldWrapper();

  sendOTP() async {
    String mobile = mobileWrapper.controller.text.trim();
    Confetti.showWithPrimary(Get.overlayContext!, AppColors.confetti);
    //   if (mobile.isValidPhone()) {
    //     mobileWrapper.errorText = Strings.empty;
    //   } else {
    //     mobileWrapper.errorText = ErrorMessages.invalidPhone;
    //     return;
    //   }
    //
    //   LoadingUtils.showLoader();
    //   RepoResponse<bool> response =
    //       await repository.sendOTP(SendOTPRequest(phone: mobile));
    //   LoadingUtils.hideLoader();
    //
    //   if (response.data ?? false) {
    //     Get.toNamed(Routes.AUTH_VERIFY_OTP, arguments: mobile);
    //   } else {
    //     mobileWrapper.errorText = response.error?.message ?? "";
    //   }
  }
}
