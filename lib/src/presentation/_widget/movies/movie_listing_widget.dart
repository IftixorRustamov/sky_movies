part of '../../view/movies_view.dart';

class _MovieListingWidget extends HookWidget {
  const _MovieListingWidget({
    required this.movies,
    required this.whenScrollBottom,
    required this.hasReachedMax,
  });

  final List<MovieDetailEntity>? movies;
  final void Function() whenScrollBottom;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    useAutomaticKeepAlive();

    useEffect(
      () {
        void scrollListener() {
          print('Scroll position: ${scrollController.position.pixels} / ${scrollController.position.maxScrollExtent}');
          if (!hasReachedMax &&
              scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent - 200) {
            print('Triggering load more');
            whenScrollBottom.call();
          }
        }

        scrollController.addListener(scrollListener);

        return () => scrollController.removeListener(scrollListener);
      },
      [scrollController, hasReachedMax],
    );

    return ListView(
      shrinkWrap: false,
      controller: scrollController,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: movies?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            final tag = UniqueKey();

            return GestureDetector(
              onTap: () => context.router.push(
                  MovieDetailRoute(movieDetail: movies?[index], heroTag: tag)),
              child: Hero(tag: tag, child: MovieCard(movie: movies?[index])),
            );
          },
        ),
        if (!hasReachedMax) const BaseIndicator(),
      ],
    );
  }
}
