import 'dart:math';

import 'package:battle_rpg_game/models/entity.dart';
import 'package:battle_rpg_game/models/monster.dart';

class Character extends Entity {
  int lastDamage = 0;
  bool hasUsedItem = false;
  bool isItemActive = false;
  int originalAttack;

  Character(super.name, super.health, super.attack, super.defense)
    : originalAttack = attack;

  @override
  void attackEntity(Entity target) {
    //몬스터에게 공격을 가하여 피해를 입힙니다.
    int damage = max(attack - target.defense, 0); // 최소 데미지는 0 이상
    target.health -= damage;
    print('${target.name}이(가) $name에게 $damage의 데미지를 입혔습니다!');
  }

  @override
  void showStatus() {
    //캐릭터의 현재 체력과 공격력을 매 턴마다 출력합니다.
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }

  void defend(Monster monster) {
    //방어 시 특정 행동을 수행합니다.
    //예) 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
    health += lastDamage;
    print('$name이(가) 방어 태세를 취하여 $lastDamage 만큼 체력을 얻었습니다.');
  }

  void useItem() {
    if (hasUsedItem) {
      print('❗ 이미 아이템을 사용했습니다.');
      return;
    }

    hasUsedItem = true;
    isItemActive = true;
    attack *= 2; // 공격력 두 배
    print('⚡ 아이템을 사용하여 공격력이 증가했습니다! 현재 공격력: $attack');
  }

  void resetAttack() {
    if (isItemActive) {
      attack = originalAttack;
      isItemActive = false;
      print('🌀 아이템 효과가 끝났습니다. 공격력이 원래대로 돌아옵니다.');
    }
  }
}
