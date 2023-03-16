enum TransactionStatus {
  success("Success"),
  fail("Fail"),
  initiated("Initiated");

  final String name;
  const TransactionStatus(this.name);
}
