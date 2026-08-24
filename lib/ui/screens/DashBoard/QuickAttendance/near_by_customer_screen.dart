import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/other/near_by_pincode_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_details_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_summary_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/broadcast_msg/make_call.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

// Optimized Geocoding Service with Batch Processing
class OptimizedGeocodingService {
  static final Map<String, LatLng> _coordinateCache = {};
  static final Map<String, Future<LatLng>> _pendingRequests = {};
  static DateTime _lastRequestTime = DateTime.now();
  static const int _minRequestIntervalMs = 50;
  static const int _batchSize = 10;
  static int _totalRequests = 0;
  static int _cacheHits = 0;

  static Future<Map<String, LatLng>> batchGetCoordinates(
    List<String> pincodes, {
    Function(int processed, int total, String status) onProgress,
  }) async {
    if (pincodes.isEmpty) return {};

    final results = <String, LatLng>{};
    final uniquePincodes = pincodes.where((p) => p.isNotEmpty).toSet().toList();
    final total = uniquePincodes.length;
    int processed = 0;

    print('📦 Processing ${uniquePincodes.length} unique pincodes');

    // Get cached results
    final uncachedPincodes = <String>[];
    for (var pincode in uniquePincodes) {
      if (_coordinateCache.containsKey(pincode)) {
        results[pincode] = _coordinateCache[pincode];
        _cacheHits++;
        processed++;
        onProgress?.call(processed, total, 'Using cached coordinates...');
      } else {
        uncachedPincodes.add(pincode);
      }
    }

    // Process uncached pincodes in parallel batches
    if (uncachedPincodes.isNotEmpty) {
      for (int i = 0; i < uncachedPincodes.length; i += _batchSize) {
        final end = min(i + _batchSize, uncachedPincodes.length);
        final batch = uncachedPincodes.sublist(i, end);

        onProgress?.call(processed, total,
            'Fetching batch ${i ~/ _batchSize + 1}/${(uncachedPincodes.length / _batchSize).ceil()}...');

        final batchFutures =
            batch.map((pincode) => _getCoordinatesWithCache(pincode));
        final batchResults = await Future.wait(batchFutures);

        for (int j = 0; j < batch.length; j++) {
          final pincode = batch[j];
          final coordinates = batchResults[j];
          if (coordinates != null) {
            results[pincode] = coordinates;
            _coordinateCache[pincode] = coordinates;
          }
          processed++;
          onProgress?.call(
              processed, total, 'Processed $processed/$total pincodes...');
        }

        if (i + _batchSize < uncachedPincodes.length) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    }

    return results;
  }

  static Future<LatLng> _getCoordinatesWithCache(String pincode) async {
    if (_pendingRequests.containsKey(pincode)) {
      return _pendingRequests[pincode];
    }

    final now = DateTime.now();
    final timeSinceLastRequest =
        now.difference(_lastRequestTime).inMilliseconds;
    if (timeSinceLastRequest < _minRequestIntervalMs) {
      await Future.delayed(
          Duration(milliseconds: _minRequestIntervalMs - timeSinceLastRequest));
    }

    final future = _fetchCoordinates(pincode);
    _pendingRequests[pincode] = future;

    try {
      return await future;
    } finally {
      _pendingRequests.remove(pincode);
    }
  }

  static Future<LatLng> _fetchCoordinates(String pincode) async {
    try {
      _totalRequests++;
      _lastRequestTime = DateTime.now();

      final locations = await locationFromAddress('$pincode, India');

      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      print('❌ Error geocoding pincode $pincode: $e');
    }
    return null;
  }

  static void clearCache() {
    _coordinateCache.clear();
    _pendingRequests.clear();
    _totalRequests = 0;
    _cacheHits = 0;
  }

  static Map<String, dynamic> getStats() {
    return {
      'cacheSize': _coordinateCache.length,
      'totalRequests': _totalRequests,
      'cacheHits': _cacheHits,
      'hitRate': _totalRequests > 0
          ? (_cacheHits / _totalRequests * 100).toStringAsFixed(1)
          : '0'
    };
  }
}

class NearByPinCodeScreen extends BaseStatefulWidget {
  static const routeName = '/NearByPinCodeScreen';

  @override
  _NearByPinCodeScreenState createState() => _NearByPinCodeScreenState();
}

class _NearByPinCodeScreenState extends BaseState<NearByPinCodeScreen>
    with
        BasicScreen<NearByPinCodeScreen>,
        TickerProviderStateMixin<NearByPinCodeScreen> {
  MainBloc _mainBloc;

  // User Data
  LoginUserDetialsResponse _offlineLoggedInData = LoginUserDetialsResponse();
  CompanyDetailsResponse _offlineCompanyData = CompanyDetailsResponse();
  int _companyId = 0;
  String _loginUserId = "";

  // API Responses
  SOCustomerNearByPinCodeSummaryResponse _summaryResponse;
  SOCustomerNearByPinCodeDetailsResponse _detailResponse;

  // Controllers
  final TextEditingController _pinSearchController = TextEditingController();
  final TextEditingController _productSearchController =
      TextEditingController();
  final TextEditingController _radiusController =
      TextEditingController(text: '150');

  // Map Controllers
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  // State
  bool _isLoading = false;
  bool _isSummaryMode = true;
  String _selectedCustomerName = "";
  int _selectedCustomerId = 0;
  String _currentSearchPincode = "";
  double _searchRadius = 150.0;
  bool _isSearchExpanded = true;
  String _geocodingStatus = "";

  // Product Selection
  String _selectedProductName = "";
  int _selectedProductId = 0;
  List<ProductSearchDetails> _productSearchResults = [];
  Timer _searchDebounceTimer;

  // Optimized data structures
  List<SOCustomerNearByPinCodeSummaryResponseDetails> _customersWithLocation =
      [];
  List<SOCustomerNearByPinCodeSummaryResponseDetails>
      _customersWithoutLocation = [];
  final Map<String, LatLng> _pincodeCoordinateCache = {};
  final Map<String, List<SOCustomerNearByPinCodeSummaryResponseDetails>>
      _customersByPincode = {};

  // Animation controllers
  AnimationController _animationController;
  Animation<double> _searchAnimation;
  Animation<double> _fadeAnimation;

  // For clustering markers
  final Map<String, int> _overlapCount = {};

  // Screen dimensions
  double screenWidth = 0;
  double screenHeight = 0;
  double topPadding = 0;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Colors.transparent;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _loadUserData();
    _mainBloc = MainBloc(baseBloc);
    _radiusController.text = _searchRadius.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isSearchExpanded = true);
      _animationController.forward();
    });
  }

  void _loadUserData() {
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    if (_offlineCompanyData.details?.isNotEmpty == true) {
      _companyId = _offlineCompanyData.details[0].pkId;
    }

    if (_offlineLoggedInData.details?.isNotEmpty == true) {
      _loginUserId = _offlineLoggedInData.details[0].userID ?? "";
    }
  }

  @override
  void dispose() {
    _pinSearchController.dispose();
    _productSearchController.dispose();
    _radiusController.dispose();
    _animationController.dispose();
    _searchDebounceTimer?.cancel();
    _mainBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    topPadding = MediaQuery.of(context).padding.top;

    return BlocProvider.value(
      value: _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        listener: (context, state) {
          if (state is SOCustomerNearByPinCodeSummaryResponseState) {
            _onSummaryResponse(state);
          }
          if (state is SOCustomerNearByPinCodeDetailsResponseState) {
            _onDetailResponse(state);
          }
          if (state is InquiryProductSearchResponseState) {
            _onProductSearchResponse(state);
          }
        },
        builder: (context, state) {
          return buildBody(context);
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            _buildMap(),
            _buildTopGradient(),
            _buildAnimatedSearchBar(),
            _buildModeToggle(),
            if (_isLoading) _buildLoadingOverlay(),
            if (!_isLoading && _currentSearchPincode.isNotEmpty)
              _buildBottomStatsCard(),
            _buildMyLocationButton(),
            if (_isLoading && _pincodeCoordinateCache.isNotEmpty)
              _buildCacheStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(23.092458, 72.555963),
        zoom: 6.0,
      ),
      markers: _markers,
      circles: _circles,
      onMapCreated: (GoogleMapController controller) {
        if (!_mapController.isCompleted) _mapController.complete(controller);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
      buildingsEnabled: true,
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      padding: EdgeInsets.only(
        top: _isSearchExpanded ? screenHeight * 0.5 : screenHeight * 0.25,
        bottom: 100,
        left: 10,
        right: 10,
      ),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: _isSearchExpanded ? screenHeight * 0.55 : screenHeight * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return AnimatedBuilder(
      animation: _searchAnimation,
      builder: (context, child) {
        return Positioned(
          top: topPadding + 8,
          left: 12,
          right: 12,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: _isSearchExpanded ? screenHeight * 0.5 : 70,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isSearchExpanded
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMainSearchRow(),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildExpandedSearchOptions(),
                          ),
                        ],
                      ),
                    )
                  : _buildMainSearchRow(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainSearchRow() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              navigateTo(context, HomeScreen.routeName, clearAllStack: true);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Color(0xFF1976D2), size: 24),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _pinSearchController,
              decoration: const InputDecoration(
                hintText: 'Enter pincode...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50)),
              onSubmitted: (_) => _onSummarySearchPressed(),
            ),
          ),
          IconButton(
            icon: AnimatedRotation(
              turns: _isSearchExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF1976D2), size: 28),
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                _isSearchExpanded
                    ? _animationController.forward()
                    : _animationController.reverse();
              });
            },
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: _isSummaryMode
                    ? _onSummarySearchPressed
                    : _onDetailSearchPressed,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    _isSummaryMode ? 'Search' : 'Apply',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSearchOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 12),

          // Radius Selector
          const Text('Search Radius',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.radar_rounded,
                          size: 20, color: Color(0xFF1976D2)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _radiusController,
                          decoration: const InputDecoration(
                            hintText: 'Radius',
                            border: InputBorder.none,
                            suffixText: 'km',
                            suffixStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          onChanged: (value) =>
                              _searchRadius = double.tryParse(value) ?? 150.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 16, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Text('Max 500 km',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1976D2))),
                  ],
                ),
              ),
            ],
          ),

          // Product Filter with Selection
          const SizedBox(height: 16),
          const Text('Filter by Product',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              if (_pinSearchController.text.trim().isEmpty) {
                _showErrorSnackBar('Please enter pincode first');
              } else {
                _showProductSearchBottomSheet();
              }
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_rounded,
                      size: 20, color: Color(0xFF1976D2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedProductName.isEmpty
                          ? 'Select product to filter customers...'
                          : _selectedProductName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _selectedProductName.isEmpty
                            ? FontWeight.normal
                            : FontWeight.w600,
                        color: _selectedProductName.isEmpty
                            ? Colors.grey
                            : const Color(0xFF2C3E50),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedProductName.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedProductName = "";
                          _selectedProductId = 0;
                          _productSearchController.clear();
                        });
                        if (_currentSearchPincode.isNotEmpty) {
                          _onSummarySearchPressed();
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
                ],
              ),
            ),
          ),

          // Rest of your existing code...
          // Selected Customer (Detail Mode only)
          if (!_isSummaryMode && _selectedCustomerName.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFF1976D2).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF1976D2),
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selected Customer',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          _selectedCustomerName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: _switchToSummaryMode,
                  ),
                ],
              ),
            ),
          ],

          // Summary Stats
          if (_isSummaryMode && _customersWithLocation.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Customers Found',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          '${_customersWithLocation.length} within ${_searchRadius.toStringAsFixed(0)}km',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  ),
                  if (_customersWithoutLocation.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_customersWithoutLocation.length} no location',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFFED6C02)),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Product filter hint when in detail mode
          if (!_isSummaryMode) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFF1976D2)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Product filter is applied in customer search. Switch to Customers mode to change product filter.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1976D2)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Positioned(
      top: topPadding + (_isSearchExpanded ? screenHeight * 0.46 : 85),
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: _buildModeChip('Customers', true)),
            Expanded(child: _buildModeChip('Orders', false)),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip(String text, bool isSummary) {
    final isSelected = _isSummaryMode == isSummary;
    return Material(
      color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          if (isSelected) return;
          setState(() {
            _isSummaryMode = isSummary;
            if (isSummary) {
              _selectedCustomerName = "";
              _selectedCustomerId = 0;
              if (_currentSearchPincode.isNotEmpty) {
                _processSummaryCoordinates();
              }
            } else {
              if (_selectedCustomerId > 0) {
                _onDetailSearchPressed();
              }
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 120,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _centerToMyLocation,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.my_location_rounded,
                  color: Color(0xFF1976D2), size: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCacheStats() {
    final stats = OptimizedGeocodingService.getStats();
    return Positioned(
      bottom: 180,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.speed, size: 14, color: Color(0xFF1976D2)),
            const SizedBox(width: 4),
            Text(
              '${stats['cacheSize']} cached • ${stats['hitRate']}% hits',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1976D2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Searching...',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50))),
              const SizedBox(height: 8),
              Text(_geocodingStatus,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center),
              if (_pincodeCoordinateCache.isNotEmpty) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: null,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cached: ${_pincodeCoordinateCache.length} locations',
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1976D2),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomStatsCard() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.location_on_rounded,
              value: _currentSearchPincode,
              label: 'Pincode',
              color: const Color(0xFF1976D2),
            ),
            Container(width: 1, height: 30, color: Colors.grey[300]),
            _buildStatItem(
              icon: Icons.radar_rounded,
              value: '${_searchRadius.toStringAsFixed(0)} km',
              label: 'Radius',
              color: const Color(0xFFFF6B6B),
            ),
            Container(width: 1, height: 30, color: Colors.grey[300]),
            _buildStatItem(
              icon: _isSummaryMode
                  ? Icons.people_rounded
                  : Icons.shopping_cart_rounded,
              value: _isSummaryMode
                  ? '${_customersWithLocation.length}'
                  : '${_detailResponse?.details?.length ?? 0}',
              label: _isSummaryMode ? 'Customers' : 'Orders',
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      {IconData icon, String value, String label, Color color}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _centerToMyLocation() async {
    // Implement if needed
  }

  void _onSummaryResponse(SOCustomerNearByPinCodeSummaryResponseState state) {
    setState(() {
      _isLoading = false;
      _summaryResponse = state.sOCustomerNearByPinCodeSummaryResponse;
    });
    _processSummaryCoordinates();
  }

  Future<void> _processSummaryCoordinates() async {
    if (_currentSearchPincode.isEmpty) return;

    setState(() {
      _isLoading = true;
      _geocodingStatus = 'Getting center location...';
      _customersWithLocation.clear();
      _customersWithoutLocation.clear();
      _pincodeCoordinateCache.clear();
      _customersByPincode.clear();
    });

    // Get center point coordinates
    final centerPoint = await OptimizedGeocodingService.batchGetCoordinates(
        [_currentSearchPincode]).then((map) => map[_currentSearchPincode]);

    if (centerPoint == null) {
      setState(() => _isLoading = false);
      _showErrorSnackBar(
          'Could not find coordinates for pincode: $_currentSearchPincode');
      return;
    }

    // Group customers by pincode first (reduces geocoding calls)
    final customers = _summaryResponse?.details ?? [];
    for (var customer in customers) {
      if (customer.pinCode == null || customer.pinCode.isEmpty) {
        _customersWithoutLocation.add(customer);
        continue;
      }
      _customersByPincode.putIfAbsent(customer.pinCode, () => []).add(customer);
    }

    setState(() {
      _geocodingStatus =
          'Fetching coordinates for ${_customersByPincode.length} unique pincodes...';
    });

    // BATCH FETCH all unique pincodes at once
    final allPincodes = _customersByPincode.keys.toList();
    final coordinatesMap = await OptimizedGeocodingService.batchGetCoordinates(
      allPincodes,
      onProgress: (processed, total, status) {
        setState(() => _geocodingStatus = status);
      },
    );

    setState(() {
      _geocodingStatus =
          'Calculating distances for ${customers.length} customers...';
    });

    // Calculate distances and filter customers
    final List<SOCustomerNearByPinCodeSummaryResponseDetails> tempWithLocation =
        [];

    for (var entry in _customersByPincode.entries) {
      final pincode = entry.key;
      final customersAtPincode = entry.value;
      final customerPoint = coordinatesMap[pincode];

      if (customerPoint == null) {
        _customersWithoutLocation.addAll(customersAtPincode);
        continue;
      }

      // Calculate distance once per pincode
      final distance = _calculateDistance(
          centerPoint.latitude,
          centerPoint.longitude,
          customerPoint.latitude,
          customerPoint.longitude);

      if (distance <= _searchRadius) {
        tempWithLocation.addAll(customersAtPincode);
      } else {
        _customersWithoutLocation.addAll(customersAtPincode);
      }
    }

    setState(() {
      _customersWithLocation = tempWithLocation;
      _isLoading = false;
      _geocodingStatus = '';
    });

    final stats = OptimizedGeocodingService.getStats();
    print('📍 Center: $_currentSearchPincode at $centerPoint');
    print(
        '📊 Found ${_customersWithLocation.length} customers within ${_searchRadius}km');
    print(
        '⚠️ ${_customersWithoutLocation.length} customers without location data');
    print(
        '💾 Cache Stats: ${stats['cacheSize']} locations, ${stats['hitRate']}% hit rate');
    print(
        '⚡ API Calls: ${stats['totalRequests']} (instead of ${customers.length})');

    _updateMarkersFromSummaryWithCoordinates(
        centerPoint, _customersWithLocation);
    _showRadiusOnMap(centerPoint);
  }

  void _onDetailResponse(SOCustomerNearByPinCodeDetailsResponseState state) {
    setState(() {
      _isLoading = false;
      _detailResponse = state.sOCustomerNearByPinCodeDetailsResponse;
    });
    _processDetailCoordinates();
  }

  Future<void> _processDetailCoordinates() async {
    if (_currentSearchPincode.isEmpty) return;

    final centerPoint = await OptimizedGeocodingService.batchGetCoordinates(
        [_currentSearchPincode]).then((map) => map[_currentSearchPincode]);
    if (centerPoint == null) return;

    _updateMarkersFromDetailsWithCoordinates(centerPoint);
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * pi / 180;

  void _showRadiusOnMap(LatLng centerPoint) {
    setState(() {
      _circles = {
        Circle(
          circleId: CircleId('radius_$_currentSearchPincode'),
          center: centerPoint,
          radius: _searchRadius * 1000,
          fillColor: const Color(0xFF1976D2).withOpacity(0.1),
          strokeColor: const Color(0xFF1976D2),
          strokeWidth: 2,
        ),
      };
    });
  }

  Future<void> _updateMarkersFromSummaryWithCoordinates(LatLng centerPoint,
      List<SOCustomerNearByPinCodeSummaryResponseDetails> customers) async {
    _overlapCount.clear();
    final newMarkers = <Marker>{};

    // Add center marker
    newMarkers.add(Marker(
      markerId: MarkerId('search_center_$_currentSearchPincode'),
      position: centerPoint,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Search Center',
        snippet: '📍 $_currentSearchPincode\n🎯 $_searchRadius km radius',
      ),
    ));

    // Group by pincode for efficiency
    final customersByPincode =
        <String, List<SOCustomerNearByPinCodeSummaryResponseDetails>>{};
    for (var customer in customers) {
      if (customer.pinCode != null && customer.pinCode.isNotEmpty) {
        customersByPincode
            .putIfAbsent(customer.pinCode, () => [])
            .add(customer);
      }
    }

    // Get coordinates for all pincodes at once
    final coordinatesMap = await OptimizedGeocodingService.batchGetCoordinates(
        customersByPincode.keys.toList());

    // Create markers
    for (var entry in customersByPincode.entries) {
      final pincode = entry.key;
      final customersAtPincode = entry.value;
      final customerPoint = coordinatesMap[pincode];

      if (customerPoint == null) continue;

      final adjustedPos =
          _adjustPosition(customerPoint.latitude, customerPoint.longitude);
      final distance = _calculateDistance(
          centerPoint.latitude,
          centerPoint.longitude,
          customerPoint.latitude,
          customerPoint.longitude);

      // If multiple customers at same pincode, create one marker with count
      if (customersAtPincode.length > 1) {
        newMarkers.add(Marker(
          markerId: MarkerId('customer_group_$pincode'),
          position: adjustedPos,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(
            title: '${customersAtPincode.length} Customers',
            snippet: '📍 $pincode\n📏 ${distance.toStringAsFixed(1)} km',
          ),
          onTap: () => _showCustomerGroupDetails(
              customersAtPincode, distance.toStringAsFixed(1)),
        ));
      } else {
        final customer = customersAtPincode.first;
        newMarkers.add(Marker(
          markerId: MarkerId('customer_${customer.customerID}'),
          position: adjustedPos,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: customer.customerName ?? 'Unknown Customer',
            snippet: '📍 $pincode\n📏 ${distance.toStringAsFixed(1)} km',
          ),
          onTap: () => _showCustomerDetails(
              customer, '${distance.toStringAsFixed(1)} km'),
        ));
      }
    }

    setState(() => _markers = newMarkers);
    _centerMapOnMarkers();
  }

  void _showCustomerGroupDetails(
      List<SOCustomerNearByPinCodeSummaryResponseDetails> customers,
      String distanceText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200])),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.group,
                        color: Color(0xFF1976D2), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Customers at this location',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text('${customers.length} customers • $distanceText',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
                      child: const Icon(Icons.person,
                          color: Color(0xFF1976D2), size: 20),
                    ),
                    title: Text(customer.customerName ?? 'Unknown'),
                    subtitle: Text(
                        'ID: ${customer.customerID ?? 'N/A'} • ${customer.customerType ?? ''}'),
                    onTap: () {
                      Navigator.pop(context);
                      _onCustomerSelected(customer);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateMarkersFromDetailsWithCoordinates(
      LatLng centerPoint) async {
    _overlapCount.clear();
    final newMarkers = <Marker>{};

    // Group orders by customer
    final ordersByCustomer =
        <int, List<SOCustomerNearByPinCodeDetailsResponseDetails>>{};
    for (var order in _detailResponse?.details ?? []) {
      ordersByCustomer.putIfAbsent(order.customerID ?? 0, () => []).add(order);
    }

    // Add center marker
    newMarkers.add(Marker(
      markerId: MarkerId('search_center_$_currentSearchPincode'),
      position: centerPoint,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Search Center',
        snippet: '📍 $_currentSearchPincode\n🎯 $_searchRadius km radius',
      ),
    ));

    // Get unique pincodes for batch processing
    final pincodes = ordersByCustomer.values
        .map((orders) => orders.first.pinCode)
        .where((p) => p != null && p.isNotEmpty)
        .map((p) => p)
        .toSet()
        .toList();

    final coordinatesMap =
        await OptimizedGeocodingService.batchGetCoordinates(pincodes);

    int markerIndex = 0;
    for (var entry in ordersByCustomer.entries) {
      final orders = entry.value;
      final firstOrder = orders.first;

      if (firstOrder.pinCode == null || firstOrder.pinCode.isEmpty) continue;

      final orderPoint = coordinatesMap[firstOrder.pinCode];
      if (orderPoint == null) continue;

      final adjustedPos =
          _adjustPosition(orderPoint.latitude, orderPoint.longitude);
      final distance = _calculateDistance(centerPoint.latitude,
          centerPoint.longitude, orderPoint.latitude, orderPoint.longitude);

      final hue = orders.length > 3
          ? BitmapDescriptor.hueRed
          : orders.length > 1
              ? BitmapDescriptor.hueOrange
              : BitmapDescriptor.hueGreen;

      newMarkers.add(Marker(
        markerId: MarkerId('customer_orders_${entry.key}_$markerIndex'),
        position: adjustedPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        infoWindow: InfoWindow(
          title: firstOrder.customerName ?? 'Customer',
          snippet:
              '📦 ${orders.length} order${orders.length > 1 ? 's' : ''}\n📍 ${firstOrder.pinCode}\n📏 ${distance.toStringAsFixed(1)} km',
        ),
        onTap: () => _showOrderDetails(orders),
      ));
      markerIndex++;
    }

    setState(() => _markers = newMarkers);
    _centerMapOnMarkers();
  }

  LatLng _adjustPosition(double lat, double lng) {
    final key = "${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}";
    _overlapCount[key] = (_overlapCount[key] ?? 0) + 1;
    final count = _overlapCount[key];
    final delta = 0.00002 * count;
    return LatLng(lat + delta, lng + delta);
  }

  Future<void> _centerMapOnMarkers() async {
    if (_markers.isEmpty || !_mapController.isCompleted) return;

    try {
      final controller = await _mapController.future;

      double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

      for (var marker in _markers) {
        minLat = min(minLat, marker.position.latitude);
        maxLat = max(maxLat, marker.position.latitude);
        minLng = min(minLng, marker.position.longitude);
        maxLng = max(maxLng, marker.position.longitude);
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - 0.05, minLng - 0.05),
        northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
      );

      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      print('Error centering map: $e');
    }
  }

  void _showCustomerDetails(
      SOCustomerNearByPinCodeSummaryResponseDetails customer,
      String distanceText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.business_center_rounded,
                      color: Color(0xFF1976D2), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.customerName ?? 'Customer Details',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50)),
                      ),
                      const SizedBox(height: 4),
                      Text('ID: ${customer.customerID ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailChip(
                Icons.phone, 'Contact No', customer.contactNo1 ?? 'N/A', () {
              MakeCall.callto(customer.contactNo1);
            }),
            const SizedBox(height: 12),
            _buildDetailChip(Icons.email, 'Email Address',
                customer.emailAddress ?? 'N/A', () {}),
            const SizedBox(height: 12),
            _buildDetailChip(Icons.location_city, 'Address',
                customer.address ?? 'N/A', () {}),
            const SizedBox(height: 12),
            _buildDetailChip(Icons.location_on_rounded, 'Pincode',
                customer.pinCode ?? 'N/A', () {}),
            const SizedBox(height: 12),
            _buildDetailChip(Icons.category_rounded, 'Type',
                customer.customerType ?? 'N/A', () {}),
            if (distanceText.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailChip(
                  Icons.straighten_rounded, 'Distance', distanceText, () {}),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _onCustomerSelected(customer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Orders'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(
      List<SOCustomerNearByPinCodeDetailsResponseDetails> orders) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200])),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_cart_rounded,
                        color: Color(0xFF4CAF50), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Orders',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                        Text(
                          orders.first.customerName ?? 'Customer',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0xFF1976D2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      '${orders.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.orderNo ?? 'No Order No',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '₹${order.unitRate?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4CAF50)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.inventory_rounded,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  order.productName ?? 'N/A',
                                  style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF616161)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (order.orderDate?.isNotEmpty == true) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    size: 14, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(order.orderDate),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
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

  Widget _buildDetailChip(
      IconData icon, String label, String value, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive scaling factor
    final scale = screenWidth / 375; // 375 = base mobile width

    final iconSize = 18 * scale.clamp(0.9, 1.3);
    final labelSize = 12 * scale.clamp(0.9, 1.3);
    final valueSize = 14 * scale.clamp(0.9, 1.3);
    final paddingSize = 12 * scale.clamp(0.9, 1.3);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(paddingSize),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12 * scale.clamp(0.9, 1.2)),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: const Color(0xFF1976D2),
            ),
            SizedBox(width: 12 * scale.clamp(0.9, 1.3)),

            // Expanded prevents overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: labelSize,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: valueSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      return dateStr.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd MMM yyyy");
    } catch (e) {
      return dateStr;
    }
  }

  void _onSummarySearchPressed() {
    final pinSearchKey = _pinSearchController.text.trim();
    final radiusText = _radiusController.text.trim();

    if (pinSearchKey.isEmpty) {
      _showErrorSnackBar('Please enter pincode');
      return;
    }

    if (pinSearchKey.length < 3) {
      _showErrorSnackBar('Enter at least 3 digits');
      return;
    }

    _searchRadius = double.tryParse(radiusText) ?? 150.0;
    if (_searchRadius <= 0) {
      _showErrorSnackBar('Please enter a valid radius');
      return;
    }

    // Store current search values
    _currentSearchPincode = pinSearchKey;

    // Clear caches
    OptimizedGeocodingService.clearCache();

    setState(() {
      _isLoading = true;
      _isSummaryMode = true;
      _selectedCustomerName = "";
      _selectedCustomerId = 0;
      _markers.clear();
      _circles.clear();
      _customersWithLocation.clear();
      _customersWithoutLocation.clear();
      _geocodingStatus = 'Fetching customer data...';
    });

    print(
        '🔍 Searching with product filter: "$_selectedProductName" (ID: $_selectedProductId)');

    final request = SOCustomerNearByPinCodeCommonRequest(
      Mode: "Summary",
      PinSearchKey: pinSearchKey,
      ProductSearchKey: _selectedProductName,
      CustomerID: "",
      LoginUserID: _loginUserId,
      CompanyId: _companyId.toString(),
    );

    _mainBloc.add(SOCustomerNearByPinCodeSummaryRequestEvent(request));
  }

  void _onDetailSearchPressed() {
    if (_selectedCustomerId == 0) {
      _showErrorSnackBar('Please select a customer first');
      return;
    }

    setState(() => _isLoading = true);

    final request = SOCustomerNearByPinCodeCommonRequest(
      Mode: "Detail",
      PinSearchKey: _pinSearchController.text.trim(),
      ProductSearchKey: _selectedProductName,
      CustomerID: _selectedCustomerId.toString(),
      LoginUserID: _loginUserId,
      CompanyId: _companyId.toString(),
    );

    _mainBloc.add(SOCustomerNearByPinCodeDetailsRequestEvent(request));
  }

  void _onCustomerSelected(
      SOCustomerNearByPinCodeSummaryResponseDetails customer) {
    setState(() {
      _isSummaryMode = false;
      _selectedCustomerName = customer.customerName ?? '';
      _selectedCustomerId = customer.customerID ?? 0;
      _isLoading = true;
    });

    final request = SOCustomerNearByPinCodeCommonRequest(
      Mode: "Detail",
      PinSearchKey: _pinSearchController.text.trim(),
      ProductSearchKey: _selectedProductName,
      CustomerID: _selectedCustomerId.toString(),
      LoginUserID: _loginUserId,
      CompanyId: _companyId.toString(),
    );

    _mainBloc.add(SOCustomerNearByPinCodeDetailsRequestEvent(request));
  }

  void _switchToSummaryMode() {
    setState(() {
      _isSummaryMode = true;
      _selectedCustomerName = "";
      _selectedCustomerId = 0;
    });

    if (_currentSearchPincode.isNotEmpty) {
      _processSummaryCoordinates();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (!_isSummaryMode) {
      _switchToSummaryMode();
      return false;
    }
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }

// Product Search Methods
  void _showProductSearchBottomSheet() {
    _productSearchController.clear();
    _productSearchResults.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        height: screenHeight * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with drag handle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200])),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_rounded,
                            color: Color(0xFF1976D2), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Select Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search,
                        color: Color(0xFF1976D2), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _productSearchController,
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onChanged: _onProductSearchChanged,
                        autofocus: true,
                      ),
                    ),
                    if (_productSearchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _productSearchController.clear();
                          setState(() {
                            _productSearchResults.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Results Count
            if (_productSearchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${_productSearchResults.length} products found',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Results List
            Expanded(
              child: _productSearchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_rounded,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching with a different keyword',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _productSearchResults.length,
                      itemBuilder: (context, index) {
                        final product = _productSearchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                _selectedProductName =
                                    product.productName ?? '';
                                _selectedProductId = product.pkID ?? 0;
                              });
                              Navigator.pop(context);
                              if (_currentSearchPincode.isNotEmpty) {
                                _onSummarySearchPressed();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1976D2)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_rounded,
                                      color: Color(0xFF1976D2),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName ?? 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                        if (product.productNameLong != null &&
                                            product.productNameLong.isNotEmpty)
                                          Text(
                                            product.productNameLong,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if (product.unitPrice != null &&
                                            product.unitPrice > 0)
                                          Text(
                                            '₹${product.unitPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF4CAF50),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _onProductSearchChanged(String value) {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer.cancel();
    }

    if (value.isEmpty) {
      setState(() {
        _productSearchResults.clear();
      });
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchProducts(value);
    });
  }

  void _searchProducts(String searchKey) {
    print('🔍 Searching products with key: "$searchKey"');

    final request = InquiryProductSearchRequest(
      pkID: "",
      CompanyId: _companyId.toString(),
      ListMode: "L",
      SearchKey: searchKey,
    );

    _mainBloc.add(InquiryProductSearchNameCallEvent(request));
  }

  void _onProductSearchResponse(InquiryProductSearchResponseState state) {
    setState(() {
      _productSearchResults = state.inquiryProductSearchResponse.details ?? [];
    });
    print('📦 Found ${_productSearchResults.length} products');
  }
}
