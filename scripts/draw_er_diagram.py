# -*- coding: utf-8 -*-
"""
Chen 风格 ER 图绘制脚本：订单 + 库存核心模块。
- 实体：矩形（不带属性）
- 关系：菱形
- 连线：直线，标注基数 (1 / n / m)
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Polygon
from matplotlib import rcParams

rcParams["font.sans-serif"] = ["PingFang HK", "Heiti TC", "STHeiti", "Arial Unicode MS"]
rcParams["axes.unicode_minus"] = False

# 画布尺寸
FIG_W, FIG_H = 18, 10.5
fig, ax = plt.subplots(figsize=(FIG_W, FIG_H))
ax.set_xlim(0, FIG_W)
ax.set_ylim(0, FIG_H)
ax.set_aspect("equal")
ax.axis("off")

ENTITY_W, ENTITY_H = 2.6, 1.0
REL_W, REL_H = 2.2, 1.05
LW = 1.6
FONT_ENTITY = 14
FONT_REL = 13
FONT_CARD = 13


def draw_entity(cx, cy, text):
    """绘制实体矩形（无填充）。"""
    x = cx - ENTITY_W / 2
    y = cy - ENTITY_H / 2
    ax.add_patch(Rectangle((x, y), ENTITY_W, ENTITY_H,
                           fill=False, edgecolor="black", linewidth=LW, zorder=3))
    ax.text(cx, cy, text, ha="center", va="center",
            fontsize=FONT_ENTITY, zorder=4)
    return cx, cy


def draw_relation(cx, cy, text):
    """绘制关系菱形（无填充）。"""
    pts = [(cx, cy + REL_H / 2), (cx + REL_W / 2, cy),
           (cx, cy - REL_H / 2), (cx - REL_W / 2, cy)]
    ax.add_patch(Polygon(pts, closed=True, fill=False,
                         edgecolor="black", linewidth=LW, zorder=3))
    ax.text(cx, cy, text, ha="center", va="center",
            fontsize=FONT_REL, zorder=4)
    return cx, cy


def edge_point(shape_center, shape_kind, target):
    """根据图形类型返回图形边缘与目标方向的连接点。"""
    cx, cy = shape_center
    tx, ty = target
    dx, dy = tx - cx, ty - cy
    if dx == 0 and dy == 0:
        return cx, cy
    if shape_kind == "rect":
        hw, hh = ENTITY_W / 2, ENTITY_H / 2
        if dx == 0:
            return cx, cy + (hh if dy > 0 else -hh)
        if dy == 0:
            return cx + (hw if dx > 0 else -hw), cy
        # 同时按 x、y 截断，取最近的边
        sx = hw / abs(dx)
        sy = hh / abs(dy)
        s = min(sx, sy)
        return cx + dx * s, cy + dy * s
    # 菱形
    hw, hh = REL_W / 2, REL_H / 2
    if dx == 0:
        return cx, cy + (hh if dy > 0 else -hh)
    if dy == 0:
        return cx + (hw if dx > 0 else -hw), cy
    # 菱形边方程 |x|/hw + |y|/hh = 1
    s = 1.0 / (abs(dx) / hw + abs(dy) / hh)
    return cx + dx * s, cy + dy * s


def connect(a_center, a_kind, b_center, b_kind, label_a="", label_b="",
            label_offset=0.28):
    """连接两个图形并在两端标注基数。"""
    p1 = edge_point(a_center, a_kind, b_center)
    p2 = edge_point(b_center, b_kind, a_center)
    ax.plot([p1[0], p2[0]], [p1[1], p2[1]],
            color="black", linewidth=LW, zorder=2)

    # 在线段两端附近标基数（往内侧靠一点）
    import math
    dx, dy = p2[0] - p1[0], p2[1] - p1[1]
    dist = math.hypot(dx, dy) or 1
    ux, uy = dx / dist, dy / dist
    # 法向量（放标签时往侧边推）
    nx, ny = -uy, ux

    # 标签位置：距离端点 0.35，往法向偏 label_offset
    pad = 0.35
    if label_a:
        lx = p1[0] + ux * pad + nx * label_offset
        ly = p1[1] + uy * pad + ny * label_offset
        ax.text(lx, ly, label_a, ha="center", va="center",
                fontsize=FONT_CARD, zorder=5)
    if label_b:
        lx = p2[0] - ux * pad + nx * label_offset
        ly = p2[1] - uy * pad + ny * label_offset
        ax.text(lx, ly, label_b, ha="center", va="center",
                fontsize=FONT_CARD, zorder=5)


# === 实体坐标 ===
E_COMPANY      = (2.0, 8.6)    # 往来主体
E_ORDER        = (8.0, 9.2)    # 订单主表
E_STORE        = (15.5, 9.2)   # 仓库
E_ODETAIL      = (8.0, 5.5)    # 订单明细
E_INMAIN       = (15.5, 5.5)   # 入库主表
E_LEVEL        = (2.0, 1.4)    # 产品级别
E_INVDETAIL    = (10.5, 1.4)   # 库存明细
E_OUT          = (16.0, 1.4)   # 出库记录

# === 关系坐标 ===
R_PLACE   = (5.0, 8.9)    # 下单：往来主体 ↔ 订单主表
R_CONTAIN = (8.0, 7.35)   # 包含：订单主表 ↔ 订单明细
R_SUPPLY  = (5.0, 5.5)    # 供货：往来主体 ↔ 订单明细
R_SPEC    = (5.0, 3.5)    # 规格：产品级别 ↔ 订单明细
R_DEFINE  = (6.25, 1.4)   # 定义：产品级别 ↔ 库存明细
R_BELONG  = (15.5, 7.35)  # 隶属：仓库 ↔ 入库主表
R_DETAIL  = (13.0, 3.45)  # 明细：入库主表 ↔ 库存明细
R_OUTBND  = (13.25, 1.4)  # 出库：库存明细 ↔ 出库记录

# === 绘制实体 ===
draw_entity(*E_COMPANY,   "往来主体")
draw_entity(*E_ORDER,     "订单主表")
draw_entity(*E_STORE,     "仓库")
draw_entity(*E_ODETAIL,   "订单明细")
draw_entity(*E_INMAIN,    "入库主表")
draw_entity(*E_LEVEL,     "产品级别")
draw_entity(*E_INVDETAIL, "库存明细")
draw_entity(*E_OUT,       "出库记录")

# === 绘制关系 ===
draw_relation(*R_PLACE,   "下单")
draw_relation(*R_CONTAIN, "包含")
draw_relation(*R_SUPPLY,  "供货")
draw_relation(*R_SPEC,    "规格")
draw_relation(*R_DEFINE,  "定义")
draw_relation(*R_BELONG,  "隶属")
draw_relation(*R_DETAIL,  "明细")
draw_relation(*R_OUTBND,  "出库")

# === 连线（端点写基数）===
# 下单：往来主体(1) — (n)订单主表
connect(E_COMPANY, "rect", R_PLACE, "rel", "1", "")
connect(R_PLACE,   "rel",  E_ORDER, "rect", "", "n")

# 包含：订单主表(1) — (n)订单明细
connect(E_ORDER,    "rect", R_CONTAIN, "rel", "1", "")
connect(R_CONTAIN,  "rel",  E_ODETAIL, "rect", "", "n")

# 供货：往来主体(1) — (n)订单明细
connect(E_COMPANY,  "rect", R_SUPPLY, "rel", "1", "")
connect(R_SUPPLY,   "rel",  E_ODETAIL, "rect", "", "n")

# 规格：产品级别(1) — (n)订单明细
connect(E_LEVEL,    "rect", R_SPEC, "rel", "1", "")
connect(R_SPEC,     "rel",  E_ODETAIL, "rect", "", "n")

# 定义：产品级别(1) — (n)库存明细
connect(E_LEVEL,    "rect", R_DEFINE, "rel", "1", "")
connect(R_DEFINE,   "rel",  E_INVDETAIL, "rect", "", "n")

# 隶属：仓库(1) — (n)入库主表
connect(E_STORE,    "rect", R_BELONG, "rel", "1", "")
connect(R_BELONG,   "rel",  E_INMAIN, "rect", "", "n")

# 明细：入库主表(1) — (n)库存明细
connect(E_INMAIN,   "rect", R_DETAIL, "rel", "1", "")
connect(R_DETAIL,   "rel",  E_INVDETAIL, "rect", "", "n")

# 出库：库存明细(1) — (n)出库记录
connect(E_INVDETAIL, "rect", R_OUTBND, "rel", "1", "")
connect(R_OUTBND,    "rel",  E_OUT, "rect", "", "n")

plt.tight_layout(pad=0.5)
out_path = "/Users/zhangming/Code/Projects/order-system-ui/订单库存ER图.png"
plt.savefig(out_path, dpi=200, bbox_inches="tight", facecolor="white")
print(f"saved: {out_path}")
