
// ignore_for_file: non_constant_identifier_names

import 'package:coani/Models/Codes.dart';
import 'package:coani/Models/itemFeed.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:flutter/material.dart';

class SelectFeedList extends StatefulWidget {
  const SelectFeedList({
    Key? key,
  }) : super(key: key);

  @override
  _SelectFeedListState createState() => _SelectFeedListState();
}

class _SelectFeedListState extends State<SelectFeedList> {
  TextEditingController idsController = TextEditingController();
  bool bSearch = false;
  bool bLoaded = true;
  bool bSelectOk = false;

  int _selIndex = -1;
  List<ItemFeed> _itemList = [];
  String _findKey = "";

  @override
  void initState() {
    Future.microtask(() {
      _findKey = "";
      _fatchData();
    });
    super.initState();
  }

  void _onTab(int index) {
    _selIndex = index;
    setState(() {
      _itemList[index].bSelect = !_itemList[index].bSelect;
      bSelectOk = (_selIndex>=0) ? true : false;
    });
  }

  String _getSelectValues() {
    String codestring = "";
    if(_selIndex>=0) {
      codestring = "{${_itemList[_selIndex].id}}${_itemList[_selIndex].name}";
    }
    return codestring;
  }

  Future<void> _fatchData() async {
    await Remote.getFeed(
        category: "사료이름",
        key: _findKey,
        onResponse: (List<ItemFeed> items) async {
          setState(() {
            _itemList = items;
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {FocusScope.of(context).unfocus(); },
        child: WillPopScope(
          onWillPop: () => _onBackPressed(context),
          child: Scaffold(
              appBar: (!bSearch)
                  ? AppBar(
            centerTitle: true,
            title: Text("사료선택"),
            actions: [
              Visibility(
                visible: (!bSearch) ? true : false,
                child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        bSearch = !bSearch;
                      });
                      //Navigator.pop(context, _getSelectValues());
                    }
                ),
              ),
            ],
          )
                  : PreferredSize(
                      child: Container(),
                        preferredSize: const Size(0.0, 0.0),
                    ),

              body: (bLoaded)
                  ? Column(
                children: [
                  // search Bar
                  Visibility(
                      visible: bSearch,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10,10,10,10),
                        //padding: const EdgeInsets.fromLTRB(10,0,0,10),
                        child: TextField(
                            controller: idsController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              _findKey = value.trim();
                              _fatchData();
                            },
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, ),
                            decoration: InputDecoration(
                                hintText: "사료이름",
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                suffixIcon: IconButton (
                                  onPressed: () async {
                                    _findKey = idsController.text.trim();
                                    _fatchData();
                                  },
                                  icon: const Icon(Icons.search,),
                                  //iconSize: 24,
                                ) ,
                                prefixIcon: IconButton (
                                  onPressed: () async {
                                    closeSearch();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios,),
                                  //iconSize: 24,
                                )
                            )
                        ),
                      )
                  ),

                  Visibility(
                    visible: bLoaded,
                    child: Expanded(
                      child:ListView.builder(
                        itemCount: _itemList.length,
                          itemBuilder: (context, index){
                            ItemFeed item = _itemList[index];
                            return ListTile(
                              onTap: () {
                                _onTab(index);
                              },
                              selected: item.bSelect,
                              leading: Container(
                                width: 32,
                                height: 32,
                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                alignment: Alignment.center,
                                child: _getIcon(item.bSelect),
                              ),
                              title: Text(_itemList[index].name,
                                style: TextStyle(
                                    color: (item.bSelect) ? Colors.blueAccent : Colors.black,
                                    fontWeight: (item.bSelect)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14.0
                                ),
                              ),
                            );
                      })
                    /*
                    child: (widget.items.isNotEmpty)
                          ? LayoutBuilder(builder: (context, constraints) {
                        return GridView.builder(
                          itemCount: widget.items.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 3,
                          ),
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                _onTab(index);
                              },
                              selected: m_bCheck[index],
                              leading: Container(
                                width: 32,
                                height: 32,
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                alignment: Alignment.center,
                                child: _getIcon(index),
                              ),
                              title: Text(widget.items[index].name,
                                style: TextStyle(
                                    color: (m_bCheck[index]) ? Colors.blueAccent : Colors.black,
                                    fontWeight: (m_bCheck[index])
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 16.0
                                ),
                              ),
                            );
                          },
                        );
                      })
                          : ListView(
                              //itemExtent: 150,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              //scrollDirection: ScrollDirection.,
                              children: List.generate(widget.items.length, (index) {
                                return ListTile(
                                  onTap: () {
                                    _onTab(index);
                                  },
                                  selected: m_bCheck[index],
                                  leading: Container(
                                    width: 32,
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    alignment: Alignment.center,
                                    child: _getIcon(index),
                                  ),

                                  title: Text(widget.items[index].name,
                                    style: TextStyle(
                                        color: (m_bCheck[index]) ? Colors.blueAccent : Colors.black,
                                        fontWeight: (m_bCheck[index])
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 20.0
                                    ),
                                  ),
                                );
                              }),
                            ),
                    */
                    ),
                  ),
                ],
              )
                  : const Center(child: CircularProgressIndicator(),), // empty back
              floatingActionButton: Visibility(
                visible: (bSelectOk && bLoaded) ? true : false,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context, _getSelectValues());
                  },
                  label: const Text("선택"),
                  icon: const Icon(Icons.check),
                  backgroundColor: Colors.brown,
                ),
              )
          )
        )
    );
  }


  Widget _getIcon(bool bSelect) {
    return (bSelect) ?
      const Icon(Icons.check_circle, color: Colors.blueAccent,) :
      const Icon(Icons.circle_outlined, color: Colors.brown);
  }

  Future<void> closeSearch() async {
    _findKey = "";
    idsController.text = "";
    await _fatchData();
    setState(() {
      bSearch = false;
    });
  }

  Future<bool> _onBackPressed(BuildContext context) {
    if(bSearch){
      closeSearch();
    }
    else {
      Navigator.pop(context);
    }
    return Future(() => false);
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;
  const ItemTile(this.itemNo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.primaries[itemNo % Colors.primaries.length];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: color.withOpacity(0.3),
        onTap: () {},
        leading: Container(
          width: 50,
          height: 30,
          color: color.withOpacity(0.5),
          child: Placeholder(
            color: color,
          ),
        ),
        title: Text(
          'Product $itemNo',
          key: Key('text_$itemNo'),
        ),
      ),
    );
  }
}