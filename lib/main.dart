import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart'; // Make sure this file exists and is configured
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import for NumberFormat
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import for banner indicator

// Global Cart State Management
class CartItem {
  final String productName;
  final String brandName;
  final String? color;
  final String? storage;
  final double price;
  final String imagePath; // Changed from imageUrl to imagePath for clarity
  int quantity;

  CartItem({
    required this.productName,
    required this.brandName,
    this.color,
    this.storage,
    required this.price,
    required this.imagePath, // Now expects an asset path
    this.quantity = 1,
  });

  String get id => '$productName-${color ?? 'no-color'}-${storage ?? 'no-storage'}';
}

final ValueNotifier<List<CartItem>> cartNotifier = ValueNotifier<List<CartItem>>([]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.poppins().fontFamily,
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF6B48FF), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B48FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            elevation: 3,
            minimumSize: const Size(120, 40),
          ),
        ),
      ),
      home: const SignInScreen(),
    );
  }
}

// --- SignInScreen ---
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      print('Signing in with: ${_emailController.text} / ${_passwordController.text}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                  color: const Color(0xFF6B48FF),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to your account.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot Password clicked!')),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata, 'Google'),
                    const SizedBox(width: 20),
                    _buildSocialButton(Icons.facebook, 'Facebook'),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF6B48FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label Sign-in clicked!')),
          );
        },
        icon: Icon(icon, size: 30, color: Colors.black87),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// --- SignUpScreen ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      print('Signing up with: ${_nameController.text} / ${_emailController.text} / ${_passwordController.text}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                  color: const Color(0xFF6B48FF),
                ),
                const SizedBox(height: 32),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata, 'Google'),
                    const SizedBox(width: 20),
                    _buildSocialButton(Icons.facebook, 'Facebook'),
                  ],
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF6B48FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label Sign-up clicked!')),
          );
        },
        icon: Icon(icon, size: 30, color: Colors.black87),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// --- HomeScreen ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final PageController _pageController = PageController(); // Controller for PageView.builder

  final ValueNotifier<List<Map<String, dynamic>>> _categoriesNotifier =
  ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<List<Map<String, dynamic>>> _dealsNotifier =
  ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<Map<String, dynamic>?> _bannerNotifier =
  ValueNotifier<Map<String, dynamic>?>(null);

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchDeals();
    _fetchBanner();
  }

  Future<void> _fetchCategories() async {
    try {
      final DataSnapshot snapshot = await _database.child('categories').get();
      if (snapshot.exists && snapshot.value is Map) {
        List<Map<String, dynamic>> fetchedCategories = [];
        Map<dynamic, dynamic> categoriesMap = snapshot.value as Map<dynamic, dynamic>;

        categoriesMap.forEach((key, value) {
          if (value is Map) {
            final String name = (value['name'] as String?) ?? 'Unnamed Category';
            final String image = (value['image'] as String?) ?? 'assets/laptop.jpeg'; // Default to a local asset

            // Process products within each category to pass to CategoryProductsScreen
            Map<String, dynamic> productsMap = {};
            if (value['products'] is Map) {
              (value['products'] as Map).forEach((prodKey, prodValue) {
                if (prodValue is Map) {
                  // Product image path now comes directly from JSON (expected to be asset path)
                  final String productImagePath = (prodValue['image'] as String?) ?? 'assets/mobile.jpeg';
                  productsMap[prodKey] = {
                    'productName': (prodValue['productName'] as String?) ?? 'Unknown Product',
                    'brandName': (prodValue['brandName'] as String?) ?? 'Unknown Brand',
                    'rating': (prodValue['rating'] as num?)?.toDouble() ?? 0.0,
                    'reviewCount': (prodValue['reviewCount'] as num?)?.toDouble() ?? 0.0,
                    'originalPrice': (prodValue['originalPrice'] as num?)?.toDouble() ?? 0.0,
                    'discountedPrice': (prodValue['discountedPrice'] as num?)?.toDouble() ?? 0.0,
                    'image': productImagePath, // This is the asset path for the product
                    'category': (prodValue['category'] as String?) ?? 'Uncategorized',
                    'colorOptions': (prodValue['colorOptions'] is List)
                        ? List<String>.from(prodValue['colorOptions'].whereType<String>())
                        : <String>[],
                    'storageOptions': (prodValue['storageOptions'] is List)
                        ? List<String>.from(prodValue['storageOptions'].whereType<String>())
                        : <String>[],
                    'features': (prodValue['features'] is List)
                        ? List<String>.from(prodValue['features'].whereType<String>())
                        : <String>[],
                  };
                }
              });
            }

            fetchedCategories.add({
              'name': name,
              'image': image, // This is the category icon, still using Image.asset
              'products': productsMap // Pass the processed products map
            });
          }
        });
        _categoriesNotifier.value = fetchedCategories;
      } else {
        print('No categories data available or invalid format.');
        _categoriesNotifier.value = [];
      }
    } catch (e) {
      print('Error fetching categories: $e');
      _categoriesNotifier.value = [];
    }
  }

  Future<void> _fetchDeals() async {
    try {
      final DataSnapshot snapshot = await _database.child('deals').get();
      if (snapshot.exists && snapshot.value is Map) {
        List<Map<String, dynamic>> fetchedDeals = [];
        Map<dynamic, dynamic> dealsMap = snapshot.value as Map<dynamic, dynamic>;

        dealsMap.forEach((key, value) {
          if (value is Map) {
            // Deal product image path now comes directly from JSON (expected to be asset path)
            final String imagePath = (value['image'] as String?) ?? 'assets/placeholder_deal.jpeg';

            fetchedDeals.add({
              'name': (value['name'] as String?) ?? 'No Name',
              'image': imagePath, // This is the asset path for the deal product
              'productName': (value['productName'] as String?) ?? 'Unknown Product',
              'brandName': (value['brandName'] as String?) ?? 'Unknown Brand',
              'rating': (value['rating'] as num?)?.toDouble() ?? 0.0,
              'reviewCount': (value['reviewCount'] as num?)?.toDouble() ?? 0.0,
              'originalPrice': (value['originalPrice'] as num?)?.toDouble() ?? 0.0,
              'discountedPrice': (value['discountedPrice'] as num?)?.toDouble() ?? 0.0,
              'category': (value['category'] as String?) ?? 'Uncategorized',
              'features': (value['features'] is List)
                  ? List<String>.from(value['features'].whereType<String>())
                  : <String>[],
            });
          }
        });
        _dealsNotifier.value = fetchedDeals;
      } else {
        print('No deals data available or invalid format.');
        _dealsNotifier.value = [];
      }
    } catch (e) {
      print('Error fetching deals: $e');
      _dealsNotifier.value = [];
    }
  }

  Future<void> _fetchBanner() async {
    try {
      final DataSnapshot snapshot = await _database.child('banner').get();
      if (snapshot.exists && snapshot.value is Map) {
        _bannerNotifier.value = Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        print('No banner data available or invalid format.');
        _bannerNotifier.value = null;
      }
    } catch (e) {
      print('Error fetching banner: $e');
      _bannerNotifier.value = null;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _categoriesNotifier.dispose();
    _dealsNotifier.dispose();
    _bannerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: () {
              print('Scan button pressed!');
            },
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {
              print('Camera button pressed!');
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: ValueListenableBuilder<List<CartItem>>(
                  valueListenable: cartNotifier,
                  builder: (context, cartItems, child) {
                    final totalItems = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
                    return totalItems > 0
                        ? CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Section
              ValueListenableBuilder<Map<String, dynamic>?>(
                valueListenable: _bannerNotifier,
                builder: (context, bannerData, child) {
                  if (bannerData == null) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(child: Text('Loading banner...')),
                    );
                  }

                  final String bannerImagePath = (bannerData['image'] as String?) ?? 'assets/placeholder_banner.jpeg';
                  final String bannerTitle = (bannerData['title'] as String?) ?? 'Great Deals';
                  final String bannerSubtitle = (bannerData['subtitle'] as String?) ?? 'Shop Now!';
                  final String bannerProductName = (bannerData['productName'] as String?) ?? 'Product';
                  final String bannerBrandName = (bannerData['brandName'] as String?) ?? 'Brand';
                  final double bannerRating = (bannerData['rating'] as num?)?.toDouble() ?? 0.0;
                  final double bannerReviewCount = (bannerData['reviewCount'] as num?)?.toDouble() ?? 0.0;
                  final double bannerOriginalPrice = (bannerData['originalPrice'] as num?)?.toDouble() ?? 0.0;
                  final double bannerDiscountedPrice = (bannerData['discountedPrice'] as num?)?.toDouble() ?? 0.0;
                  final String bannerCategory = (bannerData['category'] as String?) ?? 'Category';
                  final List<String> bannerFeatures = (bannerData['features'] is List)
                      ? List<String>.from(bannerData['features'].whereType<String>())
                      : <String>[];
                  final List<String> bannerColorOptions = (bannerData['colorOptions'] is List)
                      ? List<String>.from(bannerData['colorOptions'].whereType<String>())
                      : <String>[];
                  final List<String> bannerStorageOptions = (bannerData['storageOptions'] is List)
                      ? List<String>.from(bannerData['storageOptions'].whereType<String>())
                      : <String>[];


                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B48FF), Color(0xFF9D7FFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(77, 103, 58, 183),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bannerTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                bannerSubtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        productName: bannerProductName,
                                        brandName: bannerBrandName,
                                        rating: bannerRating,
                                        reviewCount: bannerReviewCount,
                                        originalPrice: bannerOriginalPrice,
                                        discountedPrice: bannerDiscountedPrice,
                                        imagePath: bannerImagePath,
                                        category: bannerCategory,
                                        features: bannerFeatures,
                                        colorOptions: bannerColorOptions,
                                        storageOptions: bannerStorageOptions,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF6B48FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('Shop Now'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            bannerImagePath,
                            fit: BoxFit.contain,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      print('View All Categories pressed!');
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: _categoriesNotifier,
                builder: (context, categories, child) {
                  if (categories.isEmpty) {
                    return const Center(child: Text('No categories available.'));
                  }
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            print("category ${category['products']}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  categoryName: category['name'],
                                  products: category['products'],
                                ),
                              ),
                            );
                          },
                          child: CategoryCard(
                            name: category['name'],
                            image: category['image'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Deals of the Day Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deals of the Day',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      print('View All Deals pressed!');
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: _dealsNotifier,
                builder: (context, deals, child) {
                  if (deals.isEmpty) {
                    return const Center(child: Text('No deals available.'));
                  }
                  return SizedBox(
                    height: 250, // Increased height for better display
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        final deal = deals[index];
                        return ProductCard(
                          productName: deal['productName'],
                          brandName: deal['brandName'],
                          rating: deal['rating'],
                          reviewCount: deal['reviewCount'],
                          originalPrice: deal['originalPrice'],
                          discountedPrice: deal['discountedPrice'],
                          imagePath: deal['image'],
                          category: deal['category'],
                          features: deal['features'],
                          colorOptions: const [], // Assuming deals don't specify colors/storage for simplicity
                          storageOptions: const [],
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // This is where "New Arrivals" section would typically be.
              // It has been removed as per the instruction.
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF6B48FF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Helper Widgets (assuming these are defined elsewhere or need to be added)

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;

  const CategoryCard({Key? key, required this.name, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6B48FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String brandName;
  final double rating;
  final double reviewCount;
  final double originalPrice;
  final double discountedPrice;
  final String imagePath;
  final String category;
  final List<String> features;
  final List<String> colorOptions;
  final List<String> storageOptions;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.brandName,
    required this.rating,
    required this.reviewCount,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imagePath,
    required this.category,
    required this.features,
    this.colorOptions = const [],
    this.storageOptions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: productName,
              brandName: brandName,
              rating: rating,
              reviewCount: reviewCount,
              originalPrice: originalPrice,
              discountedPrice: discountedPrice,
              imagePath: imagePath,
              category: category,
              features: features,
              colorOptions: colorOptions,
              storageOptions: storageOptions,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset('assets/mobile.jpeg', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              brandName,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  ' (${NumberFormat.compact().format(reviewCount)} reviews)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF6B48FF),
                  ),
                ),
                const SizedBox(width: 5),
                if (originalPrice > discountedPrice)
                  Text(
                    '\$${originalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String brandName;
  final double rating;
  final double reviewCount;
  final double originalPrice;
  final double discountedPrice;
  final String imagePath;
  final String category;
  final List<String> features;
  final List<String> colorOptions;
  final List<String> storageOptions;

  const ProductDetailScreen({
    Key? key,
    required this.productName,
    required this.brandName,
    required this.rating,
    required this.reviewCount,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imagePath,
    required this.category,
    required this.features,
    this.colorOptions = const [],
    this.storageOptions = const [],
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedColor;
  String? _selectedStorage;

  @override
  void initState() {
    super.initState();
    if (widget.colorOptions.isNotEmpty) {
      _selectedColor = widget.colorOptions.first;
    }
    if (widget.storageOptions.isNotEmpty) {
      _selectedStorage = widget.storageOptions.first;
    }
  }

  void _addToCart() {
    final existingItemIndex = cartNotifier.value.indexWhere(
          (item) => item.productName == widget.productName &&
          item.color == _selectedColor &&
          item.storage == _selectedStorage,
    );

    if (existingItemIndex != -1) {
      // If item exists, update quantity
      final updatedCart = List<CartItem>.from(cartNotifier.value);
      updatedCart[existingItemIndex].quantity++;
      cartNotifier.value = updatedCart;
    } else {
      // If item does not exist, add new item
      final newItem = CartItem(
        productName: widget.productName,
        brandName: widget.brandName,
        color: _selectedColor,
        storage: _selectedStorage,
        price: widget.discountedPrice,
        imagePath: widget.imagePath,
      );
      cartNotifier.value = [...cartNotifier.value, newItem];
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.productName} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.imagePath,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset('assets/laptop.jpeg', height: 250, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.productName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.brandName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    ' (${NumberFormat.compact().format(widget.reviewCount)} reviews)',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '\$${widget.discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF6B48FF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (widget.originalPrice > widget.discountedPrice)
                    Text(
                      '\$${widget.originalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[500],
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.colorOptions.isNotEmpty) ...[
                Text(
                  'Color:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: widget.colorOptions.map((color) {
                    return ChoiceChip(
                      label: Text(color),
                      selected: _selectedColor == color,
                      onSelected: (selected) {
                        setState(() {
                          _selectedColor = selected ? color : null;
                        });
                      },
                      selectedColor: const Color(0xFF6B48FF),
                      labelStyle: TextStyle(color: _selectedColor == color ? Colors.white : Colors.black),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              if (widget.storageOptions.isNotEmpty) ...[
                Text(
                  'Storage:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: widget.storageOptions.map((storage) {
                    return ChoiceChip(
                      label: Text(storage),
                      selected: _selectedStorage == storage,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStorage = selected ? storage : null;
                        });
                      },
                      selectedColor: const Color(0xFF6B48FF),
                      labelStyle: TextStyle(color: _selectedStorage == storage ? Colors.white : Colors.black),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                'Features:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF6B48FF)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cartNotifier,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          double total = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              item.imagePath,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset('assets/mobile.jpeg', width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.brandName,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                  if (item.color != null) Text('Color: ${item.color}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  if (item.storage != null) Text('Storage: ${item.storage}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    final updatedCart = List<CartItem>.from(cartNotifier.value);
                                    updatedCart[index].quantity++;
                                    cartNotifier.value = updatedCart;
                                  },
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    final updatedCart = List<CartItem>.from(cartNotifier.value);
                                    if (updatedCart[index].quantity > 1) {
                                      updatedCart[index].quantity--;
                                    } else {
                                      updatedCart.removeAt(index);
                                    }
                                    cartNotifier.value = updatedCart;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF6B48FF)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proceed to Checkout clicked!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final Map<String, dynamic> products;

  const CategoryProductsScreen({
    Key? key,
    required this.categoryName,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> productList = products.values.map((e) => Map<String, dynamic>.from(e)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
      ),
      body: productList.isEmpty
          ? const Center(child: Text('No products in this category.'))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7, // Adjust as needed
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return ProductCard(
            productName: product['productName'],
            brandName: product['brandName'],
            rating: product['rating'],
            reviewCount: product['reviewCount'],
            originalPrice: product['originalPrice'],
            discountedPrice: product['discountedPrice'],
            imagePath: product['image'],
            category: product['category'],
            features: product['features'],
            colorOptions: product['colorOptions'] ?? [],
            storageOptions: product['storageOptions'] ?? [],
          );
        },
      ),
    );
  }
}