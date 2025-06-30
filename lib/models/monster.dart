import 'dart:math';

import 'package:battle_rpg_game/models/character.dart';

class Monster {
  String name;
  int health;
  int maxAttack;
  int defense = 0;

  Monster(this.name, this.health, this.maxAttack);

  void attackCharacter(Character character) {
    //몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
    //캐릭터에게 입히는 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값이며, 최소 데미지는 0 이상입니다.
    int attack = max(Random().nextInt(maxAttack + 1), character.defense);
    int damage = attack - character.defense;
    character.health -= damage;
    character.lastDamage = damage;
  }

  void showStatus() {
    //몬스터의 현재 체력과 공격력을 매 턴마다 출력합니다.
    print('$name - 체력: $health, 공격력: $maxAttack');
  }
}
