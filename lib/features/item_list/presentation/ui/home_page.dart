import 'dart:async';

import 'package:fake_store_prog/core/widgets/bottom_nav_bar.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_bloc.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_event.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_state.dart';
import 'package:fake_store_prog/core/widgets/header.dart';
import 'package:fake_store_prog/features/item_list/widgets/item_card.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  static const double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    context.read<ItemListBloc>().add(FetchItemsRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll - current <= _scrollThreshold) {
      final state = context.read<ItemListBloc>().state;
      if (state is OpenItemsListSuccess && !state.hasReachedMax) {
        context.read<ItemListBloc>().add(FetchItemsRequested());
      } else if (state is ItemListStateInitial) {
        context.read<ItemListBloc>().add(FetchItemsRequested());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<ItemListBloc>().add(FetchItemsRequested(refresh: true));
    final completer = Completer<void>();
    final sub = context.read<ItemListBloc>().stream.listen((s) {
      if (s is OpenItemsListSuccess || s is FetchItemsError) {
        if (!completer.isCompleted) completer.complete();
      }
    });
    await completer.future.timeout(const Duration(seconds: 8), onTimeout: () {});
    await sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemListBloc, ItemListState>(
      listener: (context, state) {
        if (state is FetchItemsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: SafeArea(
          child: BlocBuilder<ItemListBloc, ItemListState>(
            builder: (context, state) {
              if (state is FetchLoading || state is ItemListStateInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OpenItemsListSuccess) {
                final username = state.user.name;
                final items = state.items;
                final hasReachedMax = state.hasReachedMax;

                return Column(
                  children: [
                    Header(
                      headerText: 'Welcome,',
                      username: username,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        height: 35,
                        width: 327,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Fake Store',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              height: 1.25,
                              color: Color(0xFF252425),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 20, bottom: 16),
                          itemCount: items.length + (hasReachedMax ? 0 : 1),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index >= items.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
                                ),
                              );
                            }
                            return Center(
                              child: SizedBox(
                                width: 342,
                                child: ItemCard(item: items[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is FetchItemsError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
