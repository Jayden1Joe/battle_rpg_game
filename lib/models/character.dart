import 'package:battle_rpg_game/models/monster.dart';

class Character {
  String name;
  int health;
  int attack;
  int defense;
  int lastDamage = 0;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    //몬스터에게 공격을 가하여 피해를 입힙니다.
    monster.health -= attack;
  }

  void defend(Monster monster) {
    //방어 시 특정 행동을 수행합니다.
    //예) 대결 상대인 몬스터가 입힌 데미지만큼 캐릭터의 체력을 상승시킵니다.
    health += lastDamage;
  }

  void showStatus() {
    //캐릭터의 현재 체력과 공격력을 매 턴마다 출력합니다.
    print('$name - 체력 $health, 공격력 $attack, 방어력 $defense');
  }
}
