import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/money.dart';
import '../../../shared/models/currency.dart';
import '../../../shared/models/debt_operation.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/widgets/currency_segmented_control.dart';
import '../../categories/application/categories_providers.dart';
import '../../categories/domain/category.dart';
import '../../categories/domain/category_catalog.dart';
import '../../rates/application/rates_providers.dart';
import '../application/transactions_providers.dart';
import '../domain/transaction.dart';
import 'widgets/category_picker_sheet.dart';
import 'widgets/rate_snapshot_card.dart';
import 'widgets/transaction_form_widgets.dart';

class NewTransactionScreen extends ConsumerStatefulWidget {
  const NewTransactionScreen({super.key});

  @override
  ConsumerState<NewTransactionScreen> createState() =>
      _NewTransactionScreenState();
}

class _NewTransactionScreenState extends ConsumerState<NewTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _type = TransactionType.income;
  Currency _currency = Currency.tryLira;
  Category? _category;
  Subcategory? _subcategory;
  DebtOperation _debtOperation = DebtOperation.pay;
  DateTime _date = DateTime.now();
  bool _isSaving = false;
  bool _isRefreshingRates = false;

  bool get _isDebtEntry =>
      _subcategory != null && debtSubcategoryIds.contains(_subcategory!.id);

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratesAsync = ref.watch(currentRatesProvider);
    final ratesResult = ratesAsync.value;
    final category = _category;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Kapat',
          onPressed: _isSaving ? null : () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Yeni İşlem'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            TransactionTypeSelector(selected: _type, onChanged: _onTypeChanged),
            const SizedBox(height: AppSpacing.xxl),
            FormSection(
              label: _currency.isGold ? 'Gram Altın' : 'Tutar',
              child: Column(
                children: [
                  AmountInput(
                    controller: _amountController,
                    currency: _currency,
                    autofocus: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CurrencySegmentedControl(
                    selected: _currency,
                    onChanged: _onCurrencyChanged,
                    useIsoCode: true,
                    height: 38,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FormSection(
              label: 'Kategori',
              child: PickerField(
                text: category?.name ?? 'Kategori seç',
                isPlaceholder: category == null,
                leadingIcon: category == null
                    ? null
                    : categoryIcon(category.iconKey),
                trailingIcon: Icons.keyboard_arrow_down_rounded,
                onTap: _pickCategory,
              ),
            ),
            if (category != null && category.hasSubcategories) ...[
              const SizedBox(height: AppSpacing.xl),
              FormSection(
                label: 'Alt Kategori',
                child: PickerField(
                  text: _subcategory?.name ?? 'Alt kategori seç',
                  isPlaceholder: _subcategory == null,
                  trailingIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: _pickSubcategory,
                ),
              ),
            ],
            if (_isDebtEntry) ...[
              const SizedBox(height: AppSpacing.xl),
              FormSection(
                label: 'Borç Hareketi',
                child: DebtOperationSelector(
                  selected: _debtOperation,
                  onChanged: (operation) =>
                      setState(() => _debtOperation = operation),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            FormSection(
              label: 'Tarih',
              child: PickerField(
                text: Formatters.fullDate(_date),
                trailingIcon: Icons.calendar_today_outlined,
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FormSection(
              label: 'Açıklama (isteğe bağlı)',
              child: TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                decoration: const InputDecoration(
                  hintText: 'Örn. Ağustos maaşı',
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            RateSnapshotCard(
              rates: ratesResult?.rates,
              isLoading: ratesAsync.isLoading,
              isRefreshing: _isRefreshingRates,
              refreshFailed: ratesResult?.refreshFailed ?? false,
              onRefresh: _refreshRates,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.lg,
        ),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const _ButtonProgress(label: 'Kaydediliyor...')
              : const Text('Kaydet'),
        ),
      ),
    );
  }

  void _onTypeChanged(TransactionType type) {
    if (type == _type) return;
    setState(() {
      _type = type;
      _category = null; // category lists differ per type
      _subcategory = null;
      _debtOperation = DebtOperation.pay;
    });
  }

  void _onCurrencyChanged(Currency currency) {
    if (currency == _currency) return;
    setState(() => _currency = currency);
  }

  Future<void> _pickCategory() async {
    FocusScope.of(context).unfocus();
    final categories = ref.read(selectableCategoriesProvider(_type));
    final selection = await showCategoryPicker(
      context,
      categories: categories,
      selected: _category,
    );
    if (selection == null || !mounted) return;

    setState(() {
      _category = selection;
      _subcategory = null;
      _debtOperation = DebtOperation.pay;
    });

    if (selection.hasSubcategories) await _pickSubcategory();
  }

  Future<void> _pickSubcategory() async {
    final category = _category;
    if (category == null || !category.hasSubcategories) return;

    FocusScope.of(context).unfocus();
    final selection = await showSubcategoryPicker(
      context,
      category: category,
      selected: _subcategory,
    );
    if (selection != null && mounted) {
      setState(() => _subcategory = selection);
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final selection = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (selection != null && mounted) {
      setState(() => _date = selection);
    }
  }

  Future<void> _refreshRates() async {
    setState(() => _isRefreshingRates = true);
    final result = await ref.read(currentRatesProvider.notifier).refreshNow();
    if (!mounted) return;
    setState(() => _isRefreshingRates = false);

    if (result.refreshFailed) {
      _showMessage('Kur güncellenemedi. Son kayıtlı kur kullanılıyor.');
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amountMinor = Money.tryParseMinor(_amountController.text);
    if (amountMinor == null || amountMinor <= 0) {
      _showMessage('Lütfen geçerli bir tutar girin.');
      return;
    }

    final category = _category;
    if (category == null) {
      _showMessage('Lütfen bir kategori seçin.');
      return;
    }
    if (category.hasSubcategories && _subcategory == null) {
      _showMessage('Lütfen bir alt kategori seçin.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final rates = (await ref.read(currentRatesProvider.future)).rates;

      // TRY entries stand on their own; anything else needs a snapshot.
      if (rates == null && _currency != Currency.tryLira) {
        _showMessage(
          'Kur bilgisi alınamadı. İnternet bağlantını kontrol edip tekrar dene.',
        );
        return;
      }

      final description = _descriptionController.text.trim();
      await ref
          .read(transactionRepositoryProvider)
          .create(
            NewTransaction(
              type: _type,
              currency: _currency,
              amountMinor: amountMinor,
              categoryId: category.id,
              subcategoryId: _subcategory?.id,
              debtOperation: _isDebtEntry ? _debtOperation : null,
              transactionDate: _date,
              description: description.isEmpty ? null : description,
              rates: rates,
            ),
          );

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isDebtEntry ? '${_debtOperation.label} kaydedildi.' : '${_type.label} kaydedildi.',
          ),
          backgroundColor: AppColors.accentFor(_type),
        ),
      );
    } on Object {
      _showMessage('İşlem kaydedilemedi. Lütfen tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ButtonProgress extends StatelessWidget {
  const _ButtonProgress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(label),
      ],
    );
  }
}
