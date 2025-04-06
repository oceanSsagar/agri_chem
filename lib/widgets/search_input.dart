import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  filled: true,
                  contentPadding: EdgeInsets.all(18),
                  border: InputBorder.none,
                  hintText: "Search anything ...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 42,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
