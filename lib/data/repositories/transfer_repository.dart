// lib/data/repositories/transfer_repository.dart
import 'package:dio/dio.dart';
import 'package:wave_app/data/models/transfer_model.dart';

class TransferRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://votre_api_url.com',
    contentType: 'application/json',
  ));

  Future<TransferModel> createTransfer(String senderId, String recipientId, double amount) async {
    try {
      final response = await _dio.post('/transfers', data: {
        'sender_id': senderId,
        'recipient_id': recipientId,
        'amount': amount,
      });
      return TransferModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<TransferModel>> createMultipleTransfers(
    String senderId,
    List<Map<String, dynamic>> transfers,
  ) async {
    try {
      final response = await _dio.post('/transfers/bulk', data: {
        'sender_id': senderId,
        'transfers': transfers,
      });
      
      return (response.data as List)
          .map((item) => TransferModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<TransferModel>> getTransferHistory() async {
    try {
      final response = await _dio.get('/transfers/history');
      return (response.data as List)
          .map((item) => TransferModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> checkBalance(double totalAmount) async {
    try {
      final response = await _dio.get('/account/balance');
      final balance = response.data['balance'] as double;
      return balance >= totalAmount;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}