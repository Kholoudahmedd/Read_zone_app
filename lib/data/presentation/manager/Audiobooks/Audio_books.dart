import 'package:read_zone_app/data/models/Audiobook_model.dart';
import 'package:equatable/equatable.dart';


abstract class AudioBooksState extends Equatable {
  const AudioBooksState();

  @override
  List<Object?> get props => [];
}

class AudioBooksInitial extends AudioBooksState {}

class AudioBooksLoading extends AudioBooksState {}

class AudioBooksPaginationLoading extends AudioBooksState {}

class AudioBooksPaginationFailure extends AudioBooksState {
  final String errMessage;

  AudioBooksPaginationFailure(this.errMessage);
}

class AudioBooksFailure extends AudioBooksState {
  final String errMessage;

  AudioBooksFailure(this.errMessage);
}

class AudioBooksSuccess extends AudioBooksState {
  final List<AudioBook> books;

  AudioBooksSuccess(this.books);
}
