
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../repo/food_repository.dart';

class AddFoodScreen extends StatefulWidget {
  final UserModel user;

  const AddFoodScreen({super.key, required this.user});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodName = TextEditingController();
  final _quantity = TextEditingController();
  final _description = TextEditingController();

  final _repository = FoodRepository();

  DateTime? _expiryTime;
  bool _loading = false;

  static const green = Color(0xFF176B4D);
  static const orange = Color(0xFFFF784F);

  @override
  void dispose() {
    _foodName.dispose();
    _quantity.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _chooseExpiry() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null || !mounted) return;

    setState(() {
      _expiryTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submitFood() async {
    if (!_formKey.currentState!.validate()) return;

    if (_expiryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select expiry date and time')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _repository.addFood(
        token: widget.user.token,
        foodName: _foodName.text.trim(),
       quantity: _quantity.text.trim().split(' ').first,
        description: _description.text.trim(),
        expiryTime: _expiryTime!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Food added successfully! 🎉'),
          backgroundColor: green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add food: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: green),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: Color(0xFFE3E9E4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: Color(0xFFE3E9E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: green, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF6F8F5),
      appBar: AppBar(
        title: const Text('Add Surplus Food'),
        backgroundColor: Color(0xFFF6F8F5),
        foregroundColor: green,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding:  EdgeInsets.all(20),
            children: [
              Container(
                padding:  EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [green, Color(0xFF32966B)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.volunteer_activism_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Share food. Spread kindness.',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your extra food so an NGO can help someone in need.',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
             SizedBox(height: 26),
          Text(
                'Food Details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20352C),
                ),
              ),
               SizedBox(height: 18),
              _input(
                controller: _foodName,
                label: 'Food name',
                hint: 'e.g. Veg pulao',
                icon: Icons.restaurant_menu_rounded,
              ),
             SizedBox(height: 16),
              _input(
                controller: _quantity,
                label: 'Quantity',
                hint: 'e.g. 10 plates or 5 kg',
                icon: Icons.scale_rounded,
              ),
         SizedBox(height: 16),
              _input(
                controller: _description,
                label: 'Description',
                hint: 'Add food condition or pickup instructions',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
           SizedBox(height: 20),
             Text(
                'Food expiry',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
               SizedBox(height: 10),
              InkWell(
                onTap: _chooseExpiry,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color:  Color(0xFFE3E9E4)),
                  ),
                  child: Row(
                    children: [
                       Icon(
                        Icons.calendar_month_rounded,
                        color: orange,
                      ),
                  SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _expiryTime == null
                              ? 'Select expiry date and time'
                              : '${_expiryTime!.day}/${_expiryTime!.month}/${_expiryTime!.year}  '
                                '${TimeOfDay.fromDateTime(_expiryTime!).format(context)}',
                        ),
                      ),
                     Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
          SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submitFood,
                  icon: _loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      
                      : Icon(Icons.volunteer_activism_rounded),
                  label: Text(
                    _loading ? 'Submitting...' : 'Donate Food',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
         SizedBox(height: 14),
           Text(
                'Please make sure the food is safe to consume.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
