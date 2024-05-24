// restaurant_reservation.dart
import 'package:flutter/material.dart';
import 'package:unifood/model/reservation_entity.dart';
import 'package:unifood/controller/reservation_controller.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/view/reviews/create/widgets/restaurant_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
class RestaurantReservation extends StatefulWidget {
  final ReservationController reservationController;
  final Future<List<Restaurant>> restaurantsFuture;
  final String userId;

  RestaurantReservation({
    required this.reservationController,
    required this.restaurantsFuture,
    required this.userId,
  });

  @override
  _RestaurantReservationState createState() => _RestaurantReservationState();
}

class _RestaurantReservationState extends State<RestaurantReservation> {
  Restaurant? _selectedRestaurant; // Make it nullable
  DateTime _selectedDateTime = DateTime.now();
  int _numberOfPeople = 1;
  late Future<List<Reservation>> _reservationsFuture;
  List<Reservation> _localReservations = [];
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadLocalReservations();
    _reservationsFuture = widget.reservationController.getUserReservations(widget.userId);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  Future<void> _loadLocalReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final reservationsString = prefs.getString('reservations_${widget.userId}');
    if (reservationsString != null) {
      final List<dynamic> reservationsJson = jsonDecode(reservationsString);
      _localReservations = reservationsJson.map((json) => Reservation.fromJson(json)).toList();
    }
  }

  Future<void> _saveLocalReservations(List<Reservation> reservations) async {
    final prefs = await SharedPreferences.getInstance();
    final reservationsString = jsonEncode(reservations.map((reservation) => reservation.toJson()).toList());
    await prefs.setString('reservations_${widget.userId}', reservationsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Reservation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0), // Adjust the top padding as needed
          child: Column(
            children: [
              if (!_isConnected && _localReservations.isEmpty)
                Column(
                  children: [
                    _buildNoInternetConnectionMessage(),
                    _buildNoInternetConnectionMessage(),
                  ],
                )
              else ...[
                _buildMakeReservationSection(),
                Divider(),
                Text(
                  'My Current Reservations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _isConnected ? _buildCurrentReservations() : _buildLocalReservations(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMakeReservationSection() {
    return FutureBuilder<List<Restaurant>>(
      future: widget.restaurantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (_selectedRestaurant == null && snapshot.data != null && snapshot.data!.isNotEmpty) {
            _selectedRestaurant = snapshot.data!.first;
          }
          return Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      RestaurantDropdown(
                        initialValue: _selectedRestaurant!,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRestaurant = newValue;
                          });
                        },
                        restaurants: snapshot.data!,
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Select Date and Time'),
                        subtitle: Text('${DateFormat('yyyy-MM-dd').format(_selectedDateTime)} ${DateFormat('hh:mm a').format(_selectedDateTime)}'),
                        trailing: Icon(Icons.calendar_today),
                        onTap: _pickDateTime,
                      ),
                      ListTile(
                        title: Text('Number of People'),
                        trailing: DropdownButton<int>(
                          value: _numberOfPeople,
                          onChanged: (value) {
                            setState(() {
                              _numberOfPeople = value!;
                            });
                          },
                          items: List.generate(20, (index) => index + 1)
                              .map((e) => DropdownMenuItem<int>(
                                    value: e,
                                    child: Text(e.toString()),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isConnected ? _makeReservation : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          child: Text(
                            'Reserve',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      if (!_isConnected)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'No internet connection, try again later',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCurrentReservations() {
    return FutureBuilder<List<Reservation>>(
      future: _reservationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final reservations = snapshot.data!;
          _saveLocalReservations(reservations); // Save to local storage
          return _buildReservationsList(reservations);
        }
      },
    );
  }

  Widget _buildLocalReservations() {
    return _buildReservationsList(_localReservations);
  }

  Widget _buildReservationsList(List<Reservation> reservations) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
              child: Image.network(
                reservation.logoUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(reservation.restaurantName),
            subtitle: Text(
                '${DateFormat('yyyy-MM-dd').format(reservation.dateTime)} ${DateFormat('hh:mm a').format(reservation.dateTime)} - ${reservation.numberOfPeople} ${reservation.numberOfPeople == 1 ? 'person' : 'people'}'),
            trailing: _isConnected
                ? IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReservation(reservation),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.red),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: null,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildNoInternetConnectionMessage() {
    return Column(
      children: [
        Icon(
          Icons.wifi_off,
          color: Colors.red,
          size: 40,
        ),
        Text(
          'No internet connection',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _makeReservation() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection, try again later')),
        );
        return;
      }

      print('Making reservation...');
      final reservation = Reservation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantName: _selectedRestaurant!.name,
        dateTime: _selectedDateTime,
        numberOfPeople: _numberOfPeople,
        logoUrl: _selectedRestaurant!.logoUrl, // Add this field
      );
      await widget.reservationController.createReservation(
        userId: widget.userId,
        reservation: reservation,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation made successfully!')),
      );
      // Refresh the reservations list after making a new reservation
      setState(() {
        _reservationsFuture = widget.reservationController.getUserReservations(widget.userId);
      });
    } catch (e) {
      print('Error making reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to make reservation: $e')),
      );
    }
  }

  Future<void> _deleteReservation(Reservation reservation) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
        _localReservations.removeWhere((res) => res.id == reservation.id);
        _saveLocalReservations(_localReservations);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection. Reservation deleted locally.')),
      );
      return;
    }

    try {
      await widget.reservationController.deleteReservation(widget.userId, reservation.id);
      setState(() {
        _localReservations.removeWhere((res) => res.id == reservation.id);
        _reservationsFuture = widget.reservationController.getUserReservations(widget.userId);
        _saveLocalReservations(_localReservations);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reservation: $e')),
      );
    }
  }
}