import 'package:flutter/material.dart';
import 'package:unifood/view/restaurant/search/widgets/restaurant_card.dart'; 
import 'package:unifood/view/restaurant/filtermenu/widgets/category_item.dart';
import 'package:unifood/view/restaurant/filtermenu/widgets/trendy_flavor_item.dart';
import 'package:unifood/view/restaurant/filtermenu/widgets/menu_item_card.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  List<Map<String, dynamic>> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int? _selectedCategoryIndex;
    final List<Map<String, dynamic>> menuItems = [
    {
      'imagePath': 'assets/images/oferta1.png',
      'title': 'Familiar Tacos',
      'description': 'Menu description',
      'rating': 4.5,
      'author': 'Sarah William',
      'price': '35.000'
    },
    {
      'imagePath': 'assets/images/oferta2.jpg',
      'title': 'El Carnal Tacos',
      'description': 'Dish description',
      'rating': 4.3,
      'author': 'Sarah William',
      'price': '15.000'
    },
    {
      'imagePath': 'assets/images/oferta3.png',
      'title': 'Assemble your taco to your liking with lettuce',
      'description': 'Dish Description',
      'rating': 4.0,
      'author': 'Sarah William',
      'price': '14.000'
    },

  ];

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Cabbage and lettuce', 'count': 14},
    {'title': 'Cucumbers and tomato', 'count': 12},
    {'title': 'Onions and garlic', 'count': 8},
    {'title': 'Peppers', 'count': 7},
    {'title': 'Potatoes and', 'count': 15},
    // Agrega más categorías si es necesario
  ];

@override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      var query = _searchController.text;
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _isSearching = false;
          _searchResults.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
Widget build(BuildContext context) {
  // Obtén el tamaño de la pantalla y el padding seguro
  final Size screenSize = MediaQuery.of(context).size;
  final EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Padding(
        // Ajusta el padding basado en el tamaño de la pantalla
        padding: EdgeInsets.fromLTRB(8.0, 0, screenSize.width * 0.1, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search), // Ícono de búsqueda dentro del campo.
                  ),
                  onChanged: _performSearch,
                ),
              ),
              if (_isSearching)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    body: _isSearching ? _buildSearchResults() : _buildFullMenu(),
  );
}

Widget _buildSearchResults() {
  return ListView.builder(
    itemCount: _searchResults.length,
    itemBuilder: (context, index) {
      final item = _searchResults[index];
      return MenuItemCard(
        imagePath: item['imagePath'],
        title: item['title'],
        description: item['description'],
        rating: item['rating'],
        author: item['author'],
        price: item['price'],
      );
    },
  );
}

Widget _buildFullMenu() {
  final screenWidth = MediaQuery.of(context).size.width;
  final titleFontSize = screenWidth < 360 ? 20.0 : 24.0; 
  final padding = screenWidth < 360 ? 12.0 : 16.0; 
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: titleFontSize, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_categories.length, (index) {
            final category = _categories[index];
            return CategoryItem(
              title: category['title'],
              count: category['count'],
              isSelected: _selectedCategoryIndex == index,
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = _selectedCategoryIndex == index ? null : index;
                });
              },
            );
          }),
        ),
        _buildTrendyFlavorsSection(), 
        _buildResultsMenu(), 
      ],
    ),
  );
}
  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _searchResults = menuItems.where((item) {
          return item['title'].toLowerCase().contains(query.toLowerCase());
        }).toList();
        _isSearching = true;
      } else {
        _searchResults.clear();
        _isSearching = false;
      }
    });
  }



Widget _buildTrendyFlavorsSection() {
  List<String> flavorImages = [
    'assets/images/trendy1.jpg',
    'assets/images/trendy2.jpg',
    'assets/images/trendy3.png',
  ];
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final titleFontSize = screenWidth < 360 ? 20.0 : 24.0; // Ajuste dinámico del tamaño de la fuente
  final containerHeight = screenHeight < 700 ? 140.0 : 160.0; // Ajuste dinámico de la altura del contenedor

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Trendy flavors',
          style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 8.0),
      SizedBox(
        height: containerHeight, // Altura ajustada dinámicamente
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: flavorImages.length,
          itemBuilder: (context, index) {
            return TrendyFlavorItem(imagePath: flavorImages[index]);
          },
        ),
      ),
      const Divider(height: 16.0, thickness: 2.0),
    ],
  );
}

Widget _buildResultsMenu() {
  List<Map<String, dynamic>> itemsToShow = _searchController.text.isNotEmpty ? _searchResults : menuItems;
  final padding = MediaQuery.of(context).size.width < 360 ? 12.0 : 16.0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(padding), // Padding ajustado dinámicamente
        child: const Text('Results Menu', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      ),
      // Directamente construye una lista de widgets MenuItemCard, sin ListView
      for (var menuItem in itemsToShow) MenuItemCard(
        imagePath: menuItem['imagePath'],
        title: menuItem['title'],
        description: menuItem['description'],
        rating: menuItem['rating'],
        author: menuItem['author'],
        price: menuItem['price'],
      ),
    ],
  );
}

  Widget _buildRestaurantCards() {
    List<Map<String, dynamic>> restaurantsToShow = _searchResults.isNotEmpty ? _searchResults : _categories;

    if (restaurantsToShow.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: restaurantsToShow.length,
      itemBuilder: (context, index) {
        final restaurant = restaurantsToShow[index];
        return RestaurantCard(
          name: restaurant['title'], // Asegúrate de que este sea el campo correcto para el nombre del restaurante
          logo: restaurant['logo'] ?? 'assets/images/elcarnal_logo.jpeg', // Proporciona una imagen por defecto si no hay logo
          state: restaurant['state'] ?? 'Closed', // Asume un estado por defecto si no está proporcionado
        );
      },
    );
  }

}


