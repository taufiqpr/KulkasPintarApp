import 'package:fridgeeye/app/data/recipe_provider.dart';
import 'package:get/get.dart';

class RecipeController extends GetxController {
  var recipes = <dynamic>[].obs;
  var recipeDetail = {}.obs;
  var isDetailLoading = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLiked = false.obs;
  var likedRecipes = <int, Map<String, dynamic>>{}.obs;

  final _recipeProvider = Get.find<RecipeProvider>();

  @override
  void onInit() {
    super.onInit();
    fetchRecipes('apple');
  }

  Future<void> fetchRecipes(String query) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      print('Querying recipes for: $query');

      var response = await _recipeProvider.getRecipes(query);
      print('Received response: $response');

      recipes.value = response.map((recipe) {
        return {
          'id': recipe['id'],
          'title': recipe['title'] ?? '-',
          'image': recipe['image'] ?? '',
          'duration': recipe['readyInMinutes'] != null
              ? '${recipe['readyInMinutes']} Menit'
              : 'Waktu tidak tersedia',
        };
      }).toList();
    } catch (e, stackTrace) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      print('Error saat fetchRecipes: $e');
      print('StackTrace: $stackTrace');
    } finally {
      isLoading(false);
    }
  }

  void toggleLike(Map<String, dynamic> recipe) {
    int id = recipe['id'];
    if (likedRecipes.containsKey(id)) {
      likedRecipes.remove(id);
    } else {
      likedRecipes[id] = recipe;
    }
  }

  bool isRecipeLiked(int id) {
    return likedRecipes.containsKey(id);
  }

  Future<void> fetchRecipeDetail(int id) async {
    try {
      isDetailLoading(true);
      final response = await _recipeProvider.getRecipeDetail(id);
      recipeDetail.value = response;
    } catch (e) {
      print('Gagal mengambil detail resep: $e');
      recipeDetail.value = {};
    } finally {
      isDetailLoading(false);
    }
  }
}
