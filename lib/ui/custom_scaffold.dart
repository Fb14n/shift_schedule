import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shift_schedule/services/api_service.dart';
import 'package:shift_schedule/ui/themes/theme.dart';
import 'package:shift_schedule/utils/toggle_theme.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomScaffold extends StatefulWidget {
  final Widget? body;
  final Widget? title;
  final Future<void> Function()? onRefresh;
  final bool showEditButton;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    this.body,
    this.title,
    this.onRefresh,
    this.showEditButton = false,
    this.floatingActionButton,

  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  late Future<Map<String, dynamic>> _userDetailsFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = apiService.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = GoRouterState.of(context).name;
    final bool canPop = context.canPop();
    //final themeMode = ThemeManager.themeModeNotifier.value;
    final String logoAsset = Theme.of(context).brightness == Brightness.light
        ? 'assets/logo/logo_vertical.svg'
        : 'assets/logo/logo_vertical_dark.svg';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.title ?? SvgPicture.asset(logoAsset, height: 40),
        leading: canPop
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        )
            : Builder(
          builder: (context) => IconButton(
            icon: const Icon(Symbols.person),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     themeMode == ThemeMode.light
          //         ? Symbols.dark_mode
          //         : Symbols.light_mode,
          //   ),
          //   onPressed: ThemeManager.toggleTheme,
          // ),
          FutureBuilder<Map<String, dynamic>>(
            future: _userDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              final isAdmin = snapshot.hasData && snapshot.data?['is_admin'] == true;
              if (!isAdmin) return const SizedBox.shrink();
              if (!widget.showEditButton) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Editieren',
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.pushNamed('user_list');
                },
              );
            },
          ),
          if (currentRoute != 'settings')
            IconButton(
              icon: const Icon(Symbols.settings_rounded),
              onPressed: () => context.pushNamed('settings'),
            ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: CHRONOSTheme.secondary));
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Benutzerdaten konnten nicht geladen werden.\nFehler: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final userDetails = snapshot.data!;
            final firstName = userDetails['first_name'] ?? 'Unbekannt';
            final lastName = userDetails['last_name'] ?? '';
            final employeeId =
                userDetails['employee_id']?.toString() ?? 'Keine ID';
            final vacationDays = userDetails['vacation_days'] ?? 0;
            final sickDays = userDetails['sick_days'] ?? 0;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          '$firstName $lastName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CHRONOSTheme.onPrimary,
                          ),
                        ),
                        accountEmail: Text(
                          'Mitarbeiter-ID: $employeeId',
                          style: const TextStyle(
                            color: CHRONOSTheme.onPrimary,
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: CHRONOSTheme.onPrimary,
                          child: Text(
                            firstName.isNotEmpty ? firstName[0] : '?',
                            style: const TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: CHRONOSTheme.primary,
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: CHRONOSTheme.primary,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.beach_access_outlined),
                        title: const Text('Resturlaub'),
                        trailing: Text(
                          '$vacationDays Tage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CHRONOSTheme.of(context).onBackground,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.sick_outlined),
                        title: const Text('Krankheitstage'),
                        trailing: Text(
                          '$sickDays Tage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CHRONOSTheme.of(context).onBackground,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Symbols.logout,
                            color: CHRONOSTheme.error),
                        title: const Text(
                          'Abmelden',
                          style: TextStyle(color: CHRONOSTheme.error),
                        ),
                        onTap: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Abmelden bestätigen'),
                                content: const Text(
                                    'Möchten Sie sich wirklich abmelden?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Ja',
                                        style: TextStyle(
                                            color: CHRONOSTheme.error)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Nein',
                                        style: TextStyle(color: CHRONOSTheme.secondary)),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLogout == true) {
                            await apiService.logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'CHRONOS © ${DateTime.now().year}\nDeveloped by Fabian Berger',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CHRONOSTheme.of(context).onBackgroundLight,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: RefreshIndicator(
        color: CHRONOSTheme.secondary,
        backgroundColor: CHRONOSTheme.of(context).popUpBackground,
        onRefresh: () async {
          final List<Future> refreshFutures = [];
          final userDetailsFuture = apiService.fetchUserDetails();
          refreshFutures.add(userDetailsFuture);

          setState(() {
            _userDetailsFuture = userDetailsFuture;
          });
          if (widget.onRefresh != null) {
            refreshFutures.add(widget.onRefresh!());
          }
          await Future.wait(refreshFutures);
        },
        child: widget.body is ScrollView
            ? widget.body!
            : SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: widget.body ?? const SizedBox.shrink(),
        ),
      ),
      floatingActionButton: widget.floatingActionButton == null
          ? null
          :  Padding(
        padding: const EdgeInsets.only(
          right: 24,
          bottom: 24,
        ),
        child: widget.floatingActionButton,
      ),
    );
  }
}