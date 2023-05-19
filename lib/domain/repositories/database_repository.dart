import 'package:admin/core/enum/role.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';

abstract class DatabaseRepository {
  Future<Either<model.AppError, model.Category>> getCategoryByID(
      {required String categoryId});
  Future<Either<model.AppError, bool>> createVendor(
      {required model.Vendor vendor});
  Future<String> uploadToFirestore(
      {required XFile file, required String userID});
  Future<Either<model.AppError, model.User>> updateUser(
      {required model.User user});
  Future<Either<model.AppError, model.Vendor>> updateVendor(
      {required model.Vendor vendor});
  Future<Either<model.AppError, model.Vendor>> updateVendorrr(
      {required model.Vendor vendor, required String id});
  Future<Either<model.AppError, bool>> deactivateUser(
      {required model.User user});
  Future<Either<model.AppError, bool>> activateUser({required model.User user});
  Future<Either<model.AppError, List<model.User>>> fetchUsersByType(
      UserType type);
  Future<Either<model.AppError, List<model.User>>> fetchAvailabelServiceVendors(
      UserType type, List<String> myList);
  Future<Either<model.AppError, model.Vendor>> fetchVendorByID(String uid);
  Future<Either<model.AppError, model.User>> fetchUserByID(String uid);
  Future<Either<model.AppError, List<model.Order>>> fetchOrders();
  Future<Either<model.AppError, model.Category>> createCategory(
      {required model.Category category});
  Future<Either<model.AppError, model.Vendor>> createVendorr(
      {required model.Vendor vendor});
  Future<Either<model.AppError, model.Category>> updateCategory(
      {required model.Category category});
  Future<Either<model.AppError, bool>> deactivateCategory(
      {required model.Category category});
  Future<Either<model.AppError, bool>> activateCategory(
      {required model.Category category});
  Future<Either<model.AppError, List<model.Category>>> fetchCategories();
  Future<Either<model.AppError, List<model.Service>>> fetchServices();
  Future<Either<model.AppError, bool>> deactivateService(
      {required model.Service service});
  Future<Either<model.AppError, bool>> activateService(
      {required model.Service service});
  Future<Either<model.AppError, List<model.Service>>> getServicesbyCategory(
      {required String categoryID});
  Future<Either<model.AppError, model.Service>> createService(
      {required model.Service service});
  Future<Either<model.AppError, model.ServiceRequest>> createNewServiceRequest(
      {required model.ServiceRequest serviceRequest});
  Future<Either<model.AppError, model.Service>> updateService(
      {required model.Service service});
  Future<Either<model.AppError, bool>> deleteServiceRequest(
      {required String id});
  Future<Either<model.AppError, List<model.ServiceRequest>>>
      getServiceRequestByServiceId({required String serviceId});
  Future<Either<model.AppError, model.Service>> getServiceByID(
      {required String serviceId});
  Future<Either<model.AppError, model.Transaction>> createTransaction(
      {required model.Transaction transaction});
  Future<Either<model.AppError, model.Notification>> createNotifications(
      {required model.Notification notifications});
  Future<Either<model.AppError, List<model.Notification>>> fetchNotifications();
  Future<Either<model.AppError, model.Order>> createOrder(
      {required model.Order order});
  Future<Either<model.AppError, model.Order>> updateOrder(
      {required model.Order order});
  Future<Either<model.AppError, model.Order>> fetchOrderByID(String uid);
  Future<Either<model.AppError, model.BannerDetail>> createBanner(
      {required model.BannerDetail banner});
  Future<Either<model.AppError, model.BannerDetail>> updateBanner(
      {required model.BannerDetail banner});
  Future<Either<model.AppError, bool>> deleteBanner(
      {required model.BannerDetail banner});
  Future<Either<model.AppError, List<model.BannerDetail>>> getBanners();
  Future<Either<model.AppError, model.News>> createNews(
      {required model.News news});
  Future<Either<model.AppError, model.News>> updateNews(
      {required model.News news});
  Future<Either<model.AppError, bool>> deleteNews({required model.News news});
  Future<Either<model.AppError, List<model.News>>> getNews();
  Future<Either<model.AppError, model.Stats>> createStats(
      {required model.Stats stats});
  Future<Either<model.AppError, model.Stats>> updateStats(
      {required model.Stats stats});
  Future<Either<model.AppError, bool>> deleteStats(
      {required model.Stats stats});
  Future<Either<model.AppError, List<model.Stats>>> getStats();
  Future<Either<model.AppError, model.NewsImage>> createNewsImage(
      {required model.NewsImage news});
  Future<Either<model.AppError, model.NewsImage>> updateNewsImage(
      {required model.NewsImage news});
  Future<Either<model.AppError, bool>> deleteNewsImage(
      {required model.NewsImage news});
  Future<Either<model.AppError, List<model.NewsImage>>> getNewsImage();

  Future<Either<model.AppError, model.CustomerReview>> createReview(
      {required model.CustomerReview review});
  Future<Either<model.AppError, model.CustomerReview>> updateReview(
      {required model.CustomerReview review});
  Future<Either<model.AppError, bool>> deleteReview(
      {required model.CustomerReview review});
  Future<Either<model.AppError, List<model.CustomerReview>>> getReviews();
  Future<Either<model.AppError, model.Category>> createContact(
      {required model.Category contact});
  Future<Either<model.AppError, model.Category>> updateContact(
      {required model.Category contact});
  Future<Either<model.AppError, bool>> deleteContact(
      {required model.Category contact});
  Future<Either<model.AppError, List<model.Category>>> getContactDetails();
  Future<Either<model.AppError, List<model.Order>>> getAllOrdersOfClient(
      {required String clientId});
  Future<Either<model.AppError, List<model.Order>>> getAllOrdersOfVendor(
      {required String vendorId});
  Future<Either<model.AppError, model.Order>> getOrderById(
      {required String orderId});
  Future<Either<model.AppError, model.Vendor>> getVendorById(
      {required String vendorId});
  Future<Either<model.AppError, bool>> saveOrderServiceRequestData(
      {required model.ServiceRequest newService,
      required model.ServiceRequest oldService,
      required String orderId});
}
