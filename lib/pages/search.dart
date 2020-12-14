import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../datasource.dart';

class Search extends SearchDelegate {
  Search({this.countryList});
  final List countryList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryBlack,
      brightness: DynamicTheme.of(context).brightness,
      // ..
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
    IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final suggestionList =
    query.isEmpty? countryList : countryList.where((element) => element['country'].toString().toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList == null ? 0 : suggestionList.length,
      itemBuilder: (context, index) {
        return suggestionList == null
            ? CircularProgressIndicator()
            : Card(
          color: Colors.grey[100],
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //color: Colors.black,
            height: 130,
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          suggestionList[index]['country'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Image.network(
                          suggestionList[index]['countryInfo']['flag'],
                          height: 50,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'CONFIRMED: ' +
                              suggestionList[index]['cases'].toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ACTIVE: ' +
                              suggestionList[index]['active'].toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'RECOVERED: ' +
                              suggestionList[index]['recovered']
                                  .toString(),
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'DEATH: ' +
                              suggestionList[index]['deaths'].toString(),
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[100] : Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}