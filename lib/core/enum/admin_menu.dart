import 'package:admin/presentation/pages/category_admin/category_page.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_page.dart';
import 'package:admin/presentation/pages/user_admin/user_page.dart';
import 'package:flutter/material.dart';

enum AdminMenu {
  vendors("Client", VendorPage()),
  users("Users", UserPage()),
  services("Services", VendorPage()),
  category("Category", CategoryPage()),
  addNotification("Add Notification", VendorPage()),
  editLandingPage("Edit Landing Page", VendorPage());

  final String title;
  final Widget view;
  const AdminMenu(this.title, this.view);
}
