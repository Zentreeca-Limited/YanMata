import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/theme.dart';
import '../../../core/ui_feedback.dart';
import '../application/cycle_settings_provider.dart';

class CycleSetupDialog extends ConsumerStatefulWidget {
  const CycleSetupDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CycleSetupDialog(),
    );
  }

  @override
  ConsumerState<CycleSetupDialog> createState() => _CycleSetupDialogState();
}

class _CycleSetupDialogState extends ConsumerState<CycleSetupDialog> {
  late DateTime _selectedDate;
  late int _cycleLength;
  late int _periodDuration;

  @override
  void initState() {
    super.initState();
    final current = ref.read(cycleSettingsProvider);
    _selectedDate = current.configured
        ? current.lastPeriodDate
        : DateTime.now().subtract(const Duration(days: 14));
    _cycleLength = current.cycleLength;
    _periodDuration = current.periodDuration;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Palette.plum),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    ref
        .read(cycleSettingsProvider.notifier)
        .updateSettings(
          lastPeriodDate: _selectedDate,
          cycleLength: _cycleLength,
          periodDuration: _periodDuration,
        );
    Navigator.of(context).pop();
    YanMataFeedback.showSuccessSnackbar(
      context,
      'Cycle settings updated. Your rhythm and predictions have refreshed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Palette.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Palette.darkBorder
                        : const Color(0xFFE2D6E4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ref.tr('set_cycle_details'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Palette.darkText : Palette.ink,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                ref.tr('cycle_dialog_intro'),
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Palette.darkMuted : Palette.muted,
                ),
              ),
              const SizedBox(height: 20),

              // Question 1: Start date of last period
              Text(
                '1. ${ref.tr('last_period_date')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Palette.darkSurface : Palette.cream,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Palette.darkBorder
                          : const Color(0xFFE9E2E9),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Palette.plum,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Palette.darkText : Palette.ink,
                          ),
                        ),
                      ),
                      Text(
                        ref.tr('select_date'),
                        style: const TextStyle(
                          color: Palette.plum,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Question 2: Cycle length
              Text(
                '2. ${ref.tr('cycle_length_days')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [24, 26, 28, 30, 32, 35].map((len) {
                  final isSelected = _cycleLength == len;
                  return ChoiceChip(
                    label: Text('$len ${ref.tr('days_unit')}'),
                    selected: isSelected,
                    selectedColor: Palette.plum,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Palette.darkText : Palette.ink),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    backgroundColor: isDark
                        ? Palette.darkSurface
                        : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? Palette.plum
                          : (isDark
                                ? Palette.darkBorder
                                : const Color(0xFFE2D6E4)),
                    ),
                    onSelected: (_) => setState(() => _cycleLength = len),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Question 3: Period duration
              Text(
                '3. ${ref.tr('period_length_days')}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.darkText : Palette.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [3, 4, 5, 6, 7].map((dur) {
                  final isSelected = _periodDuration == dur;
                  return ChoiceChip(
                    label: Text('$dur ${ref.tr('days_unit')}'),
                    selected: isSelected,
                    selectedColor: Palette.plum,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Palette.darkText : Palette.ink),
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    backgroundColor: isDark
                        ? Palette.darkSurface
                        : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? Palette.plum
                          : (isDark
                                ? Palette.darkBorder
                                : const Color(0xFFE2D6E4)),
                    ),
                    onSelected: (_) => setState(() => _periodDuration = dur),
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),

              // Save CTA
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(ref.tr('save_cycle_settings')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
