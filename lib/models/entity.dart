abstract class Entity {
  String name;
  int health;
  int attack;
  int defense;

  Entity(this.name, this.health, this.attack, this.defense);

  void attackEntity(Entity target) {}

  void showStatus() {}
}
