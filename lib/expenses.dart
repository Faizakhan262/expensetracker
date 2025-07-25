import 'package:expensetraker/models/expense.dart';
import 'package:expensetraker/widgets/expenses_list/expenses_list.dart';
import 'package:expensetraker/widgets/new_expense.dart' hide Category;
import 'package:flutter/material.dart';

import 'chart/chart_bar.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses=
  [
    Expense(title: "Flutter demo", amount: 19.9, date: DateTime.now(), category: Category.work),
    Expense(title: "Flutter demo", amount: 19.9, date: DateTime.now(), category: Category.work)

  ];


  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }



void _addExpense(Expense expense){
  setState(() {
_registeredExpenses.add(expense);
  });
}

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.add(expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracklt"),
        actions:[
          IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
    ],
      ),
      body: Column(
        children: [
          // 👇 Chart section
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: Category.values.map((category) {
                final bucket = ExpenseBucket.forCategory(_registeredExpenses, category);
                final totalCategory = bucket.totalExpenses;
                final totalOverall = _registeredExpenses.fold(
                  0.0,
                      (sum, e) => sum + e.amount,
                );
                final fill = totalOverall == 0 ? 0.0 : totalCategory / totalOverall;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ChartBar(fill: fill),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name[0].toUpperCase() + category.name.substring(1),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),


          // 👇 Expense list
          Expanded(
            child: ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            ),
          ),
        ],
      ),

    );
  }
}
