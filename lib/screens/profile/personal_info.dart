import 'package:flutter/material.dart';

import '../../cache/profile_cache.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final cache = ProfileCache.instance;

  DateTime? _birthDate;

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _birthDateCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _emailCtrl;

  bool _saving = false;

  void _onUpdate() => setState(() {});

  @override
  void initState() {
    super.initState();
    cache.addListener(_onUpdate);

    final profile = cache.profile;
    _firstNameCtrl = TextEditingController(text: profile?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: profile?.lastName ?? '');
    _weightCtrl = TextEditingController(
      text: profile?.weightKg != null ? profile!.weightKg.toString() : '',
    );
    _heightCtrl = TextEditingController(
      text: profile?.heightCm != null ? profile!.heightCm.toString() : '',
    );
    _emailCtrl = TextEditingController(text: cache.email ?? '');
    _birthDate = profile?.birthDate;
    _birthDateCtrl = TextEditingController(text: _formatDate(_birthDate));
  }

  @override
  void dispose() {
    cache.removeListener(_onUpdate);
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _emailCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateCtrl.text = _formatDate(picked);
      });
    }
  }

    Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await cache.updateProfile(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        weightKg: double.tryParse(_weightCtrl.text.trim()),
        heightCm: double.tryParse(_heightCtrl.text.trim()),
        birthDate: _birthDate,
      );
      if (_emailCtrl.text.trim() != cache.email) {
        await cache.updateEmail(_emailCtrl.text.trim());
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Podatki shranjeni.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = cache.profile;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Osebni podatki')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _firstNameCtrl,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _lastNameCtrl,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _birthDateCtrl,
            readOnly: true,
            onTap: _pickBirthDate,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          TextField(
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Height (cm)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Shrani'),
          ),
        ],
      ),
    );
  }
}