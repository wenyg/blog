## launch

```xml
<node name="example_node" pkg="example_pkg" type="example_node.py">
    <remap from="/original_topic" to="/new_topic"/>
</node>
```

remap 可以重新映射 topic， 比如 example_node.py 订阅的 topic 是 `/original_topic` 可以通过上面的映射把他改成实际是定于的 `/new_topic` 