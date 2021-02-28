import 'package:flutterclientsample/domain/entities/models/details.dart';
import 'package:flutterclientsample/domain/entities/models/user.dart';

abstract class DetailsRepository {

  Future<List<Details>> getDetails(User item);

}