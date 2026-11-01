import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/ui_feedback.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/account/application/account_provider.dart';
import 'package:yanmata/features/account/presentation/personalized_insights_page.dart';

/// Screen 2 of Account Flow: Complete Health Profile (Screen 4 from Wireframe)
class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final Map<String, dynamic> _answers = {
    'menstrual': <String, dynamic>{},
    'reproductive': <String, dynamic>{},
    'medical': <String, dynamic>{},
    'lifestyle': <String, dynamic>{},
    'family': <String, dynamic>{},
  };

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(healthProfileProvider).value;
    if (profile != null && profile.answers.isNotEmpty) {
      for (final key in _answers.keys) {
        if (profile.answers[key] is Map) {
          _answers[key] = Map<String, dynamic>.from(
            profile.answers[key] as Map,
          );
        }
      }
    }
  }

  bool _isSectionComplete(String section) {
    final data = _answers[section] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) return false;
    switch (section) {
      case 'menstrual':
        return data['cycle_regular'] != null;
      case 'reproductive':
        return data['pregnancy_status'] != null;
      case 'medical':
        return data['conditions'] != null || data['hpv_vaccinated'] != null;
      case 'lifestyle':
        return data['activity'] != null && data['stress'] != null;
      case 'family':
        return data['family_history'] != null;
      default:
        return false;
    }
  }

  void _openMenstrualSheet() {
    int menarcheAge =
        (_answers['menstrual']['menarche_age'] as num?)?.toInt() ?? 13;
    String regular =
        _answers['menstrual']['cycle_regular'] as String? ?? 'regular';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _buildBottomSheet(
            context: context,
            title: ref.tr('profile_section_menstrual'),
            children: [
              Text(
                ref.tr('profile_menarche_age'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [11, 12, 13, 14, 15, 16].map((age) {
                  final isSelected = menarcheAge == age;
                  return ChoiceChip(
                    label: Text('$age yrs'),
                    selected: isSelected,
                    onSelected: (_) => setSheetState(() => menarcheAge = age),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                ref.tr('profile_cycle_regular'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'regular',
                ref.tr('profile_regular_yes'),
                regular,
                (val) {
                  setSheetState(() => regular = val);
                },
              ),
              _buildRadioOption(
                'irregular',
                ref.tr('profile_regular_no'),
                regular,
                (val) {
                  setSheetState(() => regular = val);
                },
              ),
              _buildRadioOption(
                'unsure',
                ref.tr('profile_regular_unsure'),
                regular,
                (val) {
                  setSheetState(() => regular = val);
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _answers['menstrual'] = {
                      'menarche_age': menarcheAge,
                      'cycle_regular': regular,
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openReproductiveSheet() {
    String status =
        _answers['reproductive']['pregnancy_status'] as String? ?? 'none';
    String contraception =
        _answers['reproductive']['contraception'] as String? ?? 'none';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _buildBottomSheet(
            context: context,
            title: ref.tr('profile_section_reproductive'),
            children: [
              Text(
                ref.tr('profile_pregnancy_status'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption('none', ref.tr('profile_status_none'), status, (
                val,
              ) {
                setSheetState(() => status = val);
              }),
              _buildRadioOption(
                'pregnant',
                ref.tr('profile_status_pregnant'),
                status,
                (val) {
                  setSheetState(() => status = val);
                },
              ),
              _buildRadioOption(
                'postpartum',
                ref.tr('profile_status_postpartum'),
                status,
                (val) {
                  setSheetState(() => status = val);
                },
              ),
              _buildRadioOption(
                'breastfeeding',
                ref.tr('profile_status_nursing'),
                status,
                (val) {
                  setSheetState(() => status = val);
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _answers['reproductive'] = {
                      'pregnancy_status': status,
                      'contraception': contraception,
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openMedicalSheet() {
    List<String> conditions = List<String>.from(
      (_answers['medical']['conditions'] as List?) ?? ['none'],
    );
    String hpv = _answers['medical']['hpv_vaccinated'] as String? ?? 'unsure';
    String screening =
        _answers['medical']['last_cervical_screening'] as String? ?? 'never';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _buildBottomSheet(
            context: context,
            title: ref.tr('profile_section_medical'),
            children: [
              Text(
                ref.tr('profile_conditions_title'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children:
                    [
                      ('pcos', ref.tr('profile_cond_pcos')),
                      ('endometriosis', ref.tr('profile_cond_endo')),
                      ('fibroids', ref.tr('profile_cond_fibroids')),
                      ('anaemia', ref.tr('profile_cond_anaemia')),
                      ('hypertension', ref.tr('profile_cond_hypertension')),
                      ('diabetes', ref.tr('profile_cond_diabetes')),
                      ('none', ref.tr('profile_cond_none')),
                    ].map((item) {
                      final isSelected = conditions.contains(item.$1);
                      return FilterChip(
                        label: Text(item.$2),
                        selected: isSelected,
                        onSelected: (val) {
                          setSheetState(() {
                            if (item.$1 == 'none') {
                              conditions = ['none'];
                            } else {
                              conditions.remove('none');
                              if (val) {
                                conditions.add(item.$1);
                              } else {
                                conditions.remove(item.$1);
                              }
                              if (conditions.isEmpty) conditions = ['none'];
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                ref.tr('profile_hpv_vaccine'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'yes',
                ref.tr('profile_hpv_yes'),
                hpv,
                (v) => setSheetState(() => hpv = v),
              ),
              _buildRadioOption(
                'no',
                ref.tr('profile_hpv_no'),
                hpv,
                (v) => setSheetState(() => hpv = v),
              ),
              _buildRadioOption(
                'unsure',
                ref.tr('profile_hpv_unsure'),
                hpv,
                (v) => setSheetState(() => hpv = v),
              ),
              const SizedBox(height: 20),
              Text(
                ref.tr('profile_screening_last'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'never',
                ref.tr('profile_screening_never'),
                screening,
                (v) => setSheetState(() => screening = v),
              ),
              _buildRadioOption(
                'under_3y',
                ref.tr('profile_screening_under3'),
                screening,
                (v) => setSheetState(() => screening = v),
              ),
              _buildRadioOption(
                '3_to_5y',
                ref.tr('profile_screening_3to5'),
                screening,
                (v) => setSheetState(() => screening = v),
              ),
              _buildRadioOption(
                'over_5y',
                ref.tr('profile_screening_over5'),
                screening,
                (v) => setSheetState(() => screening = v),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _answers['medical'] = {
                      'conditions': conditions,
                      'hpv_vaccinated': hpv,
                      'last_cervical_screening': screening,
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openLifestyleSheet() {
    String activity =
        _answers['lifestyle']['activity'] as String? ?? 'moderate';
    String stress = _answers['lifestyle']['stress'] as String? ?? 'low';
    String smoking = _answers['lifestyle']['smoking'] as String? ?? 'never';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _buildBottomSheet(
            context: context,
            title: ref.tr('profile_section_lifestyle'),
            children: [
              Text(
                ref.tr('profile_lifestyle_activity'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'low',
                ref.tr('profile_activity_low'),
                activity,
                (v) => setSheetState(() => activity = v),
              ),
              _buildRadioOption(
                'moderate',
                ref.tr('profile_activity_mod'),
                activity,
                (v) => setSheetState(() => activity = v),
              ),
              _buildRadioOption(
                'high',
                ref.tr('profile_activity_high'),
                activity,
                (v) => setSheetState(() => activity = v),
              ),
              const SizedBox(height: 18),
              Text(
                ref.tr('profile_lifestyle_stress'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'low',
                ref.tr('profile_stress_low'),
                stress,
                (v) => setSheetState(() => stress = v),
              ),
              _buildRadioOption(
                'moderate',
                ref.tr('profile_stress_mod'),
                stress,
                (v) => setSheetState(() => stress = v),
              ),
              _buildRadioOption(
                'high',
                ref.tr('profile_stress_high'),
                stress,
                (v) => setSheetState(() => stress = v),
              ),
              const SizedBox(height: 18),
              Text(
                ref.tr('profile_lifestyle_smoking'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                'never',
                ref.tr('profile_smoking_never'),
                smoking,
                (v) => setSheetState(() => smoking = v),
              ),
              _buildRadioOption(
                'former',
                ref.tr('profile_smoking_former'),
                smoking,
                (v) => setSheetState(() => smoking = v),
              ),
              _buildRadioOption(
                'current',
                ref.tr('profile_smoking_current'),
                smoking,
                (v) => setSheetState(() => smoking = v),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _answers['lifestyle'] = {
                      'activity': activity,
                      'stress': stress,
                      'smoking': smoking,
                    };
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openFamilySheet() {
    List<String> family = List<String>.from(
      (_answers['family']['family_history'] as List?) ?? ['none'],
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return _buildBottomSheet(
            context: context,
            title: ref.tr('profile_section_family'),
            children: [
              Text(
                ref.tr('profile_family_history'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                      ('cervical', ref.tr('profile_family_cervical')),
                      ('breast', ref.tr('profile_family_breast')),
                      ('ovarian', ref.tr('profile_family_ovarian')),
                      ('none', ref.tr('profile_family_none')),
                    ].map((item) {
                      final isSelected = family.contains(item.$1);
                      return FilterChip(
                        label: Text(item.$2),
                        selected: isSelected,
                        onSelected: (val) {
                          setSheetState(() {
                            if (item.$1 == 'none') {
                              family = ['none'];
                            } else {
                              family.remove('none');
                              if (val) {
                                family.add(item.$1);
                              } else {
                                family.remove(item.$1);
                              }
                              if (family.isEmpty) family = ['none'];
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _answers['family'] = {'family_history': family};
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Palette.darkSurface : Palette.cream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    String value,
    String label,
    String groupValue,
    ValueChanged<String> onChanged,
  ) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Palette.slate,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(healthProfileProvider.notifier).saveFullAnswers(_answers);

      if (!mounted) return;
      // Step 3: Personalized Insights
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) =>
              PersonalizedInsightsPage(onComplete: widget.onComplete),
        ),
      );
    } catch (e) {
      if (mounted) {
        YanMataFeedback.showErrorSnackbar(
          context,
          'Unable to save profile: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    final profileAsync = ref.watch(healthProfileProvider);

    final isMinor = profileAsync.value?.isMinor ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.tr('profile_flow_title'),
          style: const TextStyle(
            fontFamily: 'Fraunces',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: PageFrame(
        children: [
          Text(
            ref.tr('profile_flow_sub'),
            style: TextStyle(fontSize: 14, color: muted, height: 1.5),
          ),
          const SizedBox(height: 20),

          // Section 1: Menstrual Cycle
          _buildSectionCard(
            title: ref.tr('profile_section_menstrual'),
            subtitle: _isSectionComplete('menstrual')
                ? 'Cycle interval & onset recorded'
                : 'Menarche age and regularity',
            icon: Icons.water_drop_outlined,
            isComplete: _isSectionComplete('menstrual'),
            onTap: _openMenstrualSheet,
          ),
          const SizedBox(height: 12),

          // Section 2: Reproductive History (Adult only)
          if (!isMinor) ...[
            _buildSectionCard(
              title: ref.tr('profile_section_reproductive'),
              subtitle: _isSectionComplete('reproductive')
                  ? 'Pregnancy status recorded'
                  : 'Pregnancy, maternal status & contraception',
              icon: Icons.child_care_outlined,
              isComplete: _isSectionComplete('reproductive'),
              onTap: _openReproductiveSheet,
            ),
            const SizedBox(height: 12),
          ],

          // Section 3: Medical History (Adult only)
          if (!isMinor) ...[
            _buildSectionCard(
              title: ref.tr('profile_section_medical'),
              subtitle: _isSectionComplete('medical')
                  ? 'Conditions & screening info saved'
                  : 'Diagnoses, HPV vaccine & screening history',
              icon: Icons.health_and_safety_outlined,
              isComplete: _isSectionComplete('medical'),
              onTap: _openMedicalSheet,
            ),
            const SizedBox(height: 12),
          ],

          // Section 4: Lifestyle & Habits
          _buildSectionCard(
            title: ref.tr('profile_section_lifestyle'),
            subtitle: _isSectionComplete('lifestyle')
                ? 'Activity & stress levels logged'
                : 'Exercise, daily stress & tobacco habits',
            icon: Icons.directions_run_outlined,
            isComplete: _isSectionComplete('lifestyle'),
            onTap: _openLifestyleSheet,
          ),
          const SizedBox(height: 12),

          // Section 5: Family History (Adult only)
          if (!isMinor) ...[
            _buildSectionCard(
              title: ref.tr('profile_section_family'),
              subtitle: _isSectionComplete('family')
                  ? 'Family cancer history recorded'
                  : 'Cervical, breast or ovarian cancer history',
              icon: Icons.family_restroom_outlined,
              isComplete: _isSectionComplete('family'),
              onTap: _openFamilySheet,
            ),
            const SizedBox(height: 24),
          ],

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSaving ? null : _saveAndContinue,
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(ref.tr('profile_btn_save')),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isComplete,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final cardBg = isDark ? Palette.darkCard : Colors.white;

    return Material(
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isComplete
              ? accent.withValues(alpha: 0.5)
              : (isDark ? Palette.darkBorder : const Color(0xFFE9E2E9)),
          width: isComplete ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? Palette.darkSurface : Palette.blush,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Palette.darkMuted : Palette.slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(0xFF2E7D32),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Palette.darkMuted : Palette.slate,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
