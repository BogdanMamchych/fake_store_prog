import 'dart:async';

import 'package:fake_store_prog/core/widgets/bottom_navigation_bar.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_bloc.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_event.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_state.dart';
import 'package:fake_store_prog/core/widgets/header.dart';
import 'package:fake_store_prog/features/item_list/widgets/product_card.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
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
    // Optional: wait until first page loaded or timeout
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
                    SizedBox(
                      height: 148,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Header(headerText: 'Welcome, ', username: username),
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
                              // bottom loading indicator
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())),
                              );
                            }
                            return ItemCard(item: items[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is FetchItemsError) {
                return Center(child: Text('Error: ${state.message}', style: mainTextStyle));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
