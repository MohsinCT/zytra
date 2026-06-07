import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';
import 'package:zytranow/models/address_entry.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserAddress address;
  bool useAccount = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  AddressType _selectedType = AddressType.home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is UserAddress) {
      address = args;
    } else {
      address = UserAddress(title: 'Selected', fullAddress: 'Unknown', locality: 'Unknown', lat: 0, lng: 0);
    }

    final user = Provider.of<UserProvider>(context, listen: false);
    if (useAccount) {
      _nameController.text = user.fullName ?? '';
      _numberController.text = user.phoneNumber;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.addAddress(
      address: UserAddress(
        title: _selectedType == AddressType.home ? 'Home' : _selectedType == AddressType.office ? 'Office' : 'Other',
        fullAddress: '${_houseController.text}, ${_streetController.text}, ${_areaController.text}, ${address.locality}',
        locality: address.locality,
        lat: address.lat,
        lng: address.lng,
      ),
      receiverName: _nameController.text.trim(),
      receiverNumber: _numberController.text.trim(),
      type: _selectedType,
      fields: {
        'house': _houseController.text,
        'street': _streetController.text,
        'area': _areaController.text,
      },
    );

    // Show confirmation bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 16, left: 16, right: 16, top: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Confirm address', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(_selectedType == AddressType.home ? 'Home' : _selectedType == AddressType.office ? 'Office' : 'Other', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 6),
              Text('${_houseController.text}, ${_streetController.text}, ${_areaController.text}, ${address.locality}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Receiver: ${_nameController.text}'),
              Text('Phone: ${_numberController.text}'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Edit details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryPink),
                      child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address details', style: TextStyle(color: Colors.black87)), backgroundColor: Colors.white, elevation: 0, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black87))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(value: useAccount, onChanged: (v) {
                    setState(() {
                      useAccount = v ?? true;
                      if (useAccount) {
                        final user = Provider.of<UserProvider>(context, listen: false);
                        _nameController.text = user.fullName ?? '';
                        _numberController.text = user.phoneNumber;
                      } else {
                        _nameController.clear();
                        _numberController.clear();
                      }
                    });
                  }),
                  const SizedBox(width: 8),
                  const Text('Use my account details'),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Receiver name'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null),
              const SizedBox(height: 8),
              TextFormField(controller: _numberController, decoration: const InputDecoration(labelText: 'Receiver number'), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.trim().length < 6) ? 'Enter phone' : null),
              const SizedBox(height: 12),
              const Text('Address type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(label: const Text('Home'), selected: _selectedType == AddressType.home, onSelected: (_) => setState(() => _selectedType = AddressType.home)),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Office'), selected: _selectedType == AddressType.office, onSelected: (_) => setState(() => _selectedType = AddressType.office)),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Other'), selected: _selectedType == AddressType.other, onSelected: (_) => setState(() => _selectedType = AddressType.other)),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _houseController, decoration: const InputDecoration(labelText: 'House / Flat / Floor')),
              const SizedBox(height: 8),
              TextFormField(controller: _streetController, decoration: const InputDecoration(labelText: 'Building / Street')),
              const SizedBox(height: 8),
              TextFormField(controller: _areaController, decoration: const InputDecoration(labelText: 'Area')),
              const SizedBox(height: 12),
              // placeholders for image upload and voice instructions
              Container(height: 84, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('Image upload placeholder'))),
              const SizedBox(height: 12),
              TextFormField(decoration: const InputDecoration(labelText: 'Delivery instructions')),              
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _onSave, style: ElevatedButton.styleFrom(backgroundColor: kPrimaryPink), child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Save address', style: TextStyle(fontSize: 16))))),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
