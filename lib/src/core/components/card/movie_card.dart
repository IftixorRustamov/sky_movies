import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/export_entities.dart';
import '../../../presentation/cubit/movie/export_movie_cubits.dart';
import '../buttons/bookmark_button.dart';
import '../image/base_network_image.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, this.movie});

  final MovieDetailEntity? movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(2, 6),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          BaseNetworkImage.originalImageSize(movie?.posterPath),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, right: 8.w),
                    child:
                        BlocBuilder<GetSavedMoviesCubit, GetSavedMoviesState>(
                      builder: (context, state) {
                        if (state is GetSavedMoviesLoaded) {
                          return BookmarkButton(movieDetailEntity: movie);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.r),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.black.withOpacity(0.4),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        movie?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
