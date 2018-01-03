# ZBPinchGridView

## TODO

\- ZBPinchGridView
 
-- CAShapLayer 作为 ContentLayer, Size 与 ContentSize 一样大. 用来平铺 ZBGridlayer
    
---- ZBGridLayer 继承自 CALayer 作为单元格表单的 Layer
    
    > 属性列表:
    >  *row* //当前 Layer 所在的行数
    > *column* // 当前 Layer 所在的列数
    > *parentScale* // 父控件当前的缩放程度(缩放可以交由 contentLayer 
    来完成, 但不同层级的缩放针对不同层级的显示, 则需要集中对 parentScale 
    进行单独的绘制处理).
(针对不同的状态所显示的背景可以考虑使用不同的 backgroundLayer 来完成, 毕竟可以直接复用.)

平移只需要平移 CAShapLayer
缩放的时候缩放 CAShapLayer 即可, 并不需要重新配置.
