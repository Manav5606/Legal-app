import 'package:admin/presentation/pages/category_admin/category_page.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_page.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_page.dart';
import 'package:admin/presentation/pages/client_admin/client_page.dart';
import 'package:flutter/material.dart';

enum AdminMenu {
  vendors("Vendors", VendorPage()),
  clients("Clients", ClientPage()),
  category("Category", CategoryPage()),
  // services("Services", VendorPage()),
  addNotification("Add Notification", VendorPage()),
  editLandingPage("Edit Landing Page", EditLandingPage());

  final String title;
  final Widget view;
  const AdminMenu(this.title, this.view);
}
