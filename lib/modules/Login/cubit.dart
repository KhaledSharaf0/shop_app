import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/model/shopLoginModel.dart';
import 'package:shop_app/modules/Login/states.dart';
import 'package:shop_app/shared/dio_helper.dart';
import 'package:shop_app/shared/endpoint.dart';

class ShopLoginCubit extends Cubit<ShopLoginState>{
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);


  ShopLoginModel? loginModel;

  void userLogin({required String email , required String pass}){

    emit(ShopLoginLoadingState());
    DioHelper.postData
      (url: LOGIN ,
        data: {
          'email':email,
          'password':pass
        }).then((value) {
      // print(value.data);
      // print(value.data['message']);
      loginModel = ShopLoginModel.fromJson(value.data);
      // print(loginModel!.data!.token);
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });
  }


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibilty(){

    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibilityState());
  }

}