import 'package:flutter/material.dart';

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return "Le nom d'utilisateur ne peut pas etre vide.";
  }

  // Length constraints
  if (value.length < 3) {
    return "Le nom d'utilisateur doit contenir au moins 3 caractères.";
  }
  if (value.length > 20) {
    return "Le nom d'utilisateur doit etre inférieur a 20 caractères.";
  }

  // Allowed characters
  RegExp regex = RegExp(r'^[a-zA-Z0-9._]+$');
  if (!regex.hasMatch(value)) {
    return "Le nom d'utilisateur ne peut contenir que des lettres, numeros, underscores.";
  }

  // Additional checks (optional)
  // Check for reserved words
  // Check for existing usernames

  return null; // Username is valid
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le mot de passe est obligatoire';
  }

  if (value.length < 8) {
    return 'Le mot de passe doit contenir au moins 8 caractères';
  }

  bool aMinuscule = RegExp(r'[a-z]').hasMatch(value);
  bool aMajuscule = RegExp(r'[A-Z]').hasMatch(value);
  bool aChiffre = RegExp(r'[0-9]').hasMatch(value);
  // ... vérifiez les symboles si nécessaire

  if (!aMinuscule) {
    return 'Le mot de passe doit contenir au moins une minuscule';
  }
  if (!aMajuscule) {
     return 'Le mot de passe doit contenir au moins  une majuscule ';
  }
  if (!aChiffre) {
    return 'Le mot de passe doit contenir au moins  un chiffre ';
  }

  return null; // Le mot de passe est valide
}

String? validateMoovPhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le numéro de téléphone est obligatoire';
  }
  if (value.length != 8) {
    return 'Veuillez entrer un numéro valide';
  }
  if (!RegExp(r'^(96|97|98|99)\d{6}$').hasMatch(value)) {
    return 'Veuillez entrer un numéro Moov valide';
  }
  return null;
}

String? validateTogocomPhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le numéro de téléphone est obligatoire';
  }
  if (value.length != 8) {
    return 'Veuillez entrer un numéro valide';
  }
  if (!RegExp(r'^(70|90|91|92|93)\d{6}$').hasMatch(value)) {
    return 'Veuillez entrer un numéro Togocom valide';
  }
  return null;
}

String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le montant est obligatoire';
  }
  if (int.tryParse(value) == null) {
    return 'Veuillez entrer un montant valide';
  }
  if (int.parse(value) < 100) {
    return 'Veuillez entrer un montant valide supérieur a 100 fcfa';
  }

  return null;
}
