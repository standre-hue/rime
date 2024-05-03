import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:rime/data/models/Activity.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/data/services/ActivityService.dart';
import 'package:rime/data/services/UserService.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'package:rime/presentation/widgets/CustomAppBar.dart';
import 'package:rime/presentation/widgets/CustomDrawer.dart';

class UserInfoScreen extends StatefulWidget {
  int userId;
  UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User user;
  UserService userService = UserService();
  ActivityService activityService = ActivityService();
  bool isWorking = true;

  List<Activity> activities = [];

  Future<void> getUserActivities() async {
    try {
      activities =
          await activityService.activityRepository.getUserActivities(user.id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo() async {
    try {
      user = (await userService.userRepository.findUserbyId(widget.userId))!;
      await getUserActivities();
      setState(() {
        isWorking = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isWorking = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: 'Information du Gestionnaire ',
      ),
      body: Container(
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.all(10),
        child: isWorking == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Nom',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${user.username}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(width: 150),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Role',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${user.role == 'USER' ? 'Simple Utilisateur' : 'Administrateur'}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(width: 150),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date de Création',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Crée le ${formatDate(user.createdAt)} a ${formatTime(user.createdAt)}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(width:20),
                    Spacer(),
                    ElevatedButton(
                    
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                      onPressed: (){
            
                      }, 
                      child: Text('Désactivé',style: TextStyle(color:Colors.white, fontSize:20),)
                      )
                  ],
                ),
                SizedBox(height:30),
                const Text(
                  'Liste des Activités',
                  style: TextStyle(fontSize: 22),
                ),
                Container(
                  width: _size.width,
                  height: _size.height,
                  child: SingleChildScrollView(
                    child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        columns: [
                          DataColumn2(
                            label: Text('ID'),
                            size: ColumnSize.L,
                          ),
                          DataColumn(
                            label: Text("Type"),
                          ),
                          DataColumn(
                            label: Text("Date"),
                          ),
                          DataColumn(
                            label: Text('Heure'),
                          ),
                        ],
                        rows: activities
                            .map((activity) => DataRow(
                                    // mouseCursor: MouseCursor.ha,
                                    onSelectChanged: (value) {
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoScreen(userId: user.id)));
                                      /*showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UserInfoDialog(
                                      userId: user.id,
                                    );
                                  });*/
                                    },
                                    cells: [
                                      DataCell(Text('${activity.id}')),
                                      //DataCell(Text('${activity.description}')),
                                      DataCell(Text(
                                          '${activity.getDescriptionText()}')),
                                      DataCell(Text('${formatDate(activity.createdAt)}')),
                                      DataCell(Text('${formatTime(activity.createdAt)}'))
                                    ]))
                            .toList()),
                  ),
                )
              ],
            ),
      ),
    );
  }
}
