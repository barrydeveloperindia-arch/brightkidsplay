import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  // Register adapters here if needed, e.g., Hive.registerAdapter(ContentNodeAdapter());

  // Initialize Supabase
  // TODO: Replace with actual Supabase URL and Key
  const supabaseUrl = 'YOUR_SUPABASE_URL';
  const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  runApp(
    const ProviderScope(
      child: BrightKidsApp(),
    ),
  );
}
