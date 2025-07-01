import 'dart:math';

import 'package:battle_rpg_game/models/character.dart';
import 'package:battle_rpg_game/models/entity.dart';

class Monster extends Entity {
  Monster(String name, int health, int attack) : super(name, health, attack, 0);
  int defenseTurnCounter = 0;

  @override
  void attackEntity(Entity character) {
    //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
    //캐릭터에게 입히는 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값이며, 최소 데미지는 0 이상입니다.
    int randomAttack = max(Random().nextInt(attack + 1), character.defense);
    int damage = randomAttack - character.defense;
    character.health -= damage;
    if (character is Character) {
      character.lastDamage = damage;
    }
    print('${name}이(가) ${character.name}에게 ${damage}의 데미지를 입혔습니다!');
  }

  @override
  void showStatus() {
    //몬스터의 현재 체력과 공격력을 매 턴마다 출력합니다.
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }

  void increaseDefensePerTurn() {
    defenseTurnCounter++;
    if (defenseTurnCounter == 3) {
      defense += 2;
      defenseTurnCounter = 0;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }
}
