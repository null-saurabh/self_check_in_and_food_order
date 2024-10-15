import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../client/self_checking_screen/widgets/gradient_texture.dart';
import 'admin_login_controller.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginController controller = Get.put(AdminLoginController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: Stack(
        children: [

          const BackgroundGradientTexture(
            top: 0,
            left: -30,
            assetPath: 'assets/textures/admin_login_texture_1.png',
          ),
          const BackgroundGradientTexture(
            top: 80,
            left: -52,
            assetPath: 'assets/textures/admin_login_texture_2.png',
          ),
          const BackgroundGradientTexture(
            top: -32,
            right: -36,
            assetPath: 'assets/textures/admin_login_texture_4.png',
          ),
          const BackgroundGradientTexture(
            top: 100,
            right: -36,
            assetPath: 'assets/textures/admin_login_texture_3.png',
          ),


          Container(
            margin:  EdgeInsets.only(left: 30.0, right: 30.0, top: MediaQuery.of(context).size.height * 0.12),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  const Text(
                    "Let's start with",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Admin",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 80, // Adjust this width as per your design
                    height: 3.0, // Thickness of the underline
                    color: Color(0xff36DCA4), // Green underline
                  ),
                  const SizedBox(height: 52.0),
                  // Form fields and Login Button
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 2.2,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [

                          _buildTextField(
                            controller: controller.usernameController,
                            hintText: "Username",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          _buildTextField(
                            controller: controller.passwordController,
                            hintText: "Password",
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Obx(() => GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : () {
                              controller.loginAdmin(context);
                            },
                            child: Container(
                              height: 48,
                              padding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: controller.isLoading.value
                                    ? Colors.grey
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    required String? Function(String?) validator,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFA0A093)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFA0A093)),
        ),
      ),
    );
  }
}
