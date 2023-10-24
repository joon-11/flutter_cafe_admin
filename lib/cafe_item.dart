import 'package:flutter/material.dart';
import 'package:flutter_cafe_admin/my_cafe.dart';

MyCafe myCafe = MyCafe();
String categoryCollectionName = 'cafe-category';
String itemCollectionName = 'cafe-item';

class CafeItem extends StatefulWidget {
  const CafeItem({super.key});

  @override
  State<CafeItem> createState() => _CafeItemState();
}

class _CafeItemState extends State<CafeItem> {
  dynamic body = const Text('Loading...');

  Future<void> getCategory() async {
    setState(() {
      body = FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            var datas = snapshot.data?.docs;
            if (datas == null) {
              return const Center(
                child: Text("empty"),
              );
            }
            //진짜 데이터가 있는 곳
            //데이터가 리스트 형태이기 때문에 리스트뷰를 이용해서 하나씩 뿌려줌
            return ListView.separated(
              itemBuilder: (context, index) {
                var data = datas[index];
                return ListTile(
                  title: Text(data["categoryName"]),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case 'modify':
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CafeCategoryAddForm(id: datas[index].id),
                              ));
                          if (result == true) {
                            getCategory();
                          }
                          break;
                        case 'delete':
                          var result = await myCafe.delete(
                              collectionName: categoryCollectionName,
                              id: data.id);
                          if (result == true) {
                            getCategory();
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'modify',
                        child: Text('수정'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('삭제'),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: datas.length,
            );
          } else {
            //아직 기다리는 중
            return const Center(
              child: Text("불러오는중"),
            );
          }
        },
        future: myCafe.get(
          collectionName: categoryCollectionName,
          id: null,
          fieldName: null,
          fieldValue: null,
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CafeCategoryAddForm(id: null),
            ),
          );
          if (result) {
            getCategory();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CafeCategoryAddForm extends StatefulWidget {
  String? id;
  CafeCategoryAddForm({super.key, required this.id});

  @override
  State<CafeCategoryAddForm> createState() => _CafeCategoryAddFormState();
}

class _CafeCategoryAddFormState extends State<CafeCategoryAddForm> {
  TextEditingController controller = TextEditingController();

  String? id;
  var isUsed = true;

  Future<dynamic> getData({required String id}) async {
    var data = await myCafe.get(
      collectionName: categoryCollectionName,
      id: id,
      fieldName: null,
      fieldValue: null,
    );
    setState(() {
      controller.text = data['categoryName'];
      isUsed = data['isUsed'];
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
    if (id != null) {
      getData(id: id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("category add"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                var data = {
                  'categoryName': controller.text,
                  'isUsed': isUsed,
                };
                var result = id != null
                    ? await myCafe.update(
                        collectionName: categoryCollectionName,
                        id: id!,
                        data: data,
                      )
                    : await myCafe.insert(
                        collectionName: categoryCollectionName,
                        data: {
                          'categoryName': controller.text,
                          'isUsed': isUsed,
                        },
                      );
                if (result) {
                  Navigator.pop(context, true);
                }
              }
            },
            child: const Text(
              'save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('category name'),
              border: OutlineInputBorder(),
            ),
            controller: controller,
          ),
          SwitchListTile(
            title: const Text("used?"),
            value: isUsed,
            onChanged: (value) {
              setState(
                () {
                  isUsed = value;
                },
              );
            },
          )
        ],
      ),
    );
  }
}
