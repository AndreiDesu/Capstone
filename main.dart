// ... all your existing imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'page2.dart';
import 'CreateAccount.dart';
import 'LoginNew.dart';
import 'Admin.dart';
import 'User.dart';
import 'Staff.dart';
import 'carousel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mendez Resort',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ResortHomePage(),
    );
  }
}

class ResortHomePage extends StatefulWidget {
  @override
  _ResortHomePageState createState() => _ResortHomePageState();
}

class _ResortHomePageState extends State<ResortHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String email = _usernameController.text;
    final String password = _passwordController.text;
    final String url = 'http://192.168.100.238/flutter_api/login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        int roleId = responseData['roleid'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );

        Widget nextPage;
        switch (roleId) {
          case 1:
            nextPage = Admin();
            break;
          case 2:
            nextPage = User();
            break;
          case 3:
            nextPage = Staff();
            break;
          default:
            nextPage = page2();
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error connecting to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
                    },
                    child: Text('Create Account'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _login(context);
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mendez Resort and Events Place'),
          actions: [
            ElevatedButton(
              onPressed: () => _showLoginDialog(context),
              child: Text(
                'BOOK NOW',
                style: TextStyle(color: Color.fromARGB(255, 45, 28, 194)),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Package'),
              Tab(text: 'Catering'),
              Tab(text: 'Calendar'),
              Tab(text: 'Amenities'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'STAY WITH COMFORT',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: screenWidth < 600 ? 200 : 300,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/Mendez.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Mendez Resort Offers',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 500,
                      child: TabBarView(
                        children: [
                          PackagesTab(),
                          _buildCateringTab(screenWidth),
                          _buildPromosTab(screenWidth),
                          Center(child: Text('Amenities info here')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPromosTab(double screenWidth) {
    final promos = [
      {'title': 'Phase 1', 'description': 'Limited time offer', 'imagePath': 'assets/Phase1.jpg'},
      {'title': 'Phase 2', 'description': 'Weekend special', 'imagePath': 'assets/Phase2.jpg'},
      {'title': 'Phase 1&2', 'description': 'Family package', 'imagePath': 'assets/Allin.jpg'},
    ];

    return Carousel();
  }

  Widget _buildCateringTab(double screenWidth) {
    final catering = [
      {
        'title': 'Wedding',
        'description': 'Full service catering',
        'imagePath': 'assets/images/catering_wedding.png',
      },
      {
        'title': 'Corporate',
        'description': 'Business event catering',
        'imagePath': 'assets/images/catering_corporate.png',
      },
    ];

    return GridView.builder(
      itemCount: catering.length,
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: screenWidth < 600 ? 250 : 400,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final item = catering[index];
        return OfferCard(
          title: item['title']!,
          description: item['description']!,
          imagePath: item['imagePath']!,
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mendez Resort and Events Place'),
              Text('San Jose del Monte, Philippines'),
              Text('0917 821 9235'),
              Text('emendez4374@gmail.com'),
            ],
          ),
          ElevatedButton(
            onPressed: () => _showLoginDialog(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OfferCard({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(description, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class PackagesTab extends StatefulWidget {
  @override
  _PackagesTabState createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
  List<dynamic> packages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    final url = Uri.parse('http://192.168.100.238/flutter_api/get_packages.php');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          packages = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _bootstrapStyleCard(Map<String, dynamic> pkg) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                'assets/Mendez.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pkg['package_name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('${pkg['day_type']} - ${pkg['week_schedule']}', style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 4),
                  Text('Hours: ${pkg['hours']}'),
                  Text('Price: ₱${pkg['price']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    if (isLoading) return Center(child: CircularProgressIndicator());
    if (packages.isEmpty) return Center(child: Text("No packages available."));

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.count(
        crossAxisCount: isWideScreen ? 2 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 2,
        children: packages.map((pkg) => Center(child: _bootstrapStyleCard(pkg))).toList(),
      ),
    );
  }
}
