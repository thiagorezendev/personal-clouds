import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pega o usuário logado para exibir o email
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Catálogo de Nuvens'),
        actions: [
          // Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bem-vindo(a)!\nVocê está logado como: ${user?.email}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}