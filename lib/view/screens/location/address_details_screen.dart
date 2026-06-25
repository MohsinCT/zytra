import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/models/address_entry.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class AddressDetailsProvider extends ChangeNotifier {
  AddressDetailsProvider() {
    nameController.addListener(_validateForm);
    numberController.addListener(_validateForm);
    houseController.addListener(_validateForm);
    streetController.addListener(_validateForm);
    areaController.addListener(_validateForm);
    labelController.addListener(_validateForm);
  }

  final formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController labelController = TextEditingController(
    text: 'Home',
  );
  final TextEditingController instructionsController = TextEditingController();

  bool useAccount = true;
  AddressType selectedType = AddressType.home;
  late UserAddress address;

  // Custom mock feature states
  bool isImageUploaded = false;
  bool isImageUploading = false;
  bool isRecording = false;
  bool hasVoiceNote = false;
  int recordDuration = 0;
  Timer? _recordTimer;

  bool _isValid = false;
  bool get isValid => _isValid;

  void initFrom(UserProvider user, UserAddress initialAddress) {
    address = initialAddress;
    areaController.text = initialAddress.locality;
    if (useAccount) {
      nameController.text = user.fullName ?? '';
      numberController.text = user.phoneNumber;
    }
    _validateForm();
  }

  void setUseAccount(bool value, UserProvider user) {
    useAccount = value;
    if (useAccount) {
      nameController.text = user.fullName ?? '';
      numberController.text = user.phoneNumber;
    } else {
      nameController.clear();
      numberController.clear();
    }
    _validateForm();
    notifyListeners();
  }

  void setType(AddressType t) {
    selectedType = t;
    if (labelController.text == 'Home' ||
        labelController.text == 'Office' ||
        labelController.text == 'Other') {
      labelController.text = t == AddressType.home
          ? 'Home'
          : t == AddressType.office
          ? 'Office'
          : 'Other';
    }
    _validateForm();
    notifyListeners();
  }

  void _validateForm() {
    final nameVal = nameController.text.trim().isNotEmpty;
    final numberVal = numberController.text.trim().length >= 10;
    final houseVal = houseController.text.trim().isNotEmpty;
    final streetVal = streetController.text.trim().isNotEmpty;
    final areaVal = areaController.text.trim().isNotEmpty;

    final currentVal = nameVal && numberVal && houseVal && streetVal && areaVal;
    if (_isValid != currentVal) {
      _isValid = currentVal;
      notifyListeners();
    }
  }

  // Simulated actions for photo upload
  void simulatePhotoUpload() {
    if (isImageUploaded || isImageUploading) return;
    isImageUploading = true;
    notifyListeners();

    Timer(const Duration(milliseconds: 1500), () {
      isImageUploading = false;
      isImageUploaded = true;
      notifyListeners();
    });
  }

  void removeUploadedPhoto() {
    isImageUploaded = false;
    notifyListeners();
  }

  // Simulated voice note recording
  void toggleVoiceRecording() {
    if (hasVoiceNote) {
      // Clear current voice note
      hasVoiceNote = false;
      recordDuration = 0;
      notifyListeners();
      return;
    }

    if (isRecording) {
      // Stop recording
      _recordTimer?.cancel();
      isRecording = false;
      hasVoiceNote = true;
      notifyListeners();
    } else {
      // Start recording
      isRecording = true;
      recordDuration = 0;
      notifyListeners();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordDuration++;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    nameController.removeListener(_validateForm);
    numberController.removeListener(_validateForm);
    houseController.removeListener(_validateForm);
    streetController.removeListener(_validateForm);
    areaController.removeListener(_validateForm);
    labelController.removeListener(_validateForm);

    nameController.dispose();
    numberController.dispose();
    houseController.dispose();
    streetController.dispose();
    areaController.dispose();
    labelController.dispose();
    instructionsController.dispose();
    super.dispose();
  }
}

class AddressDetailsScreen extends StatelessWidget {
  const AddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final initialAddress = args is UserAddress
        ? args
        : UserAddress(
            title: 'Selected',
            fullAddress: 'Unknown Location',
            locality: 'Unknown',
            lat: 0,
            lng: 0,
          );
    final user = Provider.of<UserProvider>(context, listen: false);

    return ChangeNotifierProvider<AddressDetailsProvider>(
      create: (ctx) {
        final provider = AddressDetailsProvider();
        provider.initFrom(user, initialAddress);
        return provider;
      },
      child: Consumer<AddressDetailsProvider>(
        builder: (ctx, vm, _) {
          return Scaffold(
            backgroundColor: context.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: context.scaffoldBackground,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: context.textDark),
              ),
              title: Text(
                'Address details',
                style: TextStyle(
                  color: context.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: vm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Receiver Details Section
                    _buildReceiverHeader(context),
                    const SizedBox(height: 12),
                    _buildReceiverCard(ctx, vm),
                    const SizedBox(height: 24),

                    // Address Type Segmented Tabs
                    Text(
                      'Save Address As',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.textDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeTabs(vm, context),
                    const SizedBox(height: 20),

                    // Modular Fields depending on Selection
                    _buildDynamicFields(vm, context),
                    const SizedBox(height: 20),

                    // Simulated Photo Upload Dashboard
                    _buildPhotoUploadSection(vm, context),
                    const SizedBox(height: 20),

                    // Delivery instructions section with voice note
                    _buildDeliveryInstructions(vm, context),
                    const SizedBox(height: 36),

                    // Save Address Button (Disabled dynamically based on validation)
                    _buildSaveButton(context, vm),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiverHeader(BuildContext context) {
    return Text(
      'Receiver details',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: context.textDark,
        fontSize: 15,
      ),
    );
  }

  Widget _buildReceiverCard(BuildContext context, AddressDetailsProvider vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderTheme),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.005 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: vm.useAccount,
                  activeColor: kPrimaryPink,
                  onChanged: (v) {
                    final user = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    vm.setUseAccount(v ?? true, user);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Use my account details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.textDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Receiver Name field
          TextFormField(
            controller: vm.nameController,
            style: TextStyle(
              fontSize: 14,
              color: context.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Receiver Name',
              labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
              filled: true,
              fillColor: context.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderTheme),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimaryPink, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderTheme),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Receiver Phone number field
          TextFormField(
            controller: vm.numberController,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              fontSize: 14,
              color: context.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Receiver Number',
              labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
              filled: true,
              fillColor: context.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderTheme),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimaryPink, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderTheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTabs(AddressDetailsProvider vm, BuildContext context) {
    return Row(
      children: AddressType.values.map((type) {
        final isSelected = vm.selectedType == type;
        final label = type == AddressType.home
            ? 'Home'
            : type == AddressType.office
            ? 'Office'
            : 'Other';

        return Expanded(
          child: GestureDetector(
            onTap: () => vm.setType(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (context.isDark ? Colors.white : Colors.black)
                    : context.inputFill,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? (context.isDark ? Colors.white : Colors.black)
                      : context.borderTheme,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? (context.isDark ? Colors.black : Colors.white)
                        : context.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicFields(AddressDetailsProvider vm, BuildContext context) {
    String field1Label = 'House / Flat / Floor';
    String field1Hint = 'e.g. Flat 301, 3rd Floor';
    String field2Label = 'Building / Street';
    String field2Hint = 'e.g. Rosewood Residency, Beach Rd';
    String labelLabel = 'Save address as';
    String labelHint = 'e.g. Home, Mom\'s place';

    if (vm.selectedType == AddressType.office) {
      field1Label = 'Office Name / Floor';
      field1Hint = 'e.g. Zytra Lab, 2nd Floor';
      field2Label = 'Building / Street';
      field2Hint = 'e.g. Cyber Tower, Bypass Rd';
      labelLabel = 'Save address as';
      labelHint = 'e.g. Work, Office';
    } else if (vm.selectedType == AddressType.other) {
      field1Label = 'Building / Floor';
      field1Hint = 'e.g. Sky Gym, 1st Floor';
      field2Label = 'Street';
      field2Hint = 'e.g. Valanchery Link Road';
      labelLabel = 'Save address as';
      labelHint = 'e.g. Gym, Other';
    }

    return Column(
      children: [
        // Field 1
        TextFormField(
          controller: vm.houseController,
          style: TextStyle(
            fontSize: 14,
            color: context.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: field1Label,
            hintText: field1Hint,
            labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
            hintStyle: TextStyle(color: context.textMuted),
            filled: true,
            fillColor: context.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryPink, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Field 2
        TextFormField(
          controller: vm.streetController,
          style: TextStyle(
            fontSize: 14,
            color: context.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: field2Label,
            hintText: field2Hint,
            labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
            hintStyle: TextStyle(color: context.textMuted),
            filled: true,
            fillColor: context.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryPink, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Field 3 (Area - Auto-filled from location)
        TextFormField(
          controller: vm.areaController,
          readOnly: true,
          style: TextStyle(
            fontSize: 14,
            color: context.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Area',
            labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
            filled: true,
            fillColor: context.isDark
                ? const Color(0xFF242426)
                : Colors.grey.shade100,
            prefixIcon: Icon(
              Icons.lock_outline,
              size: 16,
              color: context.textMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Field 4 (Save address as)
        TextFormField(
          controller: vm.labelController,
          style: TextStyle(
            fontSize: 14,
            color: context.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: labelLabel,
            hintText: labelHint,
            labelStyle: TextStyle(color: context.textMuted, fontSize: 13),
            hintStyle: TextStyle(color: context.textMuted),
            filled: true,
            fillColor: context.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryPink, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.borderTheme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection(
    AddressDetailsProvider vm,
    BuildContext context,
  ) {
    String placeholderText = 'Door / Building Photo';
    if (vm.selectedType == AddressType.office) {
      placeholderText = 'Reception / Drop-box Photo';
    } else if (vm.selectedType == AddressType.other) {
      placeholderText = 'Landmark / Entry Photo';
    }

    return GestureDetector(
      onTap: vm.simulatePhotoUpload,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: context.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.borderTheme,
            style: BorderStyle.solid,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: vm.isImageUploaded
              ? Container(
                  color: kPrimaryPink.withOpacity(0.04),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$placeholderText uploaded',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: context.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to remove photo',
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: vm.removeUploadedPhoto,
                      ),
                    ],
                  ),
                )
              : vm.isImageUploading
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            kPrimaryPink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Simulating upload...',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: context.textMuted,
                        size: 26,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        placeholderText,
                        style: TextStyle(
                          color: context.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInstructions(
    AddressDetailsProvider vm,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery instructions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textDark,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: vm.instructionsController,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText:
                      'e.g. Leave it next to the gate, call before arrival...',
                  hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: context.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.borderTheme),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kPrimaryPink,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.borderTheme),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Simulated voice note recorder / player
            GestureDetector(
              onTap: vm.toggleVoiceRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  color: vm.isRecording
                      ? (context.isDark
                            ? const Color(0xFF2C0B0B)
                            : Colors.red.shade50)
                      : vm.hasVoiceNote
                      ? kPrimaryPink.withValues(alpha: 0.08)
                      : context.inputFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: vm.isRecording
                        ? Colors.red.shade300
                        : vm.hasVoiceNote
                        ? kPrimaryPink.withValues(alpha: 0.4)
                        : context.borderTheme,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      vm.isRecording
                          ? Icons.stop
                          : vm.hasVoiceNote
                          ? Icons.play_arrow
                          : Icons.mic_none,
                      color: vm.isRecording
                          ? Colors.red.shade600
                          : vm.hasVoiceNote
                          ? kPrimaryPink
                          : context.textMuted,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.isRecording
                          ? '${vm.recordDuration}s'
                          : vm.hasVoiceNote
                          ? 'Saved'
                          : 'Voice',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: vm.isRecording
                            ? Colors.red.shade600
                            : vm.hasVoiceNote
                            ? kPrimaryPink
                            : context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, AddressDetailsProvider vm) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: vm.isValid
            ? () => _showConfirmationSheet(context, vm)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryPink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: context.isDark
              ? Colors.grey.shade900
              : Colors.grey.shade200,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Save Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: vm.isValid ? Colors.white : context.textMuted,
          ),
        ),
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context, AddressDetailsProvider vm) {
    final String addressLabel = vm.labelController.text.trim();
    final String typeName = vm.selectedType == AddressType.home
        ? 'Home'
        : vm.selectedType == AddressType.office
        ? 'Office'
        : 'Other';

    final fullAddressText =
        '${vm.houseController.text.trim()}, ${vm.streetController.text.trim()}, ${vm.areaController.text.trim()}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return Container(
          decoration: BoxDecoration(
            color: context.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Confirm Address Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),
              const SizedBox(height: 16),
              // Type display
              Row(
                children: [
                  Icon(
                    vm.selectedType == AddressType.home
                        ? Icons.home_outlined
                        : vm.selectedType == AddressType.office
                        ? Icons.work_outline
                        : Icons.location_on_outlined,
                    color: kPrimaryPink,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$typeName ($addressLabel)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryPink,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Full Address text
              Text(
                'DELIVERY ADDRESS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: context.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fullAddressText,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.textDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              // Receiver Name and Number
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECEIVER NAME',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: context.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vm.nameController.text.trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECEIVER PHONE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: context.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vm.numberController.text.trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Buttons (Edit details / Confirm)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: context.textDark, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Edit Details',
                        style: TextStyle(
                          color: context.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final locProvider = Provider.of<LocationProvider>(
                          context,
                          listen: false,
                        );
                        final addrProvider = Provider.of<AddressProvider>(
                          context,
                          listen: false,
                        );
                        // Confirm Save Address
                        final id = await addrProvider.addAddress(
                          address: UserAddress(
                            title: addressLabel,
                            fullAddress: fullAddressText,
                            locality: vm.address.locality,
                            lat: vm.address.lat,
                            lng: vm.address.lng,
                          ),
                          receiverName: vm.nameController.text.trim(),
                          receiverNumber: vm.numberController.text.trim(),
                          type: vm.selectedType,
                          fields: {
                            'house': vm.houseController.text.trim(),
                            'street': vm.streetController.text.trim(),
                            'area': vm.areaController.text.trim(),
                            'label': addressLabel,
                          },
                        );

                        if (id.isNotEmpty) {
                          await addrProvider.setActive(id);
                          // Update verified in LocationProvider
                          await locProvider.saveConfirmedLocation(
                            UserAddress(
                              title: addressLabel,
                              fullAddress: fullAddressText,
                              locality: vm.address.locality,
                              lat: vm.address.lat,
                              lng: vm.address.lng,
                            ),
                          );

                          if (context.mounted) {
                            Navigator.pop(sheetCtx); // Dismiss sheet
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            ); // Go back home
                          }
                        } else {
                          if (sheetCtx.mounted) {
                            ScaffoldMessenger.of(sheetCtx).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to save address. Please check fields.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
