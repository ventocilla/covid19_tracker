import 'dart:convert';
import 'package:covid19_tracker/pages/countryPage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'datasource.dart';
import 'panels/infoPanel.dart';
import 'panels/mostaffectedcountries.dart';
import 'panels/worldwidepanel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countriesData;
  List countriesMostAffectedData;
  fetchContryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countriesData = json.decode(response.body);
    });
  }

  Future fetchData() async{
    fetchWorldWideData();
    fetchContryData();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Dashboard'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.lightbulb_outline
                    : Icons.highlight,
              ),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
                );
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Text(
                  DataSource.quote,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                color: Colors.orange[100],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'WorldWide',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContryPage()
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryBlack,
                        ),
                        child: Text(
                          'Regional',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? CircularProgressIndicator()
                  : WorldWidePanel(worldData: worldData
              ),
              SizedBox(height: 10),
              worldData == null ? Container() :
              PieChart(
                  dataMap: {
                   'Confirmed': worldData['cases'].toDouble(),
                   'Active': worldData['active'].toDouble(),
                   'Recovered': worldData['recovered'].toDouble(),
                   'Deaths': worldData['deaths'].toDouble(),
              },
              colorList: [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.grey
              ],
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  //showChartValues: true,
                  showChartValuesInPercentage: true,
                ),
                //chartValueStyle: TextStyle(fontSize: 16, color: Colors.white),
                //legendStyle: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Most Affected Countries',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              countriesData == null
                  ? CircularProgressIndicator()
                  : MostAffectedPanel(countryData: countriesData),
              InfoPanel(),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'WE ARE STRONG TOGETHER IN THE FIGHT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
