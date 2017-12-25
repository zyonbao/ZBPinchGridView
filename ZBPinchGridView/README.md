
* 主要要求

1. 使用 UIView 进行绘制
2. 绘制 优化器时, 仅仅在宽高均>10的时候才绘制文字
3. 绘制优化器的具体内容最好交由 datasource 给出
4. 绘制内容(选中\非选中\不可用)均从数据源获取
4. pinch 操作仅缩放, 不考虑位移操作
5. 缩放绘制是否需要遍历所有 position 数组?
6. pinch 操作过程中, 控制 indexView 中的数字随之缩放,但 indexView 的背景大小不变.
7. pinch 结束后, 能否做到动画回弹到原来大小
8. 设置一个 innerBounds

- View
--DefaultLayer 默认的 Layer 用于处理缩放和回弹事件
---ContentLayer 用来处理缩放和滑动事件, 超出的部分交给 DefaultLayer 来对 ContentLayer 进行缩放和超出处理
// 并不可行

* 主要难点

1. Pinch 后 innerBounds 与 scale 的判断
2. Pinch 结束后归位动画的计算
3. 根据当前的 innerBounds 与 currentScale 计算 indexRect 与 itemsRect
4. 位移结束之后的动画回弹
