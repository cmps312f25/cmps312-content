import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/core/entities/user.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final bool loggedIn;
  final User? user;
  final VoidCallback? onLogout;

  const CustomNavigationDrawer({
    super.key,
    required this.loggedIn,
    this.user,
    this.onLogout,
  });

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.green,
                    padding: const EdgeInsets.only(top: 40, bottom: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundImage:
                              widget.loggedIn &&
                                  widget.user?.photoUrl != null &&
                                  widget.user!.photoUrl.isNotEmpty
                              ? NetworkImage(widget.user!.photoUrl)
                              : null,
                          child:
                              (!widget.loggedIn ||
                                  widget.user?.photoUrl == null)
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.loggedIn
                              ? (widget.user?.firstName ?? "User")
                              : "Guest",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.loggedIn ? (widget.user?.email ?? "") : "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: Colors.white,
                    child: Wrap(
                      runSpacing: 8,
                      children: [
                        if (widget.loggedIn) ...[
                          ListTile(
                            leading: const Icon(
                              Icons.person_2_outlined,
                              color: Colors.blueGrey,
                            ),
                            title: const Text(
                              "Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              context.go("/profile");
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.bar_chart,
                              color: Colors.deepPurple,
                            ),
                            title: const Text(
                              "Statistics",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              context.go("/statistics");
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.star_outlined,
                              color: Colors.amber.shade700,
                            ),
                            title: const Text(
                              "Premium",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              context.go("/premium");
                            },
                          ),
                        ],
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.grey,
                          ),
                          title: const Text(
                            "Settings",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          onTap: () {
                            context.go("/settings");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: Icon(
                    widget.loggedIn ? Icons.logout : Icons.login,
                    color: widget.loggedIn
                        ? Colors.red.shade400
                        : Colors.green.shade600,
                  ),
                  title: Text(
                    widget.loggedIn ? "Logout" : "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: widget.loggedIn
                          ? Colors.red.shade400
                          : Colors.green.shade700,
                    ),
                  ),
                  onTap: () {
                    if (widget.loggedIn) {
                      widget.onLogout?.call();
                    } else {
                      context.go("/login");
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: isEnglish,
                      onChanged: (value) {
                        setState(() {
                          isEnglish = value;
                        });
                      },
                    ),
                    Text(
                      isEnglish ? "EN" : "AR",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
