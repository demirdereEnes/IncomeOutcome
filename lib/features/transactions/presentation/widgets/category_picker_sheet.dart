import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_widgets.dart';
import '../../../categories/domain/category.dart';
import '../../../categories/domain/category_catalog.dart';

Future<Category?> showCategoryPicker(
  BuildContext context, {
  required List<Category> categories,
  Category? selected,
}) {
  return showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PickerSheet<Category>(
      title: 'Kategori Seç',
      items: categories,
      selectedId: selected?.id,
      idOf: (category) => category.id,
      labelOf: (category) => category.name,
      iconOf: (category) => categoryIcon(category.iconKey),
    ),
  );
}

Future<Subcategory?> showSubcategoryPicker(
  BuildContext context, {
  required Category category,
  Subcategory? selected,
}) {
  return showModalBottomSheet<Subcategory>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PickerSheet<Subcategory>(
      title: '${category.name} · Alt Kategori',
      items: category.subcategories,
      selectedId: selected?.id,
      idOf: (subcategory) => subcategory.id,
      labelOf: (subcategory) => subcategory.name,
      iconOf: (_) => categoryIcon(category.iconKey),
    ),
  );
}

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selectedId,
    required this.idOf,
    required this.labelOf,
    required this.iconOf,
  });

  final String title;
  final List<T> items;
  final int? selectedId;
  final int Function(T) idOf;
  final String Function(T) labelOf;
  final IconData Function(T) iconOf;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                0,
                AppSpacing.page,
                AppSpacing.sm,
              ),
              child: Text(title, style: AppTypography.sectionTitle),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = idOf(item) == selectedId;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                      vertical: AppSpacing.xs,
                    ),
                    leading: SoftIcon(
                      icon: iconOf(item),
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      background: isSelected
                          ? AppColors.primarySoft
                          : AppColors.surfaceMuted,
                    ),
                    title: Text(
                      labelOf(item),
                      style: AppTypography.body.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
