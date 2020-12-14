import 'package:flutter/material.dart';

class MostAffectedPanel extends StatelessWidget {
  final countryData;

  const MostAffectedPanel({Key key, this.countryData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  Image.network(
                      countryData[index]['countryInfo']['flag'],
                      height: 30
                  ),
                  SizedBox(width: 10),
                  Text(
                    countryData[index]['country'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Deaths ' + countryData[index]['deaths'].toString(),
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
