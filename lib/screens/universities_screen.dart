import 'package:flutter/material.dart';
import 'package:tyba_test/models/university.dart';
import 'package:tyba_test/services/university_service.dart'; 

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({Key? key}) : super(key: key);

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  late Future<List<University>> _futureUniversities;
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    _futureUniversities = UniversityService.fetchUniversities(); 
  }

  void _toggleView() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades'),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_view),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: FutureBuilder<List<University>>(
        future: _futureUniversities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron universidades.'));
          } else {
            final universities = snapshot.data!;
            return _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final university = universities[index];
                      return _buildUniversityCard(university);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final university = universities[index];
                      return _buildUniversityCard(university);
                    },
                  );
          }
        },
      ),
    );
  }

  Widget _buildUniversityCard(University university) {
    return Card(
      child: ListTile(
        title: Text(university.name),
        subtitle: Text(university.country),
        onTap: () {
          // TODO: Navegar a detalle
        },
      ),
    );
  }
}
