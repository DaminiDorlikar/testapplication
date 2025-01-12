import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testapplication/model.dart';

class ApiCallController extends GetxController {
  ApiModel? apiModel;
  var apiList = List<Data>.of([]).obs;
  RxBool isLoading = false.obs;
  RxBool isPageLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  Future<void> fetchUsers({int page = 1}) async {
    try {
      isLoading(true);
      final url = Uri.parse('https://reqres.in/api/users?page=$page');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userResponse = ApiModel.fromJson(json);

        if (page == 1) {
          apiList.value = userResponse.data ?? [];
        } else {
          apiList.addAll(userResponse.data ?? []);
        }

        currentPage.value = userResponse.page ?? 0;
        totalPages.value = userResponse.totalPages ?? 0;
      } else {
        Get.snackbar('Error', 'Failed to load data',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Load the next page of users
  void loadNextPage() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      fetchUsers(page: currentPage.value + 1);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = false;
    fetchUsers(page: 1);
  }
}
