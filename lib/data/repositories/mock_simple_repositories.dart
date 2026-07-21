import '../../core/constants/app_config.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../mock/mock_database.dart';

Future<void> _tick() => Future<void>.delayed(AppConfig.mockNetworkDelay);

// -----------------------------------------------------------------------------
// Cards
// -----------------------------------------------------------------------------
class MockCardRepository implements CardRepository {
  MockCardRepository(this._db);
  final MockDatabase _db;

  @override
  Future<List<StudentCard>> getAllCards() async {
    await _tick();
    return List.of(_db.cards);
  }

  @override
  Future<StudentCard?> getCardByUid(String uid) async {
    await _tick();
    for (final c in _db.cards) {
      if (c.cardUid == uid) return c;
    }
    return null;
  }

  @override
  Future<StudentCard?> getCardForStudent(String studentId) async {
    await _tick();
    for (final c in _db.cards) {
      if (c.studentId == studentId && c.isActive) return c;
    }
    return null;
  }

  @override
  Future<StudentCard> assignCard(StudentCard card) async {
    await _tick();
    final index = _db.cards.indexWhere((c) => c.cardUid == card.cardUid);
    if (index >= 0) {
      _db.cards[index] = card;
    } else {
      _db.cards.add(card);
    }
    return card;
  }

  @override
  Future<StudentCard> replaceCard(String studentId, String newUid) async {
    await _tick();
    // Deactivate any existing active cards for the student.
    for (var i = 0; i < _db.cards.length; i++) {
      if (_db.cards[i].studentId == studentId && _db.cards[i].isActive) {
        _db.cards[i] = _db.cards[i].copyWith(isActive: false);
      }
    }
    final replacement = StudentCard(
      cardUid: newUid,
      studentId: studentId,
      issuedAt: DateTime.now(),
    );
    _db.cards.add(replacement);
    return replacement;
  }

  @override
  Future<void> deactivateCard(String uid) async {
    await _tick();
    final index = _db.cards.indexWhere((c) => c.cardUid == uid);
    if (index >= 0) {
      _db.cards[index] = _db.cards[index].copyWith(isActive: false);
    }
  }
}

// -----------------------------------------------------------------------------
// Houses
// -----------------------------------------------------------------------------
class MockHouseRepository implements HouseRepository {
  MockHouseRepository(this._db);
  final MockDatabase _db;

  @override
  Future<List<House>> getAllHouses() async {
    await _tick();
    return List.of(_db.houses);
  }

  @override
  Future<House?> getHouseById(String id) async {
    await _tick();
    return _db.houseById(id);
  }

  @override
  Future<House> addHousePoints(String houseId, int points) async {
    await _tick();
    final index = _db.houses.indexWhere((h) => h.id == houseId);
    if (index < 0) throw StateError('House $houseId not found');
    _db.houses[index] = _db.houses[index].copyWith(
      totalPoints: _db.houses[index].totalPoints + points,
      weeklyPoints: _db.houses[index].weeklyPoints + points,
    );
    return _db.houses[index];
  }

  @override
  Future<House> updateHouse(House house) async {
    await _tick();
    final index = _db.houses.indexWhere((h) => h.id == house.id);
    if (index >= 0) {
      _db.houses[index] = house;
    } else {
      _db.houses.add(house);
    }
    return house;
  }
}

// -----------------------------------------------------------------------------
// Classes
// -----------------------------------------------------------------------------
class MockClassRepository implements ClassRepository {
  MockClassRepository(this._db);
  final MockDatabase _db;

  @override
  Future<List<SchoolClass>> getAllClasses() async {
    await _tick();
    return List.of(_db.classes);
  }

  @override
  Future<SchoolClass?> getClassById(String id) async {
    await _tick();
    for (final c in _db.classes) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Future<SchoolClass> upsertClass(SchoolClass schoolClass) async {
    await _tick();
    final index = _db.classes.indexWhere((c) => c.id == schoolClass.id);
    if (index >= 0) {
      _db.classes[index] = schoolClass;
    } else {
      _db.classes.add(schoolClass);
    }
    return schoolClass;
  }
}

// -----------------------------------------------------------------------------
// Avatars
// -----------------------------------------------------------------------------
class MockAvatarRepository implements AvatarRepository {
  MockAvatarRepository(this._db);
  final MockDatabase _db;

  @override
  Future<Avatar?> getAvatarById(String id) async {
    await _tick();
    return _db.avatarById(id);
  }

  @override
  Future<Avatar> upsertAvatar(Avatar avatar) async {
    await _tick();
    final index = _db.avatars.indexWhere((a) => a.id == avatar.id);
    if (index >= 0) {
      _db.avatars[index] = avatar;
    } else {
      _db.avatars.add(avatar);
    }
    return avatar;
  }

  @override
  Future<List<AvatarEvolutionStage>> getEvolutionLadder() async {
    await _tick();
    return List.of(_db.evolutionLadder);
  }
}

// -----------------------------------------------------------------------------
// Config
// -----------------------------------------------------------------------------
class MockConfigRepository implements ConfigRepository {
  MockConfigRepository(this._db);
  final MockDatabase _db;

  @override
  Future<GamificationConfig> getConfig() async {
    await _tick();
    return _db.config;
  }

  @override
  Future<GamificationConfig> saveConfig(GamificationConfig config) async {
    await _tick();
    _db.config = config;
    _db.emitConfig();
    return config;
  }

  @override
  Stream<GamificationConfig> watchConfig() => _db.watchConfig();
}

// -----------------------------------------------------------------------------
// Devices
// -----------------------------------------------------------------------------
class MockDeviceRepository implements DeviceRepository {
  MockDeviceRepository(this._db);
  final MockDatabase _db;

  @override
  Future<List<KioskDevice>> getDevices() async {
    await _tick();
    return List.of(_db.devices);
  }

  @override
  Future<KioskDevice?> getDevice(String id) async {
    await _tick();
    for (final d in _db.devices) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  Future<KioskDevice> updateDevice(KioskDevice device) async {
    await _tick();
    final index = _db.devices.indexWhere((d) => d.id == device.id);
    if (index >= 0) {
      _db.devices[index] = device;
    } else {
      _db.devices.add(device);
    }
    return device;
  }

  @override
  Future<KioskDevice> setMaintenance(String id, {required bool enabled}) async {
    await _tick();
    final index = _db.devices.indexWhere((d) => d.id == id);
    if (index < 0) throw StateError('Device $id not found');
    _db.devices[index] = _db.devices[index].copyWith(maintenanceMode: enabled);
    return _db.devices[index];
  }
}

// -----------------------------------------------------------------------------
// Audit log
// -----------------------------------------------------------------------------
class MockAuditRepository implements AuditRepository {
  MockAuditRepository(this._db);
  final MockDatabase _db;

  @override
  Future<List<AuditLogEntry>> getEntries({int limit = 100}) async {
    await _tick();
    final sorted = List.of(_db.auditLog)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }

  @override
  Future<void> record(AuditLogEntry entry) async {
    await _tick();
    _db.auditLog.insert(0, entry);
  }
}
