import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para ler o texto dos campos de email e senha
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variável para controlar se estamos em modo de login ou cadastro
  bool _isLoginMode = true;

  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _emailError;
  String? _passwordError;

  // Método para lidar com o login/cadastro
  void _submit() async {
    // Limpa os erros anteriores antes de uma nova tentativa
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    try {
      if (_isLoginMode) {
        // Modo Login
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Modo Cadastro
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      // Se chegar aqui, o login/cadastro foi bem sucedido.
      // O AuthGate vai lidar com o redirecionamento automaticamente.
    } on FirebaseAuthException catch (e) {
      // Exibe uma mensagem de erro para o usuário
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            _emailError = 'O formato do email é inválido.';
            break;
          case 'user-not-found':
            _emailError = 'Nenhum usuário encontrado com este email.';
            break;
          case 'email-already-in-use':
            _emailError = 'Este email já está sendo usado em outra conta.';
            break;
          case 'wrong-password':
            _passwordError = 'A senha está incorreta.';
            break;
          case 'weak-password':
            _passwordError =
                'A senha é muito fraca. Use no mínimo 6 caracteres.';
            break;
          case 'invalid-credential':
            _passwordError =
                'Credenciais inválidas. Verifique seu email e senha.';
            break;
          default:
            // Um erro genérico caso não seja um dos acima
            _passwordError = 'Ocorreu um erro. Tente novamente.';
        }
      });
    }
  }

  // Método para alternar entre os modos
  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoginMode
              ? 'Login - Personal Clouds'
              : 'Cadastro - Personal Clouds',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de Nuvem
              const Icon(Icons.cloud_circle, size: 100, color: Colors.blue),
              const SizedBox(height: 20),

              // Campo de Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  errorText: _emailError, // Exibe erro se houver
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              // Campo de Senha
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  errorText: _passwordError, // Exibe erro se houver
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Botão de Enviar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_isLoginMode ? 'Entrar' : 'Cadastrar'),
                ),
              ),
              const SizedBox(height: 10),

              // Botão para Alternar o Modo
              TextButton(
                onPressed: _toggleMode,
                child: Text(
                  _isLoginMode
                      ? 'Não tem uma conta? Cadastre-se'
                      : 'Já tem uma conta? Faça login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
