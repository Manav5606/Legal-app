import 'package:admin/presentation/pages/client_admin/client_page.dart';
import 'package:admin/presentation/pages/user_admin/user_page.dart';
import 'package:flutter/material.dart';

enum AdminMenu {
  client("Client", ClientPage()),
  users("Users", UserPage()),
  services("Services", ClientPage()),
  category("Category", ClientPage()),
  addNotification("Add Notification", ClientPage()),
  editLandingPage("Edit Landing Page", ClientPage());

  final String title;
  final Widget view;
  const AdminMenu(this.title, this.view);
}
