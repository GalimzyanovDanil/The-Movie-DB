// import 'package:flutter/material.dart';

// class NotifierProvider<M extends ChangeNotifier> extends StatefulWidget {
//   final M Function() create;
//   final Widget child;
//   final bool isManagingModel;

//   const NotifierProvider({
//     required this.create,
//     this.isManagingModel = true,
//     required this.child,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _NotifierProviderState<M> createState() => _NotifierProviderState<M>();

//   static Model? watch<Model extends ChangeNotifier>(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<_InheritedNotifierProvider<Model>>()
//         ?.model;
//   }

//   static Model? read<Model extends ChangeNotifier>(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<
//             _InheritedNotifierProvider<Model>>()
//         ?.widget;
//     return widget is _InheritedNotifierProvider<Model> ? widget.model : null;
//   }
// }

// class _NotifierProviderState<Model extends ChangeNotifier>
//     extends State<NotifierProvider<Model>> {
//   late final Model _model;
//   @override
//   void initState() {
//     _model = widget.create();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _InheritedNotifierProvider<Model>(
//       model: _model,
//       child: widget.child,
//     );
//   }

//   @override
//   void dispose() {
//     if (widget.isManagingModel) _model.dispose();

//     super.dispose();
//   }
// }

// class _InheritedNotifierProvider<Model extends ChangeNotifier>
//     extends InheritedNotifier {
//   final Model model;

//   const _InheritedNotifierProvider({
//     required Widget child,
//     required this.model,
//     Key? key,
//   }) : super(
//           key: key,
//           child: child,
//           notifier: model,
//         );
// }

// class Provider<Model> extends InheritedWidget {
//   final Model model;
//   const Provider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(key: key, child: child);

//   static Model? watch<Model>(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<Provider<Model>>()?.model;
//   }

//   static Model? read<Model>(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<Provider<Model>>()
//         ?.widget;
//     return widget is Provider<Model> ? widget.model : null;
//   }

//   @override
//   bool updateShouldNotify(Provider oldWidget) {
//     return model != oldWidget.model;
//   }
// }
