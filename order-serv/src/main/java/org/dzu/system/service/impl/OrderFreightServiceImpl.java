package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.BankChangeConstant;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.constant.OrderFreightPaymentConstants;
import org.dzu.common.constant.YesOrNoConstants;
import org.dzu.common.enums.TableName;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.*;
import org.dzu.system.mapper.BankAccountChangeMapper;
import org.dzu.system.mapper.OrderFreightMapper;
import org.dzu.system.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

/**
 * 订单运费Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OrderFreightServiceImpl implements IOrderFreightService {
    @Autowired
    private OrderFreightMapper orderFreightMapper;

    @Autowired
    private IBankAccountChangeService bankAccountChangeService;

    @Autowired
    private IBankAccountService bankAccountService;

    @Autowired
    private ICarsService carsService;

    @Autowired
    private IGoodsOrderService goodsOrderService;

    @Autowired
    private BankAccountChangeMapper bankAccountChangeMapper;

    /**
     * 查询订单运费
     *
     * @param id 订单运费主键
     * @return 订单运费
     */
    @Override
    public OrderFreight selectOrderFreightById(Long id) {
        return orderFreightMapper.selectOrderFreightById(id);
    }

    /**
     * 查询订单运费列表
     *
     * @param orderFreight 订单运费
     * @return 订单运费
     */
    @Override
    public List<OrderFreight> selectOrderFreightList(OrderFreight orderFreight) {
        return orderFreightMapper.selectOrderFreightList(orderFreight);
    }

    /**
     * 新增订单运费
     *
     * @param orderFreight 订单运费
     * @return 结果
     */
    @Override
    public int insertOrderFreight(OrderFreight orderFreight) {
        // 设置基础信息
        orderFreight.setAddtime(String.valueOf(DateUtils.getNowDate()));
        orderFreight.setUserId(SecurityUtils.getUserId());
        orderFreight.setUserName(SecurityUtils.getUserTruename());
        orderFreight.setCancelFlag(Long.valueOf(DelConstants.NODEL));
        // 新增加的运费一定还没申请，所以状态是未申请
        orderFreight.setPaymentState(OrderFreightPaymentConstants.PAYMENT_STATUS_UNPAID);
        // 新添加的一定允许编辑
        orderFreight.setIsedit(Long.valueOf(YesOrNoConstants.YES_num));


        // 校验依赖的其他表是否存在
        ValidateOtherTable(orderFreight);

        // 插入运费信息
        return orderFreightMapper.insertOrderFreight(orderFreight);
    }

    /**
     * 修改订单运费
     *
     * @param orderFreight 订单运费
     * @return 结果
     */
    @Override
    public int updateOrderFreight(OrderFreight orderFreight) {
        // 设置基础信息
        orderFreight.setUserId(SecurityUtils.getUserId());
        orderFreight.setUserName(SecurityUtils.getUserTruename());

        // 搜索老信息
        OrderFreight old = orderFreightMapper.selectOrderFreightById(orderFreight.getId());
        // 如果老信息允许编辑为否，那么就不允许编辑
        if (old.getIsedit() == YesOrNoConstants.NO_num) {
            throw new ServiceException("该运费信息不允许编辑");
        }


        // 校验依赖的其他表是否存在
        ValidateOtherTable(orderFreight);
        return orderFreightMapper.updateOrderFreight(orderFreight);
    }




    /**
     * 批量删除订单运费
     *
     * @param ids 需要删除的订单运费主键
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE,rollbackFor = Exception.class)
    public int deleteOrderFreightByIds(Long[] ids) {
        // 搜索所有的订单
        List<OrderFreight> orderFreights = orderFreightMapper.selectBatchIds(Arrays.asList(ids));
        if(orderFreights.size() != ids.length){
            throw new ServiceException("删除的信息不存在,请刷新页面后重试");
        }
        // 检查是否有不允许删除的
        for (OrderFreight orderFreight : orderFreights) {
            if (orderFreight.getIsedit() == YesOrNoConstants.NO_num) {
                throw new ServiceException("存在不允许删除的运费信息");
            }
        }

        return orderFreightMapper.deleteOrderFreightByIds(ids);
    }


    /**
     * 验证依赖的其他表是否存在
     *
     * @param orderFreight
     */
    private void ValidateOtherTable(OrderFreight orderFreight) {
        // 验证订单编号对应的订单是否存在
        GoodsOrder goodsOrder = goodsOrderService.selectGoodsOrderByOrderNO(orderFreight.getOrdersNo());

        if (StringUtils.isNull(goodsOrder)) {
            throw new ServiceException("订单编号对应的订单不存在");
        }
        // 验证司机是否存在
        Cars cars = carsService.selectCarsById(orderFreight.getDriverId());
        if (StringUtils.isNull(cars)) {
            throw new ServiceException("司机信息不存在");
        }

    }

    private void SyncToBankChange(OrderFreight orderFreight) {
        // 验证依赖的的银行卡是否存在
        BankAccount selfBank = bankAccountService.selectBankAccountByBankNo(orderFreight.getSelfBankNo());
        BankAccount driverBank = bankAccountService.selectBankAccountByBankNo(orderFreight.getOtherBankNo());
        if (StringUtils.isNull(selfBank) || StringUtils.isNull(driverBank)) {
            throw new ServiceException("银行卡信息不存在");
        }

        // 拼接变动信息
        BankAccountChange self = new BankAccountChange();
        self.setTableName(TableName.ORDER_FREIGHT.get());
        self.setMoneyAmount(Double.valueOf(orderFreight.getMoneyAmount()));
        self.setPayNO(String.valueOf(orderFreight.getId()));
        self.setChangeType(BankChangeConstant.PaymentType.PAYMENT.get());
        self.setSelfBankNo(orderFreight.getSelfBankNo());

        BankAccountChange driver = new BankAccountChange();
        driver.setTableName(TableName.ORDER_FREIGHT.get());
        driver.setMoneyAmount(Double.valueOf(orderFreight.getMoneyAmount()));
        driver.setPayNO(String.valueOf(orderFreight.getId()));
        driver.setChangeType(BankChangeConstant.PaymentType.RECEIPT.get());
        driver.setSelfBankNo(orderFreight.getOtherBankNo());


        // 去变动表里面搜索，如果搜索到就先删除后插入，搜索不到就是插入
        QueryWrapper<BankAccountChange> query = new QueryWrapper<BankAccountChange>().eq("payNO", orderFreight.getId()).eq("tableName", TableName.ORDER_FREIGHT.get());

        if (bankAccountChangeMapper.selectCount(query) > 0) {
            bankAccountChangeMapper.delete(query);
        }
        bankAccountChangeService.insertBankAccountChange(self);
        bankAccountChangeService.insertBankAccountChange(driver);

    }
}
