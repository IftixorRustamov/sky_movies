import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/components/bottom_sheet/social_media_bottom_sheet.dart';
import '../../core/components/buttons/bookmark_button.dart';
import '../../core/components/image/base_network_image.dart';
import '../../core/extensions/int_extensions.dart';
import '../../domain/entities/export_entities.dart';
import '../cubit/movie/get_movie_credits/get_movie_credits_cubit.dart';

part '../_widget/movie_detail/actor_card.dart';

part '../_widget/movie_detail/tag_container.dart';

@RoutePage()
class MovieDetailView extends StatelessWidget {
  const MovieDetailView(
      {super.key, required this.movieDetail, required this.heroTag});

  final MovieDetailEntity? movieDetail;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<GetMovieCreditsCubit>()
        ..getMovieCredits(movieDetail?.id ?? 0),
      child: _MovieDetailView(movieDetail: movieDetail, heroTag: heroTag),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView({required this.movieDetail, required this.heroTag});

  final MovieDetailEntity? movieDetail;
  final Object heroTag;

  void showSocialMediaBottomSheet(BuildContext context,
      {required String? actorId, required String? actorName}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) =>
          SocialMediaBottomSheet(actorId: actorId, actorName: actorName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => showSocialMediaBottomSheet(context,
                        actorId: '', actorName: '')),
                BookmarkButton.filled(movieDetailEntity: movieDetail),
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            //* Appbar
            SliverAppBar(
              expandedHeight: 500,
              collapsedHeight: kToolbarHeight,
              pinned: true,
              actions: [BookmarkButton.filled(movieDetailEntity: movieDetail)],
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  BaseNetworkImage.originalImageSize(
                    movieDetail?.posterPath,
                    hasRadius: false,
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      movieDetail?.title ?? '',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ],
              ),
            ),

            //* Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Stats
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movieDetail?.title ?? '',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            5.verticalSpace,
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 18, color: Colors.amber),
                                5.horizontalSpace,
                                Text(movieDetail?.voteAverage
                                        ?.toStringAsFixed(1) ??
                                    ''),
                                10.horizontalSpace,
                                Text(
                                  "· ${DateFormat('yyyy').format(DateTime.tryParse(movieDetail?.releaseDate ?? '') ?? DateTime.now())}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    20.verticalSpace,

                    //* Overview
                    ExpandableText(
                      movieDetail?.overview ?? '',
                      expandText: 'read more',
                      collapseText: 'read less',
                      maxLines: 4,
                      linkColor: Theme.of(context).colorScheme.primary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    20.verticalSpace,

                    //* Backdrop Carousel
                    CarouselSlider(
                      options: CarouselOptions(
                          height: 200.h, enlargeCenterPage: true),
                      items: [
                        movieDetail?.backdropPath,
                      ].map((path) {
                        return BaseNetworkImage.originalImageSize(path);
                      }).toList(),
                    ),

                    20.verticalSpace,

                    //* Tags
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieDetail?.genreIds?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12).r,
                        itemBuilder: (context, index) {
                          return Chip(
                            label: Text(
                              '${movieDetail?.genreIds?[index].getGenreFromNumber()}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            10.horizontalSpace,
                      ),
                    ),

                    20.verticalSpace,

                    //* Cast
                    Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10)
                          .r,
                      child: Text(
                        'Cast',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    BlocBuilder<GetMovieCreditsCubit, GetMovieCreditsState>(
                      builder: (context, state) {
                        if (state is! GetMovieCreditsLoaded) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).primaryColorDark,
                            highlightColor: Theme.of(context).primaryColor,
                            child: SizedBox(
                              height: 70.h,
                              width: 1.sw,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12)
                                        .r,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, __) => Container(
                                  height: 70.h,
                                  width: 225.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 30.w),
                                itemCount: 4,
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 70.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12).r,
                            itemBuilder: (_, index) => SizedBox(
                              height: 70.h,
                              width: 225.w,
                              child: _ActorCard(
                                  castEntity:
                                      state.movieCreditEntity.cast?[index]),
                            ),
                            separatorBuilder: (_, __) => SizedBox(width: 30.w),
                            itemCount:
                                state.movieCreditEntity.cast?.length ?? 0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
