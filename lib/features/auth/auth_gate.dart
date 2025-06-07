import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_clouds/features/auth/login_page.dart';
import 'package:personal_clouds/features/home/home_page.dart'; // Criaremos este arquivo a seguir

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Ouve o estado da autenticação em tempo real
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se o snapshot ainda não tem dados, mostra uma tela de carregamento
        if (!snapshot.hasData) {
          return const LoginPage(); // Se não há usuário logado, mostra a tela de login
        }

        // Se há um usuário logado, mostra a tela principal
        return const HomePage();
      },
    );
  }
}