import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_radar/global/providers/provider_user.dart';
import 'package:task_radar/modules/login/view_models/login_view_model.dart';
import 'package:validatorless/validatorless.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit(String username, String password) async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final user = await widget.viewModel.authenticate(username, password);
    if (!mounted) return;

    if (user != null) {
      context.read<ProviderUser>().user = user;
      TextInput.finishAutofillContext(shouldSave: true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Falha ao realizar login. Verifique suas credenciais e tente novamente.',
          key: Key('LoginScreen.Text.feedbackError'),
        ),
      ),
    );
    TextInput.finishAutofillContext(shouldSave: false);
    _passwordController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _passwordFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.viewModel,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 360
                    ? 20.0
                    : 32.0;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      Text(
                        'Task Radar',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        height: !widget.viewModel.isLoading ? null : 0,
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const Key(
                                    'LoginScreen.TextFormField.username',
                                  ),
                                  controller: _usernameController,
                                  focusNode: _usernameFocusNode,
                                  enabled: !widget.viewModel.isLoading,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  autofillHints: const [AutofillHints.username],
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(64),
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9._@-]'),
                                    ),
                                  ],
                                  validator: Validatorless.multiple([
                                    Validatorless.required(
                                      'Informe o nome de usuário',
                                    ),
                                  ]),
                                  decoration: const InputDecoration(
                                    labelText: 'Usuário',
                                    hintText: 'Digite o usuário',
                                  ),
                                  onFieldSubmitted: (_) {
                                    _passwordFocusNode.requestFocus();
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  key: const Key(
                                    'LoginScreen.TextFormField.password',
                                  ),
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  enabled: !widget.viewModel.isLoading,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  textCapitalization: TextCapitalization.none,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  enableIMEPersonalizedLearning: false,
                                  obscureText: widget.viewModel.obscurePassword,
                                  autofillHints: const [AutofillHints.password],
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(128),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'[\r\n]'),
                                    ),
                                  ],
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Informe a senha'),
                                  ]),
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    hintText: 'Digite sua senha',
                                    suffixIcon: IconButton(
                                      onPressed: widget.viewModel.isLoading
                                          ? null
                                          : widget
                                                .viewModel
                                                .togglePasswordVisibility,
                                      icon: Icon(
                                        widget.viewModel.obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) => _submit(
                                    _usernameController.text,
                                    _passwordController.text,
                                  ),
                                ),

                                const SizedBox(height: 16),
                                ElevatedButton(
                                  key: const Key(
                                    'LoginScreen.ElevatedButton.submit',
                                  ),
                                  onPressed: widget.viewModel.isLoading
                                      ? null
                                      : () => _submit(
                                          _usernameController.text,
                                          _passwordController.text,
                                        ),
                                  child: widget.viewModel.isLoading
                                      ? SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: colorScheme.onPrimary,
                                          ),
                                        )
                                      : const Text('Entrar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.viewModel.isLoading,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(
                            key: Key(
                              'LoginScreen.CircularProgressIndicator.authLoading',
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
