import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🍒 🍒',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Text(
            'Cherry Toasts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Info Cherry Toast'),
              onPressed: () {
                CherryToast.info(
                  disableToastAnimation: true,
                  title: const Text(
                    'Cherry toast title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  action: const Text('Toast content description'),
                  actionHandler: () {},
                  onToastClosed: () {
                    print('Toast closed');
                  },
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Cherry Toast Without Animation'),
              onPressed: () {
                CherryToast.info(
                  disableToastAnimation: true,
                  autoDismiss: false,
                  toastPosition: Position.top,
                  title: const Text(
                    'Cherry toast title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  action: const Text('Toast content description'),
                  actionHandler: () {},
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Error Cherry Toast'),
              onPressed: () {
                CherryToast.error(
                  enableIconAnimation: false,
                  description: const Text('Invalid account information'),
                  animationType: AnimationType.fromRight,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Bottom Cherry Toast'),
              onPressed: () {
                CherryToast(
                  icon: Icons.alarm_add,
                  themeColor: Colors.pink,
                  description: const Text('A bottom cherry toast example'),
                  toastPosition: Position.bottom,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Center Cherry Toast'),
              onPressed: () {
                CherryToast(
                  icon: Icons.android,
                  themeColor: Colors.green,
                  title: const Text(''),
                  description: const Text('A center cherry toast example'),
                  toastPosition: Position.center,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Warning Cherry Toast'),
              onPressed: () {
                CherryToast.warning(
                  description:
                  const Text('All information may be deleted after this action'),
                  animationType: AnimationType.fromTop,
                  action: const Text('Backup data'),
                  actionHandler: () {},
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Success Cherry Toast'),
              onPressed: () {
                CherryToast.success(
                  title: const Text('The simplest cherry toast'),
                  borderRadius: 0,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🍒 Right Layout Cherry Toast'),
              onPressed: () {
                CherryToast(
                  icon: Icons.car_repair,
                  description: const Text('This is a description message'),
                  themeColor: Colors.green,
                  toastPosition: Position.bottom,
                  textDirection: TextDirection.rtl,
                  // Corrected here
                  animationType: AnimationType.fromRight,
                  action: const Text(
                    'انقر هنا',
                    style: TextStyle(color: Colors.green),
                  ),
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🇹🇳 Arabic Cherry Toast'),
              onPressed: () {
                CherryToast.info(
                  toastPosition: Position.top,
                  title: const Text(
                    'هذا مثال للإنذار',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  action: const Text('هذا النص كتب بالعربية'),
                  actionHandler: () {},
                  textDirection: TextDirection.rtl,
                ).show(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              child: const Text('🇰🇷 Korean Cherry Toast'),
              onPressed: () {
                CherryToast.info(
                  toastPosition: Position.top,
                  title: const Text(
                    '이건 제목이야',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  action: const Text('내용 설명입니다'),
                  actionHandler: () {},
                ).show(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
