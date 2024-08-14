## 简单工厂

```cpp
#include <memory>

// 抽象产品
class Ball {
  public:
    virtual void show(){};
};

// 具体产品
class BasketBall : public Ball {};
class FootBall: public Ball {};

// 工厂
class Factory{
  public:
    std::shared_ptr<Ball> getBall(const std::string &name){
      if (name == "BasketBall"){
        return std::make_shared<BasketBall>();
      } else if (name == "FootBall"){
        return std::make_shared<FootBall>();
      }
      return {};
    }
};
```

简单工厂的使用方法

```cpp
int main(int argc, char **argv){
  Factory factory;
  auto ball1 = factory.getBall("BasketBall");
  auto ball2 = factory.getBall("FootBall");
}
```

简单工厂就是利用一个参数就可以通过工厂获取对应的产品。很显然，每次新增产品就要修改工厂代码。


## 工厂方法

```cpp
#include <memory>

// 抽象产品
class Ball {
  public:
    virtual void show(){};
};
// 抽象工厂
class Facotry {
  public:
    virtual std::shared_ptr<Ball> getBall() { return {};};
};

// 具体产品及其工厂
class BasketBall : public Ball {};
class FootBall: public Ball {};
class BasketBallFacotry: public Facotry {
  public:
    virtual std::shared_ptr<Ball> getBall() { 
      return std::make_shared<BasketBall>();
    };
};
class FootBallFacotry: public Facotry {
  public:
    virtual std::shared_ptr<Ball> getBall() { 
      return std::make_shared<FootBall>();
    };
};
```

使用方法

```cpp
int main(int argc, char **argv){
  std::Factory f1 = BasketBallFacotry();
  auto f2 = FootBallFacotry();
  auto ball1 = f1.getBall();
  auto ball2 = f2.getBall();
}
```

与简单工厂的区别是工厂方法获取的是



