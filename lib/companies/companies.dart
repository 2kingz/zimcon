import 'package:flutter/material.dart';
import 'package:zimcon/companies/page/index.dart';

class CompaniesPages extends StatefulWidget {
  const CompaniesPages({Key? key}) : super(key: key);

  @override
  _CompaniesPagesState createState() => _CompaniesPagesState();
}

class _CompaniesPagesState extends State<CompaniesPages> {
  @override
  Widget build(BuildContext context) {
    return Container(child: MaterialApp(home: IndexPage()));
  }
}
