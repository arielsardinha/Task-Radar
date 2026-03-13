import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:task_radar/data/storage/storage.dart';

@GenerateNiceMocks([MockSpec<Storage>()])
void main() {}
