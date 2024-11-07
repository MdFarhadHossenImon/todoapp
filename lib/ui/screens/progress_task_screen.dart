import 'package:flutter/material.dart';
import 'package:project01/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:project01/ui/widgets/task_card.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskListInProgress = false;
  List<TaskModel> _progressTaskList = [];
  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getProgressTaskListInProgress,
      replacement: CenteredCircularProgressIndicator(),
      child: ListView.separated(
        itemCount: _progressTaskList.length,
        itemBuilder: (context, index) {
          return  TaskCard(
            taskModel:_progressTaskList[index],
            onRefreshList: _getProgressTaskList,

          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _progressTaskList.clear();
    _getProgressTaskListInProgress= true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.progressTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _progressTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }
}