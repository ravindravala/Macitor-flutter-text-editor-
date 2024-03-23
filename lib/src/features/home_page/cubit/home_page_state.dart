part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<TextFile> allFiles;
  final int currentIndex;
  const HomePageState(this.allFiles, this.currentIndex);

  @override
  List<Object?> get props => [identityHashCode(this)];

  HomePageState copyWith(List<TextFile>? allFiles, int? currentIndex) {
    return HomePageState(
      allFiles ?? this.allFiles,
      currentIndex ?? this.currentIndex,
    );
  }
}
