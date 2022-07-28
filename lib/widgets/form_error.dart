import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        const Icon(
          Icons.warning,
          color: kWarning,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(error),
      ],
    );
  }
}
