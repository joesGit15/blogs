### Item Opacity

使用ItemDoesntPropagateOpacityToChildren和ItemIgnoresParentOpacity最好父亲和孩子配套使用;

```cpp
parentItem = //new parent tiem;
parentItem->setFlag(QGraphicsItem::ItemDoesntPropagateOpacityToChildren);
parentItem->setOpacity(0);

for(/** some code */){
    GraphicsRectItem *item = scene->addCustomizeRect(rect,parentItem);
    item->setFlag(QGraphicsItem::ItemIgnoresParentOpacity);
}
```

---

