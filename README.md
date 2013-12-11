VN_API
======

仮想ネットワーク＋API

ルーティングスイッチ使用法
------

```shell
$ trema run ./routing-switch.rb -c triangle.conf
```
(以下、別ターミナルで)

```shell
$ trema kill 0x1  # スイッチ 0x1 を落とす
$ trema up 0x1  # 落としたスイッチ 0x1 をふたたび起動
$ trema port_down --switch 0x1 --port 1  # スイッチ 0x1 のポート 1 を落とす
$ trema port_up --switch 0x1 --port 1  # 落としたポートを上げる
```

graphviz でトポロジ画像を出す:

```shell
$ trema run "./routing-switch.rb graphviz /tmp/topology.png" -c fullmesh.conf
```

