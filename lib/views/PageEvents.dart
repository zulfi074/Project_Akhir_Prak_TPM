import 'package:flutter/material.dart';
import 'package:final_project/apiDataSource.dart'; // Make sure this import matches your API location
import 'package:final_project/models/EventsModel.dart';
import 'package:final_project/views/DetailPageEvent.dart'; // Make sure this import matches your model location
import 'package:final_project/views/SearchEvents.dart'; // Make sure this import matches your SearchPage location

class PageEvents extends StatefulWidget {
  const PageEvents({Key? key}) : super(key: key);

  @override
  State<PageEvents> createState() => _PageEventsState();
}

class _PageEventsState extends State<PageEvents> {
  String _selectedCurrency = 'IDR'; // Default currency
  final TextEditingController _searchController = TextEditingController();

  final Map<String, double> _exchangeRates = {
    'IDR': 1, // Assume minprice is in IDR
    'MYR': 0.00029, // Example conversion rate
    'SGD': 0.000094, // Example conversion rate
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Events"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari event...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchPage(cari: _searchController.text),
                      ),
                    );
                  },
                  child: Text('Cari'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pilih Mata Uang: "),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: [
                    DropdownMenuItem(
                      value: 'IDR',
                      child: Text('Rupiah (IDR)'),
                    ),
                    DropdownMenuItem(
                      value: 'MYR',
                      child: Text('Ringgit (MYR)'),
                    ),
                    DropdownMenuItem(
                      value: 'SGD',
                      child: Text('Dolar Singapura (SGD)'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(child: _buildListEvents()),
        ],
      ),
    );
  }

  Widget _buildListEvents() {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder(
        future: ApiDataSource.instance.loadEvents(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildError();
          }
          if (snapshot.hasData) {
            Welcome welcome = Welcome.fromJson(snapshot.data);
            return _buildSuccess(welcome.data!);
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text("Error loading data."),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccess(EventsModel data) {
    return ListView.builder(
      itemCount: data.data?.length ?? 0,
      itemBuilder: (BuildContext context, index) {
        return _buildItem(data.data![index]);
      },
    );
  }

  Widget _buildItem(Data eventData) {
    double priceInSelectedCurrency = eventData.minprice != null
        ? eventData.minprice! * _exchangeRates[_selectedCurrency]!
        : 0;

    String currencySymbol;
    switch (_selectedCurrency) {
      case 'MYR':
        currencySymbol = 'RM';
        break;
      case 'SGD':
        currencySymbol = 'S\$';
        break;
      case 'IDR':
      default:
        currencySymbol = 'Rp';
        break;
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailPage(slug: eventData.slug!, nama: eventData.nama!),
        ),
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://api.yesplis.com/images/banner/${eventData.filename}'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.event, size: 20),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      eventData.nama ?? "No Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.place, size: 20),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      eventData.namaTempat ?? "No Place Name",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      eventData.alamat ?? "No Address",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    currencySymbol,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 5),
                  Text(
                    priceInSelectedCurrency.toStringAsFixed(2),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
