package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.*;
import org.dzu.system.mapper.GoodsOrderMapper;
import org.dzu.system.mapper.OrderDetailMapper;
import org.dzu.system.mapper.OrderdetailBackMapper;
import org.dzu.system.service.ICompanyService;
import org.dzu.system.service.IExWarehouseService;
import org.dzu.system.service.IInventoryService;
import org.dzu.system.service.IOrderDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 订单详情Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderDetailServiceImpl implements IOrderDetailService {
    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private ICompanyService companyService;

    @Autowired
    private IInventoryService inventoryService;

    @Autowired
    private IExWarehouseService exWarehouseService;

    @Autowired
    private OrderdetailBackMapper orderdetailBackMapper;

    @Autowired
    private GoodsOrderMapper goodsOrderMapper;

    /**
     * 查询订单详情
     *
     * @param id 订单详情主键
     * @return 订单详情
     */
    @Override
    public OrderDetail selectOrderDetailById(Long id) {
        return orderDetailMapper.selectOrderDetailById(id);
    }

    /**
     * 查询订单详情列表
     *
     * @param orderDetail 订单详情
     * @return 订单详情
     */
    @Override
    public List<OrderDetail> selectOrderDetailList(OrderDetail orderDetail) {
        return orderDetailMapper.selectOrderDetailList(orderDetail);
    }

    /**
     * 新增订单详情
     *
     * @param orderDetail 订单详情
     * @return 结果
     */
    @Override
    public int insertOrderDetail(OrderDetail orderDetail) {
        preInsert(orderDetail);
        return orderDetailMapper.insertOrderDetail(orderDetail);
    }

    @Override
    public void preInsert(OrderDetail orderDetail) {
        // 对于需要插插入的信息进行一些校验或者填补

        // 补充一些基本的数据
        orderDetail.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderDetail.setUserId(SecurityUtils.getUserId());
        orderDetail.setUserName(SecurityUtils.getUserTruename());
        orderDetail.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        // 插入肯定不是修改，所以不是调整
        orderDetail.setIsAdjusted(YesOrNoConstants.NO_zh);
        orderDetail.setAdjustDate(null);

        // 准备校验

        // 两者不能同时为null
        if (StringUtils.isNull(orderDetail.getSupplierID()) && StringUtils.isNull(orderDetail.getStoreID())) {
            throw new ServiceException("供应商和仓库不能同时为空，请检查后重试");
        }
        // 两者也不能同时不为null
        if (StringUtils.isNotNull(orderDetail.getSupplierID()) && StringUtils.isNotNull(orderDetail.getStoreID())) {
            throw new ServiceException("供应商和仓库不能同时不为空，请检查后重试");
        }

        // 先校验仓库和供应商是否存在，不存在就没法确定后期拨款
        if (StringUtils.isNotNull(orderDetail.getSupplierID())) {
            Company supplier = companyService.selectCompanyById(orderDetail.getSupplierID());
            if (supplier == null) {
                throw new ServiceException("获取供应商信息异常，请刷新页面后重试");
            }
        }
        if (StringUtils.isNotNull(orderDetail.getStoreID())) {
            Inventory inventory = inventoryService.selectInventoryById(orderDetail.getStoreID());
            if (inventory == null) {
                throw new ServiceException("获取对应仓库的存货信息异常，请刷新页面后重试");
            } else {
                // 存货二次判断+联动修改
                if (inventory.getStockNumber() > 0 && orderDetail.getPieces() <= inventory.getStockNumber()) {
                    // 仓库存货足够
                    exWarehouseService.InventoryToEx(orderDetail.getStoreID(), orderDetail.getPieces(), orderDetail.getOrdersNo(), orderDetail.getAddtime());
                } else {
                    throw new ServiceException("仓库存货不足，请检查后重试");
                }
            }
        }
    }


    /**
     * 修改订单详情
     *
     * @param orderDetail 订单详情
     * @return 结果
     */
    @Override
    public int updateOrderDetail(OrderDetail orderDetail) {
        orderDetail.setUserId(SecurityUtils.getUserId());
        orderDetail.setUserName(SecurityUtils.getUserTruename());
        orderDetail.setUpdateTime(DateUtils.getNowDate());
        return orderDetailMapper.updateOrderDetail(orderDetail);
    }

    /**
     * 批量删除订单详情
     *
     * @param ids 需要删除的订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderDetailByIds(Long[] ids) {
        return orderDetailMapper.deleteOrderDetailByIds(ids);
    }

    /**
     * 删除订单详情信息
     *
     * @param id 订单详情主键
     * @return 结果
     */
    @Override
    public int deleteOrderDetailById(Long id) {
        return orderDetailMapper.deleteOrderDetailById(id);
    }

    @Override
    public void backupOrderDetail(String ordersNo) {
        orderDetailMapper.backupOrderDetail(ordersNo);
        QueryWrapper<OrderdetailBack> query = new QueryWrapper<>();
        query.eq("ordersNo", ordersNo);

        // 获取本次修改的人
        OrderdetailBack updateInfo = new OrderdetailBack();
        updateInfo.setUserId(SecurityUtils.getUserId());
        updateInfo.setUserName(SecurityUtils.getUserTruename());
        updateInfo.setUpdateTime(DateUtils.getNowDate());
        orderdetailBackMapper.update(updateInfo, query);

    }

    @Override
    public void adjustOrderDetail(String ordersNo) {
        // 设置属性为调整
        OrderDetail update = new OrderDetail();
        update.setAdjustDate(DateUtils.getNowDate().toString());
        update.setIsAdjusted(YesOrNoConstants.YES_zh);
        QueryWrapper<OrderDetail> query = new QueryWrapper<OrderDetail>().eq("ordersNo", ordersNo).eq("cancelFlag", DelConstants.NODEL);
        orderDetailMapper.update(update, query);
    }

    @Override
    public void deleteOrderDetailByOrderId(GoodsOrder goodsOrder) {

        // 如果是仓库出货，需要联动删除出库信息
        exWarehouseService.deleteExWarehouseByOrderNo(goodsOrder.getOrdersNo());

        goodsOrderMapper.deleteOrderDetailByOrderId(goodsOrder.getId());
    }
}
