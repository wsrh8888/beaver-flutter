class ProjectLink {
  final String name;
  final String description;
  final String url;
  final String icon;

  const ProjectLink({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
  });
}

class AuthorInfo {
  final String name;
  final String description;
  final String githubUrl;

  const AuthorInfo({
    required this.name,
    required this.description,
    required this.githubUrl,
  });
}
