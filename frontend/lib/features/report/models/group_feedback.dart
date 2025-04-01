enum BodyPartGroup { back, arm, leg, core }

class GroupFeedback {
  final BodyPartGroup group;
  final int count;

  GroupFeedback({required this.group, required this.count});
}
