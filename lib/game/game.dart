import 'dart:math';

import 'package:battle_rpg_game/models/character.dart';
import 'package:battle_rpg_game/models/monster.dart';

class Game {
  Character character;
  List<Monster> monsters;
  int monstersDefeated = 0;

  Game(this.character, this.monsters);

  void startGame() {
    // 캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
    //몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
    //예) “다음 몬스터와 대결하시겠습니까? (y/n)”
    //설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.

    battle();
  }

  void battle() {
    //- 게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
    // 예) 공격하기(1), 방어하기(2)
    // - 매 턴마다 몬스터는 사용자에게 공격만 가합니다.
    // - 캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
    // - 처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
    // - 캐릭터의 체력은 대결 **간에 누적**됩니다.

    getRandomMonster();
  }

  Monster getRandomMonster() {
    //Random() 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
    Monster randomMonster = monsters[Random().nextInt(monsters.length)];
    return randomMonster;
  }
}
