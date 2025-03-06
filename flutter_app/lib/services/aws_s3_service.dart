import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class S3Service {
  final String bucketName = dotenv.env['AWS_BUCKET_NAME']!;
  final String region = dotenv.env['AWS_REGION']!;
  final String accessKey = dotenv.env['AWS_ACCESS_KEY']!;
  final String secretKey = dotenv.env['AWS_SECRET_KEY']!;

  Future<String?> uploadFile(String filePath, String fileName) async {
    try {
      final String s3Url = "https://$bucketName.s3.$region.amazonaws.com/$fileName";
      final File file = File(filePath);
      final int fileSize = await file.length();
      final List<int> fileBytes = await file.readAsBytes();
      final String fileHash = base64.encode(md5.convert(fileBytes).bytes);

      final Dio dio = Dio();

      // Generate AWS Signature for authentication
      final DateTime now = DateTime.now().toUtc();
      final String dateString = now.toIso8601String().split('T').first.replaceAll('-', '');
      final String timeString = "${now.toIso8601String().replaceAll(RegExp(r'[:-]'), '').split('.')[0]}Z";

      final String credentialScope = "$dateString/$region/s3/aws4_request";
      final String canonicalRequest = "PUT\n/$fileName\n\nhost:$bucketName.s3.$region.amazonaws.com\nx-amz-content-sha256:$fileHash\nx-amz-date:$timeString\n\nhost;x-amz-content-sha256;x-amz-date\n$fileHash";

      final String stringToSign = "AWS4-HMAC-SHA256\n$timeString\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest))}";

      final List<int> signingKey = Hmac(sha256, utf8.encode("AWS4$secretKey")).convert(utf8.encode(dateString)).bytes;
      final List<int> regionKey = Hmac(sha256, signingKey).convert(utf8.encode(region)).bytes;
      final List<int> serviceKey = Hmac(sha256, regionKey).convert(utf8.encode("s3")).bytes;
      final List<int> signingKeyFinal = Hmac(sha256, serviceKey).convert(utf8.encode("aws4_request")).bytes;
      final String signature = Hmac(sha256, signingKeyFinal).convert(utf8.encode(stringToSign)).toString();

      final String authorizationHeader =
          "AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$signature";

      final response = await dio.put(
        s3Url,
        data: Stream.fromIterable(fileBytes.map((e) => [e])),
        options: Options(
          headers: {
            "Authorization": authorizationHeader,
            "x-amz-date": timeString,
            "x-amz-content-sha256": fileHash,
            "Content-Length": fileSize.toString(),
            "Content-Type": "image/jpeg",
          },
        ),
      );

      if (response.statusCode == 200) {
        return s3Url;
      } else {
        print("Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}
