import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentStockPage extends StatefulWidget {
  const CurrentStockPage({Key? key}) : super(key: key);

  @override
  _CurrentStockPageState createState() => _CurrentStockPageState();
}

class _CurrentStockPageState extends State<CurrentStockPage> {
  Map<String, dynamic>? appleStockData;
  Map<String, dynamic>? msftStockData;
  bool _isLoading = true;
  String _errorMessage = '';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final apiKey = 'A8AO82O605EHGS5G';
    final appleSymbol = 'AAPL';
    final msftSymbol = 'MSFT';

    final appleUrl =
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$appleSymbol&interval=5min&apikey=$apiKey';
    final msftUrl =
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$msftSymbol&interval=5min&apikey=$apiKey';

    try {
      final appleResponse = await http.get(Uri.parse(appleUrl));
      final msftResponse = await http.get(Uri.parse(msftUrl));

      if (appleResponse.statusCode == 200 && msftResponse.statusCode == 200) {
        final appleData = json.decode(appleResponse.body);
        final msftData = json.decode(msftResponse.body);

        setState(() {
          appleStockData = _getLatestStockData(appleData);
          msftStockData = _getLatestStockData(msftData);
          _isLoading = false;
          _errorMessage = '';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
          'Error: ${appleResponse.statusCode} or ${msftResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    await fetchStockData();
  }

  Map<String, dynamic>? _getLatestStockData(Map<String, dynamic> data) {
    try {
      return data['Time Series (5min)']?.entries?.first?.value;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error parsing stock data';
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('주식 현재가'),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '애플 주식 현재가',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                _buildStockInfo('애플', appleStockData),
                const SizedBox(height: 20),
                const Text(
                  '마이크로소프트 주식 현재가',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                _buildStockInfo('마이크로소프트', msftStockData),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _refreshData,
        tooltip: '새로고침',
        backgroundColor: Colors.black, // 새로고침 버튼의 배경색을 검정색으로 설정
        child: const Icon(Icons.refresh, color: Colors.white), // 아이콘의 색상을 흰색으로 설정
      ),
    );
  }

  Widget _buildStockInfo(
      String company, Map<String, dynamic>? stockData) {
    if (stockData == null) {
      return const Text(
        'No data available',
        style: TextStyle(color: Colors.white),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                stockData['1. open'],
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '예상 등락',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '+2.99%', // 데이터를 가져와서 계산해야 함
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '예상 가격',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                stockData['2. high'],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '예상 수량',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                stockData['5. volume'],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
