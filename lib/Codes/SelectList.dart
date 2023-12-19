
// ignore_for_file: non_constant_identifier_names

import 'package:coani/Models/Codes.dart';
import 'package:coani/Remote/Remote.dart';
import 'package:flutter/material.dart';

class SelectList extends StatefulWidget {
  const SelectList({Key? key, required this.cotegory, required this.items, required this.isMulti, required this.minCheckCount}) : super(key: key);
  final bool isMulti;
  final int minCheckCount;
  final String cotegory;
  final List<String> items;
  @override
  _SelectListState createState() => _SelectListState();
}

class _SelectListState extends State<SelectList> {
  TextEditingController idsController = TextEditingController();
  bool bSearch = false;
  bool bLoaded = true;
  bool bSelectOk = false;
  late List<bool> m_bCheck;

  //get category => null;

  @override
  void initState() {
    super.initState();
    m_bCheck = List.filled(widget.items.length, false, growable: false);
  }

  void _onTab(int index) {
    if (widget.isMulti) {
      setState(() {
        m_bCheck[index] = !m_bCheck[index];
        int count = 0;
        for (var check in m_bCheck) {
          if (check) {
            count++;
          }
        }
        bSelectOk = (count >= widget.minCheckCount) ? true : false;
      });
    }
    else {
      setState(() {
        m_bCheck[index] = !m_bCheck[index];
        for (int n = 0; n < m_bCheck.length; n++) {
          if (n != index) {
            if (m_bCheck[n]) {
              m_bCheck[n] = false;
            }
          }
        }
        bSelectOk = (m_bCheck[index]) ? true : false;
      });
    }
  }

  String _getSelectValues() {
    String codestring = "";
    for (int n = 0; n < m_bCheck.length; n++) {
      if (m_bCheck[n]) {
        if (codestring.isNotEmpty) {
          codestring += "|";
        }
        codestring += widget.items[n];
      }
    }
    return codestring;
  }

  Future<void> _fatchData({String key=""}) async {
    setState(() {
      bLoaded = false;

    });

    await Remote.getCodes (category: widget.cotegory, key:key,
        onResponse: (List<Codes> list) async {
          setState(() {
            widget.items.clear();
            for (var element in list) { widget.items.add(element.name.toString());}

            bSelectOk = false;
            m_bCheck = List.filled(widget.items.length, false, growable: false);

            bLoaded = true;
          });
        });
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
            title: Text(widget.cotegory),
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
                              String key = value;
                              if(key.isNotEmpty) {
                                _fatchData(key:key);
                              }
                            },
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, ),
                            decoration: InputDecoration(
                                hintText: "검색어",
                                //border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                suffixIcon: IconButton (
                                  onPressed: () async {
                                    String key = idsController.text.trim();
                                    if(key.isNotEmpty) {
                                      _fatchData(key:key);
                                    }
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
                      child: (widget.items.isNotEmpty)
                          ? LayoutBuilder(builder: (context, constraints) {
                        return GridView.builder(
                          itemCount: widget.items.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (constraints.maxWidth) > 800 ? 3 : 2,
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
                              title: Text(widget.items[index],
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

                                  title: Text(widget.items[index],
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


  Widget _getIcon(int index) {
    if (widget.isMulti) {
      return (m_bCheck[index]) ?
        const Icon(Icons.check_box_sharp, color: Colors.blueAccent) :
        const Icon(Icons.check_box_outline_blank, color: Colors.brown);
    }
    else {
      return (m_bCheck[index]) ?
        const Icon(Icons.check_circle, color: Colors.blueAccent,) :
        const Icon(Icons.circle_outlined, color: Colors.brown);
    }
  }

  Future<void> closeSearch() async {
    await _fatchData(key: "");
    setState(() {
      idsController.text = "";
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