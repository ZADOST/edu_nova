import 'dart:async';

class AlumniEvent {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;

  AlumniEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });
}

class AlumniRepository {
  // Simulating an API call to fetch networking events
  Future<List<AlumniEvent>> fetchUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 900));
    
    return [
      AlumniEvent(
        id: 'evt_01',
        title: 'Tech Innovators Networking Mixer',
        date: 'August 15, 2026',
        location: 'Erbil International Hotel',
        description: 'Join fellow graduates in the tech sector for an evening of networking, idea sharing, and opportunities with leading regional startups.',
      ),
      AlumniEvent(
        id: 'evt_02',
        title: 'Annual Alumni Gala Dinner',
        date: 'October 10, 2026',
        location: 'University Grand Hall',
        description: 'Celebrate the achievements of our outstanding alumni with a formal dinner and awards ceremony.',
      ),
    ];
  }
}