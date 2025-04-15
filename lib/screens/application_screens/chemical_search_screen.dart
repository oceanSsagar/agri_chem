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

  void _searchChemicals(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);

    final snapshot =
        await FirebaseFirestore.instance
            .collection('agri_chemicals')
            .where('name_lower', isGreaterThanOrEqualTo: query)
            .where('name_lower', isLessThanOrEqualTo: query + '\uf8ff')
            .get();

    setState(() {
      _results = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    widget._search.dispose();
    super.dispose();
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
                _searchChemicals(value.trim());
              },
              hintText: "Search for Chemicals",
              keyboardType: TextInputType.name,
              elevation: WidgetStateProperty.all(5.0),
            ),
            SizedBox(height: 15),
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _results.isEmpty
                      ? Center(child: Text('No chemicals found.'))
                      : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final chem =
                              _results[index].data() as Map<String, dynamic>;
                          final status =
                              (chem['status'] as String?)?.toLowerCase() ??
                              'unknown';

                          Color getStatusColor(String status) {
                            switch (status) {
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
                                // You can open a detailed screen if needed
                                final chemData =
                                    _results[index].data()
                                        as Map<String, dynamic>;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChemicalDetailScreen(
                                          chemical: chemData,
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
