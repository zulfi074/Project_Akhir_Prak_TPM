import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/apiDataSource.dart';
import 'package:final_project/models/DetailEventsModel.dart';

class DetailPage extends StatefulWidget {
  final String slug, nama;
  const DetailPage({Key? key, required this.slug, required this.nama})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String selectedTimeZone = 'WIB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.nama}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedTimeZone,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTimeZone = newValue!;
                });
              },
              items: <String>['WIB', 'WITA', 'WIT', 'London']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(child: _buildDetailUser(widget.slug)),
        ],
      ),
    );
  }

  Widget _buildDetailUser(String slugDiterima) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: ApiDataSource.instance.loadDetailEvents(slugDiterima),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
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
      child: Text("Error loading data"),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  String convertTime(String time, String fromTimeZone, String toTimeZone) {
    var format = DateFormat("HH:mm:ss");
    var dateTime = format.parse(time, true).toUtc();
    dateTime = dateTime.add(Duration(
        hours: _timeZoneOffset(toTimeZone) - _timeZoneOffset(fromTimeZone)));
    return DateFormat("HH:mm:ss").format(dateTime);
  }

  int _timeZoneOffset(String timeZone) {
    switch (timeZone) {
      case 'WIB':
        return 7;
      case 'WITA':
        return 8;
      case 'WIT':
        return 9;
      case 'London':
        return 1; // During standard time (not considering daylight saving time)
      default:
        return 0;
    }
  }

  Widget _buildSuccess(Data data) {
    String startTime = data.waktuMulai ?? '15:00:00';
    String endTime = data.waktuSelesai ?? '15:00:00';

    String startConverted = convertTime(startTime, 'WIB', selectedTimeZone);
    String endConverted = convertTime(endTime, 'WIB', selectedTimeZone);

    return ListView(
      children: [
        if (data.filename != null && data.filename!.isNotEmpty)
          Image.network(
              'https://api.yesplis.com/images/banner/${data.filename}'),
        SizedBox(height: 16.0),
        Text(
          data.nama ?? 'No Name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('dd-MM-yyyy')
                .format(data.tanggalMulai ?? DateTime.now())),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Start Time ($selectedTimeZone):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(startConverted),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'End Time ($selectedTimeZone):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(endConverted),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                data.namaTempat ?? 'Unknown',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                data.alamat ?? 'Unknown',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          data.deskripsi ?? 'No Description',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}
