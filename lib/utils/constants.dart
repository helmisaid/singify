import 'package:flutter/material.dart';
import 'package:singify/models/genre_model.dart';
import 'package:singify/models/song_model.dart';

// Colors
const Color primaryColor = Color(0xFF8b2cf5);
const Color cardColor = Color(0xFFffffff);

// Text Styles
const TextStyle titleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Color(0xFF282828),
);

const TextStyle subtitleStyle = TextStyle(
  fontSize: 14,
  color: Color(0xFF666666),
);

// Padding
const double defaultPadding = 16.0;

// Sample Data - Featured Songs
final List<Song> featuredSongs = [
  Song(
    id: '1',
    title: 'Anti-Hero',
    artist: 'Taylor Swift',
    albumArt: 'assets/images/album_covers/anti_hero.jpg',
    lyrics:
        "I have this thing where I get older but just never wiser\nMidnights become my afternoons\nWhen my depression works the graveyard shift\nAll of the people I've ghosted stand there in the room\n\nI should not be left to my own devices\nThey come with prices and vices\nI end up in crisis (tale as old as time)\nI wake up screaming from dreaming\nOne day I'll watch as you're leaving\n'Cause you got tired of my scheming\n(For the last time)\n\nIt's me, hi, I'm the problem, it's me\nAt tea time, everybody agrees\nI'll stare directly at the sun but never in the mirror\nIt must be exhausting always rooting for the anti-hero",
    genre: 'Pop',
  ),
  Song(
    id: '2',
    title: 'Sparks',
    artist: 'Coldplay',
    albumArt: 'assets/images/album_covers/sparks.jpg',
    lyrics:
        "Did I drive you away?\nI know what you'll say\nYou say, \"Oh, sing one we know\"\nBut I promise you this\nI'll always look out for you\nThat's what I'll do\n\nI say \"oh\"\nI say \"oh\"\n\nMy heart is yours\nIt's you that I hold on to\nThat's what I do\nAnd I know I was wrong\nBut I won't let you down\n(Oh yeah, yeah, yes I will)\n\nI say \"oh\"\nI cry \"oh\"\n\nYeah I saw sparks\nYeah I saw sparks\nAnd I saw sparks\nYeah I saw sparks\nSing it out",
    genre: 'Rock',
  ),
  Song(
    id: '3',
    title: 'Viva La Vida',
    artist: 'Coldplay',
    albumArt: 'assets/images/album_covers/viva_la_vida.jpg',
    lyrics:
        "I used to rule the world\nSeas would rise when I gave the word\nNow in the morning, I sleep alone\nSweep the streets I used to own\n\nI used to roll the dice\nFeel the fear in my enemy's eyes\nListen as the crowd would sing\n\"Now the old king is dead! Long live the king!\"\n\nOne minute I held the key\nNext the walls were closed on me\nAnd I discovered that my castles stand\nUpon pillars of salt and pillars of sand\n\nI hear Jerusalem bells are ringing\nRoman Cavalry choirs are singing\nBe my mirror, my sword and shield\nMy missionaries in a foreign field\n\nFor some reason I can't explain\nOnce you'd gone, there was never\nNever an honest word\nAnd that was when I ruled the world",
    genre: 'Rock',
  ),
];

// Sample Data - Popular Lyrics
final List<Song> popularLyrics = [
  Song(
    id: '4',
    title: 'Shape of You',
    artist: 'Ed Sheeran',
    albumArt: 'assets/images/album_covers/shape_of_you.jpg',
    genre: 'Pop',
  ),
  Song(
    id: '5',
    title: 'Blinding Lights',
    artist: 'The Weeknd',
    albumArt: 'assets/images/album_covers/blinding_lights.jpg',
    genre: 'R&B',
  ),
  Song(
    id: '6',
    title: 'Bad Guy',
    artist: 'Billie Eilish',
    albumArt: 'assets/images/album_covers/bad_guy.jpg',
    genre: 'Pop',
  ),
];

// Sample Data - Genres
final List<Genre> genres = [
  Genre(
    name: 'Pop',
    imageUrl: 'assets/images/genres/pop.jpg',
    songCount: 12,
  ),
  Genre(
    name: 'Rock',
    imageUrl: 'assets/images/genres/rock.jpg',
    songCount: 12,
  ),
  Genre(
    name: 'Hip Hop',
    imageUrl: 'assets/images/genres/hiphop.jpg',
    songCount: 12,
  ),
  Genre(
    name: 'R&B',
    imageUrl: 'assets/images/genres/rnb.jpg',
    songCount: 12,
  ),
];
