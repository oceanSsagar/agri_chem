import 'package:agri_chem/screens/application_screens/chemical_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChemicalSearchScreen extends StatefulWidget {
  ChemicalSearchScreen({super.key});
  final _search = TextEditingController();

  @override
  State<ChemicalSearchScreen> createState() => _ChemicalSearchScreenState();
}

class _ChemicalSearchScreenState extends State<ChemicalSearchScreen> {
  List<DocumentSnapshot> _results = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _searchChemicals(widget._search.text.trim());
      }
    });
  }

  void _searchChemicals(String query, {bool isNewSearch = false}) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _lastDoc = null;
        _hasMore = true;
      });
      return;
    }

    if (isNewSearch) {
      setState(() {
        _results.clear();
        _lastDoc = null;
        _hasMore = true;
      });
    }

    if (!_hasMore) return;

    setState(() => _isLoading = true);

    Query queryRef = FirebaseFirestore.instance
        .collection('agri_chemicals')
        .where('name_lower', isGreaterThanOrEqualTo: query)
        .where('name_lower', isLessThanOrEqualTo: query + '\uf8ff')
        .orderBy('name_lower')
        .limit(_limit);

    if (_lastDoc != null) {
      queryRef = (queryRef as Query<Map<String, dynamic>>).startAfterDocument(
        _lastDoc!,
      );
    }

    final snapshot = await queryRef.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDoc = snapshot.docs.last;
      _results.addAll(snapshot.docs);
    } else {
      _hasMore = false;
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    widget._search.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'allowed':
        return Colors.green.shade100;
      case 'restricted':
        return Colors.orange.shade100;
      case 'banned':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            SearchBar(
              controller: widget._search,
              onChanged: (value) {
                _searchChemicals(value.trim(), isNewSearch: true);
              },
              hintText: "Search for Chemicals",
              keyboardType: TextInputType.name,
              elevation: WidgetStateProperty.all(5.0),
            ),
            SizedBox(height: 15),
            Expanded(
              child:
                  _results.isEmpty && !_isLoading
                      ? Center(child: Text('No chemicals found.'))
                      : ListView.builder(
                        controller: _scrollController,
                        itemCount: _results.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _results.length) {
                            return _isLoading
                                ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : SizedBox.shrink();
                          }

                          final chem =
                              _results[index].data() as Map<String, dynamic>;
                          final status =
                              (chem['status'] ?? 'unknown') as String;

                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: getStatusColor(status),
                              title: Text(
                                chem['name'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                "Status: ${chem['status'] ?? 'N/A'}",
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChemicalDetailScreen(
                                          chemical: chem,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
