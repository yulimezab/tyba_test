import 'package:flutter/material.dart';
import 'package:tyba_test/models/university.dart';
import 'package:tyba_test/screens/university_detail_screen.dart';
import 'package:tyba_test/services/university_service.dart';
import 'package:flutter/foundation.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({Key? key}) : super(key: key);

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  List<University> universities = [];
  int currentPage = 0;
  bool isLoading = false;
  bool _isGrid = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (universities.isEmpty) {
      _loadUniversities();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadUniversities();
      }
    });
  }

  Future<void> _loadUniversities() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final response = await UniversityService.fetchUniversities(currentPage);
    setState(() {
      universities.addAll(response);
      currentPage++;
      isLoading = false;
    });
  }

  void _toggleView() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            width: screenWidth * 0.7,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Universities App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D47A1), // Azul oscuro moderno
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isGrid ? Icons.list : Icons.grid_view,
                    color: Color(0xFF0D47A1),
                  ),
                  onPressed: _toggleView,
                ),
              ],
            ),
          ),
        ),
      ),
      body: universities.isEmpty && isLoading
          ? _buildLoadingIndicator()
          : _isGrid
              ? _buildGridView(screenWidth)
              : _buildListView(screenWidth),
    );
  }

  Widget _buildListView(double screenWidth) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: universities.length + 1,
      itemBuilder: (context, index) {
        if (index == universities.length) {
          return _buildLoadingIndicator();
        }
        final university = universities[index];
        return Center(
          child: Container(
            width: screenWidth * 0.5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildUniversityCard(university),
          ),
        );
      },
    );
  }

  Widget _buildGridView(double screenWidth) {
    int crossAxisCount = (screenWidth ~/ 220).clamp(2, 6); // más responsivo

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7, // menos alto
      ),
      itemCount: universities.length + 1,
      itemBuilder: (context, index) {
        if (index == universities.length) {
          return _buildLoadingIndicator();
        }
        final university = universities[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final updatedUniversity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UniversityDetailScreen(university: university)),
              );
              if (updatedUniversity != null) {
                setState(() {
                  universities[index] = updatedUniversity;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: university.image != null
                          ? (kIsWeb
                              ? Image.memory(university.image, fit: BoxFit.cover)
                              : Image.file(university.image, fit: BoxFit.cover))
                          : const Icon(Icons.school, size: 50, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    university.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    university.country,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (university.students != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${university.students} students',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUniversityCard(University university) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 60,
          height: 60,
          child: university.image != null
              ? (kIsWeb
                  ? Image.memory(university.image, fit: BoxFit.cover)
                  : Image.file(university.image, fit: BoxFit.cover))
              : const Icon(Icons.school, size: 50, color: Colors.grey),
        ),
      ),
      title: Text(
        university.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(university.country),
          if (university.students != null)
            Text('${university.students} students'),
        ],
      ),
      onTap: () async {
        final index = universities.indexWhere((u) => u.name == university.name);
        if (index == -1) return;

        final updatedUniversity = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniversityDetailScreen(university: universities[index]),
          ),
        );

        if (updatedUniversity != null) {
          setState(() {
            universities[index] = updatedUniversity;
          });
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
