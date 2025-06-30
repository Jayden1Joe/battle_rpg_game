import 'dart:math';

import 'dart:io';

import 'package:battle_rpg_game/models/character.dart';
import 'package:battle_rpg_game/models/monster.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];
  int monstersDefeated = 0;

  Game();

  void loadCharacterStats() {
    try {
      final file = File('data/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      String name = getCharacterName();
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void loadMonsterStats() {
    try {
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
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
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
    loadCharacterStats();
    loadMonsterStats();
    print('게임을 시작합니다!');
    character.showStatus();
    print('');
    battle();
  }

  void battle() {
    //- 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
    // 예) 공격하기(1), 방어하기(2)
    // - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
    // - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
    // - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
    // - 캐릭터의 체력은 대결 **간에 누적**됩니다.
    print('새로운 몬스터가 나타났습니다!');
    Monster monster = getRandomMonster();
    monster.showStatus();
    while (monster.health > 0) {
      bool turn = true; // 캐릭터의 턴
      if (turn) {
        print('${character.name}의 턴');
        stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
        String? choice;
        do {
          choice = stdin.readLineSync();
          if (choice == null || (choice != '1' && choice != '2')) {
            print('잘못된 입력입니다. 1 또는 2를 입력해주세요.');
          }
        } while (choice == null || (choice != '1' && choice != '2'));
        if (choice == '1') {
          // 공격하기
          character.attackMonster(monster);
          print(
            '${character.name}이(가) ${monster.name}에게 ${character.attack}의 데미지를 입혔습니다!',
          );
        } else if (choice == '2') {
          // 방어하기
          character.defend(monster);
          print(
            '${character.name}이(가) 방어 태세를 취하여 ${character.lastDamage} 만큼 체력을 얻었습니다.',
          );
        }
        print('');
      }
    }
  }

  Monster getRandomMonster() {
    //Random() 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
    Monster randomMonster = monsters[Random().nextInt(monsters.length)];
    return randomMonster;
  }
}
