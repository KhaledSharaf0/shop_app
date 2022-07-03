import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/modules/Login/cubit.dart';
import 'package:shop_app/modules/Login/states.dart';
import 'package:shop_app/modules/Register/Register.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/network/shared_pref.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginState>(
        listener: (context, state) {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status!){
              print(state.loginModel.message);
              print(state.loginModel.status);
              // Fluttertoast.showToast(
              //     msg: state.loginModel.message!,
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 5,
              //     backgroundColor: Colors.green,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              showToast(
                text: state.loginModel.message!,
                state: ToastStates.SUCCESS
              );
              CacheHelper.saveData(key: 'token', value: state.loginModel.message!,).then((value) {
                navigateAndFinish(context, ShopLayout());
              });
            }else{
              showToast(
                  text: state.loginModel.message!,
                  state: ToastStates.ERROR
              );
              print(state.loginModel.message);
              // Fluttertoast.showToast(
              //     msg: state.loginModel.message!,
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 5,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              // Fluttertoast.showToast(
              //     msg: state.loginModel.message!,
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 5,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.lato(fontSize: 35),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Login now to browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        defaultTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address';
                              }
                            },
                            label: 'Enter Your Email',
                            prefix: Icons.email),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextFormField(
                            controller: passController,
                            type: TextInputType.visiblePassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            onTap: (value){
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    pass: passController.text);
                              }
                            },
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopLoginCubit.get(context).changePasswordVisibilty();
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                            },
                            label: 'Enter Your password',
                            prefix: Icons.lock),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      pass: passController.text
                                  );
                                }
                              },
                              text: 'Login',
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Don\'t have an account?"),
                            // Spacer(),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                text: "Register"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
