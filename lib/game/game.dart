import 'dart:math';

import 'dart:io';

import 'package:battle_rpg_game/models/character.dart';
import 'package:battle_rpg_game/models/monster.dart';
import 'package:battle_rpg_game/utils/route_validated_input.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];
  int monstersDefeated = 0;

  Game();

  void loadCharacterStats() {
    final file = File('data/characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    String name = getCharacterName();
    character = Character(name, health, attack, defense);
  }

  void loadMonsterStats() {
    final file = File('data/monsters.txt');
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final stats = line.split(',');
      if (stats.length != 3) {
        throw FormatException('Invalid monster data: $line');
      }
      String name = stats[0];
      int health = int.parse(stats[1]);
      int attack = int.parse(stats[2]);

      monsters.add(Monster(name, health, attack));
    }
  }

  String getCharacterName() {
    final validNameRegExp = RegExp(r'^[가-힣a-zA-Z]+$'); // 한글, 영문 대소문자만 허용

    do {
      stdout.write('캐릭터의 이름을 입력하세요: ');
      String? name = stdin.readLineSync();

      if (name == null || name.isEmpty) {
        print('이름은 비워둘 수 없습니다. 다시 입력해주세요.');
        continue;
      }
      if (!validNameRegExp.hasMatch(name)) {
        print('이름에는 한글 또는 영문 대소문자만 포함될 수 있습니다. 특수문자나 숫자는 사용할 수 없습니다.');
        continue;
      }
      return name;
    } while (true);
  }

  void startGame() {
    // 캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
    //몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
    //예) “다음 몬스터와 대결하시겠습니까? (y/n)”
    //설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.
    try {
      loadCharacterStats();
      loadMonsterStats();
      print('게임을 시작합니다!');
      applyBonusHealth(character);
      character.showStatus();
      battle();
    } on FileSystemException catch (e) {
      print('📁 파일을 찾을 수 없거나 읽는 데 실패했습니다: ${e.message}');
    } on FormatException catch (e) {
      print('❌ 데이터 형식이 잘못되었습니다: ${e.message}');
    } catch (e) {
      print('⚠️ 알 수 없는 에러 발생: $e');
    }
  }

  void applyBonusHealth(Character character) {
    final random = Random();
    final chance = random.nextDouble(); // 0.0 ~ 1.0 사이의 랜덤 실수

    if (chance < 0.3) {
      // 30% 확률
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  void battle() {
    //- 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
    // 예) 공격하기(1), 방어하기(2)
    // - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
    // - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
    // - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
    // - 캐릭터의 체력은 대결 **간에 누적**됩니다.
    print('');
    print('새로운 몬스터가 나타났습니다!');
    Monster monster = getRandomMonster();
    monster.showStatus();
    bool turn = true; // 캐릭터의 턴
    while (monster.health > 0 && character.health > 0) {
      print('');
      if (turn) {
        print('${character.name}의 턴');
        routeValidatedInput(
          prompt: '행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용): ',
          actions: {
            '1': () => character.attackEntity(monster),
            '2': () => character.defend(monster),
            '3': () {
              character.useItem(); // 아이템 사용
              turn = true;
              return 'REPEAT'; // 아이템 사용 후 다시 턴을 캐릭터로 유지
            },
          },
        );
        character.resetAttack();
        turn = false; // 턴을 몬스터로 변경
        continue;
      } else {
        // 몬스터의 턴
        print('${monster.name}의 턴');
        monster.increaseDefensePerTurn(); // 몬스터의 방어력 증가
        monster.attackEntity(character);
        character.showStatus();
        monster.showStatus();
        turn = true; // 턴을 캐릭터로 변경
      }
    }
    print('');
    if (character.health <= 0) {
      print('${character.name}이(가) 쓰러졌습니다! 게임 오버!');
      saveResult(false);
    }
    print('${monster.name}을(를) 물리쳤습니다!');
    monstersDefeated++;
    monsters.remove(monster); // 몬스터 리스트에서 제거
    if (monsters.isEmpty) {
      print('모든 몬스터를 물리쳤습니다! 게임에서 승리했습니다!');
      saveResult(true);
    } else {
      nextBattle();
    }
  }

  void nextBattle() {
    routeValidatedInput(
      prompt: '다음 몬스터와 대결하시겠습니까? (y/n): ',
      preprocess: (input) => input.toLowerCase(),
      actions: {
        'y': () {
          print('다음 몬스터와 대결을 시작합니다!');
          battle(); // 다음 몬스터와 대결
        },
        'n': () {
          print('게임을 종료합니다. 물리친 몬스터 수: $monstersDefeated');
          saveResult(false);
        },
      },
    );
  }

  void saveResult(bool isWin) {
    routeValidatedInput(
      prompt: '결과를 저장하시겠습니까? (y/n): ',
      preprocess: (input) => input.toLowerCase(),
      actions: {
        'y': () {
          final result =
              '${character.name}, ${character.health}, ${isWin ? '승리' : '패배'}\n';
          final file = File('data/result.txt');
          file.writeAsStringSync(result, mode: FileMode.append);
          print('결과가 result.txt 파일에 저장되었습니다.');
        },
        'n': () {
          print('결과 저장을 취소했습니다.');
        },
      },
    );
    exit(0);
  }

  Monster getRandomMonster() {
    //Random() 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
    Monster randomMonster = monsters[Random().nextInt(monsters.length)];
    return randomMonster;
  }
}
