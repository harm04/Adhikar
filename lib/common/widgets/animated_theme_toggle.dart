import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhikar/providers/theme_provider.dart';
import 'package:adhikar/theme/color_scheme.dart';

// Radio button style theme toggle
class RadioThemeToggle extends ConsumerWidget {
  const RadioThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Theme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          _buildRadioOption(
            context,
            'Light Mode',
            Icons.light_mode,
            ThemeMode.light,
            themeMode,
            themeNotifier,
          ),
          const SizedBox(height: 8),
          _buildRadioOption(
            context,
            'Dark Mode',
            Icons.dark_mode,
            ThemeMode.dark,
            themeMode,
            themeNotifier,
          ),
          const SizedBox(height: 8),
          _buildRadioOption(
            context,
            'System Default',
            Icons.settings,
            ThemeMode.system,
            themeMode,
            themeNotifier,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context,
    String title,
    IconData icon,
    ThemeMode value,
    ThemeMode currentValue,
    ThemeNotifier notifier,
  ) {
    final isSelected = currentValue == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: () => notifier.setTheme(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? context.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? context.primaryColor : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? context.primaryColor
                        : context.iconSecondaryColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.primaryColor,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Icon(
                icon,
                color: isSelected
                    ? context.primaryColor
                    : Theme.of(context).iconTheme.color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? context.primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
