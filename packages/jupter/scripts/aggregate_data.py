# -*- coding: utf-8 -*-
"""
将订单发货记录、出入库记录和产品信息聚合成 demand_inventory 结构。
输出：Date, Product_ID, Demand, Inventory
若产品级别在产品表中不存在，则用 xxx 代替。
"""

import pandas as pd
from pathlib import Path

# 脚本所在目录
SCRIPT_DIR = Path(__file__).resolve().parent
# 数据目录
DATA_DIR = SCRIPT_DIR.parent / 'data'
# 输出文件
OUTPUT_FILE = DATA_DIR / '聚合数据.csv'

# 数据文件名
INBOUND_FILE = '烨辉油砂仓库入库记录_1773303249308.csv'
OUTBOUND_FILE = '烨辉油砂仓库正常发货出库记录_1773303193695.csv'
PRODUCT_FILE = '订单系统导出数据-产品级别管理(Product_ID)_1773301304089.csv'

# 未知产品占位
UNKNOWN_PRODUCT = 'xxx'


def _to_numeric(val):
    """转为数值，空值返回 None"""
    if pd.isna(val) or val == '':
        return None
    if isinstance(val, (int, float)):
        return float(val)
    s = str(val).strip()
    if not s:
        return None
    try:
        return float(s)
    except ValueError:
        return None


def _parse_date(val):
    """解析日期为 YYYY-MM-DD"""
    if pd.isna(val):
        return None
    d = pd.to_datetime(val, errors='coerce')
    return d.strftime('%Y-%m-%d') if pd.notna(d) else None


def build_product_mapping(df_product):
    """(级别名称, 厚度, 长度, 宽度) -> 级别编码"""
    mapping = {}
    for _, row in df_product.iterrows():
        name = str(row.get('级别名称', '')).strip()
        t = _to_numeric(row.get('厚度'))
        l_val = _to_numeric(row.get('长度'))
        w = _to_numeric(row.get('宽度'))
        code = str(row.get('级别编码', '')).strip()
        if not name or not code:
            continue
        key = (name, t, l_val, w)
        if key not in mapping:
            mapping[key] = code
    return mapping


def resolve_product_id(mapping, name, thickness, length, width):
    """根据级别名称和规格解析 Product_ID，不存在则返回 xxx"""
    t = _to_numeric(thickness)
    l_val = _to_numeric(length)
    w = _to_numeric(width)
    name = str(name).strip() if pd.notna(name) else ''
    if not name:
        return UNKNOWN_PRODUCT
    key = (name, t, l_val, w)
    if key in mapping:
        return mapping[key]
    return UNKNOWN_PRODUCT


def load_and_aggregate(encoding='utf-8-sig'):
    """
    加载数据并聚合。
    @param {str} encoding - CSV 编码
    @returns {pd.DataFrame} 聚合结果
    """
    # 1. 产品映射（级别编码保留字符串避免前导零丢失）
    product_path = DATA_DIR / PRODUCT_FILE
    df_product = pd.read_csv(
        product_path,
        encoding=encoding,
        dtype={'级别编码': str}
    )
    mapping = build_product_mapping(df_product)

    # 2. 入库记录
    inbound_path = DATA_DIR / INBOUND_FILE
    df_in = pd.read_csv(inbound_path, encoding=encoding)
    df_in['date'] = df_in['入库时间'].apply(_parse_date)
    df_in['qty'] = pd.to_numeric(df_in['出厂片数'], errors='coerce').fillna(0).astype(int)
    df_in['product_id'] = df_in.apply(
        lambda r: resolve_product_id(
            mapping, r.get('级别名称'), r.get('厚度'), r.get('长度'), r.get('宽度')
        ),
        axis=1
    )
    df_in = df_in[['date', 'product_id', 'qty']].dropna(subset=['date'])
    inbound = df_in.groupby(['date', 'product_id'])['qty'].sum().reset_index()
    inbound.columns = ['date', 'product_id', 'inbound']

    # 3. 出库记录（作为 Demand）
    outbound_path = DATA_DIR / OUTBOUND_FILE
    df_out = pd.read_csv(outbound_path, encoding=encoding)
    df_out['date'] = df_out['变动日期'].apply(_parse_date)
    df_out['qty'] = pd.to_numeric(df_out['出库量'], errors='coerce').fillna(0).astype(int)
    df_out['product_id'] = df_out.apply(
        lambda r: resolve_product_id(
            mapping, r.get('产品级别'), r.get('厚度'), r.get('长度'), r.get('宽度')
        ),
        axis=1
    )
    df_out = df_out[['date', 'product_id', 'qty']].dropna(subset=['date'])
    outbound = df_out.groupby(['date', 'product_id'])['qty'].sum().reset_index()
    outbound.columns = ['date', 'product_id', 'demand']

    # 4. 收集所有日期和产品
    all_dates = pd.concat([
        inbound['date'], outbound['date']
    ]).drop_duplicates().sort_values().reset_index(drop=True)
    all_products = pd.concat([
        inbound['product_id'], outbound['product_id']
    ]).drop_duplicates().reset_index(drop=True)

    if all_dates.empty:
        return pd.DataFrame(columns=['Date', 'Product_ID', 'Demand', 'Inventory'])

    date_range = pd.date_range(
        start=all_dates.min(), end=all_dates.max(), freq='D'
    ).strftime('%Y-%m-%d')

    # 5. 构建逐日入库/出库
    inbound_map = inbound.set_index(['date', 'product_id'])['inbound'].to_dict()
    outbound_map = outbound.set_index(['date', 'product_id'])['demand'].to_dict()

    rows = []
    for date in date_range:
        for pid in all_products:
            inc = inbound_map.get((date, pid), 0)
            out = outbound_map.get((date, pid), 0)
            rows.append({'date': date, 'product_id': pid, 'inbound': inc, 'demand': out})

    df_daily = pd.DataFrame(rows)

    # 6. 计算累计库存：按产品分组，按日期排序，cumsum(inbound - demand)
    df_sorted = df_daily.sort_values(['product_id', 'date'])
    df_sorted['net'] = df_sorted['inbound'] - df_sorted['demand']
    df_sorted['inventory'] = df_sorted.groupby('product_id')['net'].cumsum()

    # 7. 输出结构：Date, Product_ID, Demand, Inventory
    result = df_sorted[['date', 'product_id', 'demand', 'inventory']].copy()
    result.columns = ['Date', 'Product_ID', 'Demand', 'Inventory']
    result['Inventory'] = result['Inventory'].astype(int)
    result['Demand'] = result['Demand'].astype(int)
    result = result.sort_values(['Date', 'Product_ID']).reset_index(drop=True)

    return result


def main():
    """主入口"""
    if not DATA_DIR.exists():
        raise FileNotFoundError(f'数据目录不存在: {DATA_DIR}')
    for enc in ('utf-8-sig', 'utf-8', 'gbk'):
        try:
            result = load_and_aggregate(encoding=enc)
            break
        except UnicodeDecodeError:
            continue
    else:
        raise ValueError('无法使用 utf-8-sig/utf-8/gbk 解码 CSV')
    result.to_csv(OUTPUT_FILE, index=True, encoding='utf-8-sig')
    print(f'已输出: {OUTPUT_FILE}, 共 {len(result)} 行')


if __name__ == '__main__':
    main()
