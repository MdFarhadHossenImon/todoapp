import 'package:get/get.dart';
import 'package:project01/data/models/network_response.dart';
import 'package:project01/data/models/task_list_model.dart';
import 'package:project01/data/models/task_model.dart';
import 'package:project01/data/services/network_caller.dart';
import 'package:project01/data/utils/urls.dart';

class NewTaskListController extends GetxController{
  bool _inProgress = false;
  String? _errorMessage;
  bool get inProgress => _inProgress;
  String? get errorMassage => _errorMessage;

  List<TaskModel> _taskList =[];
  List<TaskModel> get taskList => _taskList;

  Future<bool> getNewTaskList() async{
     bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.newTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}