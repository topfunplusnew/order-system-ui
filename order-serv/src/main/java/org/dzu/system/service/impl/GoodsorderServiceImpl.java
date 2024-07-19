package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.uuid.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import org.dzu.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import org.dzu.system.domain.Orderdetail;
import org.dzu.system.mapper.GoodsorderMapper;
import org.dzu.system.domain.Goodsorder;
import org.dzu.system.service.IGoodsorderService;

/**
 * 订单Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class GoodsorderServiceImpl implements IGoodsorderService 
{
    @Autowired
    private GoodsorderMapper goodsorderMapper;

    /**
     * 查询订单
     * 
     * @param id 订单主键
     * @return 订单
     */
    @Override
    public Goodsorder selectGoodsorderById(Long id)
    {
        return goodsorderMapper.selectGoodsorderById(id);
    }

    /**
     * 查询订单列表
     * 
     * @param goodsorder 订单
     * @return 订单
     */
    @Override
    public List<Goodsorder> selectGoodsorderList(Goodsorder goodsorder)
    {
        return goodsorderMapper.selectGoodsorderList(goodsorder);
    }

    /**
     * 新增订单
     * 
     * @param goodsorder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int insertGoodsorder(Goodsorder goodsorder)
    {
        goodsorder.setOrdersNo(UUID.fastUUID().toString());
        //TODO 毛磊： 此处考虑UUID可能重复问题，解决：数据库唯一索引，此处添加捕获重试机制
        int rows = goodsorderMapper.insertGoodsorder(goodsorder);
        insertOrderdetail(goodsorder);
        return rows;
    }

    /**
     * 修改订单
     * 
     * @param goodsorder 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int updateGoodsorder(Goodsorder goodsorder)
    {
        goodsorder.setUpdateTime(DateUtils.getNowDate());
        goodsorderMapper.deleteOrderdetailByOrdersNo(goodsorder.getId());
        insertOrderdetail(goodsorder);
        return goodsorderMapper.updateGoodsorder(goodsorder);
    }

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsorderByIds(Long[] ids)
    {
        goodsorderMapper.deleteOrderdetailByOrdersNos(ids);
        return goodsorderMapper.deleteGoodsorderByIds(ids);
    }

    /**
     * 删除订单信息
     * 
     * @param id 订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodsorderById(Long id)
    {
        goodsorderMapper.deleteOrderdetailByOrdersNo(id);
        return goodsorderMapper.deleteGoodsorderById(id);
    }

    /**
     * 新增订单详情信息
     * 
     * @param goodsorder 订单对象
     */
    public void insertOrderdetail(Goodsorder goodsorder)
    {
        List<Orderdetail> orderdetailList = goodsorder.getOrderdetailList();
        String ordersNo = goodsorder.getOrdersNo();
        if (StringUtils.isNotNull(orderdetailList))
        {
            List<Orderdetail> list = new ArrayList<Orderdetail>();
            for (Orderdetail orderdetail : orderdetailList)
            {
                orderdetail.setOrdersNo(ordersNo);
                list.add(orderdetail);
            }
            if (list.size() > 0)
            {
                goodsorderMapper.batchOrderdetail(list);
            }
        }
    }
}
