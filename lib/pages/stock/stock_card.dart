import 'package:flutter/material.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';


class StockProductCard extends StatelessWidget {
  // You can pass these values in from your database later
  final String title;
  final double quantity;
  final double minQuantity;
  final IconData icon;
  final String unit;
  final double price;
  const StockProductCard({
    super.key,
    required this.title, 
    required this.quantity,     
    required this.price,       
    required this.minQuantity,    
    required this.unit,     
    required this.icon,
  });

  Widget _buildField({
  required TextEditingController controller,
  required String label,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }
        if (double.tryParse(value) == null) {
          return "Invalid number";
        }
        return null;
      },
    ),
  );
}


  void _showEditDialog(BuildContext context) {
  final quantityController =
      TextEditingController(text: quantity.toString());
  final priceController =
      TextEditingController(text: price.toString());
  final minQuantityController =
      TextEditingController(text: minQuantity.toString());

  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        
        title: const Text("Modifier le stock"),
        content: Form(
          
          key: formKey,
          child: Column(
            
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(
                controller: quantityController,
                label: "Quantity ($unit)",
              ),
              _buildField(
                controller: priceController,
                label: "Valeur financière (DH)",
              ),
              _buildField(
                controller: minQuantityController,
                label: "Minimum quantity ($unit)",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final newQuantity =
                  double.parse(quantityController.text);
              final newPrice =
                  double.parse(priceController.text);
              final newMinQuantity =
                  double.parse(minQuantityController.text);

              Navigator.pop(context);
              SysNotif.showWidget(context,'le stock va etre modifiee',Colors.orangeAccent,Icons.info);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Simple logic to check if stock is critical
    final bool isLowStock = quantity < minQuantity;
    
    // Determine status color based on stock level
    final Color statusColor = icon==Icons.trending_down 
        ? Colors.redAccent
        : Colors.greenAccent;

    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Border turns red if stock is low, otherwise subtle grey
          color: isLowStock 
              ? theme.colorScheme.error.withOpacity(0.5)
              : theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. TOP: Title ---
      Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        IconButton(
          icon: Icon(Icons.edit,color: theme.colorScheme.primary.withOpacity(0.5),size: 20,),
          onPressed: () {
            _showEditDialog(context);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ],
    ),
          
           // Pushes content apart evenly
          const Spacer(),
          // --- 2. MIDDLE: Actual Quantity ---
          _buildStatRow(
            context, 
            label: "Quantity", 
            value: quantity.toString() + " $unit",
            valueColor: statusColor,
            isBold: true
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            context, 
            label: "valeur financiere", 
            value: price.toString() + " DH",
            valueColor: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            context, 
            label: "prix unitaire", 
            value: minQuantity.toString() + " DH",
            valueColor: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 8),
          // --- 3. MIDDLE: Min Quantity ---
          _buildStatRow(
            context, 
            label: "Min Limit", 
            value: minQuantity.toString() + " $unit",
            valueColor: theme.colorScheme.onSurface.withOpacity(0.6),
          ),

         const Spacer(),
          
          // --- 4. END: Icon ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Small status indicator text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isLowStock ? "Low Stock" : "In Stock",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // The requested Icon
              Icon(
                icon,
                color: icon==Icons.trending_down ? Colors.redAccent.withOpacity(0.3) : Colors.greenAccent.withOpacity(0.3),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildStatRow(BuildContext context, {
    required String label, 
    required String value, 
    Color? valueColor,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor ?? theme.colorScheme.onSurface,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}