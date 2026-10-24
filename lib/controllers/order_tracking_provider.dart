import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';

enum OrderStatus {
  placed,
  confirmed,
  packed,
  outForDelivery,
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get title {
    switch (this) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.packed:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivered:
        return 4;
    }
  }
}

class OrderNotification {
  final String title;
  final String message;
  final DateTime timestamp;

  OrderNotification({
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

class ActiveOrderModel {
  final String orderId;
  final DateTime placedAt;
  final List<Product> items;
  final double grandTotal;
  int remainingSeconds; // Starts at 300 (5 minutes)
  OrderStatus status;
  int? userRating;
  bool isCompleted;

  ActiveOrderModel({
    required this.orderId,
    required this.placedAt,
    required this.items,
    required this.grandTotal,
    this.remainingSeconds = 300,
    this.status = OrderStatus.placed,
    this.userRating,
    this.isCompleted = false,
  });
}

class OrderTrackingProvider extends ChangeNotifier {
  ActiveOrderModel? _activeOrder;
  Timer? _timer;
  OrderNotification? _latestNotification;
  Timer? _notificationTimer;

  // Rating modal state managed centrally for Stateless components
  bool isRatingDialogShown = false;
  int selectedRating = 5;
  bool isRatingSubmitting = false;
  bool isThankYouShown = false;

  ActiveOrderModel? get activeOrder => _activeOrder;
  bool get hasActiveOrder => _activeOrder != null && !_activeOrder!.isCompleted;
  int get remainingSeconds => _activeOrder?.remainingSeconds ?? 0;
  OrderStatus get currentStatus => _activeOrder?.status ?? OrderStatus.placed;
  OrderNotification? get latestNotification => _latestNotification;

  String get remainingTimeString {
    if (_activeOrder == null) return '00:00';
    final minutes = (_activeOrder!.remainingSeconds / 60).floor();
    final seconds = _activeOrder!.remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get remainingMinutesOnlyString {
    if (_activeOrder == null) return '0 mins';
    final minutes = (_activeOrder!.remainingSeconds / 60).ceil();
    return '$minutes ${minutes == 1 ? 'min' : 'mins'}';
  }

  /// Compact min string specifically for Floating Live-Status Capsule (e.g. "5 min", "4 min", "3 min")
  String get capsuleMinsString {
    if (_activeOrder == null) return '0 min';
    final minutes = (_activeOrder!.remainingSeconds / 60).ceil();
    return '$minutes min';
  }

  void startOrder({
    required List<Product> items,
    required double grandTotal,
  }) {
    _timer?.cancel();
    _notificationTimer?.cancel();

    isRatingDialogShown = false;
    selectedRating = 5;
    isRatingSubmitting = false;
    isThankYouShown = false;

    // Generate random Order ID e.g. ZY24S6B278
    final orderId = 'ZY24S${(1000 + DateTime.now().millisecond % 9000).toString()}';

    _activeOrder = ActiveOrderModel(
      orderId: orderId,
      placedAt: DateTime.now(),
      items: List.from(items),
      grandTotal: grandTotal,
      remainingSeconds: 300, // 5 minutes
      status: OrderStatus.placed,
    );

    _triggerNotification(
      'Order Placed!',
      'evermi is preparing your order. Total: ₹${grandTotal.toStringAsFixed(0)}',
    );

    _startCountdownTimer();
    notifyListeners();
  }

  void setSelectedRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void markRatingDialogShown() {
    isRatingDialogShown = true;
  }

  void setRatingSubmitting(bool value) {
    isRatingSubmitting = value;
    notifyListeners();
  }

  void setThankYouShown(bool value) {
    isThankYouShown = value;
    notifyListeners();
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_activeOrder == null || _activeOrder!.isCompleted) {
        timer.cancel();
        return;
      }

      if (_activeOrder!.remainingSeconds > 0) {
        _activeOrder!.remainingSeconds--;

        final oldStatus = _activeOrder!.status;
        final newStatus = _calculateStatus(_activeOrder!.remainingSeconds);

        if (oldStatus != newStatus) {
          _activeOrder!.status = newStatus;
          _handleStatusChangeNotification(newStatus);
        }

        notifyListeners();
      } else {
        // Reached 0 seconds -> Delivered
        _activeOrder!.remainingSeconds = 0;
        if (_activeOrder!.status != OrderStatus.delivered) {
          _activeOrder!.status = OrderStatus.delivered;
          _markOrderAsDelivered();
          _triggerNotification(
            'Order Delivered!',
            'Your evermi order has been delivered successfully. Enjoy!',
          );
        }
        timer.cancel();
        notifyListeners();
      }
    });
  }

  OrderStatus _calculateStatus(int secondsRemaining) {
    if (secondsRemaining > 240) {
      // 5 mins remaining (300 to 241)
      return OrderStatus.placed;
    } else if (secondsRemaining > 180) {
      // 4 mins remaining (240 to 181)
      return OrderStatus.confirmed;
    } else if (secondsRemaining > 120) {
      // 3 mins remaining (180 to 121)
      return OrderStatus.packed;
    } else if (secondsRemaining > 0) {
      // 2 mins to 1 min remaining (120 to 1)
      return OrderStatus.outForDelivery;
    } else {
      // 0 mins remaining
      return OrderStatus.delivered;
    }
  }

  void _handleStatusChangeNotification(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        _triggerNotification(
          'Instamart order confirmed',
          'Order confirmed! Delivering in 4 mins',
        );
        break;
      case OrderStatus.packed:
        _triggerNotification(
          'Order Packed',
          'Your order has been packed and handed to rider',
        );
        break;
      case OrderStatus.outForDelivery:
        _triggerNotification(
          'Out for Delivery',
          'Delivery Man is out for delivery. Arriving shortly!',
        );
        break;
      case OrderStatus.delivered:
        _triggerNotification(
          'Order Delivered',
          'Your order has been delivered successfully!',
        );
        break;
      default:
        break;
    }
  }

  void _triggerNotification(String title, String message) {
    _latestNotification = OrderNotification(
      title: title,
      message: message,
      timestamp: DateTime.now(),
    );
    notifyListeners();

    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 4), () {
      _latestNotification = null;
      notifyListeners();
    });
  }

  void dismissNotification() {
    _notificationTimer?.cancel();
    _latestNotification = null;
    notifyListeners();
  }

  final List<Product> _allDeliveredProducts = [];
  List<Product> get allDeliveredProducts => List.unmodifiable(_allDeliveredProducts);

  void _markOrderAsDelivered() {
    if (_activeOrder != null) {
      for (final item in _activeOrder!.items) {
        _allDeliveredProducts.removeWhere((p) => p.id == item.id);
        _allDeliveredProducts.insert(0, item);
      }
    }
  }

  void submitRating(int rating) {
    if (_activeOrder != null) {
      _activeOrder!.userRating = rating;
      _activeOrder!.isCompleted = true;
      _markOrderAsDelivered();
    }
    notifyListeners();
  }

  void clearActiveOrder() {
    _timer?.cancel();
    _notificationTimer?.cancel();
    _activeOrder = null;
    _latestNotification = null;
    isRatingDialogShown = false;
    isThankYouShown = false;
    isRatingSubmitting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationTimer?.cancel();
    super.dispose();
  }
}
